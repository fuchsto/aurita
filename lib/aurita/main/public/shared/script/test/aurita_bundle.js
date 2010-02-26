
///////////////////////////////////////////////////////
// BEGIN jscalendar/calendar
///////////////////////////////////////////////////////
/*  Copyright Mihai Bazon, 2002-2005  |  www.bazon.net/mishoo
 * -----------------------------------------------------------
 *
 * The DHTML Calendar, version 1.0 "It is happening again"
 *
 * Details and latest version at:
 * www.dynarch.com/projects/calendar
 *
 * This script is developed by Dynarch.com.  Visit us at www.dynarch.com.
 *
 * This script is distributed under the GNU Lesser General Public License.
 * Read the entire license text here: http://www.gnu.org/licenses/lgpl.html
 */

// $Id: calendar.js,v 1.51 2005/03/07 16:44:31 mishoo Exp $

/** The Calendar object constructor. */
Calendar = function (firstDayOfWeek, dateStr, onSelected, onClose) {
	// member variables
	this.activeDiv = null;
	this.currentDateEl = null;
	this.getDateStatus = null;
	this.getDateToolTip = null;
	this.getDateText = null;
	this.timeout = null;
	this.onSelected = onSelected || null;
	this.onClose = onClose || null;
	this.dragging = false;
	this.hidden = false;
	this.minYear = 1970;
	this.maxYear = 2050;
	this.dateFormat = Calendar._TT["DEF_DATE_FORMAT"];
	this.ttDateFormat = Calendar._TT["TT_DATE_FORMAT"];
	this.isPopup = true;
	this.weekNumbers = true;
	this.firstDayOfWeek = typeof firstDayOfWeek == "number" ? firstDayOfWeek : Calendar._FD; // 0 for Sunday, 1 for Monday, etc.
	this.showsOtherMonths = false;
	this.dateStr = dateStr;
	this.ar_days = null;
	this.showsTime = false;
	this.time24 = true;
	this.yearStep = 2;
	this.hiliteToday = true;
	this.multiple = null;
	// HTML elements
	this.table = null;
	this.element = null;
	this.tbody = null;
	this.firstdayname = null;
	// Combo boxes
	this.monthsCombo = null;
	this.yearsCombo = null;
	this.hilitedMonth = null;
	this.activeMonth = null;
	this.hilitedYear = null;
	this.activeYear = null;
	// Information
	this.dateClicked = false;

	// one-time initializations
	if (typeof Calendar._SDN == "undefined") {
		// table of short day names
		if (typeof Calendar._SDN_len == "undefined")
			Calendar._SDN_len = 3;
		var ar = new Array();
		for (var i = 8; i > 0;) {
			ar[--i] = Calendar._DN[i].substr(0, Calendar._SDN_len);
		}
		Calendar._SDN = ar;
		// table of short month names
		if (typeof Calendar._SMN_len == "undefined")
			Calendar._SMN_len = 3;
		ar = new Array();
		for (var i = 12; i > 0;) {
			ar[--i] = Calendar._MN[i].substr(0, Calendar._SMN_len);
		}
		Calendar._SMN = ar;
	}
};

// ** constants

/// "static", needed for event handlers.
Calendar._C = null;

/// detect a special case of "web browser"
Calendar.is_ie = ( /msie/i.test(navigator.userAgent) &&
		   !/opera/i.test(navigator.userAgent) );

Calendar.is_ie5 = ( Calendar.is_ie && /msie 5\.0/i.test(navigator.userAgent) );

/// detect Opera browser
Calendar.is_opera = /opera/i.test(navigator.userAgent);

/// detect KHTML-based browsers
Calendar.is_khtml = /Konqueror|Safari|KHTML/i.test(navigator.userAgent);

// BEGIN: UTILITY FUNCTIONS; beware that these might be moved into a separate
//        library, at some point.

Calendar.getAbsolutePos = function(el) {
	var SL = 0, ST = 0;
	var is_div = /^div$/i.test(el.tagName);
	if (is_div && el.scrollLeft)
		SL = el.scrollLeft;
	if (is_div && el.scrollTop)
		ST = el.scrollTop;
	var r = { x: el.offsetLeft - SL, y: el.offsetTop - ST };
	if (el.offsetParent) {
		var tmp = this.getAbsolutePos(el.offsetParent);
		r.x += tmp.x;
		r.y += tmp.y;
	}
	return r;
};

Calendar.isRelated = function (el, evt) {
	var related = evt.relatedTarget;
	if (!related) {
		var type = evt.type;
		if (type == "mouseover") {
			related = evt.fromElement;
		} else if (type == "mouseout") {
			related = evt.toElement;
		}
	}
	while (related) {
		if (related == el) {
			return true;
		}
		related = related.parentNode;
	}
	return false;
};

Calendar.removeClass = function(el, className) {
	if (!(el && el.className)) {
		return;
	}
	var cls = el.className.split(" ");
	var ar = new Array();
	for (var i = cls.length; i > 0;) {
		if (cls[--i] != className) {
			ar[ar.length] = cls[i];
		}
	}
	el.className = ar.join(" ");
};

Calendar.addClass = function(el, className) {
	Calendar.removeClass(el, className);
	el.className += " " + className;
};

// FIXME: the following 2 functions totally suck, are useless and should be replaced immediately.
Calendar.getElement = function(ev) {
	var f = Calendar.is_ie ? window.event.srcElement : ev.currentTarget;
	while (f.nodeType != 1 || /^div$/i.test(f.tagName))
		f = f.parentNode;
	return f;
};

Calendar.getTargetElement = function(ev) {
	var f = Calendar.is_ie ? window.event.srcElement : ev.target;
	while (f.nodeType != 1)
		f = f.parentNode;
	return f;
};

Calendar.stopEvent = function(ev) {
	ev || (ev = window.event);
	if (Calendar.is_ie) {
		ev.cancelBubble = true;
		ev.returnValue = false;
	} else {
		ev.preventDefault();
		ev.stopPropagation();
	}
	return false;
};

Calendar.addEvent = function(el, evname, func) {
	if (el.attachEvent) { // IE
		el.attachEvent("on" + evname, func);
	} else if (el.addEventListener) { // Gecko / W3C
		el.addEventListener(evname, func, true);
	} else {
		el["on" + evname] = func;
	}
};

Calendar.removeEvent = function(el, evname, func) {
	if (el.detachEvent) { // IE
		el.detachEvent("on" + evname, func);
	} else if (el.removeEventListener) { // Gecko / W3C
		el.removeEventListener(evname, func, true);
	} else {
		el["on" + evname] = null;
	}
};

Calendar.createElement = function(type, parent) {
	var el = null;
	if (document.createElementNS) {
		// use the XHTML namespace; IE won't normally get here unless
		// _they_ "fix" the DOM2 implementation.
		el = document.createElementNS("http://www.w3.org/1999/xhtml", type);
	} else {
		el = document.createElement(type);
	}
	if (typeof parent != "undefined") {
		parent.appendChild(el);
	}
	return el;
};

// END: UTILITY FUNCTIONS

// BEGIN: CALENDAR STATIC FUNCTIONS

/** Internal -- adds a set of events to make some element behave like a button. */
Calendar._add_evs = function(el) {
	with (Calendar) {
		addEvent(el, "mouseover", dayMouseOver);
		addEvent(el, "mousedown", dayMouseDown);
		addEvent(el, "mouseout", dayMouseOut);
		if (is_ie) {
			addEvent(el, "dblclick", dayMouseDblClick);
			el.setAttribute("unselectable", true);
		}
	}
};

Calendar.findMonth = function(el) {
	if (typeof el.month != "undefined") {
		return el;
	} else if (typeof el.parentNode.month != "undefined") {
		return el.parentNode;
	}
	return null;
};

Calendar.findYear = function(el) {
	if (typeof el.year != "undefined") {
		return el;
	} else if (typeof el.parentNode.year != "undefined") {
		return el.parentNode;
	}
	return null;
};

Calendar.showMonthsCombo = function () {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	var cal = cal;
	var cd = cal.activeDiv;
	var mc = cal.monthsCombo;
	if (cal.hilitedMonth) {
		Calendar.removeClass(cal.hilitedMonth, "hilite");
	}
	if (cal.activeMonth) {
		Calendar.removeClass(cal.activeMonth, "active");
	}
	var mon = cal.monthsCombo.getElementsByTagName("div")[cal.date.getMonth()];
	Calendar.addClass(mon, "active");
	cal.activeMonth = mon;
	var s = mc.style;
	s.display = "block";
	if (cd.navtype < 0)
		s.left = cd.offsetLeft + "px";
	else {
		var mcw = mc.offsetWidth;
		if (typeof mcw == "undefined")
			// Konqueror brain-dead techniques
			mcw = 50;
		s.left = (cd.offsetLeft + cd.offsetWidth - mcw) + "px";
	}
	s.top = (cd.offsetTop + cd.offsetHeight) + "px";
};

Calendar.showYearsCombo = function (fwd) {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	var cal = cal;
	var cd = cal.activeDiv;
	var yc = cal.yearsCombo;
	if (cal.hilitedYear) {
		Calendar.removeClass(cal.hilitedYear, "hilite");
	}
	if (cal.activeYear) {
		Calendar.removeClass(cal.activeYear, "active");
	}
	cal.activeYear = null;
	var Y = cal.date.getFullYear() + (fwd ? 1 : -1);
	var yr = yc.firstChild;
	var show = false;
	for (var i = 12; i > 0; --i) {
		if (Y >= cal.minYear && Y <= cal.maxYear) {
			yr.innerHTML = Y;
			yr.year = Y;
			yr.style.display = "block";
			show = true;
		} else {
			yr.style.display = "none";
		}
		yr = yr.nextSibling;
		Y += fwd ? cal.yearStep : -cal.yearStep;
	}
	if (show) {
		var s = yc.style;
		s.display = "block";
		if (cd.navtype < 0)
			s.left = cd.offsetLeft + "px";
		else {
			var ycw = yc.offsetWidth;
			if (typeof ycw == "undefined")
				// Konqueror brain-dead techniques
				ycw = 50;
			s.left = (cd.offsetLeft + cd.offsetWidth - ycw) + "px";
		}
		s.top = (cd.offsetTop + cd.offsetHeight) + "px";
	}
};

// event handlers

Calendar.tableMouseUp = function(ev) {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	if (cal.timeout) {
		clearTimeout(cal.timeout);
	}
	var el = cal.activeDiv;
	if (!el) {
		return false;
	}
	var target = Calendar.getTargetElement(ev);
	ev || (ev = window.event);
	Calendar.removeClass(el, "active");
	if (target == el || target.parentNode == el) {
		Calendar.cellClick(el, ev);
	}
	var mon = Calendar.findMonth(target);
	var date = null;
	if (mon) {
		date = new Date(cal.date);
		if (mon.month != date.getMonth()) {
			date.setMonth(mon.month);
			cal.setDate(date);
			cal.dateClicked = false;
			cal.callHandler();
		}
	} else {
		var year = Calendar.findYear(target);
		if (year) {
			date = new Date(cal.date);
			if (year.year != date.getFullYear()) {
				date.setFullYear(year.year);
				cal.setDate(date);
				cal.dateClicked = false;
				cal.callHandler();
			}
		}
	}
	with (Calendar) {
		removeEvent(document, "mouseup", tableMouseUp);
		removeEvent(document, "mouseover", tableMouseOver);
		removeEvent(document, "mousemove", tableMouseOver);
		cal._hideCombos();
		_C = null;
		return stopEvent(ev);
	}
};

Calendar.tableMouseOver = function (ev) {
	var cal = Calendar._C;
	if (!cal) {
		return;
	}
	var el = cal.activeDiv;
	var target = Calendar.getTargetElement(ev);
	if (target == el || target.parentNode == el) {
		Calendar.addClass(el, "hilite active");
		Calendar.addClass(el.parentNode, "rowhilite");
	} else {
		if (typeof el.navtype == "undefined" || (el.navtype != 50 && (el.navtype == 0 || Math.abs(el.navtype) > 2)))
			Calendar.removeClass(el, "active");
		Calendar.removeClass(el, "hilite");
		Calendar.removeClass(el.parentNode, "rowhilite");
	}
	ev || (ev = window.event);
	if (el.navtype == 50 && target != el) {
		var pos = Calendar.getAbsolutePos(el);
		var w = el.offsetWidth;
		var x = ev.clientX;
		var dx;
		var decrease = true;
		if (x > pos.x + w) {
			dx = x - pos.x - w;
			decrease = false;
		} else
			dx = pos.x - x;

		if (dx < 0) dx = 0;
		var range = el._range;
		var current = el._current;
		var count = Math.floor(dx / 10) % range.length;
		for (var i = range.length; --i >= 0;)
			if (range[i] == current)
				break;
		while (count-- > 0)
			if (decrease) {
				if (--i < 0)
					i = range.length - 1;
			} else if ( ++i >= range.length )
				i = 0;
		var newval = range[i];
		el.innerHTML = newval;

		cal.onUpdateTime();
	}
	var mon = Calendar.findMonth(target);
	if (mon) {
		if (mon.month != cal.date.getMonth()) {
			if (cal.hilitedMonth) {
				Calendar.removeClass(cal.hilitedMonth, "hilite");
			}
			Calendar.addClass(mon, "hilite");
			cal.hilitedMonth = mon;
		} else if (cal.hilitedMonth) {
			Calendar.removeClass(cal.hilitedMonth, "hilite");
		}
	} else {
		if (cal.hilitedMonth) {
			Calendar.removeClass(cal.hilitedMonth, "hilite");
		}
		var year = Calendar.findYear(target);
		if (year) {
			if (year.year != cal.date.getFullYear()) {
				if (cal.hilitedYear) {
					Calendar.removeClass(cal.hilitedYear, "hilite");
				}
				Calendar.addClass(year, "hilite");
				cal.hilitedYear = year;
			} else if (cal.hilitedYear) {
				Calendar.removeClass(cal.hilitedYear, "hilite");
			}
		} else if (cal.hilitedYear) {
			Calendar.removeClass(cal.hilitedYear, "hilite");
		}
	}
	return Calendar.stopEvent(ev);
};

Calendar.tableMouseDown = function (ev) {
	if (Calendar.getTargetElement(ev) == Calendar.getElement(ev)) {
		return Calendar.stopEvent(ev);
	}
};

Calendar.calDragIt = function (ev) {
	var cal = Calendar._C;
	if (!(cal && cal.dragging)) {
		return false;
	}
	var posX;
	var posY;
	if (Calendar.is_ie) {
		posY = window.event.clientY + document.body.scrollTop;
		posX = window.event.clientX + document.body.scrollLeft;
	} else {
		posX = ev.pageX;
		posY = ev.pageY;
	}
	cal.hideShowCovered();
	var st = cal.element.style;
	st.left = (posX - cal.xOffs) + "px";
	st.top = (posY - cal.yOffs) + "px";
	return Calendar.stopEvent(ev);
};

Calendar.calDragEnd = function (ev) {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	cal.dragging = false;
	with (Calendar) {
		removeEvent(document, "mousemove", calDragIt);
		removeEvent(document, "mouseup", calDragEnd);
		tableMouseUp(ev);
	}
	cal.hideShowCovered();
};

Calendar.dayMouseDown = function(ev) {
	var el = Calendar.getElement(ev);
	if (el.disabled) {
		return false;
	}
	var cal = el.calendar;
	cal.activeDiv = el;
	Calendar._C = cal;
	if (el.navtype != 300) with (Calendar) {
		if (el.navtype == 50) {
			el._current = el.innerHTML;
			addEvent(document, "mousemove", tableMouseOver);
		} else
			addEvent(document, Calendar.is_ie5 ? "mousemove" : "mouseover", tableMouseOver);
		addClass(el, "hilite active");
		addEvent(document, "mouseup", tableMouseUp);
	} else if (cal.isPopup) {
		cal._dragStart(ev);
	}
	if (el.navtype == -1 || el.navtype == 1) {
		if (cal.timeout) clearTimeout(cal.timeout);
		cal.timeout = setTimeout("Calendar.showMonthsCombo()", 250);
	} else if (el.navtype == -2 || el.navtype == 2) {
		if (cal.timeout) clearTimeout(cal.timeout);
		cal.timeout = setTimeout((el.navtype > 0) ? "Calendar.showYearsCombo(true)" : "Calendar.showYearsCombo(false)", 250);
	} else {
		cal.timeout = null;
	}
	return Calendar.stopEvent(ev);
};

Calendar.dayMouseDblClick = function(ev) {
	Calendar.cellClick(Calendar.getElement(ev), ev || window.event);
	if (Calendar.is_ie) {
		document.selection.empty();
	}
};

Calendar.dayMouseOver = function(ev) {
	var el = Calendar.getElement(ev);
	if (Calendar.isRelated(el, ev) || Calendar._C || el.disabled) {
		return false;
	}
	if (el.ttip) {
		if (el.ttip.substr(0, 1) == "_") {
			el.ttip = el.caldate.print(el.calendar.ttDateFormat) + el.ttip.substr(1);
		}
		el.calendar.tooltips.innerHTML = el.ttip;
	}
	if (el.navtype != 300) {
		Calendar.addClass(el, "hilite");
		if (el.caldate) {
			Calendar.addClass(el.parentNode, "rowhilite");
		}
	}
	return Calendar.stopEvent(ev);
};

Calendar.dayMouseOut = function(ev) {
	with (Calendar) {
		var el = getElement(ev);
		if (isRelated(el, ev) || _C || el.disabled)
			return false;
		removeClass(el, "hilite");
		if (el.caldate)
			removeClass(el.parentNode, "rowhilite");
		if (el.calendar)
			el.calendar.tooltips.innerHTML = _TT["SEL_DATE"];
		return stopEvent(ev);
	}
};

/**
 *  A generic "click" handler :) handles all types of buttons defined in this
 *  calendar.
 */
Calendar.cellClick = function(el, ev) {
	var cal = el.calendar;
	var closing = false;
	var newdate = false;
	var date = null;
	if (typeof el.navtype == "undefined") {
		if (cal.currentDateEl) {
			Calendar.removeClass(cal.currentDateEl, "selected");
			Calendar.addClass(el, "selected");
			closing = (cal.currentDateEl == el);
			if (!closing) {
				cal.currentDateEl = el;
			}
		}
		cal.date.setDateOnly(el.caldate);
		date = cal.date;
		var other_month = !(cal.dateClicked = !el.otherMonth);
		if (!other_month && !cal.currentDateEl)
			cal._toggleMultipleDate(new Date(date));
		else
			newdate = !el.disabled;
		// a date was clicked
		if (other_month)
			cal._init(cal.firstDayOfWeek, date);
	} else {
		if (el.navtype == 200) {
			Calendar.removeClass(el, "hilite");
			cal.callCloseHandler();
			return;
		}
		date = new Date(cal.date);
		if (el.navtype == 0)
			date.setDateOnly(new Date()); // TODAY
		// unless "today" was clicked, we assume no date was clicked so
		// the selected handler will know not to close the calenar when
		// in single-click mode.
		// cal.dateClicked = (el.navtype == 0);
		cal.dateClicked = false;
		var year = date.getFullYear();
		var mon = date.getMonth();
		function setMonth(m) {
			var day = date.getDate();
			var max = date.getMonthDays(m);
			if (day > max) {
				date.setDate(max);
			}
			date.setMonth(m);
		};
		switch (el.navtype) {
		    case 400:
			Calendar.removeClass(el, "hilite");
			var text = Calendar._TT["ABOUT"];
			if (typeof text != "undefined") {
				text += cal.showsTime ? Calendar._TT["ABOUT_TIME"] : "";
			} else {
				// FIXME: this should be removed as soon as lang files get updated!
				text = "Help and about box text is not translated into this language.\n" +
					"If you know this language and you feel generous please update\n" +
					"the corresponding file in \"lang\" subdir to match calendar-en.js\n" +
					"and send it back to <mihai_bazon@yahoo.com> to get it into the distribution  ;-)\n\n" +
					"Thank you!\n" +
					"http://dynarch.com/mishoo/calendar.epl\n";
			}
			alert(text);
			return;
		    case -2:
			if (year > cal.minYear) {
				date.setFullYear(year - 1);
			}
			break;
		    case -1:
			if (mon > 0) {
				setMonth(mon - 1);
			} else if (year-- > cal.minYear) {
				date.setFullYear(year);
				setMonth(11);
			}
			break;
		    case 1:
			if (mon < 11) {
				setMonth(mon + 1);
			} else if (year < cal.maxYear) {
				date.setFullYear(year + 1);
				setMonth(0);
			}
			break;
		    case 2:
			if (year < cal.maxYear) {
				date.setFullYear(year + 1);
			}
			break;
		    case 100:
			cal.setFirstDayOfWeek(el.fdow);
			return;
		    case 50:
			var range = el._range;
			var current = el.innerHTML;
			for (var i = range.length; --i >= 0;)
				if (range[i] == current)
					break;
			if (ev && ev.shiftKey) {
				if (--i < 0)
					i = range.length - 1;
			} else if ( ++i >= range.length )
				i = 0;
			var newval = range[i];
			el.innerHTML = newval;
			cal.onUpdateTime();
			return;
		    case 0:
			// TODAY will bring us here
			if ((typeof cal.getDateStatus == "function") &&
			    cal.getDateStatus(date, date.getFullYear(), date.getMonth(), date.getDate())) {
				return false;
			}
			break;
		}
		if (!date.equalsTo(cal.date)) {
			cal.setDate(date);
			newdate = true;
		} else if (el.navtype == 0)
			newdate = closing = true;
	}
	if (newdate) {
		ev && cal.callHandler();
	}
	if (closing) {
		Calendar.removeClass(el, "hilite");
		ev && cal.callCloseHandler();
	}
};

// END: CALENDAR STATIC FUNCTIONS

// BEGIN: CALENDAR OBJECT FUNCTIONS

/**
 *  This function creates the calendar inside the given parent.  If _par is
 *  null than it creates a popup calendar inside the BODY element.  If _par is
 *  an element, be it BODY, then it creates a non-popup calendar (still
 *  hidden).  Some properties need to be set before calling this function.
 */
Calendar.prototype.create = function (_par) {
	var parent = null;
	if (! _par) {
		// default parent is the document body, in which case we create
		// a popup calendar.
		parent = document.getElementsByTagName("body")[0];
		this.isPopup = true;
	} else {
		parent = _par;
		this.isPopup = false;
	}
	this.date = this.dateStr ? new Date(this.dateStr) : new Date();

	var table = Calendar.createElement("table");
	this.table = table;
	table.cellSpacing = 0;
	table.cellPadding = 0;
	table.calendar = this;
	Calendar.addEvent(table, "mousedown", Calendar.tableMouseDown);

	var div = Calendar.createElement("div");
	this.element = div;
	div.className = "calendar";
	if (this.isPopup) {
		div.style.position = "absolute";
		div.style.display = "none";
	}
	div.appendChild(table);

	var thead = Calendar.createElement("thead", table);
	var cell = null;
	var row = null;

	var cal = this;
	var hh = function (text, cs, navtype) {
		cell = Calendar.createElement("td", row);
		cell.colSpan = cs;
		cell.className = "button";
		if (navtype != 0 && Math.abs(navtype) <= 2)
			cell.className += " nav";
		Calendar._add_evs(cell);
		cell.calendar = cal;
		cell.navtype = navtype;
		cell.innerHTML = "<div unselectable='on'>" + text + "</div>";
		return cell;
	};

	row = Calendar.createElement("tr", thead);
	var title_length = 6;
	(this.isPopup) && --title_length;
	(this.weekNumbers) && ++title_length;

	hh("?", 1, 400).ttip = Calendar._TT["INFO"];
	this.title = hh("", title_length, 300);
	this.title.className = "title";
	if (this.isPopup) {
		this.title.ttip = Calendar._TT["DRAG_TO_MOVE"];
		this.title.style.cursor = "move";
		hh("&#x00d7;", 1, 200).ttip = Calendar._TT["CLOSE"];
	}

	row = Calendar.createElement("tr", thead);
	row.className = "headrow";

	this._nav_py = hh("&#x00ab;", 1, -2);
	this._nav_py.ttip = Calendar._TT["PREV_YEAR"];

	this._nav_pm = hh("&#x2039;", 1, -1);
	this._nav_pm.ttip = Calendar._TT["PREV_MONTH"];

	this._nav_now = hh(Calendar._TT["TODAY"], this.weekNumbers ? 4 : 3, 0);
	this._nav_now.ttip = Calendar._TT["GO_TODAY"];

	this._nav_nm = hh("&#x203a;", 1, 1);
	this._nav_nm.ttip = Calendar._TT["NEXT_MONTH"];

	this._nav_ny = hh("&#x00bb;", 1, 2);
	this._nav_ny.ttip = Calendar._TT["NEXT_YEAR"];

	// day names
	row = Calendar.createElement("tr", thead);
	row.className = "daynames";
	if (this.weekNumbers) {
		cell = Calendar.createElement("td", row);
		cell.className = "name wn";
		cell.innerHTML = Calendar._TT["WK"];
	}
	for (var i = 7; i > 0; --i) {
		cell = Calendar.createElement("td", row);
		if (!i) {
			cell.navtype = 100;
			cell.calendar = this;
			Calendar._add_evs(cell);
		}
	}
	this.firstdayname = (this.weekNumbers) ? row.firstChild.nextSibling : row.firstChild;
	this._displayWeekdays();

	var tbody = Calendar.createElement("tbody", table);
	this.tbody = tbody;

	for (i = 6; i > 0; --i) {
		row = Calendar.createElement("tr", tbody);
		if (this.weekNumbers) {
			cell = Calendar.createElement("td", row);
		}
		for (var j = 7; j > 0; --j) {
			cell = Calendar.createElement("td", row);
			cell.calendar = this;
			Calendar._add_evs(cell);
		}
	}

	if (this.showsTime) {
		row = Calendar.createElement("tr", tbody);
		row.className = "time";

		cell = Calendar.createElement("td", row);
		cell.className = "time";
		cell.colSpan = 2;
		cell.innerHTML = Calendar._TT["TIME"] || "&nbsp;";

		cell = Calendar.createElement("td", row);
		cell.className = "time";
		cell.colSpan = this.weekNumbers ? 4 : 3;

		(function(){
			function makeTimePart(className, init, range_start, range_end) {
				var part = Calendar.createElement("span", cell);
				part.className = className;
				part.innerHTML = init;
				part.calendar = cal;
				part.ttip = Calendar._TT["TIME_PART"];
				part.navtype = 50;
				part._range = [];
				if (typeof range_start != "number")
					part._range = range_start;
				else {
					for (var i = range_start; i <= range_end; ++i) {
						var txt;
						if (i < 10 && range_end >= 10) txt = '0' + i;
						else txt = '' + i;
						part._range[part._range.length] = txt;
					}
				}
				Calendar._add_evs(part);
				return part;
			};
			var hrs = cal.date.getHours();
			var mins = cal.date.getMinutes();
			var t12 = !cal.time24;
			var pm = (hrs > 12);
			if (t12 && pm) hrs -= 12;
			var H = makeTimePart("hour", hrs, t12 ? 1 : 0, t12 ? 12 : 23);
			var span = Calendar.createElement("span", cell);
			span.innerHTML = ":";
			span.className = "colon";
			var M = makeTimePart("minute", mins, 0, 59);
			var AP = null;
			cell = Calendar.createElement("td", row);
			cell.className = "time";
			cell.colSpan = 2;
			if (t12)
				AP = makeTimePart("ampm", pm ? "pm" : "am", ["am", "pm"]);
			else
				cell.innerHTML = "&nbsp;";

			cal.onSetTime = function() {
				var pm, hrs = this.date.getHours(),
					mins = this.date.getMinutes();
				if (t12) {
					pm = (hrs >= 12);
					if (pm) hrs -= 12;
					if (hrs == 0) hrs = 12;
					AP.innerHTML = pm ? "pm" : "am";
				}
				H.innerHTML = (hrs < 10) ? ("0" + hrs) : hrs;
				M.innerHTML = (mins < 10) ? ("0" + mins) : mins;
			};

			cal.onUpdateTime = function() {
				var date = this.date;
				var h = parseInt(H.innerHTML, 10);
				if (t12) {
					if (/pm/i.test(AP.innerHTML) && h < 12)
						h += 12;
					else if (/am/i.test(AP.innerHTML) && h == 12)
						h = 0;
				}
				var d = date.getDate();
				var m = date.getMonth();
				var y = date.getFullYear();
				date.setHours(h);
				date.setMinutes(parseInt(M.innerHTML, 10));
				date.setFullYear(y);
				date.setMonth(m);
				date.setDate(d);
				this.dateClicked = false;
				this.callHandler();
			};
		})();
	} else {
		this.onSetTime = this.onUpdateTime = function() {};
	}

	var tfoot = Calendar.createElement("tfoot", table);

	row = Calendar.createElement("tr", tfoot);
	row.className = "footrow";

	cell = hh(Calendar._TT["SEL_DATE"], this.weekNumbers ? 8 : 7, 300);
	cell.className = "ttip";
	if (this.isPopup) {
		cell.ttip = Calendar._TT["DRAG_TO_MOVE"];
		cell.style.cursor = "move";
	}
	this.tooltips = cell;

	div = Calendar.createElement("div", this.element);
	this.monthsCombo = div;
	div.className = "combo";
	for (i = 0; i < Calendar._MN.length; ++i) {
		var mn = Calendar.createElement("div");
		mn.className = Calendar.is_ie ? "label-IEfix" : "label";
		mn.month = i;
		mn.innerHTML = Calendar._SMN[i];
		div.appendChild(mn);
	}

	div = Calendar.createElement("div", this.element);
	this.yearsCombo = div;
	div.className = "combo";
	for (i = 12; i > 0; --i) {
		var yr = Calendar.createElement("div");
		yr.className = Calendar.is_ie ? "label-IEfix" : "label";
		div.appendChild(yr);
	}

	this._init(this.firstDayOfWeek, this.date);
	parent.appendChild(this.element);
};

/** keyboard navigation, only for popup calendars */
Calendar._keyEvent = function(ev) {
	var cal = window._dynarch_popupCalendar;
	if (!cal || cal.multiple)
		return false;
	(Calendar.is_ie) && (ev = window.event);
	var act = (Calendar.is_ie || ev.type == "keypress"),
		K = ev.keyCode;
	if (ev.ctrlKey) {
		switch (K) {
		    case 37: // KEY left
			act && Calendar.cellClick(cal._nav_pm);
			break;
		    case 38: // KEY up
			act && Calendar.cellClick(cal._nav_py);
			break;
		    case 39: // KEY right
			act && Calendar.cellClick(cal._nav_nm);
			break;
		    case 40: // KEY down
			act && Calendar.cellClick(cal._nav_ny);
			break;
		    default:
			return false;
		}
	} else switch (K) {
	    case 32: // KEY space (now)
		Calendar.cellClick(cal._nav_now);
		break;
	    case 27: // KEY esc
		act && cal.callCloseHandler();
		break;
	    case 37: // KEY left
	    case 38: // KEY up
	    case 39: // KEY right
	    case 40: // KEY down
		if (act) {
			var prev, x, y, ne, el, step;
			prev = K == 37 || K == 38;
			step = (K == 37 || K == 39) ? 1 : 7;
			function setVars() {
				el = cal.currentDateEl;
				var p = el.pos;
				x = p & 15;
				y = p >> 4;
				ne = cal.ar_days[y][x];
			};setVars();
			function prevMonth() {
				var date = new Date(cal.date);
				date.setDate(date.getDate() - step);
				cal.setDate(date);
			};
			function nextMonth() {
				var date = new Date(cal.date);
				date.setDate(date.getDate() + step);
				cal.setDate(date);
			};
			while (1) {
				switch (K) {
				    case 37: // KEY left
					if (--x >= 0)
						ne = cal.ar_days[y][x];
					else {
						x = 6;
						K = 38;
						continue;
					}
					break;
				    case 38: // KEY up
					if (--y >= 0)
						ne = cal.ar_days[y][x];
					else {
						prevMonth();
						setVars();
					}
					break;
				    case 39: // KEY right
					if (++x < 7)
						ne = cal.ar_days[y][x];
					else {
						x = 0;
						K = 40;
						continue;
					}
					break;
				    case 40: // KEY down
					if (++y < cal.ar_days.length)
						ne = cal.ar_days[y][x];
					else {
						nextMonth();
						setVars();
					}
					break;
				}
				break;
			}
			if (ne) {
				if (!ne.disabled)
					Calendar.cellClick(ne);
				else if (prev)
					prevMonth();
				else
					nextMonth();
			}
		}
		break;
	    case 13: // KEY enter
		if (act)
			Calendar.cellClick(cal.currentDateEl, ev);
		break;
	    default:
		return false;
	}
	return Calendar.stopEvent(ev);
};

/**
 *  (RE)Initializes the calendar to the given date and firstDayOfWeek
 */
Calendar.prototype._init = function (firstDayOfWeek, date) {
	var today = new Date(),
		TY = today.getFullYear(),
		TM = today.getMonth(),
		TD = today.getDate();
	this.table.style.visibility = "hidden";
	var year = date.getFullYear();
	if (year < this.minYear) {
		year = this.minYear;
		date.setFullYear(year);
	} else if (year > this.maxYear) {
		year = this.maxYear;
		date.setFullYear(year);
	}
	this.firstDayOfWeek = firstDayOfWeek;
	this.date = new Date(date);
	var month = date.getMonth();
	var mday = date.getDate();
	var no_days = date.getMonthDays();

	// calendar voodoo for computing the first day that would actually be
	// displayed in the calendar, even if it's from the previous month.
	// WARNING: this is magic. ;-)
	date.setDate(1);
	var day1 = (date.getDay() - this.firstDayOfWeek) % 7;
	if (day1 < 0)
		day1 += 7;
	date.setDate(-day1);
	date.setDate(date.getDate() + 1);

	var row = this.tbody.firstChild;
	var MN = Calendar._SMN[month];
	var ar_days = this.ar_days = new Array();
	var weekend = Calendar._TT["WEEKEND"];
	var dates = this.multiple ? (this.datesCells = {}) : null;
	for (var i = 0; i < 6; ++i, row = row.nextSibling) {
		var cell = row.firstChild;
		if (this.weekNumbers) {
			cell.className = "day wn";
			cell.innerHTML = date.getWeekNumber();
			cell = cell.nextSibling;
		}
		row.className = "daysrow";
		var hasdays = false, iday, dpos = ar_days[i] = [];
		for (var j = 0; j < 7; ++j, cell = cell.nextSibling, date.setDate(iday + 1)) {
			iday = date.getDate();
			var wday = date.getDay();
			cell.className = "day";
			cell.pos = i << 4 | j;
			dpos[j] = cell;
			var current_month = (date.getMonth() == month);
			if (!current_month) {
				if (this.showsOtherMonths) {
					cell.className += " othermonth";
					cell.otherMonth = true;
				} else {
					cell.className = "emptycell";
					cell.innerHTML = "&nbsp;";
					cell.disabled = true;
					continue;
				}
			} else {
				cell.otherMonth = false;
				hasdays = true;
			}
			cell.disabled = false;
			cell.innerHTML = this.getDateText ? this.getDateText(date, iday) : iday;
			if (dates)
				dates[date.print("%Y%m%d")] = cell;
			if (this.getDateStatus) {
				var status = this.getDateStatus(date, year, month, iday);
				if (this.getDateToolTip) {
					var toolTip = this.getDateToolTip(date, year, month, iday);
					if (toolTip)
						cell.title = toolTip;
				}
				if (status === true) {
					cell.className += " disabled";
					cell.disabled = true;
				} else {
					if (/disabled/i.test(status))
						cell.disabled = true;
					cell.className += " " + status;
				}
			}
			if (!cell.disabled) {
				cell.caldate = new Date(date);
				cell.ttip = "_";
				if (!this.multiple && current_month
				    && iday == mday && this.hiliteToday) {
					cell.className += " selected";
					this.currentDateEl = cell;
				}
				if (date.getFullYear() == TY &&
				    date.getMonth() == TM &&
				    iday == TD) {
					cell.className += " today";
					cell.ttip += Calendar._TT["PART_TODAY"];
				}
				if (weekend.indexOf(wday.toString()) != -1)
					cell.className += cell.otherMonth ? " oweekend" : " weekend";
			}
		}
		if (!(hasdays || this.showsOtherMonths))
			row.className = "emptyrow";
	}
	this.title.innerHTML = Calendar._MN[month] + ", " + year;
	this.onSetTime();
	this.table.style.visibility = "visible";
	this._initMultipleDates();
	// PROFILE
	// this.tooltips.innerHTML = "Generated in " + ((new Date()) - today) + " ms";
};

Calendar.prototype._initMultipleDates = function() {
	if (this.multiple) {
		for (var i in this.multiple) {
			var cell = this.datesCells[i];
			var d = this.multiple[i];
			if (!d)
				continue;
			if (cell)
				cell.className += " selected";
		}
	}
};

Calendar.prototype._toggleMultipleDate = function(date) {
	if (this.multiple) {
		var ds = date.print("%Y%m%d");
		var cell = this.datesCells[ds];
		if (cell) {
			var d = this.multiple[ds];
			if (!d) {
				Calendar.addClass(cell, "selected");
				this.multiple[ds] = date;
			} else {
				Calendar.removeClass(cell, "selected");
				delete this.multiple[ds];
			}
		}
	}
};

Calendar.prototype.setDateToolTipHandler = function (unaryFunction) {
	this.getDateToolTip = unaryFunction;
};

/**
 *  Calls _init function above for going to a certain date (but only if the
 *  date is different than the currently selected one).
 */
Calendar.prototype.setDate = function (date) {
	if (!date.equalsTo(this.date)) {
		this._init(this.firstDayOfWeek, date);
	}
};

/**
 *  Refreshes the calendar.  Useful if the "disabledHandler" function is
 *  dynamic, meaning that the list of disabled date can change at runtime.
 *  Just * call this function if you think that the list of disabled dates
 *  should * change.
 */
Calendar.prototype.refresh = function () {
	this._init(this.firstDayOfWeek, this.date);
};

/** Modifies the "firstDayOfWeek" parameter (pass 0 for Synday, 1 for Monday, etc.). */
Calendar.prototype.setFirstDayOfWeek = function (firstDayOfWeek) {
	this._init(firstDayOfWeek, this.date);
	this._displayWeekdays();
};

/**
 *  Allows customization of what dates are enabled.  The "unaryFunction"
 *  parameter must be a function object that receives the date (as a JS Date
 *  object) and returns a boolean value.  If the returned value is true then
 *  the passed date will be marked as disabled.
 */
Calendar.prototype.setDateStatusHandler = Calendar.prototype.setDisabledHandler = function (unaryFunction) {
	this.getDateStatus = unaryFunction;
};

/** Customization of allowed year range for the calendar. */
Calendar.prototype.setRange = function (a, z) {
	this.minYear = a;
	this.maxYear = z;
};

/** Calls the first user handler (selectedHandler). */
Calendar.prototype.callHandler = function () {
	if (this.onSelected) {
		this.onSelected(this, this.date.print(this.dateFormat));
	}
};

/** Calls the second user handler (closeHandler). */
Calendar.prototype.callCloseHandler = function () {
	if (this.onClose) {
		this.onClose(this);
	}
	this.hideShowCovered();
};

/** Removes the calendar object from the DOM tree and destroys it. */
Calendar.prototype.destroy = function () {
	var el = this.element.parentNode;
	el.removeChild(this.element);
	Calendar._C = null;
	window._dynarch_popupCalendar = null;
};

/**
 *  Moves the calendar element to a different section in the DOM tree (changes
 *  its parent).
 */
Calendar.prototype.reparent = function (new_parent) {
	var el = this.element;
	el.parentNode.removeChild(el);
	new_parent.appendChild(el);
};

// This gets called when the user presses a mouse button anywhere in the
// document, if the calendar is shown.  If the click was outside the open
// calendar this function closes it.
Calendar._checkCalendar = function(ev) {
	var calendar = window._dynarch_popupCalendar;
	if (!calendar) {
		return false;
	}
	var el = Calendar.is_ie ? Calendar.getElement(ev) : Calendar.getTargetElement(ev);
	for (; el != null && el != calendar.element; el = el.parentNode);
	if (el == null) {
		// calls closeHandler which should hide the calendar.
		window._dynarch_popupCalendar.callCloseHandler();
		return Calendar.stopEvent(ev);
	}
};

/** Shows the calendar. */
Calendar.prototype.show = function () {
	var rows = this.table.getElementsByTagName("tr");
	for (var i = rows.length; i > 0;) {
		var row = rows[--i];
		Calendar.removeClass(row, "rowhilite");
		var cells = row.getElementsByTagName("td");
		for (var j = cells.length; j > 0;) {
			var cell = cells[--j];
			Calendar.removeClass(cell, "hilite");
			Calendar.removeClass(cell, "active");
		}
	}
	this.element.style.display = "block";
	this.hidden = false;
	if (this.isPopup) {
		window._dynarch_popupCalendar = this;
		Calendar.addEvent(document, "keydown", Calendar._keyEvent);
		Calendar.addEvent(document, "keypress", Calendar._keyEvent);
		Calendar.addEvent(document, "mousedown", Calendar._checkCalendar);
	}
	this.hideShowCovered();
};

/**
 *  Hides the calendar.  Also removes any "hilite" from the class of any TD
 *  element.
 */
Calendar.prototype.hide = function () {
	if (this.isPopup) {
		Calendar.removeEvent(document, "keydown", Calendar._keyEvent);
		Calendar.removeEvent(document, "keypress", Calendar._keyEvent);
		Calendar.removeEvent(document, "mousedown", Calendar._checkCalendar);
	}
	this.element.style.display = "none";
	this.hidden = true;
	this.hideShowCovered();
};

/**
 *  Shows the calendar at a given absolute position (beware that, depending on
 *  the calendar element style -- position property -- this might be relative
 *  to the parent's containing rectangle).
 */
Calendar.prototype.showAt = function (x, y) {
	var s = this.element.style;
	s.left = x + "px";
	s.top = y + "px";
	this.show();
};

/** Shows the calendar near a given element. */
Calendar.prototype.showAtElement = function (el, opts) {
	var self = this;
	var p = Calendar.getAbsolutePos(el);
	if (!opts || typeof opts != "string") {
		this.showAt(p.x, p.y + el.offsetHeight);
		return true;
	}
	function fixPosition(box) {
		if (box.x < 0)
			box.x = 0;
		if (box.y < 0)
			box.y = 0;
		var cp = document.createElement("div");
		var s = cp.style;
		s.position = "absolute";
		s.right = s.bottom = s.width = s.height = "0px";
		document.body.appendChild(cp);
		var br = Calendar.getAbsolutePos(cp);
		document.body.removeChild(cp);
		if (Calendar.is_ie) {
			br.y += document.body.scrollTop;
			br.x += document.body.scrollLeft;
		} else {
			br.y += window.scrollY;
			br.x += window.scrollX;
		}
		var tmp = box.x + box.width - br.x;
		if (tmp > 0) box.x -= tmp;
		tmp = box.y + box.height - br.y;
		if (tmp > 0) box.y -= tmp;
	};
	this.element.style.display = "block";
	Calendar.continuation_for_the_fucking_khtml_browser = function() {
		var w = self.element.offsetWidth;
		var h = self.element.offsetHeight;
		self.element.style.display = "none";
		var valign = opts.substr(0, 1);
		var halign = "l";
		if (opts.length > 1) {
			halign = opts.substr(1, 1);
		}
		// vertical alignment
		switch (valign) {
		    case "T": p.y -= h; break;
		    case "B": p.y += el.offsetHeight; break;
		    case "C": p.y += (el.offsetHeight - h) / 2; break;
		    case "t": p.y += el.offsetHeight - h; break;
		    case "b": break; // already there
		}
		// horizontal alignment
		switch (halign) {
		    case "L": p.x -= w; break;
		    case "R": p.x += el.offsetWidth; break;
		    case "C": p.x += (el.offsetWidth - w) / 2; break;
		    case "l": p.x += el.offsetWidth - w; break;
		    case "r": break; // already there
		}
		p.width = w;
		p.height = h + 40;
		self.monthsCombo.style.display = "none";
		fixPosition(p);
		self.showAt(p.x, p.y);
	};
	if (Calendar.is_khtml)
		setTimeout("Calendar.continuation_for_the_fucking_khtml_browser()", 10);
	else
		Calendar.continuation_for_the_fucking_khtml_browser();
};

/** Customizes the date format. */
Calendar.prototype.setDateFormat = function (str) {
	this.dateFormat = str;
};

/** Customizes the tooltip date format. */
Calendar.prototype.setTtDateFormat = function (str) {
	this.ttDateFormat = str;
};

/**
 *  Tries to identify the date represented in a string.  If successful it also
 *  calls this.setDate which moves the calendar to the given date.
 */
Calendar.prototype.parseDate = function(str, fmt) {
	if (!fmt)
		fmt = this.dateFormat;
	this.setDate(Date.parseDate(str, fmt));
};

Calendar.prototype.hideShowCovered = function () {
	if (!Calendar.is_ie && !Calendar.is_opera)
		return;
	function getVisib(obj){
		var value = obj.style.visibility;
		if (!value) {
			if (document.defaultView && typeof (document.defaultView.getComputedStyle) == "function") { // Gecko, W3C
				if (!Calendar.is_khtml)
					value = document.defaultView.
						getComputedStyle(obj, "").getPropertyValue("visibility");
				else
					value = '';
			} else if (obj.currentStyle) { // IE
				value = obj.currentStyle.visibility;
			} else
				value = '';
		}
		return value;
	};

	var tags = new Array("applet", "iframe", "select");
	var el = this.element;

	var p = Calendar.getAbsolutePos(el);
	var EX1 = p.x;
	var EX2 = el.offsetWidth + EX1;
	var EY1 = p.y;
	var EY2 = el.offsetHeight + EY1;

	for (var k = tags.length; k > 0; ) {
		var ar = document.getElementsByTagName(tags[--k]);
		var cc = null;

		for (var i = ar.length; i > 0;) {
			cc = ar[--i];

			p = Calendar.getAbsolutePos(cc);
			var CX1 = p.x;
			var CX2 = cc.offsetWidth + CX1;
			var CY1 = p.y;
			var CY2 = cc.offsetHeight + CY1;

			if (this.hidden || (CX1 > EX2) || (CX2 < EX1) || (CY1 > EY2) || (CY2 < EY1)) {
				if (!cc.__msh_save_visibility) {
					cc.__msh_save_visibility = getVisib(cc);
				}
				cc.style.visibility = cc.__msh_save_visibility;
			} else {
				if (!cc.__msh_save_visibility) {
					cc.__msh_save_visibility = getVisib(cc);
				}
				cc.style.visibility = "hidden";
			}
		}
	}
};

/** Internal function; it displays the bar with the names of the weekday. */
Calendar.prototype._displayWeekdays = function () {
	var fdow = this.firstDayOfWeek;
	var cell = this.firstdayname;
	var weekend = Calendar._TT["WEEKEND"];
	for (var i = 0; i < 7; ++i) {
		cell.className = "day name";
		var realday = (i + fdow) % 7;
		if (i) {
			cell.ttip = Calendar._TT["DAY_FIRST"].replace("%s", Calendar._DN[realday]);
			cell.navtype = 100;
			cell.calendar = this;
			cell.fdow = realday;
			Calendar._add_evs(cell);
		}
		if (weekend.indexOf(realday.toString()) != -1) {
			Calendar.addClass(cell, "weekend");
		}
		cell.innerHTML = Calendar._SDN[(i + fdow) % 7];
		cell = cell.nextSibling;
	}
};

/** Internal function.  Hides all combo boxes that might be displayed. */
Calendar.prototype._hideCombos = function () {
	this.monthsCombo.style.display = "none";
	this.yearsCombo.style.display = "none";
};

/** Internal function.  Starts dragging the element. */
Calendar.prototype._dragStart = function (ev) {
	if (this.dragging) {
		return;
	}
	this.dragging = true;
	var posX;
	var posY;
	if (Calendar.is_ie) {
		posY = window.event.clientY + document.body.scrollTop;
		posX = window.event.clientX + document.body.scrollLeft;
	} else {
		posY = ev.clientY + window.scrollY;
		posX = ev.clientX + window.scrollX;
	}
	var st = this.element.style;
	this.xOffs = posX - parseInt(st.left);
	this.yOffs = posY - parseInt(st.top);
	with (Calendar) {
		addEvent(document, "mousemove", calDragIt);
		addEvent(document, "mouseup", calDragEnd);
	}
};

// BEGIN: DATE OBJECT PATCHES

/** Adds the number of days array to the Date object. */
Date._MD = new Array(31,28,31,30,31,30,31,31,30,31,30,31);

/** Constants used for time computations */
Date.SECOND = 1000 /* milliseconds */;
Date.MINUTE = 60 * Date.SECOND;
Date.HOUR   = 60 * Date.MINUTE;
Date.DAY    = 24 * Date.HOUR;
Date.WEEK   =  7 * Date.DAY;

Date.parseDate = function(str, fmt) {
	var today = new Date();
	var y = 0;
	var m = -1;
	var d = 0;
	var a = str.split(/\W+/);
	var b = fmt.match(/%./g);
	var i = 0, j = 0;
	var hr = 0;
	var min = 0;
	for (i = 0; i < a.length; ++i) {
		if (!a[i])
			continue;
		switch (b[i]) {
		    case "%d":
		    case "%e":
			d = parseInt(a[i], 10);
			break;

		    case "%m":
			m = parseInt(a[i], 10) - 1;
			break;

		    case "%Y":
		    case "%y":
			y = parseInt(a[i], 10);
			(y < 100) && (y += (y > 29) ? 1900 : 2000);
			break;

		    case "%b":
		    case "%B":
			for (j = 0; j < 12; ++j) {
				if (Calendar._MN[j].substr(0, a[i].length).toLowerCase() == a[i].toLowerCase()) { m = j; break; }
			}
			break;

		    case "%H":
		    case "%I":
		    case "%k":
		    case "%l":
			hr = parseInt(a[i], 10);
			break;

		    case "%P":
		    case "%p":
			if (/pm/i.test(a[i]) && hr < 12)
				hr += 12;
			else if (/am/i.test(a[i]) && hr >= 12)
				hr -= 12;
			break;

		    case "%M":
			min = parseInt(a[i], 10);
			break;
		}
	}
	if (isNaN(y)) y = today.getFullYear();
	if (isNaN(m)) m = today.getMonth();
	if (isNaN(d)) d = today.getDate();
	if (isNaN(hr)) hr = today.getHours();
	if (isNaN(min)) min = today.getMinutes();
	if (y != 0 && m != -1 && d != 0)
		return new Date(y, m, d, hr, min, 0);
	y = 0; m = -1; d = 0;
	for (i = 0; i < a.length; ++i) {
		if (a[i].search(/[a-zA-Z]+/) != -1) {
			var t = -1;
			for (j = 0; j < 12; ++j) {
				if (Calendar._MN[j].substr(0, a[i].length).toLowerCase() == a[i].toLowerCase()) { t = j; break; }
			}
			if (t != -1) {
				if (m != -1) {
					d = m+1;
				}
				m = t;
			}
		} else if (parseInt(a[i], 10) <= 12 && m == -1) {
			m = a[i]-1;
		} else if (parseInt(a[i], 10) > 31 && y == 0) {
			y = parseInt(a[i], 10);
			(y < 100) && (y += (y > 29) ? 1900 : 2000);
		} else if (d == 0) {
			d = a[i];
		}
	}
	if (y == 0)
		y = today.getFullYear();
	if (m != -1 && d != 0)
		return new Date(y, m, d, hr, min, 0);
	return today;
};

/** Returns the number of days in the current month */
Date.prototype.getMonthDays = function(month) {
	var year = this.getFullYear();
	if (typeof month == "undefined") {
		month = this.getMonth();
	}
	if (((0 == (year%4)) && ( (0 != (year%100)) || (0 == (year%400)))) && month == 1) {
		return 29;
	} else {
		return Date._MD[month];
	}
};

/** Returns the number of day in the year. */
Date.prototype.getDayOfYear = function() {
	var now = new Date(this.getFullYear(), this.getMonth(), this.getDate(), 0, 0, 0);
	var then = new Date(this.getFullYear(), 0, 0, 0, 0, 0);
	var time = now - then;
	return Math.floor(time / Date.DAY);
};

/** Returns the number of the week in year, as defined in ISO 8601. */
Date.prototype.getWeekNumber = function() {
	var d = new Date(this.getFullYear(), this.getMonth(), this.getDate(), 0, 0, 0);
	var DoW = d.getDay();
	d.setDate(d.getDate() - (DoW + 6) % 7 + 3); // Nearest Thu
	var ms = d.valueOf(); // GMT
	d.setMonth(0);
	d.setDate(4); // Thu in Week 1
	return Math.round((ms - d.valueOf()) / (7 * 864e5)) + 1;
};

/** Checks date and time equality */
Date.prototype.equalsTo = function(date) {
	return ((this.getFullYear() == date.getFullYear()) &&
		(this.getMonth() == date.getMonth()) &&
		(this.getDate() == date.getDate()) &&
		(this.getHours() == date.getHours()) &&
		(this.getMinutes() == date.getMinutes()));
};

/** Set only the year, month, date parts (keep existing time) */
Date.prototype.setDateOnly = function(date) {
	var tmp = new Date(date);
	this.setDate(1);
	this.setFullYear(tmp.getFullYear());
	this.setMonth(tmp.getMonth());
	this.setDate(tmp.getDate());
};

/** Prints the date in a string according to the given format. */
Date.prototype.print = function (str) {
	var m = this.getMonth();
	var d = this.getDate();
	var y = this.getFullYear();
	var wn = this.getWeekNumber();
	var w = this.getDay();
	var s = {};
	var hr = this.getHours();
	var pm = (hr >= 12);
	var ir = (pm) ? (hr - 12) : hr;
	var dy = this.getDayOfYear();
	if (ir == 0)
		ir = 12;
	var min = this.getMinutes();
	var sec = this.getSeconds();
	s["%a"] = Calendar._SDN[w]; // abbreviated weekday name [FIXME: I18N]
	s["%A"] = Calendar._DN[w]; // full weekday name
	s["%b"] = Calendar._SMN[m]; // abbreviated month name [FIXME: I18N]
	s["%B"] = Calendar._MN[m]; // full month name
	// FIXME: %c : preferred date and time representation for the current locale
	s["%C"] = 1 + Math.floor(y / 100); // the century number
	s["%d"] = (d < 10) ? ("0" + d) : d; // the day of the month (range 01 to 31)
	s["%e"] = d; // the day of the month (range 1 to 31)
	// FIXME: %D : american date style: %m/%d/%y
	// FIXME: %E, %F, %G, %g, %h (man strftime)
	s["%H"] = (hr < 10) ? ("0" + hr) : hr; // hour, range 00 to 23 (24h format)
	s["%I"] = (ir < 10) ? ("0" + ir) : ir; // hour, range 01 to 12 (12h format)
	s["%j"] = (dy < 100) ? ((dy < 10) ? ("00" + dy) : ("0" + dy)) : dy; // day of the year (range 001 to 366)
	s["%k"] = hr;		// hour, range 0 to 23 (24h format)
	s["%l"] = ir;		// hour, range 1 to 12 (12h format)
	s["%m"] = (m < 9) ? ("0" + (1+m)) : (1+m); // month, range 01 to 12
	s["%M"] = (min < 10) ? ("0" + min) : min; // minute, range 00 to 59
	s["%n"] = "\n";		// a newline character
	s["%p"] = pm ? "PM" : "AM";
	s["%P"] = pm ? "pm" : "am";
	// FIXME: %r : the time in am/pm notation %I:%M:%S %p
	// FIXME: %R : the time in 24-hour notation %H:%M
	s["%s"] = Math.floor(this.getTime() / 1000);
	s["%S"] = (sec < 10) ? ("0" + sec) : sec; // seconds, range 00 to 59
	s["%t"] = "\t";		// a tab character
	// FIXME: %T : the time in 24-hour notation (%H:%M:%S)
	s["%U"] = s["%W"] = s["%V"] = (wn < 10) ? ("0" + wn) : wn;
	s["%u"] = w + 1;	// the day of the week (range 1 to 7, 1 = MON)
	s["%w"] = w;		// the day of the week (range 0 to 6, 0 = SUN)
	// FIXME: %x : preferred date representation for the current locale without the time
	// FIXME: %X : preferred time representation for the current locale without the date
	s["%y"] = ('' + y).substr(2, 2); // year without the century (range 00 to 99)
	s["%Y"] = y;		// year with the century
	s["%%"] = "%";		// a literal '%' character

	var re = /%./g;
	if (!Calendar.is_ie5 && !Calendar.is_khtml)
		return str.replace(re, function (par) { return s[par] || par; });

	var a = str.match(re);
	for (var i = 0; i < a.length; i++) {
		var tmp = s[a[i]];
		if (tmp) {
			re = new RegExp(a[i], 'g');
			str = str.replace(re, tmp);
		}
	}

	return str;
};

Date.prototype.__msh_oldSetFullYear = Date.prototype.setFullYear;
Date.prototype.setFullYear = function(y) {
	var d = new Date(this);
	d.__msh_oldSetFullYear(y);
	if (d.getMonth() != this.getMonth())
		this.setDate(28);
	this.__msh_oldSetFullYear(y);
};

// END: DATE OBJECT PATCHES


// global object that remembers the calendar
window._dynarch_popupCalendar = null;

///////////////////////////////////////////////////////
// END jscalendar/calendar
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN jscalendar/lang/calendar-de
///////////////////////////////////////////////////////
// ** I18N

// Calendar DE language
// Author: Jack (tR), <jack@jtr.de>
// Encoding: any
// Distributed under the same terms as the calendar itself.

// For translators: please use UTF-8 if possible.  We strongly believe that
// Unicode is the answer to a real internationalized world.  Also please
// include your contact information in the header, as can be seen above.

// full day names
Calendar._DN = new Array
("Sonntag",
 "Montag",
 "Dienstag",
 "Mittwoch",
 "Donnerstag",
 "Freitag",
 "Samstag",
 "Sonntag");

// Please note that the following array of short day names (and the same goes
// for short month names, _SMN) isn't absolutely necessary.  We give it here
// for exemplification on how one can customize the short day names, but if
// they are simply the first N letters of the full name you can simply say:
//
//   Calendar._SDN_len = N; // short day name length
//   Calendar._SMN_len = N; // short month name length
//
// If N = 3 then this is not needed either since we assume a value of 3 if not
// present, to be compatible with translation files that were written before
// this feature.

// short day names
Calendar._SDN = new Array
("So",
 "Mo",
 "Di",
 "Mi",
 "Do",
 "Fr",
 "Sa",
 "So");

// full month names
Calendar._MN = new Array
("Januar",
 "Februar",
 "M\u00e4rz",
 "April",
 "Mai",
 "Juni",
 "Juli",
 "August",
 "September",
 "Oktober",
 "November",
 "Dezember");

// short month names
Calendar._SMN = new Array
("Jan",
 "Feb",
 "M\u00e4r",
 "Apr",
 "May",
 "Jun",
 "Jul",
 "Aug",
 "Sep",
 "Okt",
 "Nov",
 "Dez");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "\u00DCber dieses Kalendarmodul";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this ;-)
"For latest version visit: http://www.dynarch.com/projects/calendar/\n" +
"Distributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details." +
"\n\n" +
"Datum ausw\u00e4hlen:\n" +
"- Benutzen Sie die \xab, \xbb Buttons um das Jahr zu w\u00e4hlen\n" +
"- Benutzen Sie die " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " Buttons um den Monat zu w\u00e4hlen\n" +
"- F\u00fcr eine Schnellauswahl halten Sie die Maustaste \u00fcber diesen Buttons fest.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Zeit ausw\u00e4hlen:\n" +
"- Klicken Sie auf die Teile der Uhrzeit, um diese zu erh\u00F6hen\n" +
"- oder klicken Sie mit festgehaltener Shift-Taste um diese zu verringern\n" +
"- oder klicken und festhalten f\u00fcr Schnellauswahl.";

Calendar._TT["TOGGLE"] = "Ersten Tag der Woche w\u00e4hlen";
Calendar._TT["PREV_YEAR"] = "Voriges Jahr (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["PREV_MONTH"] = "Voriger Monat (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["GO_TODAY"] = "Heute ausw\u00e4hlen";
Calendar._TT["NEXT_MONTH"] = "N\u00e4chst. Monat (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["NEXT_YEAR"] = "N\u00e4chst. Jahr (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["SEL_DATE"] = "Datum ausw\u00e4hlen";
Calendar._TT["DRAG_TO_MOVE"] = "Zum Bewegen festhalten";
Calendar._TT["PART_TODAY"] = " (Heute)";

// the following is to inform that "%s" is to be the first day of week
// %s will be replaced with the day name.
Calendar._TT["DAY_FIRST"] = "Woche beginnt mit %s ";

// This may be locale-dependent.  It specifies the week-end days, as an array
// of comma-separated numbers.  The numbers are from 0 to 6: 0 means Sunday, 1
// means Monday, etc.
Calendar._TT["WEEKEND"] = "0,6";

Calendar._TT["CLOSE"] = "Schlie\u00dfen";
Calendar._TT["TODAY"] = "Heute";
Calendar._TT["TIME_PART"] = "(Shift-)Klick oder Festhalten und Ziehen um den Wert zu \u00e4ndern";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%d.%m.%Y";
Calendar._TT["TT_DATE_FORMAT"] = "%a, %b %e";

Calendar._TT["WK"] = "wk";
Calendar._TT["TIME"] = "Zeit:";

///////////////////////////////////////////////////////
// END jscalendar/lang/calendar-de
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN jscalendar/calendar-setup
///////////////////////////////////////////////////////
/*  Copyright Mihai Bazon, 2002, 2003  |  http://dynarch.com/mishoo/
 * ---------------------------------------------------------------------------
 *
 * The DHTML Calendar
 *
 * Details and latest version at:
 * http://dynarch.com/mishoo/calendar.epl
 *
 * This script is distributed under the GNU Lesser General Public License.
 * Read the entire license text here: http://www.gnu.org/licenses/lgpl.html
 *
 * This file defines helper functions for setting up the calendar.  They are
 * intended to help non-programmers get a working calendar on their site
 * quickly.  This script should not be seen as part of the calendar.  It just
 * shows you what one can do with the calendar, while in the same time
 * providing a quick and simple method for setting it up.  If you need
 * exhaustive customization of the calendar creation process feel free to
 * modify this code to suit your needs (this is recommended and much better
 * than modifying calendar.js itself).
 */

// $Id: calendar-setup.js,v 1.25 2005/03/07 09:51:33 mishoo Exp $

/**
 *  This function "patches" an input field (or other element) to use a calendar
 *  widget for date selection.
 *
 *  The "params" is a single object that can have the following properties:
 *
 *    prop. name   | description
 *  -------------------------------------------------------------------------------------------------
 *   inputField    | the ID of an input field to store the date
 *   displayArea   | the ID of a DIV or other element to show the date
 *   button        | ID of a button or other element that will trigger the calendar
 *   eventName     | event that will trigger the calendar, without the "on" prefix (default: "click")
 *   ifFormat      | date format that will be stored in the input field
 *   daFormat      | the date format that will be used to display the date in displayArea
 *   singleClick   | (true/false) wether the calendar is in single click mode or not (default: true)
 *   firstDay      | numeric: 0 to 6.  "0" means display Sunday first, "1" means display Monday first, etc.
 *   align         | alignment (default: "Br"); if you don't know what's this see the calendar documentation
 *   range         | array with 2 elements.  Default: [1900, 2999] -- the range of years available
 *   weekNumbers   | (true/false) if it's true (default) the calendar will display week numbers
 *   flat          | null or element ID; if not null the calendar will be a flat calendar having the parent with the given ID
 *   flatCallback  | function that receives a JS Date object and returns an URL to point the browser to (for flat calendar)
 *   disableFunc   | function that receives a JS Date object and should return true if that date has to be disabled in the calendar
 *   onSelect      | function that gets called when a date is selected.  You don't _have_ to supply this (the default is generally okay)
 *   onClose       | function that gets called when the calendar is closed.  [default]
 *   onUpdate      | function that gets called after the date is updated in the input field.  Receives a reference to the calendar.
 *   date          | the date that the calendar will be initially displayed to
 *   showsTime     | default: false; if true the calendar will include a time selector
 *   timeFormat    | the time format; can be "12" or "24", default is "12"
 *   electric      | if true (default) then given fields/date areas are updated for each move; otherwise they're updated only on close
 *   step          | configures the step of the years in drop-down boxes; default: 2
 *   position      | configures the calendar absolute position; default: null
 *   cache         | if "true" (but default: "false") it will reuse the same calendar object, where possible
 *   showOthers    | if "true" (but default: "false") it will show days from other months too
 *
 *  None of them is required, they all have default values.  However, if you
 *  pass none of "inputField", "displayArea" or "button" you'll get a warning
 *  saying "nothing to setup".
 */
Calendar.setup = function (params) {
	function param_default(pname, def) { if (typeof params[pname] == "undefined") { params[pname] = def; } };

	param_default("inputField",     null);
	param_default("displayArea",    null);
	param_default("button",         null);
	param_default("eventName",      "click");
	param_default("ifFormat",       "%Y/%m/%d");
	param_default("daFormat",       "%Y/%m/%d");
	param_default("singleClick",    true);
	param_default("disableFunc",    null);
	param_default("dateStatusFunc", params["disableFunc"]);	// takes precedence if both are defined
	param_default("dateText",       null);
	param_default("firstDay",       null);
	param_default("align",          "Br");
	param_default("range",          [1900, 2999]);
	param_default("weekNumbers",    true);
	param_default("flat",           null);
	param_default("flatCallback",   null);
	param_default("onSelect",       null);
	param_default("onClose",        null);
	param_default("onUpdate",       null);
	param_default("date",           null);
	param_default("showsTime",      false);
	param_default("timeFormat",     "24");
	param_default("electric",       true);
	param_default("step",           2);
	param_default("position",       null);
	param_default("cache",          false);
	param_default("showOthers",     false);
	param_default("multiple",       null);

	var tmp = ["inputField", "displayArea", "button"];
	for (var i in tmp) {
		if (typeof params[tmp[i]] == "string") {
			params[tmp[i]] = document.getElementById(params[tmp[i]]);
		}
	}
	if (!(params.flat || params.multiple || params.inputField || params.displayArea || params.button)) {
		alert("Calendar.setup:\n  Nothing to setup (no fields found).  Please check your code");
		return false;
	}

	function onSelect(cal) {
		var p = cal.params;
		var update = (cal.dateClicked || p.electric);
		if (update && p.inputField) {
			p.inputField.value = cal.date.print(p.ifFormat);
			if (typeof p.inputField.onchange == "function")
				p.inputField.onchange();
		}
		if (update && p.displayArea)
			p.displayArea.innerHTML = cal.date.print(p.daFormat);
		if (update && typeof p.onUpdate == "function")
			p.onUpdate(cal);
		if (update && p.flat) {
			if (typeof p.flatCallback == "function")
				p.flatCallback(cal);
		}
		if (update && p.singleClick && cal.dateClicked)
			cal.callCloseHandler();
	};

	if (params.flat != null) {
		if (typeof params.flat == "string")
			params.flat = document.getElementById(params.flat);
		if (!params.flat) {
			alert("Calendar.setup:\n  Flat specified but can't find parent.");
			return false;
		}
		var cal = new Calendar(params.firstDay, params.date, params.onSelect || onSelect);
		cal.showsOtherMonths = params.showOthers;
		cal.showsTime = params.showsTime;
		cal.time24 = (params.timeFormat == "24");
		cal.params = params;
		cal.weekNumbers = params.weekNumbers;
		cal.setRange(params.range[0], params.range[1]);
		cal.setDateStatusHandler(params.dateStatusFunc);
		cal.getDateText = params.dateText;
		if (params.ifFormat) {
			cal.setDateFormat(params.ifFormat);
		}
		if (params.inputField && typeof params.inputField.value == "string") {
			cal.parseDate(params.inputField.value);
		}
		cal.create(params.flat);
		cal.show();
		return false;
	}

	var triggerEl = params.button || params.displayArea || params.inputField;
	triggerEl["on" + params.eventName] = function() {
		var dateEl = params.inputField || params.displayArea;
		var dateFmt = params.inputField ? params.ifFormat : params.daFormat;
		var mustCreate = false;
		var cal = window.calendar;
		if (dateEl)
			params.date = Date.parseDate(dateEl.value || dateEl.innerHTML, dateFmt);
		if (!(cal && params.cache)) {
			window.calendar = cal = new Calendar(params.firstDay,
							     params.date,
							     params.onSelect || onSelect,
							     params.onClose || function(cal) { cal.hide(); });
			cal.showsTime = params.showsTime;
			cal.time24 = (params.timeFormat == "24");
			cal.weekNumbers = params.weekNumbers;
			mustCreate = true;
		} else {
			if (params.date)
				cal.setDate(params.date);
			cal.hide();
		}
		if (params.multiple) {
			cal.multiple = {};
			for (var i = params.multiple.length; --i >= 0;) {
				var d = params.multiple[i];
				var ds = d.print("%Y%m%d");
				cal.multiple[ds] = d;
			}
		}
		cal.showsOtherMonths = params.showOthers;
		cal.yearStep = params.step;
		cal.setRange(params.range[0], params.range[1]);
		cal.params = params;
		cal.setDateStatusHandler(params.dateStatusFunc);
		cal.getDateText = params.dateText;
		cal.setDateFormat(dateFmt);
		if (mustCreate)
			cal.create();
		cal.refresh();
		if (!params.position)
			cal.showAtElement(params.button || params.displayArea || params.inputField, params.align);
		else
			cal.showAt(params.position[0], params.position[1]);
		return false;
	};

	return cal;
};

///////////////////////////////////////////////////////
// END jscalendar/calendar-setup
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN log
///////////////////////////////////////////////////////

function log_debug(message) { 
  if(window.console && window.console.log) { 
    window.console.log(message); 
  } 
  if(document.getElementById('developer_console')) { 
    document.getElementById('developer_console').innerHTML += (message + '<hr />');
  }
}

function clear_log() { 
  document.getElementById('developer_console').innerHTML = ''; 
}
function hide_log() { 
  app             = document.getElementById('app_body');
  console_element = document.getElementById('debug_box'); 
  app.removeChild(console_element); 
}

///////////////////////////////////////////////////////
// END log
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN helpers
///////////////////////////////////////////////////////

date_obj = new Date(); 

var Browser = {
    is_ie    : document.all&&document.getElementById,
    is_gecko : document.getElementById&&!document.all
};

function element_exists(id)
{
    return (document.getElementById(id) != undefined);
}
function add_event( obj, type, fn )
{
   if (obj.addEventListener) {
      obj.addEventListener( type, fn, false );
   } else if (obj.attachEvent) {
      obj["e"+type+fn] = fn;
      obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
      obj.attachEvent( "on"+type, obj[type+fn] );
   }
}

function remove_event( obj, type, fn )
{
   if (obj.removeEventListener) {
      obj.removeEventListener( type, fn, false );
   } else if (obj.detachEvent) {
      obj.detachEvent( "on"+type, obj[type+fn] );
      obj[type+fn] = null;
      obj["e"+type+fn] = null;
   }
}

function position_of(obj) 
{
    var curleft = curtop = 0;
    if (obj.offsetParent) {
      curleft = obj.offsetLeft
      curtop = obj.offsetTop
      while (obj = obj.offsetParent) {
        curleft += obj.offsetLeft
        curtop += obj.offsetTop
      }
    }
    return [curleft,curtop];
}

function getPageScroll(){

  var yScroll;

  if (self.pageYOffset) {
    yScroll = self.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop){  // Explorer 6 Strict
    yScroll = document.documentElement.scrollTop;
  } else if (document.body) {// all other Explorers
    yScroll = document.body.scrollTop;
  }

  arrayPageScroll = new Array('',yScroll) 
  return arrayPageScroll;
}

var mouse_x = 0; 
var mouse_y = 0; 
function capture_mouse(ev) 
{
    if(!ev) { ev = window.event; }
    if(!ev) { return ; }

// Is IE
    if(Browser.is_ie) { 
      mouse_x = ev.clientX;  // ignore horizontal scroll
      mouse_y = ev.clientY + getPageScroll()[1]; 
    }
// Is Gecko
    else if (Browser.is_gecko) { 
      mouse_x = ev.pageX; 
      mouse_y = ev.pageY; 
    }
//    Element.setStyle('context_menu_icon', { left: (mouse_x+5)+'px', top: (mouse_y+5)+'px' });
//    window.status = mouse_x + 'x' + mouse_y; 
}
function get_mouse(event) 
{
    return [mouse_x, mouse_y];
}

function get_style(el, style) 
{
    if(!document.getElementById) return;
    var value = el.style[style];
    
    if(!value) { 
      if(document.defaultView) {
        value = document.defaultView.getComputedStyle(el, "").getPropertyValue(style);
      } else if(el.currentStyle) { 
        value = el.currentStyle[style];
      }
    }
    return value; 
}

function is_mouse_over(obj)
{
    if(!obj) { return; } 
    width = parseInt(Element.getWidth(obj)); 
    height = parseInt(Element.getHeight(obj));
    if(!width) { width = obj.offsetWidth; }
    if(!height) { width = obj.offsetheight; }
    pos = position_of(obj);
    x = pos[0];
    y = pos[1];
    
    if(obj.style.x) { x = obj.style.x; }
    if(obj.style.y) { y = obj.style.y; }
    
    if(mouse_x >= x && mouse_x <= x+width &&
       mouse_y >= y && mouse_y <= y+height) {
      window.status = 'OVER MENU '+mouse_x+' '+mouse_y; 
      return true; 
    } 
    else {
      return false; 
    }
}

function rgb_to_hex(str)
{
    var pattern = /\([^\)]+\)/gi;
    var result = ''+str.match(pattern);

    result = result.replace(/\(/,'').replace(/\)/,'');

    var hex = '#';
    tmp = result.split(', ');

    for (m=0; m<3; m++) {
      value = (tmp[m]*1).toString(16);
      if(value.length < 2) { value = '0'+value; }
      hex += value;
    }
    return hex;
}

var last_hovered_element = false; 
function hover_element(elem_id) { 
  if(last_hovered_element) { 
    try { 
      Element.removeClassName($(last_hovered_element), 'hovered'); 
    } catch(e) { }
  }
  Element.addClassName($(elem_id), 'hovered'); 
  last_hovered_element = elem_id; 
}
function unhover_element(elem_id) { 
  Element.removeClassName($(elem_id), 'hovered'); 
}

function focus_element(element_id)
{
    Element.addClassName(element_id, 'highlighted'); 
    Element.setStyle(element_id, {zIndex: 301});
}
function unfocus_element(element_id)
{
    if(element_exists(element_id)) {
      Element.removeClassName(element_id, 'highlighted'); 
      Element.setStyle(element_id, {zIndex: 1});
    }
}

function swap_style(style, value_1, value_2, target)
{
    obj = document.getElementById(target); 
    style_curr = obj.style[style]; 
    
    obj.style[style] = value_1; 
    if(obj.style[style] == style_curr) {
      obj.style[style] = value_2; 
    }
}

function swap_value(element_id, value_1, value_2)
{
    obj = document.getElementById(element_id); 
    value_curr = obj.value; 
    
    obj.value = value_1; 
    if(obj.value == value_curr) {
      obj.value = value_2; 
    }
    
}


function resizeable_popup(w, h, url)
{
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable=1,menubar=0,fullscreen=0,status=0';
    win = window.open(url,"popup",settings);
    win.focus();
}

function checkbox_swap(element)
{
    if(element.checked == true) {
      element.value = '1'; 
    }
    else {
      element.value = '0'; 
    }
}

function alert_array(arr) { 
  s = ''; 
  for(var e in arr) { 
    s += (e + ' | ' + arr[e]); 
  } 
  alert(s); 
}

function insert_at_cursor(textarea_element_id, text) { 
  textarea = $(textarea_element_id); 
  //IE 
  if (document.selection) {
    textarea.focus();
    sel = document.selection.createRange();
    sel.text = text;
  }
  //MOZILLA
  else if (textarea.selectionStart || textarea.selectionStart == 0) {
    var startPos = textarea.selectionStart;
    var endPos = textarea.selectionEnd;
    textarea.value = textarea.value.substring(0, startPos)
    + text
    + textarea.value.substring(endPos, textarea.value.length);
  } else {
    textarea.value += text;
  }
}


///////////////////////////////////////////////////////
// END helpers
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN cookie
///////////////////////////////////////////////////////

/**
 * Sets a Cookie with the given name and value.
 *
 * name       Name of the cookie
 * value      Value of the cookie
 * [expires]  Expiration date of the cookie (default: end of current session)
 * [path]     Path where the cookie is valid (default: path of calling document)
 * [domain]   Domain where the cookie is valid
 *              (default: domain of calling document)
 * [secure]   Boolean value indicating if the cookie transmission requires a
 *              secure transmission
 */
function setCookie(name, value, expires, path, domain, secure) {
    path = '/'; 
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toGMTString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

/**
 * Gets the value of the specified cookie.
 *
 * name  Name of the desired cookie.
 *
 * Returns a string containing value of specified cookie,
 *   or null if cookie does not exist.
 */
function getCookie(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}

/**
 * Deletes the specified cookie.
 *
 * name      name of the cookie
 * [path]    path of the cookie (must be same as path used to create cookie)
 * [domain]  domain of the cookie (must be same as domain used to create cookie)
 */
function deleteCookie(name, path, domain) {
    path = '/'; 
    if (getCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

///////////////////////////////////////////////////////
// END cookie
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN xhconn
///////////////////////////////////////////////////////

/** XHConn - Simple XMLHTTP Interface - bfults@gmail.com - 2005-04-08        **
 ** Code licensed under Creative Commons Attribution-ShareAlike License      **
 ** http://creativecommons.org/licenses/by-sa/2.0/                           **/
function XHConn()
{
  var xmlhttp, bComplete = false;
  var request_url = false; 

  try {
      //    netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (e) {
    alert("Permission UniversalBrowserRead denied.");
  }

  this.req_url = function() { 
    return request_url;
  }

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (e) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (e) { try { xmlhttp = new XMLHttpRequest(); }
  catch (e) { xmlhttp = false; }}}
  if (!xmlhttp) return null;

  this.abort = function() { 
    xmlhttp.abort(); 
  }
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars, onload_fun) {
  
      request_url = sURL; 

      if(postVars == undefined) { postVars = ""; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
        //  sURL += '&randseed='+Math.round(Math.random()*100000);
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
            bComplete = true;
            if(fnDone) { 
              fnDone(xmlhttp, element, sMethod, onload_fun);
            }
          }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return true;
  };

  this.get_string = function(sURL, responseFun, sMethod, postVars) {

   result = '';
   if(postVars == undefined) { postVars = ""; }
   if(sMethod == undefined) { sMethod = 'GET'; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
            bComplete = true;
            responseFun(xmlhttp.responseText);
          }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return result;
  };
  
  return this;
}


///////////////////////////////////////////////////////
// END xhconn
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN md5
///////////////////////////////////////////////////////
/*
 *  md5.js 1.0b 27/06/96
 *
 * Javascript implementation of the RSA Data Security, Inc. MD5
 * Message-Digest Algorithm.
 *
 * Copyright (c) 1996 Henri Torgemane. All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * and its documentation for any purposes and without
 * fee is hereby granted provided that this copyright notice
 * appears in all copies.
 *
 * Of course, this soft is provided "as is" without express or implied
 * warranty of any kind.
 *
 *
 * Modified with german comments and some information about collisions.
 * (Ralf Mieke, ralf@miekenet.de, http://mieke.home.pages.de)
 */



function array(n) {
  for(i=0;i<n;i++) this[i]=0;
  this.length=n;
}



/* Einige grundlegenden Funktionen müssen wegen
 * Javascript Fehlern umgeschrieben werden.
 * Man versuche z.B. 0xffffffff >> 4 zu berechnen..
 * Die nun verwendeten Funktionen sind zwar langsamer als die Originale,
 * aber sie funktionieren.
 */

function integer(n) { return n%(0xffffffff+1); }

function shr(a,b) {
  a=integer(a);
  b=integer(b);
  if (a-0x80000000>=0) {
    a=a%0x80000000;
    a>>=b;
    a+=0x40000000>>(b-1);
  } else
    a>>=b;
  return a;
}

function shl1(a) {
  a=a%0x80000000;
  if (a&0x40000000==0x40000000)
  {
    a-=0x40000000;
    a*=2;
    a+=0x80000000;
  } else
    a*=2;
  return a;
}

function shl(a,b) {
  a=integer(a);
  b=integer(b);
  for (var i=0;i<b;i++) a=shl1(a);
  return a;
}

function and(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1&t2)+0x80000000);
    else
      return (t1&b);
  else
    if (t2>=0)
      return (a&t2);
    else
      return (a&b);
}

function or(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1|t2)+0x80000000);
    else
      return ((t1|b)+0x80000000);
  else
    if (t2>=0)
      return ((a|t2)+0x80000000);
    else
      return (a|b);
}

function xor(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return (t1^t2);
    else
      return ((t1^b)+0x80000000);
  else
    if (t2>=0)
      return ((a^t2)+0x80000000);
    else
      return (a^b);
}

function not(a) {
  a=integer(a);
  return (0xffffffff-a);
}

/* Beginn des Algorithmus */

    var state = new array(4);
    var count = new array(2);
        count[0] = 0;
        count[1] = 0;
    var buffer = new array(64);
    var transformBuffer = new array(16);
    var digestBits = new array(16);

    var S11 = 7;
    var S12 = 12;
    var S13 = 17;
    var S14 = 22;
    var S21 = 5;
    var S22 = 9;
    var S23 = 14;
    var S24 = 20;
    var S31 = 4;
    var S32 = 11;
    var S33 = 16;
    var S34 = 23;
    var S41 = 6;
    var S42 = 10;
    var S43 = 15;
    var S44 = 21;

    function F(x,y,z) {
        return or(and(x,y),and(not(x),z));
    }

    function G(x,y,z) {
        return or(and(x,z),and(y,not(z)));
    }

    function H(x,y,z) {
        return xor(xor(x,y),z);
    }

    function I(x,y,z) {
        return xor(y ,or(x , not(z)));
    }

    function rotateLeft(a,n) {
        return or(shl(a, n),(shr(a,(32 - n))));
    }

    function FF(a,b,c,d,x,s,ac) {
        a = a+F(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function GG(a,b,c,d,x,s,ac) {
        a = a+G(b, c, d) +x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function HH(a,b,c,d,x,s,ac) {
        a = a+H(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function II(a,b,c,d,x,s,ac) {
        a = a+I(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function transform(buf,offset) {
        var a=0, b=0, c=0, d=0;
        var x = transformBuffer;

        a = state[0];
        b = state[1];
        c = state[2];
        d = state[3];

        for (i = 0; i < 16; i++) {
            x[i] = and(buf[i*4+offset],0xff);
            for (j = 1; j < 4; j++) {
                x[i]+=shl(and(buf[i*4+j+offset] ,0xff), j * 8);
            }
        }

        /* Runde 1 */
        a = FF ( a, b, c, d, x[ 0], S11, 0xd76aa478); /* 1 */
        d = FF ( d, a, b, c, x[ 1], S12, 0xe8c7b756); /* 2 */
        c = FF ( c, d, a, b, x[ 2], S13, 0x242070db); /* 3 */
        b = FF ( b, c, d, a, x[ 3], S14, 0xc1bdceee); /* 4 */
        a = FF ( a, b, c, d, x[ 4], S11, 0xf57c0faf); /* 5 */
        d = FF ( d, a, b, c, x[ 5], S12, 0x4787c62a); /* 6 */
        c = FF ( c, d, a, b, x[ 6], S13, 0xa8304613); /* 7 */
        b = FF ( b, c, d, a, x[ 7], S14, 0xfd469501); /* 8 */
        a = FF ( a, b, c, d, x[ 8], S11, 0x698098d8); /* 9 */
        d = FF ( d, a, b, c, x[ 9], S12, 0x8b44f7af); /* 10 */
        c = FF ( c, d, a, b, x[10], S13, 0xffff5bb1); /* 11 */
        b = FF ( b, c, d, a, x[11], S14, 0x895cd7be); /* 12 */
        a = FF ( a, b, c, d, x[12], S11, 0x6b901122); /* 13 */
        d = FF ( d, a, b, c, x[13], S12, 0xfd987193); /* 14 */
        c = FF ( c, d, a, b, x[14], S13, 0xa679438e); /* 15 */
        b = FF ( b, c, d, a, x[15], S14, 0x49b40821); /* 16 */

        /* Runde 2 */
        a = GG ( a, b, c, d, x[ 1], S21, 0xf61e2562); /* 17 */
        d = GG ( d, a, b, c, x[ 6], S22, 0xc040b340); /* 18 */
        c = GG ( c, d, a, b, x[11], S23, 0x265e5a51); /* 19 */
        b = GG ( b, c, d, a, x[ 0], S24, 0xe9b6c7aa); /* 20 */
        a = GG ( a, b, c, d, x[ 5], S21, 0xd62f105d); /* 21 */
        d = GG ( d, a, b, c, x[10], S22,  0x2441453); /* 22 */
        c = GG ( c, d, a, b, x[15], S23, 0xd8a1e681); /* 23 */
        b = GG ( b, c, d, a, x[ 4], S24, 0xe7d3fbc8); /* 24 */
        a = GG ( a, b, c, d, x[ 9], S21, 0x21e1cde6); /* 25 */
        d = GG ( d, a, b, c, x[14], S22, 0xc33707d6); /* 26 */
        c = GG ( c, d, a, b, x[ 3], S23, 0xf4d50d87); /* 27 */
        b = GG ( b, c, d, a, x[ 8], S24, 0x455a14ed); /* 28 */
        a = GG ( a, b, c, d, x[13], S21, 0xa9e3e905); /* 29 */
        d = GG ( d, a, b, c, x[ 2], S22, 0xfcefa3f8); /* 30 */
        c = GG ( c, d, a, b, x[ 7], S23, 0x676f02d9); /* 31 */
        b = GG ( b, c, d, a, x[12], S24, 0x8d2a4c8a); /* 32 */

        /* Runde 3 */
        a = HH ( a, b, c, d, x[ 5], S31, 0xfffa3942); /* 33 */
        d = HH ( d, a, b, c, x[ 8], S32, 0x8771f681); /* 34 */
        c = HH ( c, d, a, b, x[11], S33, 0x6d9d6122); /* 35 */
        b = HH ( b, c, d, a, x[14], S34, 0xfde5380c); /* 36 */
        a = HH ( a, b, c, d, x[ 1], S31, 0xa4beea44); /* 37 */
        d = HH ( d, a, b, c, x[ 4], S32, 0x4bdecfa9); /* 38 */
        c = HH ( c, d, a, b, x[ 7], S33, 0xf6bb4b60); /* 39 */
        b = HH ( b, c, d, a, x[10], S34, 0xbebfbc70); /* 40 */
        a = HH ( a, b, c, d, x[13], S31, 0x289b7ec6); /* 41 */
        d = HH ( d, a, b, c, x[ 0], S32, 0xeaa127fa); /* 42 */
        c = HH ( c, d, a, b, x[ 3], S33, 0xd4ef3085); /* 43 */
        b = HH ( b, c, d, a, x[ 6], S34,  0x4881d05); /* 44 */
        a = HH ( a, b, c, d, x[ 9], S31, 0xd9d4d039); /* 45 */
        d = HH ( d, a, b, c, x[12], S32, 0xe6db99e5); /* 46 */
        c = HH ( c, d, a, b, x[15], S33, 0x1fa27cf8); /* 47 */
        b = HH ( b, c, d, a, x[ 2], S34, 0xc4ac5665); /* 48 */

        /* Runde 4 */
        a = II ( a, b, c, d, x[ 0], S41, 0xf4292244); /* 49 */
        d = II ( d, a, b, c, x[ 7], S42, 0x432aff97); /* 50 */
        c = II ( c, d, a, b, x[14], S43, 0xab9423a7); /* 51 */
        b = II ( b, c, d, a, x[ 5], S44, 0xfc93a039); /* 52 */
        a = II ( a, b, c, d, x[12], S41, 0x655b59c3); /* 53 */
        d = II ( d, a, b, c, x[ 3], S42, 0x8f0ccc92); /* 54 */
        c = II ( c, d, a, b, x[10], S43, 0xffeff47d); /* 55 */
        b = II ( b, c, d, a, x[ 1], S44, 0x85845dd1); /* 56 */
        a = II ( a, b, c, d, x[ 8], S41, 0x6fa87e4f); /* 57 */
        d = II ( d, a, b, c, x[15], S42, 0xfe2ce6e0); /* 58 */
        c = II ( c, d, a, b, x[ 6], S43, 0xa3014314); /* 59 */
        b = II ( b, c, d, a, x[13], S44, 0x4e0811a1); /* 60 */
        a = II ( a, b, c, d, x[ 4], S41, 0xf7537e82); /* 61 */
        d = II ( d, a, b, c, x[11], S42, 0xbd3af235); /* 62 */
        c = II ( c, d, a, b, x[ 2], S43, 0x2ad7d2bb); /* 63 */
        b = II ( b, c, d, a, x[ 9], S44, 0xeb86d391); /* 64 */

        state[0] +=a;
        state[1] +=b;
        state[2] +=c;
        state[3] +=d;

    }
    /* Mit der Initialisierung von Dobbertin:
       state[0] = 0x12ac2375;
       state[1] = 0x3b341042;
       state[2] = 0x5f62b97c;
       state[3] = 0x4ba763ed;
       gibt es eine Kollision:

       begin 644 Message1
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHR%C4:G1R:Q"=
       `
       end

       begin 644 Message2
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHREC4:G1R:Q"=
       `
       end
    */
    function init() {
        count[0]=count[1] = 0;
        state[0] = 0x67452301;
        state[1] = 0xefcdab89;
        state[2] = 0x98badcfe;
        state[3] = 0x10325476;
        for (i = 0; i < digestBits.length; i++)
            digestBits[i] = 0;
    }

    function update(b) {
        var index,i;

        index = and(shr(count[0],3) , 0x3f);
        if (count[0]<0xffffffff-7)
          count[0] += 8;
        else {
          count[1]++;
          count[0]-=0xffffffff+1;
          count[0]+=8;
        }
        buffer[index] = and(b,0xff);
        if (index  >= 63) {
            transform(buffer, 0);
        }
    }

    function finish() {
        var bits = new array(8);
        var        padding;
        var        i=0, index=0, padLen=0;

        for (i = 0; i < 4; i++) {
            bits[i] = and(shr(count[0],(i * 8)), 0xff);
        }
        for (i = 0; i < 4; i++) {
            bits[i+4]=and(shr(count[1],(i * 8)), 0xff);
        }
        index = and(shr(count[0], 3) ,0x3f);
        padLen = (index < 56) ? (56 - index) : (120 - index);
        padding = new array(64);
        padding[0] = 0x80;
        for (i=0;i<padLen;i++)
          update(padding[i]);
        for (i=0;i<8;i++)
          update(bits[i]);

        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                digestBits[i*4+j] = and(shr(state[i], (j * 8)) , 0xff);
            }
        }
    }

/* Ende des MD5 Algorithmus */

function hexa(n) {
 var hexa_h = "0123456789abcdef";
 var hexa_c="";
 var hexa_m=n;
 for (hexa_i=0;hexa_i<8;hexa_i++) {
   hexa_c=hexa_h.charAt(Math.abs(hexa_m)%16)+hexa_c;
   hexa_m=Math.floor(hexa_m/16);
 }
 return hexa_c;
}


var ascii="01234567890123456789012345678901" +
          " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
          "[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

function MD5(nachricht)
{
 var l,s,k,ka,kb,kc,kd;

 init();
 for (k=0;k<nachricht.length;k++) {
   l=nachricht.charAt(k);
   update(ascii.lastIndexOf(l));
 }
 finish();
 ka=kb=kc=kd=0;
 for (i=0;i<4;i++) ka+=shl(digestBits[15-i], (i*8));
 for (i=4;i<8;i++) kb+=shl(digestBits[15-i], ((i-4)*8));
 for (i=8;i<12;i++) kc+=shl(digestBits[15-i], ((i-8)*8));
 for (i=12;i<16;i++) kd+=shl(digestBits[15-i], ((i-12)*8));
 s=hexa(kd)+hexa(kc)+hexa(kb)+hexa(ka);
 return s;
}
///////////////////////////////////////////////////////
// END md5
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN aurita
///////////////////////////////////////////////////////

var Aurita = {
  last_username: '', 
  username_input_element: '0', 
  loading_icon: '<img src="/aurita/images/icons/loading.gif" />'
}; 

Aurita.check_if_internet_explorer = function() {
  var nAgt = navigator.userAgent;
  if (nAgt.indexOf("MSIE") != -1) {
    return 1;
  }
  else {
    return 0;
  }
};


Aurita.random = function(length) {
  if(!length) length = 4; 
  return Math.round(Math.random() * Math.exp(10,length)); 
}; 

Aurita.element = function(dom_id) { 
  try { 
    elem = $(dom_id); 
  } catch(e) { 
    elem = false; 
  }
  return elem; 
}; 

Aurita.eval_response = function(response) { 
  if(!response) return; 
  try { 
    return eval('('+response+')'); 
  } catch(excep) { 
    log_debug('Error in eval_response: ' + excep); 
    return; 
  }
}; 

Aurita.get_remote_string = function(action, response_fun, method, postVars) { 
  var xml_conn = new XHConn; 

  req_url = '/aurita/'+action+'&mode=none'; 
  if(method == 'POST') { 
    req_url = action; 
  }
  xml_conn.get_string(req_url, response_fun, method, postVars);
}; 

Aurita.check_username_available = function(result) { 
  if(result.match('true')) { 
      Element.setStyle(Aurita.username_input_element, { 'border-color': '#00ff00' });
  } else { 
      Element.setStyle(Aurita.username_input_element, { 'border-color': '#ff0000' });
  }
};

Aurita.username_available = function(input_element) { 
  if(input_element.value == Aurita.last_username) { return; }
  Aurita.username_input_element = input_element; 
  Aurita.last_username = input_element.value; 
  Aurita.get_remote_string('User_Group/username_available/user_group_name='+input_element.value, 
                           Aurita.check_username_available);
};

Aurita.async_form_submit = function(form_element, params) { 
  context_menu_autoclose = true; 
  target_url   = '/aurita/dispatch'; 
  postVars     = Form.serialize(form_element);

  postVars    += '&mode=async'; 
  // postVarsHash = Form.serialize(form_element, true); 
  
  var xml_conn = new XHConn; 
  element = Aurita.element('dispatcher'); 
  onload_fun = function() { };
  if(params) { onload_fun = params['onload']; }
  xml_conn.connect(target_url, 'POST', Aurita.update_element, element, postVars, onload_fun); 
};

Aurita.handle_form_error = function() { 
  for (var i=0; i < arguments.length; i++) {
    info = arguments[i];
    try { 
      // Get input element by attribute 'name' that is 
      // known from exception: 
      elm  = $$('input[name="' + info.field + '"]').first();
      // Get wrapper by DOM id, which is the same as 
      // the input field's id with '_wrap' appended: 
      wrapper = $(elm.id + '_wrap'); 
      Element.addClassName(wrapper, 'error'); 
      Element.removeClassName(warpper, 'invalid'); 
    } catch(e) { } 
  }
  if(Aurita.context_menu_opened()) { 
    Element.setOpacity('context_menu', 1.0); 
  }
};

Aurita.cancel_form = function(form) { 
  Aurita.Editor.flush_all(); 
  if(Aurita.context_menu.is_opened()) { 
    Element.hide('context_menu'); 
    Aurita.context_menu_close(); 
  } 
  else { 
    history.back(); 
  }
  return true; 
}; 

Aurita.submit_form = function(form, params) { 
  Aurita.Editor.flush_all(); 
  Aurita.async_form_submit(form, params); 
};

Aurita.waiting_for_file_upload = false; 
Aurita.submit_upload_form = function(form_id) { 
  if(Aurita.waiting_for_file_upload) { 
    alert('Ein anderer Upload ist noch aktiv');
    return false;
  }

  if($('public_media_asset_title') && $('autocomplete_tags') && 
     ($('public_media_asset_title').value == '' || $('autocomplete_tags').value == '')) 
  { 
    alert('Bitte machen Sie alle erforderlichen Angaben'); 
    return false; 
  }
  Aurita.waiting_for_file_upload = true; 

  Aurita.Editor.save_all(); 
  Element.toggle(form_id); 
  
  Element.hide('context_menu'); 
  setTimeout('Aurita.context_menu_close()', 2000); 

  $(form_id).submit(); 
  // Delay closing context menu so form values 
  // remain intact at the moment of submit: 
  Aurita.close_info_badge(); 
  new Effect.SlideDown('file_upload_indicator'); 
  if(!Aurita.context_menu_opened()) { 
    setTimeout('Aurita.after_submit_upload_form()', 2000); 
  }
  return false; 
}; 

Aurita.after_submit_upload_form = function() { 
  Aurita.load({ action: 'Wiki::Media_Asset/after_add' }); 
}; 

Aurita.after_file_upload = function() { 
  if(Aurita.waiting_for_file_upload) {
    new Effect.SlideUp('file_upload_indicator'); 
    Aurita.waiting_for_file_upload = false; 
    Aurita.open_info_badge('Wiki::Media_Asset/after_file_upload');
  }
};

Aurita.info_badge_opened = false; 
Aurita.open_info_badge = function(action) { 
  Aurita.close_info_badge(); 
  Aurita.load({ element: 'info_badge', 
                action: action, 
                onload: function() { new Effect.SlideDown('info_badge'); Aurita.info_badge_opened = true; } });
} 
Aurita.close_info_badge = function() { 
  if(Aurita.info_badge_opened) { 
    new Effect.SlideUp('info_badge');
    Aurita.info_badge_opened = false; 
  }
}

Aurita.form_field_onfocus = function(element_id) { 
  Element.addClassName(element_id+'_wrap', 'focussed' ); 
  Element.addClassName(element_id, 'focussed' );
  return true; 
};

Aurita.form_field_onblur = function(element_id) { 
  Element.removeClassName(element_id+'_wrap', 'focussed' ); 
  Element.removeClassName(element_id, 'focussed' );
  return true; 
};

Aurita.handle_invalid_field = function(element) { 
  Element.addClassName(element, 'invalid');
  Element.addClassName(element.id+'_wrap', 'invalid');
}; 

Aurita.validate_form_field_value = function(element, data_type, required) { 
  if(required && (!element.value || element.value == '')) { 
    Aurita.handle_invalid_field(element); 
    return false; 
  }
  switch(data_type) { 
    // Varchar
    case 1043: break; // every input matches varchar
    case 1015: break; // every input matches varchar[]
  }
  // All tests passed, set to valid state again if 
  // failed before: 
  Element.removeClassName(element, 'invalid');
  Element.removeClassName(element.id+'_wrap', 'invalid');
  Element.removeClassName(element.id+'_wrap', 'error');
  return true; 
};


Aurita.flash = function(mesg) { 
  alert(mesg); 
}

Aurita.hierarchy_node_select_onchange = function(field, attribute_name, level) { 
  Aurita.load({ element: attribute_name + '_' + level + '_next', 
                action : 'Wiki::Media_Asset_Folder/hierarchy_node_select_level/media_folder_id__parent='+field.value+'&level='+(level+1) }); 
  $(attribute_name).value = field.value; 
}


///// XHR ///////////////////////////////

Aurita.update_targets            = {}; 
Aurita.current_interface_calls   = {}; 
Aurita.completed_interface_calls = {}; 
Aurita.last_hashvalue            = ''; 
Aurita.wait_for_iframe_sync      = false; 

Aurita.set_ie_history_fix_iframe_src = function(code) 
{ 
  if(Aurita.wait_for_iframe_sync) { 
    return; 
  } 
  var code_url = '/aurita/App_Main/blank/mode=none&code=' + code; 
  $('ie_fix_history_frame').src = code_url;
};
Aurita.set_hashcode = function(code) 
{
  log_debug('set_hashcode: '+code); 
  if(Aurita.check_if_internet_explorer() == 1) {
    Aurita.set_ie_history_fix_iframe_src(code);
  }
  document.location.hash = code; 
  Aurita.force_load = true; 
  Aurita.check_hashvalue(); 
}; 

Aurita.after_update_element = function(element) {
  Aurita.Editor.init_all(); 
}; 

Aurita.on_successful_submit = function() { 
  context_menu_close(); 
}; 

Aurita.convert_response = function(xml_conn)
{
  response_text = xml_conn.responseText; 
  response = { error: false, script: false, html: response_text }; 

  response_script = false; 
  if(response_text.substr(0, 6) == '{ html')
  { 
    log_debug("Convert response html"); 
    try { 
      json_response = eval('(' + response_text + ')'); 
    } catch(excep) { 
      log_debug('Error in eval on response: ' + excep); 
      return; 
    }
    response_html   = json_response.html.replace('\"','"'); 
    response_script = json_response.script.replace('\"','"'); 
    response_error  = json_response.error; 
    if(response_error) { 
      response_error = json_response.error.replace('\"','"'); 
    }
  } 
  else if(response_text.substr(0,8) == '{ script' ) 
  {
    log_debug("Convert response script"); 
    try { 
      json_response = eval('(' + response_text + ')'); 
    } catch(excep) { 
      log_debug('Error in eval on response: ' + excep); 
      return; 
    }
    response_html   = ''
    response_error  = false; 
    response_script = json_response.script.replace('\"','"'); 
  } 
  else if(response_text.substr(0,7) == '{ error' ) 
  {
    log_debug("Convert response error"); 
    try { 
      json_response   = eval('(' + response_text + ')'); 
    } catch(excep) { 
      log_debug('Error in eval on response: ' + excep); 
      return; 
    }
    response_text   = ''
    response_html   = false; 
    response_script = false; 
    Aurita.update_targets = { }; // Break dispatch chain on error, 
                                 // prohibit further actions in interface
    response_error = json_response.error.replace('\"','"'); 
  } 
  else if(response_text.replace(/\s/g,'') == '') { 
    Aurita.on_successful_submit(); 
  }

  response_debug  = json_response.debug; 
  return { html: response_html, error: response_error, script: response_script, debug: response_debug };
};

Aurita.update_element_silently = function(xml_conn, element, request_method, onload_fun)
{
    if(element) { log_debug('Aurita.update_element_silently ' + element.id); }
    else        { log_debug('Aurita.update_element_silently: Target element undefined!'); }

    response_script = false; 
    response_error = false; 
    if(element) 
    {
      response = Aurita.convert_response(xml_conn); 
      response_html   = response['html']; 
      response_script = response['script']; 
      response_error  = response['error']; 
      response_debug  = response['debug'];
      if(response_debug) { log_debug(response_debug); }

    // When to close context menu (no error and no html response, or target element
    // is not context menu)
      if(!response_error && (!element || !response_html))
      {
        context_menu_close(); 
      } 
      if(response_html) { 
        element.innerHTML = response_html; 
      }
    }
    if(response_script) { eval(response_script); }
    if(response_error)  { eval(response_error);  }

    if(onload_fun) { onload_fun(); }
}; 

Aurita.update_element = function(xml_conn, element, request_method, onload_fun)
{
    if(element) { log_debug('Aurita.update_element: ' + element.id); }
    else        { log_debug('Aurita.update_element: No target element'); }

    response = Aurita.convert_response(xml_conn); 
    response_html   = response['html']; 
    response_script = response['script']; 
    response_error  = response['error']; 
    response_debug  = response['debug'];
    // See Cuba::Controller.render_view
    if(element) 
    {
      try { Element.setOpacity(element, 1.0); } catch(e) { }

      if(response_debug) { log_debug(response_debug); }

      // When to close context menu (no error and no html response, or target element
      // is not context menu)
      if(!response_error && (!element || !response_html))
      {
        Aurita.context_menu_close(); 
      } 
      if(response_error) // aurita wants to tell us something
      {
        eval(response_error); 
      }
      element.innerHTML = response_html; 
    }
    if(onload_fun) { 
      onload_fun(element); 
    }
    if(response_script) { eval(response_script); }

    if(Aurita.update_targets) {
      for(var target in Aurita.update_targets) {
        if(Aurita.update_targets[target]) { 
          url = Aurita.update_targets[target].replace('.','/');
          Aurita.load({ element: target, action: url }); 
        }
      }
      // Reset targets so they will be set in next load/remote_submit call: 
      Aurita.update_targets = null; 
    }
    Aurita.after_update_element(element); 
}; 

Aurita.before_load_url = function(element) { 
  try { Element.setOpacity(element, 0.5); } catch(e) { } 
  try { Aurita.Editor.save_all(); } catch(e) { } 
}

Aurita.current_request = false; 
Aurita.load_url = function(params)
{
  log_debug('entering load_url'); 
  target_id = params['element']; 
  if(!target_id) { target_id = 'app_main_content'; }

  element = Aurita.element(target_id); 
  if(!params['silently']) { 
    log_debug('Before load');
    Aurita.before_load_url(element); 
  }

  if(target_id == 'app_main_content' && !params['no_hashvalue'] && !params['onload']) { 
    log_debug('redirect to set_hashcode'); 
    Aurita.current_hashvalue = params['action']; 
    Aurita.last_hashvalue    = params['action']; 
    Aurita.set_hashcode(params['action']);
    return; 
  }

  req_url = ''; 

  if(params['action']) { 
    action_url  = params['action'];
    action_url  = action_url.replace('/aurita/',''); 
    // Are there any params in the request URI?
    if(action_url.match('=')) { 
      action_url += '&'; 
    } else { 
      // If none, does request URI end in a forward slash? 
      if(!action_url.match(/^(.+)\/$/)) { action_url += '/'; }
    }
    action_url += ('element=' + element.id);
    call_arr    = action_url.replace(/([^\/]+)\/([^\/]+)[\/&]?(.+)?/,'$1.$2').replace('/','').split('.');
    model       = call_arr[0]; 
    method      = call_arr[1]; 
    postVars    = 'controller=' + model; 
    postVars   += '&action=' + method; 
    if(!params['mode']) { 
      params['mode'] = 'async';
    }
    postVars += ('&mode=' + params['mode'] + '&');
//  postVars += ('&element=' + element.id + '&');
    postVars += action_url.replace(/([^\/]+)\/([^\/]+)[\/&]?(.+)?/,'$3').replace('/',''); 
    req_url = '/aurita/dispatch'; 
  } 
  else if(params['url']) { 
    req_url = params['url'];
    postVars      = '';
  }
  if(params['silently']) { 
    update_fun = Aurita.update_element_silently; 
  } 
  else { 
  log_debug('LOAD URL'); 
    update_fun = Aurita.update_element; 
  }

  log_debug("Dispatch interface "+req_url);
  
  Aurita.update_targets = params['targets']; 

  var xml_conn = new XHConn; 

  if(params['method'] == 'POST') { 
    xml_conn.connect(req_url, 'POST', update_fun, element, postVars, params['onload']); 
  }
  else { 
    action_url = '/aurita/' + action_url + '&mode=async'; 
    xml_conn.connect(action_url, 'GET', update_fun, element, '', params['onload']); 
  }
}; 

Aurita.prevent_default_onclick = false; 
Aurita.load = function(params) {
  try { 
    Aurita.prevent_default_onclick = true; 
    Aurita.load_url(params); 
    return false; 
    try { 
      if(window.event) { 
//          stopPropagation = true; 
//          window.event.cancelBubble = true; 
      }
    } catch(e) {  } 
  } catch(e) { 
    log_debug(e); 
    return false; 
  } 
  return false; 
}; 

Aurita.display_widget = function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 
    $('app_main_content').innerHTML = widget; 
}; 

/* This returns an implicit closure - be careful with frequent calls! */
Aurita.load_widget_to = function(element) { 
  return function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 
    $(element).innerHTML = widget; 
  }
}; 

/* This returns an implicit closure - be careful with frequent calls! */
Aurita.append_widget_to = function(element) { 
  return function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 
    widget_element = document.createElement('span');
    widget_element.innerHTML = widget; 
    $(element).appendChild(widget_element); 
  }
}; 

Aurita.load_widget = function(widget_name, params, handle_fun) { 
  try { 
    params_string = 'controller=Widget_Service&action=get&widget='+widget_name;
    for(param_name in params) { 
      params_string += '&' + param_name + '=' + params[param_name];
    }
    if(!handle_fun) { handle_fun = Aurita.display_widget; } 
    Aurita.get_remote_string('/aurita/poll', handle_fun, 'POST', params_string); 
  } catch(excep) { 
    log_debug('Could not load widget '+widget_name+'('+params_string+')');
  }
}; 

Aurita.load_silently = function(params) {
  try { 
    if(!$(params['element'])) { 
      log_debug('Target for Aurita.load_silently does not exist: '+params['target']+', using default'); 
    }
    params['targets']  = params['redirect_after']; 
    params['silently'] = true; 
    Aurita.load_url(params); 
    return false; 
  } catch(e) { 
    log_debug(e); 
    return false; 
  } 
}; 

Aurita.call = function(url_req) { 
  if(url_req['action']) { 
    url_req['element'] = 'dispatcher';
    Aurita.load(url_req); 
  }
  else {
    Aurita.load({ action: url_req, element: 'dispatcher' }); 
  }
}; 

Aurita.get_ie_history_fix_iframe_code = function() 
{
  hashcode = false
  try { 
    // Requesting the src attribute is faster, as iframe does not have to be loaded, 
    // but this method is prohibited in most cases: 
    hashcode = parent.ie_fix_history_frame.location.href; 
    hashcode = hashcode.replace(/(.+)?code=([^&]+)/g,"$2"); 
  } catch(e) { }
  return hashcode; 
}

Aurita.current_hashvalue = false; 
Aurita.check_hashvalue = function()
{
    Aurita.current_hashvalue = document.location.hash.replace('#',''); 

    if(Aurita.current_hashvalue.match(/(.+)?_anchor/)) { return;  } 

    if(Aurita.check_if_internet_explorer() == 1) { // IE REACT
      if(Aurita.force_load) { 
        iframe_hashvalue = Aurita.current_hashvalue; 
      }
      else { 
        iframe_hashvalue = Aurita.get_ie_history_fix_iframe_code(); 
      } 

      // Case: Backbutton
      if(iframe_hashvalue && 
      // iframe_hashvalue != 'no_code' && 
         iframe_hashvalue != Aurita.current_hashvalue && 
         !Aurita.force_load && 
         iframe_hashvalue != '' && 
         !iframe_hashvalue.match('about:')) 
      { 
//      if(Aurita.current_hashvalue && Aurita.current_hashvalue != '' && iframe_hashvalue == 'no_code') { 
//        Aurita.current_hashvalue = 'App_General/main/';
//      }
        if(Aurita.current_hashvalue && Aurita.current_hashvalue != '' && iframe_hashvalue != 'no_code') { 
          Aurita.current_hashvalue = iframe_hashvalue; 
        }
      }
    }

    if(Aurita.force_load || Aurita.current_hashvalue != Aurita.last_hashvalue && Aurita.current_hashvalue != '') 
    { 
      log_debug('check_hashvalue load'); 
      window.scrollTo(0,0);

      log_debug('last: ' + Aurita.last_hashvalue); 
      log_debug('new: ' + Aurita.current_hashvalue); 
      Aurita.last_hashvalue = Aurita.current_hashvalue;
      action = Aurita.current_hashvalue.replace(/--/g,'/').replace(/-/,'=');

      Aurita.load({ action: action, 
                    no_hashvalue: true, 
                    onload: function() { Aurita.wait_for_iframe_sync = false; } }); 
      Aurita.force_load = false; 
    } 
}; 

Aurita.last_feedback = { }; 
Aurita.handle_feedback = function(response) 
{
  if(!response) return; 
  try { 
    feedback = eval('('+response+')'); 
  } catch(excep) { 
    log_debug('Error in eval on response: ' + excep); 
    return; 
  }

  if(feedback.unread_mail && Aurita.last_feedback.unread_mail != feedback.unread_mail) { 
    log_debug('-- unread_mail: '+feedback.unread_mail); 
    if(feedback.unread_mail == 0) {
      feedback.unread_mail = ''; 
      $('mailbox_icon').src = '/aurita/images/icons/mailbox.gif'; 
      Element.hide('mail_notifier'); 
    }
    else { 
      feedback.unread_mail = '(' + feedback.unread_mail + ')'; 
      $('mailbox_icon').src = '/aurita/images/icons/mailbox_alert.gif'; 
      $('mail_notifier').innerHTML = feedback.unread_mail; 
      Element.show('mail_notifier'); 
    }
  }
  Aurita.last_feedback = feedback; 
}; 

Aurita.poll_feedback = function()
{
  Aurita.get_remote_string('Async_Feedback/get/x=1', Aurita.handle_feedback); 
}; 

Aurita.confirmed_interface = ''; 
Aurita.unconfirmed_action =  '';  
Aurita.message_box = undefined; 
Aurita.on_confirm_action = false; 

Aurita.after_confirmed_action = function(xml_conn, element) 
{
  // do nothing
}; 

// Usage: 
// <span onclick="Aurita.confirmable({ action: 'Community::Forum_Post/delete/forum_post_id=123', 
//                                     message: 'Really delete post?', 
//                                     onconfirm: function() { alert('Post deleted'); }
//                                  });" >
//   delete post
// </span>
Aurita.confirmable = function(params) {
  req_url = params['action']; 
  message = params['message']; 
  Aurita.message_box = new MessageBox({ action: 'App_Main/confirmation_box/message='+message }); 
  Aurita.unconfirmed_action = req_url; 
  if(params['onconfirm']) { 
    Aurita.on_confirm_action = params['onconfirm']; 
  } 
  else { 
    Aurita.on_confirm_action = false; 
  }
  Aurita.message_box.open();
}; 
Aurita.confirm_action = function() { 
  Aurita.call({ action: Aurita.unconfirmed_action, 
                onupdate: Aurita.after_confirmed_action });
  if(Aurita.on_confirm_action) { Aurita.on_confirm_action(); }
  Aurita.message_box.close(); 
}; 
Aurita.cancel_action = function() { 
  Aurita.message_box.close(); 
}; 

Aurita.tabs = {}; 
Aurita.register_tab_group = function(tab_params) { 
  Aurita.tabs[tab_params.tab_group_id] = tab_params; 
}

var active_messaging_button = false;
Aurita.tab_click = function(tab_group_id, tab_id, tab_name)
{
  tab_params = Aurita.tab_register[tab_group_id]; 
  tabs = tab_params.tabs; 
  
  for(t in tabs) { 
    Element.removeClassName(t, 'active');
  }
  Element.addClassName(tab_id, 'active');

  action_url = tab_params.actions[tab_id]; 

  Aurita.load({ element: tab_content_id, action: action_url }); 
}

Aurita.poll_load = function(elem_id, url, seconds)
{
  setInterval(function() { 
    Aurita.load({ element: elem_id, action: url, silently: true }) 
  }, seconds * 1000);
}; 

Aurita.poll_call = function(elem_id, url, seconds)
{
  setInterval(function() { 
    Aurita.call({ element: elem_id, action: url, silently: true }) 
  }, seconds * 1000);
} 


///////////////////////////////////////////////////////
// END aurita
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN error
///////////////////////////////////////////////////////

Aurita.notify_error = function(error_code, form_element, message) { 
  Element.setStyle(form_element_id, { borderColor: '#990000' } ); 
  if(message) { 
    $(form_element_id+'_message').innerHTML = message; 
    Element.show(form_element_id+'_message'); 
  }
  try { Element.show(button_id+'_form_buttons'); } catch(e) {}; 
  try { Element.show('main_form_buttons'); } catch(e) {};  
  try { if(Aurita.context_menu.is_opened()) { Element.setOpacity('context_menu', 1.0); } } catch(e) {}; 
  init_all_editors(); 
}

///////////////////////////////////////////////////////
// END error
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN backbutton
///////////////////////////////////////////////////////


function PageLocator(propertyToUse, dividingCharacter) {
    this.propertyToUse = propertyToUse;
    this.defaultQS = 1;
    this.dividingCharacter = dividingCharacter;
}
PageLocator.prototype.getLocation = function() {
    return eval(this.propertyToUse);
}
PageLocator.prototype.getHash = function() {
    var url = this.getLocation();
    if(url.indexOf(this.dividingCharacter) > -1) {
        var url_elements = url.split(this.dividingCharacter);
        return url_elements[url_elements.length-1];
    } else {
        return this.defaultQS;
    }
}
PageLocator.prototype.getHref = function() {
    var url = this.getLocation();
    var url_elements = url.split(this.dividingCharacter);
    return url_elements[0];
}
PageLocator.prototype.makeNewLocation = function(new_qs) {
    return this.getHref() + this.dividingCharacter + new_qs;
}


///////////////////////////////////////////////////////
// END backbutton
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN message_box
///////////////////////////////////////////////////////

function MessageBox(params)
{
    var m_action  = params['action'];
    var m_content = params['content']; 

    var fill_box = function(message_string) { 
      $('message_box').innerHTML = message_string; 
      show(); 
    };
    var show = function()
    {
      offset = (screen.width-(Element.getDimensions('message_box').width+1)) / 2; 
      Element.setStyle('message_box', { 'left': '50%' }); 
      Element.setStyle('message_box', { 'marginLeft': '-100px', 
                                        'left': '50%', 
                                        'top': '200px',
                                        'display': '' }); 
        scrollTo(0,0); 
    };
    
    this.open = function()
    {
      if(m_content) { 
        $('message_box').innerHTML = m_content; 
        show(); 
      } else {
        Aurita.get_remote_string(m_action, fill_box); 
      }
      m_opened = true; 
      new Draggable('message_box'); 
    };

    this.close = function() {
      $('message_box').innerHTML = ''; 
      Element.setStyle('message_box', { 'display': 'none' });
      Element.setStyle('cover', { 'display': 'none' }); 
    };

}

///////////////////////////////////////////////////////
// END message_box
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN context_menu
///////////////////////////////////////////////////////

var context_menu_cache = {};  
var ie_right_click = false; 
function ContextMenu(menu_element_id, params)
{
    var m_menu = document.getElementById(menu_element_id);
    var m_active_element_id; 
    var m_highlight_element_id; 
    var m_focussed_element_id; 

    var m_opened = false; 
    var m_autoclose = true; 

    var m_interface;
    var m_clicked_element_id;
    var m_args; 

    var m_other_interface; 
    var m_other_clicked_element_id; 
    var m_other_args; 

    var m_params = params; 
    var m_no_focus = false; 

    var m_active   = true; 

    var m_init_fun = false; 

    this.is_opened = function() { return m_opened; };

    //////////////////////////////////////////////////////////////////
    var open_menu = function(params) {

        if(!params['force_open']) { 
          if(!m_clicked_element_id) { return; }
        //  if(!is_mouse_over($(m_clicked_element_id))) { return; }
        }
        m_init_fun = params.init_fun; 
        m_no_focus = params.no_focus; 
        m_menu.innerHTML = '<img src="/aurita/images/icons/loading.gif" border="0" />'; 
        Element.setOpacity(m_menu, 1.0); 
        Element.show(m_menu); 

        if(m_opened && m_clicked_element_id != m_active_element_id) { 
            close_menu(); // close old context menu
        } 
        else if(m_opened && m_clicked_element_id == m_active_element_id) {
            return; 
        }
        
        m_active_element_id = m_clicked_element_id; 
        
        m_autoclose = params['autoclose']; 
        if(params.targets) { m_update_targets = params.targets; }
        if(params.url)     { m_interface      = params.url; }

        m_interface += '&mode=none'; 
        if(context_menu_cache[m_interface]) { 
          log_debug('Loading context menu from cache'); 
          m_menu.innerHTML = context_menu_cache[m_interface];
          show(); 
          if(m_init_fun) m_init_fun(); 
        }
        else {
            m_menu.innerHTML = '<img src="/aurita/images/icons/loading.gif" border="0" />'; 
            
            var xml_conn = new XHConn; 
            params['onupdate'] = update_menu;
            xml_conn.connect(m_interface, 'GET', params['onupdate'], m_menu); 
        }
        m_opened = true; 

    }; 

    this.no_autoclose = function() { 
      m_autoclose = false; 
    }; 

    this.set = function(params) {     
       
      m_autoclose = params['autoclose']; 
      if(params.targets) { Aurita.update_targets = params.targets; }
      if(params.url)     { m_interface         = params.url; }

      m_interface += '&mode=none'
      m_menu.innerHTML = '<img src="/aurita/images/icons/loading.gif" border="0" />'; 

      var xml_conn = new XHConn; 
      if(!params['onupdate']) params['onupdate'] = update_menu;
      m_init_fun = params.init_fun; 
      m_no_focus = params.no_focus; 
      xml_conn.connect(m_interface, 'GET', params['onupdate'], m_menu); 
      
      m_opened = true; 
    };

    //////////////////////////////////////////////////////////////////
    var update_menu = function(xml_conn, element) {
      if(element) {
        response = xml_conn.responseText;
        
        abort = false; 
        if(response.length < 10) {
          stripped = response.replace(/^([\s|\n])+/g,'');
          if(stripped == '') { abort = true; }
        }
        if(abort) {
            Aurita.context_menu_close(); 
        } 
        else {
          show(); 
    
          element.innerHTML = response;
          context_menu_cache[m_interface] = response; 
          log_debug('menu init_fun: '+m_init_fun); 
          if(m_init_fun) m_init_fun(); 
        }
      }
    };

    var show = function() { 
      Element.setStyle(m_menu, { display: '' }); 
      if(m_clicked_element_id && !m_no_focus) { 
        if(!m_focussed_element_id) { 
          // Enable for focussing on context menu load (instead immediately on click)
          // focus_element(m_highlight_element_id); 
          // m_focussed_element_id = m_highlight_element_id; 
          log_debug('focussing ' + m_highlight_element_id); 
        } 
      }
    }; 
    
    //////////////////////////////////////////////////////////////////
    var close_menu = function() {
        if(m_opened) {
            // IE fix: 
            m_opened = false; 
            Element.setStyle(m_menu, { display: 'none' }); 
            unfocus_element(m_focussed_element_id); 
            $('context_menu').innerHTML = ''; 
        } 
    };
    this.open = function(params) { 
      params['url'] = '/aurita/'+params.url;
      log_debug('Opening context menu with interface '+params.url);
      log_debug('init_fun: '+params.init_fun); 
      open_menu(params);
    }; 

    this.close = function() { 
        close_menu(); 
    }; 

    this.enable = function() { 
       m_enabled = true;
    }; 
    this.disable = function() { 
       m_enabled = false;
    }; 
    this.activate = function() { 
       m_active = true;
    }; 
    this.deactivate = function() { 
       m_active = false;
    }; 
    this.is_active = function() { 
      return m_active; 
    }
    this.is_opened = function() { 
       return m_opened; 
    }; 

    //////////////////////////////////////////////////////////////////
    this.element_hover = function(type, args, elem_id, highlight_element_id) {
      if(highlight_element_id) m_highlight_element_id = highlight_element_id; 
      else m_highlight_element_id = elem_id; 
      type_parts = type.split('::'); 
      context_menu_controller = ''; 
      if(type_parts.length > 1) { 
        context_menu_controller = type_parts[0] + '::Context_Menu'; 
        type = type_parts[1].toLowerCase(); 
      } else {
        context_menu_controller = 'Context_Menu'; 
      }
      m_clicked_element_id = elem_id; 
      m_args = args; 
      m_interface = '/aurita/'+context_menu_controller+'/'+type.toLowerCase()+'/'+args;
    };

    //////////////////////////////////////////////////////////////////
    this.handle_click = function(ev, is_right_click) {
      if(!m_active) { return true; }
      if(!ev) { ev = window.event; }
    // ?  var is_right_click = false; 
      if(ev) { 
        if(ev.button && ev.button == 2) { is_right_click = true; }
        if(ev.which && ev.which == 3)   { is_right_click = true; }
        if(ie_right_click)              { is_right_click = true; ie_right_click = false; }
      }
      
      capture_mouse(ev); 

      if(m_opened && m_autoclose == true && !is_mouse_over(m_menu)) {
        close_menu(); 
      }
      
      if(ie_right_click || is_right_click || Aurita.enable_left_click_menu) {

          Aurita.enable_left_click_menu = false; 

          mouse_coords = get_mouse(ev); 
          Element.setStyle('context_menu', { left: mouse_coords[0]+'px', top: mouse_coords[1]+'px', display: '' }); 
          
          unfocus_element(m_focussed_element_id); 
          m_focussed_element_id = m_highlight_element_id; 

          if(m_opened && m_other_clicked_element_id != undefined) {
            m_clicked_element_id = m_other_clicked_element_id; 
            m_args       = m_other_args; 
            m_interface  = m_other_interface; 
          }
          if(m_enabled) { 
            focus_element(m_highlight_element_id); 
            m_focussed_element_id = m_highlight_element_id; 
            open_menu({ autoclose: true }); 
          } else { 
            Element.hide(m_menu); 
          }
          return false; 
      } else { 
        if(window.event) { 
          // return true if default action is to be performed, false otherwise:
          prevent_click = Aurita.prevent_default_onclick; 
          Aurita.prevent_default_onclick = false; 
          return !prevent_click; 
        } 
        else { 
          return true
        }
      }
    };

    this.handle_key = function(ev) { 

      if(!m_opened && ev.which == 109) { // only act on char 'm'
          m_menu.style.left = mouse_x;
          m_menu.style.top = mouse_y;
          
          if(m_opened && m_other_clicked_element_id != undefined) {
          m_clicked_element_id = m_other_clicked_element_id; 
          m_args       = m_other_args; 
          m_interface  = m_other_interface; 
          }
          open_menu({ autoclose: true }); 
      }
    };

    return this; 
}
Aurita.context_menu = new ContextMenu('context_menu'); 

Aurita.enable_left_click_menu = false; 

Aurita.context_menu_click = function(params)
{
    Aurita.context_menu.no_autoclose(); 
    Element.hide('context_menu'); 
    Aurita.load({ element: 'context_menu', 
                  action: params.url, 
                  onload: function() { Aurita.GUI.center_element('context_menu'); } }); 
}; 

Aurita.context_menu_close = function()
{
    Aurita.context_menu.close(); 
    if(Aurita.message_box) { 
      Aurita.message_box.close();
    } 
}; 

// Function to use on elements providing a 
// context menu (onMouseOver). Sets states for 
// context menu to be opened on right-click, but 
// doesn't open it itself. 
Aurita.last_hovered = false; 
Aurita.context_menu_over = function(type, args, elem_id, highlight_element_id) 
{
  Aurita.context_menu.element_hover(type, args, elem_id, highlight_element_id); 

  if(Aurita.last_hovered) { 
    Element.removeClassName(Aurita.last_hovered, 'context_hover'); 
  }
  if(highlight_element_id) { elem_id = highlight_element_id; } 

  if(!Aurita.context_menu_opened()) { 
    Element.addClassName(elem_id, 'context_hover'); 
    if($(elem_id+'_wrap')) { 
      Element.show(elem_id+'_wrap'); 

      if(Aurita.last_hovered != elem_id && $(Aurita.last_hovered+'_wrap')) { 
        Element.hide(Aurita.last_hovered+'_wrap'); 
      }
    }
  }
  Aurita.last_hovered = elem_id; 
  Aurita.context_menu.enable(); 
}; 

Aurita.context_menu_opened = function() { 
  return Aurita.context_menu.is_opened(); 
}; 

Aurita.context_menu_out = function(element) 
{ 
  Aurita.context_menu.disable(); 
  Element.removeClassName(Aurita.last_hovered, 'context_hover'); 
  if($(Aurita.last_hovered+'_wrap')) { 
    Element.hide(Aurita.last_hovered+'_wrap'); 
    Aurita.enable_left_click_menu = false; 
  }
}; 

Aurita.open_context_menu = function() { 
  Aurita.enable_left_click_menu = true; 
  Aurita.context_menu.handle_click(false, true); 
};



///////////////////////////////////////////////////////
// END context_menu
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN aurita_gui
///////////////////////////////////////////////////////
Aurita.GUI = { 

  init_left : function(element)
  {
     log_debug('init left'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('left_column_components');
     Element.show(element); 
  }, 
  init_main : function(element)
  {
     log_debug('init main'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('workspace_components');
     Element.show(element); 
  }, 
        
  load_layout : function(setup_name)
  {
    log_debug('load layout '+setup_name); 
    Aurita.load({ element: 'app_left_column', action: setup_name+'/left/', onload: function() { Element.show('app_left_column'); } } ); 
    Aurita.load({ action: setup_name+'/main/' }); 
  }, 

  active_button : false, 
  switch_layout : function(setup_name)
  {
    Element.hide('app_left_column'); 
//    Element.hide('app_main_content'); 
    if(active_button) { 
      active_button.className = 'header_button';
    }

    active_button = document.getElementById('button_'+setup_name.replace('::','__')); 
    active_button.className = 'header_button_active';

    Aurita.GUI.load_layout(setup_name); 
    return; 

    setTimeout(function() { Aurita.GUI.load_layout(setup_name) }, 550); 
  }, 


  toggle_box : function(box_id) { 
    log_debug('toggling '+box_id); 

    collapsed_boxes = getCookie('collapsed_boxes'); 
    if(collapsed_boxes) { 
      collapsed_boxes = collapsed_boxes.split('-'); 
    } else { 
      collapsed_boxes = []; 
    }
    if($('collapse_icon_'+box_id).src.match('plus.gif')) { 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/minus.gif'
      box_id_string = ''
      for(b=0; b<collapsed_boxes.length; b++) {
        bid = collapsed_boxes[b]; 
        if(bid != box_id) { 
          box_id_string +=  bid + '-';
        }
      }
      setCookie('collapsed_boxes', box_id_string); 
      log_debug('Slide down'); 
//    new Effect.SlideDown(box_id + '_body', { duration: 0.5 });
      Element.show(box_id + '_body'); 
    } else { 
      collapsed_boxes.push(box_id); 
      setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
      log_debug('Slide up'); 
//    new Effect.SlideUp(box_id + '_body', { duration: 0.5 });
      Element.hide(box_id + '_body'); 
    }
  }, 

  close_box : function(box_id) { 
    if($(box_id + '_body')) { 
      Element.hide(box_id + '_body'); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
    }
  }, 

  collapse_boxes : function() 
  {
     collapsed_boxes = getCookie('collapsed_boxes'); 
     if(collapsed_boxes) {
       collapsed_boxes = collapsed_boxes.split('-'); 
       for(b=0; b<collapsed_boxes.length; b++) { 
         box_id = collapsed_boxes[b]; 
         if($(box_id)) { 
           Aurita.GUI.close_box(box_id); 
         }
       }
     }
  }, 

  calendar : false, 
  open_calendar : function(field_id, button_id)
  {
    log_debug('opening calendar'); 
    
    var onSelect = function(calendar, date) { 
      $(field_id).value = date; 
      if (calendar.dateClicked) {
          calendar.callCloseHandler(); // this calls "onClose" (see above)
      };
    }
    var onClose = function(calendar) { calendar.hide(); }; 

    Aurita.GUI.calendar = new Calendar(1, null, onSelect, onClose);
    Aurita.GUI.calendar.create(); 
    Aurita.GUI.calendar.showAtElement($(field_id), 'Bl'); 
  }, 


  set_dialog_link : function(url) { 
    plaintext = Aurita.temp_range.text; 
    url = 'http://' + url.replace('http://',''); 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="'+url+'" target="_blank">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="'+url+'" target="_blank">'+Aurita.temp_range+'</a>');
    }
    Aurita.context_menu_close(); 
  }, 

  center_element : function(element_id) { 
    var d = document; 
    var rootElm = (d.documentelement && d.compatMode == 'CSS1Compat') ? d.documentelement : d.body

    var vpw = self.innerWidth ? self.innerWidth : rootElm.clientWidth; // viewport width 
    var vph = self.innerHeight ? self.innerHeight : rootElm.clientHeight; // viewport height 

    var elem_width  = $(element_id).getWidth(); 
    var elem_height = $(element_id).getHeight(); 

    var scroll_top = (window.pageYOffset)? window.pageYOffset : document.scrollTop; 

    var pos_left = ((vpw - elem_width) / 2); 
    var pos_top  = ((scroll_top + vph) - (elem_height/2)); 

    new Effect.Move(element_id, { 
      x: pos_left, 
      y: (scroll_top + 180), 
      mode: 'absolute', 
      afterFinish: function() { Element.show('context_menu'); }, 
      duration: 0
    });
  }, 
  
  reorder_hierarchy_id : false, 
  on_hierarchy_entry_reorder : function(entry)
  {
      position_values = Sortable.serialize(entry.id);
      Aurita.load_silently({ element: 'dispatcher', 
                             method: 'POST', 
                             action: 'Hierarchy/perform_reorder/' + position_values + '&hierarchy_id=' + reorder_hierarchy_id }); 
  }, 

  init_sortable_components : function(container, params) { 
    params['format']   = /^component_(.+)$/;
    params['onUpdate'] = function(container) { 
      position_values = Sortable.serialize(container.id); 
      Aurita.call({ method: 'POST', 
                    action: 'Component_Position/set/'+position_values+'&context='+container.id }); 
    }
    Sortable.create(container, params)
  }


};


///////////////////////////////////////////////////////
// END aurita_gui
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN editor
///////////////////////////////////////////////////////

Aurita.Editor = { 

  tinyMCE : tinyMCE, 
  registered_editors : {}, 

  flush_all : function() {
    log_debug('Aurita.Editor.flush_register');
    for(var editor_id in Aurita.Editor.registered_editors) {
      try { 
        Aurita.Editor.flush(editor_id);     
      } catch(e) { 
        log_debug('Exception in Aurita.Editor.flush_all('+editor_id+'): '+e.message); 
      }
    }
    Aurita.Editor.registered_editors = {}; 
  }, 

  init : function(textarea_element_id) 
  {
    if(!$(textarea_element_id)) { log_debug('No element'); return; }
    if(!Aurita.Editor.registered_editors[textarea_element_id] || 
        Aurita.Editor.registered_editors[textarea_element_id] == null) 
    { 
      if(Element.hasClassName(textarea_element_id, 'saving')) { 
        log_debug('Editor ' + textarea_element_id + ' is saving, skipping init'); 
        return; 
      }
      log_debug('Aurita.Editor.init ' + textarea_element_id); 
      Aurita.Editor.registered_editors[textarea_element_id] = textarea_element_id; 
      try { 
        Element.setStyle(textarea_element_id, { visibility: true }); 
      } catch(e) { 
        log_debug('Exception in Aurita.Editor.init: ' + e.message); 
      }
      if(Element.hasClassName(textarea_element_id, 'full')) { 
        Aurita.Editor.switch_mode_full(); 
      }
      if(Element.hasClassName(textarea_element_id, 'simple')) { 
        Aurita.Editor.switch_mode_simple(); 
      }
      tinyMCE.execCommand('mceAddControl', false, textarea_element_id); 
    }
    else { 
      log_debug('Editor already in register, skipping init'); 
    }
  }, 

  save : function(textarea_element_id) 
  {
    if(!$(textarea_element_id)) { log_debug('No element'); return; }
    if(Aurita.Editor.registered_editors[textarea_element_id] &&
       Aurita.Editor.registered_editors[textarea_element_id] != null) 
    { 
      log_debug('Aurita.Editor.save ' + textarea_element_id); 
      Element.addClassName(textarea_element_id, 'saving');
  //  tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
      tinyMCE.triggerSave(false,true);
      Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
      tinyMCE.execCommand('mceRemoveControl', false, textarea_element_id);
    }
    else { 
      log_debug('Editor not in register, skipping save'); 
    }
  }, 

  flush : function(textarea_element_id)
  {
    if(!$(textarea_element_id)) { log_debug('No element'); return; }
    if(Aurita.Editor.registered_editors[textarea_element_id] &&
       Aurita.Editor.registered_editors[textarea_element_id] != null) 
    { 
      log_debug('Aurita.Editor.flush ' + textarea_element_id); 
      Element.addClassName(textarea_element_id, 'saving');
      Aurita.Editor.registered_editors[textarea_element_id] = null; 

      Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
      log_debug('flushing '+textarea_element_id); 
  //  tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
      tinyMCE.triggerSave(false,true);
      tinyMCE.execCommand('mceRemoveControl', false, textarea_element_id);
      tinyMCE.triggerSave(false, true);
    } 
    else { 
      log_debug('Editor not in register, skipping flush'); 
    }
  },

  init_all : function(element) {
//   try { 
      // Could be necessary: 
//    Aurita.Editor.flush_all(element); 
      log_debug('Aurita.Editor.init_all'); 
      elements = document.getElementsByTagName('textarea');
      if(!elements || elements == undefined || elements == null) { 
        log_debug('elements in init_all_editors is undefined'); 
        return; 
      }
      if(elements == undefined || !elements.length) { 
        log_debug('Error: elements.length in init_all_editors is undefined'); 
        return; 
      }
      for (var i = 0; i < elements.length; i++) {
        elem_id = elements.item(i).id; 
        log_debug('entry in register for '+elem_id+': '+Aurita.Editor.registered_editors[elem_id]); 
        if(Aurita.Editor.registered_editors[elem_id] == null) { 
          log_debug('Found textarea to initialize: ' + elem_id);
          inst = $(elem_id); 
          if(inst && Element.hasClassName(inst, 'editor')) { Aurita.Editor.init(elem_id); }
        }
      }
//   } catch(e) { 
//     log_debug('Catched Exception in Aurita.Editor.init_all:' + e.message); 
//     return; 
//   }
  }, 

  save_all : function(element) {
//    try { 
      var inst = false; 
      log_debug('Aurita.Editor.save_all'); 
      Aurita.Editor.flush_all(); 
      elements = document.getElementsByTagName('textarea');
      if(!elements || elements == undefined || elements == null) { 
        log_debug('No textareas found in document, nothing to save. '); 
        return; 
      }
      for (var i = 0; i < elements.length; i++) {
        elem_id = elements.item(i).id; 
          inst = $(elem_id);
        if(inst && Element.hasClassName(inst, 'editor')) { 
          Aurita.Editor.save(elem_id); 
        }
      }
//    } catch(e) { 
//      log_debug('Catched Exception in Aurita.Editor.save_all: ' + e); 
//      return; 
//    }
  }, 

  switch_mode_full : function() { 
    tinyMCE.init({
      // do not provide mode! Editor inits are handled event-based when needed. 
      mode: 'specific_textareas', 
      editor_selector : "full", 
      plugins : "autoresize,safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras",
      theme : "advanced",
      relative_urls : true,
      valid_elements : "*[*]",
      extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
      content_css : "/aurita/shared/editor_content_full.css",
      theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
      theme_advanced_toolbar_align : "left", 
      theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,|,formatselect,removeformat,|,insertdate,inserttime,|,forecolor,backcolor", 
      theme_advanced_buttons2 : "bullist,numlist,outdent,indent,|,tablecontrols,|,hr,fullscreen", 
      theme_advanced_buttons3 : "", 
      theme_advanced_toolbar_location : "top", 
      theme_advanced_resizing : false, 
      auto_resize : true,
      language : "de", 
      setup : function(editor) { 
        editor.addButton('aurita_save', { 
                          title : 'Speichern', 
                          image : '/aurita/images/icons/editor_save.gif', 
                          onclick : function() { 
                            Aurita.submit_form('container_form_xxxx'); 
                          }
        }); 
        editor.addButton('aurita_cancel', { 
                          title : 'Abbrechen', 
                          image : '/aurita/images/icons/editor_cancel.gif', 
                          onclick : function() { 
                            Aurita.Editor.save_all(); 
                            Aurita.load({ action : 'Wiki::Article/show/article_id=xxxx' });  
                          }
        }); 
      }
    });
  }, 

  switch_mode_simple : function() { 
    tinyMCE.init({
      mode: 'specific_textareas', 
      editor_selector : "simple", 
      plugins : "safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras",
      theme : "advanced",
      relative_urls : true,
      valid_elements : "*[*]",
      extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
      content_css : "/aurita/shared/editor_content_simple.css",
      theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
      theme_advanced_toolbar_align : "left", 
      theme_advanced_buttons1 : "bold,italic,underline,strikethrough,removeformat,|,bullist,numlist,|,insertdate,inserttime,|,forecolor,backcolor", 
      theme_advanced_buttons2 : "", 
      theme_advanced_buttons3 : "", 
      theme_advanced_toolbar_location : "top", 
      theme_advanced_resizing : false, 
      auto_resize : false,
      language : "de"

    });
  }

}; 

///////////////////////////////////////////////////////
// END editor
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN login
///////////////////////////////////////////////////////

var Login = { 

  check_success: function(success)
  {
    var failed = true; 

    if(success != "\n0\n") 
    { 
      user_params = eval(success); 
      if(user_params.session_id) {
        setCookie('cb_login', user_params.session_id, 0, '/'); 
        failed = false; 
      }
    }
    if(failed) 
    {
      new Effect.Shake('login_box'); 
    }
    else { 
      new Effect.Fade('login_box', {queue: 'front', duration: 1}); 
//    new Effect.Appear('start_button', {queue: 'end', duration: 1}); 
      document.location.href = '/aurita/App_Main/start/';
    }
  },

  remote_login: function(login, pass)
  {
    login = MD5(login); 
    pass  = MD5(pass); 
    Aurita.get_remote_string('App_Main/validate_user/mode=async&login='+login+'&pass='+pass, Login.check_success); 
  }

} // Namespace Login

///////////////////////////////////////////////////////
// END login
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN main
///////////////////////////////////////////////////////

Aurita.Main = { 

  init_login_screen : function(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
  }, 

  autocomplete_username_handler : function(text, li)
  {
    generic_id = text.id; 
  }, 
  
  init_autocomplete_tags : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             parameters: 'controller=Autocomplete&action=tags&mode=none'
                           }
    );
  }, 

  autocomplete_single_tag : function(li)
  {
    tag = li.id.replace('tag_',''); 
    Aurita.load({ element: 'tag_form', action: 'Tag_Synonym/show/tag='+tag });
    return true; 
  }, 

  init_autocomplete_tag_selection : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             updateElement: Aurita.Main.autocomplete_single_tag, 
                             parameters: 'controller=Autocomplete&action=tags&mode=none'
                           }
    );
  }, 

  init_autocomplete_username : function()
  {
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_selected_users : {}, 
  init_autocomplete_single_username : function()
  {
    Aurita.Main.autocomplete_selected_users = {}; 
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: Aurita.Main.autocomplete_single_username_handler, 
                             frequency: 0.1, 
                             tokens: [], 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_single_username_handler : function(li)
  {
    $('autocomplete_username').value = ''; 
    uname = li.innerHTML.replace(/^.+<b>([^>]+?)<\/b>.+$/i,'$1'); // username is in <b> tag
    uid = li.id.replace('user__',''); 
    entry =  '<li id="user_group_id_'+uid+'">'
    entry += '<input type="hidden" name="user_group_ids[]" value="'+uid+'" />'
    entry += '<a class="icon" onclick="Element.remove(\'user_group_id_'+uid+'\');"><img src="/aurita/images/icons/delete_small.png" /></a>'+uname+'</li>';
    $('user_group_ids_selected_options').innerHTML += entry; 

    return true; 
  }, 

  category_selection_add : function(category_field_id)
  {
    var category_select_field_id = category_field_id + '_select'; 
    var category_list_id         = category_field_id + '_selected_options';
    var category_id              = $F(category_select_field_id); // Selected value of category select field
    var selected_option          = $A($(category_select_field_id).options).find(function(option) { return option.selected; } );
    category_name                = selected_option.text; 

    entry =  '<li id="public_category_category_id_'+category_id+'">'
    entry += '<input type="hidden" name="category_ids[]" value="'+category_id+'" />'
    entry += '<a class="icon" onclick="Element.remove(\'public_category_category_id_'+category_id+'\');"><img src="/aurita/images/icons/delete_small.png" /></a>'+category_name+'</li>';
    $(category_list_id).innerHTML += entry; 

    Element.remove(selected_option); 
    return true; 
  } 

}; 

///////////////////////////////////////////////////////
// END main
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN wiki
///////////////////////////////////////////////////////

Aurita.Wiki = { 

  autocomplete_article_handler : function(text, li) { 
    plaintext = Aurita.temp_range.text; 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>');
    }
    context_menu_close(); 
  }, 

  autocomplete_link_article_handler : function(text, li) { 
    plaintext = Aurita.temp_range.text; 
    hashcode = text.id.replace('__','--'); 
    onclick = "Aurita.set_hashcode(&apos;"+hashcode+"&apos;); "; 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+hashcode+'" onclick="'+onclick+'">'+Aurita.temp_range+'</a>');
    }
    context_menu_close(); 
  }, 

  init_autocomplete_articles : function(xml_conn, element, update_source)
  {
    element.innerHTML = xml_conn.responseText; 
    new Ajax.Autocompleter("autocomplete_article", 
                           "autocomplete_article_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: autocomplete_article_handler, /* TODO: Handler doesn't exist any more?! */
                             tokens: [' ',',','\n']
                           }
    );
  }, 

  init_link_autocomplete_articles : function()
  {
    new Ajax.Autocompleter("autocomplete_link_article", 
                           "autocomplete_link_article_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: autocomplete_link_article_handler, 
                             tokens: [' ',',','\n'], 
                             parameters: 'controller=Autocomplete&action=articles&mode=async'
                           }
    );
  }, 

  on_article_reorder : function(container)
  {
    position_values = Sortable.serialize(container.id);
    Aurita.call({ method : 'POST', 
                  action : 'Wiki::Article/perform_reorder/' + position_values + 
                           '&content_id_parent=' + Aurita.Wiki.reorder_article_content_id }); 
  }, 

  init_article_reorder : function(article_content_id)
  {
      Aurita.Wiki.reorder_article_content_id = article_content_id; 
      Sortable.create("article_partials_list", 
                      { dropOnEmpty: true, 
                        onUpdate: Aurita.Wiki.on_article_reorder, 
                        handle: true }); 
  }, 

  init_article : function(xml_conn, element, update_source)
  {
      element.innerHTML = xml_conn.responseText; 
  }, 

  attachment_text_asset_content_id : false, 
  init_container_attachment_editor : function(article_id, text_asset_content_id) { 
    
  }, 

  handle_container_attachment : function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 

    $('selected_media_assets').innerHTML += widget; 
  }, 

  // mark_image : function(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix, desc)
  add_container_attachment : function(media_asset_id) 
  {
    Aurita.load_widget('Wiki::Media_Asset_Selection_Thumbnail', 
                       { media_asset_id: media_asset_id, size: 'tiny' }, 
                       Aurita.Wiki.handle_container_attachment); 
  }, 

  init_container_inline_editor : function(xml_conn, element, update_source)
  {
      element.innerHTML = xml_conn.responseText; 
      Element.setOpacity(element, 1.0); 
      init_all_editors(); 
  }, 

  opened_select_box : false, 
  select_media_asset : function(params) {
      var hidden_field_id = params['hidden_field']; 
      var user_id = params['user_id']; 
      var hidden_field = $(hidden_field_id); 
      var select_box_id = 'select_box_'+hidden_field_id;
      select_box = $(select_box_id); 
      Aurita.Wiki.opened_select_box = select_box; 
      Aurita.load({ element: select_box_id, 
                    action: 'Wiki::Media_Asset/choose_from_user_folders/user_group_id='+user_id+'&image_dom_id='+hidden_field_id }); 
      Element.setStyle(select_box, { display: 'block' });
      Element.setStyle(select_box, { width: '100%' });
  }, 

  select_media_asset_click : function(media_asset_id, element_id) { 
      var hidden_field = $(element_id);
      var image = $('picture_asset_'+element_id); 

      image.src = ''; 
      if(media_asset_id == 0) { 
        image.style.display = 'none';
        hidden_field.value = '1'; 
        $('clear_selected_image_button'+element_id).style.display = 'none'; 
      } else { 
        image.src = '/aurita/assets/medium/asset_'+media_asset_id+'.jpg';
        image.style.display = 'block';
        hidden_field.value = media_asset_id; 
        $('clear_selected_image_button_'+element_id).style.display = ''; 
      }
      try { 
        if(Aurita.Wiki.opened_select_box) { 
          Element.hide(Aurita.Wiki.opened_select_box); 
          Aurita.Wiki.opened_select_box = false; 
        }
      } catch(e) { }
  }, 

  expanded_folder_ids : {}, 
  load_media_asset_folder_level : function(parent_folder_id, indent) {
    if($('folder_expand_icon_'+parent_folder_id)) { 
      if($('folder_expand_icon_'+parent_folder_id).src.match('folder_collapse.gif')) { 
        $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_expand.gif'; 
        Aurita.Wiki.expanded_folder_ids[parent_folder_id] = false; 
        Element.hide('folder_children_'+parent_folder_id); 
        return;
      }
      else { 
        Element.show('folder_children_'+parent_folder_id); 
        Aurita.Wiki.expanded_folder_ids[parent_folder_id] = true; 
        $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_collapse.gif'; 
        if($('folder_children_'+parent_folder_id).innerHTML.length < 10) { 
          Aurita.load({ element: 'folder_children_'+parent_folder_id, 
                        action: 'Wiki::Media_Asset_Folder/tree_box_level/media_folder_id='+parent_folder_id+'&indent='+indent }); 
        }
      }
    }
  }, 

  open_folder : 0, 
  change_folder_icon : function(value) { 
    folder_to_open = $("folder_icon_" + value);
    folder_to_close = $("folder_icon_" + Aurita.Wiki.open_folder);
    if(folder_to_close) { 
      folder_to_close.src = "/aurita/images/icons/folder_closed.gif"; 
    }
    if(folder_to_open) { 
      folder_to_open.src = "/aurita/images/icons/folder_opened.gif"; 
    }
    Aurita.Wiki.open_folder = value;
  }, 

  recently_viewed : [], 
  recently_viewed_titles : [], 
  recently_viewed_models : [], 
  add_recently_viewed : function(model, asset_id, title) { 
    Aurita.Wiki.recently_viewed_titles[asset_id] = title; 
    Aurita.Wiki.recently_viewed_models[asset_id] = model; 

    if(Aurita.Wiki.recently_viewed.indexOf(asset_id) != -1) { 
      // remove previous appearance of asset_id from list: 
      Aurita.Wiki.recently_viewed.splice(Aurita.Wiki.recently_viewed.indexOf(asset_id), 1); 
    }
    else { 
      // remove last asset_id from list: 
      if(Aurita.Wiki.recently_viewed.length > 10) Aurita.Wiki.recently_viewed.shift(); 
    }
    Aurita.Wiki.recently_viewed.push(asset_id); 
    template = $('recently_viewed_element_template').innerHTML; 
    content = ''; 
    Aurita.Wiki.recently_viewed.reverse(); 
    for(i=0; i<Aurita.Wiki.recently_viewed.length; i++) {
      cid      = Aurita.Wiki.recently_viewed[i]; 
      title    = Aurita.Wiki.recently_viewed_titles[cid]; 
      model    = Aurita.Wiki.recently_viewed_models[cid];
      content += template.replace('__id__', cid).replace('__id__', cid).replace('__id__', cid).replace('{title}', title).replace('__model__', model); 
    }
    Aurita.Wiki.recently_viewed.reverse(); 
    $('recently_viewed_list').innerHTML = content; 
  }, 

  after_article_delete : function(deleted_article_id) { 
    entry = 'article_entry_'+deleted_article_id; 
    if($(entry)) { 
      new Effect.Pulsate(entry, { duration: 0.5, pulses: 2, queue: 'front' }); 
      new Effect.Fade(entry, { duration: 0.5, queue: 'end' }); 
    } 
    else { 
      Aurita.load_widget('Message_Box', { message: 'article_has_been_deleted' }); 
    } 
  }, 
  
  after_media_asset_delete : function(deleted_media_asset_id) { 
    reps = [ 'media_asset_entry_'+deleted_media_asset_id, 
             'wiki__media_asset_'+deleted_media_asset_id ];
    entry_found = false; 
    for(var i in reps) { 
      entry = reps[i];
      if($(entry)) { 
        entry_found = true; 
        new Effect.Pulsate(entry, { duration: 0.5, pulses: 2, queue: 'front' }); 
        new Effect.Fade(entry, { duration: 0.5, queue: 'end' }); 
      } 
    } 
    if(!entry_found) { 
      Aurita.load_widget('Message_Box', { message: 'file_has_been_deleted' }); 
    }
  }, 

  after_media_asset_folder_delete : function(deleted_folder_id) { 
    reps = [ 'media_asset_folder_entry_'+deleted_folder_id, 
             'wiki__media_asset_folder_'+deleted_folder_id ];
    entry_found = false; 
    for(var i in reps) { 
      entry = reps[i];
      if($(entry)) { 
        entry_found = true; 
        new Effect.Pulsate(entry, { duration: 0.5, pulses: 2, queue: 'front' }); 
        new Effect.Fade(entry, { duration: 0.5, queue: 'end' }); 
      } 
    } 
    if(!entry_found) { 
      Aurita.load_widget('Message_Box', { message: 'folder_has_been_deleted' }); 
    }
  }

};


///////////////////////////////////////////////////////
// END wiki
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN poll
///////////////////////////////////////////////////////

Poll_Editor = { 

  option_counter: 0, 
  option_amount: 0, 

  add_option: function() { 
    Poll_Editor.option_counter++; 
    Poll_Editor.option_amount++; 
    field = document.createElement('li');
    field.id = 'poll_option_entry_'+Poll_Editor.option_counter; 
    field.innerHTML = '<input type="text" class="polling_option" name="poll_option_'+Poll_Editor.option_counter+'" /><button onclick="Poll_Editor.remove_option('+Poll_Editor.option_counter+');" class="polling_option_button">-</button>';
    $('poll_options').appendChild(field);

    if(Poll_Editor.option_amount >= 2) { 
      Element.setStyle('poll_editor_submit_button', { display: '' }); 
    }
    if(Poll_Editor.option_amount > 10) { 
      Element.setStyle('poll_editor_add_option_button', { display: 'none' }); 
    }

    $('poll_editor_max_option_index').value = Poll_Editor.option_counter; 
  },
  remove_option: function(index) { 
    Poll_Editor.option_amount--; 
    Element.remove('poll_option_entry_'+index); 
    if(Poll_Editor.option_amount < 2) { 
      Element.setStyle('poll_editor_submit_button', { display: 'none' }); 
    }
    if(Poll_Editor.option_amount <= 10) { 
      Element.setStyle('poll_editor_add_option_button', { display: '' }); 
    }
  }, 

  init: function(xml_conn, element, update_source)
  {
    element.innerHTML = xml_conn.responseText; 

    Poll_Editor.option_counter = 0; 
    Poll_Editor.option_amount = 0; 
  }

}; 




///////////////////////////////////////////////////////
// END poll
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN messaging
///////////////////////////////////////////////////////

Aurita.Messaging = { 
  
  load_interfaces : function(what)
  {
     Aurita.load({ element: 'messaging_content', action: 'Messaging::Mailbox/show_'+what+'/' }); 
  }, 

  active_messaging_button : false, 

  open_tab : function(which)
  {
    if(!active_messaging_button) { 
      active_messaging_button = $('messaging_flag_inbox'); 
    }
    Element.addClassName('messaging_flag_inbox', 'flag_button');
    Element.removeClassName('messaging_flag_inbox', 'flag_button_active');
    Element.addClassName('messaging_flag_sent', 'flag_button');
    Element.removeClassName('messaging_flag_sent', 'flag_button_active');
    Element.addClassName('messaging_flag_read', 'flag_button');
    Element.removeClassName('messaging_flag_read', 'flag_button_active');
    Element.addClassName('messaging_flag_trash', 'flag_button');
    Element.removeClassName('messaging_flag_trash', 'flag_button_active');

    active_messaging_button = $('messaging_flag_'+which); 

    Element.addClassName(active_messaging_button, 'flag_button_active');
    Element.removeClassName(active_messaging_button, 'flag_button');

    Aurita.Messaging.load_interfaces(which); 
  }

};



///////////////////////////////////////////////////////
// END messaging
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN bookmark
///////////////////////////////////////////////////////

Aurita.Bookmarking = { 

  on_bookmark_reorder : function(container)
  {
      position_values = Sortable.serialize(container.id);
      Aurita.load_silently({ element: 'dispatcher', 
                             method: 'POST', 
                             action: 'Bookmarking::Bookmark/perform_reorder/' + position_values }); 
  }

}; 


///////////////////////////////////////////////////////
// END bookmark
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN onload
///////////////////////////////////////////////////////

tinyMCE.init({
  // do not provide mode! Editor inits are handled event-based when needed. 
  mode: 'specific_textareas', 
  editor_selector : "full", 
  plugins : "autoresize,safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras",
  theme : "advanced",
  relative_urls : true,
  valid_elements : "*[*]",
  extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
  content_css : "/aurita/shared/editor_content_full.css",
  theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
  theme_advanced_toolbar_align : "left", 
  theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,|,formatselect,removeformat,|,insertdate,inserttime,|,forecolor,backcolor", 
  theme_advanced_buttons2 : "bullist,numlist,outdent,indent,|,tablecontrols,|,hr,fullscreen", 
  theme_advanced_buttons3 : "", 
  theme_advanced_toolbar_location : "top", 
  theme_advanced_resizing : false, 
  auto_resize : true,
  language : "de", 
  setup : function(editor) { 
    editor.addButton('aurita_save', { 
                      title : 'Speichern', 
                      image : '/aurita/images/icons/editor_save.gif', 
                      onclick : function() { 
                        Aurita.submit_form('container_form_xxxx'); 
                      }
    }); 
    editor.addButton('aurita_cancel', { 
                      title : 'Abbrechen', 
                      image : '/aurita/images/icons/editor_cancel.gif', 
                      onclick : function() { 
                        Aurita.Editor.save_all(); 
                        Aurita.load({ action : 'Wiki::Article/show/article_id=xxxx' });  
                      }
    }); 
  }

});
tinyMCE.init({
  mode: 'specific_textareas', 
  editor_selector : "simple", 
  plugins : "safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras",
  theme : "advanced",
  relative_urls : true,
  valid_elements : "*[*]",
  extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
  content_css : "/aurita/shared/editor_content_simple.css",
  theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
  theme_advanced_toolbar_align : "left", 
  theme_advanced_buttons1 : "bold,italic,underline,strikethrough,removeformat,|,bullist,numlist,|,insertdate,inserttime,|,forecolor,backcolor", 
  theme_advanced_buttons2 : "", 
  theme_advanced_buttons3 : "", 
  theme_advanced_toolbar_location : "top", 
  theme_advanced_resizing : false, 
  auto_resize : false,
  language : "de"

});

Aurita.on_page_load = function() { 


  Aurita.loading_icon = new Image(); 
  Aurita.loading_icon.src = '/aurita/images/icons/loading.gif'; 

  Aurita.context_menu_draggable = new Draggable('context_menu', { starteffect: 0, endeffect: 0 } );

  Aurita.disable_context_menu_draggable = function() { 
    Aurita.context_menu_draggable.destroy(); 
  }; 

  Aurita.enable_context_menu_draggable = function() { 
    Aurita.context_menu_draggable = new Draggable('context_menu');
  }; 

  Aurita.poll_load('users_online_box_body', 'App_General/users_online_box_body', 120); 

  setInterval(function() { Aurita.check_hashvalue(); }, 300);
  setInterval(function() { Aurita.poll_feedback(); }, 60000);

  Element.hide('cover'); 
  Aurita.GUI.collapse_boxes();  

  new Draggable('message_box'); 
  if($('debug_box')) { 
    new Draggable('debug_box', { handle: 'debug_toolbar', starteffect: 0, endeffect: 0 } );
  }
  try { 
  new accordion('app_left_column', { 
                   classNames: { 
                     content: 'accordion_box_body', 
                     toggle: 'accordion_box_header', 
                     toggleActive: 'accordion_box_header_active' 
                   } 
                });
  } catch(e) { } 

  function custom_autocomplete_onupdate() { 
    Element.hide('indicator');
    Element.show('indicator_');
    Element.setStyle('autocomplete_choices', { width: '419px', top: '25px', left: '-200px' }); 
    Element.show('autocomplete_choices');
  }
  function custom_autocomplete() { 
    Element.show('indicator');
    Element.hide('indicator_');
    Aurita.load_silently({ action: 'Autocomplete/all/key='+($('autocomplete').value), 
                           element: 'autocomplete_choices', 
                           onload: custom_autocomplete_onupdate });
  };


  function show_article(text, li)
  {
    generic_id = text.id; 
    req_parts = generic_id.split('__'); 

    if(generic_id.match('find_all__')) {	
      tag = generic_id.replace('find_all__','');
      Aurita.load({ action: 'App_Main/find_all/key='+tag }); 
    }
    else if(generic_id.match('find_full__')) {	
      tag = generic_id.replace('find_full__','');
      Aurita.load({ action: 'App_Main/find_full/key='+tag }); 
    }
    else { 
      if(req_parts[0] == 'url') { 
        req_url = req_parts[1]; 
        window.open(req_url);
        return; 
      }
      else { 
        if(req_parts[2]) { 
          req_url = (req_parts[0] + '::' + req_parts[1] + '/show/id=' + req_parts[2]); 
          Aurita.load({ action: req_url }); 
        }
        else { 
          req_url = (req_parts[0] + '/show/id=' + req_parts[1]); 
          Aurita.load({ action: req_url }); 
        }
      } 
    }
  }

  function fix_rollout(element, query) { 
    Element.setStyle('autocomplete_choices', { width: '419px', top: '25px', left: '-200px' }); 
    Element.setOpacity('autocomplete_choices', 1.0);
    return query; 
  }

  if($('autocomplete')) { 
    new Ajax.Autocompleter("autocomplete", 
                           "autocomplete_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: show_article, 
                             indicator: 'indicator', 
                             tokens: [], 
                             frequency: 0.2, 
                             callback: fix_rollout, 
                             parameters: 'controller=Autocomplete&action=all&mode=none'
                           }
    );
  }

  Aurita.init_page(); // Calls onload scripts defined in decorator
}

window.onload = Aurita.on_page_load; 



///////////////////////////////////////////////////////
// END onload
///////////////////////////////////////////////////////
