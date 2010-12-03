
Number.prototype.toDecimal = function(value) { 
  var precision = 2; 
  var power     = Math.pow(10, precision || 0);
  return String(Math.round(value * power) / power);
}; 

Number.prototype.formatCurrency = function(c, d, t){
  var n = this, c = isNaN(c = Math.abs(c)) ? 2 : c, d = d == undefined ? "," : d, t = t == undefined ? "." : t, s = n < 0 ? "-" : "",
  i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0;
  return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t)
  + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
};

