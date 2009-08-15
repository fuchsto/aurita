function log_debug(A){if(window.console&&window.console.log){window.console.log(A)}if(document.getElementById("developer_console")){document.getElementById("developer_console").innerHTML+=(A+"<br />")}}var resizeSpeed=10;var borderSize=10;var slideShowWidth=-1;var slideShowHeight=-1;var navigationBarWidth=-1;var slideshow=0;var foreverLoop=1;var loopInterval=4000;var loopMusic=true;var homeURL="http://infranode.com:81/aurita/";var fileLoadingImage=homeURL+"images/lb/loading.gif";var fileBottomNavCloseImage=homeURL+"images/lb/close.png";var SlideShowStartImage=homeURL+"images/lb/play.png";var SlideShowStopImage=homeURL+"images/lb/stop.png";var MusicOnImage=homeURL+"images/lb/music_on.png";var MusicOffImage=homeURL+"images/lb/music_off.png";var replayImage=homeURL+"images/lb/replay.png";var blankSrc=homeURL+"images/lb/blank.gif";var imageDataContainerOpacity=0.6;var resize=1;var SoundBridgeSWF=homeURL+"/inc/lightboxEx/js/SoundBridge.swf";var imageArray=new Array;var activeImage;if(resizeSpeed>10){resizeSpeed=10}if(resizeSpeed<1){resizeSpeed=1}resizeDuration=(11-resizeSpeed)*0.15;var so=null;var objSlideShowImage;var objLightboxImage;var objImageDataContainer;var objSpeakerImage;var objBottomNavCloseImage;var keyPressed=false;var slideshowMusic=null;var firstTime=1;var closeWindow=false;var saveSlideshow;var saveForeverLoop;var saveLoopInterval;var saveSlideShowWidth;var saveSlideShowHeight;var saveLoopMusic;var saveNavigationBarWidth;var timeStart=0;var isPNGSupported=!(/MSIE ((5\.5)|(6\.0))/.test(navigator.userAgent)&&(navigator.platform=="Win32"));var realSrc;function propertyChanged(){if(isPNGSupported){return }var A=event.propertyName;if(A!="src"){return }if(!new RegExp(blankSrc).test(event.srcElement.src)){fixPNGImage(event.srcElement)}}function fixPNGImage(A){if(isPNGSupported){return }var B=A.src;if(B==realSrc&&/\.png$/i.test(B)){A.src=blankSrc;return }if(!new RegExp(blankSrc).test(B)){realSrc=B}if(/\.png$/i.test(realSrc)){A.src=blankSrc;A.runtimeStyle.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+B+"',sizingMethod='scale')"}else{A.runtimeStyle.filter=""}}function openSlideShow(C){var D=800;var A=620;var K=(screen.width-D)/2;var J=(screen.height-A)/3;var E=homeURL+C+".html";var B=window.open(E,"_blank","width="+D+",height="+A+",top="+J+",left="+K+",screenX="+K+",screenY="+J+",toolbar=0,scrollbars=0,resizable=0,location=0,status=0");if(B==null||typeof (B)=="undefined"){alert("Can't open a slideshow window.\nPlease, try again when the page gets reloaded.");location.reload()}}function startSlideshow(){closeWindow=true;init();var B=document.getElementsByTagName("a");if(B.length!=0){var A=B[0];myLightbox.start(A)}}Object.extend(Element,{getWidth:function(A){A=$(A);return A.offsetWidth},setWidth:function(B,A){B=$(B);B.style.width=A+"px"},setHeight:function(A,B){A=$(A);A.style.height=B+"px"},setTop:function(B,A){B=$(B);B.style.top=A+"px"},setSrc:function(A,B){A=$(A);A.src=B},setHref:function(B,A){B=$(B);B.href=A},setInnerHTML:function(A,B){A=$(A);A.innerHTML=B}});Array.prototype.removeDuplicates=function(){for(i=1;i<this.length;i++){if(this[i][0]==this[i-1][0]){this.splice(i,1)}}};Array.prototype.empty=function(){for(i=0;i<=this.length;i++){this.shift()}};Sound.trace=function(A,B){};function Player(){this.paused=true;this.stoped=true;this.options=new Object();this.options.swfLocation=SoundBridgeSWF;this.sound=new Sound(this.options);this.position=0;this.frequency=1000;this.isLoaded=false;this.duration=0;this.bytesTotal=0;this.callback=this.registerCallback()}Player.prototype.onTimerEvent=function(){var B=false;if(!this.paused){var A=this.sound.getPosition();if(!A){A=0}if(A!=this.position&&A!=0){this.onPlaying()}else{this.onBuffering()}this.position=A;var K=0;K=this.sound.getDuration();if(!K){K=0}if(K==this.duration&&K!=0){B=true}this.duration=K;var D=A/K;if(B){this.setProgressBar(D)}var E=false;var J=this.sound.getBytesTotal();if(J==this.bytesTotal){E=true}this.bytesTotal=J;if(E){var C=this.sound.getBytesLoaded()/J;this.setLoadedBar(C)}if(D==1&&K!=0&&A!=0){this.onSoundComplete()}}};Player.prototype.registerCallback=function(){return setInterval(this.onTimerEvent.bind(this),this.frequency)};Player.prototype.clearCallback=function(){clearInterval(this.callback);this.callback=null};Player.prototype.setProgressBar=function(A){if(!A){A=0}};Player.prototype.setLoadedBar=function(A){if(!A){A=0}};Player.prototype.onPlaying=function(){};Player.prototype.onPause=function(){};Player.prototype.onBuffering=function(){};Player.prototype.onSoundComplete=function(){if(!this.paused){if(loopMusic){this.onForward()}}};Player.prototype.onForward=function(){this.position=0;this.duration=0;this.sound.start(this.duration/1000,1);this.sound.stop();this.loadTrack(this.track);this.stoped=true;this.setProgressBar(0);this.setLoadedBar(0);if(!this.paused){this.paused=true;this.play()}};Player.prototype.fadeOut=function(){for(var A=this.sound.getVolume()-1;A>=0;A--){this.sound.setVolume(A)}};Player.prototype.fadeIn=function(){for(var A=1;A<=100;A++){this.sound.setVolume(A)}};Player.prototype.toggleVolume=function(){if(this.paused){return }var A=this.sound.getVolume();if(A==0){this.fadeIn();objSpeakerImage.setAttribute("src",MusicOnImage)}if(A==100){this.fadeOut();objSpeakerImage.setAttribute("src",MusicOffImage)}};Player.prototype.play=function(){if(this.paused){this.paused=false;if(this.stoped){this.sound.loadSound(this.track,true)}this.sound.start(this.position/1000,1);this.stoped=false}else{this.position=this.sound.getPosition();this.sound.stop();this.paused=true;this.onPause()}};Player.prototype.stop=function(){if(!this.paused){for(var A=this.sound.getVolume()-1;A>=0;A--){this.sound.setVolume(A);pause(1)}}this.paused=true;this.stoped=true;this.position=0;this.duration=0;this.sound.start(this.duration/1000,1);this.sound.stop()};Player.prototype.loadTrack=function(A){this.track=A};var player;var Lightbox=Class.create();Lightbox.prototype={initialize:function(){this.dimmingOut=false;if(!document.getElementsByTagName){return }var T=document.getElementsByTagName("a");for(var a=0;a<T.length;a++){var N=T[a];var d=String(N.getAttribute("rel"));if(N.getAttribute("href")&&(d.toLowerCase().match("lightbox"))){N.onclick=function(){myLightbox.start(this);return false}}}var f=document.getElementsByTagName("body").item(0);var O=document.createElement("div");O.setAttribute("id","overlay");O.style.display="none";O.onclick=function(){if(!closeWindow){myLightbox.end()}return false};f.appendChild(O);var S=document.createElement("div");S.setAttribute("id","lightbox");S.style.display="none";f.appendChild(S);var c=document.createElement("div");c.setAttribute("id","outerImageContainer");S.appendChild(c);var R=document.createElement("div");R.setAttribute("id","imageContainer");c.appendChild(R);objLightboxImage=document.createElement("img");objLightboxImage.setAttribute("id","lightboxImage");objLightboxImage.setAttribute("width","");objLightboxImage.setAttribute("height","");R.appendChild(objLightboxImage);var X=document.createElement("div");X.setAttribute("id","hoverNav");R.appendChild(X);var Y=document.createElement("a");Y.setAttribute("id","prevLink");Y.setAttribute("href","#");Y.setAttribute("onFocus","if (this.blur) this.blur()");X.appendChild(Y);var J=document.createElement("a");J.setAttribute("id","nextLink");J.setAttribute("href","#");J.setAttribute("onFocus","if (this.blur) this.blur()");X.appendChild(J);var Z=document.createElement("div");Z.setAttribute("id","loading");R.appendChild(Z);var A=document.createElement("a");A.setAttribute("id","loadingLink");A.setAttribute("href","#");A.setAttribute("onFocus","if (this.blur) this.blur()");A.onclick=function(){myLightbox.end();if(closeWindow){window.close()}return false};Z.appendChild(A);var Q=document.createElement("img");Q.setAttribute("src",fileLoadingImage);A.appendChild(Q);var B=document.createElement("div");B.setAttribute("id","replay");R.appendChild(B);var U=document.createElement("a");U.setAttribute("id","replayLink");U.setAttribute("href","#");U.setAttribute("onFocus","if (this.blur) this.blur()");U.onclick=function(){myLightbox.toggleSlideShow();return false};B.appendChild(U);var e=document.createElement("img");e.onpropertychange=function(){propertyChanged();return false};e.setAttribute("src",replayImage);U.appendChild(e);e.setAttribute("src",replayImage);Element.hide("replay");var M=document.createElement("div");M.setAttribute("id","spacer");M.className="spacer";S.appendChild(M);objImageDataContainer=document.createElement("div");objImageDataContainer.setAttribute("id","imageDataContainer");objImageDataContainer.className="clearfix";objImageDataContainer.onmouseover=function(k){if(k==undefined){k=event}if(checkMouseEnter(this,k)){myLightbox.lightUpNavigationBar()}return false};objImageDataContainer.onmouseout=function(k){if(k==undefined){k=event}if(checkMouseLeave(this,k)){myLightbox.dimDownNavigationBar()}return false};S.appendChild(objImageDataContainer);var K=document.createElement("div");K.setAttribute("id","imageData");objImageDataContainer.appendChild(K);var W=document.createElement("div");W.setAttribute("id","imageDetails");K.appendChild(W);var P=document.createElement("span");P.setAttribute("id","caption");W.appendChild(P);var C=document.createElement("span");C.setAttribute("id","numberDisplay");W.appendChild(C);var V=document.createElement("div");V.setAttribute("id","bottomNav");K.appendChild(V);var g=document.createElement("a");g.setAttribute("id","bottomNavClose");g.setAttribute("href","#");g.setAttribute("onFocus","if (this.blur) this.blur()");g.onclick=function(){myLightbox.end();if(closeWindow){window.close()}return false};V.appendChild(g);objBottomNavCloseImage=document.createElement("img");objBottomNavCloseImage.setAttribute("id","closeButton");objBottomNavCloseImage.setAttribute("alt","Close");objBottomNavCloseImage.onpropertychange=function(){propertyChanged();return false};objBottomNavCloseImage.setAttribute("src",fileBottomNavCloseImage);g.appendChild(objBottomNavCloseImage);var E=document.createElement("a");E.setAttribute("id","slideshowLink");E.setAttribute("href","#");E.setAttribute("onFocus","if (this.blur) this.blur()");E.onclick=function(){myLightbox.toggleSlideShow();return false};V.appendChild(E);objSlideShowImage=document.createElement("img");objSlideShowImage.setAttribute("id","playButton");objSlideShowImage.setAttribute("alt","Start/Stop");objSlideShowImage.setAttribute("src",SlideShowStartImage);objSlideShowImage.onpropertychange=function(){propertyChanged();return false};E.appendChild(objSlideShowImage);var D=document.createElement("a");D.setAttribute("id","speakerLink");D.setAttribute("href","#");D.setAttribute("onFocus","if (this.blur) this.blur()");D.onclick=function(){player.toggleVolume();return false};V.appendChild(D);objSpeakerImage=document.createElement("img");objSpeakerImage.setAttribute("id","speaker");objSpeakerImage.setAttribute("alt","Music On/Off");objSpeakerImage.setAttribute("src",MusicOffImage);objSpeakerImage.onpropertychange=function(){propertyChanged();return false};D.appendChild(objSpeakerImage);var L=document.createElement("div");L.setAttribute("id","__sound_flash__");O.appendChild(L)},lightUpNavigationBar:function(){if(!this.dimmingOut){new Effect.Parallel([new Effect.Appear("imageDataContainer",{duration:0.25,from:imageDataContainerOpacity,to:1})],{duration:0.25})}else{this.dimmingOut=false}},dimDownNavigationBar:function(){this.dimmingOut=true;setTimeout(function(){if(this.dimmingOut){new Effect.Parallel([new Effect.Appear("imageDataContainer",{duration:0.25,from:1,to:imageDataContainerOpacity,afterFinish:function(){myLightbox.dimmingOut=false}})],{duration:0.25})}}.bind(this),2000)},start:function(E){player=new Player();slideshowMusic=null;firstTime=1;saveSlideshow=slideshow;saveForeverLoop=foreverLoop;saveLoopInterval=loopInterval;saveSlideShowWidth=slideShowWidth;saveSlideShowHeight=slideShowHeight;saveLoopMusic=loopMusic;saveNavigationBarWidth=navigationBarWidth;hideSelectBoxes();var L=getPageSize();Element.setHeight("overlay",L[1]);new Effect.Appear("overlay",{duration:0.2,from:0,to:0.8});imageArray=[];imageNum=0;if(!document.getElementsByTagName){return }var A=document.getElementsByTagName("a");if((E.getAttribute("rel")=="lightbox")){imageArray.push(new Array(E.getAttribute("href"),E.getAttribute("title")))}else{for(var J=0;J<A.length;J++){var K=A[J];if(K.getAttribute("href")&&(K.getAttribute("rel")==E.getAttribute("rel"))){imageArray.push(new Array(K.getAttribute("href"),K.getAttribute("title")));if(imageArray.length==1){slideshowMusic=K.getAttribute("music");if(slideshowMusic==null){}else{player.loadTrack(slideshowMusic)}var C=K.getAttribute("startslideshow");if(C!=null){if(C=="false"){slideshow=0}}var M=K.getAttribute("forever");if(M!=null){if(M=="true"){foreverLoop=1}else{foreverLoop=0}}var D=K.getAttribute("loopMusic");if(D!=null){if(D=="true"){loopMusic=true}else{loopMusic=false}}if(foreverLoop==1){loopMusic=true}var N=K.getAttribute("slideDuration");if(N!=null){loopInterval=N*1000}var B=K.getAttribute("slideshowwidth");if(B!=null){slideShowWidth=B*1}var O=K.getAttribute("slideshowheight");if(O!=null){slideShowHeight=O*1}var P=K.getAttribute("navbarWidth");if(P!=null){navigationBarWidth=P*1}}}}imageArray.removeDuplicates();while(imageArray[imageNum][0]!=E.getAttribute("href")){imageNum++}}this.changeImageByTimer(imageNum)},showLightBox:function(){var B=getPageSize();var A=getPageScroll();var C=A[1]+(B[3]/15);Element.setTop("lightbox",C+10);Element.show("lightbox")},changeImageByTimer:function(A){activeImage=A;this.imageTimer=setTimeout(function(){this.showLightBox();this.changeImage(activeImage)}.bind(this),10)},changeImage:function(A){activeImage=A;Element.show("loading");Element.hide("replay");Element.hide("lightboxImage");Element.hide("hoverNav");Element.hide("prevLink");Element.hide("nextLink");if(firstTime==1){Element.hide("imageDataContainer");Element.hide("bottomNav");Element.hide("numberDisplay");Element.hide("speakerLink");Element.hide("slideshowLink")}imgPreloader=new Image();imgPreloader.onload=function(){Element.setSrc("lightboxImage",imageArray[activeImage][0]);objLightboxImage.setAttribute("width",imgPreloader.width);objLightboxImage.setAttribute("height",imgPreloader.height);if((imageArray.length>1)&&(slideShowWidth!=-1||slideShowHeight!=-1)){if(slideShowWidth==-1&&slideShowHeight!=-1){myLightbox.resizeImageContainer(imgPreloader.width,slideShowHeight)}else{if(slideShowHeight==-1&&slideShowWidth!=-1){myLightbox.resizeImageContainer(slideShowWidth,imgPreloader.height)}else{if((slideShowWidth>=imgPreloader.width)&&(slideShowHeight>=imgPreloader.height)){myLightbox.resizeImageContainer(slideShowWidth,slideShowHeight)}else{myLightbox.resizeImageAndContainer(imgPreloader.width,imgPreloader.height)}}}}else{myLightbox.resizeImageAndContainer(imgPreloader.width,imgPreloader.height)}};imgPreloader.src=imageArray[activeImage][0]},resizeImageAndContainer:function(C,A){if(resize==1){useableWidth=0.9;useableHeight=0.8;var D=getPageSize();windowWidth=D[2];windowHeight=D[3];var B=windowWidth*useableWidth;var E=windowHeight*useableHeight;var J=Element.getHeight("spacer");if(J){E=E-(J+J)}scaleX=1;scaleY=1;if(C>B){scaleX=(B)/C}if(A>E){scaleY=(E)/A}scale=Math.min(scaleX,scaleY);C*=scale;A*=scale;objLightboxImage.setAttribute("width",C);objLightboxImage.setAttribute("height",A)}this.resizeImageContainer(C,A)},resizeImageContainer:function(B,A){B=B+1;this.wCur=Element.getWidth("outerImageContainer");this.hCur=Element.getHeight("outerImageContainer");this.xScale=((B+(borderSize*2))/this.wCur)*100;this.yScale=((A+(borderSize*2))/this.hCur)*100;wDiff=(this.wCur-borderSize*2)-B;hDiff=(this.hCur-borderSize*2)-A;this.slideDownImageDataContainer=true;if(!(hDiff==0)){new Effect.Scale("outerImageContainer",this.yScale,{scaleX:false,duration:resizeDuration,queue:"front"})}if(!(wDiff==0)){if(navigationBarWidth==-1){Element.hide("imageDataContainer")}new Effect.Scale("outerImageContainer",this.xScale,{scaleY:false,delay:resizeDuration,duration:resizeDuration})}else{this.slideDownImageDataContainer=false}if((hDiff==0)&&(wDiff==0)){if(navigator.appVersion.indexOf("MSIE")!=-1){pause(250)}else{pause(100)}}Element.setHeight("prevLink",A);Element.setHeight("nextLink",A);if(navigationBarWidth==-1){Element.setWidth("imageDataContainer",B+(borderSize*2))}else{Element.setWidth("imageDataContainer",navigationBarWidth+(borderSize*2));this.slideDownImageDataContainer=false}this.showImage()},showImage:function(){Element.hide("loading");new Effect.Appear("lightboxImage",{duration:0.5,queue:"end",afterFinish:function(){myLightbox.updateDetails()}});this.preloadNeighborImages()},updateDetails:function(){Element.show("bottomNav");if(firstTime==1){objSpeakerImage.setAttribute("src",MusicOffImage);objSlideShowImage.setAttribute("src",SlideShowStartImage);objBottomNavCloseImage.setAttribute("src",fileBottomNavCloseImage)}Element.show("caption");if(imageArray[activeImage][1]!=""&&imageArray[activeImage][1]!=null){Element.setInnerHTML("caption",imageArray[activeImage][1])}else{Element.setInnerHTML("caption","&nbsp;")}if(imageArray.length>1){Element.show("numberDisplay");Element.setInnerHTML("numberDisplay",""+eval(activeImage+1)+" of "+imageArray.length)}if(firstTime==1||this.slideDownImageDataContainer){new Effect.Parallel([new Effect.SlideDown("imageDataContainer",{sync:true,duration:resizeDuration+0.25,from:0,to:1}),new Effect.Appear("imageDataContainer",{sync:true,duration:1,from:0,to:imageDataContainerOpacity})],{duration:0.65,afterFinish:function(){myLightbox.updateNav()}})}else{myLightbox.updateNav()}if(imageArray.length>1){Element.show("slideshowLink")}else{Element.hide("slideshowLink")}if(slideshow==1&&imageArray.length>1){this.startSlideShow()}},updateNav:function(){Element.show("hoverNav");if(activeImage!=0){Element.show("prevLink");document.getElementById("prevLink").onclick=function(){if(slideshow==1){keyPressed=true}myLightbox.changeImage(activeImage-1);return false}}if(activeImage!=(imageArray.length-1)){Element.show("nextLink");document.getElementById("nextLink").onclick=function(){if(slideshow==1){keyPressed=true}myLightbox.changeImage(activeImage+1);return false}}this.enableKeyboardNav();if(firstTime==1){firstTime=0;this.showSpeaker();if(slideshow==1){this.playMusic()}}},enableKeyboardNav:function(){document.onkeydown=this.keyboardAction},disableKeyboardNav:function(){document.onkeydown=""},keyboardAction:function(A){if(A==null){keycode=event.keyCode}else{keycode=A.which}key=String.fromCharCode(keycode).toLowerCase();if((key=="x")||(key=="o")||(key=="c")){myLightbox.end()}else{if((keycode==188)||(key=="p")){if(activeImage!=0){if(slideshow==1){keyPressed=true}myLightbox.disableKeyboardNav();myLightbox.changeImage(activeImage-1)}}else{if((keycode==190)||(key=="n")){if(activeImage!=(imageArray.length-1)){if(slideshow==1){keyPressed=true}myLightbox.disableKeyboardNav();myLightbox.changeImage(activeImage+1)}}}}},preloadNeighborImages:function(){if((imageArray.length-1)>activeImage){preloadNextImage=new Image();preloadNextImage.src=imageArray[activeImage+1][0]}if(activeImage>0){preloadPrevImage=new Image();preloadPrevImage.src=imageArray[activeImage-1][0]}},showSpeaker:function(){if(slideshowMusic!=null){Element.show("speakerLink")}else{Element.hide("speakerLink")}},playMusic:function(){if(slideshowMusic!=null){objSpeakerImage.setAttribute("src",MusicOnImage);player.play()}},stopMusic:function(){if(slideshowMusic!=null){objSpeakerImage.setAttribute("src",MusicOffImage);if(player.paused){player.stop()}else{player.play()}}},toggleSlideShow:function(){if(slideshow==1){this.stopSlideShow()}else{this.playMusic();if(activeImage==(imageArray.length-1)){slideshow=1;this.changeImage(0)}else{this.startSlideShow()}}},startSlideShow:function(){slideshow=1;objSlideShowImage.setAttribute("src",SlideShowStopImage);this.slideShowTimer=setTimeout(function(){if(keyPressed){keyPressed=false;return }if(activeImage<(imageArray.length-1)){this.changeImage(activeImage+1)}else{if(foreverLoop){this.changeImage(0)}else{slideshow=0;if(this.slideShowTimer){clearTimeout(this.slideShowTimer);this.slideShowTimer=null}player.clearCallback();this.disableKeyboardNav();Element.hide("hoverNav");Element.hide("prevLink");Element.hide("nextLink");Element.setInnerHTML("numberDisplay","");this.fadeoutTimer=setInterval(function(){player.sound.setVolume(player.sound.getVolume()-1)}.bind(this),30);new Effect.Appear("lightboxImage",{duration:3,from:1,to:0,afterFinish:function(){new Effect.Appear("replay",{duration:0.2,from:0,to:1});objSlideShowImage.setAttribute("src",SlideShowStartImage);clearInterval(myLightbox.fadeoutTimer);player.paused=true;myLightbox.stopMusic()}})}}}.bind(this),loopInterval)},stopSlideShow:function(){slideshow=0;objSlideShowImage.setAttribute("src",SlideShowStartImage);this.stopMusic();if(this.slideShowTimer){clearTimeout(this.slideShowTimer);this.slideShowTimer=null}},end:function(){player.paused=true;this.stopSlideShow();player.clearCallback();clearInterval(myLightbox.fadeoutTimer);this.disableKeyboardNav();Element.hide("bottomNav");Element.hide("lightbox");new Effect.Fade("overlay",{duration:0.2});showSelectBoxes();slideshow=saveSlideshow;foreverLoop=saveForeverLoop;loopInterval=saveLoopInterval;slideShowWidth=saveSlideShowWidth;slideShowHeight=saveSlideShowHeight;navigationBarWidth=saveNavigationBarWidth;loopMusic=saveLoopMusic}};function containsDOM(A,C){var B=false;do{if((B=A==C)){break}C=C.parentNode}while(C!=null);return B}function checkMouseEnter(B,A){if(B.contains&&A.fromElement){return !B.contains(A.fromElement)}else{if(A.relatedTarget){return !containsDOM(B,A.relatedTarget)}}}function checkMouseLeave(B,A){if(B.contains&&A.toElement){return !B.contains(A.toElement)}else{if(A.relatedTarget){return !containsDOM(B,A.relatedTarget)}}}function getPageScroll(){var A;if(self.pageYOffset){A=self.pageYOffset}else{if(document.documentElement&&document.documentElement.scrollTop){A=document.documentElement.scrollTop}else{if(document.body){A=document.body.scrollTop}}}arrayPageScroll=new Array("",A);return arrayPageScroll}function getPageSize(){var C,A;if(window.innerHeight&&window.scrollMaxY){C=document.body.scrollWidth;A=window.innerHeight+window.scrollMaxY}else{if(document.body.scrollHeight>document.body.offsetHeight){C=document.body.scrollWidth;A=document.body.scrollHeight}else{C=document.body.offsetWidth;A=document.body.offsetHeight}}var B,D;if(self.innerHeight){B=self.innerWidth;D=self.innerHeight}else{if(document.documentElement&&document.documentElement.clientHeight){B=document.documentElement.clientWidth;D=document.documentElement.clientHeight}else{if(document.body){B=document.body.clientWidth;D=document.body.clientHeight}}}if(A<D){pageHeight=D}else{pageHeight=A}if(C<B){pageWidth=B}else{pageWidth=C}arrayPageSize=new Array(pageWidth,pageHeight,B,D);return arrayPageSize}function getKey(A){if(A==null){keycode=event.keyCode}else{keycode=A.which}key=String.fromCharCode(keycode).toLowerCase();if(key=="x"){}}function listenKey(){document.onkeypress=getKey}function showSelectBoxes(){selects=document.getElementsByTagName("select");for(i=0;i!=selects.length;i++){selects[i].style.visibility="visible"}}function hideSelectBoxes(){selects=document.getElementsByTagName("select");for(i=0;i!=selects.length;i++){selects[i].style.visibility="hidden"}}function pause(B){var A=new Date();var C=A.getTime()+B;while(true){A=new Date();if(A.getTime()>C){return }}}function initLightbox(){myLightbox=new Lightbox()}function init(){if(arguments.callee.done){return }arguments.callee.done=true;if(_timer){clearInterval(_timer);_timer=null}initLightbox()}if(document.addEventListener){document.addEventListener("DOMContentLoaded",init,false);
/*@cc_on @*/
/*@if (@_win32)
    document.write("<script id=__ie_onload defer src=javascript:void(0)></script>");
    var script = document.getElementById("__ie_onload");
    script.onreadystatechange = function() {
        if (this.readyState == "complete") {
            init(); // call the onload handler
        }
    };
/*@end @*/
<<<<<<< .mine
<<<<<<< .mine

 

/* for Safari */
if (/WebKit/i.test(navigator.userAgent)) { // sniff
    var _timer = setInterval(function() {
        if (/loaded|complete/.test(document.readyState)) {
            init(); // call the onload handler
        }
    }, 10);
}

 

/* for other browsers */
window.onload = init;


function rd_admin__ui__tool_showhide(name, nest)
{
    if(nest != '') {
	var box = get_object_by_id(nest,'');
	var content = get_object_by_id(name,nest);
    }
    else {
	content = get_object_by_id(name, ''); 
    }
    if(content.display == "none") {
	content.display = "";
	if(nest != '') { box.width="240px"; }
    } 
    else {
	content.display = "none"; 
	if(nest != '') { box.width="24px"; }
    }
}
function rd_admin__ui__tool_varwidth_showhide(name, nest, width)
{
    var box = get_object_by_id(nest,'');
    var content = get_object_by_id(name,nest);
    if(content.display == "none") {
	content.display = "";
	box.width=width+"px";
    } 
    else {
	content.display = "none"; 
	box.width="24px";
    }
}
function rd_admin__ui__show(name, nest)
{
    var hide_obj = get_object_by_id(name, nest);
    hide_obj.display = "";
    
}
function rd_admin__ui__hide(name, nest)
{
    var hide_obj = get_object_by_id(name, nest);
    hide_obj.display = "none";
}

function rd_admin__handle_exception(error_name, action)
{
    rd_admin__ui__showhide('rd_admin__ui__error',''); 
    //  parent.rd_admin__ui__scratch.location.href="dispatcher.rhtml?rd__model=Error_Handler&rd__error="+error_name+"&rd__controller="+action; 
}
function rd_admin__raise_exception(	header,message, 
					label1,action1,type1,  
					label2,action2,type2,
					label3,action3,type3)
{
    rd_admin__ui__show('rd_admin__ui__error',''); 
    // apply button styles etc
    if(action1 != '') { 
	rd_admin__ui__show_button('rd_admin__ui__error_button1', 'rd_admin__ui__error', label1, type1); 
	//	apply_style('rd_admin__ui__error_button1', 'rd_admin__ui__error', 'background_color'='#990000');
    }
    if(action2 != '') { 
	rd_admin__ui__show('rd_admin__ui__error_button2', 'rd_admin__ui__error'); 
	//	apply_style('rd_admin__ui__error_button2', 'rd_admin__ui__error', 'class'=type2);
    } 
    else { rd_admin__ui__hide('rd_admin__ui__error_button2', 'rd_admin__ui__error'); }
    if(action3 != '') { 
	rd_admin__ui__show('rd_admin__ui__error_button3', 'rd_admin__ui__error'); 
	//	apply_style('rd_admin__ui__error_button3', 'rd_admin__ui__error', 'class'=type3); 
    }
    else { rd_admin__ui__hide('rd_admin__ui__error_button3', 'rd_admin__ui__error'); }
    
}
function rd_admin__ui__show_button(name, nest, label, type) 
{
    var button = get_object_by_id(name, nest);
    button.display = "";
}

function rd_admin__location(frame, url)
{
    eval(frame+'.location.href='+"'"+url+"'"); 
}

function rd_admin__popup_asset(url, w, h) 
{
    if(w == undefined || w > screen.width)   { w = screen.width/2; resize = '1'; }
    if(h == undefined || h > screen.height)  { h = screen.height/2; resize = '1'; }
    
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable='+resize+',menubar=0,fullscreen=0,status=0'
	win = window.open(url,"app",settings);
    win.focus();
}

function rd_admin__popup(url, width, height)
{
    w=width;
    h=height;
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable=0,menubar=0,fullscreen=0,status=0';
    win = window.open(url,'win'+width+'x'+height,settings);
    
    win.focus();	
}

function rd_admin__article_preview(project, aid)
{
    rd_admin__popup('/projects/'+project+'/Node/preview_article/rd__article_id='+aid, 1024, 768); 
}
function rd_admin__node_preview(project, bg, cid)
{
    rd_admin__popup('/projects/'+project+'/Site/content/bg='+bg+'&track='+cid+'&x='+screen.width+'&y='+screen.height+'&cid='+cid, screen.width*0.7, screen.height-200); 
}

function rd_admin__select_box_value(select_id)
{
    select_obj = document.getElementById(select_id); 
    with (select_obj) return options[selectedIndex].value;
}

function rd_admin__swap_checkbox(checkbox_id)
{
    checkbox = document.getElementById(checkbox_id);
    if(checkbox.checked) { checkbox.checked = false; }
    else { checkbox.checked = true; } 
}

date_obj = new Date(); 

function swap_image_choice_list()
{
    Element.setStyle('image_choice_list', { display: '' }); 
    Element.setStyle('text_asset_form', { display: 'none' }); 
    Element.setStyle('choose_custom_form', { display: 'none' }); 
    Cuba.disable_context_menu_draggable(); 
}
function swap_text_edit_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: ''}); 
    Element.setStyle('choose_custom_form', { display: 'none'}); 
    Cuba.enable_context_menu_draggable(); 
}
function swap_choose_custom_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: 'none'}); 
    Element.setStyle('choose_custom_form', { display: ''}); 
    Cuba.enable_context_menu_draggable(); 
}

function profile_load_interfaces(uid, what)
{
  Cuba.load({ element: 'profile_content', action: 'Community::User_Profile/show_'+what+'/user_group_id='+uid, on_update: on_data }); 
}

var active_profile_button = false;
function profile_load(uid, which)
{
  new Effect.Fade('profile_content', {duration: 0.5}); 
  if($('profile_flag_main')) { 
    $('profile_flag_main').className = 'flag_button'
  }
  if($('profile_flag_own_main')) { 
    $('profile_flag_own_main').className = 'flag_button'
  }
  $('profile_flag_galery').className = 'flag_button'
  $('profile_flag_posts').className  = 'flag_button'
  $('profile_flag_friends').className  = 'flag_button'
  if(!active_profile_button) { 
    document.getElementById('profile_flag_main'); 
  }
  active_profile_button.className = 'flag_button';
  active_profile_button = document.getElementById('profile_flag_'+which); 
  active_profile_button.className = 'flag_button_active';
  setTimeout("profile_load_interfaces('"+uid+"','"+which+"')", 550); 
}

function messaging_load_interfaces(uid, what)
{
  Cuba.load({ element: 'messaging_content', action: 'Community::User_Message/show_'+what+'/user_group_id='+uid, on_update: on_data }); 
}

var active_messaging_button = false;
function messaging_load(uid, which)
{
  new Effect.Fade('messaging_content', {duration: 0.5}); 
  $('messaging_flag_inbox').className = 'flag_button'
  $('messaging_flag_sent').className = 'flag_button'
  $('messaging_flag_read').className  = 'flag_button'
  $('messaging_flag_trash').className  = 'flag_button'
  if(!active_messaging_button) { 
    document.getElementById('messaging_flag_main'); 
  }
  active_messaging_button.className = 'flag_button';
  active_messaging_button = document.getElementById('messaging_flag_'+which); 
  active_messaging_button.className = 'flag_button_active';
  setTimeout("messaging_load_interfaces('"+uid+"','"+which+"')", 550); 
}

function autocomplete_single_username_handler(li)
{
  username = li.innerHTML.replace(/(.+)?<b>([^<]+)<\/b>(.+)/, "$2"); 
  user_group_id = li.id.replace('user__',''); 
  if(!autocomplete_selected_users[user_group_id]) { 
  $('username_list').innerHTML += '<div id="user_autocomplete_entry_'+ user_group_id +'">'+
                                  '<span class="link" onclick="Element.remove(\'user_autocomplete_entry_'+ user_group_id +'\'); '+
                                                              'autocomplete_selected_users['+user_group_id+'] = false; ">x</span> '+
                                  username +'<br />' +
                                  '<span style="margin-left: 7px; ">'+
                                  '<input type="checkbox" value="t" name="readonly_'+ user_group_id +'" /> nur Lesen'+
                                  '</span>'+
                                  '<input type="hidden" value="'+ user_group_id +'" name="user_group_ids[]" />'+
                                  '</div>';
  }
  autocomplete_selected_users[user_group_id] = true; 

}


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


var mouse_x = 0; 
var mouse_y = 0; 
function capture_mouse(ev) 
{
    if(!ev) { ev = window.event; }
    if(!ev) { return ; }

    if(Browser.is_ie) {
      mouse_x = ev.clientX + document.body.scrollLeft; 
      mouse_y = ev.clientY + document.body.scrollTop; 
    }
    else if(Browser.is_gecko) { 
      mouse_x = ev.pageX; 
      mouse_y = ev.pageY; 
    }
    //    window.status = mouse_x + 'x' + mouse_y; 
}
function get_mouse(event) 
{
    return [mouse_x, mouse_y];


    if(Browser.is_ie) {
	mouse_x = event.clientX + document.body.scrollLeft; 
	mouse_y = event.clientY + document.body.scrollTop; 
    }
    else if(Browser.is_gecko) { 
	mouse_x = event.pageX; 
	mouse_y = event.pageY; 
    }
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
      Element.setStyle($(last_hovered_element), { backgroundColor: 'transparent' }); 
    } catch(e) { }
  }
  Element.setStyle($(elem_id), { backgroundColor: '#bfbfbf' }); 
  last_hovered_element = elem_id; 
}

var element_style_unfocussed;
function focus_element(element_id)
{
    if(element_style_unfocussed == undefined) {
    //  element_style_unfocussed = rgb_to_hex(Element.getStyle(element_id, 'color')); 
      element_style_unfocussed = (Element.getStyle(element_id, 'color')); 
    }
    //    alert(element_style_unfocussed);
    Element.setStyle(element_id, {backgroundColor: '#ccc8c8'});
    Element.setStyle(element_id, {zIndex: 301});
}
function unfocus_element(element_id)
{
    if(element_exists(element_id)) {
      if(element_style_unfocussed) { 
        Element.setStyle(element_id, {color: element_style_unfocussed}); 
      }
      Element.setStyle(element_id, {backgroundColor: '' });
      Element.setStyle(element_id, {zIndex: 1});
      element_style_unfocussed = undefined; 
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


function init_login_screen(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
}


function init_article_interface(element) { 
    initLightbox(); 
}

function init_autocomplete_username(xml_conn, element, update_source)
{
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_username", 
                         "autocomplete_username_choices", 
                         "/aurita/autocomplete_username.fcgi", 
                         { 
                           minChars: 2, 
                           tokens: [' ',',','\n']
                         }
  );
}
function init_autocomplete_single_username(xml_conn, element, update_source)
{
  autocomplete_selected_users = {}; 
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_username", 
                         "autocomplete_username_choices", 
                         "/aurita/autocomplete_username.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_single_username_handler, 
                           tokens: []
                         }
  );
}

function autocomplete_link_article_handler(text, li) { 
  plaintext = Cuba.temp_range.text; 
  hashcode = text.id.replace('__','--'); 
  onclick = "Cuba.set_hashcode(&apos;"+hashcode+"&apos;); "; 
  if(Cuba.check_if_internet_explorer() == '1') { 
    marker_key = 'find_and_replace_me';
    Cuba.temp_range.text = marker_key; 
    editor_html = Cuba.temp_editor_instance.getBody().innerHTML; 
    pos = editor_html.indexOf(marker_key); 
    if(pos != -1) { 
      Cuba.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
    }
  } 
  else 
  { 
    tinyMCE.execInstanceCommand(Cuba.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+hashcode+'" onclick="'+onclick+'">'+Cuba.temp_range+'</a>');
  }
  context_menu_close(); 
}

function init_autocomplete_articles(xml_conn, element, update_source)
{
  log_debug('in init_autocomplete_articles'); 
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_article", 
                         "autocomplete_article_choices", 
                         "/aurita/dispatch.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_article_handler, 
                           tokens: [' ',',','\n']
                         }
  );
}
function init_link_autocomplete_articles()
{
  new Ajax.Autocompleter("autocomplete_link_article", 
                         "autocomplete_link_article_choices", 
                         "/aurita/dispatch.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_link_article_handler, 
                           tokens: [' ',',','\n']
                         }
  );
}

function init_media_interface(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    for(index=0; index<3000; index++) {
      if(document.getElementById('folder_'+index))
      {
          Cuba.droppables[index] = index;
          Droppables.add('folder_'+index,
             { onDrop: drop_image_in_folder, 
               onHover: activate_target, 
               greedy: true }); 
      }
    }

}

function init_poll_editor(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    Poll_Editor.option_counter = 0; 
    Poll_Editor.option_amount = 0; 
}

var reorder_article_content_id; 
function on_article_reorder(container)
{
    position_values = Sortable.serialize(container.id);
    cb__load_interface_silently('dispatcher','/aurita/Wiki::Article/perform_reorder/' + position_values + '&content_id_parent=' + reorder_article_content_id); 
}
function init_article_reorder_interface(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    Sortable.create("article_partials_list", 
		    { dropOnEmpty:true, 
		      onUpdate: on_article_reorder, 
		      handle: true }); 
}

function init_article(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
    initLightbox(); 
}

var tinyMCE = tinyMCE; 
var registered_editors = {}; 
function flush_editor_register() {
    for(var editor_id in registered_editors) {
      flush_editor(editor_id);     
    }
    registered_editors = {}; 
}

function init_editor(textarea_element_id) 
{
    if(registered_editors[textarea_element_id] == null) { 
      registered_editors[textarea_element_id] = textarea_element_id; 
      tinyMCE.execCommand('mceAddControl', false, textarea_element_id); 
    }
}
function save_editor(textarea_element_id) 
{
    if($(textarea_element_id)) { 
      Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
    }
    registered_editors[textarea_element_id] = null; 
    tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
    tinyMCE.execCommand('mceRemoveControl', true, textarea_element_id);
    tinyMCE.triggerSave(true,true);
}
function flush_editor(textarea_element_id)
{
    if(!$(textarea_element_id)) { return; }

    Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
    log_debug('flushing '+textarea_element_id); 
    tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
    tinyMCE.execCommand('mceRemoveControl', true, textarea_element_id);
    tinyMCE.triggerSave();
    registered_editors[textarea_element_id] = null; 
}
function init_all_editors(element) {
	try { 
		elements = document.getElementsByTagName('textarea');
		if(!elements || elements == undefined || elements == null) { log_debug('elements in init_all_editors is undefined'); return; }
		if(elements == undefined || !elements.length) { log_debug('Error: elements.length in init_all_editors is undefined'); return; }
		for (var i = 0; i < elements.length; i++) {
			elem_id = elements.item(i).id; 
			if(registered_editors[elem_id] == null) { 
				log_debug('init editor instance: ' + elem_id);
				inst = $(elem_id); 
				if(inst) { init_editor(elem_id); }
			}
		}
  } catch(e) { 
		log_debug('Catched Exception'); 
		return; 
  }
}

function save_all_editors(element) {
	try { 
		var inst = false; 
		elements = document.getElementsByTagName('textarea');
		if(!elements || elements == undefined || elements == null) { log_debug('Error: elements in init_all_editors is undefined'); return; }
		log_debug('saving all editors'); 
		for (var i = 0; i < elements.length; i++) {
			elem_id = elements.item(i).id; 
			if(elem_id && elem_id.match('lore_textarea')) { 
				inst = $(elem_id);
			}
			if(inst) { save_editor(inst.id); }
		}
  } catch(e) { 
		log_debug('Catched Exception'); 
  }
  return true; 
}

function enlarge_textarea() {
    for(i=0; i<10; i++) {
      inst = document.getElementById('mce_editor_'+i); 
      if(inst) { Element.setStyle(inst, { width: '500px', height: '300px' }); }
    }
}


function init_user_profile()
{
    alert('foo'); 
    init_editor('guestbook_textarea'); 
}

var calendar; 
function open_calendar(field_id, button_id)
{

    var onSelect = function(calendar, date) { 
      document.getElementById(field_id).value = date; 
      if (calendar.dateClicked) {
          calendar.callCloseHandler(); // this calls "onClose" (see above)
      };
    }
    var onClose = function(calendar) { calendar.hide(); }

    calendar = new Calendar(1, null, onSelect, onClose);

    calendar.create(); 

    calendar.showAtElement(document.getElementById(field_id), 'Bl'); 

    return; ///////////////////////////////////////////////////////////

    if(document.getElementById('date_field')) {
      Calendar.setup({
             inputField  : "date_field",  // ID of the input field
             ifFormat    : "%d.%m.%Y",    // the date format
             button      : "date_trigger" // ID of the button
      });
    }
}

function reload_selected_media_assets()
{
    cb__load_interface_silently('selected_media_assets', '/aurita/Wiki::Media_Asset/list_selected/content_id='+active_text_asset_content_id);
}
function asset_entry_string(image_index, content_id, media_asset_id, thumbnail_suffix)
{
  if(!thumbnail_suffix || thumbnail_suffix == 'jpg') { 
    thumbnail_suffix = media_asset_id; 
  }
  string = ''+
   '<div id="image_wrap__'+content_id+'">'+
   '<div style="float: left; margin-top: 4px; margin-left: 4px; height: 120px; border: 1px solid #aaaaaa; background-color: #ffffff; ">'+
     '<div style="height: 100px; width: 120px; overflow: hidden;">'+
       '<img src="/aurita/assets/thumb/asset_'+thumbnail_suffix+'.jpg" />'+
     '</div>'+
     '<div onclick="deselect_image('+content_id+');" style="cursor: pointer; background-color: #eaeaea; padding: 3px; position: relative; left: 0px; bottom: 0px; width: 12px; height: 12px; text-align: center; ">X</div>'+
   '</div>'+
   '</div>'; 

   return string; 
}
var active_text_asset_content_id;
function mark_image(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix)
{
  marked_image_register = document.getElementById('marked_image_register').value; 
  if (marked_image_register != '') { 
      marked_image_register += '_'; 
  }
  marked_image_register += media_asset_content_id; 
  document.getElementById('marked_image_register').value = marked_image_register; 

  document.getElementById('selected_media_assets').innerHTML += asset_entry_string(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix);
}
function deselect_image(media_asset_content_id) 
{ 
  Cuba.delete_element('image_wrap__'+ media_asset_content_id);
  marked_image_register = document.getElementById('marked_image_register').value; 
  marked_image_register = marked_image_register.replace(media_asset_content_id, '').replace('__', '_');
  document.getElementById('marked_image_register').value = marked_image_register; 
}
function init_container_inline_editor(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
    init_all_editors(); 
}
/** XHConn - Simple XMLHTTP Interface - bfults@gmail.com - 2005-04-08        **
 ** Code licensed under Creative Commons Attribution-ShareAlike License      **
 ** http://creativecommons.org/licenses/by-sa/2.0/                           **/
function XHConn()
{
  var xmlhttp, bComplete = false;

  try {
      //    netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (e) {
    alert("Permission UniversalBrowserRead denied.");
  }

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (e) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (e) { try { xmlhttp = new XMLHttpRequest(); }
  catch (e) { xmlhttp = false; }}}
  if (!xmlhttp) return null;
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars) {
  
      if(postVars == undefined) { postVars = ""; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
  	      sURL += '&randseed='+Math.round(Math.random()*100000);
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type",
                                     "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
              bComplete = true;
              if(fnDone) { 
                    fnDone(xmlhttp, element, sMethod=='POST');
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
	      xmlhttp.setRequestHeader("Content-Type",
				       "application/x-www-form-urlencoded");
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

/*
// Maps interface names to init functions. Means "Call this function 
// after this interface has been requested"
Cuba.init_functions = { 
    'Wiki::Article.show' : init_article_interface, 
    'Wiki::Container.update' : init_all_editors, 
    'App_Main.login' : init_login_screen
};

// Maps element ids to init functions. Means: "Call this function when 
// updating this element". This Hash is to be filled automatically. 
Cuba.element_init_functions = {}
Cuba.update_targets = {}; 
*/
function update_element(xml_conn, element, do_update_source)
{
    if(element) {
	response = xml_conn.responseText;

	if(response == "\n") 
	{
	    if(element.id == 'context_menu') {
        context_menu_close(); 
	    }
	    element.display = 'none';
	} 
	else
	{
	    element.innerHTML = response; 

	    init_fun = Cuba.element_init_functions[element.id]
	    if(init_fun) { init_fun(element); }
	}
    }
    if(do_update_source) {
      for(var target in Cuba.update_targets) {
          url = Cuba.update_targets[target];
          cb__update_element(target, url); 
      }
    }
}
function update_element_and_targets(xml_conn, element, update_targets) // update_targets is ignored here
{
    t = '';
    for(var target in Cuba.update_targets) {
	t += target;
    }
//  alert('update '+t+':'+update_targets);
    update_element(xml_conn, element, true); 
}


function cb__get_remote_string(url, response_fun)
{
    var xml_conn = new XHConn; 
    xml_conn.get_string(url, response_fun);
}

function cb__get_form_values(form_id)
{
    form = document.getElementById(form_id);
    
    string = ''
    for(index=0; index<form.elements.length; index++) {
	element = form.elements[index]; 
	if(element.value != '' && element.name != '') { 
	    element_value = element.value;
	    element_value = element_value.replace(/&auml;/g,'ä'); 
	    element_value = element_value.replace(/&ouml;/g,'ö'); 
	    element_value = element_value.replace(/&uuml;/g,'ü'); 
	    element_value = element_value.replace(/&Auml;/g,'Ä'); 
	    element_value = element_value.replace(/&Ouml;/g,'Ö'); 
	    element_value = element_value.replace(/&Uuml;/g,'Ü'); 
	    element_value = element_value.replace(/&szlig;/g,'ß'); 
	    element_value = element_value.replace(/&nbsp;/g,' '); 

	    string += element.name + '=' + element_value + '&'; 
	}
    }
    return string
}

function cb__update_element(element_id, interface_url)
{
    element = document.getElementById(element_id);
    var xml_conn = new XHConn; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    xml_conn.connect(interface_url+'&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000), 'GET', update_element, element); 
}

function cb__remote_submit(form_id, target_id, targets)
{
    context_menu_autoclose = true; 
    target_url     = '/aurita/dispatch'; 
    postVars       = Cuba.get_form_values(form_id);
    postVarsHash   = Cuba.get_form_values_hash(form_id);
    postVars += 'cb__mode=dispatch'; 
    Cuba.update_targets = targets

    interface_call = postVarsHash['cb__model']+'.'+postVarsHash['cb__controller']
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    var xml_conn = new XHConn; 
    element = document.getElementById(target_id); 

    //    xml_conn.connect(target_url, 'POST', update_element_and_targets, element, postVars); 
    xml_conn.connect(target_url, 'POST', update_element, element, postVars); 
}

function cb__async_call(target_id, interface_url, on_complete_fun)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 
    if(on_complete_fun == undefined) { on_complete_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', on_complete_fun, element);
}

function cb__dispatch_interface(target_id, interface_url, update_fun)
{
//  new Effect.Appear(document.getElementById(target_id), {from:0.0, to:0.9, duration:0.5});
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');
    
    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
    
    if(update_fun == undefined && interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    if(update_fun == undefined) { update_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}

function cb__load_interface(target_id, interface_url, targets)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    element.innerHTML  = '<img src="/aurita/images/icons/loading.gif" />'; 
    Cuba.update_targets = targets; 
    if(interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    else { update_fun  = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}
function cb__load_interface_silently(target_id, interface_url)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    xml_conn.connect(interface_url, 'GET', update_element, element); 
}

// Only function allowed to close the 
// currently opened context menu. 
// Also responsible for cleanup-procedure. 
function cb__cancel_dispatch()
{
    context_menu_close();
    return; 
//    dispatcher_hide(); 
//    setTimeout('cb__unfade()',1000); 
    if(context_menu_opened) {
	context_menu_opened = false; 
	document.getElementById('context_menu').style.display = 'none'; 
	unfocus_element(context_menu_active_element_id); 
    } 
    else {
	new Effect.Fade('dispatcher', {duration: 0.5});
    }
}

function cb__show_fullscreen_cover()
{
    new Effect.Appear('app_fullscreen', { from: 0, to: 1 }); 
    Element.setStyle('app_body', { 'overflow-y': 'hidden' });  // override document scroll bars
    $('app_main_content').innerHTML = ''; 
}
function cb__hide_fullscreen_cover()
{
    Element.setStyle('app_body', { 'overflow-y': 'scroll' }); // reactivate document scroll bars
    Element.setStyle('app_fullscreen', { display: 'none' }); 
    $('app_fullscreen').innerHTML = ''; 
}

var Cuba = { 

    element: function(element_id)
    {
        element = document.getElementById(element_id); 
        if(!element) { 
            element = $(element_id); 
        }
        if(!element) { 
        //  alert('No such element: ' + element_id); 
        }
        return element;
    }, 

    delete_element: function(element_id) 
    {
        Element.remove(element_id); 
    },
    
    get_form_values: function(form_id)
    {
        var form; 
        if(document.forms) {
           form = eval('document.forms.'+form_id); 
        } 
        else {
           form = Cuba.element(form_id);
        }
        string = ''
        for(index=0; index<form.elements.length; index++) {
            element = form.elements[index]; 
            if(element.value != '' && element.name != '') { 
              element_value = element.value;
              element_value = element_value.replace(/&auml;/g,'ä'); 
              element_value = element_value.replace(/&ouml;/g,'ö'); 
              element_value = element_value.replace(/&uuml;/g,'ü'); 
              element_value = element_value.replace(/&Auml;/g,'Ä'); 
              element_value = element_value.replace(/&Ouml;/g,'Ö'); 
              element_value = element_value.replace(/&Uuml;/g,'Ü'); 
              element_value = element_value.replace(/&szlig;/g,'ß'); 
              element_value = element_value.replace(/&nbsp;/g,' '); 
              
              string += element.name + '=' + element_value + '&'; 
            }
        }
        return string;
    },

    get_form_values_hash: function(form_id)
    {
        var form; 
        if(document.forms) {
           form = eval('document.forms.'+form_id); 
        } 
        else {
           form = Cuba.element(form_id);
        }
	
        value_hash = {}; 
        for(index=0; index<form.elements.length; index++) {
            element = form.elements[index]; 
            if(element.value != '' && element.name != '') { 

              element_value = element.value;
              element_value = element_value.replace(/&auml;/g,'ä'); 
              element_value = element_value.replace(/&ouml;/g,'ö'); 
              element_value = element_value.replace(/&uuml;/g,'ü'); 
              element_value = element_value.replace(/&Auml;/g,'Ä'); 
              element_value = element_value.replace(/&Ouml;/g,'Ö'); 
              element_value = element_value.replace(/&Uuml;/g,'Ü'); 
              element_value = element_value.replace(/&szlig;/g,'ß'); 
              element_value = element_value.replace(/&nbsp;/g,' '); 
              
              value_hash[element.name] = element_value;
            }
        }
        return value_hash;
    },
    
    get_remote_string: function(url, response_fun)
    {
        var xml_conn = new XHConn; 
        xml_conn.get_string(url, response_fun);
    },
    
    after_submit_target_map: {
        'Wiki::Article.perform_add': { 'app_main_content': 'Wiki::Article.show_own_latest' }, 
        'Community::Role_Permissions.perform_add': { 'app_main_content': 'Community::Role.list' }, 
        'Form_Builder.perform_add': { 'app_main_content': 'Form_Builder.form_added' }, 
        'Community::User_Profile.perform_update': { 'app_main_content': 'Community::User_Profile.show_own' }, 
        'Community::User_Message.perform_add' : { 'messaging_content' : 'Community::User_Message.message_sent'}
    }, 

    after_submit_targets: function(form_id) { 
     // form_values = Cuba.get_form_values_hash(form_id); 
        form_values = Form.serialize(form_id, true); 
        targets = Cuba.after_submit_target_map[form_values['cb__model']+'.'+form_values['cb__controller']];
        return targets; 
    }, 
    
    update_targets: {}, 
    init_functions: {
      'Wiki::Article.show': init_article_interface, 
      'App_Main.login': init_login_screen, 
      'Community::User_Profile.register_user': init_login_screen, 
      'Community::User_Profile.show_galery': initLightbox, 
      'Wiki::Media_Asset_Folder.show': initLightbox
    }, 
    element_init_functions: {}, 

    load_element_content: function(element_id, interface_url)
    {
        element = Cuba.element(element_id); 
        var xml_conn = new XHConn; 
        
        interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
        interface_call = interface_call.replace('/','');

        init_fun = Cuba.init_functions[interface_call];

        if(init_fun && element) { Cuba.element_init_functions[element.id] = init_fun; }
        
//      xml_conn.connect(interface_url+'&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000), 'GET', Cuba.update_element_only, element); 
        xml_conn.connect(interface_url+'&cb__mode=dispatch', 'GET', Cuba.update_element_only, element, true); 
    },

    update_element: function(xml_conn, element, do_update_source)
    {
        if(element) 
        {
          response = xml_conn.responseText;
          if(response == "\n" || response == '') 
          {
            // This might be a hack: 
            // We currenltly are setting (brute force) element_id to 'dispatcher' in 
            // Cuba.remote_submit (because there, it's the only sensible target element). 
            // Then, however, target 'context_menu' is overridden, so it wouldn't be closed 
            // here. 
            if(element.id == 'context_menu') {
              context_menu_close(); 
            } 
          } 
          else
          {
            element.innerHTML = response; 
          }
          init_fun = Cuba.element_init_functions[element.id]
          if(init_fun) { init_fun(element); }
        }

        if(Cuba.update_targets) {
          for(var target in Cuba.update_targets) {
            if(Cuba.update_targets[target]) { 
              url = '/aurita/'+(Cuba.update_targets[target].replace('.','/'));
              url += '&randseed='+Math.round(Math.random()*100000);
              Cuba.load_element_content(target, url);
            }
          }
          // Reset targets so they will be set in next load/remote_submit call: 
          Cuba.update_targets = null; 
        }
    },

    update_element_only: function(xml_conn, element, do_update_source)
    {
      if(element) 
      {
        response = xml_conn.responseText;

        if(response == "\n") 
        {
            if(element.id == 'context_menu') {
              context_menu_close(); 
            }
            Element.setStyle(element, { display: 'none' });
        } 
        else
        {
            element.innerHTML = response; 
        }
        init_fun = Cuba.element_init_functions[element.id]; 
        if(init_fun) { init_fun(element); }
      }
    },

    call: function(interface_url)
    {
      var xml_conn = new XHConn; 
      interface_url += '&cb__mode=dispatch'; 
      xml_conn.connect('/aurita/'+interface_url, 'GET', null, null); 
    },

    current_interface_calls: {}, 
    completed_interface_calls: {}, 
    dispatch_interface: function(params)
    {
      target_id     = params['target']; 
      interface_url = '/aurita/' + params['interface_url']; 
      interface_url.replace('/aurita//aurita/','/aurita/'); 
      
      if(Cuba.current_interface_calls[interface_url]) { log_debug("Duplicate interface call?"); }
      Cuba.current_interface_calls[interface_url] = true; 
      
      log_debug("Dispatch interface "+interface_url);

      update_fun    = params['on_update']; 
      
      Cuba.update_targets = params['targets']; 
      var xml_conn = new XHConn; 
      interface_url += '&cb__mode=dispatch'; 
      element = Cuba.element(target_id); 
      if(!params['silently']) { 
        element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 
      }
      interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
      interface_call = interface_call.replace('/','');
      init_fun = Cuba.init_functions[interface_call];
      if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
      if(update_fun == undefined) { update_fun = Cuba.update_element; }
      xml_conn.connect(interface_url, 'GET', update_fun, element); 
    },

    remote_submit: function(form_id, target_id, targets)
    {

      context_menu_autoclose = true; 
      target_url     = '/aurita/dispatch'; 
      postVars       = Form.serialize(form_id);
      // postVars = Cuba.get_form_values(form_id); 
      postVars += '&cb__mode=dispatch&x=1'; 
      // postVarsHash   = Cuba.get_form_values_hash(form_id); 
      postVarsHash   = Form.serialize(form_id, true); 
      if(targets && !Cuba.update_targets) { 
          Cuba.update_targets = targets; 
      }
      else { 
        // update targets
          for(t in targets) { 
            Cuba.update_targets[t] = targets[t]; 
          }
      }
      
      interface_call = postVarsHash['cb__model']+'.'+postVarsHash['cb__controller']; 
      init_fun = Cuba.init_functions[interface_call];
      if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
      
      var xml_conn = new XHConn; 
      element = Cuba.element(target_id); 
      xml_conn.connect(target_url, 'POST', Cuba.update_element, element, postVars); 
    },

    async_submit: function(params) { 
        Cuba.remote_submit(params['form'], params['element']); 
    },

    load: function(params) {
        params['interface_url'] = params['action']; 
        params['target']        = params['element']; 
        params['targets']       = params['redirect_after']; 
        params['on_update']     = params['on_update']; 
        Cuba.dispatch_interface(params); 
    },

    cancel_dispatch: function() 
    {
      Cuba.close_context_menu();
    },
    // A message box is printing a string (message_text) and 
    // offers a button to close it. 
    alert: function(message_text) {
        Cuba.message_box = new MessageBox({ interface_url: 'App_Main/alert_box/message='+message_text });
        Cuba.message_box.open();
    },
    // A popup includes an arbitrary interface. 
    popup: function(action) {
        Cuba.message_box = new MessageBox({ interface_url: action });
        Cuba.message_box.open();
    },
    
    confirmed_interface: '',
    unconfirmed_interface: '', 
    message_box: undefined, 
    
    on_confirm_action: function() {}, 

    after_confirmed_action: function(xml_conn, element) 
    {
      // do nothing
    },

    // Usage: 
    // <span onclick="Cuba.confirmable_action({ call: 'Community::Forum_Post/delete/forum_post_id=123', 
    //                                          message: 'Really delete post?', 
    //                                          targets: { post_list: 'Community::Forum_Post/list/' } 
    //                                       });" >
    //   delete post
    // </span>
    confirmable_action: function(params) {
      interface_url = params['action']; 
      message       = params['message']; 
      targets       = params['targets']; 
      Cuba.message_box = new MessageBox({ interface_url: 'App_Main/confirmation_box/message='+message }); 
      Cuba.unconfirmed_interface = interface_url; 
      if(params['onconfirm']) { 
        Cuba.on_confirm_action = params['onconfirm']; 
      }
      Cuba.update_targets = targets; 
      Cuba.message_box.open();
    }, 
    confirm_action: function() { 
      Cuba.dispatch_interface({ target: 'dispatcher', 
                                interface_url: Cuba.unconfirmed_interface, 
                                on_update: Cuba.after_confirmed_action, 
                                targets: Cuba.update_targets });
      Cuba.update_targets = {}; 
      Cuba.on_confirm_action(); 
      Cuba.message_box.close(); 
    }, 
    cancel_action: function() { 
      Cuba.update_targets = {}; 
      Cuba.message_box.close(); 
    },

    waiting_for_file_upload: false, 
    before_file_upload: function() {
      Cuba.waiting_for_file_upload = true; 
      Element.setStyle('file_upload_indicator', { display: '' });
    },
    after_file_upload: function() { 
      if(Cuba.waiting_for_file_upload) {
        Element.setStyle('file_upload_indicator', { display: 'none' });
        Cuba.waiting_for_file_upload = false; 
        alert('Datei wurde auf den Server geladen');
      }
    }, 
    upload_file: function(form_id) {
                   alert('upload');
      if(Cuba.waiting_for_file_upload) { 
        alert('Ein anderer Upload l&auml;uft bereits');
        return false;
      }
      Cuba.before_file_upload(); 
      Element.toggle(form_id); 
      Element.toggle('upload_confirmation');
      return true; 
    }
      

} // Namespace Cuba


Cuba.force_load = false; 

Cuba.set_ie_history_fix_iframe_src = function(url) 
{ 
  if(wait_for_iframe_sync == '1') { 
    wait_for_iframe_sync = '0'; 
  } else { 
    wait_for_iframe_sync = '1'; 
  }
  Cuba.ie_history_fix_iframe = parent.ie_fix_history_frame; 
  Cuba.ie_history_fix_iframe.location.href = url; 
};

Cuba.set_hashcode = function(code) 
{
  if(Cuba.check_if_internet_explorer() == 1)
  {
    Cuba.set_ie_history_fix_iframe_src('/aurita/get_code.fcgi?code='+code);
  }
  Cuba.force_load = true; 
  document.location.href = '#'+code;
  Cuba.check_hashvalue(); 
}; 
Cuba.append_hashcode = function(code) { 
    Cuba.force_load = true; 
    document.location.href += '--' + code;
    Cuba.check_hashvalue(); 
}; 


var IFrameObj; // our IFrame object
Cuba.ie_fix_history_frame = function() 
{
  iframe_id = 'ie_fix_history_iframe';

  if (!document.createElement) {return true};
  var IFrameDoc;
  if (!IFrameObj && document.createElement) {
    // create the IFrame and assign a reference to the
    // object to our global variable IFrameObj.
    // this will only happen the first time 
    // callToServer() is called
   try {
      var tempIFrame=document.createElement('iframe');
      tempIFrame.setAttribute('id',iframe_id);
      tempIFrame.style.border='0px';
      tempIFrame.style.width='0px';
      tempIFrame.style.height='0px';
      IFrameObj = document.body.appendChild(tempIFrame);
      
      if (document.frames) {
        // this is for IE5 Mac, because it will only
        // allow access to the document object
        // of the IFrame if we access it through
        // the document.frames array
        IFrameObj = document.frames[iframe_id];
      }
    } catch(exception) {
      // This is for IE5 PC, which does not allow dynamic creation
      // and manipulation of an iframe object. Instead, we'll fake
      // it up by creating our own objects.
      iframeHTML='\<iframe id="'+iframe_id+'" style="';
      iframeHTML+='border:0px;';
      iframeHTML+='width:0px;';
      iframeHTML+='height:0px;';
      iframeHTML+='"><\/iframe>';
      document.body.innerHTML+=iframeHTML;
      IFrameObj = new Object();
      IFrameObj.document = new Object();
      IFrameObj.document.location = new Object();
      IFrameObj.document.location.iframe = document.getElementById(iframe_id);
      IFrameObj.document.location.replace = function(location) {
        this.iframe.src = location;
      }
    }
  }
  
  if (navigator.userAgent.indexOf('Gecko') !=-1 && !IFrameObj.contentDocument) {
    // we have to give NS6 a fraction of a second
    // to recognize the new IFrame
    setTimeout('callToServer()',10);
    return false;
  }
  
  // For access to JS functions in IFrame: 
/*
  if (IFrameObj.contentDocument) {
    // For NS6
    IFrameDoc = IFrameObj.contentDocument; 
  } else if (IFrameObj.contentWindow) {
    // For IE5.5 and IE6
    IFrameDoc = IFrameObj.contentWindow.document;
  } else if (IFrameObj.document) {
    // For IE5
    IFrameDoc = IFrameObj.document;
  } else {
    return true;
  }
  return IFrameDoc;
*/
  return IFrameObj;
}

Cuba.toggle_box = function(box_id) { 
  Element.toggle(box_id + '_body'); 
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
  } else { 
    collapsed_boxes.push(box_id); 
    setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
    $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
  }
}; 
Cuba.close_box = function(box_id) { 
  Element.hide(box_id + '_body'); 
  $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
}; 

  
function show_image(text, li)
{
    media_asset_id = text.id; 
    cb__load_interface('media_folder_content', '/aurita/Wiki::Media_Asset/show/media_asset_id='+media_asset_id);
};

var drop_target_folder; 
function activate_target(draggable, droppable, overlap_perc)
{
    drop_target_folder = droppable; 
};
function drop_image_in_folder(element)
{
    element.style.display = 'none'; 
    if (element.id.search('image') != -1)
    {
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_asset_id='+element.id);
   	}
   	else if(element.id.search('folder') != -1)
   	{
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset_Folder/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_folder_asset_id='+element.id);
   	}
};

Cuba.media_asset_draggables = {}; 
Cuba.create_media_asset_draggable = function(element_id, options) { 
  if(Cuba.media_asset_draggables[element_id] == undefined) {
    Cuba.media_asset_draggables[element_id] = new Draggable(element_id, options);
  }
};

Cuba.destroy_draggables = function() {
  for(var x in Cuba.media_asset_draggables) { 
    Cuba.media_asset_draggables[x].destroy(); 
  }
  Cuba.media_asset_draggables = {}; 
};

Cuba.droppables = {};

Cuba.remove_droppables = function() {
  for(var x in Cuba.droppables) {
      Droppables.remove(document.getElementById('folder_'+Cuba.droppables[x]));
  }
	Cuba.droppables = {};
}

Cuba.shutdown_media_management = function() {
  Cuba.remove_droppables(); 
  Cuba.destroy_draggables(); 
  cb__hide_fullscreen_cover(); 
  Cuba.expanded_folder_ids = {}; 
}

Cuba.expanded_folder_ids = {}
Cuba.load_media_asset_folder_level = function(parent_folder_id, indent) {
  if(Cuba.expanded_folder_ids[parent_folder_id]) {
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/plus.gif'; 
    Cuba.expanded_folder_ids[parent_folder_id] = false; 
    $('folder_children_'+parent_folder_id).innerHTML = '';
    return;
  }
  else { 
    Cuba.expanded_folder_ids[parent_folder_id] = true; 
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/minus.gif'; 
    Cuba.load({ element: 'folder_children_'+parent_folder_id, action: 'Wiki::Media_Asset/print_media_asset_folder_level/media_folder_id='+parent_folder_id+'&indent='+indent, on_update: init_media_interface}); 
  }
}

Cuba.select_media_asset = function(params) {
    var hidden_field_id = params['hidden_field']; 
    var user_id = params['user_id']; 
    var hidden_field = $(hidden_field_id); 
    var select_box_id = 'select_box_'+hidden_field_id;
    select_box = $(select_box_id); 
    Cuba.load({ element: select_box_id, 
                action: 'Wiki::Media_Asset/choose_from_user_folders/user_group_id='+user_id+'&element_id_to_update='+hidden_field_id }); 
    Element.setStyle(select_box, { display: 'block' });
    Element.setStyle(select_box, { width: '100%' });
}; 
Cuba.select_media_asset_click = function(media_asset_id, element_id_to_update) { 
    var hidden_field = $(element_id_to_update);
    var image = $('image_'+element_id_to_update); 
    select_box = $('select_box_'+element_id_to_update); 

    Element.setStyle(select_box, { display: 'none' }); 
    image.src = ''; 
    if(media_asset_id == 0) { 
      image.style.display = 'none';
      hidden_field.value = ''; 
      $('clear_selected_image_button').style.display = 'none'; 
        } else { 
      image.src = '/aurita/assets/asset_'+media_asset_id+'.jpg';
      image.style.display = 'block';
      hidden_field.value = media_asset_id; 
      $('clear_selected_image_button').style.display = ''; 
    }
}; 

Cuba.reload_image = function(element) { 
	var image = $('reloadable_image'); 
	var src = image.src; 
	image.src = ""; 
	image.src = src + '?' + Math.round(Math.random()*1000); 
};

Cuba.folder_hierarchy = new Array();
Cuba.folder_hierarchy.push(0);

Cuba.add_folder_to_hierarchy = function(value) {
  
}

Cuba.open_folder = 0;

Cuba.change_folder_icon = function(value) { 
	folder_to_open = $("folder_icon_" + value);
  folder_to_close = $("folder_icon_" + Cuba.open_folder);
  if(folder_to_close) { 
	  folder_to_close.src = "/aurita/images/icons/folder_closed.gif"; 
  }
	folder_to_open.src = "/aurita/images/icons/folder_opened.gif"; 
  Cuba.open_folder = value;
};

Cuba.reload_background_image = function(element) {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image.style.backgroundImage = ""; 
	image.style.backgroundImage = 'url(' + url + '?' + Math.round(Math.random()*1000) + ')'; 
};

Cuba.rotation_counter = 0;

Cuba.increment_rotation_counter = function() {
	Cuba.rotation_counter += 1;
};

Cuba.check_if_internet_explorer = function() {
  var nAgt = navigator.userAgent;
  if ((verOffset = nAgt.indexOf("MSIE")) != -1) {
    return 1;
  }
  else {
    return 0;
  }
};

Cuba.calculate_aspect_ratio = function() {
  Cuba.check_if_internet_explorer();
	image = $('image_preview');
  url = Element.getStyle('image_preview', 'height');
	url = url.replace(/url\(([^\)]+)\)/,'$1');
  Element.setStyle('image_preview', {'src': url});
	height = Element.getHeight('image_preview'); 
	width = Element.getWidth('image_preview');
	ratio = height / width;
	height = parseInt(width / ratio); 
	if(Cuba.check_if_internet_explorer() == 1) {
    Element.setStyle('crop_line_bottom', { 'top': height-8 } ); 
	}
  else {
    Element.setStyle('crop_line_bottom', { 'top': height-6 } ); 
  }
  Element.setStyle('crop_line_left',   { 'height': height+4 } ); 
  Element.setStyle('crop_line_right',  { 'height': height+4 } ); 
	image.style.height = height;
};

Cuba.ignore_manipulation = false; 
Cuba.image_brightness    = 1.0; 
Cuba.image_hue           = 1.0; 
Cuba.image_saturation    = 1.0; 
Cuba.image_contrast	     = 100; 

Cuba.image_manipulate_brightness = function(value) { 
	Cuba.image_brightness = value; 
	Cuba.manipulate_image();
};
Cuba.image_manipulate_hue = function(value) { 
	Cuba.image_hue = value; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_saturation = function(value) { 
	Cuba.image_saturation = value; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_contrast = function(value) { 
	Cuba.image_contrast = value; 
	Cuba.manipulate_image(); 
};

Cuba.manipulate_image = function(slider_value) // Ignore param
{
   if(!Cuba.ignore_manipulation) { 
     action = 'Wiki::Media_Asset/manipulate/media_asset_id='+ Cuba.active_media_asset_id;
     action += '&brightness='+Cuba.image_brightness;
     action += '&hue='+Cuba.image_hue;
     action += '&saturation='+Cuba.image_saturation; 
     action += '&contrast='+Cuba.image_contrast;
     Cuba.load({ action: action, 
		         element: 'dispatcher', 
		         on_update: Cuba.reload_background_image });
     }
}

Cuba.init_image_manipulation_sliders = function() {
	Cuba.image_brightness_slider = new Control.Slider('brightness_handle', 'brightness_track', {
	    onChange: Cuba.image_manipulate_brightness, 
		range: $R(0,2), 
		sliderValue: 1 }); 
	Cuba.image_hue_slider = new Control.Slider('hue_handle', 'hue_track', {
	    onChange: Cuba.image_manipulate_hue, 
		range: $R(0,2), 
		sliderValue: 1 });
	Cuba.image_saturation_slider = new Control.Slider('saturation_handle', 'saturation_track', {
	    onChange: Cuba.image_manipulate_saturation, 
		range: $R(0,2), 
		sliderValue: 1 });	
	Cuba.image_contrast_slider = new Control.Slider('contrast_handle', 'contrast_track', {
	    onChange: Cuba.image_manipulate_contrast, 
		range: $R(1,200), 
		sliderValue: 100 });
};

Cuba.reset_image = function() { 
    Cuba.ignore_manipulation = true; 
	Cuba.image_brightness_slider.setValue(1);
	Cuba.image_hue_slider.setValue(1);
	Cuba.image_saturation_slider.setValue(1);
	Cuba.image_contrast_slider.setValue(100);
	if(Cuba.rotation_counter % 2 == 1)
	{
		Cuba.calculate_aspect_ratio();
	}
	Cuba.rotation_counter = 0;
	Cuba.reload_background_image();
	Cuba.ignore_manipulation = false; 

};


Cuba.init_crop_lines = function() {
    
    new Draggable('crop_line_left', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_right', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_top', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
    new Draggable('crop_line_bottom', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
};

Cuba.resolve_slider_positions = function() {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image_file = new Image(); 
	image_file.src = url; 
	image_height = image_file.height; 

	position_top = parseInt($('crop_line_top').style.top) + 405;
	position_bottom = parseInt($('crop_line_bottom').style.top) - image_height + 6;
	position_left = parseInt($('crop_line_left').style.left) + 305;
	position_right = parseInt($('crop_line_right').style.left) - 299;
	Cuba.slider_positions = {top: position_top, bottom: position_bottom, left: position_left, right: position_right, height: image_height };
}

Cuba.init_image_manipulation = function(xml_conn, element) { 
	element.innerHTML = xml_conn.responseText;
	Cuba.init_image_manipulation_sliders();
	Cuba.init_crop_lines(); 
}; 


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
    cb__get_remote_string('/aurita/App_Main/validate_user/cb__mode=dispatch&login='+login+'&pass='+pass, Login.check_success); 
  }

} // Namespace Login

var Aurita = {

    last_username: '', 
    username_input_element: '0',

    check_username_available: function(result) { 
	if(result.match('true')) { 
	    Element.setStyle(Aurita.username_input_element, { 'border-color': '#00ff00' });
	} else { 
	    Element.setStyle(Aurita.username_input_element, { 'border-color': '#ff0000' });
	}
    },

    username_available: function(input_element) { 
	if(input_element.value == Aurita.last_username) { return; }
	Aurita.username_input_element = input_element; 
	Aurita.last_username = input_element.value; 
	cb__get_remote_string('/aurita/RBAC::User_Group/username_available/cb__mode=dispatch&user_group_name='+input_element.value, Aurita.check_username_available);
    }

} // namespace Aurita

Cuba.app_domains = ['wortundform2.selfip.com', '192.168.54.108']; 

Cuba.append_autocomplete_value = function(field_id, value) { 
  field = $(field_id); 
  fullvalue = field.value.replace(',', ' ').replace(/\s+/, ' '); 
  values = fullvalue.split(' '); 
  values.pop(); 
  values.push(value); 
  field.value = values.join(' '); 
  field.focus(); 
}

Cuba.get_ie_history_fix_iframe_code = function() 
{
  try { 
    hashcode = parent.ie_fix_history_frame.location.href; 
    for(var i in Cuba.app_domains) {
      hashcode = hashcode.replace('http://'+Cuba.app_domains[i]+'/aurita/get_code.fcgi?code=',''); 
    }
  } catch(e) { 
    hashcode = parent.ie_fix_history_frame.get_code(); 
  }
  return hashcode; 
}

Cuba.last_hashvalue = ''; 
var home_loaded = false; 
wait_for_iframe_sync = '0'; 
Cuba.check_hashvalue = function() 
{
    current_hashvalue = document.location.hash.replace('#',''); 


    if(current_hashvalue.match(/(.+)?_anchor/)) { return;  } 

    if(Cuba.check_if_internet_explorer() == 1) { 
      iframe_hashvalue = Cuba.get_ie_history_fix_iframe_code(); 
      if(iframe_hashvalue != 'no_code' && iframe_hashvalue != current_hashvalue && !Cuba.force_load && iframe_hashvalue != '' && !iframe_hashvalue.match('about:')) { 
        current_hashvalue = iframe_hashvalue; 
      }
      if(document.location.hash != '#'+current_hashvalue) { document.location.hash = current_hashvalue; }
    }

    if(Cuba.force_load || current_hashvalue != Cuba.last_hashvalue && current_hashvalue != '') 
    { 
      window.scrollTo(0,0);

      Cuba.force_load = false; 
      log_debug("loading interface for "+current_hashvalue); 
      flush_editor_register(); 
      Cuba.last_hashvalue = current_hashvalue;

      if(current_hashvalue.match('article--')) { 
          aid = current_hashvalue.replace('article--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Article/show/article_id='+aid, 
                      on_update: init_article }); 
      }
      else if(current_hashvalue.match('user--')) { 
          uid = current_hashvalue.replace('user--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::User_Profile/show_by_username/user_group_name='+uid }); 
      }
      else if(current_hashvalue.match('media--')) { 
          maid = current_hashvalue.replace('media--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Media_Asset/show/media_asset_id='+maid }); 
      }
      else if(current_hashvalue.match('folder--')) { 
          mafid = current_hashvalue.replace('folder--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Media_Asset_Folder/show/media_folder_id='+mafid }); 
      }
      else if(current_hashvalue.match('playlist--')) { 
          pid = current_hashvalue.replace('playlist--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::Playlist_Entry/show/playlist_id='+pid }); 
      }
      else if(current_hashvalue.match('video--')) { 
          vid = current_hashvalue.replace('video--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/play_youtube_video/playlist_entry_id='+vid }); 
      }
      else if(current_hashvalue.match('find--')) { 
          pattern = current_hashvalue.replace('find--','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find/key='+pattern }); 
      }
      else if(current_hashvalue.match('find_full--')) { 
          pattern = current_hashvalue.replace('find_full--','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find_full/key='+pattern }); 
      }
      else if(current_hashvalue.match('topic--')) { 
          tid = current_hashvalue.replace('topic--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::Forum_Topic/show/forum_topic_id='+tid }); 
      }
      else if(current_hashvalue.match('app--')) { 
          action = current_hashvalue.replace('app--','').replace('+','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/'+action+'/' }); 
      }
      else if(current_hashvalue.match('calendar--')) { 
          action = current_hashvalue.replace('calendar--','').replace('+','').replace(/ /g,''); 
          if(action.substr(0,5) == 'day--') { 
            action = 'day/date=' + action.replace('day--','');
          }
          Cuba.load({ element: 'app_main_content', 
                      action: 'Calendar/'+action+'/' }); 
      }
      else {
        action = current_hashvalue.replace('--','/');
          // split hash into controller--action--param1--value1--param2--value2...
          Cuba.load({ element: 'app_main_content', 
                      action: action }); 
      }

    } 
}; 
window.setInterval(Cuba.check_hashvalue, 1000); 

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

      function on_data(xml_conn, element)
      {
         log_debug('on_data triggered'); 
         element.innerHTML = xml_conn.responseText; 
         // collapse hierarchy boxes
         collapsed_boxes = getCookie('collapsed_boxes'); 
         if(collapsed_boxes) {
           collapsed_boxes = collapsed_boxes.split('-'); 
           for(b=0; b<collapsed_boxes.length; b++) { 
             box_id = collapsed_boxes[b]; 
             if($(box_id)) { 
               Cuba.close_box(box_id); 
             }
           }
         }
         // display content
         Effect.Appear(element, {duration: 0.5}); 
         init_fun = Cuba.element_init_functions[element.id]
         if(init_fun) { init_fun(element); }
      }
      
      function app_load_interfaces(setup_name)
      {
        log_debug('in app_load_interface '+setup_name); 
//      document.getElementById('app_body').className = 'site_body_'+setup_name; 
        cb__dispatch_interface('app_left_column',  '/aurita/'+setup_name+'/left',  on_data); 
        cb__dispatch_interface('app_main_content', '/aurita/'+setup_name+'/main',  on_data); 
      }
      var active_button; 
      function app_load_setup(setup_name)
      {
        new Effect.Fade('app_left_column', {duration: 0.5}); 
        new Effect.Fade('app_main_content', {duration: 0.5}); 
        if(active_button) { 
          active_button.className = 'header_button';
        }
        active_button = document.getElementById('button_'+setup_name); 
        active_button.className = 'header_button_active';
        setTimeout(function() { app_load_interfaces(setup_name) }, 550); 

      }

      tinyMCE.init({
//    do not provide mode! Editor inits are handled event-based when needed. 

      plugins : 'paste, auritalink',
      theme : "advanced",
      relative_urls : true,
      valid_elements : "*[*]",
      extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
      content_css : "/aurita/inc/editor_content.css",
      editor_css : "/aurita/inc/editor.css", 
      theme_advanced_toolbar_align : "left", 
      theme_advanced_buttons1 : "bold,italic,underline,bullist,numlist,pastetext,unlink", 
      theme_advanced_buttons1_add : 'auritalink',
      theme_advanced_buttons2 : "", 
      theme_advanced_buttons3 : "", 
      theme_advanced_toolbar_location : "top"
      });

      loading = new Image(); 
      loading.src = '/aurita/images/icons/loading.gif'; 

      Cuba.context_menu_draggable = new Draggable('context_menu');
      new Draggable('dispatcher');

      Cuba.disable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable.destroy(); 
      }
      Cuba.enable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable = new Draggable('context_menu');
      }
        


      function interval_reload(elem_id, url, seconds)
      {
        setInterval(function() { if(!Cuba.update_targets) { Cuba.load({ element: elem_id, action: url, silently: true }) } }, seconds * 1000 );
      } 
      interval_reload('changed_articles_body', 'Article/print_recently_changed/', 60); 
      interval_reload('viewed_articles_body', 'Article/print_recently_viewed/', 20); 

      function toggle_mail_notifier(result) { 
        result = result.replace(' ','').replace("\n",''); 
        var new_mail = (result.lastIndexOf("0") == -1 && result != ''); 
        $('dispatcher').innerHTML = result+': '+new_mail; 
        if (new_mail) { 
          Element.setStyle('new_mail_notifier', { display: '' });
          $('unread_mail_amount').innerHTML = '(' + result + ')'; 
        } 
        else { 
          Element.setStyle('new_mail_notifier', { display: 'none' });
        }
      }

      function check_mail_for_user() { 
//      Cuba.get_remote_string('/aurita/User_Message/check_mail_for_user/cb__mode=none', toggle_mail_notifier);
      }
//    setInterval(check_mail_for_user, 30000);

      Cuba.check_hashvalue(); 

      document.getElementById('app_main_content').style['min-height'] = (window.innerHeight-177)+'px';
=======
}if(/WebKit/i.test(navigator.userAgent)){var _timer=setInterval(function(){if(/loaded|complete/.test(document.readyState)){init()}},10)}window.onload=init;function rd_admin__ui__tool_showhide(A,D){if(D!=""){var C=get_object_by_id(D,"");var B=get_object_by_id(A,D)}else{B=get_object_by_id(A,"")}if(B.display=="none"){B.display="";if(D!=""){C.width="240px"}}else{B.display="none";if(D!=""){C.width="24px"}}}function rd_admin__ui__tool_varwidth_showhide(A,E,B){var D=get_object_by_id(E,"");var C=get_object_by_id(A,E);if(C.display=="none"){C.display="";D.width=B+"px"}else{C.display="none";D.width="24px"}}function rd_admin__ui__show(A,C){var B=get_object_by_id(A,C);B.display=""}function rd_admin__ui__hide(A,C){var B=get_object_by_id(A,C);B.display="none"}function rd_admin__handle_exception(B,A){rd_admin__ui__showhide("rd_admin__ui__error","")}function rd_admin__raise_exception(N,O,K,C,M,J,B,L,D,A,E){rd_admin__ui__show("rd_admin__ui__error","");if(C!=""){rd_admin__ui__show_button("rd_admin__ui__error_button1","rd_admin__ui__error",K,M)}if(B!=""){rd_admin__ui__show("rd_admin__ui__error_button2","rd_admin__ui__error")}else{rd_admin__ui__hide("rd_admin__ui__error_button2","rd_admin__ui__error")}if(A!=""){rd_admin__ui__show("rd_admin__ui__error_button3","rd_admin__ui__error")}else{rd_admin__ui__hide("rd_admin__ui__error_button3","rd_admin__ui__error")}}function rd_admin__ui__show_button(B,E,A,D){var C=get_object_by_id(B,E);C.display=""}function rd_admin__location(frame,url){eval(frame+".location.href='"+url+"'")}function rd_admin__popup_asset(B,A,C){if(A==undefined||A>screen.width){A=screen.width/2;resize="1"}if(C==undefined||C>screen.height){C=screen.height/2;resize="1"}LeftPosition=(screen.width)?(screen.width-A)/2:0;TopPosition=(screen.height)?(screen.height-C)/2:0;settings="height="+C+",width="+A+",top="+TopPosition+",left="+LeftPosition+",scrollbars=1,resizable="+resize+",menubar=0,fullscreen=0,status=0";win=window.open(B,"app",settings);win.focus()}function rd_admin__popup(B,C,A){w=C;h=A;LeftPosition=(screen.width)?(screen.width-w)/2:0;TopPosition=(screen.height)?(screen.height-h)/2:0;settings="height="+h+",width="+w+",top="+TopPosition+",left="+LeftPosition+",scrollbars=1,resizable=0,menubar=0,fullscreen=0,status=0";win=window.open(B,"win"+C+"x"+A,settings);win.focus()}function rd_admin__article_preview(B,A){rd_admin__popup("/projects/"+B+"/Node/preview_article/rd__article_id="+A,1024,768)}function rd_admin__node_preview(B,A,C){rd_admin__popup("/projects/"+B+"/Site/content/bg="+A+"&track="+C+"&x="+screen.width+"&y="+screen.height+"&cid="+C,screen.width*0.7,screen.height-200)}function rd_admin__select_box_value(select_id){select_obj=document.getElementById(select_id);with(select_obj){return options[selectedIndex].value}}function rd_admin__swap_checkbox(A){checkbox=document.getElementById(A);if(checkbox.checked){checkbox.checked=false}else{checkbox.checked=true}}date_obj=new Date();function swap_image_choice_list(){Element.setStyle("image_choice_list",{display:""});Element.setStyle("text_asset_form",{display:"none"});Element.setStyle("choose_custom_form",{display:"none"});Cuba.disable_context_menu_draggable()}function swap_text_edit_form(){Element.setStyle("image_choice_list",{display:"none"});Element.setStyle("text_asset_form",{display:""});Element.setStyle("choose_custom_form",{display:"none"});Cuba.enable_context_menu_draggable()}function swap_choose_custom_form(){Element.setStyle("image_choice_list",{display:"none"});Element.setStyle("text_asset_form",{display:"none"});Element.setStyle("choose_custom_form",{display:""});Cuba.enable_context_menu_draggable()}function profile_load_interfaces(A,B){Cuba.load({element:"profile_content",action:"Community::User_Profile/show_"+B+"/user_group_id="+A,on_update:on_data})}var active_profile_button=false;function profile_load(A,B){new Effect.Fade("profile_content",{duration:0.5});if($("profile_flag_main")){$("profile_flag_main").className="flag_button"}if($("profile_flag_own_main")){$("profile_flag_own_main").className="flag_button"}$("profile_flag_galery").className="flag_button";$("profile_flag_posts").className="flag_button";$("profile_flag_friends").className="flag_button";if(!active_profile_button){document.getElementById("profile_flag_main")}active_profile_button.className="flag_button";active_profile_button=document.getElementById("profile_flag_"+B);active_profile_button.className="flag_button_active";setTimeout("profile_load_interfaces('"+A+"','"+B+"')",550)}function messaging_load_interfaces(A,B){Cuba.load({element:"messaging_content",action:"Community::User_Message/show_"+B+"/user_group_id="+A,on_update:on_data})}var active_messaging_button=false;function messaging_load(A,B){new Effect.Fade("messaging_content",{duration:0.5});$("messaging_flag_inbox").className="flag_button";$("messaging_flag_sent").className="flag_button";$("messaging_flag_read").className="flag_button";$("messaging_flag_trash").className="flag_button";if(!active_messaging_button){document.getElementById("messaging_flag_main")}active_messaging_button.className="flag_button";active_messaging_button=document.getElementById("messaging_flag_"+B);active_messaging_button.className="flag_button_active";setTimeout("messaging_load_interfaces('"+A+"','"+B+"')",550)}function autocomplete_username_handler(B,A){generic_id=B.id}var Browser={is_ie:document.all&&document.getElementById,is_gecko:document.getElementById&&!document.all};function element_exists(A){return(document.getElementById(A)!=undefined)}function add_event(C,B,A){if(C.addEventListener){C.addEventListener(B,A,false)}else{if(C.attachEvent){C["e"+B+A]=A;C[B+A]=function(){C["e"+B+A](window.event)};C.attachEvent("on"+B,C[B+A])}}}function remove_event(C,B,A){if(C.removeEventListener){C.removeEventListener(B,A,false)}else{if(C.detachEvent){C.detachEvent("on"+B,C[B+A]);C[B+A]=null;C["e"+B+A]=null}}}function position_of(A){var B=curtop=0;if(A.offsetParent){B=A.offsetLeft;curtop=A.offsetTop;while(A=A.offsetParent){B+=A.offsetLeft;curtop+=A.offsetTop}}return[B,curtop]}var mouse_x=0;var mouse_y=0;function capture_mouse(A){if(!A){A=window.event}if(!A){return }if(Browser.is_ie){mouse_x=A.clientX+document.body.scrollLeft;mouse_y=A.clientY+document.body.scrollTop}else{if(Browser.is_gecko){mouse_x=A.pageX;mouse_y=A.pageY}}}function get_mouse(A){return[mouse_x,mouse_y];if(Browser.is_ie){mouse_x=A.clientX+document.body.scrollLeft;mouse_y=A.clientY+document.body.scrollTop}else{if(Browser.is_gecko){mouse_x=A.pageX;mouse_y=A.pageY}}return[mouse_x,mouse_y]}function get_style(B,A){if(!document.getElementById){return }var C=B.style[A];if(!C){if(document.defaultView){C=document.defaultView.getComputedStyle(B,"").getPropertyValue(A)}else{if(B.currentStyle){C=B.currentStyle[A]}}}return C}function is_mouse_over(A){if(!A){return }width=parseInt(Element.getWidth(A));height=parseInt(Element.getHeight(A));if(!width){width=A.offsetWidth}if(!height){width=A.offsetheight}pos=position_of(A);x=pos[0];y=pos[1];if(A.style.x){x=A.style.x}if(A.style.y){y=A.style.y}if(mouse_x>=x&&mouse_x<=x+width&&mouse_y>=y&&mouse_y<=y+height){window.status="OVER MENU "+mouse_x+" "+mouse_y;return true}else{return false}}function rgb_to_hex(D){var C=/\([^\)]+\)/gi;var A=""+D.match(C);A=A.replace(/\(/,"").replace(/\)/,"");var B="#";tmp=A.split(", ");for(m=0;m<3;m++){value=(tmp[m]*1).toString(16);if(value.length<2){value="0"+value}B+=value}return B}var last_hovered_element=false;function hover_element(A){if(last_hovered_element){try{Element.setStyle($(last_hovered_element),{backgroundColor:"transparent"})}catch(B){}}Element.setStyle($(A),{backgroundColor:"#bfbfbf"});last_hovered_element=A}function unhover_element(A){Element.setStyle($(A),{backgroundColor:""})}var element_style_unfocussed;function focus_element(A){if(element_style_unfocussed==undefined){element_style_unfocussed=(Element.getStyle(A,"color"))}Element.setStyle(A,{backgroundColor:"#ccc8c8"});Element.setStyle(A,{zIndex:301})}function unfocus_element(A){if(element_exists(A)){if(element_style_unfocussed){Element.setStyle(A,{color:element_style_unfocussed})}Element.setStyle(A,{backgroundColor:""});Element.setStyle(A,{zIndex:1});element_style_unfocussed=undefined}}function swap_style(A,D,B,C){obj=document.getElementById(C);style_curr=obj.style[A];obj.style[A]=D;if(obj.style[A]==style_curr){obj.style[A]=B}}function swap_value(A,C,B){obj=document.getElementById(A);value_curr=obj.value;obj.value=C;if(obj.value==value_curr){obj.value=B}}function resizeable_popup(A,C,B){LeftPosition=(screen.width)?(screen.width-A)/2:0;TopPosition=(screen.height)?(screen.height-C)/2:0;settings="height="+C+",width="+A+",top="+TopPosition+",left="+LeftPosition+",scrollbars=1,resizable=1,menubar=0,fullscreen=0,status=0";win=window.open(B,"popup",settings);win.focus()}function checkbox_swap(A){if(A.checked==true){A.value="1"}else{A.value="0"}}function alert_array(A){s="";for(var B in A){s+=(B+" | "+A[B])}alert(s)}function setCookie(B,D,A,J,C,E){J="/";document.cookie=B+"="+escape(D)+((A)?"; expires="+A.toGMTString():"")+((J)?"; path="+J:"")+((C)?"; domain="+C:"")+((E)?"; secure":"")}function getCookie(C){var B=document.cookie;var E=C+"=";var D=B.indexOf("; "+E);if(D==-1){D=B.indexOf(E);if(D!=0){return null}}else{D+=2}var A=document.cookie.indexOf(";",D);if(A==-1){A=B.length}return unescape(B.substring(D+E.length,A))}function deleteCookie(A,C,B){C="/";if(getCookie(A)){document.cookie=A+"="+((C)?"; path="+C:"")+((B)?"; domain="+B:"")+"; expires=Thu, 01-Jan-70 00:00:01 GMT"}}function init_login_screen(A){new Effect.Appear("login_box",{duration:2,to:1})}function init_article_interface(A){initLightbox()}function init_autocomplete_username(C,B,A){B.innerHTML=C.responseText;new Ajax.Autocompleter("autocomplete_username","autocomplete_username_choices","/aurita/autocomplete_username.fcgi",{minChars:2,tokens:[" ",",","\n"]})}function init_autocomplete_single_username(C,B,A){autocomplete_selected_users={};B.innerHTML=C.responseText;new Ajax.Autocompleter("autocomplete_username","autocomplete_username_choices","/aurita/autocomplete_username.fcgi",{minChars:2,updateElement:autocomplete_single_username_handler,tokens:[]})}function autocomplete_article_handler(B,A){plaintext=Cuba.temp_range.text;if(Cuba.check_if_internet_explorer()=="1"){marker_key="find_and_replace_me";Cuba.temp_range.text=marker_key;editor_html=Cuba.temp_editor_instance.getBody().innerHTML;pos=editor_html.indexOf(marker_key);if(pos!=-1){Cuba.temp_editor_instance.getBody().innerHTML=editor_html.substring(0,pos)+'<a href="#'+B.id.replace("__","--")+'">'+plaintext+"</a>"+editor_html.substring(pos+marker_key.length)}}else{tinyMCE.execInstanceCommand(Cuba.temp_editor_id,"mceInsertRawHTML",false,'<a href="#'+B.id.replace("__","--")+'">'+plaintext+"</a>")}context_menu_close()}function autocomplete_link_article_handler(B,A){plaintext=Cuba.temp_range.text;hashcode=B.id.replace("__","--");onclick="Cuba.set_hashcode(&apos;"+hashcode+"&apos;); ";if(Cuba.check_if_internet_explorer()=="1"){marker_key="find_and_replace_me";Cuba.temp_range.text=marker_key;editor_html=Cuba.temp_editor_instance.getBody().innerHTML;pos=editor_html.indexOf(marker_key);if(pos!=-1){Cuba.temp_editor_instance.getBody().innerHTML=editor_html.substring(0,pos)+'<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+"</a>"+editor_html.substring(pos+marker_key.length)}}else{tinyMCE.execInstanceCommand(Cuba.temp_editor_id,"mceInsertRawHTML",false,'<a href="#'+hashcode+'" onclick="'+onclick+'">'+Cuba.temp_range+"</a>")}context_menu_close()}function autocomplete_single_username_handler(A){username=A.innerHTML.replace(/(.+)?<b>([^<]+)<\/b>(.+)/,"$2");user_group_id=A.id.replace("user__","");if(!autocomplete_selected_users[user_group_id]){$("username_list").innerHTML+='<div id="user_autocomplete_entry_'+user_group_id+'"><span class="link" onclick="Element.remove(\'user_autocomplete_entry_'+user_group_id+"'); autocomplete_selected_users["+user_group_id+'] = false; ">x</span> '+username+'<br /><span style="margin-left: 7px; "><input type="checkbox" value="t" name="readonly_'+user_group_id+'" /> nur Lesen</span><input type="hidden" value="'+user_group_id+'" name="user_group_ids[]" /></div>'}autocomplete_selected_users[user_group_id]=true}function init_autocomplete_articles(C,B,A){B.innerHTML=C.responseText;new Ajax.Autocompleter("autocomplete_article","autocomplete_article_choices","/aurita/dispatch.fcgi",{minChars:2,updateElement:autocomplete_article_handler,tokens:[" ",",","\n"]})}function init_link_autocomplete_articles(){new Ajax.Autocompleter("autocomplete_link_article","autocomplete_link_article_choices","/aurita/dispatch.fcgi",{minChars:2,updateElement:autocomplete_link_article_handler,tokens:[" ",",","\n"]})}function init_media_interface(C,B,A){B.innerHTML=C.responseText;for(index=0;index<3000;index++){if(document.getElementById("folder_"+index)){Cuba.droppables[index]=index;Droppables.add("folder_"+index,{onDrop:drop_image_in_folder,onHover:activate_target,greedy:true})}}}function init_poll_editor(C,B,A){B.innerHTML=C.responseText;Poll_Editor.option_counter=0;Poll_Editor.option_amount=0}var reorder_article_content_id;function on_article_reorder(A){position_values=Sortable.serialize(A.id);cb__load_interface_silently("dispatcher","/aurita/Wiki::Article/perform_reorder/"+position_values+"&content_id_parent="+reorder_article_content_id)}function init_article_reorder_interface(C,B,A){B.innerHTML=C.responseText;Sortable.create("article_partials_list",{dropOnEmpty:true,onUpdate:on_article_reorder,handle:true})}function init_article(C,B,A){B.innerHTML=C.responseText;initLightbox()}var tinyMCE=tinyMCE;var registered_editors={};function flush_editor_register(){for(var A in registered_editors){flush_editor(A)}registered_editors={}}function init_editor(A){if(registered_editors[A]==null){registered_editors[A]=A;tinyMCE.execCommand("mceAddControl",false,A)}}function save_editor(A){if($(A)){Element.setStyle(A,{visibility:"hidden"})}registered_editors[A]=null;tinyMCE.execInstanceCommand(A,"mceCleanup");tinyMCE.execCommand("mceRemoveControl",true,A);tinyMCE.triggerSave(true,true)}function flush_editor(A){if(!$(A)){return }Element.setStyle(A,{visibility:"hidden"});log_debug("flushing "+A);tinyMCE.execInstanceCommand(A,"mceCleanup");tinyMCE.execCommand("mceRemoveControl",true,A);tinyMCE.triggerSave();registered_editors[A]=null}function init_all_editors(B){try{elements=document.getElementsByTagName("textarea");if(!elements||elements==undefined||elements==null){log_debug("elements in init_all_editors is undefined");return }if(elements==undefined||!elements.length){log_debug("Error: elements.length in init_all_editors is undefined");return }for(var A=0;A<elements.length;A++){elem_id=elements.item(A).id;if(registered_editors[elem_id]==null){log_debug("init editor instance: "+elem_id);inst=$(elem_id);if(inst){init_editor(elem_id)}}}}catch(C){log_debug("Catched Exception");return }}function save_all_editors(B){try{var C=false;elements=document.getElementsByTagName("textarea");if(!elements||elements==undefined||elements==null){log_debug("Error: elements in init_all_editors is undefined");return }log_debug("saving all editors");for(var A=0;A<elements.length;A++){elem_id=elements.item(A).id;if(elem_id&&elem_id.match("lore_textarea")){C=$(elem_id)}if(C){save_editor(C.id)}}}catch(D){log_debug("Catched Exception");return }}function enlarge_textarea(){for(i=0;i<10;i++){inst=document.getElementById("mce_editor_"+i);if(inst){Element.setStyle(inst,{width:"500px",height:"300px"})}}}function init_user_profile(){alert("foo");init_editor("guestbook_textarea")}var calendar;function open_calendar(D,C){var B=function(J,E){document.getElementById(D).value=E;if(J.dateClicked){J.callCloseHandler()}};var A=function(E){E.hide()};calendar=new Calendar(1,null,B,A);calendar.create();calendar.showAtElement(document.getElementById(D),"Bl");return ;if(document.getElementById("date_field")){Calendar.setup({inputField:"date_field",ifFormat:"%d.%m.%Y",button:"date_trigger"})}}function reload_selected_media_assets(){cb__load_interface_silently("selected_media_assets","/aurita/Wiki::Media_Asset/list_selected/content_id="+active_text_asset_content_id)}function asset_entry_string(A,C,D,B){if(!B||B=="jpg"){B=D}string='<div id="image_wrap__'+C+'"><div style="float: left; margin-top: 4px; margin-left: 4px; height: 120px; border: 1px solid #aaaaaa; background-color: #ffffff; "><div style="height: 100px; width: 120px; overflow: hidden;"><img src="/aurita/assets/thumb/asset_'+B+'.jpg" /></div><div onclick="deselect_image('+C+');" style="cursor: pointer; background-color: #eaeaea; padding: 3px; position: relative; left: 0px; bottom: 0px; width: 12px; height: 12px; text-align: center; ">X</div></div></div>';return string}var active_text_asset_content_id;function mark_image(B,A,D,C){marked_image_register=document.getElementById("marked_image_register").value;if(marked_image_register!=""){marked_image_register+="_"}marked_image_register+=A;document.getElementById("marked_image_register").value=marked_image_register;document.getElementById("selected_media_assets").innerHTML+=asset_entry_string(B,A,D,C)}function deselect_image(A){Cuba.delete_element("image_wrap__"+A);marked_image_register=document.getElementById("marked_image_register").value;marked_image_register=marked_image_register.replace(A,"").replace("__","_");document.getElementById("marked_image_register").value=marked_image_register}function init_container_inline_editor(C,B,A){B.innerHTML=C.responseText;init_all_editors()}function XHConn(){var B,A=false;try{}catch(C){alert("Permission UniversalBrowserRead denied.")}try{B=new ActiveXObject("Msxml2.XMLHTTP")}catch(C){try{B=new ActiveXObject("Microsoft.XMLHTTP")}catch(C){try{B=new XMLHttpRequest()}catch(C){B=false}}}if(!B){return null}this.connect=function(K,E,L,J,D){if(D==undefined){D=""}if(!B){return false}A=false;try{if(E=="GET"){K+="&randseed="+Math.round(Math.random()*100000);B.open(E,K,true);sVars=""}else{B.open(E,K,true);B.setRequestHeader("Method","POST "+K+" HTTP/1.1");B.setRequestHeader("Content-Type","application/x-www-form-urlencoded")}B.onreadystatechange=function(){if(B.readyState==4&&!A){A=true;if(L){L(B,J,E=="POST")}}};B.send(D)}catch(M){alert(M);return false}return true};this.get_string=function(K,J,E,D){result="";if(D==undefined){D=""}if(E==undefined){E="GET"}if(!B){return false}A=false;try{if(E=="GET"){B.open(E,K,true);sVars=""}else{B.open(E,K,true);B.setRequestHeader("Method","POST "+K+" HTTP/1.1");B.setRequestHeader("Content-Type","application/x-www-form-urlencoded")}B.onreadystatechange=function(){if(B.readyState==4&&!A){A=true;J(B.responseText)}};B.send(D)}catch(L){alert(L);return false}return result};return this}function update_element(B,A,C){if(A){response=B.responseText;if(response=="\n"){if(A.id=="context_menu"){context_menu_close()}A.display="none"}else{A.innerHTML=response;init_fun=Cuba.element_init_functions[A.id];if(init_fun){init_fun(A)}}}if(C){for(var D in Cuba.update_targets){url=Cuba.update_targets[D];cb__update_element(D,url)}}}function update_element_and_targets(C,B,A){t="";for(var D in Cuba.update_targets){t+=D}update_element(C,B,true)}function cb__get_remote_string(B,A){var C=new XHConn;C.get_string(B,A)}function cb__get_form_values(A){form=document.getElementById(A);string="";for(index=0;index<form.elements.length;index++){element=form.elements[index];if(element.value!=""&&element.name!=""){element_value=element.value;element_value=element_value.replace(/&auml;/g,"ä");element_value=element_value.replace(/&ouml;/g,"ö");element_value=element_value.replace(/&uuml;/g,"ü");element_value=element_value.replace(/&Auml;/g,"Ä");element_value=element_value.replace(/&Ouml;/g,"Ö");element_value=element_value.replace(/&Uuml;/g,"Ü");element_value=element_value.replace(/&szlig;/g,"ß");element_value=element_value.replace(/&nbsp;/g," ");string+=element.name+"="+element_value+"&"}}return string}function cb__update_element(B,A){element=document.getElementById(B);var C=new XHConn;interface_call=A.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}C.connect(A+"&cb__mode=dispatch&randseed="+Math.round(Math.random()*100000),"GET",update_element,element)}function cb__remote_submit(B,C,A){context_menu_autoclose=true;target_url="/aurita/dispatch";postVars=Cuba.get_form_values(B);postVarsHash=Cuba.get_form_values_hash(B);postVars+="cb__mode=dispatch";Cuba.update_targets=A;interface_call=postVarsHash.cb__model+"."+postVarsHash.cb__controller;interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}var D=new XHConn;element=document.getElementById(C);D.connect(target_url,"POST",update_element,element,postVars)}function cb__async_call(C,B,A){var D=new XHConn;B+="&cb__mode=dispatch";element=document.getElementById(C);element.innerHTML='<img src="/aurita/images/icons/loading.gif" />';if(A==undefined){A=update_element}D.connect(B,"GET",A,element)}function cb__dispatch_interface(C,A,B){var D=new XHConn;A+="&cb__mode=dispatch";element=document.getElementById(C);element.innerHTML='<img src="/aurita/images/icons/loading.gif" />';interface_call=A.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}if(B==undefined&&A.match("Wiki::Article/show")){B=init_article}if(B==undefined){B=update_element}D.connect(A,"GET",B,element)}function cb__load_interface(C,A,B){var D=new XHConn;A+="&cb__mode=dispatch&randseed="+Math.round(Math.random()*100000);element=document.getElementById(C);element.innerHTML='<img src="/aurita/images/icons/loading.gif" />';Cuba.update_targets=B;if(A.match("Wiki::Article/show")){update_fun=init_article}else{update_fun=update_element}D.connect(A,"GET",update_fun,element)}function cb__load_interface_silently(B,A){var C=new XHConn;A+="&cb__mode=dispatch&randseed="+Math.round(Math.random()*100000);element=document.getElementById(B);C.connect(A,"GET",update_element,element)}function cb__cancel_dispatch(){context_menu_close();return ;if(context_menu_opened){context_menu_opened=false;document.getElementById("context_menu").style.display="none";unfocus_element(context_menu_active_element_id)}else{new Effect.Fade("dispatcher",{duration:0.5})}}function cb__show_fullscreen_cover(){new Effect.Appear("app_fullscreen",{from:0,to:1});Element.setStyle("app_body",{"overflow-y":"hidden"});$("app_main_content").innerHTML=""}function cb__hide_fullscreen_cover(){Element.setStyle("app_body",{"overflow-y":"scroll"});Element.setStyle("app_fullscreen",{display:"none"});$("app_fullscreen").innerHTML=""}var Cuba={compare_arrays:function(B,A){return(B.join("-")==A.join("-"))},random:function(A){if(!A){A=4}return Math.round(Math.random()*Math.exp(10,A))},loading_symbol:'<img src="/aurita/images/icons/loading.gif" border="0" />',notify_invalid_params:function(A,C,B){C=C.replace("perform_","");A=A.replace("Aurita::Main::","").replace("_Controller","");form_buttons=A.toLowerCase()+"_"+C+"_form_buttons";if($(form_buttons)){Element.show(form_buttons)}Cuba.alert(B)},element:function(A){element=document.getElementById(A);if(!element){element=$(A)}if(!element){}return element},delete_element:function(A){Element.remove(A)},get_form_values:function(form_id){var form;if(document.forms){form=eval("document.forms."+form_id)}else{form=Cuba.element(form_id)}string="";for(index=0;index<form.elements.length;index++){element=form.elements[index];if(element.value!=""&&element.name!=""){element_value=element.value;element_value=element_value.replace(/&auml;/g,"ä");element_value=element_value.replace(/&ouml;/g,"ö");element_value=element_value.replace(/&uuml;/g,"ü");element_value=element_value.replace(/&Auml;/g,"Ä");element_value=element_value.replace(/&Ouml;/g,"Ö");element_value=element_value.replace(/&Uuml;/g,"Ü");element_value=element_value.replace(/&szlig;/g,"ß");element_value=element_value.replace(/&nbsp;/g," ");string+=element.name+"="+element_value+"&"}}return string},get_form_values_hash:function(form_id){var form;if(document.forms){form=eval("document.forms."+form_id)}else{form=Cuba.element(form_id)}value_hash={};for(index=0;index<form.elements.length;index++){element=form.elements[index];if(element.value!=""&&element.name!=""){element_value=element.value;element_value=element_value.replace(/&auml;/g,"ä");element_value=element_value.replace(/&ouml;/g,"ö");element_value=element_value.replace(/&uuml;/g,"ü");element_value=element_value.replace(/&Auml;/g,"Ä");element_value=element_value.replace(/&Ouml;/g,"Ö");element_value=element_value.replace(/&Uuml;/g,"Ü");element_value=element_value.replace(/&szlig;/g,"ß");element_value=element_value.replace(/&nbsp;/g," ");value_hash[element.name]=element_value}}return value_hash},get_remote_string:function(B,A){var C=new XHConn;C.get_string(B,A)},after_submit_target_map:{"Community::Role_Permissions.perform_add":{app_main_content:"Community::Role.list"},"Form_Builder.perform_add":{app_main_content:"Form_Builder.form_added"},"Community::User_Profile.perform_update":{app_main_content:"Community::User_Profile.show_own"},"Community::User_Message.perform_add":{messaging_content:"Community::User_Message.message_sent"}},after_submit_targets:function(A){form_values=Form.serialize(A,true);log_debug(form_values.cb__model+"."+form_values.cb__controller);targets=Cuba.after_submit_target_map[form_values.cb__model+"."+form_values.cb__controller];return targets},update_targets:{},init_functions:{"Wiki::Article.show":init_article_interface,"App_Main.login":init_login_screen,"Community::User_Profile.register_user":init_login_screen,"Community::User_Profile.show_galery":initLightbox,"Wiki::Media_Asset_Folder.show":initLightbox},element_init_functions:{},load_element_content:function(B,A){element=Cuba.element(B);var C=new XHConn;interface_call=A.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun&&element){Cuba.element_init_functions[element.id]=init_fun}C.connect(A+"&cb__mode=dispatch","GET",Cuba.update_element_only,element,true)},update_element:function(xml_conn,element,do_update_source){response=xml_conn.responseText;response_script=false;if(response.substr(0,6)=="{ html"){json_response=eval("("+response+")");response=json_response.html.replace('"','"');response_script=json_response.script.replace('"','"')}else{if(response.substr(0,8)=="{ script"){json_response=eval("("+response+")");response="";response_script=json_response.script.replace('"','"')}}if(element){if(response=="\n"||response==""){if(element.id=="context_menu"){context_menu_close()}}else{element.innerHTML=response}init_fun=Cuba.element_init_functions[element.id];if(init_fun&&element){init_fun(element)}if(response_script){eval(response_script)}}if(Cuba.update_targets){for(var target in Cuba.update_targets){if(Cuba.update_targets[target]){url="/aurita/"+(Cuba.update_targets[target].replace(".","/"));url+="&randseed="+Math.round(Math.random()*100000);Cuba.load_element_content(target,url)}}Cuba.update_targets=null}},update_element_only:function(B,A,C){if(A){response=B.responseText;if(response=="\n"){if(A.id=="context_menu"){context_menu_close()}Element.setStyle(A,{display:"none"})}else{A.innerHTML=response}init_fun=Cuba.element_init_functions[A.id];if(init_fun&&A){init_fun(A)}}},call:function(A){var B=new XHConn;A+="&cb__mode=dispatch";B.connect("/aurita/"+A,"GET",null,null)},current_interface_calls:{},completed_interface_calls:{},dispatch_interface:function(B){target_id=B.target;interface_url="/aurita/"+B.interface_url;interface_url.replace("/aurita//aurita/","/aurita/");if(Cuba.current_interface_calls[interface_url]){log_debug("Duplicate interface call?")}Cuba.current_interface_calls[interface_url]=true;log_debug("Dispatch interface "+interface_url);update_fun=B.on_update;Cuba.update_targets=B.targets;var A=new XHConn;interface_url+="&cb__mode=dispatch";element=Cuba.element(target_id);if(!B.silently){element.innerHTML='<img src="/aurita/images/icons/loading.gif" />'}interface_call=interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun&&element){Cuba.element_init_functions[element.id]=init_fun}if(update_fun==undefined){update_fun=Cuba.update_element}A.connect(interface_url,"GET",update_fun,element)},remote_submit:function(B,C,A){context_menu_autoclose=true;target_url="/aurita/dispatch";postVars=Form.serialize(B);postVars+="&cb__mode=dispatch&x=1";postVarsHash=Form.serialize(B,true);if(A&&!Cuba.update_targets){Cuba.update_targets=A}else{for(t in A){Cuba.update_targets[t]=A[t]}}interface_call=postVarsHash.cb__model+"."+postVarsHash.cb__controller;init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}var D=new XHConn;element=Cuba.element(C);D.connect(target_url,"POST",Cuba.update_element,element,postVars)},async_submit:function(A){Cuba.remote_submit(A.form,A.element)},load:function(A){if(!$(A.element)){log_debug("Target for Cuba.load does not exist: "+A.target+", ignoring call");return }A.interface_url=A.action;A.target=A.element;A.targets=A.redirect_after;A.on_update=A.on_update;if(A.nocache){A.interface_url+="&rand="+Cuba.random()}Cuba.dispatch_interface(A)},cancel_dispatch:function(){Cuba.close_context_menu()},alert:function(A){Cuba.message_box=new MessageBox({interface_url:"App_Main/alert_box/message="+A});Cuba.message_box.open()},popup:function(A){Cuba.message_box=new MessageBox({interface_url:A});Cuba.message_box.open()},confirmed_interface:"",unconfirmed_interface:"",message_box:undefined,on_confirm_action:function(){},after_confirmed_action:function(B,A){},confirmable_action:function(A){interface_url=A.action;message=A.message;targets=A.targets;Cuba.message_box=new MessageBox({interface_url:"App_Main/confirmation_box/message="+message});Cuba.unconfirmed_interface=interface_url;if(A.onconfirm){Cuba.on_confirm_action=A.onconfirm}Cuba.update_targets=targets;Cuba.message_box.open()},confirm_action:function(){Cuba.dispatch_interface({target:"dispatcher",interface_url:Cuba.unconfirmed_interface,on_update:Cuba.after_confirmed_action,targets:Cuba.update_targets});Cuba.update_targets={};Cuba.on_confirm_action();Cuba.message_box.close()},cancel_action:function(){Cuba.update_targets={};Cuba.message_box.close()},waiting_for_file_upload:false,before_file_upload:function(){Cuba.waiting_for_file_upload=true;Element.setStyle("file_upload_indicator",{display:""})},after_file_upload:function(){if(Cuba.waiting_for_file_upload){Element.setStyle("file_upload_indicator",{display:"none"});Cuba.waiting_for_file_upload=false;alert("Datei wurde auf den Server geladen")}},upload_file:function(A){alert("upload");if(Cuba.waiting_for_file_upload){alert("Ein anderer Upload l&auml;uft bereits");return false}Cuba.before_file_upload();Element.toggle(A);Element.toggle("upload_confirmation");return true}};Cuba.force_load=false;Cuba.append_autocomplete_value=function(A,B){field=$(A);fullvalue=field.value.replace(","," ").replace(/\s+/," ");values=fullvalue.split(" ");values.pop();values.push(B);field.value=values.join(" ");field.focus()};Cuba.set_ie_history_fix_iframe_src=function(A){if(wait_for_iframe_sync=="1"){wait_for_iframe_sync="0"}else{wait_for_iframe_sync="1"}Cuba.ie_history_fix_iframe=parent.ie_fix_history_frame;Cuba.ie_history_fix_iframe.location.href=A};Cuba.set_hashcode=function(A){if(Cuba.check_if_internet_explorer()==1){Cuba.set_ie_history_fix_iframe_src("/aurita/get_code.fcgi?code="+A)}Cuba.force_load=true;document.location.href="#"+A;Cuba.check_hashvalue()};Cuba.append_hashcode=function(A){Cuba.force_load=true;document.location.href+="--"+A;Cuba.check_hashvalue()};Cuba.toggle_user_functions=function(A){log_debug("toggling user functions");A=A.replace(" ","").replace("\n","");if(A.match("1")||A.match("2")){Element.show("button_App_Profile")}if(A.match("2")){Element.show("button_App_Expert")}if(A.match("0")||A==""){Element.hide("button_App_Profile");Element.hide("button_App_Expert")}};Cuba.toggle_mail_notifier=function(A){A=A.replace(" ","").replace("\n","");var B=(A.lastIndexOf("0")==-1&&A!="");log_debug("new mail: "+A+" -> "+B);if(B){Element.setStyle("new_mail_notifier",{display:""});$("unread_mail_amount").innerHTML="("+A+")"}else{Element.setStyle("new_mail_notifier",{display:"none"})}};Cuba.last_feedback={};Cuba.handle_feedback=function(response){if(!response){return }feedback=eval("("+response+")");if(feedback.unread_mail&&Cuba.last_feedback.unread_mail!=feedback.unread_mail){log_debug("-- unread_mail: "+feedback.unread_mail);$("mail_notifier").innerHTML=feedback.unread_mail}if(feedback.random_image){if($("random_image")&&Cuba.last_feedback.random_image!=feedback.random_image){log_debug("-- random_image: "+feedback.random_image);$("random_image").src="/aurita/Wiki::Media_Asset/image/id="+feedback.random_image+"x=220"}}if(feedback.registered!=undefined){if(feedback.registered!=Cuba.last_feedback.registered){log_debug("-- user_registered");Cuba.load({element:"account_box",action:"App_Main/account_box",silently:true});Cuba.load({element:"system_box",action:"App_Main/system_box_body",silently:true});Cuba.get_remote_string("/aurita/User_Group/is_registered/cb__mode=none&rand="+Cuba.random(),Cuba.toggle_user_functions)}}if(feedback.recently_changed){if(!Cuba.last_feedback.recently_changed||!Cuba.compare_arrays(Cuba.last_feedback.recently_changed,feedback.recently_changed)){log_debug("-- recently_changed");Cuba.load({element:"changed_articles_body",action:"Wiki::Article/print_recently_changed/",nocache:true})}}if(feedback.recently_viewed){if(!Cuba.last_feedback.recently_viewed||!Cuba.compare_arrays(Cuba.last_feedback.recently_viewed,feedback.recently_viewed)){log_debug("-- recently_viewed");Cuba.load({element:"viewed_articles_body",action:"Wiki::Article/print_recently_viewed/",nocache:true})}}if(feedback.recently_viewed_media){if(!Cuba.last_feedback.recently_viewed_media||!Cuba.compare_arrays(Cuba.last_feedback.recently_viewed_media,feedback.recently_viewed_media)){log_debug("-- recently_viewed_media");Cuba.load({element:"viewed_media_body",action:"Wiki::Article/print_recently_viewed_media/",nocache:true})}}Cuba.last_feedback=feedback};Cuba.poll_feedback=function(){Cuba.get_remote_string("Async_Feedback/get/cb__mode=none&"+Cuba.random(),Cuba.handle_feedback)};setInterval(Cuba.poll_feedback,15000);Cuba.poll_feedback();var IFrameObj;Cuba.ie_fix_history_frame=function(){iframe_id="ie_fix_history_iframe";if(!document.createElement){return true}var C;if(!IFrameObj&&document.createElement){try{var A=document.createElement("iframe");A.setAttribute("id",iframe_id);A.style.border="0px";A.style.width="0px";A.style.height="0px";IFrameObj=document.body.appendChild(A);if(document.frames){IFrameObj=document.frames[iframe_id]}}catch(B){iframeHTML='<iframe id="'+iframe_id+'" style="';iframeHTML+="border:0px;";iframeHTML+="width:0px;";iframeHTML+="height:0px;";iframeHTML+='"></iframe>';document.body.innerHTML+=iframeHTML;IFrameObj=new Object();IFrameObj.document=new Object();IFrameObj.document.location=new Object();IFrameObj.document.location.iframe=document.getElementById(iframe_id);IFrameObj.document.location.replace=function(D){this.iframe.src=D}}}if(navigator.userAgent.indexOf("Gecko")!=-1&&!IFrameObj.contentDocument){setTimeout("callToServer()",10);return false}return IFrameObj};function show_image(B,A){media_asset_id=B.id;cb__load_interface("media_folder_content","/aurita/Wiki::Media_Asset/show/media_asset_id="+media_asset_id)}var drop_target_folder;function activate_target(A,C,B){drop_target_folder=C}function drop_image_in_folder(A){A.style.display="none";if(A.id.search("image")!=-1){cb__load_interface_silently("","/aurita/Wiki::Media_Asset/move_to_folder/media_folder_id="+drop_target_folder.id+"&media_asset_id="+A.id)}else{if(A.id.search("folder")!=-1){cb__load_interface_silently("","/aurita/Wiki::Media_Asset_Folder/move_to_folder/media_folder_id="+drop_target_folder.id+"&media_folder_asset_id="+A.id)}}}Cuba.media_asset_draggables={};Cuba.create_media_asset_draggable=function(A,B){if(Cuba.media_asset_draggables[A]==undefined){Cuba.media_asset_draggables[A]=new Draggable(A,B)}};Cuba.destroy_draggables=function(){for(var A in Cuba.media_asset_draggables){Cuba.media_asset_draggables[A].destroy()}Cuba.media_asset_draggables={}};Cuba.droppables={};Cuba.remove_droppables=function(){for(var A in Cuba.droppables){Droppables.remove(document.getElementById("folder_"+Cuba.droppables[A]))}Cuba.droppables={}};Cuba.shutdown_media_management=function(){Cuba.remove_droppables();Cuba.destroy_draggables();cb__hide_fullscreen_cover();Cuba.expanded_folder_ids={}};Cuba.expanded_folder_ids={};Cuba.load_media_asset_folder_level=function(B,A){if(Cuba.expanded_folder_ids[B]){$("folder_expand_icon_"+B).src="/aurita/images/icons/plus.gif";Cuba.expanded_folder_ids[B]=false;$("folder_children_"+B).innerHTML="";return }else{Cuba.expanded_folder_ids[B]=true;$("folder_expand_icon_"+B).src="/aurita/images/icons/minus.gif";Cuba.load({element:"folder_children_"+B,action:"Wiki::Media_Asset/print_media_asset_folder_level/media_folder_id="+B+"&indent="+A,on_update:init_media_interface})}};Cuba.select_media_asset=function(D){var C=D.hidden_field;var B=D.user_id;var E=$(C);var A="select_box_"+C;select_box=$(A);Cuba.load({element:A,action:"Wiki::Media_Asset/choose_from_user_folders/user_group_id="+B+"&element_id_to_update="+C});Element.setStyle(select_box,{display:"block"});Element.setStyle(select_box,{width:"100%"})};Cuba.select_media_asset_click=function(B,A){var D=$(A);var C=$("image_"+A);select_box=$("select_box_"+A);Element.setStyle(select_box,{display:"none"});C.src="";if(B==0){C.style.display="none";D.value="";$("clear_selected_image_button").style.display="none"}else{C.src="/aurita/assets/asset_"+B+".jpg";C.style.display="block";D.value=B;$("clear_selected_image_button").style.display=""}};Cuba.reload_image=function(A){var B=$("reloadable_image");var C=B.src;B.src="";B.src=C+"?"+Math.round(Math.random()*1000)};Cuba.folder_hierarchy=new Array();Cuba.folder_hierarchy.push(0);Cuba.add_folder_to_hierarchy=function(A){};Cuba.open_folder=0;Cuba.change_folder_icon=function(A){folder_to_open=$("folder_icon_"+A);folder_to_close=$("folder_icon_"+Cuba.open_folder);if(folder_to_close){folder_to_close.src="/aurita/images/icons/folder_closed.gif"}folder_to_open.src="/aurita/images/icons/folder_opened.gif";Cuba.open_folder=A};Cuba.reload_background_image=function(A){image=$("image_preview");url=image.style.backgroundImage;url=url.replace(/url\(([^\)]+)\)/,"$1");image.style.backgroundImage="";image.style.backgroundImage="url("+url+"?"+Math.round(Math.random()*1000)+")"};Cuba.rotation_counter=0;Cuba.increment_rotation_counter=function(){Cuba.rotation_counter+=1};Cuba.check_if_internet_explorer=function(){var A=navigator.userAgent;if((verOffset=A.indexOf("MSIE"))!=-1){return 1}else{return 0}};Cuba.calculate_aspect_ratio=function(){Cuba.check_if_internet_explorer();image=$("image_preview");url=Element.getStyle("image_preview","height");url=url.replace(/url\(([^\)]+)\)/,"$1");Element.setStyle("image_preview",{src:url});height=Element.getHeight("image_preview");width=Element.getWidth("image_preview");ratio=height/width;height=parseInt(width/ratio);if(Cuba.check_if_internet_explorer()==1){Element.setStyle("crop_line_bottom",{top:height-8})}else{Element.setStyle("crop_line_bottom",{top:height-6})}Element.setStyle("crop_line_left",{height:height+4});Element.setStyle("crop_line_right",{height:height+4});image.style.height=height};Cuba.ignore_manipulation=false;Cuba.image_brightness=1;Cuba.image_hue=1;Cuba.image_saturation=1;Cuba.image_contrast=100;Cuba.image_manipulate_brightness=function(A){Cuba.image_brightness=A;Cuba.manipulate_image()};Cuba.image_manipulate_hue=function(A){Cuba.image_hue=A;Cuba.manipulate_image()};Cuba.image_manipulate_saturation=function(A){Cuba.image_saturation=A;Cuba.manipulate_image()};Cuba.image_manipulate_contrast=function(A){Cuba.image_contrast=A;Cuba.manipulate_image()};Cuba.manipulate_image=function(A){if(!Cuba.ignore_manipulation){action="Wiki::Media_Asset/manipulate/media_asset_id="+Cuba.active_media_asset_id;action+="&brightness="+Cuba.image_brightness;action+="&hue="+Cuba.image_hue;action+="&saturation="+Cuba.image_saturation;action+="&contrast="+Cuba.image_contrast;Cuba.load({action:action,element:"dispatcher",on_update:Cuba.reload_background_image})}};Cuba.init_image_manipulation_sliders=function(){Cuba.image_brightness_slider=new Control.Slider("brightness_handle","brightness_track",{onChange:Cuba.image_manipulate_brightness,range:$R(0,2),sliderValue:1});Cuba.image_hue_slider=new Control.Slider("hue_handle","hue_track",{onChange:Cuba.image_manipulate_hue,range:$R(0,2),sliderValue:1});Cuba.image_saturation_slider=new Control.Slider("saturation_handle","saturation_track",{onChange:Cuba.image_manipulate_saturation,range:$R(0,2),sliderValue:1});Cuba.image_contrast_slider=new Control.Slider("contrast_handle","contrast_track",{onChange:Cuba.image_manipulate_contrast,range:$R(1,200),sliderValue:100})};Cuba.reset_image=function(){Cuba.ignore_manipulation=true;Cuba.image_brightness_slider.setValue(1);Cuba.image_hue_slider.setValue(1);Cuba.image_saturation_slider.setValue(1);Cuba.image_contrast_slider.setValue(100);if(Cuba.rotation_counter%2==1){Cuba.calculate_aspect_ratio()}Cuba.rotation_counter=0;Cuba.reload_background_image();Cuba.ignore_manipulation=false};Cuba.init_crop_lines=function(){new Draggable("crop_line_left",{revert:false,constraint:"horizontal",containment:"image_preview"});new Draggable("crop_line_right",{revert:false,constraint:"horizontal",containment:"image_preview"});new Draggable("crop_line_top",{revert:false,constraint:"vertical",containment:"image_preview"});new Draggable("crop_line_bottom",{revert:false,constraint:"vertical",containment:"image_preview"})};Cuba.resolve_slider_positions=function(){image=$("image_preview");url=image.style.backgroundImage;url=url.replace(/url\(([^\)]+)\)/,"$1");image_file=new Image();image_file.src=url;image_height=image_file.height;position_top=parseInt($("crop_line_top").style.top)+405;position_bottom=parseInt($("crop_line_bottom").style.top)-image_height+6;position_left=parseInt($("crop_line_left").style.left)+305;position_right=parseInt($("crop_line_right").style.left)-299;Cuba.slider_positions={top:position_top,bottom:position_bottom,left:position_left,right:position_right,height:image_height}};Cuba.init_image_manipulation=function(B,A){A.innerHTML=B.responseText;Cuba.init_image_manipulation_sliders();Cuba.init_crop_lines()};var Login={check_success:function(success){var failed=true;if(success!="\n0\n"){user_params=eval(success);if(user_params.session_id){setCookie("cb_login",user_params.session_id,0,"/");failed=false}}if(failed){new Effect.Shake("login_box")}else{new Effect.Fade("login_box",{queue:"front",duration:1});document.location.href="/aurita/App_Main/start/"}},remote_login:function(A,B){A=MD5(A);B=MD5(B);cb__get_remote_string("/aurita/App_Main/validate_user/cb__mode=dispatch&login="+A+"&pass="+B,Login.check_success)}};var Aurita={last_username:"",username_input_element:"0",check_username_available:function(A){if(A.match("true")){Element.setStyle(Aurita.username_input_element,{"border-color":"#00ff00"})}else{Element.setStyle(Aurita.username_input_element,{"border-color":"#ff0000"})}},username_available:function(A){if(A.value==Aurita.last_username){return }Aurita.username_input_element=A;Aurita.last_username=A.value;cb__get_remote_string("/aurita/RBAC::User_Group/username_available/cb__mode=dispatch&user_group_name="+A.value,Aurita.check_username_available)}};Cuba.app_domains=["wortundform2.selfip.com"];Cuba.append_autocomplete_value=function(A,B){field=$(A);fullvalue=field.value.replace(","," ").replace(/\s+/," ");values=fullvalue.split(" ");values.pop();values.push(B);field.value=values.join(" ");field.focus()};Cuba.get_ie_history_fix_iframe_code=function(){try{hashcode=parent.ie_fix_history_frame.location.href;for(var A in Cuba.app_domains){hashcode=hashcode.replace("http://"+Cuba.app_domains[A]+"/aurita/get_code.fcgi?code=","")}}catch(B){hashcode=parent.ie_fix_history_frame.get_code()}return hashcode};Cuba.last_hashvalue="";var home_loaded=false;wait_for_iframe_sync="0";Cuba.check_hashvalue=function(){current_hashvalue=document.location.hash.replace("#","");if(current_hashvalue.match(/(.+)?_anchor/)){return }if(Cuba.check_if_internet_explorer()==1){iframe_hashvalue=Cuba.get_ie_history_fix_iframe_code();if(iframe_hashvalue!="no_code"&&iframe_hashvalue!=current_hashvalue&&!Cuba.force_load&&iframe_hashvalue!=""&&!iframe_hashvalue.match("about:")){current_hashvalue=iframe_hashvalue}if(document.location.hash!="#"+current_hashvalue){document.location.hash=current_hashvalue}}if(Cuba.force_load||current_hashvalue!=Cuba.last_hashvalue&&current_hashvalue!=""){window.scrollTo(0,0);Cuba.force_load=false;log_debug("loading interface for "+current_hashvalue);flush_editor_register();Cuba.last_hashvalue=current_hashvalue;if(current_hashvalue.match("article--")){aid=current_hashvalue.replace("article--","");Cuba.load({element:"app_main_content",action:"Wiki::Article/show/article_id="+aid,on_update:init_article})}else{if(current_hashvalue.match("user--")){uid=current_hashvalue.replace("user--","");Cuba.load({element:"app_main_content",action:"Community::User_Profile/show_by_username/user_group_name="+uid})}else{if(current_hashvalue.match("media--")){maid=current_hashvalue.replace("media--","");Cuba.load({element:"app_main_content",action:"Wiki::Media_Asset/show/media_asset_id="+maid})}else{if(current_hashvalue.match("folder--")){mafid=current_hashvalue.replace("folder--","");Cuba.load({element:"app_main_content",action:"Wiki::Media_Asset_Folder/show/media_folder_id="+mafid})}else{if(current_hashvalue.match("playlist--")){pid=current_hashvalue.replace("playlist--","");Cuba.load({element:"app_main_content",action:"Community::Playlist_Entry/show/playlist_id="+pid})}else{if(current_hashvalue.match("video--")){vid=current_hashvalue.replace("video--","");Cuba.load({element:"app_main_content",action:"App_Main/play_youtube_video/playlist_entry_id="+vid})}else{if(current_hashvalue.match("find--")){pattern=current_hashvalue.replace("find--","").replace(/ /g,"");Cuba.load({element:"app_main_content",action:"App_Main/find/key="+pattern})}else{if(current_hashvalue.match("find_full--")){pattern=current_hashvalue.replace("find_full--","").replace(/ /g,"");Cuba.load({element:"app_main_content",action:"App_Main/find_full/key="+pattern})}else{if(current_hashvalue.match("topic--")){tid=current_hashvalue.replace("topic--","");Cuba.load({element:"app_main_content",action:"Community::Forum_Topic/show/forum_topic_id="+tid})}else{if(current_hashvalue.match("app--")){action=current_hashvalue.replace("app--","").replace("+","").replace(/ /g,"");Cuba.load({element:"app_main_content",action:"App_Main/"+action+"/"})}else{if(current_hashvalue.match("calendar--")){action=current_hashvalue.replace("calendar--","").replace("+","").replace(/ /g,"");if(action.substr(0,5)=="day--"){action="day/date="+action.replace("day--","")}Cuba.load({element:"app_main_content",action:"Calendar/"+action+"/"})}else{action=current_hashvalue.replace("--","/");Cuba.load({element:"app_main_content",action:action})}}}}}}}}}}}}};window.setInterval(Cuba.check_hashvalue,1000);function PageLocator(B,A){this.propertyToUse=B;this.defaultQS=1;this.dividingCharacter=A}PageLocator.prototype.getLocation=function(){return eval(this.propertyToUse)};PageLocator.prototype.getHash=function(){var B=this.getLocation();if(B.indexOf(this.dividingCharacter)>-1){var A=B.split(this.dividingCharacter);return A[A.length-1]}else{return this.defaultQS}};PageLocator.prototype.getHref=function(){var B=this.getLocation();var A=B.split(this.dividingCharacter);return A[0]};PageLocator.prototype.makeNewLocation=function(A){return this.getHref()+this.dividingCharacter+A};Cuba.toggle_box=function(A){Element.toggle(A+"_body");collapsed_boxes=getCookie("collapsed_boxes");if(collapsed_boxes){collapsed_boxes=collapsed_boxes.split("-")}else{collapsed_boxes=[]}if($("collapse_icon_"+A).src.match("plus.gif")){$("collapse_icon_"+A).src="/aurita/images/icons/minus.gif";box_id_string="";for(b=0;b<collapsed_boxes.length;b++){bid=collapsed_boxes[b];if(bid!=A){box_id_string+=bid+"-"}}setCookie("collapsed_boxes",box_id_string)}else{collapsed_boxes.push(A);setCookie("collapsed_boxes",collapsed_boxes.join("-"));$("collapse_icon_"+A).src="/aurita/images/icons/plus.gif"}};Cuba.close_box=function(A){Element.hide(A+"_body");$("collapse_icon_"+A).src="/aurita/images/icons/plus.gif"};Poll_Editor={option_counter:0,option_amount:0,add_option:function(){Poll_Editor.option_counter++;Poll_Editor.option_amount++;field=document.createElement("span");field.id="poll_option_entry_"+Poll_Editor.option_counter;field.innerHTML='<input style="margin-top: 2px; " type="text" class="lore" name="poll_option_'+Poll_Editor.option_counter+'" /><span onclick="Poll_Editor.remove_option('+Poll_Editor.option_counter+');" class="lore_text_button" style="height: 19px; ">-</span> <br />';$("poll_options").appendChild(field);if(Poll_Editor.option_amount>=2){Element.setStyle("poll_editor_submit_button",{display:""})}if(Poll_Editor.option_amount>10){Element.setStyle("poll_editor_add_option_button",{display:"none"})}$("poll_editor_max_option_index").value=Poll_Editor.option_counter},remove_option:function(A){Poll_Editor.option_amount--;$("poll_option_entry_"+A).innerHTML="";if(Poll_Editor.option_amount<2){Element.setStyle("poll_editor_submit_button",{display:"none"})}if(Poll_Editor.option_amount<=10){Element.setStyle("poll_editor_add_option_button",{display:""})}}};Calendar=function(D,C,J,A){this.activeDiv=null;this.currentDateEl=null;this.getDateStatus=null;this.getDateToolTip=null;this.getDateText=null;this.timeout=null;this.onSelected=J||null;this.onClose=A||null;this.dragging=false;this.hidden=false;this.minYear=1970;this.maxYear=2050;this.dateFormat=Calendar._TT.DEF_DATE_FORMAT;this.ttDateFormat=Calendar._TT.TT_DATE_FORMAT;this.isPopup=true;this.weekNumbers=true;this.firstDayOfWeek=typeof D=="number"?D:Calendar._FD;this.showsOtherMonths=false;this.dateStr=C;this.ar_days=null;this.showsTime=false;this.time24=true;this.yearStep=2;this.hiliteToday=true;this.multiple=null;this.table=null;this.element=null;this.tbody=null;this.firstdayname=null;this.monthsCombo=null;this.yearsCombo=null;this.hilitedMonth=null;this.activeMonth=null;this.hilitedYear=null;this.activeYear=null;this.dateClicked=false;if(typeof Calendar._SDN=="undefined"){if(typeof Calendar._SDN_len=="undefined"){Calendar._SDN_len=3}var B=new Array();for(var E=8;E>0;){B[--E]=Calendar._DN[E].substr(0,Calendar._SDN_len)}Calendar._SDN=B;if(typeof Calendar._SMN_len=="undefined"){Calendar._SMN_len=3}B=new Array();for(var E=12;E>0;){B[--E]=Calendar._MN[E].substr(0,Calendar._SMN_len)}Calendar._SMN=B}};Calendar._C=null;Calendar.is_ie=(/msie/i.test(navigator.userAgent)&&!/opera/i.test(navigator.userAgent));Calendar.is_ie5=(Calendar.is_ie&&/msie 5\.0/i.test(navigator.userAgent));Calendar.is_opera=/opera/i.test(navigator.userAgent);Calendar.is_khtml=/Konqueror|Safari|KHTML/i.test(navigator.userAgent);Calendar.getAbsolutePos=function(E){var A=0,D=0;var C=/^div$/i.test(E.tagName);if(C&&E.scrollLeft){A=E.scrollLeft}if(C&&E.scrollTop){D=E.scrollTop}var J={x:E.offsetLeft-A,y:E.offsetTop-D};if(E.offsetParent){var B=this.getAbsolutePos(E.offsetParent);J.x+=B.x;J.y+=B.y}return J};Calendar.isRelated=function(C,A){var D=A.relatedTarget;if(!D){var B=A.type;if(B=="mouseover"){D=A.fromElement}else{if(B=="mouseout"){D=A.toElement}}}while(D){if(D==C){return true}D=D.parentNode}return false};Calendar.removeClass=function(E,D){if(!(E&&E.className)){return }var A=E.className.split(" ");var B=new Array();for(var C=A.length;C>0;){if(A[--C]!=D){B[B.length]=A[C]}}E.className=B.join(" ")};Calendar.addClass=function(B,A){Calendar.removeClass(B,A);B.className+=" "+A};Calendar.getElement=function(A){var B=Calendar.is_ie?window.event.srcElement:A.currentTarget;while(B.nodeType!=1||/^div$/i.test(B.tagName)){B=B.parentNode}return B};Calendar.getTargetElement=function(A){var B=Calendar.is_ie?window.event.srcElement:A.target;while(B.nodeType!=1){B=B.parentNode}return B};Calendar.stopEvent=function(A){A||(A=window.event);if(Calendar.is_ie){A.cancelBubble=true;A.returnValue=false}else{A.preventDefault();A.stopPropagation()}return false};Calendar.addEvent=function(A,C,B){if(A.attachEvent){A.attachEvent("on"+C,B)}else{if(A.addEventListener){A.addEventListener(C,B,true)}else{A["on"+C]=B}}};Calendar.removeEvent=function(A,C,B){if(A.detachEvent){A.detachEvent("on"+C,B)}else{if(A.removeEventListener){A.removeEventListener(C,B,true)}else{A["on"+C]=null}}};Calendar.createElement=function(C,B){var A=null;if(document.createElementNS){A=document.createElementNS("http://www.w3.org/1999/xhtml",C)}else{A=document.createElement(C)}if(typeof B!="undefined"){B.appendChild(A)}return A};Calendar._add_evs=function(el){with(Calendar){addEvent(el,"mouseover",dayMouseOver);addEvent(el,"mousedown",dayMouseDown);addEvent(el,"mouseout",dayMouseOut);if(is_ie){addEvent(el,"dblclick",dayMouseDblClick);el.setAttribute("unselectable",true)}}};Calendar.findMonth=function(A){if(typeof A.month!="undefined"){return A}else{if(typeof A.parentNode.month!="undefined"){return A.parentNode}}return null};Calendar.findYear=function(A){if(typeof A.year!="undefined"){return A}else{if(typeof A.parentNode.year!="undefined"){return A.parentNode}}return null};Calendar.showMonthsCombo=function(){var E=Calendar._C;if(!E){return false}var E=E;var J=E.activeDiv;var D=E.monthsCombo;if(E.hilitedMonth){Calendar.removeClass(E.hilitedMonth,"hilite")}if(E.activeMonth){Calendar.removeClass(E.activeMonth,"active")}var C=E.monthsCombo.getElementsByTagName("div")[E.date.getMonth()];Calendar.addClass(C,"active");E.activeMonth=C;var B=D.style;B.display="block";if(J.navtype<0){B.left=J.offsetLeft+"px"}else{var A=D.offsetWidth;if(typeof A=="undefined"){A=50}B.left=(J.offsetLeft+J.offsetWidth-A)+"px"}B.top=(J.offsetTop+J.offsetHeight)+"px"};Calendar.showYearsCombo=function(D){var A=Calendar._C;if(!A){return false}var A=A;var C=A.activeDiv;var J=A.yearsCombo;if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}if(A.activeYear){Calendar.removeClass(A.activeYear,"active")}A.activeYear=null;var B=A.date.getFullYear()+(D?1:-1);var M=J.firstChild;var L=false;for(var E=12;E>0;--E){if(B>=A.minYear&&B<=A.maxYear){M.innerHTML=B;M.year=B;M.style.display="block";L=true}else{M.style.display="none"}M=M.nextSibling;B+=D?A.yearStep:-A.yearStep}if(L){var N=J.style;N.display="block";if(C.navtype<0){N.left=C.offsetLeft+"px"}else{var K=J.offsetWidth;if(typeof K=="undefined"){K=50}N.left=(C.offsetLeft+C.offsetWidth-K)+"px"}N.top=(C.offsetTop+C.offsetHeight)+"px"}};Calendar.tableMouseUp=function(ev){var cal=Calendar._C;if(!cal){return false}if(cal.timeout){clearTimeout(cal.timeout)}var el=cal.activeDiv;if(!el){return false}var target=Calendar.getTargetElement(ev);ev||(ev=window.event);Calendar.removeClass(el,"active");if(target==el||target.parentNode==el){Calendar.cellClick(el,ev)}var mon=Calendar.findMonth(target);var date=null;if(mon){date=new Date(cal.date);if(mon.month!=date.getMonth()){date.setMonth(mon.month);cal.setDate(date);cal.dateClicked=false;cal.callHandler()}}else{var year=Calendar.findYear(target);if(year){date=new Date(cal.date);if(year.year!=date.getFullYear()){date.setFullYear(year.year);cal.setDate(date);cal.dateClicked=false;cal.callHandler()}}}with(Calendar){removeEvent(document,"mouseup",tableMouseUp);removeEvent(document,"mouseover",tableMouseOver);removeEvent(document,"mousemove",tableMouseOver);cal._hideCombos();_C=null;return stopEvent(ev)}};Calendar.tableMouseOver=function(Q){var A=Calendar._C;if(!A){return }var C=A.activeDiv;var M=Calendar.getTargetElement(Q);if(M==C||M.parentNode==C){Calendar.addClass(C,"hilite active");Calendar.addClass(C.parentNode,"rowhilite")}else{if(typeof C.navtype=="undefined"||(C.navtype!=50&&(C.navtype==0||Math.abs(C.navtype)>2))){Calendar.removeClass(C,"active")}Calendar.removeClass(C,"hilite");Calendar.removeClass(C.parentNode,"rowhilite")}Q||(Q=window.event);if(C.navtype==50&&M!=C){var P=Calendar.getAbsolutePos(C);var S=C.offsetWidth;var R=Q.clientX;var T;var O=true;if(R>P.x+S){T=R-P.x-S;O=false}else{T=P.x-R}if(T<0){T=0}var J=C._range;var L=C._current;var K=Math.floor(T/10)%J.length;for(var E=J.length;--E>=0;){if(J[E]==L){break}}while(K-->0){if(O){if(--E<0){E=J.length-1}}else{if(++E>=J.length){E=0}}}var B=J[E];C.innerHTML=B;A.onUpdateTime()}var D=Calendar.findMonth(M);if(D){if(D.month!=A.date.getMonth()){if(A.hilitedMonth){Calendar.removeClass(A.hilitedMonth,"hilite")}Calendar.addClass(D,"hilite");A.hilitedMonth=D}else{if(A.hilitedMonth){Calendar.removeClass(A.hilitedMonth,"hilite")}}}else{if(A.hilitedMonth){Calendar.removeClass(A.hilitedMonth,"hilite")}var N=Calendar.findYear(M);if(N){if(N.year!=A.date.getFullYear()){if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}Calendar.addClass(N,"hilite");A.hilitedYear=N}else{if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}}}else{if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}}}return Calendar.stopEvent(Q)};Calendar.tableMouseDown=function(A){if(Calendar.getTargetElement(A)==Calendar.getElement(A)){return Calendar.stopEvent(A)}};Calendar.calDragIt=function(B){var C=Calendar._C;if(!(C&&C.dragging)){return false}var E;var D;if(Calendar.is_ie){D=window.event.clientY+document.body.scrollTop;E=window.event.clientX+document.body.scrollLeft}else{E=B.pageX;D=B.pageY}C.hideShowCovered();var A=C.element.style;A.left=(E-C.xOffs)+"px";A.top=(D-C.yOffs)+"px";return Calendar.stopEvent(B)};Calendar.calDragEnd=function(ev){var cal=Calendar._C;if(!cal){return false}cal.dragging=false;with(Calendar){removeEvent(document,"mousemove",calDragIt);removeEvent(document,"mouseup",calDragEnd);tableMouseUp(ev)}cal.hideShowCovered()};Calendar.dayMouseDown=function(ev){var el=Calendar.getElement(ev);if(el.disabled){return false}var cal=el.calendar;cal.activeDiv=el;Calendar._C=cal;if(el.navtype!=300){with(Calendar){if(el.navtype==50){el._current=el.innerHTML;addEvent(document,"mousemove",tableMouseOver)}else{addEvent(document,Calendar.is_ie5?"mousemove":"mouseover",tableMouseOver)}addClass(el,"hilite active");addEvent(document,"mouseup",tableMouseUp)}}else{if(cal.isPopup){cal._dragStart(ev)}}if(el.navtype==-1||el.navtype==1){if(cal.timeout){clearTimeout(cal.timeout)}cal.timeout=setTimeout("Calendar.showMonthsCombo()",250)}else{if(el.navtype==-2||el.navtype==2){if(cal.timeout){clearTimeout(cal.timeout)}cal.timeout=setTimeout((el.navtype>0)?"Calendar.showYearsCombo(true)":"Calendar.showYearsCombo(false)",250)}else{cal.timeout=null}}return Calendar.stopEvent(ev)};Calendar.dayMouseDblClick=function(A){Calendar.cellClick(Calendar.getElement(A),A||window.event);if(Calendar.is_ie){document.selection.empty()}};Calendar.dayMouseOver=function(B){var A=Calendar.getElement(B);if(Calendar.isRelated(A,B)||Calendar._C||A.disabled){return false}if(A.ttip){if(A.ttip.substr(0,1)=="_"){A.ttip=A.caldate.print(A.calendar.ttDateFormat)+A.ttip.substr(1)}A.calendar.tooltips.innerHTML=A.ttip}if(A.navtype!=300){Calendar.addClass(A,"hilite");if(A.caldate){Calendar.addClass(A.parentNode,"rowhilite")}}return Calendar.stopEvent(B)};Calendar.dayMouseOut=function(ev){with(Calendar){var el=getElement(ev);if(isRelated(el,ev)||_C||el.disabled){return false}removeClass(el,"hilite");if(el.caldate){removeClass(el.parentNode,"rowhilite")}if(el.calendar){el.calendar.tooltips.innerHTML=_TT.SEL_DATE}return stopEvent(ev)}};Calendar.cellClick=function(E,R){var C=E.calendar;var L=false;var O=false;var J=null;if(typeof E.navtype=="undefined"){if(C.currentDateEl){Calendar.removeClass(C.currentDateEl,"selected");Calendar.addClass(E,"selected");L=(C.currentDateEl==E);if(!L){C.currentDateEl=E}}C.date.setDateOnly(E.caldate);J=C.date;var B=!(C.dateClicked=!E.otherMonth);if(!B&&!C.currentDateEl){C._toggleMultipleDate(new Date(J))}else{O=!E.disabled}if(B){C._init(C.firstDayOfWeek,J)}}else{if(E.navtype==200){Calendar.removeClass(E,"hilite");C.callCloseHandler();return }J=new Date(C.date);if(E.navtype==0){J.setDateOnly(new Date())}C.dateClicked=false;var Q=J.getFullYear();var K=J.getMonth();function A(U){var V=J.getDate();var T=J.getMonthDays(U);if(V>T){J.setDate(T)}J.setMonth(U)}switch(E.navtype){case 400:Calendar.removeClass(E,"hilite");var S=Calendar._TT.ABOUT;if(typeof S!="undefined"){S+=C.showsTime?Calendar._TT.ABOUT_TIME:""}else{S='Help and about box text is not translated into this language.\nIf you know this language and you feel generous please update\nthe corresponding file in "lang" subdir to match calendar-en.js\nand send it back to <mihai_bazon@yahoo.com> to get it into the distribution  ;-)\n\nThank you!\nhttp://dynarch.com/mishoo/calendar.epl\n'}alert(S);return ;case -2:if(Q>C.minYear){J.setFullYear(Q-1)}break;case -1:if(K>0){A(K-1)}else{if(Q-->C.minYear){J.setFullYear(Q);A(11)}}break;case 1:if(K<11){A(K+1)}else{if(Q<C.maxYear){J.setFullYear(Q+1);A(0)}}break;case 2:if(Q<C.maxYear){J.setFullYear(Q+1)}break;case 100:C.setFirstDayOfWeek(E.fdow);return ;case 50:var N=E._range;var P=E.innerHTML;for(var M=N.length;--M>=0;){if(N[M]==P){break}}if(R&&R.shiftKey){if(--M<0){M=N.length-1}}else{if(++M>=N.length){M=0}}var D=N[M];E.innerHTML=D;C.onUpdateTime();return ;case 0:if((typeof C.getDateStatus=="function")&&C.getDateStatus(J,J.getFullYear(),J.getMonth(),J.getDate())){return false}break}if(!J.equalsTo(C.date)){C.setDate(J);O=true}else{if(E.navtype==0){O=L=true}}}if(O){R&&C.callHandler()}if(L){Calendar.removeClass(E,"hilite");R&&C.callCloseHandler()}};Calendar.prototype.create=function(P){var O=null;if(!P){O=document.getElementsByTagName("body")[0];this.isPopup=true}else{O=P;this.isPopup=false}this.date=this.dateStr?new Date(this.dateStr):new Date();var S=Calendar.createElement("table");this.table=S;S.cellSpacing=0;S.cellPadding=0;S.calendar=this;Calendar.addEvent(S,"mousedown",Calendar.tableMouseDown);var A=Calendar.createElement("div");this.element=A;A.className="calendar";if(this.isPopup){A.style.position="absolute";A.style.display="none"}A.appendChild(S);var M=Calendar.createElement("thead",S);var Q=null;var T=null;var B=this;var E=function(W,V,U){Q=Calendar.createElement("td",T);Q.colSpan=V;Q.className="button";if(U!=0&&Math.abs(U)<=2){Q.className+=" nav"}Calendar._add_evs(Q);Q.calendar=B;Q.navtype=U;Q.innerHTML="<div unselectable='on'>"+W+"</div>";return Q};T=Calendar.createElement("tr",M);var C=6;(this.isPopup)&&--C;(this.weekNumbers)&&++C;E("?",1,400).ttip=Calendar._TT.INFO;this.title=E("",C,300);this.title.className="title";if(this.isPopup){this.title.ttip=Calendar._TT.DRAG_TO_MOVE;this.title.style.cursor="move";E("&#x00d7;",1,200).ttip=Calendar._TT.CLOSE}T=Calendar.createElement("tr",M);T.className="headrow";this._nav_py=E("&#x00ab;",1,-2);this._nav_py.ttip=Calendar._TT.PREV_YEAR;this._nav_pm=E("&#x2039;",1,-1);this._nav_pm.ttip=Calendar._TT.PREV_MONTH;this._nav_now=E(Calendar._TT.TODAY,this.weekNumbers?4:3,0);this._nav_now.ttip=Calendar._TT.GO_TODAY;this._nav_nm=E("&#x203a;",1,1);this._nav_nm.ttip=Calendar._TT.NEXT_MONTH;this._nav_ny=E("&#x00bb;",1,2);this._nav_ny.ttip=Calendar._TT.NEXT_YEAR;T=Calendar.createElement("tr",M);T.className="daynames";if(this.weekNumbers){Q=Calendar.createElement("td",T);Q.className="name wn";Q.innerHTML=Calendar._TT.WK}for(var L=7;L>0;--L){Q=Calendar.createElement("td",T);if(!L){Q.navtype=100;Q.calendar=this;Calendar._add_evs(Q)}}this.firstdayname=(this.weekNumbers)?T.firstChild.nextSibling:T.firstChild;this._displayWeekdays();var K=Calendar.createElement("tbody",S);this.tbody=K;for(L=6;L>0;--L){T=Calendar.createElement("tr",K);if(this.weekNumbers){Q=Calendar.createElement("td",T)}for(var J=7;J>0;--J){Q=Calendar.createElement("td",T);Q.calendar=this;Calendar._add_evs(Q)}}if(this.showsTime){T=Calendar.createElement("tr",K);T.className="time";Q=Calendar.createElement("td",T);Q.className="time";Q.colSpan=2;Q.innerHTML=Calendar._TT.TIME||"&nbsp;";Q=Calendar.createElement("td",T);Q.className="time";Q.colSpan=this.weekNumbers?4:3;(function(){function X(k,n,l,o){var f=Calendar.createElement("span",Q);f.className=k;f.innerHTML=n;f.calendar=B;f.ttip=Calendar._TT.TIME_PART;f.navtype=50;f._range=[];if(typeof l!="number"){f._range=l}else{for(var g=l;g<=o;++g){var e;if(g<10&&o>=10){e="0"+g}else{e=""+g}f._range[f._range.length]=e}}Calendar._add_evs(f);return f}var c=B.date.getHours();var U=B.date.getMinutes();var d=!B.time24;var V=(c>12);if(d&&V){c-=12}var Z=X("hour",c,d?1:0,d?12:23);var Y=Calendar.createElement("span",Q);Y.innerHTML=":";Y.className="colon";var W=X("minute",U,0,59);var a=null;Q=Calendar.createElement("td",T);Q.className="time";Q.colSpan=2;if(d){a=X("ampm",V?"pm":"am",["am","pm"])}else{Q.innerHTML="&nbsp;"}B.onSetTime=function(){var f,e=this.date.getHours(),g=this.date.getMinutes();if(d){f=(e>=12);if(f){e-=12}if(e==0){e=12}a.innerHTML=f?"pm":"am"}Z.innerHTML=(e<10)?("0"+e):e;W.innerHTML=(g<10)?("0"+g):g};B.onUpdateTime=function(){var f=this.date;var g=parseInt(Z.innerHTML,10);if(d){if(/pm/i.test(a.innerHTML)&&g<12){g+=12}else{if(/am/i.test(a.innerHTML)&&g==12){g=0}}}var k=f.getDate();var e=f.getMonth();var l=f.getFullYear();f.setHours(g);f.setMinutes(parseInt(W.innerHTML,10));f.setFullYear(l);f.setMonth(e);f.setDate(k);this.dateClicked=false;this.callHandler()}})()}else{this.onSetTime=this.onUpdateTime=function(){}}var N=Calendar.createElement("tfoot",S);T=Calendar.createElement("tr",N);T.className="footrow";Q=E(Calendar._TT.SEL_DATE,this.weekNumbers?8:7,300);Q.className="ttip";if(this.isPopup){Q.ttip=Calendar._TT.DRAG_TO_MOVE;Q.style.cursor="move"}this.tooltips=Q;A=Calendar.createElement("div",this.element);this.monthsCombo=A;A.className="combo";for(L=0;L<Calendar._MN.length;++L){var D=Calendar.createElement("div");D.className=Calendar.is_ie?"label-IEfix":"label";D.month=L;D.innerHTML=Calendar._SMN[L];A.appendChild(D)}A=Calendar.createElement("div",this.element);this.yearsCombo=A;A.className="combo";for(L=12;L>0;--L){var R=Calendar.createElement("div");R.className=Calendar.is_ie?"label-IEfix":"label";A.appendChild(R)}this._init(this.firstDayOfWeek,this.date);O.appendChild(this.element)};Calendar._keyEvent=function(P){var A=window._dynarch_popupCalendar;if(!A||A.multiple){return false}(Calendar.is_ie)&&(P=window.event);var N=(Calendar.is_ie||P.type=="keypress"),Q=P.keyCode;if(P.ctrlKey){switch(Q){case 37:N&&Calendar.cellClick(A._nav_pm);break;case 38:N&&Calendar.cellClick(A._nav_py);break;case 39:N&&Calendar.cellClick(A._nav_nm);break;case 40:N&&Calendar.cellClick(A._nav_ny);break;default:return false}}else{switch(Q){case 32:Calendar.cellClick(A._nav_now);break;case 27:N&&A.callCloseHandler();break;case 37:case 38:case 39:case 40:if(N){var E,R,O,L,C,D;E=Q==37||Q==38;D=(Q==37||Q==39)?1:7;function B(){C=A.currentDateEl;var K=C.pos;R=K&15;O=K>>4;L=A.ar_days[O][R]}B();function J(){var K=new Date(A.date);K.setDate(K.getDate()-D);A.setDate(K)}function M(){var K=new Date(A.date);K.setDate(K.getDate()+D);A.setDate(K)}while(1){switch(Q){case 37:if(--R>=0){L=A.ar_days[O][R]}else{R=6;Q=38;continue}break;case 38:if(--O>=0){L=A.ar_days[O][R]}else{J();B()}break;case 39:if(++R<7){L=A.ar_days[O][R]}else{R=0;Q=40;continue}break;case 40:if(++O<A.ar_days.length){L=A.ar_days[O][R]}else{M();B()}break}break}if(L){if(!L.disabled){Calendar.cellClick(L)}else{if(E){J()}else{M()}}}}break;case 13:if(N){Calendar.cellClick(A.currentDateEl,P)}break;default:return false}}return Calendar.stopEvent(P)};Calendar.prototype._init=function(P,Z){var Y=new Date(),T=Y.getFullYear(),c=Y.getMonth(),B=Y.getDate();this.table.style.visibility="hidden";var L=Z.getFullYear();if(L<this.minYear){L=this.minYear;Z.setFullYear(L)}else{if(L>this.maxYear){L=this.maxYear;Z.setFullYear(L)}}this.firstDayOfWeek=P;this.date=new Date(Z);var a=Z.getMonth();var e=Z.getDate();var d=Z.getMonthDays();Z.setDate(1);var U=(Z.getDay()-this.firstDayOfWeek)%7;if(U<0){U+=7}Z.setDate(-U);Z.setDate(Z.getDate()+1);var E=this.tbody.firstChild;var N=Calendar._SMN[a];var R=this.ar_days=new Array();var Q=Calendar._TT.WEEKEND;var D=this.multiple?(this.datesCells={}):null;for(var W=0;W<6;++W,E=E.nextSibling){var A=E.firstChild;if(this.weekNumbers){A.className="day wn";A.innerHTML=Z.getWeekNumber();A=A.nextSibling}E.className="daysrow";var X=false,J,C=R[W]=[];for(var V=0;V<7;++V,A=A.nextSibling,Z.setDate(J+1)){J=Z.getDate();var K=Z.getDay();A.className="day";A.pos=W<<4|V;C[V]=A;var O=(Z.getMonth()==a);if(!O){if(this.showsOtherMonths){A.className+=" othermonth";A.otherMonth=true}else{A.className="emptycell";A.innerHTML="&nbsp;";A.disabled=true;continue}}else{A.otherMonth=false;X=true}A.disabled=false;A.innerHTML=this.getDateText?this.getDateText(Z,J):J;if(D){D[Z.print("%Y%m%d")]=A}if(this.getDateStatus){var S=this.getDateStatus(Z,L,a,J);if(this.getDateToolTip){var M=this.getDateToolTip(Z,L,a,J);if(M){A.title=M}}if(S===true){A.className+=" disabled";A.disabled=true}else{if(/disabled/i.test(S)){A.disabled=true}A.className+=" "+S}}if(!A.disabled){A.caldate=new Date(Z);A.ttip="_";if(!this.multiple&&O&&J==e&&this.hiliteToday){A.className+=" selected";this.currentDateEl=A}if(Z.getFullYear()==T&&Z.getMonth()==c&&J==B){A.className+=" today";A.ttip+=Calendar._TT.PART_TODAY}if(Q.indexOf(K.toString())!=-1){A.className+=A.otherMonth?" oweekend":" weekend"}}}if(!(X||this.showsOtherMonths)){E.className="emptyrow"}}this.title.innerHTML=Calendar._MN[a]+", "+L;this.onSetTime();this.table.style.visibility="visible";this._initMultipleDates()};Calendar.prototype._initMultipleDates=function(){if(this.multiple){for(var B in this.multiple){var A=this.datesCells[B];var C=this.multiple[B];if(!C){continue}if(A){A.className+=" selected"}}}};Calendar.prototype._toggleMultipleDate=function(B){if(this.multiple){var C=B.print("%Y%m%d");var A=this.datesCells[C];if(A){var D=this.multiple[C];if(!D){Calendar.addClass(A,"selected");this.multiple[C]=B}else{Calendar.removeClass(A,"selected");delete this.multiple[C]}}}};Calendar.prototype.setDateToolTipHandler=function(A){this.getDateToolTip=A};Calendar.prototype.setDate=function(A){if(!A.equalsTo(this.date)){this._init(this.firstDayOfWeek,A)}};Calendar.prototype.refresh=function(){this._init(this.firstDayOfWeek,this.date)};Calendar.prototype.setFirstDayOfWeek=function(A){this._init(A,this.date);this._displayWeekdays()};Calendar.prototype.setDateStatusHandler=Calendar.prototype.setDisabledHandler=function(A){this.getDateStatus=A};Calendar.prototype.setRange=function(A,B){this.minYear=A;this.maxYear=B};Calendar.prototype.callHandler=function(){if(this.onSelected){this.onSelected(this,this.date.print(this.dateFormat))}};Calendar.prototype.callCloseHandler=function(){if(this.onClose){this.onClose(this)}this.hideShowCovered()};Calendar.prototype.destroy=function(){var A=this.element.parentNode;A.removeChild(this.element);Calendar._C=null;window._dynarch_popupCalendar=null};Calendar.prototype.reparent=function(B){var A=this.element;A.parentNode.removeChild(A);B.appendChild(A)};Calendar._checkCalendar=function(B){var C=window._dynarch_popupCalendar;if(!C){return false}var A=Calendar.is_ie?Calendar.getElement(B):Calendar.getTargetElement(B);for(;A!=null&&A!=C.element;A=A.parentNode){}if(A==null){window._dynarch_popupCalendar.callCloseHandler();return Calendar.stopEvent(B)}};Calendar.prototype.show=function(){var E=this.table.getElementsByTagName("tr");for(var D=E.length;D>0;){var J=E[--D];Calendar.removeClass(J,"rowhilite");var C=J.getElementsByTagName("td");for(var B=C.length;B>0;){var A=C[--B];Calendar.removeClass(A,"hilite");Calendar.removeClass(A,"active")}}this.element.style.display="block";this.hidden=false;if(this.isPopup){window._dynarch_popupCalendar=this;Calendar.addEvent(document,"keydown",Calendar._keyEvent);Calendar.addEvent(document,"keypress",Calendar._keyEvent);Calendar.addEvent(document,"mousedown",Calendar._checkCalendar)}this.hideShowCovered()};Calendar.prototype.hide=function(){if(this.isPopup){Calendar.removeEvent(document,"keydown",Calendar._keyEvent);Calendar.removeEvent(document,"keypress",Calendar._keyEvent);Calendar.removeEvent(document,"mousedown",Calendar._checkCalendar)}this.element.style.display="none";this.hidden=true;this.hideShowCovered()};Calendar.prototype.showAt=function(A,C){var B=this.element.style;B.left=A+"px";B.top=C+"px";this.show()};Calendar.prototype.showAtElement=function(C,D){var A=this;var E=Calendar.getAbsolutePos(C);if(!D||typeof D!="string"){this.showAt(E.x,E.y+C.offsetHeight);return true}function B(M){if(M.x<0){M.x=0}if(M.y<0){M.y=0}var N=document.createElement("div");var L=N.style;L.position="absolute";L.right=L.bottom=L.width=L.height="0px";document.body.appendChild(N);var K=Calendar.getAbsolutePos(N);document.body.removeChild(N);if(Calendar.is_ie){K.y+=document.body.scrollTop;K.x+=document.body.scrollLeft}else{K.y+=window.scrollY;K.x+=window.scrollX}var J=M.x+M.width-K.x;if(J>0){M.x-=J}J=M.y+M.height-K.y;if(J>0){M.y-=J}}this.element.style.display="block";Calendar.continuation_for_the_fucking_khtml_browser=function(){var J=A.element.offsetWidth;var L=A.element.offsetHeight;A.element.style.display="none";var K=D.substr(0,1);var M="l";if(D.length>1){M=D.substr(1,1)}switch(K){case"T":E.y-=L;break;case"B":E.y+=C.offsetHeight;break;case"C":E.y+=(C.offsetHeight-L)/2;break;case"t":E.y+=C.offsetHeight-L;break;case"b":break}switch(M){case"L":E.x-=J;break;case"R":E.x+=C.offsetWidth;break;case"C":E.x+=(C.offsetWidth-J)/2;break;case"l":E.x+=C.offsetWidth-J;break;case"r":break}E.width=J;E.height=L+40;A.monthsCombo.style.display="none";B(E);A.showAt(E.x,E.y)};if(Calendar.is_khtml){setTimeout("Calendar.continuation_for_the_fucking_khtml_browser()",10)}else{Calendar.continuation_for_the_fucking_khtml_browser()}};Calendar.prototype.setDateFormat=function(A){this.dateFormat=A};Calendar.prototype.setTtDateFormat=function(A){this.ttDateFormat=A};Calendar.prototype.parseDate=function(B,A){if(!A){A=this.dateFormat}this.setDate(Date.parseDate(B,A))};Calendar.prototype.hideShowCovered=function(){if(!Calendar.is_ie&&!Calendar.is_opera){return }function B(V){var U=V.style.visibility;if(!U){if(document.defaultView&&typeof (document.defaultView.getComputedStyle)=="function"){if(!Calendar.is_khtml){U=document.defaultView.getComputedStyle(V,"").getPropertyValue("visibility")}else{U=""}}else{if(V.currentStyle){U=V.currentStyle.visibility}else{U=""}}}return U}var T=new Array("applet","iframe","select");var C=this.element;var A=Calendar.getAbsolutePos(C);var J=A.x;var D=C.offsetWidth+J;var S=A.y;var R=C.offsetHeight+S;for(var L=T.length;L>0;){var K=document.getElementsByTagName(T[--L]);var E=null;for(var N=K.length;N>0;){E=K[--N];A=Calendar.getAbsolutePos(E);var Q=A.x;var P=E.offsetWidth+Q;var O=A.y;var M=E.offsetHeight+O;if(this.hidden||(Q>D)||(P<J)||(O>R)||(M<S)){if(!E.__msh_save_visibility){E.__msh_save_visibility=B(E)}E.style.visibility=E.__msh_save_visibility}else{if(!E.__msh_save_visibility){E.__msh_save_visibility=B(E)}E.style.visibility="hidden"}}}};Calendar.prototype._displayWeekdays=function(){var B=this.firstDayOfWeek;var A=this.firstdayname;var D=Calendar._TT.WEEKEND;for(var C=0;C<7;++C){A.className="day name";var E=(C+B)%7;if(C){A.ttip=Calendar._TT.DAY_FIRST.replace("%s",Calendar._DN[E]);A.navtype=100;A.calendar=this;A.fdow=E;Calendar._add_evs(A)}if(D.indexOf(E.toString())!=-1){Calendar.addClass(A,"weekend")}A.innerHTML=Calendar._SDN[(C+B)%7];A=A.nextSibling}};Calendar.prototype._hideCombos=function(){this.monthsCombo.style.display="none";this.yearsCombo.style.display="none"};Calendar.prototype._dragStart=function(ev){if(this.dragging){return }this.dragging=true;var posX;var posY;if(Calendar.is_ie){posY=window.event.clientY+document.body.scrollTop;posX=window.event.clientX+document.body.scrollLeft}else{posY=ev.clientY+window.scrollY;posX=ev.clientX+window.scrollX}var st=this.element.style;this.xOffs=posX-parseInt(st.left);this.yOffs=posY-parseInt(st.top);with(Calendar){addEvent(document,"mousemove",calDragIt);addEvent(document,"mouseup",calDragEnd)}};Date._MD=new Array(31,28,31,30,31,30,31,31,30,31,30,31);Date.SECOND=1000;Date.MINUTE=60*Date.SECOND;Date.HOUR=60*Date.MINUTE;Date.DAY=24*Date.HOUR;Date.WEEK=7*Date.DAY;Date.parseDate=function(K,A){var L=new Date();var M=0;var B=-1;var J=0;var O=K.split(/\W+/);var N=A.match(/%./g);var E=0,D=0;var P=0;var C=0;for(E=0;E<O.length;++E){if(!O[E]){continue}switch(N[E]){case"%d":case"%e":J=parseInt(O[E],10);break;case"%m":B=parseInt(O[E],10)-1;break;case"%Y":case"%y":M=parseInt(O[E],10);(M<100)&&(M+=(M>29)?1900:2000);break;case"%b":case"%B":for(D=0;D<12;++D){if(Calendar._MN[D].substr(0,O[E].length).toLowerCase()==O[E].toLowerCase()){B=D;break}}break;case"%H":case"%I":case"%k":case"%l":P=parseInt(O[E],10);break;case"%P":case"%p":if(/pm/i.test(O[E])&&P<12){P+=12}else{if(/am/i.test(O[E])&&P>=12){P-=12}}break;case"%M":C=parseInt(O[E],10);break}}if(isNaN(M)){M=L.getFullYear()}if(isNaN(B)){B=L.getMonth()}if(isNaN(J)){J=L.getDate()}if(isNaN(P)){P=L.getHours()}if(isNaN(C)){C=L.getMinutes()}if(M!=0&&B!=-1&&J!=0){return new Date(M,B,J,P,C,0)}M=0;B=-1;J=0;for(E=0;E<O.length;++E){if(O[E].search(/[a-zA-Z]+/)!=-1){var Q=-1;for(D=0;D<12;++D){if(Calendar._MN[D].substr(0,O[E].length).toLowerCase()==O[E].toLowerCase()){Q=D;break}}if(Q!=-1){if(B!=-1){J=B+1}B=Q}}else{if(parseInt(O[E],10)<=12&&B==-1){B=O[E]-1}else{if(parseInt(O[E],10)>31&&M==0){M=parseInt(O[E],10);(M<100)&&(M+=(M>29)?1900:2000)}else{if(J==0){J=O[E]}}}}}if(M==0){M=L.getFullYear()}if(B!=-1&&J!=0){return new Date(M,B,J,P,C,0)}return L};Date.prototype.getMonthDays=function(B){var A=this.getFullYear();if(typeof B=="undefined"){B=this.getMonth()}if(((0==(A%4))&&((0!=(A%100))||(0==(A%400))))&&B==1){return 29}else{return Date._MD[B]}};Date.prototype.getDayOfYear=function(){var A=new Date(this.getFullYear(),this.getMonth(),this.getDate(),0,0,0);var C=new Date(this.getFullYear(),0,0,0,0,0);var B=A-C;return Math.floor(B/Date.DAY)};Date.prototype.getWeekNumber=function(){var C=new Date(this.getFullYear(),this.getMonth(),this.getDate(),0,0,0);var B=C.getDay();C.setDate(C.getDate()-(B+6)%7+3);var A=C.valueOf();C.setMonth(0);C.setDate(4);return Math.round((A-C.valueOf())/(7*86400000))+1};Date.prototype.equalsTo=function(A){return((this.getFullYear()==A.getFullYear())&&(this.getMonth()==A.getMonth())&&(this.getDate()==A.getDate())&&(this.getHours()==A.getHours())&&(this.getMinutes()==A.getMinutes()))};Date.prototype.setDateOnly=function(A){var B=new Date(A);this.setDate(1);this.setFullYear(B.getFullYear());this.setMonth(B.getMonth());this.setDate(B.getDate())};Date.prototype.print=function(M){var A=this.getMonth();var L=this.getDate();var N=this.getFullYear();var P=this.getWeekNumber();var Q=this.getDay();var U={};var R=this.getHours();var B=(R>=12);var J=(B)?(R-12):R;var T=this.getDayOfYear();if(J==0){J=12}var C=this.getMinutes();var K=this.getSeconds();U["%a"]=Calendar._SDN[Q];U["%A"]=Calendar._DN[Q];U["%b"]=Calendar._SMN[A];U["%B"]=Calendar._MN[A];U["%C"]=1+Math.floor(N/100);U["%d"]=(L<10)?("0"+L):L;U["%e"]=L;U["%H"]=(R<10)?("0"+R):R;U["%I"]=(J<10)?("0"+J):J;U["%j"]=(T<100)?((T<10)?("00"+T):("0"+T)):T;U["%k"]=R;U["%l"]=J;U["%m"]=(A<9)?("0"+(1+A)):(1+A);U["%M"]=(C<10)?("0"+C):C;U["%n"]="\n";U["%p"]=B?"PM":"AM";U["%P"]=B?"pm":"am";U["%s"]=Math.floor(this.getTime()/1000);U["%S"]=(K<10)?("0"+K):K;U["%t"]="\t";U["%U"]=U["%W"]=U["%V"]=(P<10)?("0"+P):P;U["%u"]=Q+1;U["%w"]=Q;U["%y"]=(""+N).substr(2,2);U["%Y"]=N;U["%%"]="%";var S=/%./g;if(!Calendar.is_ie5&&!Calendar.is_khtml){return M.replace(S,function(V){return U[V]||V})}var O=M.match(S);for(var E=0;E<O.length;E++){var D=U[O[E]];if(D){S=new RegExp(O[E],"g");M=M.replace(S,D)}}return M};Date.prototype.__msh_oldSetFullYear=Date.prototype.setFullYear;Date.prototype.setFullYear=function(B){var A=new Date(this);A.__msh_oldSetFullYear(B);if(A.getMonth()!=this.getMonth()){this.setDate(28)}this.__msh_oldSetFullYear(B)};window._dynarch_popupCalendar=null;Calendar._DN=new Array("Sonntag","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag");Calendar._SDN=new Array("So","Mo","Di","Mi","Do","Fr","Sa","So");Calendar._MN=new Array("Januar","Februar","M\u00e4rz","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember");Calendar._SMN=new Array("Jan","Feb","M\u00e4r","Apr","May","Jun","Jul","Aug","Sep","Okt","Nov","Dez");Calendar._TT={};Calendar._TT.INFO="\u00DCber dieses Kalendarmodul";Calendar._TT.ABOUT="DHTML Date/Time Selector\n(c) dynarch.com 2002-2005 / Author: Mihai Bazon\nFor latest version visit: http://www.dynarch.com/projects/calendar/\nDistributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details.\n\nDatum ausw\u00e4hlen:\n- Benutzen Sie die \xab, \xbb Buttons um das Jahr zu w\u00e4hlen\n- Benutzen Sie die "+String.fromCharCode(8249)+", "+String.fromCharCode(8250)+" Buttons um den Monat zu w\u00e4hlen\n- F\u00fcr eine Schnellauswahl halten Sie die Maustaste \u00fcber diesen Buttons fest.";Calendar._TT.ABOUT_TIME="\n\nZeit ausw\u00e4hlen:\n- Klicken Sie auf die Teile der Uhrzeit, um diese zu erh\u00F6hen\n- oder klicken Sie mit festgehaltener Shift-Taste um diese zu verringern\n- oder klicken und festhalten f\u00fcr Schnellauswahl.";Calendar._TT.TOGGLE="Ersten Tag der Woche w\u00e4hlen";Calendar._TT.PREV_YEAR="Voriges Jahr (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.PREV_MONTH="Voriger Monat (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.GO_TODAY="Heute ausw\u00e4hlen";Calendar._TT.NEXT_MONTH="N\u00e4chst. Monat (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.NEXT_YEAR="N\u00e4chst. Jahr (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.SEL_DATE="Datum ausw\u00e4hlen";Calendar._TT.DRAG_TO_MOVE="Zum Bewegen festhalten";Calendar._TT.PART_TODAY=" (Heute)";Calendar._TT.DAY_FIRST="Woche beginnt mit %s ";Calendar._TT.WEEKEND="0,6";Calendar._TT.CLOSE="Schlie\u00dfen";Calendar._TT.TODAY="Heute";Calendar._TT.TIME_PART="(Shift-)Klick oder Festhalten und Ziehen um den Wert zu \u00e4ndern";Calendar._TT.DEF_DATE_FORMAT="%d.%m.%Y";Calendar._TT.TT_DATE_FORMAT="%a, %b %e";Calendar._TT.WK="wk";Calendar._TT.TIME="Zeit:";Calendar.setup=function(K){function J(L,M){if(typeof K[L]=="undefined"){K[L]=M}}J("inputField",null);J("displayArea",null);J("button",null);J("eventName","click");J("ifFormat","%Y/%m/%d");J("daFormat","%Y/%m/%d");J("singleClick",true);J("disableFunc",null);J("dateStatusFunc",K.disableFunc);J("dateText",null);J("firstDay",null);J("align","Br");J("range",[1900,2999]);J("weekNumbers",true);J("flat",null);J("flatCallback",null);J("onSelect",null);J("onClose",null);J("onUpdate",null);J("date",null);J("showsTime",false);J("timeFormat","24");J("electric",true);J("step",2);J("position",null);J("cache",false);J("showOthers",false);J("multiple",null);var C=["inputField","displayArea","button"];for(var B in C){if(typeof K[C[B]]=="string"){K[C[B]]=document.getElementById(K[C[B]])}}if(!(K.flat||K.multiple||K.inputField||K.displayArea||K.button)){alert("Calendar.setup:\n  Nothing to setup (no fields found).  Please check your code");return false}function A(M){var L=M.params;var N=(M.dateClicked||L.electric);if(N&&L.inputField){L.inputField.value=M.date.print(L.ifFormat);if(typeof L.inputField.onchange=="function"){L.inputField.onchange()}}if(N&&L.displayArea){L.displayArea.innerHTML=M.date.print(L.daFormat)}if(N&&typeof L.onUpdate=="function"){L.onUpdate(M)}if(N&&L.flat){if(typeof L.flatCallback=="function"){L.flatCallback(M)}}if(N&&L.singleClick&&M.dateClicked){M.callCloseHandler()}}if(K.flat!=null){if(typeof K.flat=="string"){K.flat=document.getElementById(K.flat)}if(!K.flat){alert("Calendar.setup:\n  Flat specified but can't find parent.");return false}var E=new Calendar(K.firstDay,K.date,K.onSelect||A);E.showsOtherMonths=K.showOthers;E.showsTime=K.showsTime;E.time24=(K.timeFormat=="24");E.params=K;E.weekNumbers=K.weekNumbers;E.setRange(K.range[0],K.range[1]);E.setDateStatusHandler(K.dateStatusFunc);E.getDateText=K.dateText;if(K.ifFormat){E.setDateFormat(K.ifFormat)}if(K.inputField&&typeof K.inputField.value=="string"){E.parseDate(K.inputField.value)}E.create(K.flat);E.show();return false}var D=K.button||K.displayArea||K.inputField;D["on"+K.eventName]=function(){var L=K.inputField||K.displayArea;var N=K.inputField?K.ifFormat:K.daFormat;var R=false;var P=window.calendar;if(L){K.date=Date.parseDate(L.value||L.innerHTML,N)}if(!(P&&K.cache)){window.calendar=P=new Calendar(K.firstDay,K.date,K.onSelect||A,K.onClose||function(S){S.hide()});P.showsTime=K.showsTime;P.time24=(K.timeFormat=="24");P.weekNumbers=K.weekNumbers;R=true}else{if(K.date){P.setDate(K.date)}P.hide()}if(K.multiple){P.multiple={};for(var M=K.multiple.length;--M>=0;){var Q=K.multiple[M];var O=Q.print("%Y%m%d");P.multiple[O]=Q}}P.showsOtherMonths=K.showOthers;P.yearStep=K.step;P.setRange(K.range[0],K.range[1]);P.params=K;P.setDateStatusHandler(K.dateStatusFunc);P.getDateText=K.dateText;P.setDateFormat(N);if(R){P.create()}P.refresh();if(!K.position){P.showAtElement(K.button||K.displayArea||K.inputField,K.align)}else{P.showAt(K.position[0],K.position[1])}return false};return E};function array(A){for(i=0;i<A;i++){this[i]=0}this.length=A}function integer(A){return A%(4294967295+1)}function shr(B,A){B=integer(B);A=integer(A);if(B-2147483648>=0){B=B%2147483648;B>>=A;B+=1073741824>>(A-1)}else{B>>=A}return B}function shl1(A){A=A%2147483648;if(A&1073741824==1073741824){A-=1073741824;A*=2;A+=2147483648}else{A*=2}return A}function shl(B,A){B=integer(B);A=integer(A);for(var C=0;C<A;C++){B=shl1(B)}return B}function and(B,A){B=integer(B);A=integer(A);var D=(B-2147483648);var C=(A-2147483648);if(D>=0){if(C>=0){return((D&C)+2147483648)}else{return(D&A)}}else{if(C>=0){return(B&C)}else{return(B&A)}}}function or(B,A){B=integer(B);A=integer(A);var D=(B-2147483648);var C=(A-2147483648);if(D>=0){if(C>=0){return((D|C)+2147483648)}else{return((D|A)+2147483648)}}else{if(C>=0){return((B|C)+2147483648)}else{return(B|A)}}}function xor(B,A){B=integer(B);A=integer(A);var D=(B-2147483648);var C=(A-2147483648);if(D>=0){if(C>=0){return(D^C)}else{return((D^A)+2147483648)}}else{if(C>=0){return((B^C)+2147483648)}else{return(B^A)}}}function not(A){A=integer(A);return(4294967295-A)}var state=new array(4);var count=new array(2);count[0]=0;count[1]=0;var buffer=new array(64);var transformBuffer=new array(16);var digestBits=new array(16);var S11=7;var S12=12;var S13=17;var S14=22;var S21=5;var S22=9;var S23=14;var S24=20;var S31=4;var S32=11;var S33=16;var S34=23;var S41=6;var S42=10;var S43=15;var S44=21;function F(A,C,B){return or(and(A,C),and(not(A),B))}function G(A,C,B){return or(and(A,B),and(C,not(B)))}function H(A,C,B){return xor(xor(A,C),B)}function I(A,C,B){return xor(C,or(A,not(B)))}function rotateLeft(A,B){return or(shl(A,B),(shr(A,(32-B))))}function FF(C,B,K,J,A,D,E){C=C+F(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function GG(C,B,K,J,A,D,E){C=C+G(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function HH(C,B,K,J,A,D,E){C=C+H(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function II(C,B,K,J,A,D,E){C=C+I(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function transform(D,J){var C=0,B=0,K=0,E=0;var A=transformBuffer;C=state[0];B=state[1];K=state[2];E=state[3];for(i=0;i<16;i++){A[i]=and(D[i*4+J],255);for(j=1;j<4;j++){A[i]+=shl(and(D[i*4+j+J],255),j*8)}}C=FF(C,B,K,E,A[0],S11,3614090360);E=FF(E,C,B,K,A[1],S12,3905402710);K=FF(K,E,C,B,A[2],S13,606105819);B=FF(B,K,E,C,A[3],S14,3250441966);C=FF(C,B,K,E,A[4],S11,4118548399);E=FF(E,C,B,K,A[5],S12,1200080426);K=FF(K,E,C,B,A[6],S13,2821735955);B=FF(B,K,E,C,A[7],S14,4249261313);C=FF(C,B,K,E,A[8],S11,1770035416);E=FF(E,C,B,K,A[9],S12,2336552879);K=FF(K,E,C,B,A[10],S13,4294925233);B=FF(B,K,E,C,A[11],S14,2304563134);C=FF(C,B,K,E,A[12],S11,1804603682);E=FF(E,C,B,K,A[13],S12,4254626195);K=FF(K,E,C,B,A[14],S13,2792965006);B=FF(B,K,E,C,A[15],S14,1236535329);C=GG(C,B,K,E,A[1],S21,4129170786);E=GG(E,C,B,K,A[6],S22,3225465664);K=GG(K,E,C,B,A[11],S23,643717713);B=GG(B,K,E,C,A[0],S24,3921069994);C=GG(C,B,K,E,A[5],S21,3593408605);E=GG(E,C,B,K,A[10],S22,38016083);K=GG(K,E,C,B,A[15],S23,3634488961);B=GG(B,K,E,C,A[4],S24,3889429448);C=GG(C,B,K,E,A[9],S21,568446438);E=GG(E,C,B,K,A[14],S22,3275163606);K=GG(K,E,C,B,A[3],S23,4107603335);B=GG(B,K,E,C,A[8],S24,1163531501);C=GG(C,B,K,E,A[13],S21,2850285829);E=GG(E,C,B,K,A[2],S22,4243563512);K=GG(K,E,C,B,A[7],S23,1735328473);B=GG(B,K,E,C,A[12],S24,2368359562);C=HH(C,B,K,E,A[5],S31,4294588738);E=HH(E,C,B,K,A[8],S32,2272392833);K=HH(K,E,C,B,A[11],S33,1839030562);B=HH(B,K,E,C,A[14],S34,4259657740);C=HH(C,B,K,E,A[1],S31,2763975236);E=HH(E,C,B,K,A[4],S32,1272893353);K=HH(K,E,C,B,A[7],S33,4139469664);B=HH(B,K,E,C,A[10],S34,3200236656);C=HH(C,B,K,E,A[13],S31,681279174);E=HH(E,C,B,K,A[0],S32,3936430074);K=HH(K,E,C,B,A[3],S33,3572445317);B=HH(B,K,E,C,A[6],S34,76029189);C=HH(C,B,K,E,A[9],S31,3654602809);E=HH(E,C,B,K,A[12],S32,3873151461);K=HH(K,E,C,B,A[15],S33,530742520);B=HH(B,K,E,C,A[2],S34,3299628645);C=II(C,B,K,E,A[0],S41,4096336452);E=II(E,C,B,K,A[7],S42,1126891415);K=II(K,E,C,B,A[14],S43,2878612391);B=II(B,K,E,C,A[5],S44,4237533241);C=II(C,B,K,E,A[12],S41,1700485571);E=II(E,C,B,K,A[3],S42,2399980690);K=II(K,E,C,B,A[10],S43,4293915773);B=II(B,K,E,C,A[1],S44,2240044497);C=II(C,B,K,E,A[8],S41,1873313359);E=II(E,C,B,K,A[15],S42,4264355552);K=II(K,E,C,B,A[6],S43,2734768916);B=II(B,K,E,C,A[13],S44,1309151649);C=II(C,B,K,E,A[4],S41,4149444226);E=II(E,C,B,K,A[11],S42,3174756917);K=II(K,E,C,B,A[2],S43,718787259);B=II(B,K,E,C,A[9],S44,3951481745);state[0]+=C;state[1]+=B;state[2]+=K;state[3]+=E}function init(){count[0]=count[1]=0;state[0]=1732584193;state[1]=4023233417;state[2]=2562383102;state[3]=271733878;for(i=0;i<digestBits.length;i++){digestBits[i]=0}}function update(A){var B,C;B=and(shr(count[0],3),63);if(count[0]<4294967295-7){count[0]+=8}else{count[1]++;count[0]-=4294967295+1;count[0]+=8}buffer[B]=and(A,255);if(B>=63){transform(buffer,0)}}function finish(){var D=new array(8);var E;var C=0,B=0,A=0;for(C=0;C<4;C++){D[C]=and(shr(count[0],(C*8)),255)}for(C=0;C<4;C++){D[C+4]=and(shr(count[1],(C*8)),255)}B=and(shr(count[0],3),63);A=(B<56)?(56-B):(120-B);E=new array(64);E[0]=128;for(C=0;C<A;C++){update(E[C])}for(C=0;C<8;C++){update(D[C])}for(C=0;C<4;C++){for(j=0;j<4;j++){digestBits[C*4+j]=and(shr(state[C],(j*8)),255)}}}function hexa(D){var C="0123456789abcdef";var A="";var B=D;for(hexa_i=0;hexa_i<8;hexa_i++){A=C.charAt(Math.abs(B)%16)+A;B=Math.floor(B/16)}return A}var ascii="01234567890123456789012345678901 !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";function MD5(L){var A,J,B,K,E,D,C;init();for(B=0;B<L.length;B++){A=L.charAt(B);update(ascii.lastIndexOf(A))}finish();K=E=D=C=0;for(i=0;i<4;i++){K+=shl(digestBits[15-i],(i*8))}for(i=4;i<8;i++){E+=shl(digestBits[15-i],((i-4)*8))}for(i=8;i<12;i++){D+=shl(digestBits[15-i],((i-8)*8))}for(i=12;i<16;i++){C+=shl(digestBits[15-i],((i-12)*8))}J=hexa(C)+hexa(D)+hexa(E)+hexa(K);return J}function on_data(B,A){log_debug("on_data triggered");A.innerHTML=B.responseText;collapsed_boxes=getCookie("collapsed_boxes");if(collapsed_boxes){collapsed_boxes=collapsed_boxes.split("-");for(b=0;b<collapsed_boxes.length;b++){box_id=collapsed_boxes[b];if($(box_id)){Cuba.close_box(box_id)}}}Effect.Appear(A,{duration:0.5});init_fun=Cuba.element_init_functions[A.id];if(init_fun){init_fun(A)}}function app_load_interfaces(A){log_debug("in app_load_interface "+A);cb__dispatch_interface("app_left_column","/aurita/"+A+"/left",on_data);cb__dispatch_interface("app_main_content","/aurita/"+A+"/main",on_data)}var active_button;function app_load_setup(A){new Effect.Fade("app_left_column",{duration:0.5});new Effect.Fade("app_main_content",{duration:0.5});if(active_button){active_button.className="header_button"}active_button=document.getElementById("button_"+A);active_button.className="header_button_active";setTimeout(function(){app_load_interfaces(A)},550)}tinyMCE.init({plugins:"paste, auritalink, auritacode, table",theme:"advanced",relative_urls:true,valid_elements:"*[*]",extended_valid_elements:"hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",content_css:"/aurita/inc/editor_content.css",editor_css:"/aurita/inc/editor.css",theme_advanced_styles:"Header 1=header1;Header 2=header2;Header 3=header3;Code=code",theme_advanced_toolbar_align:"left",theme_advanced_buttons1:"bold,italic,underline,strikethrough,bullist,numlist,pastetext,unlink,preview,insertdatetime",theme_advanced_buttons1_add:"auritalink,auritacode,table,formatselect",theme_advanced_buttons2:"",theme_advanced_buttons3:"",theme_advanced_toolbar_location:"top",theme_advanced_resizing:true,theme_advanced_resize_horizontal:false});loading=new Image();loading.src="/aurita/images/icons/loading.gif";Cuba.context_menu_draggable=new Draggable("context_menu");new Draggable("dispatcher");Cuba.disable_context_menu_draggable=function(){Cuba.context_menu_draggable.destroy()};Cuba.enable_context_menu_draggable=function(){Cuba.context_menu_draggable=new Draggable("context_menu")};function interval_reload(A,B,C){setInterval(function(){if(!Cuba.update_targets){Cuba.load({element:A,action:B,silently:true})}},C*1000)}Cuba.check_hashvalue();>>>>>>> .r361
=======
<<<<<<< .mine

 

/* for Safari */
if (/WebKit/i.test(navigator.userAgent)) { // sniff
    var _timer = setInterval(function() {
        if (/loaded|complete/.test(document.readyState)) {
            init(); // call the onload handler
        }
    }, 10);
}

 

/* for other browsers */
window.onload = init;


function rd_admin__ui__tool_showhide(name, nest)
{
    if(nest != '') {
	var box = get_object_by_id(nest,'');
	var content = get_object_by_id(name,nest);
    }
    else {
	content = get_object_by_id(name, ''); 
    }
    if(content.display == "none") {
	content.display = "";
	if(nest != '') { box.width="240px"; }
    } 
    else {
	content.display = "none"; 
	if(nest != '') { box.width="24px"; }
    }
}
function rd_admin__ui__tool_varwidth_showhide(name, nest, width)
{
    var box = get_object_by_id(nest,'');
    var content = get_object_by_id(name,nest);
    if(content.display == "none") {
	content.display = "";
	box.width=width+"px";
    } 
    else {
	content.display = "none"; 
	box.width="24px";
    }
}
function rd_admin__ui__show(name, nest)
{
    var hide_obj = get_object_by_id(name, nest);
    hide_obj.display = "";
    
}
function rd_admin__ui__hide(name, nest)
{
    var hide_obj = get_object_by_id(name, nest);
    hide_obj.display = "none";
}

function rd_admin__handle_exception(error_name, action)
{
    rd_admin__ui__showhide('rd_admin__ui__error',''); 
    //  parent.rd_admin__ui__scratch.location.href="dispatcher.rhtml?rd__model=Error_Handler&rd__error="+error_name+"&rd__controller="+action; 
}
function rd_admin__raise_exception(	header,message, 
					label1,action1,type1,  
					label2,action2,type2,
					label3,action3,type3)
{
    rd_admin__ui__show('rd_admin__ui__error',''); 
    // apply button styles etc
    if(action1 != '') { 
	rd_admin__ui__show_button('rd_admin__ui__error_button1', 'rd_admin__ui__error', label1, type1); 
	//	apply_style('rd_admin__ui__error_button1', 'rd_admin__ui__error', 'background_color'='#990000');
    }
    if(action2 != '') { 
	rd_admin__ui__show('rd_admin__ui__error_button2', 'rd_admin__ui__error'); 
	//	apply_style('rd_admin__ui__error_button2', 'rd_admin__ui__error', 'class'=type2);
    } 
    else { rd_admin__ui__hide('rd_admin__ui__error_button2', 'rd_admin__ui__error'); }
    if(action3 != '') { 
	rd_admin__ui__show('rd_admin__ui__error_button3', 'rd_admin__ui__error'); 
	//	apply_style('rd_admin__ui__error_button3', 'rd_admin__ui__error', 'class'=type3); 
    }
    else { rd_admin__ui__hide('rd_admin__ui__error_button3', 'rd_admin__ui__error'); }
    
}
function rd_admin__ui__show_button(name, nest, label, type) 
{
    var button = get_object_by_id(name, nest);
    button.display = "";
}

function rd_admin__location(frame, url)
{
    eval(frame+'.location.href='+"'"+url+"'"); 
}

function rd_admin__popup_asset(url, w, h) 
{
    if(w == undefined || w > screen.width)   { w = screen.width/2; resize = '1'; }
    if(h == undefined || h > screen.height)  { h = screen.height/2; resize = '1'; }
    
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable='+resize+',menubar=0,fullscreen=0,status=0'
	win = window.open(url,"app",settings);
    win.focus();
}

function rd_admin__popup(url, width, height)
{
    w=width;
    h=height;
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable=0,menubar=0,fullscreen=0,status=0';
    win = window.open(url,'win'+width+'x'+height,settings);
    
    win.focus();	
}

function rd_admin__article_preview(project, aid)
{
    rd_admin__popup('/projects/'+project+'/Node/preview_article/rd__article_id='+aid, 1024, 768); 
}
function rd_admin__node_preview(project, bg, cid)
{
    rd_admin__popup('/projects/'+project+'/Site/content/bg='+bg+'&track='+cid+'&x='+screen.width+'&y='+screen.height+'&cid='+cid, screen.width*0.7, screen.height-200); 
}

function rd_admin__select_box_value(select_id)
{
    select_obj = document.getElementById(select_id); 
    with (select_obj) return options[selectedIndex].value;
}

function rd_admin__swap_checkbox(checkbox_id)
{
    checkbox = document.getElementById(checkbox_id);
    if(checkbox.checked) { checkbox.checked = false; }
    else { checkbox.checked = true; } 
}

date_obj = new Date(); 

function swap_image_choice_list()
{
    Element.setStyle('image_choice_list', { display: '' }); 
    Element.setStyle('text_asset_form', { display: 'none' }); 
    Element.setStyle('choose_custom_form', { display: 'none' }); 
    Cuba.disable_context_menu_draggable(); 
}
function swap_text_edit_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: ''}); 
    Element.setStyle('choose_custom_form', { display: 'none'}); 
    Cuba.enable_context_menu_draggable(); 
}
function swap_choose_custom_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: 'none'}); 
    Element.setStyle('choose_custom_form', { display: ''}); 
    Cuba.enable_context_menu_draggable(); 
}

function profile_load_interfaces(uid, what)
{
  Cuba.load({ element: 'profile_content', action: 'Community::User_Profile/show_'+what+'/user_group_id='+uid, on_update: on_data }); 
}

var active_profile_button = false;
function profile_load(uid, which)
{
  new Effect.Fade('profile_content', {duration: 0.5}); 
  if($('profile_flag_main')) { 
    $('profile_flag_main').className = 'flag_button'
  }
  if($('profile_flag_own_main')) { 
    $('profile_flag_own_main').className = 'flag_button'
  }
  $('profile_flag_galery').className = 'flag_button'
  $('profile_flag_posts').className  = 'flag_button'
  $('profile_flag_friends').className  = 'flag_button'
  if(!active_profile_button) { 
    document.getElementById('profile_flag_main'); 
  }
  active_profile_button.className = 'flag_button';
  active_profile_button = document.getElementById('profile_flag_'+which); 
  active_profile_button.className = 'flag_button_active';
  setTimeout("profile_load_interfaces('"+uid+"','"+which+"')", 550); 
}

function messaging_load_interfaces(uid, what)
{
  Cuba.load({ element: 'messaging_content', action: 'Community::User_Message/show_'+what+'/user_group_id='+uid, on_update: on_data }); 
}

var active_messaging_button = false;
function messaging_load(uid, which)
{
  new Effect.Fade('messaging_content', {duration: 0.5}); 
  $('messaging_flag_inbox').className = 'flag_button'
  $('messaging_flag_sent').className = 'flag_button'
  $('messaging_flag_read').className  = 'flag_button'
  $('messaging_flag_trash').className  = 'flag_button'
  if(!active_messaging_button) { 
    document.getElementById('messaging_flag_main'); 
  }
  active_messaging_button.className = 'flag_button';
  active_messaging_button = document.getElementById('messaging_flag_'+which); 
  active_messaging_button.className = 'flag_button_active';
  setTimeout("messaging_load_interfaces('"+uid+"','"+which+"')", 550); 
}

function autocomplete_single_username_handler(li)
{
  username = li.innerHTML.replace(/(.+)?<b>([^<]+)<\/b>(.+)/, "$2"); 
  user_group_id = li.id.replace('user__',''); 
  if(!autocomplete_selected_users[user_group_id]) { 
  $('username_list').innerHTML += '<div id="user_autocomplete_entry_'+ user_group_id +'">'+
                                  '<span class="link" onclick="Element.remove(\'user_autocomplete_entry_'+ user_group_id +'\'); '+
                                                              'autocomplete_selected_users['+user_group_id+'] = false; ">x</span> '+
                                  username +'<br />' +
                                  '<span style="margin-left: 7px; ">'+
                                  '<input type="checkbox" value="t" name="readonly_'+ user_group_id +'" /> nur Lesen'+
                                  '</span>'+
                                  '<input type="hidden" value="'+ user_group_id +'" name="user_group_ids[]" />'+
                                  '</div>';
  }
  autocomplete_selected_users[user_group_id] = true; 

}


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


var mouse_x = 0; 
var mouse_y = 0; 
function capture_mouse(ev) 
{
    if(!ev) { ev = window.event; }
    if(!ev) { return ; }

    if(Browser.is_ie) {
      mouse_x = ev.clientX + document.body.scrollLeft; 
      mouse_y = ev.clientY + document.body.scrollTop; 
    }
    else if(Browser.is_gecko) { 
      mouse_x = ev.pageX; 
      mouse_y = ev.pageY; 
    }
    //    window.status = mouse_x + 'x' + mouse_y; 
}
function get_mouse(event) 
{
    return [mouse_x, mouse_y];


    if(Browser.is_ie) {
	mouse_x = event.clientX + document.body.scrollLeft; 
	mouse_y = event.clientY + document.body.scrollTop; 
    }
    else if(Browser.is_gecko) { 
	mouse_x = event.pageX; 
	mouse_y = event.pageY; 
    }
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
      Element.setStyle($(last_hovered_element), { backgroundColor: 'transparent' }); 
    } catch(e) { }
  }
  Element.setStyle($(elem_id), { backgroundColor: '#bfbfbf' }); 
  last_hovered_element = elem_id; 
}
function unhover_element(elem_id) { 
  Element.setStyle($(elem_id), { backgroundColor: '' }); 
}

var element_style_unfocussed;
function focus_element(element_id)
{
    if(element_style_unfocussed == undefined) {
    //  element_style_unfocussed = rgb_to_hex(Element.getStyle(element_id, 'color')); 
      element_style_unfocussed = (Element.getStyle(element_id, 'color')); 
    }
    //    alert(element_style_unfocussed);
    Element.setStyle(element_id, {backgroundColor: '#ccc8c8'});
    Element.setStyle(element_id, {zIndex: 301});
}
function unfocus_element(element_id)
{
    if(element_exists(element_id)) {
      if(element_style_unfocussed) { 
        Element.setStyle(element_id, {color: element_style_unfocussed}); 
      }
      Element.setStyle(element_id, {backgroundColor: '' });
      Element.setStyle(element_id, {zIndex: 1});
      element_style_unfocussed = undefined; 
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


function init_login_screen(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
}


function init_article_interface(element) { 
    initLightbox(); 
}

function init_autocomplete_username(xml_conn, element, update_source)
{
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_username", 
                         "autocomplete_username_choices", 
                         "/aurita/autocomplete_username.fcgi", 
                         { 
                           minChars: 2, 
                           tokens: [' ',',','\n']
                         }
  );
}
function init_autocomplete_single_username(xml_conn, element, update_source)
{
  autocomplete_selected_users = {}; 
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_username", 
                         "autocomplete_username_choices", 
                         "/aurita/autocomplete_username.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_single_username_handler, 
                           tokens: []
                         }
  );
}

function autocomplete_link_article_handler(text, li) { 
  plaintext = Cuba.temp_range.text; 
  hashcode = text.id.replace('__','--'); 
  onclick = "Cuba.set_hashcode(&apos;"+hashcode+"&apos;); "; 
  if(Cuba.check_if_internet_explorer() == '1') { 
    marker_key = 'find_and_replace_me';
    Cuba.temp_range.text = marker_key; 
    editor_html = Cuba.temp_editor_instance.getBody().innerHTML; 
    pos = editor_html.indexOf(marker_key); 
    if(pos != -1) { 
      Cuba.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
    }
  } 
  else 
  { 
    tinyMCE.execInstanceCommand(Cuba.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+hashcode+'" onclick="'+onclick+'">'+Cuba.temp_range+'</a>');
  }
  context_menu_close(); 
}

function init_autocomplete_articles(xml_conn, element, update_source)
{
  log_debug('in init_autocomplete_articles'); 
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_article", 
                         "autocomplete_article_choices", 
                         "/aurita/dispatch.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_article_handler, 
                           tokens: [' ',',','\n']
                         }
  );
}
function init_link_autocomplete_articles()
{
  new Ajax.Autocompleter("autocomplete_link_article", 
                         "autocomplete_link_article_choices", 
                         "/aurita/dispatch.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_link_article_handler, 
                           tokens: [' ',',','\n']
                         }
  );
}

function init_media_interface(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    for(index=0; index<3000; index++) {
      if(document.getElementById('folder_'+index))
      {
          Cuba.droppables[index] = index;
          Droppables.add('folder_'+index,
             { onDrop: drop_image_in_folder, 
               onHover: activate_target, 
               greedy: true }); 
      }
    }

}

function init_poll_editor(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    Poll_Editor.option_counter = 0; 
    Poll_Editor.option_amount = 0; 
}

var reorder_article_content_id; 
function on_article_reorder(container)
{
    position_values = Sortable.serialize(container.id);
    cb__load_interface_silently('dispatcher','/aurita/Wiki::Article/perform_reorder/' + position_values + '&content_id_parent=' + reorder_article_content_id); 
}
function init_article_reorder_interface(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    Sortable.create("article_partials_list", 
		    { dropOnEmpty:true, 
		      onUpdate: on_article_reorder, 
		      handle: true }); 
}

function init_article(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
    initLightbox(); 
}

var tinyMCE = tinyMCE; 
var registered_editors = {}; 
function flush_editor_register() {
    for(var editor_id in registered_editors) {
      flush_editor(editor_id);     
    }
    registered_editors = {}; 
}

function init_editor(textarea_element_id) 
{
    if(registered_editors[textarea_element_id] == null) { 
      registered_editors[textarea_element_id] = textarea_element_id; 
      tinyMCE.execCommand('mceAddControl', false, textarea_element_id); 
    }
}
function save_editor(textarea_element_id) 
{
    if($(textarea_element_id)) { 
      Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
    }
    registered_editors[textarea_element_id] = null; 
    tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
    tinyMCE.execCommand('mceRemoveControl', true, textarea_element_id);
    tinyMCE.triggerSave(true,true);
}
function flush_editor(textarea_element_id)
{
    if(!$(textarea_element_id)) { return; }

    Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
    log_debug('flushing '+textarea_element_id); 
    tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
    tinyMCE.execCommand('mceRemoveControl', true, textarea_element_id);
    tinyMCE.triggerSave();
    registered_editors[textarea_element_id] = null; 
}
function init_all_editors(element) {
	try { 
		elements = document.getElementsByTagName('textarea');
		if(!elements || elements == undefined || elements == null) { log_debug('elements in init_all_editors is undefined'); return; }
		if(elements == undefined || !elements.length) { log_debug('Error: elements.length in init_all_editors is undefined'); return; }
		for (var i = 0; i < elements.length; i++) {
			elem_id = elements.item(i).id; 
			if(registered_editors[elem_id] == null) { 
				log_debug('init editor instance: ' + elem_id);
				inst = $(elem_id); 
				if(inst) { init_editor(elem_id); }
			}
		}
  } catch(e) { 
		log_debug('Catched Exception'); 
		return; 
  }
}

function save_all_editors(element) {
	try { 
		var inst = false; 
		elements = document.getElementsByTagName('textarea');
		if(!elements || elements == undefined || elements == null) { log_debug('Error: elements in init_all_editors is undefined'); return; }
		log_debug('saving all editors'); 
		for (var i = 0; i < elements.length; i++) {
			elem_id = elements.item(i).id; 
			if(elem_id && elem_id.match('lore_textarea')) { 
				inst = $(elem_id);
			}
			if(inst) { save_editor(inst.id); }
		}
  } catch(e) { 
		log_debug('Catched Exception'); 
  }
  return true; 
}

function enlarge_textarea() {
    for(i=0; i<10; i++) {
      inst = document.getElementById('mce_editor_'+i); 
      if(inst) { Element.setStyle(inst, { width: '500px', height: '300px' }); }
    }
}


function init_user_profile()
{
    alert('foo'); 
    init_editor('guestbook_textarea'); 
}

var calendar; 
function open_calendar(field_id, button_id)
{

    var onSelect = function(calendar, date) { 
      document.getElementById(field_id).value = date; 
      if (calendar.dateClicked) {
          calendar.callCloseHandler(); // this calls "onClose" (see above)
      };
    }
    var onClose = function(calendar) { calendar.hide(); }

    calendar = new Calendar(1, null, onSelect, onClose);

    calendar.create(); 

    calendar.showAtElement(document.getElementById(field_id), 'Bl'); 

    return; ///////////////////////////////////////////////////////////

    if(document.getElementById('date_field')) {
      Calendar.setup({
             inputField  : "date_field",  // ID of the input field
             ifFormat    : "%d.%m.%Y",    // the date format
             button      : "date_trigger" // ID of the button
      });
    }
}

function reload_selected_media_assets()
{
    cb__load_interface_silently('selected_media_assets', '/aurita/Wiki::Media_Asset/list_selected/content_id='+active_text_asset_content_id);
}
function asset_entry_string(image_index, content_id, media_asset_id, thumbnail_suffix)
{
  if(!thumbnail_suffix || thumbnail_suffix == 'jpg') { 
    thumbnail_suffix = media_asset_id; 
  }
  string = ''+
   '<div id="image_wrap__'+content_id+'">'+
   '<div style="float: left; margin-top: 4px; margin-left: 4px; height: 120px; border: 1px solid #aaaaaa; background-color: #ffffff; ">'+
     '<div style="height: 100px; width: 120px; overflow: hidden;">'+
       '<img src="/aurita/assets/thumb/asset_'+thumbnail_suffix+'.jpg" />'+
     '</div>'+
     '<div onclick="deselect_image('+content_id+');" style="cursor: pointer; background-color: #eaeaea; padding: 3px; position: relative; left: 0px; bottom: 0px; width: 12px; height: 12px; text-align: center; ">X</div>'+
   '</div>'+
   '</div>'; 

   return string; 
}
var active_text_asset_content_id;
function mark_image(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix)
{
  marked_image_register = document.getElementById('marked_image_register').value; 
  if (marked_image_register != '') { 
      marked_image_register += '_'; 
  }
  marked_image_register += media_asset_content_id; 
  document.getElementById('marked_image_register').value = marked_image_register; 

  document.getElementById('selected_media_assets').innerHTML += asset_entry_string(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix);
}
function deselect_image(media_asset_content_id) 
{ 
  Cuba.delete_element('image_wrap__'+ media_asset_content_id);
  marked_image_register = document.getElementById('marked_image_register').value; 
  marked_image_register = marked_image_register.replace(media_asset_content_id, '').replace('__', '_');
  document.getElementById('marked_image_register').value = marked_image_register; 
}
function init_container_inline_editor(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
    init_all_editors(); 
}
/** XHConn - Simple XMLHTTP Interface - bfults@gmail.com - 2005-04-08        **
 ** Code licensed under Creative Commons Attribution-ShareAlike License      **
 ** http://creativecommons.org/licenses/by-sa/2.0/                           **/
function XHConn()
{
  var xmlhttp, bComplete = false;

  try {
      //    netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (e) {
    alert("Permission UniversalBrowserRead denied.");
  }

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (e) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (e) { try { xmlhttp = new XMLHttpRequest(); }
  catch (e) { xmlhttp = false; }}}
  if (!xmlhttp) return null;
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars) {
  
      if(postVars == undefined) { postVars = ""; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
  	      sURL += '&randseed='+Math.round(Math.random()*100000);
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type",
                                     "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
              bComplete = true;
              if(fnDone) { 
                    fnDone(xmlhttp, element, sMethod=='POST');
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
	      xmlhttp.setRequestHeader("Content-Type",
				       "application/x-www-form-urlencoded");
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

/*
// Maps interface names to init functions. Means "Call this function 
// after this interface has been requested"
Cuba.init_functions = { 
    'Wiki::Article.show' : init_article_interface, 
    'Wiki::Container.update' : init_all_editors, 
    'App_Main.login' : init_login_screen
};

// Maps element ids to init functions. Means: "Call this function when 
// updating this element". This Hash is to be filled automatically. 
Cuba.element_init_functions = {}
Cuba.update_targets = {}; 
*/
function update_element(xml_conn, element, do_update_source)
{
    if(element) {
	response = xml_conn.responseText;

	if(response == "\n") 
	{
	    if(element.id == 'context_menu') {
        context_menu_close(); 
	    }
	    element.display = 'none';
	} 
	else
	{
	    element.innerHTML = response; 

	    init_fun = Cuba.element_init_functions[element.id]
	    if(init_fun) { init_fun(element); }
	}
    }
    if(do_update_source) {
      for(var target in Cuba.update_targets) {
          url = Cuba.update_targets[target];
          cb__update_element(target, url); 
      }
    }
}
function update_element_and_targets(xml_conn, element, update_targets) // update_targets is ignored here
{
    t = '';
    for(var target in Cuba.update_targets) {
	t += target;
    }
//  alert('update '+t+':'+update_targets);
    update_element(xml_conn, element, true); 
}


function cb__get_remote_string(url, response_fun)
{
    var xml_conn = new XHConn; 
    xml_conn.get_string(url, response_fun);
}

function cb__get_form_values(form_id)
{
    form = document.getElementById(form_id);
    
    string = ''
    for(index=0; index<form.elements.length; index++) {
	element = form.elements[index]; 
	if(element.value != '' && element.name != '') { 
	    element_value = element.value;
	    element_value = element_value.replace(/&auml;/g,'ä'); 
	    element_value = element_value.replace(/&ouml;/g,'ö'); 
	    element_value = element_value.replace(/&uuml;/g,'ü'); 
	    element_value = element_value.replace(/&Auml;/g,'Ä'); 
	    element_value = element_value.replace(/&Ouml;/g,'Ö'); 
	    element_value = element_value.replace(/&Uuml;/g,'Ü'); 
	    element_value = element_value.replace(/&szlig;/g,'ß'); 
	    element_value = element_value.replace(/&nbsp;/g,' '); 

	    string += element.name + '=' + element_value + '&'; 
	}
    }
    return string
}

function cb__update_element(element_id, interface_url)
{
    element = document.getElementById(element_id);
    var xml_conn = new XHConn; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    xml_conn.connect(interface_url+'&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000), 'GET', update_element, element); 
}

function cb__remote_submit(form_id, target_id, targets)
{
    context_menu_autoclose = true; 
    target_url     = '/aurita/dispatch'; 
    postVars       = Cuba.get_form_values(form_id);
    postVarsHash   = Cuba.get_form_values_hash(form_id);
    postVars += 'cb__mode=dispatch'; 
    Cuba.update_targets = targets

    interface_call = postVarsHash['cb__model']+'.'+postVarsHash['cb__controller']
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    var xml_conn = new XHConn; 
    element = document.getElementById(target_id); 

    //    xml_conn.connect(target_url, 'POST', update_element_and_targets, element, postVars); 
    xml_conn.connect(target_url, 'POST', update_element, element, postVars); 
}

function cb__async_call(target_id, interface_url, on_complete_fun)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 
    if(on_complete_fun == undefined) { on_complete_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', on_complete_fun, element);
}

function cb__dispatch_interface(target_id, interface_url, update_fun)
{
//  new Effect.Appear(document.getElementById(target_id), {from:0.0, to:0.9, duration:0.5});
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');
    
    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
    
    if(update_fun == undefined && interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    if(update_fun == undefined) { update_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}

function cb__load_interface(target_id, interface_url, targets)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    element.innerHTML  = '<img src="/aurita/images/icons/loading.gif" />'; 
    Cuba.update_targets = targets; 
    if(interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    else { update_fun  = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}
function cb__load_interface_silently(target_id, interface_url)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    xml_conn.connect(interface_url, 'GET', update_element, element); 
}

// Only function allowed to close the 
// currently opened context menu. 
// Also responsible for cleanup-procedure. 
function cb__cancel_dispatch()
{
    context_menu_close();
    return; 
//    dispatcher_hide(); 
//    setTimeout('cb__unfade()',1000); 
    if(context_menu_opened) {
	context_menu_opened = false; 
	document.getElementById('context_menu').style.display = 'none'; 
	unfocus_element(context_menu_active_element_id); 
    } 
    else {
	new Effect.Fade('dispatcher', {duration: 0.5});
    }
}

function cb__show_fullscreen_cover()
{
    new Effect.Appear('app_fullscreen', { from: 0, to: 1 }); 
    Element.setStyle('app_body', { 'overflow-y': 'hidden' });  // override document scroll bars
    $('app_main_content').innerHTML = ''; 
}
function cb__hide_fullscreen_cover()
{
    Element.setStyle('app_body', { 'overflow-y': 'scroll' }); // reactivate document scroll bars
    Element.setStyle('app_fullscreen', { display: 'none' }); 
    $('app_fullscreen').innerHTML = ''; 
}


var Cuba = { 

    loading_symbol: '<img src="/aurita/images/icons/loading.gif" border="0" />', 

    notify_invalid_params : function(klass, method, message) 
    { 
      method = method.replace('perform_',''); 
      klass = klass.replace('Aurita::Main::','').replace('_Controller',''); 
      form_buttons = klass.toLowerCase() + '_' + method + '_form_buttons'; 
      if($(form_buttons)) Element.show(form_buttons); 
      Cuba.alert(message); 
    }, 

    element: function(element_id)
    {
        element = document.getElementById(element_id); 
        if(!element) { 
            element = $(element_id); 
        }
        if(!element) { 
        //  alert('No such element: ' + element_id); 
        }
        return element;
    }, 

    delete_element: function(element_id) 
    {
        Element.remove(element_id); 
    },
    
    get_form_values: function(form_id)
    {
        var form; 
        if(document.forms) {
           form = eval('document.forms.'+form_id); 
        } 
        else {
           form = Cuba.element(form_id);
        }
        string = ''
        for(index=0; index<form.elements.length; index++) {
            element = form.elements[index]; 
            if(element.value != '' && element.name != '') { 
              element_value = element.value;
              element_value = element_value.replace(/&auml;/g,'ä'); 
              element_value = element_value.replace(/&ouml;/g,'ö'); 
              element_value = element_value.replace(/&uuml;/g,'ü'); 
              element_value = element_value.replace(/&Auml;/g,'Ä'); 
              element_value = element_value.replace(/&Ouml;/g,'Ö'); 
              element_value = element_value.replace(/&Uuml;/g,'Ü'); 
              element_value = element_value.replace(/&szlig;/g,'ß'); 
              element_value = element_value.replace(/&nbsp;/g,' '); 
              
              string += element.name + '=' + element_value + '&'; 
            }
        }
        return string;
    },

    get_form_values_hash: function(form_id)
    {
        var form; 
        if(document.forms) {
           form = eval('document.forms.'+form_id); 
        } 
        else {
           form = Cuba.element(form_id);
        }
	
        value_hash = {}; 
        for(index=0; index<form.elements.length; index++) {
            element = form.elements[index]; 
            if(element.value != '' && element.name != '') { 

              element_value = element.value;
              element_value = element_value.replace(/&auml;/g,'ä'); 
              element_value = element_value.replace(/&ouml;/g,'ö'); 
              element_value = element_value.replace(/&uuml;/g,'ü'); 
              element_value = element_value.replace(/&Auml;/g,'Ä'); 
              element_value = element_value.replace(/&Ouml;/g,'Ö'); 
              element_value = element_value.replace(/&Uuml;/g,'Ü'); 
              element_value = element_value.replace(/&szlig;/g,'ß'); 
              element_value = element_value.replace(/&nbsp;/g,' '); 
              
              value_hash[element.name] = element_value;
            }
        }
        return value_hash;
    },
    
    get_remote_string: function(url, response_fun)
    {
        var xml_conn = new XHConn; 
        xml_conn.get_string(url, response_fun);
    },
    
    after_submit_target_map: {
    //  'Wiki::Article.perform_add': { 'app_main_content': 'Wiki::Article.show_own_latest' }, 
        'Community::Role_Permissions.perform_add': { 'app_main_content': 'Community::Role.list' }, 
        'Form_Builder.perform_add': { 'app_main_content': 'Form_Builder.form_added' }, 
        'Community::User_Profile.perform_update': { 'app_main_content': 'Community::User_Profile.show_own' }, 
        'Community::User_Message.perform_add' : { 'messaging_content' : 'Community::User_Message.message_sent'}
    }, 

    after_submit_targets: function(form_id) { 
     // form_values = Cuba.get_form_values_hash(form_id); 
        form_values = Form.serialize(form_id, true); 
        targets = Cuba.after_submit_target_map[form_values['cb__model']+'.'+form_values['cb__controller']];
        return targets; 
    }, 
    
    update_targets: {}, 
    init_functions: {
      'Wiki::Article.show': init_article_interface, 
      'App_Main.login': init_login_screen, 
      'Community::User_Profile.register_user': init_login_screen, 
      'Community::User_Profile.show_galery': initLightbox, 
      'Wiki::Media_Asset_Folder.show': initLightbox
    }, 
    element_init_functions: {}, 

    load_element_content: function(element_id, interface_url)
    {
        element = Cuba.element(element_id); 
        var xml_conn = new XHConn; 
        
        interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
        interface_call = interface_call.replace('/','');

        init_fun = Cuba.init_functions[interface_call];

        if(init_fun && element) { Cuba.element_init_functions[element.id] = init_fun; }
        
//      xml_conn.connect(interface_url+'&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000), 'GET', Cuba.update_element_only, element); 
        xml_conn.connect(interface_url+'&cb__mode=dispatch', 'GET', Cuba.update_element_only, element, true); 
    },

    update_element: function(xml_conn, element, do_update_source)
    {
        response = xml_conn.responseText;
        response_script = false; 
        // See Cuba::Controller.render_view
        if(response.substr(0, 6) == '{ html')
        { 
          json_response = eval('(' + response + ')'); 
          response = json_response.html.replace('\"','"'); 
          response_script = json_response.script.replace('\"','"'); 
        } 
        else if(response.substr(0,8) == '{ script' ) 
        {
          json_response = eval('(' + response + ')'); 
          response = ''
          response_script = json_response.script.replace('\"','"'); 
        }
        if(element) 
        {
          if(response == "\n" || response == '') 
          {
            // This might be a hack: 
            // We currenltly are setting (brute force) element_id to 'dispatcher' in 
            // Cuba.remote_submit (because there, it's the only sensible target element). 
            // Then, however, target 'context_menu' is overridden, so it wouldn't be closed 
            // here. 
            if(element.id == 'context_menu') {
              context_menu_close(); 
            } 
          } 
          else
          {
            element.innerHTML = response; 
          }
          init_fun = Cuba.element_init_functions[element.id]
          if(init_fun) { init_fun(element); }
          if(response_script) { eval(response_script); }
        }

        if(Cuba.update_targets) {
          for(var target in Cuba.update_targets) {
            if(Cuba.update_targets[target]) { 
              url = '/aurita/'+(Cuba.update_targets[target].replace('.','/'));
              url += '&randseed='+Math.round(Math.random()*100000);
              Cuba.load_element_content(target, url);
            }
          }
          // Reset targets so they will be set in next load/remote_submit call: 
          Cuba.update_targets = null; 
        }
    },

    update_element_only: function(xml_conn, element, do_update_source)
    {
      if(element) 
      {
        response = xml_conn.responseText;

        if(response == "\n") 
        {
            if(element.id == 'context_menu') {
              context_menu_close(); 
            }
            Element.setStyle(element, { display: 'none' });
        } 
        else
        {
            element.innerHTML = response; 
        }
        init_fun = Cuba.element_init_functions[element.id]; 
        if(init_fun) { init_fun(element); }
      }
    },

    call: function(interface_url)
    {
      var xml_conn = new XHConn; 
      interface_url += '&cb__mode=dispatch'; 
      xml_conn.connect('/aurita/'+interface_url, 'GET', null, null); 
    },

    current_interface_calls: {}, 
    completed_interface_calls: {}, 
    dispatch_interface: function(params)
    {
      target_id     = params['target']; 
      interface_url = '/aurita/' + params['interface_url']; 
      interface_url.replace('/aurita//aurita/','/aurita/'); 
      
      if(Cuba.current_interface_calls[interface_url]) { log_debug("Duplicate interface call?"); }
      Cuba.current_interface_calls[interface_url] = true; 
      
      log_debug("Dispatch interface "+interface_url);

      update_fun    = params['on_update']; 
      
      Cuba.update_targets = params['targets']; 
      var xml_conn = new XHConn; 
      interface_url += '&cb__mode=dispatch'; 
      element = Cuba.element(target_id); 
      if(!params['silently']) { 
        element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 
      }
      interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
      interface_call = interface_call.replace('/','');
      init_fun = Cuba.init_functions[interface_call];
      if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
      if(update_fun == undefined) { update_fun = Cuba.update_element; }
      xml_conn.connect(interface_url, 'GET', update_fun, element); 
    },

    remote_submit: function(form_id, target_id, targets)
    {

      context_menu_autoclose = true; 
      target_url     = '/aurita/dispatch'; 
      postVars       = Form.serialize(form_id);
      // postVars = Cuba.get_form_values(form_id); 
      postVars += '&cb__mode=dispatch&x=1'; 
      // postVarsHash   = Cuba.get_form_values_hash(form_id); 
      postVarsHash   = Form.serialize(form_id, true); 
      if(targets && !Cuba.update_targets) { 
          Cuba.update_targets = targets; 
      }
      else { 
        // update targets
          for(t in targets) { 
            Cuba.update_targets[t] = targets[t]; 
          }
      }
      
      interface_call = postVarsHash['cb__model']+'.'+postVarsHash['cb__controller']; 
      init_fun = Cuba.init_functions[interface_call];
      if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
      
      var xml_conn = new XHConn; 
      element = Cuba.element(target_id); 
      xml_conn.connect(target_url, 'POST', Cuba.update_element, element, postVars); 
    },

    async_submit: function(params) { 
        Cuba.remote_submit(params['form'], params['element']); 
    },

    load: function(params) {
        params['interface_url'] = params['action']; 
        params['target']        = params['element']; 
        params['targets']       = params['redirect_after']; 
        params['on_update']     = params['on_update']; 
        Cuba.dispatch_interface(params); 
    },

    cancel_dispatch: function() 
    {
      Cuba.close_context_menu();
    },
    // A message box is printing a string (message_text) and 
    // offers a button to close it. 
    alert: function(message_text) {
        Cuba.message_box = new MessageBox({ interface_url: 'App_Main/alert_box/message='+message_text });
        Cuba.message_box.open();
    },
    // A popup includes an arbitrary interface. 
    popup: function(action) {
        Cuba.message_box = new MessageBox({ interface_url: action });
        Cuba.message_box.open();
    },
    
    confirmed_interface: '',
    unconfirmed_interface: '', 
    message_box: undefined, 
    
    on_confirm_action: function() {}, 

    after_confirmed_action: function(xml_conn, element) 
    {
      // do nothing
    },

    // Usage: 
    // <span onclick="Cuba.confirmable_action({ call: 'Community::Forum_Post/delete/forum_post_id=123', 
    //                                          message: 'Really delete post?', 
    //                                          targets: { post_list: 'Community::Forum_Post/list/' } 
    //                                       });" >
    //   delete post
    // </span>
    confirmable_action: function(params) {
      interface_url = params['action']; 
      message       = params['message']; 
      targets       = params['targets']; 
      Cuba.message_box = new MessageBox({ interface_url: 'App_Main/confirmation_box/message='+message }); 
      Cuba.unconfirmed_interface = interface_url; 
      if(params['onconfirm']) { 
        Cuba.on_confirm_action = params['onconfirm']; 
      }
      Cuba.update_targets = targets; 
      Cuba.message_box.open();
    }, 
    confirm_action: function() { 
      Cuba.dispatch_interface({ target: 'dispatcher', 
                                interface_url: Cuba.unconfirmed_interface, 
                                on_update: Cuba.after_confirmed_action, 
                                targets: Cuba.update_targets });
      Cuba.update_targets = {}; 
      Cuba.on_confirm_action(); 
      Cuba.message_box.close(); 
    }, 
    cancel_action: function() { 
      Cuba.update_targets = {}; 
      Cuba.message_box.close(); 
    },

    waiting_for_file_upload: false, 
    before_file_upload: function() {
      Cuba.waiting_for_file_upload = true; 
      Element.setStyle('file_upload_indicator', { display: '' });
    },
    after_file_upload: function() { 
      if(Cuba.waiting_for_file_upload) {
        Element.setStyle('file_upload_indicator', { display: 'none' });
        Cuba.waiting_for_file_upload = false; 
        alert('Datei wurde auf den Server geladen');
      }
    }, 
    upload_file: function(form_id) {
                   alert('upload');
      if(Cuba.waiting_for_file_upload) { 
        alert('Ein anderer Upload l&auml;uft bereits');
        return false;
      }
      Cuba.before_file_upload(); 
      Element.toggle(form_id); 
      Element.toggle('upload_confirmation');
      return true; 
    }
      

} // Namespace Cuba


Cuba.force_load = false; 

Cuba.set_ie_history_fix_iframe_src = function(url) 
{ 
  if(wait_for_iframe_sync == '1') { 
    wait_for_iframe_sync = '0'; 
  } else { 
    wait_for_iframe_sync = '1'; 
  }
  Cuba.ie_history_fix_iframe = parent.ie_fix_history_frame; 
  Cuba.ie_history_fix_iframe.location.href = url; 
};

Cuba.set_hashcode = function(code) 
{
  if(Cuba.check_if_internet_explorer() == 1)
  {
    Cuba.set_ie_history_fix_iframe_src('/aurita/get_code.fcgi?code='+code);
  }
  Cuba.force_load = true; 
  document.location.href = '#'+code;
  Cuba.check_hashvalue(); 
}; 
Cuba.append_hashcode = function(code) { 
    Cuba.force_load = true; 
    document.location.href += '--' + code;
    Cuba.check_hashvalue(); 
}; 


var IFrameObj; // our IFrame object
Cuba.ie_fix_history_frame = function() 
{
  iframe_id = 'ie_fix_history_iframe';

  if (!document.createElement) {return true};
  var IFrameDoc;
  if (!IFrameObj && document.createElement) {
    // create the IFrame and assign a reference to the
    // object to our global variable IFrameObj.
    // this will only happen the first time 
    // callToServer() is called
   try {
      var tempIFrame=document.createElement('iframe');
      tempIFrame.setAttribute('id',iframe_id);
      tempIFrame.style.border='0px';
      tempIFrame.style.width='0px';
      tempIFrame.style.height='0px';
      IFrameObj = document.body.appendChild(tempIFrame);
      
      if (document.frames) {
        // this is for IE5 Mac, because it will only
        // allow access to the document object
        // of the IFrame if we access it through
        // the document.frames array
        IFrameObj = document.frames[iframe_id];
      }
    } catch(exception) {
      // This is for IE5 PC, which does not allow dynamic creation
      // and manipulation of an iframe object. Instead, we'll fake
      // it up by creating our own objects.
      iframeHTML='\<iframe id="'+iframe_id+'" style="';
      iframeHTML+='border:0px;';
      iframeHTML+='width:0px;';
      iframeHTML+='height:0px;';
      iframeHTML+='"><\/iframe>';
      document.body.innerHTML+=iframeHTML;
      IFrameObj = new Object();
      IFrameObj.document = new Object();
      IFrameObj.document.location = new Object();
      IFrameObj.document.location.iframe = document.getElementById(iframe_id);
      IFrameObj.document.location.replace = function(location) {
        this.iframe.src = location;
      }
    }
  }
  
  if (navigator.userAgent.indexOf('Gecko') !=-1 && !IFrameObj.contentDocument) {
    // we have to give NS6 a fraction of a second
    // to recognize the new IFrame
    setTimeout('callToServer()',10);
    return false;
  }
  
  // For access to JS functions in IFrame: 
/*
  if (IFrameObj.contentDocument) {
    // For NS6
    IFrameDoc = IFrameObj.contentDocument; 
  } else if (IFrameObj.contentWindow) {
    // For IE5.5 and IE6
    IFrameDoc = IFrameObj.contentWindow.document;
  } else if (IFrameObj.document) {
    // For IE5
    IFrameDoc = IFrameObj.document;
  } else {
    return true;
  }
  return IFrameDoc;
*/
  return IFrameObj;
}

Cuba.toggle_box = function(box_id) { 
  Element.toggle(box_id + '_body'); 
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
  } else { 
    collapsed_boxes.push(box_id); 
    setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
    $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
  }
}; 
Cuba.close_box = function(box_id) { 
  Element.hide(box_id + '_body'); 
  $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
}; 

  
function show_image(text, li)
{
    media_asset_id = text.id; 
    cb__load_interface('media_folder_content', '/aurita/Wiki::Media_Asset/show/media_asset_id='+media_asset_id);
};

var drop_target_folder; 
function activate_target(draggable, droppable, overlap_perc)
{
    drop_target_folder = droppable; 
};
function drop_image_in_folder(element)
{
    element.style.display = 'none'; 
    if (element.id.search('image') != -1)
    {
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_asset_id='+element.id);
   	}
   	else if(element.id.search('folder') != -1)
   	{
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset_Folder/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_folder_asset_id='+element.id);
   	}
};

Cuba.media_asset_draggables = {}; 
Cuba.create_media_asset_draggable = function(element_id, options) { 
  if(Cuba.media_asset_draggables[element_id] == undefined) {
    Cuba.media_asset_draggables[element_id] = new Draggable(element_id, options);
  }
};

Cuba.destroy_draggables = function() {
  for(var x in Cuba.media_asset_draggables) { 
    Cuba.media_asset_draggables[x].destroy(); 
  }
  Cuba.media_asset_draggables = {}; 
};

Cuba.droppables = {};

Cuba.remove_droppables = function() {
  for(var x in Cuba.droppables) {
      Droppables.remove(document.getElementById('folder_'+Cuba.droppables[x]));
  }
	Cuba.droppables = {};
}

Cuba.shutdown_media_management = function() {
  Cuba.remove_droppables(); 
  Cuba.destroy_draggables(); 
  cb__hide_fullscreen_cover(); 
  Cuba.expanded_folder_ids = {}; 
}

Cuba.expanded_folder_ids = {}
Cuba.load_media_asset_folder_level = function(parent_folder_id, indent) {
  if(Cuba.expanded_folder_ids[parent_folder_id]) {
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/plus.gif'; 
    Cuba.expanded_folder_ids[parent_folder_id] = false; 
    $('folder_children_'+parent_folder_id).innerHTML = '';
    return;
  }
  else { 
    Cuba.expanded_folder_ids[parent_folder_id] = true; 
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/minus.gif'; 
    Cuba.load({ element: 'folder_children_'+parent_folder_id, action: 'Wiki::Media_Asset/print_media_asset_folder_level/media_folder_id='+parent_folder_id+'&indent='+indent, on_update: init_media_interface}); 
  }
}

Cuba.select_media_asset = function(params) {
    var hidden_field_id = params['hidden_field']; 
    var user_id = params['user_id']; 
    var hidden_field = $(hidden_field_id); 
    var select_box_id = 'select_box_'+hidden_field_id;
    select_box = $(select_box_id); 
    Cuba.load({ element: select_box_id, 
                action: 'Wiki::Media_Asset/choose_from_user_folders/user_group_id='+user_id+'&element_id_to_update='+hidden_field_id }); 
    Element.setStyle(select_box, { display: 'block' });
    Element.setStyle(select_box, { width: '100%' });
}; 
Cuba.select_media_asset_click = function(media_asset_id, element_id_to_update) { 
    var hidden_field = $(element_id_to_update);
    var image = $('image_'+element_id_to_update); 
    select_box = $('select_box_'+element_id_to_update); 

    Element.setStyle(select_box, { display: 'none' }); 
    image.src = ''; 
    if(media_asset_id == 0) { 
      image.style.display = 'none';
      hidden_field.value = ''; 
      $('clear_selected_image_button').style.display = 'none'; 
        } else { 
      image.src = '/aurita/assets/asset_'+media_asset_id+'.jpg';
      image.style.display = 'block';
      hidden_field.value = media_asset_id; 
      $('clear_selected_image_button').style.display = ''; 
    }
}; 

Cuba.reload_image = function(element) { 
	var image = $('reloadable_image'); 
	var src = image.src; 
	image.src = ""; 
	image.src = src + '?' + Math.round(Math.random()*1000); 
};

Cuba.folder_hierarchy = new Array();
Cuba.folder_hierarchy.push(0);

Cuba.add_folder_to_hierarchy = function(value) {
  
}

Cuba.open_folder = 0;

Cuba.change_folder_icon = function(value) { 
	folder_to_open = $("folder_icon_" + value);
  folder_to_close = $("folder_icon_" + Cuba.open_folder);
  if(folder_to_close) { 
	  folder_to_close.src = "/aurita/images/icons/folder_closed.gif"; 
  }
	folder_to_open.src = "/aurita/images/icons/folder_opened.gif"; 
  Cuba.open_folder = value;
};

Cuba.reload_background_image = function(element) {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image.style.backgroundImage = ""; 
	image.style.backgroundImage = 'url(' + url + '?' + Math.round(Math.random()*1000) + ')'; 
};

Cuba.rotation_counter = 0;

Cuba.increment_rotation_counter = function() {
	Cuba.rotation_counter += 1;
};

Cuba.check_if_internet_explorer = function() {
  var nAgt = navigator.userAgent;
  if ((verOffset = nAgt.indexOf("MSIE")) != -1) {
    return 1;
  }
  else {
    return 0;
  }
};

Cuba.calculate_aspect_ratio = function() {
  Cuba.check_if_internet_explorer();
	image = $('image_preview');
  url = Element.getStyle('image_preview', 'height');
	url = url.replace(/url\(([^\)]+)\)/,'$1');
  Element.setStyle('image_preview', {'src': url});
	height = Element.getHeight('image_preview'); 
	width = Element.getWidth('image_preview');
	ratio = height / width;
	height = parseInt(width / ratio); 
	if(Cuba.check_if_internet_explorer() == 1) {
    Element.setStyle('crop_line_bottom', { 'top': height-8 } ); 
	}
  else {
    Element.setStyle('crop_line_bottom', { 'top': height-6 } ); 
  }
  Element.setStyle('crop_line_left',   { 'height': height+4 } ); 
  Element.setStyle('crop_line_right',  { 'height': height+4 } ); 
	image.style.height = height;
};

Cuba.ignore_manipulation = false; 
Cuba.image_brightness    = 1.0; 
Cuba.image_hue           = 1.0; 
Cuba.image_saturation    = 1.0; 
Cuba.image_contrast	     = 100; 

Cuba.image_manipulate_brightness = function(value) { 
	Cuba.image_brightness = value; 
	Cuba.manipulate_image();
};
Cuba.image_manipulate_hue = function(value) { 
	Cuba.image_hue = value; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_saturation = function(value) { 
	Cuba.image_saturation = value; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_contrast = function(value) { 
	Cuba.image_contrast = value; 
	Cuba.manipulate_image(); 
};

Cuba.manipulate_image = function(slider_value) // Ignore param
{
   if(!Cuba.ignore_manipulation) { 
     action = 'Wiki::Media_Asset/manipulate/media_asset_id='+ Cuba.active_media_asset_id;
     action += '&brightness='+Cuba.image_brightness;
     action += '&hue='+Cuba.image_hue;
     action += '&saturation='+Cuba.image_saturation; 
     action += '&contrast='+Cuba.image_contrast;
     Cuba.load({ action: action, 
		         element: 'dispatcher', 
		         on_update: Cuba.reload_background_image });
     }
}

Cuba.init_image_manipulation_sliders = function() {
	Cuba.image_brightness_slider = new Control.Slider('brightness_handle', 'brightness_track', {
	    onChange: Cuba.image_manipulate_brightness, 
		range: $R(0,2), 
		sliderValue: 1 }); 
	Cuba.image_hue_slider = new Control.Slider('hue_handle', 'hue_track', {
	    onChange: Cuba.image_manipulate_hue, 
		range: $R(0,2), 
		sliderValue: 1 });
	Cuba.image_saturation_slider = new Control.Slider('saturation_handle', 'saturation_track', {
	    onChange: Cuba.image_manipulate_saturation, 
		range: $R(0,2), 
		sliderValue: 1 });	
	Cuba.image_contrast_slider = new Control.Slider('contrast_handle', 'contrast_track', {
	    onChange: Cuba.image_manipulate_contrast, 
		range: $R(1,200), 
		sliderValue: 100 });
};

Cuba.reset_image = function() { 
    Cuba.ignore_manipulation = true; 
	Cuba.image_brightness_slider.setValue(1);
	Cuba.image_hue_slider.setValue(1);
	Cuba.image_saturation_slider.setValue(1);
	Cuba.image_contrast_slider.setValue(100);
	if(Cuba.rotation_counter % 2 == 1)
	{
		Cuba.calculate_aspect_ratio();
	}
	Cuba.rotation_counter = 0;
	Cuba.reload_background_image();
	Cuba.ignore_manipulation = false; 

};


Cuba.init_crop_lines = function() {
    
    new Draggable('crop_line_left', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_right', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_top', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
    new Draggable('crop_line_bottom', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
};

Cuba.resolve_slider_positions = function() {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image_file = new Image(); 
	image_file.src = url; 
	image_height = image_file.height; 

	position_top = parseInt($('crop_line_top').style.top) + 405;
	position_bottom = parseInt($('crop_line_bottom').style.top) - image_height + 6;
	position_left = parseInt($('crop_line_left').style.left) + 305;
	position_right = parseInt($('crop_line_right').style.left) - 299;
	Cuba.slider_positions = {top: position_top, bottom: position_bottom, left: position_left, right: position_right, height: image_height };
}

Cuba.init_image_manipulation = function(xml_conn, element) { 
	element.innerHTML = xml_conn.responseText;
	Cuba.init_image_manipulation_sliders();
	Cuba.init_crop_lines(); 
}; 


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
    cb__get_remote_string('/aurita/App_Main/validate_user/cb__mode=dispatch&login='+login+'&pass='+pass, Login.check_success); 
  }

} // Namespace Login

var Aurita = {

    last_username: '', 
    username_input_element: '0',

    check_username_available: function(result) { 
	if(result.match('true')) { 
	    Element.setStyle(Aurita.username_input_element, { 'border-color': '#00ff00' });
	} else { 
	    Element.setStyle(Aurita.username_input_element, { 'border-color': '#ff0000' });
	}
    },

    username_available: function(input_element) { 
	if(input_element.value == Aurita.last_username) { return; }
	Aurita.username_input_element = input_element; 
	Aurita.last_username = input_element.value; 
	cb__get_remote_string('/aurita/RBAC::User_Group/username_available/cb__mode=dispatch&user_group_name='+input_element.value, Aurita.check_username_available);
    }

} // namespace Aurita

Cuba.app_domains = ['wortundform2.selfip.com']; 

Cuba.append_autocomplete_value = function(field_id, value) { 
  field = $(field_id); 
  fullvalue = field.value.replace(',', ' ').replace(/\s+/, ' '); 
  values = fullvalue.split(' '); 
  values.pop(); 
  values.push(value); 
  field.value = values.join(' '); 
  field.focus(); 
}

Cuba.get_ie_history_fix_iframe_code = function() 
{
  try { 
    hashcode = parent.ie_fix_history_frame.location.href; 
    for(var i in Cuba.app_domains) {
      hashcode = hashcode.replace('http://'+Cuba.app_domains[i]+'/aurita/get_code.fcgi?code=',''); 
    }
  } catch(e) { 
    hashcode = parent.ie_fix_history_frame.get_code(); 
  }
  return hashcode; 
}

Cuba.last_hashvalue = ''; 
var home_loaded = false; 
wait_for_iframe_sync = '0'; 
Cuba.check_hashvalue = function() 
{
    current_hashvalue = document.location.hash.replace('#',''); 


    if(current_hashvalue.match(/(.+)?_anchor/)) { return;  } 

    if(Cuba.check_if_internet_explorer() == 1) { 
      iframe_hashvalue = Cuba.get_ie_history_fix_iframe_code(); 
      if(iframe_hashvalue != 'no_code' && iframe_hashvalue != current_hashvalue && !Cuba.force_load && iframe_hashvalue != '' && !iframe_hashvalue.match('about:')) { 
        current_hashvalue = iframe_hashvalue; 
      }
      if(document.location.hash != '#'+current_hashvalue) { document.location.hash = current_hashvalue; }
    }

    if(Cuba.force_load || current_hashvalue != Cuba.last_hashvalue && current_hashvalue != '') 
    { 
      window.scrollTo(0,0);

      Cuba.force_load = false; 
      log_debug("loading interface for "+current_hashvalue); 
      flush_editor_register(); 
      Cuba.last_hashvalue = current_hashvalue;

      if(current_hashvalue.match('article--')) { 
          aid = current_hashvalue.replace('article--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Article/show/article_id='+aid, 
                      on_update: init_article }); 
      }
      else if(current_hashvalue.match('user--')) { 
          uid = current_hashvalue.replace('user--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::User_Profile/show_by_username/user_group_name='+uid }); 
      }
      else if(current_hashvalue.match('media--')) { 
          maid = current_hashvalue.replace('media--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Media_Asset/show/media_asset_id='+maid }); 
      }
      else if(current_hashvalue.match('folder--')) { 
          mafid = current_hashvalue.replace('folder--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Media_Asset_Folder/show/media_folder_id='+mafid }); 
      }
      else if(current_hashvalue.match('playlist--')) { 
          pid = current_hashvalue.replace('playlist--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::Playlist_Entry/show/playlist_id='+pid }); 
      }
      else if(current_hashvalue.match('video--')) { 
          vid = current_hashvalue.replace('video--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/play_youtube_video/playlist_entry_id='+vid }); 
      }
      else if(current_hashvalue.match('find--')) { 
          pattern = current_hashvalue.replace('find--','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find/key='+pattern }); 
      }
      else if(current_hashvalue.match('find_full--')) { 
          pattern = current_hashvalue.replace('find_full--','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find_full/key='+pattern }); 
      }
      else if(current_hashvalue.match('topic--')) { 
          tid = current_hashvalue.replace('topic--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::Forum_Topic/show/forum_topic_id='+tid }); 
      }
      else if(current_hashvalue.match('app--')) { 
          action = current_hashvalue.replace('app--','').replace('+','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/'+action+'/' }); 
      }
      else if(current_hashvalue.match('calendar--')) { 
          action = current_hashvalue.replace('calendar--','').replace('+','').replace(/ /g,''); 
          if(action.substr(0,5) == 'day--') { 
            action = 'day/date=' + action.replace('day--','');
          }
          Cuba.load({ element: 'app_main_content', 
                      action: 'Calendar/'+action+'/' }); 
      }
      else {
        action = current_hashvalue.replace('--','/');
          // split hash into controller--action--param1--value1--param2--value2...
          Cuba.load({ element: 'app_main_content', 
                      action: action }); 
      }

    } 
}; 
window.setInterval(Cuba.check_hashvalue, 1000); 

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


Poll_Editor = { 

  option_counter: 0, 
  option_amount: 0, 

  add_option: function() { 
    Poll_Editor.option_counter++; 
    Poll_Editor.option_amount++; 
    field = document.createElement('span');
    field.id = 'poll_option_entry_'+Poll_Editor.option_counter; 
    field.innerHTML = '<input style="margin-top: 2px; " type="text" class="lore" name="poll_option_'+Poll_Editor.option_counter+'" /><span onclick="Poll_Editor.remove_option('+Poll_Editor.option_counter+');" class="lore_text_button" style="height: 19px; ">-</span> <br />';
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
    $('poll_option_entry_'+index).innerHTML = ''; 
    if(Poll_Editor.option_amount < 2) { 
      Element.setStyle('poll_editor_submit_button', { display: 'none' }); 
    }
    if(Poll_Editor.option_amount <= 10) { 
      Element.setStyle('poll_editor_add_option_button', { display: '' }); 
    }
  }

}; 


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

      function on_data(xml_conn, element)
      {
         log_debug('on_data triggered'); 
         element.innerHTML = xml_conn.responseText; 
         // collapse hierarchy boxes
         collapsed_boxes = getCookie('collapsed_boxes'); 
         if(collapsed_boxes) {
           collapsed_boxes = collapsed_boxes.split('-'); 
           for(b=0; b<collapsed_boxes.length; b++) { 
             box_id = collapsed_boxes[b]; 
             if($(box_id)) { 
               Cuba.close_box(box_id); 
             }
           }
         }
         // display content
         Effect.Appear(element, {duration: 0.5}); 
         init_fun = Cuba.element_init_functions[element.id]
         if(init_fun) { init_fun(element); }
      }
      
      function app_load_interfaces(setup_name)
      {
        log_debug('in app_load_interface '+setup_name); 
//      document.getElementById('app_body').className = 'site_body_'+setup_name; 
        cb__dispatch_interface('app_left_column',  '/aurita/'+setup_name+'/left',  on_data); 
        cb__dispatch_interface('app_main_content', '/aurita/'+setup_name+'/main',  on_data); 
      }
      var active_button; 
      function app_load_setup(setup_name)
      {
        new Effect.Fade('app_left_column', {duration: 0.5}); 
        new Effect.Fade('app_main_content', {duration: 0.5}); 
        if(active_button) { 
          active_button.className = 'header_button';
        }
        active_button = document.getElementById('button_'+setup_name); 
        active_button.className = 'header_button_active';
        setTimeout(function() { app_load_interfaces(setup_name) }, 550); 

      }

      tinyMCE.init({
//    do not provide mode! Editor inits are handled event-based when needed. 
      plugins : 'paste, auritalink, auritacode, table',
      theme : "advanced",
      relative_urls : true,
      valid_elements : "*[*]",
      extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
      content_css : "/aurita/inc/editor_content.css",
      editor_css : "/aurita/inc/editor.css", 
      theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
      theme_advanced_toolbar_align : "left", 
      theme_advanced_buttons1 : "bold,italic,underline,strikethrough,bullist,numlist,justifyleft,justifycenter,justifyright,pastetext,unlink,preview,insertdatetime", 
      theme_advanced_buttons1_add : 'auritalink,auritacode,table,formatselect',
      theme_advanced_buttons2 : "", 
      theme_advanced_buttons3 : "", 
      theme_advanced_toolbar_location : "top", 
      theme_advanced_resizing : true, 
      theme_advanced_resize_horizontal : false
      });

      loading = new Image(); 
      loading.src = '/aurita/images/icons/loading.gif'; 

      Cuba.context_menu_draggable = new Draggable('context_menu');
      new Draggable('dispatcher');

      Cuba.disable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable.destroy(); 
      }
      Cuba.enable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable = new Draggable('context_menu');
      }
        


      function interval_reload(elem_id, url, seconds)
      {
        setInterval(function() { if(!Cuba.update_targets) { Cuba.load({ element: elem_id, action: url, silently: true }) } }, seconds * 1000 );
      } 
      interval_reload('changed_articles_body', 'Article/print_recently_changed/', 60); 
      interval_reload('viewed_articles_body', 'Article/print_recently_viewed/', 20); 

      function toggle_mail_notifier(result) { 
        result = result.replace(' ','').replace("\n",''); 
        var new_mail = (result.lastIndexOf("0") == -1 && result != ''); 
        $('dispatcher').innerHTML = result+': '+new_mail; 
        if (new_mail) { 
          Element.setStyle('new_mail_notifier', { display: '' });
          $('unread_mail_amount').innerHTML = '(' + result + ')'; 
        } 
        else { 
          Element.setStyle('new_mail_notifier', { display: 'none' });
        }
      }

      function check_mail_for_user() { 
        Cuba.get_remote_string('/aurita/User_Message/check_mail_for_user/cb__mode=none', toggle_mail_notifier);
      }
      setInterval(check_mail_for_user, 30000);

      Cuba.check_hashvalue(); 

      document.getElementById('app_main_content').style['min-height'] = (window.innerHeight-177)+'px';
=======
}if(/WebKit/i.test(navigator.userAgent)){var _timer=setInterval(function(){if(/loaded|complete/.test(document.readyState)){init()}},10)}window.onload=init;function rd_admin__ui__tool_showhide(A,D){if(D!=""){var C=get_object_by_id(D,"");var B=get_object_by_id(A,D)}else{B=get_object_by_id(A,"")}if(B.display=="none"){B.display="";if(D!=""){C.width="240px"}}else{B.display="none";if(D!=""){C.width="24px"}}}function rd_admin__ui__tool_varwidth_showhide(A,E,B){var D=get_object_by_id(E,"");var C=get_object_by_id(A,E);if(C.display=="none"){C.display="";D.width=B+"px"}else{C.display="none";D.width="24px"}}function rd_admin__ui__show(A,C){var B=get_object_by_id(A,C);B.display=""}function rd_admin__ui__hide(A,C){var B=get_object_by_id(A,C);B.display="none"}function rd_admin__handle_exception(B,A){rd_admin__ui__showhide("rd_admin__ui__error","")}function rd_admin__raise_exception(N,O,K,C,M,J,B,L,D,A,E){rd_admin__ui__show("rd_admin__ui__error","");if(C!=""){rd_admin__ui__show_button("rd_admin__ui__error_button1","rd_admin__ui__error",K,M)}if(B!=""){rd_admin__ui__show("rd_admin__ui__error_button2","rd_admin__ui__error")}else{rd_admin__ui__hide("rd_admin__ui__error_button2","rd_admin__ui__error")}if(A!=""){rd_admin__ui__show("rd_admin__ui__error_button3","rd_admin__ui__error")}else{rd_admin__ui__hide("rd_admin__ui__error_button3","rd_admin__ui__error")}}function rd_admin__ui__show_button(B,E,A,D){var C=get_object_by_id(B,E);C.display=""}function rd_admin__location(frame,url){eval(frame+".location.href='"+url+"'")}function rd_admin__popup_asset(B,A,C){if(A==undefined||A>screen.width){A=screen.width/2;resize="1"}if(C==undefined||C>screen.height){C=screen.height/2;resize="1"}LeftPosition=(screen.width)?(screen.width-A)/2:0;TopPosition=(screen.height)?(screen.height-C)/2:0;settings="height="+C+",width="+A+",top="+TopPosition+",left="+LeftPosition+",scrollbars=1,resizable="+resize+",menubar=0,fullscreen=0,status=0";win=window.open(B,"app",settings);win.focus()}function rd_admin__popup(B,C,A){w=C;h=A;LeftPosition=(screen.width)?(screen.width-w)/2:0;TopPosition=(screen.height)?(screen.height-h)/2:0;settings="height="+h+",width="+w+",top="+TopPosition+",left="+LeftPosition+",scrollbars=1,resizable=0,menubar=0,fullscreen=0,status=0";win=window.open(B,"win"+C+"x"+A,settings);win.focus()}function rd_admin__article_preview(B,A){rd_admin__popup("/projects/"+B+"/Node/preview_article/rd__article_id="+A,1024,768)}function rd_admin__node_preview(B,A,C){rd_admin__popup("/projects/"+B+"/Site/content/bg="+A+"&track="+C+"&x="+screen.width+"&y="+screen.height+"&cid="+C,screen.width*0.7,screen.height-200)}function rd_admin__select_box_value(select_id){select_obj=document.getElementById(select_id);with(select_obj){return options[selectedIndex].value}}function rd_admin__swap_checkbox(A){checkbox=document.getElementById(A);if(checkbox.checked){checkbox.checked=false}else{checkbox.checked=true}}date_obj=new Date();function swap_image_choice_list(){Element.setStyle("image_choice_list",{display:""});Element.setStyle("text_asset_form",{display:"none"});Element.setStyle("choose_custom_form",{display:"none"});Cuba.disable_context_menu_draggable()}function swap_text_edit_form(){Element.setStyle("image_choice_list",{display:"none"});Element.setStyle("text_asset_form",{display:""});Element.setStyle("choose_custom_form",{display:"none"});Cuba.enable_context_menu_draggable()}function swap_choose_custom_form(){Element.setStyle("image_choice_list",{display:"none"});Element.setStyle("text_asset_form",{display:"none"});Element.setStyle("choose_custom_form",{display:""});Cuba.enable_context_menu_draggable()}function profile_load_interfaces(A,B){Cuba.load({element:"profile_content",action:"Community::User_Profile/show_"+B+"/user_group_id="+A,on_update:on_data})}var active_profile_button=false;function profile_load(A,B){new Effect.Fade("profile_content",{duration:0.5});if($("profile_flag_main")){$("profile_flag_main").className="flag_button"}if($("profile_flag_own_main")){$("profile_flag_own_main").className="flag_button"}$("profile_flag_galery").className="flag_button";$("profile_flag_posts").className="flag_button";$("profile_flag_friends").className="flag_button";if(!active_profile_button){document.getElementById("profile_flag_main")}active_profile_button.className="flag_button";active_profile_button=document.getElementById("profile_flag_"+B);active_profile_button.className="flag_button_active";setTimeout("profile_load_interfaces('"+A+"','"+B+"')",550)}function messaging_load_interfaces(A,B){Cuba.load({element:"messaging_content",action:"Community::User_Message/show_"+B+"/user_group_id="+A,on_update:on_data})}var active_messaging_button=false;function messaging_load(A,B){new Effect.Fade("messaging_content",{duration:0.5});$("messaging_flag_inbox").className="flag_button";$("messaging_flag_sent").className="flag_button";$("messaging_flag_read").className="flag_button";$("messaging_flag_trash").className="flag_button";if(!active_messaging_button){document.getElementById("messaging_flag_main")}active_messaging_button.className="flag_button";active_messaging_button=document.getElementById("messaging_flag_"+B);active_messaging_button.className="flag_button_active";setTimeout("messaging_load_interfaces('"+A+"','"+B+"')",550)}function autocomplete_username_handler(B,A){generic_id=B.id}var Browser={is_ie:document.all&&document.getElementById,is_gecko:document.getElementById&&!document.all};function element_exists(A){return(document.getElementById(A)!=undefined)}function add_event(C,B,A){if(C.addEventListener){C.addEventListener(B,A,false)}else{if(C.attachEvent){C["e"+B+A]=A;C[B+A]=function(){C["e"+B+A](window.event)};C.attachEvent("on"+B,C[B+A])}}}function remove_event(C,B,A){if(C.removeEventListener){C.removeEventListener(B,A,false)}else{if(C.detachEvent){C.detachEvent("on"+B,C[B+A]);C[B+A]=null;C["e"+B+A]=null}}}function position_of(A){var B=curtop=0;if(A.offsetParent){B=A.offsetLeft;curtop=A.offsetTop;while(A=A.offsetParent){B+=A.offsetLeft;curtop+=A.offsetTop}}return[B,curtop]}var mouse_x=0;var mouse_y=0;function capture_mouse(A){if(!A){A=window.event}if(!A){return }if(Browser.is_ie){mouse_x=A.clientX+document.body.scrollLeft;mouse_y=A.clientY+document.body.scrollTop}else{if(Browser.is_gecko){mouse_x=A.pageX;mouse_y=A.pageY}}}function get_mouse(A){return[mouse_x,mouse_y];if(Browser.is_ie){mouse_x=A.clientX+document.body.scrollLeft;mouse_y=A.clientY+document.body.scrollTop}else{if(Browser.is_gecko){mouse_x=A.pageX;mouse_y=A.pageY}}return[mouse_x,mouse_y]}function get_style(B,A){if(!document.getElementById){return }var C=B.style[A];if(!C){if(document.defaultView){C=document.defaultView.getComputedStyle(B,"").getPropertyValue(A)}else{if(B.currentStyle){C=B.currentStyle[A]}}}return C}function is_mouse_over(A){if(!A){return }width=parseInt(Element.getWidth(A));height=parseInt(Element.getHeight(A));if(!width){width=A.offsetWidth}if(!height){width=A.offsetheight}pos=position_of(A);x=pos[0];y=pos[1];if(A.style.x){x=A.style.x}if(A.style.y){y=A.style.y}if(mouse_x>=x&&mouse_x<=x+width&&mouse_y>=y&&mouse_y<=y+height){window.status="OVER MENU "+mouse_x+" "+mouse_y;return true}else{return false}}function rgb_to_hex(D){var C=/\([^\)]+\)/gi;var A=""+D.match(C);A=A.replace(/\(/,"").replace(/\)/,"");var B="#";tmp=A.split(", ");for(m=0;m<3;m++){value=(tmp[m]*1).toString(16);if(value.length<2){value="0"+value}B+=value}return B}var last_hovered_element=false;function hover_element(A){if(last_hovered_element){try{Element.setStyle($(last_hovered_element),{backgroundColor:"transparent"})}catch(B){}}Element.setStyle($(A),{backgroundColor:"#bfbfbf"});last_hovered_element=A}function unhover_element(A){Element.setStyle($(A),{backgroundColor:""})}var element_style_unfocussed;function focus_element(A){if(element_style_unfocussed==undefined){element_style_unfocussed=(Element.getStyle(A,"color"))}Element.setStyle(A,{backgroundColor:"#ccc8c8"});Element.setStyle(A,{zIndex:301})}function unfocus_element(A){if(element_exists(A)){if(element_style_unfocussed){Element.setStyle(A,{color:element_style_unfocussed})}Element.setStyle(A,{backgroundColor:""});Element.setStyle(A,{zIndex:1});element_style_unfocussed=undefined}}function swap_style(A,D,B,C){obj=document.getElementById(C);style_curr=obj.style[A];obj.style[A]=D;if(obj.style[A]==style_curr){obj.style[A]=B}}function swap_value(A,C,B){obj=document.getElementById(A);value_curr=obj.value;obj.value=C;if(obj.value==value_curr){obj.value=B}}function resizeable_popup(A,C,B){LeftPosition=(screen.width)?(screen.width-A)/2:0;TopPosition=(screen.height)?(screen.height-C)/2:0;settings="height="+C+",width="+A+",top="+TopPosition+",left="+LeftPosition+",scrollbars=1,resizable=1,menubar=0,fullscreen=0,status=0";win=window.open(B,"popup",settings);win.focus()}function checkbox_swap(A){if(A.checked==true){A.value="1"}else{A.value="0"}}function alert_array(A){s="";for(var B in A){s+=(B+" | "+A[B])}alert(s)}function setCookie(B,D,A,J,C,E){J="/";document.cookie=B+"="+escape(D)+((A)?"; expires="+A.toGMTString():"")+((J)?"; path="+J:"")+((C)?"; domain="+C:"")+((E)?"; secure":"")}function getCookie(C){var B=document.cookie;var E=C+"=";var D=B.indexOf("; "+E);if(D==-1){D=B.indexOf(E);if(D!=0){return null}}else{D+=2}var A=document.cookie.indexOf(";",D);if(A==-1){A=B.length}return unescape(B.substring(D+E.length,A))}function deleteCookie(A,C,B){C="/";if(getCookie(A)){document.cookie=A+"="+((C)?"; path="+C:"")+((B)?"; domain="+B:"")+"; expires=Thu, 01-Jan-70 00:00:01 GMT"}}function init_login_screen(A){new Effect.Appear("login_box",{duration:2,to:1})}function init_article_interface(A){initLightbox()}function init_autocomplete_username(C,B,A){B.innerHTML=C.responseText;new Ajax.Autocompleter("autocomplete_username","autocomplete_username_choices","/aurita/autocomplete_username.fcgi",{minChars:2,tokens:[" ",",","\n"]})}function init_autocomplete_single_username(C,B,A){autocomplete_selected_users={};B.innerHTML=C.responseText;new Ajax.Autocompleter("autocomplete_username","autocomplete_username_choices","/aurita/autocomplete_username.fcgi",{minChars:2,updateElement:autocomplete_single_username_handler,tokens:[]})}function autocomplete_article_handler(B,A){plaintext=Cuba.temp_range.text;if(Cuba.check_if_internet_explorer()=="1"){marker_key="find_and_replace_me";Cuba.temp_range.text=marker_key;editor_html=Cuba.temp_editor_instance.getBody().innerHTML;pos=editor_html.indexOf(marker_key);if(pos!=-1){Cuba.temp_editor_instance.getBody().innerHTML=editor_html.substring(0,pos)+'<a href="#'+B.id.replace("__","--")+'">'+plaintext+"</a>"+editor_html.substring(pos+marker_key.length)}}else{tinyMCE.execInstanceCommand(Cuba.temp_editor_id,"mceInsertRawHTML",false,'<a href="#'+B.id.replace("__","--")+'">'+plaintext+"</a>")}context_menu_close()}function autocomplete_link_article_handler(B,A){plaintext=Cuba.temp_range.text;hashcode=B.id.replace("__","--");onclick="Cuba.set_hashcode(&apos;"+hashcode+"&apos;); ";if(Cuba.check_if_internet_explorer()=="1"){marker_key="find_and_replace_me";Cuba.temp_range.text=marker_key;editor_html=Cuba.temp_editor_instance.getBody().innerHTML;pos=editor_html.indexOf(marker_key);if(pos!=-1){Cuba.temp_editor_instance.getBody().innerHTML=editor_html.substring(0,pos)+'<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+"</a>"+editor_html.substring(pos+marker_key.length)}}else{tinyMCE.execInstanceCommand(Cuba.temp_editor_id,"mceInsertRawHTML",false,'<a href="#'+hashcode+'" onclick="'+onclick+'">'+Cuba.temp_range+"</a>")}context_menu_close()}function autocomplete_single_username_handler(A){username=A.innerHTML.replace(/(.+)?<b>([^<]+)<\/b>(.+)/,"$2");user_group_id=A.id.replace("user__","");if(!autocomplete_selected_users[user_group_id]){$("username_list").innerHTML+='<div id="user_autocomplete_entry_'+user_group_id+'"><span class="link" onclick="Element.remove(\'user_autocomplete_entry_'+user_group_id+"'); autocomplete_selected_users["+user_group_id+'] = false; ">x</span> '+username+'<br /><span style="margin-left: 7px; "><input type="checkbox" value="t" name="readonly_'+user_group_id+'" /> nur Lesen</span><input type="hidden" value="'+user_group_id+'" name="user_group_ids[]" /></div>'}autocomplete_selected_users[user_group_id]=true}function init_autocomplete_articles(C,B,A){B.innerHTML=C.responseText;new Ajax.Autocompleter("autocomplete_article","autocomplete_article_choices","/aurita/dispatch.fcgi",{minChars:2,updateElement:autocomplete_article_handler,tokens:[" ",",","\n"]})}function init_link_autocomplete_articles(){new Ajax.Autocompleter("autocomplete_link_article","autocomplete_link_article_choices","/aurita/dispatch.fcgi",{minChars:2,updateElement:autocomplete_link_article_handler,tokens:[" ",",","\n"]})}function init_media_interface(C,B,A){B.innerHTML=C.responseText;for(index=0;index<3000;index++){if(document.getElementById("folder_"+index)){Cuba.droppables[index]=index;Droppables.add("folder_"+index,{onDrop:drop_image_in_folder,onHover:activate_target,greedy:true})}}}function init_poll_editor(C,B,A){B.innerHTML=C.responseText;Poll_Editor.option_counter=0;Poll_Editor.option_amount=0}var reorder_article_content_id;function on_article_reorder(A){position_values=Sortable.serialize(A.id);cb__load_interface_silently("dispatcher","/aurita/Wiki::Article/perform_reorder/"+position_values+"&content_id_parent="+reorder_article_content_id)}function init_article_reorder_interface(C,B,A){B.innerHTML=C.responseText;Sortable.create("article_partials_list",{dropOnEmpty:true,onUpdate:on_article_reorder,handle:true})}function init_article(C,B,A){B.innerHTML=C.responseText;initLightbox()}var tinyMCE=tinyMCE;var registered_editors={};function flush_editor_register(){for(var A in registered_editors){flush_editor(A)}registered_editors={}}function init_editor(A){if(registered_editors[A]==null){registered_editors[A]=A;tinyMCE.execCommand("mceAddControl",false,A)}}function save_editor(A){if($(A)){Element.setStyle(A,{visibility:"hidden"})}registered_editors[A]=null;tinyMCE.execInstanceCommand(A,"mceCleanup");tinyMCE.execCommand("mceRemoveControl",true,A);tinyMCE.triggerSave(true,true)}function flush_editor(A){if(!$(A)){return }Element.setStyle(A,{visibility:"hidden"});log_debug("flushing "+A);tinyMCE.execInstanceCommand(A,"mceCleanup");tinyMCE.execCommand("mceRemoveControl",true,A);tinyMCE.triggerSave();registered_editors[A]=null}function init_all_editors(B){try{elements=document.getElementsByTagName("textarea");if(!elements||elements==undefined||elements==null){log_debug("elements in init_all_editors is undefined");return }if(elements==undefined||!elements.length){log_debug("Error: elements.length in init_all_editors is undefined");return }for(var A=0;A<elements.length;A++){elem_id=elements.item(A).id;if(registered_editors[elem_id]==null){log_debug("init editor instance: "+elem_id);inst=$(elem_id);if(inst){init_editor(elem_id)}}}}catch(C){log_debug("Catched Exception");return }}function save_all_editors(B){try{var C=false;elements=document.getElementsByTagName("textarea");if(!elements||elements==undefined||elements==null){log_debug("Error: elements in init_all_editors is undefined");return }log_debug("saving all editors");for(var A=0;A<elements.length;A++){elem_id=elements.item(A).id;if(elem_id&&elem_id.match("lore_textarea")){C=$(elem_id)}if(C){save_editor(C.id)}}}catch(D){log_debug("Catched Exception");return }}function enlarge_textarea(){for(i=0;i<10;i++){inst=document.getElementById("mce_editor_"+i);if(inst){Element.setStyle(inst,{width:"500px",height:"300px"})}}}function init_user_profile(){alert("foo");init_editor("guestbook_textarea")}var calendar;function open_calendar(D,C){var B=function(J,E){document.getElementById(D).value=E;if(J.dateClicked){J.callCloseHandler()}};var A=function(E){E.hide()};calendar=new Calendar(1,null,B,A);calendar.create();calendar.showAtElement(document.getElementById(D),"Bl");return ;if(document.getElementById("date_field")){Calendar.setup({inputField:"date_field",ifFormat:"%d.%m.%Y",button:"date_trigger"})}}function reload_selected_media_assets(){cb__load_interface_silently("selected_media_assets","/aurita/Wiki::Media_Asset/list_selected/content_id="+active_text_asset_content_id)}function asset_entry_string(A,C,D,B){if(!B||B=="jpg"){B=D}string='<div id="image_wrap__'+C+'"><div style="float: left; margin-top: 4px; margin-left: 4px; height: 120px; border: 1px solid #aaaaaa; background-color: #ffffff; "><div style="height: 100px; width: 120px; overflow: hidden;"><img src="/aurita/assets/thumb/asset_'+B+'.jpg" /></div><div onclick="deselect_image('+C+');" style="cursor: pointer; background-color: #eaeaea; padding: 3px; position: relative; left: 0px; bottom: 0px; width: 12px; height: 12px; text-align: center; ">X</div></div></div>';return string}var active_text_asset_content_id;function mark_image(B,A,D,C){marked_image_register=document.getElementById("marked_image_register").value;if(marked_image_register!=""){marked_image_register+="_"}marked_image_register+=A;document.getElementById("marked_image_register").value=marked_image_register;document.getElementById("selected_media_assets").innerHTML+=asset_entry_string(B,A,D,C)}function deselect_image(A){Cuba.delete_element("image_wrap__"+A);marked_image_register=document.getElementById("marked_image_register").value;marked_image_register=marked_image_register.replace(A,"").replace("__","_");document.getElementById("marked_image_register").value=marked_image_register}function init_container_inline_editor(C,B,A){B.innerHTML=C.responseText;init_all_editors()}function XHConn(){var B,A=false;try{}catch(C){alert("Permission UniversalBrowserRead denied.")}try{B=new ActiveXObject("Msxml2.XMLHTTP")}catch(C){try{B=new ActiveXObject("Microsoft.XMLHTTP")}catch(C){try{B=new XMLHttpRequest()}catch(C){B=false}}}if(!B){return null}this.connect=function(K,E,L,J,D){if(D==undefined){D=""}if(!B){return false}A=false;try{if(E=="GET"){K+="&randseed="+Math.round(Math.random()*100000);B.open(E,K,true);sVars=""}else{B.open(E,K,true);B.setRequestHeader("Method","POST "+K+" HTTP/1.1");B.setRequestHeader("Content-Type","application/x-www-form-urlencoded")}B.onreadystatechange=function(){if(B.readyState==4&&!A){A=true;if(L){L(B,J,E=="POST")}}};B.send(D)}catch(M){alert(M);return false}return true};this.get_string=function(K,J,E,D){result="";if(D==undefined){D=""}if(E==undefined){E="GET"}if(!B){return false}A=false;try{if(E=="GET"){B.open(E,K,true);sVars=""}else{B.open(E,K,true);B.setRequestHeader("Method","POST "+K+" HTTP/1.1");B.setRequestHeader("Content-Type","application/x-www-form-urlencoded")}B.onreadystatechange=function(){if(B.readyState==4&&!A){A=true;J(B.responseText)}};B.send(D)}catch(L){alert(L);return false}return result};return this}function update_element(B,A,C){if(A){response=B.responseText;if(response=="\n"){if(A.id=="context_menu"){context_menu_close()}A.display="none"}else{A.innerHTML=response;init_fun=Cuba.element_init_functions[A.id];if(init_fun){init_fun(A)}}}if(C){for(var D in Cuba.update_targets){url=Cuba.update_targets[D];cb__update_element(D,url)}}}function update_element_and_targets(C,B,A){t="";for(var D in Cuba.update_targets){t+=D}update_element(C,B,true)}function cb__get_remote_string(B,A){var C=new XHConn;C.get_string(B,A)}function cb__get_form_values(A){form=document.getElementById(A);string="";for(index=0;index<form.elements.length;index++){element=form.elements[index];if(element.value!=""&&element.name!=""){element_value=element.value;element_value=element_value.replace(/&auml;/g,"ä");element_value=element_value.replace(/&ouml;/g,"ö");element_value=element_value.replace(/&uuml;/g,"ü");element_value=element_value.replace(/&Auml;/g,"Ä");element_value=element_value.replace(/&Ouml;/g,"Ö");element_value=element_value.replace(/&Uuml;/g,"Ü");element_value=element_value.replace(/&szlig;/g,"ß");element_value=element_value.replace(/&nbsp;/g," ");string+=element.name+"="+element_value+"&"}}return string}function cb__update_element(B,A){element=document.getElementById(B);var C=new XHConn;interface_call=A.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}C.connect(A+"&cb__mode=dispatch&randseed="+Math.round(Math.random()*100000),"GET",update_element,element)}function cb__remote_submit(B,C,A){context_menu_autoclose=true;target_url="/aurita/dispatch";postVars=Cuba.get_form_values(B);postVarsHash=Cuba.get_form_values_hash(B);postVars+="cb__mode=dispatch";Cuba.update_targets=A;interface_call=postVarsHash.cb__model+"."+postVarsHash.cb__controller;interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}var D=new XHConn;element=document.getElementById(C);D.connect(target_url,"POST",update_element,element,postVars)}function cb__async_call(C,B,A){var D=new XHConn;B+="&cb__mode=dispatch";element=document.getElementById(C);element.innerHTML='<img src="/aurita/images/icons/loading.gif" />';if(A==undefined){A=update_element}D.connect(B,"GET",A,element)}function cb__dispatch_interface(C,A,B){var D=new XHConn;A+="&cb__mode=dispatch";element=document.getElementById(C);element.innerHTML='<img src="/aurita/images/icons/loading.gif" />';interface_call=A.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}if(B==undefined&&A.match("Wiki::Article/show")){B=init_article}if(B==undefined){B=update_element}D.connect(A,"GET",B,element)}function cb__load_interface(C,A,B){var D=new XHConn;A+="&cb__mode=dispatch&randseed="+Math.round(Math.random()*100000);element=document.getElementById(C);element.innerHTML='<img src="/aurita/images/icons/loading.gif" />';Cuba.update_targets=B;if(A.match("Wiki::Article/show")){update_fun=init_article}else{update_fun=update_element}D.connect(A,"GET",update_fun,element)}function cb__load_interface_silently(B,A){var C=new XHConn;A+="&cb__mode=dispatch&randseed="+Math.round(Math.random()*100000);element=document.getElementById(B);C.connect(A,"GET",update_element,element)}function cb__cancel_dispatch(){context_menu_close();return ;if(context_menu_opened){context_menu_opened=false;document.getElementById("context_menu").style.display="none";unfocus_element(context_menu_active_element_id)}else{new Effect.Fade("dispatcher",{duration:0.5})}}function cb__show_fullscreen_cover(){new Effect.Appear("app_fullscreen",{from:0,to:1});Element.setStyle("app_body",{"overflow-y":"hidden"});$("app_main_content").innerHTML=""}function cb__hide_fullscreen_cover(){Element.setStyle("app_body",{"overflow-y":"scroll"});Element.setStyle("app_fullscreen",{display:"none"});$("app_fullscreen").innerHTML=""}var Cuba={compare_arrays:function(B,A){return(B.join("-")==A.join("-"))},random:function(A){if(!A){A=4}return Math.round(Math.random()*Math.exp(10,A))},loading_symbol:'<img src="/aurita/images/icons/loading.gif" border="0" />',notify_invalid_params:function(A,C,B){C=C.replace("perform_","");A=A.replace("Aurita::Main::","").replace("_Controller","");form_buttons=A.toLowerCase()+"_"+C+"_form_buttons";if($(form_buttons)){Element.show(form_buttons)}Cuba.alert(B)},element:function(A){element=document.getElementById(A);if(!element){element=$(A)}if(!element){}return element},delete_element:function(A){Element.remove(A)},get_form_values:function(form_id){var form;if(document.forms){form=eval("document.forms."+form_id)}else{form=Cuba.element(form_id)}string="";for(index=0;index<form.elements.length;index++){element=form.elements[index];if(element.value!=""&&element.name!=""){element_value=element.value;element_value=element_value.replace(/&auml;/g,"ä");element_value=element_value.replace(/&ouml;/g,"ö");element_value=element_value.replace(/&uuml;/g,"ü");element_value=element_value.replace(/&Auml;/g,"Ä");element_value=element_value.replace(/&Ouml;/g,"Ö");element_value=element_value.replace(/&Uuml;/g,"Ü");element_value=element_value.replace(/&szlig;/g,"ß");element_value=element_value.replace(/&nbsp;/g," ");string+=element.name+"="+element_value+"&"}}return string},get_form_values_hash:function(form_id){var form;if(document.forms){form=eval("document.forms."+form_id)}else{form=Cuba.element(form_id)}value_hash={};for(index=0;index<form.elements.length;index++){element=form.elements[index];if(element.value!=""&&element.name!=""){element_value=element.value;element_value=element_value.replace(/&auml;/g,"ä");element_value=element_value.replace(/&ouml;/g,"ö");element_value=element_value.replace(/&uuml;/g,"ü");element_value=element_value.replace(/&Auml;/g,"Ä");element_value=element_value.replace(/&Ouml;/g,"Ö");element_value=element_value.replace(/&Uuml;/g,"Ü");element_value=element_value.replace(/&szlig;/g,"ß");element_value=element_value.replace(/&nbsp;/g," ");value_hash[element.name]=element_value}}return value_hash},get_remote_string:function(B,A){var C=new XHConn;C.get_string(B,A)},after_submit_target_map:{"Community::Role_Permissions.perform_add":{app_main_content:"Community::Role.list"},"Form_Builder.perform_add":{app_main_content:"Form_Builder.form_added"},"Community::User_Profile.perform_update":{app_main_content:"Community::User_Profile.show_own"},"Community::User_Message.perform_add":{messaging_content:"Community::User_Message.message_sent"}},after_submit_targets:function(A){form_values=Form.serialize(A,true);log_debug(form_values.cb__model+"."+form_values.cb__controller);targets=Cuba.after_submit_target_map[form_values.cb__model+"."+form_values.cb__controller];return targets},update_targets:{},init_functions:{"Wiki::Article.show":init_article_interface,"App_Main.login":init_login_screen,"Community::User_Profile.register_user":init_login_screen,"Community::User_Profile.show_galery":initLightbox,"Wiki::Media_Asset_Folder.show":initLightbox},element_init_functions:{},load_element_content:function(B,A){element=Cuba.element(B);var C=new XHConn;interface_call=A.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun&&element){Cuba.element_init_functions[element.id]=init_fun}C.connect(A+"&cb__mode=dispatch","GET",Cuba.update_element_only,element,true)},update_element:function(xml_conn,element,do_update_source){response=xml_conn.responseText;response_script=false;if(response.substr(0,6)=="{ html"){json_response=eval("("+response+")");response=json_response.html.replace('"','"');response_script=json_response.script.replace('"','"')}else{if(response.substr(0,8)=="{ script"){json_response=eval("("+response+")");response="";response_script=json_response.script.replace('"','"')}}if(element){if(response=="\n"||response==""){if(element.id=="context_menu"){context_menu_close()}}else{element.innerHTML=response}init_fun=Cuba.element_init_functions[element.id];if(init_fun&&element){init_fun(element)}if(response_script){eval(response_script)}}if(Cuba.update_targets){for(var target in Cuba.update_targets){if(Cuba.update_targets[target]){url="/aurita/"+(Cuba.update_targets[target].replace(".","/"));url+="&randseed="+Math.round(Math.random()*100000);Cuba.load_element_content(target,url)}}Cuba.update_targets=null}},update_element_only:function(B,A,C){if(A){response=B.responseText;if(response=="\n"){if(A.id=="context_menu"){context_menu_close()}Element.setStyle(A,{display:"none"})}else{A.innerHTML=response}init_fun=Cuba.element_init_functions[A.id];if(init_fun&&A){init_fun(A)}}},call:function(A){var B=new XHConn;A+="&cb__mode=dispatch";B.connect("/aurita/"+A,"GET",null,null)},current_interface_calls:{},completed_interface_calls:{},dispatch_interface:function(B){target_id=B.target;interface_url="/aurita/"+B.interface_url;interface_url.replace("/aurita//aurita/","/aurita/");if(Cuba.current_interface_calls[interface_url]){log_debug("Duplicate interface call?")}Cuba.current_interface_calls[interface_url]=true;log_debug("Dispatch interface "+interface_url);update_fun=B.on_update;Cuba.update_targets=B.targets;var A=new XHConn;interface_url+="&cb__mode=dispatch";element=Cuba.element(target_id);if(!B.silently){element.innerHTML='<img src="/aurita/images/icons/loading.gif" />'}interface_call=interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,"$1.$2");interface_call=interface_call.replace("/","");init_fun=Cuba.init_functions[interface_call];if(init_fun&&element){Cuba.element_init_functions[element.id]=init_fun}if(update_fun==undefined){update_fun=Cuba.update_element}A.connect(interface_url,"GET",update_fun,element)},remote_submit:function(B,C,A){context_menu_autoclose=true;target_url="/aurita/dispatch";postVars=Form.serialize(B);postVars+="&cb__mode=dispatch&x=1";postVarsHash=Form.serialize(B,true);if(A&&!Cuba.update_targets){Cuba.update_targets=A}else{for(t in A){Cuba.update_targets[t]=A[t]}}interface_call=postVarsHash.cb__model+"."+postVarsHash.cb__controller;init_fun=Cuba.init_functions[interface_call];if(init_fun){Cuba.element_init_functions[element.id]=init_fun}var D=new XHConn;element=Cuba.element(C);D.connect(target_url,"POST",Cuba.update_element,element,postVars)},async_submit:function(A){Cuba.remote_submit(A.form,A.element)},load:function(A){if(!$(A.element)){log_debug("Target for Cuba.load does not exist: "+A.target+", ignoring call");return }A.interface_url=A.action;A.target=A.element;A.targets=A.redirect_after;A.on_update=A.on_update;if(A.nocache){A.interface_url+="&rand="+Cuba.random()}Cuba.dispatch_interface(A)},cancel_dispatch:function(){Cuba.close_context_menu()},alert:function(A){Cuba.message_box=new MessageBox({interface_url:"App_Main/alert_box/message="+A});Cuba.message_box.open()},popup:function(A){Cuba.message_box=new MessageBox({interface_url:A});Cuba.message_box.open()},confirmed_interface:"",unconfirmed_interface:"",message_box:undefined,on_confirm_action:function(){},after_confirmed_action:function(B,A){},confirmable_action:function(A){interface_url=A.action;message=A.message;targets=A.targets;Cuba.message_box=new MessageBox({interface_url:"App_Main/confirmation_box/message="+message});Cuba.unconfirmed_interface=interface_url;if(A.onconfirm){Cuba.on_confirm_action=A.onconfirm}Cuba.update_targets=targets;Cuba.message_box.open()},confirm_action:function(){Cuba.dispatch_interface({target:"dispatcher",interface_url:Cuba.unconfirmed_interface,on_update:Cuba.after_confirmed_action,targets:Cuba.update_targets});Cuba.update_targets={};Cuba.on_confirm_action();Cuba.message_box.close()},cancel_action:function(){Cuba.update_targets={};Cuba.message_box.close()},waiting_for_file_upload:false,before_file_upload:function(){Cuba.waiting_for_file_upload=true;Element.setStyle("file_upload_indicator",{display:""})},after_file_upload:function(){if(Cuba.waiting_for_file_upload){Element.setStyle("file_upload_indicator",{display:"none"});Cuba.waiting_for_file_upload=false;alert("Datei wurde auf den Server geladen")}},upload_file:function(A){alert("upload");if(Cuba.waiting_for_file_upload){alert("Ein anderer Upload l&auml;uft bereits");return false}Cuba.before_file_upload();Element.toggle(A);Element.toggle("upload_confirmation");return true}};Cuba.force_load=false;Cuba.append_autocomplete_value=function(A,B){field=$(A);fullvalue=field.value.replace(","," ").replace(/\s+/," ");values=fullvalue.split(" ");values.pop();values.push(B);field.value=values.join(" ");field.focus()};Cuba.set_ie_history_fix_iframe_src=function(A){if(wait_for_iframe_sync=="1"){wait_for_iframe_sync="0"}else{wait_for_iframe_sync="1"}Cuba.ie_history_fix_iframe=parent.ie_fix_history_frame;Cuba.ie_history_fix_iframe.location.href=A};Cuba.set_hashcode=function(A){if(Cuba.check_if_internet_explorer()==1){Cuba.set_ie_history_fix_iframe_src("/aurita/get_code.fcgi?code="+A)}Cuba.force_load=true;document.location.href="#"+A;Cuba.check_hashvalue()};Cuba.append_hashcode=function(A){Cuba.force_load=true;document.location.href+="--"+A;Cuba.check_hashvalue()};Cuba.toggle_user_functions=function(A){log_debug("toggling user functions");A=A.replace(" ","").replace("\n","");if(A.match("1")||A.match("2")){Element.show("button_App_Profile")}if(A.match("2")){Element.show("button_App_Expert")}if(A.match("0")||A==""){Element.hide("button_App_Profile");Element.hide("button_App_Expert")}};Cuba.toggle_mail_notifier=function(A){A=A.replace(" ","").replace("\n","");var B=(A.lastIndexOf("0")==-1&&A!="");log_debug("new mail: "+A+" -> "+B);if(B){Element.setStyle("new_mail_notifier",{display:""});$("unread_mail_amount").innerHTML="("+A+")"}else{Element.setStyle("new_mail_notifier",{display:"none"})}};Cuba.last_feedback={};Cuba.handle_feedback=function(response){if(!response){return }feedback=eval("("+response+")");if(feedback.unread_mail&&Cuba.last_feedback.unread_mail!=feedback.unread_mail){log_debug("-- unread_mail: "+feedback.unread_mail);$("mail_notifier").innerHTML=feedback.unread_mail}if(feedback.random_image){if($("random_image")&&Cuba.last_feedback.random_image!=feedback.random_image){log_debug("-- random_image: "+feedback.random_image);$("random_image").src="/aurita/Wiki::Media_Asset/image/id="+feedback.random_image+"x=220"}}if(feedback.registered!=undefined){if(feedback.registered!=Cuba.last_feedback.registered){log_debug("-- user_registered");Cuba.load({element:"account_box",action:"App_Main/account_box",silently:true});Cuba.load({element:"system_box",action:"App_Main/system_box_body",silently:true});Cuba.get_remote_string("/aurita/User_Group/is_registered/cb__mode=none&rand="+Cuba.random(),Cuba.toggle_user_functions)}}if(feedback.recently_changed){if(!Cuba.last_feedback.recently_changed||!Cuba.compare_arrays(Cuba.last_feedback.recently_changed,feedback.recently_changed)){log_debug("-- recently_changed");Cuba.load({element:"changed_articles_body",action:"Wiki::Article/print_recently_changed/",nocache:true})}}if(feedback.recently_viewed){if(!Cuba.last_feedback.recently_viewed||!Cuba.compare_arrays(Cuba.last_feedback.recently_viewed,feedback.recently_viewed)){log_debug("-- recently_viewed");Cuba.load({element:"viewed_articles_body",action:"Wiki::Article/print_recently_viewed/",nocache:true})}}if(feedback.recently_viewed_media){if(!Cuba.last_feedback.recently_viewed_media||!Cuba.compare_arrays(Cuba.last_feedback.recently_viewed_media,feedback.recently_viewed_media)){log_debug("-- recently_viewed_media");Cuba.load({element:"viewed_media_body",action:"Wiki::Article/print_recently_viewed_media/",nocache:true})}}Cuba.last_feedback=feedback};Cuba.poll_feedback=function(){Cuba.get_remote_string("Async_Feedback/get/cb__mode=none&"+Cuba.random(),Cuba.handle_feedback)};setInterval(Cuba.poll_feedback,15000);Cuba.poll_feedback();var IFrameObj;Cuba.ie_fix_history_frame=function(){iframe_id="ie_fix_history_iframe";if(!document.createElement){return true}var C;if(!IFrameObj&&document.createElement){try{var A=document.createElement("iframe");A.setAttribute("id",iframe_id);A.style.border="0px";A.style.width="0px";A.style.height="0px";IFrameObj=document.body.appendChild(A);if(document.frames){IFrameObj=document.frames[iframe_id]}}catch(B){iframeHTML='<iframe id="'+iframe_id+'" style="';iframeHTML+="border:0px;";iframeHTML+="width:0px;";iframeHTML+="height:0px;";iframeHTML+='"></iframe>';document.body.innerHTML+=iframeHTML;IFrameObj=new Object();IFrameObj.document=new Object();IFrameObj.document.location=new Object();IFrameObj.document.location.iframe=document.getElementById(iframe_id);IFrameObj.document.location.replace=function(D){this.iframe.src=D}}}if(navigator.userAgent.indexOf("Gecko")!=-1&&!IFrameObj.contentDocument){setTimeout("callToServer()",10);return false}return IFrameObj};function show_image(B,A){media_asset_id=B.id;cb__load_interface("media_folder_content","/aurita/Wiki::Media_Asset/show/media_asset_id="+media_asset_id)}var drop_target_folder;function activate_target(A,C,B){drop_target_folder=C}function drop_image_in_folder(A){A.style.display="none";if(A.id.search("image")!=-1){cb__load_interface_silently("","/aurita/Wiki::Media_Asset/move_to_folder/media_folder_id="+drop_target_folder.id+"&media_asset_id="+A.id)}else{if(A.id.search("folder")!=-1){cb__load_interface_silently("","/aurita/Wiki::Media_Asset_Folder/move_to_folder/media_folder_id="+drop_target_folder.id+"&media_folder_asset_id="+A.id)}}}Cuba.media_asset_draggables={};Cuba.create_media_asset_draggable=function(A,B){if(Cuba.media_asset_draggables[A]==undefined){Cuba.media_asset_draggables[A]=new Draggable(A,B)}};Cuba.destroy_draggables=function(){for(var A in Cuba.media_asset_draggables){Cuba.media_asset_draggables[A].destroy()}Cuba.media_asset_draggables={}};Cuba.droppables={};Cuba.remove_droppables=function(){for(var A in Cuba.droppables){Droppables.remove(document.getElementById("folder_"+Cuba.droppables[A]))}Cuba.droppables={}};Cuba.shutdown_media_management=function(){Cuba.remove_droppables();Cuba.destroy_draggables();cb__hide_fullscreen_cover();Cuba.expanded_folder_ids={}};Cuba.expanded_folder_ids={};Cuba.load_media_asset_folder_level=function(B,A){if(Cuba.expanded_folder_ids[B]){$("folder_expand_icon_"+B).src="/aurita/images/icons/plus.gif";Cuba.expanded_folder_ids[B]=false;$("folder_children_"+B).innerHTML="";return }else{Cuba.expanded_folder_ids[B]=true;$("folder_expand_icon_"+B).src="/aurita/images/icons/minus.gif";Cuba.load({element:"folder_children_"+B,action:"Wiki::Media_Asset/print_media_asset_folder_level/media_folder_id="+B+"&indent="+A,on_update:init_media_interface})}};Cuba.select_media_asset=function(D){var C=D.hidden_field;var B=D.user_id;var E=$(C);var A="select_box_"+C;select_box=$(A);Cuba.load({element:A,action:"Wiki::Media_Asset/choose_from_user_folders/user_group_id="+B+"&element_id_to_update="+C});Element.setStyle(select_box,{display:"block"});Element.setStyle(select_box,{width:"100%"})};Cuba.select_media_asset_click=function(B,A){var D=$(A);var C=$("image_"+A);select_box=$("select_box_"+A);Element.setStyle(select_box,{display:"none"});C.src="";if(B==0){C.style.display="none";D.value="";$("clear_selected_image_button").style.display="none"}else{C.src="/aurita/assets/asset_"+B+".jpg";C.style.display="block";D.value=B;$("clear_selected_image_button").style.display=""}};Cuba.reload_image=function(A){var B=$("reloadable_image");var C=B.src;B.src="";B.src=C+"?"+Math.round(Math.random()*1000)};Cuba.folder_hierarchy=new Array();Cuba.folder_hierarchy.push(0);Cuba.add_folder_to_hierarchy=function(A){};Cuba.open_folder=0;Cuba.change_folder_icon=function(A){folder_to_open=$("folder_icon_"+A);folder_to_close=$("folder_icon_"+Cuba.open_folder);if(folder_to_close){folder_to_close.src="/aurita/images/icons/folder_closed.gif"}folder_to_open.src="/aurita/images/icons/folder_opened.gif";Cuba.open_folder=A};Cuba.reload_background_image=function(A){image=$("image_preview");url=image.style.backgroundImage;url=url.replace(/url\(([^\)]+)\)/,"$1");image.style.backgroundImage="";image.style.backgroundImage="url("+url+"?"+Math.round(Math.random()*1000)+")"};Cuba.rotation_counter=0;Cuba.increment_rotation_counter=function(){Cuba.rotation_counter+=1};Cuba.check_if_internet_explorer=function(){var A=navigator.userAgent;if((verOffset=A.indexOf("MSIE"))!=-1){return 1}else{return 0}};Cuba.calculate_aspect_ratio=function(){Cuba.check_if_internet_explorer();image=$("image_preview");url=Element.getStyle("image_preview","height");url=url.replace(/url\(([^\)]+)\)/,"$1");Element.setStyle("image_preview",{src:url});height=Element.getHeight("image_preview");width=Element.getWidth("image_preview");ratio=height/width;height=parseInt(width/ratio);if(Cuba.check_if_internet_explorer()==1){Element.setStyle("crop_line_bottom",{top:height-8})}else{Element.setStyle("crop_line_bottom",{top:height-6})}Element.setStyle("crop_line_left",{height:height+4});Element.setStyle("crop_line_right",{height:height+4});image.style.height=height};Cuba.ignore_manipulation=false;Cuba.image_brightness=1;Cuba.image_hue=1;Cuba.image_saturation=1;Cuba.image_contrast=100;Cuba.image_manipulate_brightness=function(A){Cuba.image_brightness=A;Cuba.manipulate_image()};Cuba.image_manipulate_hue=function(A){Cuba.image_hue=A;Cuba.manipulate_image()};Cuba.image_manipulate_saturation=function(A){Cuba.image_saturation=A;Cuba.manipulate_image()};Cuba.image_manipulate_contrast=function(A){Cuba.image_contrast=A;Cuba.manipulate_image()};Cuba.manipulate_image=function(A){if(!Cuba.ignore_manipulation){action="Wiki::Media_Asset/manipulate/media_asset_id="+Cuba.active_media_asset_id;action+="&brightness="+Cuba.image_brightness;action+="&hue="+Cuba.image_hue;action+="&saturation="+Cuba.image_saturation;action+="&contrast="+Cuba.image_contrast;Cuba.load({action:action,element:"dispatcher",on_update:Cuba.reload_background_image})}};Cuba.init_image_manipulation_sliders=function(){Cuba.image_brightness_slider=new Control.Slider("brightness_handle","brightness_track",{onChange:Cuba.image_manipulate_brightness,range:$R(0,2),sliderValue:1});Cuba.image_hue_slider=new Control.Slider("hue_handle","hue_track",{onChange:Cuba.image_manipulate_hue,range:$R(0,2),sliderValue:1});Cuba.image_saturation_slider=new Control.Slider("saturation_handle","saturation_track",{onChange:Cuba.image_manipulate_saturation,range:$R(0,2),sliderValue:1});Cuba.image_contrast_slider=new Control.Slider("contrast_handle","contrast_track",{onChange:Cuba.image_manipulate_contrast,range:$R(1,200),sliderValue:100})};Cuba.reset_image=function(){Cuba.ignore_manipulation=true;Cuba.image_brightness_slider.setValue(1);Cuba.image_hue_slider.setValue(1);Cuba.image_saturation_slider.setValue(1);Cuba.image_contrast_slider.setValue(100);if(Cuba.rotation_counter%2==1){Cuba.calculate_aspect_ratio()}Cuba.rotation_counter=0;Cuba.reload_background_image();Cuba.ignore_manipulation=false};Cuba.init_crop_lines=function(){new Draggable("crop_line_left",{revert:false,constraint:"horizontal",containment:"image_preview"});new Draggable("crop_line_right",{revert:false,constraint:"horizontal",containment:"image_preview"});new Draggable("crop_line_top",{revert:false,constraint:"vertical",containment:"image_preview"});new Draggable("crop_line_bottom",{revert:false,constraint:"vertical",containment:"image_preview"})};Cuba.resolve_slider_positions=function(){image=$("image_preview");url=image.style.backgroundImage;url=url.replace(/url\(([^\)]+)\)/,"$1");image_file=new Image();image_file.src=url;image_height=image_file.height;position_top=parseInt($("crop_line_top").style.top)+405;position_bottom=parseInt($("crop_line_bottom").style.top)-image_height+6;position_left=parseInt($("crop_line_left").style.left)+305;position_right=parseInt($("crop_line_right").style.left)-299;Cuba.slider_positions={top:position_top,bottom:position_bottom,left:position_left,right:position_right,height:image_height}};Cuba.init_image_manipulation=function(B,A){A.innerHTML=B.responseText;Cuba.init_image_manipulation_sliders();Cuba.init_crop_lines()};var Login={check_success:function(success){var failed=true;if(success!="\n0\n"){user_params=eval(success);if(user_params.session_id){setCookie("cb_login",user_params.session_id,0,"/");failed=false}}if(failed){new Effect.Shake("login_box")}else{new Effect.Fade("login_box",{queue:"front",duration:1});document.location.href="/aurita/App_Main/start/"}},remote_login:function(A,B){A=MD5(A);B=MD5(B);cb__get_remote_string("/aurita/App_Main/validate_user/cb__mode=dispatch&login="+A+"&pass="+B,Login.check_success)}};var Aurita={last_username:"",username_input_element:"0",check_username_available:function(A){if(A.match("true")){Element.setStyle(Aurita.username_input_element,{"border-color":"#00ff00"})}else{Element.setStyle(Aurita.username_input_element,{"border-color":"#ff0000"})}},username_available:function(A){if(A.value==Aurita.last_username){return }Aurita.username_input_element=A;Aurita.last_username=A.value;cb__get_remote_string("/aurita/RBAC::User_Group/username_available/cb__mode=dispatch&user_group_name="+A.value,Aurita.check_username_available)}};Cuba.app_domains=["wortundform2.selfip.com"];Cuba.append_autocomplete_value=function(A,B){field=$(A);fullvalue=field.value.replace(","," ").replace(/\s+/," ");values=fullvalue.split(" ");values.pop();values.push(B);field.value=values.join(" ");field.focus()};Cuba.get_ie_history_fix_iframe_code=function(){try{hashcode=parent.ie_fix_history_frame.location.href;for(var A in Cuba.app_domains){hashcode=hashcode.replace("http://"+Cuba.app_domains[A]+"/aurita/get_code.fcgi?code=","")}}catch(B){hashcode=parent.ie_fix_history_frame.get_code()}return hashcode};Cuba.last_hashvalue="";var home_loaded=false;wait_for_iframe_sync="0";Cuba.check_hashvalue=function(){current_hashvalue=document.location.hash.replace("#","");if(current_hashvalue.match(/(.+)?_anchor/)){return }if(Cuba.check_if_internet_explorer()==1){iframe_hashvalue=Cuba.get_ie_history_fix_iframe_code();if(iframe_hashvalue!="no_code"&&iframe_hashvalue!=current_hashvalue&&!Cuba.force_load&&iframe_hashvalue!=""&&!iframe_hashvalue.match("about:")){current_hashvalue=iframe_hashvalue}if(document.location.hash!="#"+current_hashvalue){document.location.hash=current_hashvalue}}if(Cuba.force_load||current_hashvalue!=Cuba.last_hashvalue&&current_hashvalue!=""){window.scrollTo(0,0);Cuba.force_load=false;log_debug("loading interface for "+current_hashvalue);flush_editor_register();Cuba.last_hashvalue=current_hashvalue;if(current_hashvalue.match("article--")){aid=current_hashvalue.replace("article--","");Cuba.load({element:"app_main_content",action:"Wiki::Article/show/article_id="+aid,on_update:init_article})}else{if(current_hashvalue.match("user--")){uid=current_hashvalue.replace("user--","");Cuba.load({element:"app_main_content",action:"Community::User_Profile/show_by_username/user_group_name="+uid})}else{if(current_hashvalue.match("media--")){maid=current_hashvalue.replace("media--","");Cuba.load({element:"app_main_content",action:"Wiki::Media_Asset/show/media_asset_id="+maid})}else{if(current_hashvalue.match("folder--")){mafid=current_hashvalue.replace("folder--","");Cuba.load({element:"app_main_content",action:"Wiki::Media_Asset_Folder/show/media_folder_id="+mafid})}else{if(current_hashvalue.match("playlist--")){pid=current_hashvalue.replace("playlist--","");Cuba.load({element:"app_main_content",action:"Community::Playlist_Entry/show/playlist_id="+pid})}else{if(current_hashvalue.match("video--")){vid=current_hashvalue.replace("video--","");Cuba.load({element:"app_main_content",action:"App_Main/play_youtube_video/playlist_entry_id="+vid})}else{if(current_hashvalue.match("find--")){pattern=current_hashvalue.replace("find--","").replace(/ /g,"");Cuba.load({element:"app_main_content",action:"App_Main/find/key="+pattern})}else{if(current_hashvalue.match("find_full--")){pattern=current_hashvalue.replace("find_full--","").replace(/ /g,"");Cuba.load({element:"app_main_content",action:"App_Main/find_full/key="+pattern})}else{if(current_hashvalue.match("topic--")){tid=current_hashvalue.replace("topic--","");Cuba.load({element:"app_main_content",action:"Community::Forum_Topic/show/forum_topic_id="+tid})}else{if(current_hashvalue.match("app--")){action=current_hashvalue.replace("app--","").replace("+","").replace(/ /g,"");Cuba.load({element:"app_main_content",action:"App_Main/"+action+"/"})}else{if(current_hashvalue.match("calendar--")){action=current_hashvalue.replace("calendar--","").replace("+","").replace(/ /g,"");if(action.substr(0,5)=="day--"){action="day/date="+action.replace("day--","")}Cuba.load({element:"app_main_content",action:"Calendar/"+action+"/"})}else{action=current_hashvalue.replace("--","/");Cuba.load({element:"app_main_content",action:action})}}}}}}}}}}}}};window.setInterval(Cuba.check_hashvalue,1000);function PageLocator(B,A){this.propertyToUse=B;this.defaultQS=1;this.dividingCharacter=A}PageLocator.prototype.getLocation=function(){return eval(this.propertyToUse)};PageLocator.prototype.getHash=function(){var B=this.getLocation();if(B.indexOf(this.dividingCharacter)>-1){var A=B.split(this.dividingCharacter);return A[A.length-1]}else{return this.defaultQS}};PageLocator.prototype.getHref=function(){var B=this.getLocation();var A=B.split(this.dividingCharacter);return A[0]};PageLocator.prototype.makeNewLocation=function(A){return this.getHref()+this.dividingCharacter+A};Cuba.toggle_box=function(A){Element.toggle(A+"_body");collapsed_boxes=getCookie("collapsed_boxes");if(collapsed_boxes){collapsed_boxes=collapsed_boxes.split("-")}else{collapsed_boxes=[]}if($("collapse_icon_"+A).src.match("plus.gif")){$("collapse_icon_"+A).src="/aurita/images/icons/minus.gif";box_id_string="";for(b=0;b<collapsed_boxes.length;b++){bid=collapsed_boxes[b];if(bid!=A){box_id_string+=bid+"-"}}setCookie("collapsed_boxes",box_id_string)}else{collapsed_boxes.push(A);setCookie("collapsed_boxes",collapsed_boxes.join("-"));$("collapse_icon_"+A).src="/aurita/images/icons/plus.gif"}};Cuba.close_box=function(A){Element.hide(A+"_body");$("collapse_icon_"+A).src="/aurita/images/icons/plus.gif"};Poll_Editor={option_counter:0,option_amount:0,add_option:function(){Poll_Editor.option_counter++;Poll_Editor.option_amount++;field=document.createElement("span");field.id="poll_option_entry_"+Poll_Editor.option_counter;field.innerHTML='<input style="margin-top: 2px; " type="text" class="lore" name="poll_option_'+Poll_Editor.option_counter+'" /><span onclick="Poll_Editor.remove_option('+Poll_Editor.option_counter+');" class="lore_text_button" style="height: 19px; ">-</span> <br />';$("poll_options").appendChild(field);if(Poll_Editor.option_amount>=2){Element.setStyle("poll_editor_submit_button",{display:""})}if(Poll_Editor.option_amount>10){Element.setStyle("poll_editor_add_option_button",{display:"none"})}$("poll_editor_max_option_index").value=Poll_Editor.option_counter},remove_option:function(A){Poll_Editor.option_amount--;$("poll_option_entry_"+A).innerHTML="";if(Poll_Editor.option_amount<2){Element.setStyle("poll_editor_submit_button",{display:"none"})}if(Poll_Editor.option_amount<=10){Element.setStyle("poll_editor_add_option_button",{display:""})}}};Calendar=function(D,C,J,A){this.activeDiv=null;this.currentDateEl=null;this.getDateStatus=null;this.getDateToolTip=null;this.getDateText=null;this.timeout=null;this.onSelected=J||null;this.onClose=A||null;this.dragging=false;this.hidden=false;this.minYear=1970;this.maxYear=2050;this.dateFormat=Calendar._TT.DEF_DATE_FORMAT;this.ttDateFormat=Calendar._TT.TT_DATE_FORMAT;this.isPopup=true;this.weekNumbers=true;this.firstDayOfWeek=typeof D=="number"?D:Calendar._FD;this.showsOtherMonths=false;this.dateStr=C;this.ar_days=null;this.showsTime=false;this.time24=true;this.yearStep=2;this.hiliteToday=true;this.multiple=null;this.table=null;this.element=null;this.tbody=null;this.firstdayname=null;this.monthsCombo=null;this.yearsCombo=null;this.hilitedMonth=null;this.activeMonth=null;this.hilitedYear=null;this.activeYear=null;this.dateClicked=false;if(typeof Calendar._SDN=="undefined"){if(typeof Calendar._SDN_len=="undefined"){Calendar._SDN_len=3}var B=new Array();for(var E=8;E>0;){B[--E]=Calendar._DN[E].substr(0,Calendar._SDN_len)}Calendar._SDN=B;if(typeof Calendar._SMN_len=="undefined"){Calendar._SMN_len=3}B=new Array();for(var E=12;E>0;){B[--E]=Calendar._MN[E].substr(0,Calendar._SMN_len)}Calendar._SMN=B}};Calendar._C=null;Calendar.is_ie=(/msie/i.test(navigator.userAgent)&&!/opera/i.test(navigator.userAgent));Calendar.is_ie5=(Calendar.is_ie&&/msie 5\.0/i.test(navigator.userAgent));Calendar.is_opera=/opera/i.test(navigator.userAgent);Calendar.is_khtml=/Konqueror|Safari|KHTML/i.test(navigator.userAgent);Calendar.getAbsolutePos=function(E){var A=0,D=0;var C=/^div$/i.test(E.tagName);if(C&&E.scrollLeft){A=E.scrollLeft}if(C&&E.scrollTop){D=E.scrollTop}var J={x:E.offsetLeft-A,y:E.offsetTop-D};if(E.offsetParent){var B=this.getAbsolutePos(E.offsetParent);J.x+=B.x;J.y+=B.y}return J};Calendar.isRelated=function(C,A){var D=A.relatedTarget;if(!D){var B=A.type;if(B=="mouseover"){D=A.fromElement}else{if(B=="mouseout"){D=A.toElement}}}while(D){if(D==C){return true}D=D.parentNode}return false};Calendar.removeClass=function(E,D){if(!(E&&E.className)){return }var A=E.className.split(" ");var B=new Array();for(var C=A.length;C>0;){if(A[--C]!=D){B[B.length]=A[C]}}E.className=B.join(" ")};Calendar.addClass=function(B,A){Calendar.removeClass(B,A);B.className+=" "+A};Calendar.getElement=function(A){var B=Calendar.is_ie?window.event.srcElement:A.currentTarget;while(B.nodeType!=1||/^div$/i.test(B.tagName)){B=B.parentNode}return B};Calendar.getTargetElement=function(A){var B=Calendar.is_ie?window.event.srcElement:A.target;while(B.nodeType!=1){B=B.parentNode}return B};Calendar.stopEvent=function(A){A||(A=window.event);if(Calendar.is_ie){A.cancelBubble=true;A.returnValue=false}else{A.preventDefault();A.stopPropagation()}return false};Calendar.addEvent=function(A,C,B){if(A.attachEvent){A.attachEvent("on"+C,B)}else{if(A.addEventListener){A.addEventListener(C,B,true)}else{A["on"+C]=B}}};Calendar.removeEvent=function(A,C,B){if(A.detachEvent){A.detachEvent("on"+C,B)}else{if(A.removeEventListener){A.removeEventListener(C,B,true)}else{A["on"+C]=null}}};Calendar.createElement=function(C,B){var A=null;if(document.createElementNS){A=document.createElementNS("http://www.w3.org/1999/xhtml",C)}else{A=document.createElement(C)}if(typeof B!="undefined"){B.appendChild(A)}return A};Calendar._add_evs=function(el){with(Calendar){addEvent(el,"mouseover",dayMouseOver);addEvent(el,"mousedown",dayMouseDown);addEvent(el,"mouseout",dayMouseOut);if(is_ie){addEvent(el,"dblclick",dayMouseDblClick);el.setAttribute("unselectable",true)}}};Calendar.findMonth=function(A){if(typeof A.month!="undefined"){return A}else{if(typeof A.parentNode.month!="undefined"){return A.parentNode}}return null};Calendar.findYear=function(A){if(typeof A.year!="undefined"){return A}else{if(typeof A.parentNode.year!="undefined"){return A.parentNode}}return null};Calendar.showMonthsCombo=function(){var E=Calendar._C;if(!E){return false}var E=E;var J=E.activeDiv;var D=E.monthsCombo;if(E.hilitedMonth){Calendar.removeClass(E.hilitedMonth,"hilite")}if(E.activeMonth){Calendar.removeClass(E.activeMonth,"active")}var C=E.monthsCombo.getElementsByTagName("div")[E.date.getMonth()];Calendar.addClass(C,"active");E.activeMonth=C;var B=D.style;B.display="block";if(J.navtype<0){B.left=J.offsetLeft+"px"}else{var A=D.offsetWidth;if(typeof A=="undefined"){A=50}B.left=(J.offsetLeft+J.offsetWidth-A)+"px"}B.top=(J.offsetTop+J.offsetHeight)+"px"};Calendar.showYearsCombo=function(D){var A=Calendar._C;if(!A){return false}var A=A;var C=A.activeDiv;var J=A.yearsCombo;if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}if(A.activeYear){Calendar.removeClass(A.activeYear,"active")}A.activeYear=null;var B=A.date.getFullYear()+(D?1:-1);var M=J.firstChild;var L=false;for(var E=12;E>0;--E){if(B>=A.minYear&&B<=A.maxYear){M.innerHTML=B;M.year=B;M.style.display="block";L=true}else{M.style.display="none"}M=M.nextSibling;B+=D?A.yearStep:-A.yearStep}if(L){var N=J.style;N.display="block";if(C.navtype<0){N.left=C.offsetLeft+"px"}else{var K=J.offsetWidth;if(typeof K=="undefined"){K=50}N.left=(C.offsetLeft+C.offsetWidth-K)+"px"}N.top=(C.offsetTop+C.offsetHeight)+"px"}};Calendar.tableMouseUp=function(ev){var cal=Calendar._C;if(!cal){return false}if(cal.timeout){clearTimeout(cal.timeout)}var el=cal.activeDiv;if(!el){return false}var target=Calendar.getTargetElement(ev);ev||(ev=window.event);Calendar.removeClass(el,"active");if(target==el||target.parentNode==el){Calendar.cellClick(el,ev)}var mon=Calendar.findMonth(target);var date=null;if(mon){date=new Date(cal.date);if(mon.month!=date.getMonth()){date.setMonth(mon.month);cal.setDate(date);cal.dateClicked=false;cal.callHandler()}}else{var year=Calendar.findYear(target);if(year){date=new Date(cal.date);if(year.year!=date.getFullYear()){date.setFullYear(year.year);cal.setDate(date);cal.dateClicked=false;cal.callHandler()}}}with(Calendar){removeEvent(document,"mouseup",tableMouseUp);removeEvent(document,"mouseover",tableMouseOver);removeEvent(document,"mousemove",tableMouseOver);cal._hideCombos();_C=null;return stopEvent(ev)}};Calendar.tableMouseOver=function(Q){var A=Calendar._C;if(!A){return }var C=A.activeDiv;var M=Calendar.getTargetElement(Q);if(M==C||M.parentNode==C){Calendar.addClass(C,"hilite active");Calendar.addClass(C.parentNode,"rowhilite")}else{if(typeof C.navtype=="undefined"||(C.navtype!=50&&(C.navtype==0||Math.abs(C.navtype)>2))){Calendar.removeClass(C,"active")}Calendar.removeClass(C,"hilite");Calendar.removeClass(C.parentNode,"rowhilite")}Q||(Q=window.event);if(C.navtype==50&&M!=C){var P=Calendar.getAbsolutePos(C);var S=C.offsetWidth;var R=Q.clientX;var T;var O=true;if(R>P.x+S){T=R-P.x-S;O=false}else{T=P.x-R}if(T<0){T=0}var J=C._range;var L=C._current;var K=Math.floor(T/10)%J.length;for(var E=J.length;--E>=0;){if(J[E]==L){break}}while(K-->0){if(O){if(--E<0){E=J.length-1}}else{if(++E>=J.length){E=0}}}var B=J[E];C.innerHTML=B;A.onUpdateTime()}var D=Calendar.findMonth(M);if(D){if(D.month!=A.date.getMonth()){if(A.hilitedMonth){Calendar.removeClass(A.hilitedMonth,"hilite")}Calendar.addClass(D,"hilite");A.hilitedMonth=D}else{if(A.hilitedMonth){Calendar.removeClass(A.hilitedMonth,"hilite")}}}else{if(A.hilitedMonth){Calendar.removeClass(A.hilitedMonth,"hilite")}var N=Calendar.findYear(M);if(N){if(N.year!=A.date.getFullYear()){if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}Calendar.addClass(N,"hilite");A.hilitedYear=N}else{if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}}}else{if(A.hilitedYear){Calendar.removeClass(A.hilitedYear,"hilite")}}}return Calendar.stopEvent(Q)};Calendar.tableMouseDown=function(A){if(Calendar.getTargetElement(A)==Calendar.getElement(A)){return Calendar.stopEvent(A)}};Calendar.calDragIt=function(B){var C=Calendar._C;if(!(C&&C.dragging)){return false}var E;var D;if(Calendar.is_ie){D=window.event.clientY+document.body.scrollTop;E=window.event.clientX+document.body.scrollLeft}else{E=B.pageX;D=B.pageY}C.hideShowCovered();var A=C.element.style;A.left=(E-C.xOffs)+"px";A.top=(D-C.yOffs)+"px";return Calendar.stopEvent(B)};Calendar.calDragEnd=function(ev){var cal=Calendar._C;if(!cal){return false}cal.dragging=false;with(Calendar){removeEvent(document,"mousemove",calDragIt);removeEvent(document,"mouseup",calDragEnd);tableMouseUp(ev)}cal.hideShowCovered()};Calendar.dayMouseDown=function(ev){var el=Calendar.getElement(ev);if(el.disabled){return false}var cal=el.calendar;cal.activeDiv=el;Calendar._C=cal;if(el.navtype!=300){with(Calendar){if(el.navtype==50){el._current=el.innerHTML;addEvent(document,"mousemove",tableMouseOver)}else{addEvent(document,Calendar.is_ie5?"mousemove":"mouseover",tableMouseOver)}addClass(el,"hilite active");addEvent(document,"mouseup",tableMouseUp)}}else{if(cal.isPopup){cal._dragStart(ev)}}if(el.navtype==-1||el.navtype==1){if(cal.timeout){clearTimeout(cal.timeout)}cal.timeout=setTimeout("Calendar.showMonthsCombo()",250)}else{if(el.navtype==-2||el.navtype==2){if(cal.timeout){clearTimeout(cal.timeout)}cal.timeout=setTimeout((el.navtype>0)?"Calendar.showYearsCombo(true)":"Calendar.showYearsCombo(false)",250)}else{cal.timeout=null}}return Calendar.stopEvent(ev)};Calendar.dayMouseDblClick=function(A){Calendar.cellClick(Calendar.getElement(A),A||window.event);if(Calendar.is_ie){document.selection.empty()}};Calendar.dayMouseOver=function(B){var A=Calendar.getElement(B);if(Calendar.isRelated(A,B)||Calendar._C||A.disabled){return false}if(A.ttip){if(A.ttip.substr(0,1)=="_"){A.ttip=A.caldate.print(A.calendar.ttDateFormat)+A.ttip.substr(1)}A.calendar.tooltips.innerHTML=A.ttip}if(A.navtype!=300){Calendar.addClass(A,"hilite");if(A.caldate){Calendar.addClass(A.parentNode,"rowhilite")}}return Calendar.stopEvent(B)};Calendar.dayMouseOut=function(ev){with(Calendar){var el=getElement(ev);if(isRelated(el,ev)||_C||el.disabled){return false}removeClass(el,"hilite");if(el.caldate){removeClass(el.parentNode,"rowhilite")}if(el.calendar){el.calendar.tooltips.innerHTML=_TT.SEL_DATE}return stopEvent(ev)}};Calendar.cellClick=function(E,R){var C=E.calendar;var L=false;var O=false;var J=null;if(typeof E.navtype=="undefined"){if(C.currentDateEl){Calendar.removeClass(C.currentDateEl,"selected");Calendar.addClass(E,"selected");L=(C.currentDateEl==E);if(!L){C.currentDateEl=E}}C.date.setDateOnly(E.caldate);J=C.date;var B=!(C.dateClicked=!E.otherMonth);if(!B&&!C.currentDateEl){C._toggleMultipleDate(new Date(J))}else{O=!E.disabled}if(B){C._init(C.firstDayOfWeek,J)}}else{if(E.navtype==200){Calendar.removeClass(E,"hilite");C.callCloseHandler();return }J=new Date(C.date);if(E.navtype==0){J.setDateOnly(new Date())}C.dateClicked=false;var Q=J.getFullYear();var K=J.getMonth();function A(U){var V=J.getDate();var T=J.getMonthDays(U);if(V>T){J.setDate(T)}J.setMonth(U)}switch(E.navtype){case 400:Calendar.removeClass(E,"hilite");var S=Calendar._TT.ABOUT;if(typeof S!="undefined"){S+=C.showsTime?Calendar._TT.ABOUT_TIME:""}else{S='Help and about box text is not translated into this language.\nIf you know this language and you feel generous please update\nthe corresponding file in "lang" subdir to match calendar-en.js\nand send it back to <mihai_bazon@yahoo.com> to get it into the distribution  ;-)\n\nThank you!\nhttp://dynarch.com/mishoo/calendar.epl\n'}alert(S);return ;case -2:if(Q>C.minYear){J.setFullYear(Q-1)}break;case -1:if(K>0){A(K-1)}else{if(Q-->C.minYear){J.setFullYear(Q);A(11)}}break;case 1:if(K<11){A(K+1)}else{if(Q<C.maxYear){J.setFullYear(Q+1);A(0)}}break;case 2:if(Q<C.maxYear){J.setFullYear(Q+1)}break;case 100:C.setFirstDayOfWeek(E.fdow);return ;case 50:var N=E._range;var P=E.innerHTML;for(var M=N.length;--M>=0;){if(N[M]==P){break}}if(R&&R.shiftKey){if(--M<0){M=N.length-1}}else{if(++M>=N.length){M=0}}var D=N[M];E.innerHTML=D;C.onUpdateTime();return ;case 0:if((typeof C.getDateStatus=="function")&&C.getDateStatus(J,J.getFullYear(),J.getMonth(),J.getDate())){return false}break}if(!J.equalsTo(C.date)){C.setDate(J);O=true}else{if(E.navtype==0){O=L=true}}}if(O){R&&C.callHandler()}if(L){Calendar.removeClass(E,"hilite");R&&C.callCloseHandler()}};Calendar.prototype.create=function(P){var O=null;if(!P){O=document.getElementsByTagName("body")[0];this.isPopup=true}else{O=P;this.isPopup=false}this.date=this.dateStr?new Date(this.dateStr):new Date();var S=Calendar.createElement("table");this.table=S;S.cellSpacing=0;S.cellPadding=0;S.calendar=this;Calendar.addEvent(S,"mousedown",Calendar.tableMouseDown);var A=Calendar.createElement("div");this.element=A;A.className="calendar";if(this.isPopup){A.style.position="absolute";A.style.display="none"}A.appendChild(S);var M=Calendar.createElement("thead",S);var Q=null;var T=null;var B=this;var E=function(W,V,U){Q=Calendar.createElement("td",T);Q.colSpan=V;Q.className="button";if(U!=0&&Math.abs(U)<=2){Q.className+=" nav"}Calendar._add_evs(Q);Q.calendar=B;Q.navtype=U;Q.innerHTML="<div unselectable='on'>"+W+"</div>";return Q};T=Calendar.createElement("tr",M);var C=6;(this.isPopup)&&--C;(this.weekNumbers)&&++C;E("?",1,400).ttip=Calendar._TT.INFO;this.title=E("",C,300);this.title.className="title";if(this.isPopup){this.title.ttip=Calendar._TT.DRAG_TO_MOVE;this.title.style.cursor="move";E("&#x00d7;",1,200).ttip=Calendar._TT.CLOSE}T=Calendar.createElement("tr",M);T.className="headrow";this._nav_py=E("&#x00ab;",1,-2);this._nav_py.ttip=Calendar._TT.PREV_YEAR;this._nav_pm=E("&#x2039;",1,-1);this._nav_pm.ttip=Calendar._TT.PREV_MONTH;this._nav_now=E(Calendar._TT.TODAY,this.weekNumbers?4:3,0);this._nav_now.ttip=Calendar._TT.GO_TODAY;this._nav_nm=E("&#x203a;",1,1);this._nav_nm.ttip=Calendar._TT.NEXT_MONTH;this._nav_ny=E("&#x00bb;",1,2);this._nav_ny.ttip=Calendar._TT.NEXT_YEAR;T=Calendar.createElement("tr",M);T.className="daynames";if(this.weekNumbers){Q=Calendar.createElement("td",T);Q.className="name wn";Q.innerHTML=Calendar._TT.WK}for(var L=7;L>0;--L){Q=Calendar.createElement("td",T);if(!L){Q.navtype=100;Q.calendar=this;Calendar._add_evs(Q)}}this.firstdayname=(this.weekNumbers)?T.firstChild.nextSibling:T.firstChild;this._displayWeekdays();var K=Calendar.createElement("tbody",S);this.tbody=K;for(L=6;L>0;--L){T=Calendar.createElement("tr",K);if(this.weekNumbers){Q=Calendar.createElement("td",T)}for(var J=7;J>0;--J){Q=Calendar.createElement("td",T);Q.calendar=this;Calendar._add_evs(Q)}}if(this.showsTime){T=Calendar.createElement("tr",K);T.className="time";Q=Calendar.createElement("td",T);Q.className="time";Q.colSpan=2;Q.innerHTML=Calendar._TT.TIME||"&nbsp;";Q=Calendar.createElement("td",T);Q.className="time";Q.colSpan=this.weekNumbers?4:3;(function(){function X(k,n,l,o){var f=Calendar.createElement("span",Q);f.className=k;f.innerHTML=n;f.calendar=B;f.ttip=Calendar._TT.TIME_PART;f.navtype=50;f._range=[];if(typeof l!="number"){f._range=l}else{for(var g=l;g<=o;++g){var e;if(g<10&&o>=10){e="0"+g}else{e=""+g}f._range[f._range.length]=e}}Calendar._add_evs(f);return f}var c=B.date.getHours();var U=B.date.getMinutes();var d=!B.time24;var V=(c>12);if(d&&V){c-=12}var Z=X("hour",c,d?1:0,d?12:23);var Y=Calendar.createElement("span",Q);Y.innerHTML=":";Y.className="colon";var W=X("minute",U,0,59);var a=null;Q=Calendar.createElement("td",T);Q.className="time";Q.colSpan=2;if(d){a=X("ampm",V?"pm":"am",["am","pm"])}else{Q.innerHTML="&nbsp;"}B.onSetTime=function(){var f,e=this.date.getHours(),g=this.date.getMinutes();if(d){f=(e>=12);if(f){e-=12}if(e==0){e=12}a.innerHTML=f?"pm":"am"}Z.innerHTML=(e<10)?("0"+e):e;W.innerHTML=(g<10)?("0"+g):g};B.onUpdateTime=function(){var f=this.date;var g=parseInt(Z.innerHTML,10);if(d){if(/pm/i.test(a.innerHTML)&&g<12){g+=12}else{if(/am/i.test(a.innerHTML)&&g==12){g=0}}}var k=f.getDate();var e=f.getMonth();var l=f.getFullYear();f.setHours(g);f.setMinutes(parseInt(W.innerHTML,10));f.setFullYear(l);f.setMonth(e);f.setDate(k);this.dateClicked=false;this.callHandler()}})()}else{this.onSetTime=this.onUpdateTime=function(){}}var N=Calendar.createElement("tfoot",S);T=Calendar.createElement("tr",N);T.className="footrow";Q=E(Calendar._TT.SEL_DATE,this.weekNumbers?8:7,300);Q.className="ttip";if(this.isPopup){Q.ttip=Calendar._TT.DRAG_TO_MOVE;Q.style.cursor="move"}this.tooltips=Q;A=Calendar.createElement("div",this.element);this.monthsCombo=A;A.className="combo";for(L=0;L<Calendar._MN.length;++L){var D=Calendar.createElement("div");D.className=Calendar.is_ie?"label-IEfix":"label";D.month=L;D.innerHTML=Calendar._SMN[L];A.appendChild(D)}A=Calendar.createElement("div",this.element);this.yearsCombo=A;A.className="combo";for(L=12;L>0;--L){var R=Calendar.createElement("div");R.className=Calendar.is_ie?"label-IEfix":"label";A.appendChild(R)}this._init(this.firstDayOfWeek,this.date);O.appendChild(this.element)};Calendar._keyEvent=function(P){var A=window._dynarch_popupCalendar;if(!A||A.multiple){return false}(Calendar.is_ie)&&(P=window.event);var N=(Calendar.is_ie||P.type=="keypress"),Q=P.keyCode;if(P.ctrlKey){switch(Q){case 37:N&&Calendar.cellClick(A._nav_pm);break;case 38:N&&Calendar.cellClick(A._nav_py);break;case 39:N&&Calendar.cellClick(A._nav_nm);break;case 40:N&&Calendar.cellClick(A._nav_ny);break;default:return false}}else{switch(Q){case 32:Calendar.cellClick(A._nav_now);break;case 27:N&&A.callCloseHandler();break;case 37:case 38:case 39:case 40:if(N){var E,R,O,L,C,D;E=Q==37||Q==38;D=(Q==37||Q==39)?1:7;function B(){C=A.currentDateEl;var K=C.pos;R=K&15;O=K>>4;L=A.ar_days[O][R]}B();function J(){var K=new Date(A.date);K.setDate(K.getDate()-D);A.setDate(K)}function M(){var K=new Date(A.date);K.setDate(K.getDate()+D);A.setDate(K)}while(1){switch(Q){case 37:if(--R>=0){L=A.ar_days[O][R]}else{R=6;Q=38;continue}break;case 38:if(--O>=0){L=A.ar_days[O][R]}else{J();B()}break;case 39:if(++R<7){L=A.ar_days[O][R]}else{R=0;Q=40;continue}break;case 40:if(++O<A.ar_days.length){L=A.ar_days[O][R]}else{M();B()}break}break}if(L){if(!L.disabled){Calendar.cellClick(L)}else{if(E){J()}else{M()}}}}break;case 13:if(N){Calendar.cellClick(A.currentDateEl,P)}break;default:return false}}return Calendar.stopEvent(P)};Calendar.prototype._init=function(P,Z){var Y=new Date(),T=Y.getFullYear(),c=Y.getMonth(),B=Y.getDate();this.table.style.visibility="hidden";var L=Z.getFullYear();if(L<this.minYear){L=this.minYear;Z.setFullYear(L)}else{if(L>this.maxYear){L=this.maxYear;Z.setFullYear(L)}}this.firstDayOfWeek=P;this.date=new Date(Z);var a=Z.getMonth();var e=Z.getDate();var d=Z.getMonthDays();Z.setDate(1);var U=(Z.getDay()-this.firstDayOfWeek)%7;if(U<0){U+=7}Z.setDate(-U);Z.setDate(Z.getDate()+1);var E=this.tbody.firstChild;var N=Calendar._SMN[a];var R=this.ar_days=new Array();var Q=Calendar._TT.WEEKEND;var D=this.multiple?(this.datesCells={}):null;for(var W=0;W<6;++W,E=E.nextSibling){var A=E.firstChild;if(this.weekNumbers){A.className="day wn";A.innerHTML=Z.getWeekNumber();A=A.nextSibling}E.className="daysrow";var X=false,J,C=R[W]=[];for(var V=0;V<7;++V,A=A.nextSibling,Z.setDate(J+1)){J=Z.getDate();var K=Z.getDay();A.className="day";A.pos=W<<4|V;C[V]=A;var O=(Z.getMonth()==a);if(!O){if(this.showsOtherMonths){A.className+=" othermonth";A.otherMonth=true}else{A.className="emptycell";A.innerHTML="&nbsp;";A.disabled=true;continue}}else{A.otherMonth=false;X=true}A.disabled=false;A.innerHTML=this.getDateText?this.getDateText(Z,J):J;if(D){D[Z.print("%Y%m%d")]=A}if(this.getDateStatus){var S=this.getDateStatus(Z,L,a,J);if(this.getDateToolTip){var M=this.getDateToolTip(Z,L,a,J);if(M){A.title=M}}if(S===true){A.className+=" disabled";A.disabled=true}else{if(/disabled/i.test(S)){A.disabled=true}A.className+=" "+S}}if(!A.disabled){A.caldate=new Date(Z);A.ttip="_";if(!this.multiple&&O&&J==e&&this.hiliteToday){A.className+=" selected";this.currentDateEl=A}if(Z.getFullYear()==T&&Z.getMonth()==c&&J==B){A.className+=" today";A.ttip+=Calendar._TT.PART_TODAY}if(Q.indexOf(K.toString())!=-1){A.className+=A.otherMonth?" oweekend":" weekend"}}}if(!(X||this.showsOtherMonths)){E.className="emptyrow"}}this.title.innerHTML=Calendar._MN[a]+", "+L;this.onSetTime();this.table.style.visibility="visible";this._initMultipleDates()};Calendar.prototype._initMultipleDates=function(){if(this.multiple){for(var B in this.multiple){var A=this.datesCells[B];var C=this.multiple[B];if(!C){continue}if(A){A.className+=" selected"}}}};Calendar.prototype._toggleMultipleDate=function(B){if(this.multiple){var C=B.print("%Y%m%d");var A=this.datesCells[C];if(A){var D=this.multiple[C];if(!D){Calendar.addClass(A,"selected");this.multiple[C]=B}else{Calendar.removeClass(A,"selected");delete this.multiple[C]}}}};Calendar.prototype.setDateToolTipHandler=function(A){this.getDateToolTip=A};Calendar.prototype.setDate=function(A){if(!A.equalsTo(this.date)){this._init(this.firstDayOfWeek,A)}};Calendar.prototype.refresh=function(){this._init(this.firstDayOfWeek,this.date)};Calendar.prototype.setFirstDayOfWeek=function(A){this._init(A,this.date);this._displayWeekdays()};Calendar.prototype.setDateStatusHandler=Calendar.prototype.setDisabledHandler=function(A){this.getDateStatus=A};Calendar.prototype.setRange=function(A,B){this.minYear=A;this.maxYear=B};Calendar.prototype.callHandler=function(){if(this.onSelected){this.onSelected(this,this.date.print(this.dateFormat))}};Calendar.prototype.callCloseHandler=function(){if(this.onClose){this.onClose(this)}this.hideShowCovered()};Calendar.prototype.destroy=function(){var A=this.element.parentNode;A.removeChild(this.element);Calendar._C=null;window._dynarch_popupCalendar=null};Calendar.prototype.reparent=function(B){var A=this.element;A.parentNode.removeChild(A);B.appendChild(A)};Calendar._checkCalendar=function(B){var C=window._dynarch_popupCalendar;if(!C){return false}var A=Calendar.is_ie?Calendar.getElement(B):Calendar.getTargetElement(B);for(;A!=null&&A!=C.element;A=A.parentNode){}if(A==null){window._dynarch_popupCalendar.callCloseHandler();return Calendar.stopEvent(B)}};Calendar.prototype.show=function(){var E=this.table.getElementsByTagName("tr");for(var D=E.length;D>0;){var J=E[--D];Calendar.removeClass(J,"rowhilite");var C=J.getElementsByTagName("td");for(var B=C.length;B>0;){var A=C[--B];Calendar.removeClass(A,"hilite");Calendar.removeClass(A,"active")}}this.element.style.display="block";this.hidden=false;if(this.isPopup){window._dynarch_popupCalendar=this;Calendar.addEvent(document,"keydown",Calendar._keyEvent);Calendar.addEvent(document,"keypress",Calendar._keyEvent);Calendar.addEvent(document,"mousedown",Calendar._checkCalendar)}this.hideShowCovered()};Calendar.prototype.hide=function(){if(this.isPopup){Calendar.removeEvent(document,"keydown",Calendar._keyEvent);Calendar.removeEvent(document,"keypress",Calendar._keyEvent);Calendar.removeEvent(document,"mousedown",Calendar._checkCalendar)}this.element.style.display="none";this.hidden=true;this.hideShowCovered()};Calendar.prototype.showAt=function(A,C){var B=this.element.style;B.left=A+"px";B.top=C+"px";this.show()};Calendar.prototype.showAtElement=function(C,D){var A=this;var E=Calendar.getAbsolutePos(C);if(!D||typeof D!="string"){this.showAt(E.x,E.y+C.offsetHeight);return true}function B(M){if(M.x<0){M.x=0}if(M.y<0){M.y=0}var N=document.createElement("div");var L=N.style;L.position="absolute";L.right=L.bottom=L.width=L.height="0px";document.body.appendChild(N);var K=Calendar.getAbsolutePos(N);document.body.removeChild(N);if(Calendar.is_ie){K.y+=document.body.scrollTop;K.x+=document.body.scrollLeft}else{K.y+=window.scrollY;K.x+=window.scrollX}var J=M.x+M.width-K.x;if(J>0){M.x-=J}J=M.y+M.height-K.y;if(J>0){M.y-=J}}this.element.style.display="block";Calendar.continuation_for_the_fucking_khtml_browser=function(){var J=A.element.offsetWidth;var L=A.element.offsetHeight;A.element.style.display="none";var K=D.substr(0,1);var M="l";if(D.length>1){M=D.substr(1,1)}switch(K){case"T":E.y-=L;break;case"B":E.y+=C.offsetHeight;break;case"C":E.y+=(C.offsetHeight-L)/2;break;case"t":E.y+=C.offsetHeight-L;break;case"b":break}switch(M){case"L":E.x-=J;break;case"R":E.x+=C.offsetWidth;break;case"C":E.x+=(C.offsetWidth-J)/2;break;case"l":E.x+=C.offsetWidth-J;break;case"r":break}E.width=J;E.height=L+40;A.monthsCombo.style.display="none";B(E);A.showAt(E.x,E.y)};if(Calendar.is_khtml){setTimeout("Calendar.continuation_for_the_fucking_khtml_browser()",10)}else{Calendar.continuation_for_the_fucking_khtml_browser()}};Calendar.prototype.setDateFormat=function(A){this.dateFormat=A};Calendar.prototype.setTtDateFormat=function(A){this.ttDateFormat=A};Calendar.prototype.parseDate=function(B,A){if(!A){A=this.dateFormat}this.setDate(Date.parseDate(B,A))};Calendar.prototype.hideShowCovered=function(){if(!Calendar.is_ie&&!Calendar.is_opera){return }function B(V){var U=V.style.visibility;if(!U){if(document.defaultView&&typeof (document.defaultView.getComputedStyle)=="function"){if(!Calendar.is_khtml){U=document.defaultView.getComputedStyle(V,"").getPropertyValue("visibility")}else{U=""}}else{if(V.currentStyle){U=V.currentStyle.visibility}else{U=""}}}return U}var T=new Array("applet","iframe","select");var C=this.element;var A=Calendar.getAbsolutePos(C);var J=A.x;var D=C.offsetWidth+J;var S=A.y;var R=C.offsetHeight+S;for(var L=T.length;L>0;){var K=document.getElementsByTagName(T[--L]);var E=null;for(var N=K.length;N>0;){E=K[--N];A=Calendar.getAbsolutePos(E);var Q=A.x;var P=E.offsetWidth+Q;var O=A.y;var M=E.offsetHeight+O;if(this.hidden||(Q>D)||(P<J)||(O>R)||(M<S)){if(!E.__msh_save_visibility){E.__msh_save_visibility=B(E)}E.style.visibility=E.__msh_save_visibility}else{if(!E.__msh_save_visibility){E.__msh_save_visibility=B(E)}E.style.visibility="hidden"}}}};Calendar.prototype._displayWeekdays=function(){var B=this.firstDayOfWeek;var A=this.firstdayname;var D=Calendar._TT.WEEKEND;for(var C=0;C<7;++C){A.className="day name";var E=(C+B)%7;if(C){A.ttip=Calendar._TT.DAY_FIRST.replace("%s",Calendar._DN[E]);A.navtype=100;A.calendar=this;A.fdow=E;Calendar._add_evs(A)}if(D.indexOf(E.toString())!=-1){Calendar.addClass(A,"weekend")}A.innerHTML=Calendar._SDN[(C+B)%7];A=A.nextSibling}};Calendar.prototype._hideCombos=function(){this.monthsCombo.style.display="none";this.yearsCombo.style.display="none"};Calendar.prototype._dragStart=function(ev){if(this.dragging){return }this.dragging=true;var posX;var posY;if(Calendar.is_ie){posY=window.event.clientY+document.body.scrollTop;posX=window.event.clientX+document.body.scrollLeft}else{posY=ev.clientY+window.scrollY;posX=ev.clientX+window.scrollX}var st=this.element.style;this.xOffs=posX-parseInt(st.left);this.yOffs=posY-parseInt(st.top);with(Calendar){addEvent(document,"mousemove",calDragIt);addEvent(document,"mouseup",calDragEnd)}};Date._MD=new Array(31,28,31,30,31,30,31,31,30,31,30,31);Date.SECOND=1000;Date.MINUTE=60*Date.SECOND;Date.HOUR=60*Date.MINUTE;Date.DAY=24*Date.HOUR;Date.WEEK=7*Date.DAY;Date.parseDate=function(K,A){var L=new Date();var M=0;var B=-1;var J=0;var O=K.split(/\W+/);var N=A.match(/%./g);var E=0,D=0;var P=0;var C=0;for(E=0;E<O.length;++E){if(!O[E]){continue}switch(N[E]){case"%d":case"%e":J=parseInt(O[E],10);break;case"%m":B=parseInt(O[E],10)-1;break;case"%Y":case"%y":M=parseInt(O[E],10);(M<100)&&(M+=(M>29)?1900:2000);break;case"%b":case"%B":for(D=0;D<12;++D){if(Calendar._MN[D].substr(0,O[E].length).toLowerCase()==O[E].toLowerCase()){B=D;break}}break;case"%H":case"%I":case"%k":case"%l":P=parseInt(O[E],10);break;case"%P":case"%p":if(/pm/i.test(O[E])&&P<12){P+=12}else{if(/am/i.test(O[E])&&P>=12){P-=12}}break;case"%M":C=parseInt(O[E],10);break}}if(isNaN(M)){M=L.getFullYear()}if(isNaN(B)){B=L.getMonth()}if(isNaN(J)){J=L.getDate()}if(isNaN(P)){P=L.getHours()}if(isNaN(C)){C=L.getMinutes()}if(M!=0&&B!=-1&&J!=0){return new Date(M,B,J,P,C,0)}M=0;B=-1;J=0;for(E=0;E<O.length;++E){if(O[E].search(/[a-zA-Z]+/)!=-1){var Q=-1;for(D=0;D<12;++D){if(Calendar._MN[D].substr(0,O[E].length).toLowerCase()==O[E].toLowerCase()){Q=D;break}}if(Q!=-1){if(B!=-1){J=B+1}B=Q}}else{if(parseInt(O[E],10)<=12&&B==-1){B=O[E]-1}else{if(parseInt(O[E],10)>31&&M==0){M=parseInt(O[E],10);(M<100)&&(M+=(M>29)?1900:2000)}else{if(J==0){J=O[E]}}}}}if(M==0){M=L.getFullYear()}if(B!=-1&&J!=0){return new Date(M,B,J,P,C,0)}return L};Date.prototype.getMonthDays=function(B){var A=this.getFullYear();if(typeof B=="undefined"){B=this.getMonth()}if(((0==(A%4))&&((0!=(A%100))||(0==(A%400))))&&B==1){return 29}else{return Date._MD[B]}};Date.prototype.getDayOfYear=function(){var A=new Date(this.getFullYear(),this.getMonth(),this.getDate(),0,0,0);var C=new Date(this.getFullYear(),0,0,0,0,0);var B=A-C;return Math.floor(B/Date.DAY)};Date.prototype.getWeekNumber=function(){var C=new Date(this.getFullYear(),this.getMonth(),this.getDate(),0,0,0);var B=C.getDay();C.setDate(C.getDate()-(B+6)%7+3);var A=C.valueOf();C.setMonth(0);C.setDate(4);return Math.round((A-C.valueOf())/(7*86400000))+1};Date.prototype.equalsTo=function(A){return((this.getFullYear()==A.getFullYear())&&(this.getMonth()==A.getMonth())&&(this.getDate()==A.getDate())&&(this.getHours()==A.getHours())&&(this.getMinutes()==A.getMinutes()))};Date.prototype.setDateOnly=function(A){var B=new Date(A);this.setDate(1);this.setFullYear(B.getFullYear());this.setMonth(B.getMonth());this.setDate(B.getDate())};Date.prototype.print=function(M){var A=this.getMonth();var L=this.getDate();var N=this.getFullYear();var P=this.getWeekNumber();var Q=this.getDay();var U={};var R=this.getHours();var B=(R>=12);var J=(B)?(R-12):R;var T=this.getDayOfYear();if(J==0){J=12}var C=this.getMinutes();var K=this.getSeconds();U["%a"]=Calendar._SDN[Q];U["%A"]=Calendar._DN[Q];U["%b"]=Calendar._SMN[A];U["%B"]=Calendar._MN[A];U["%C"]=1+Math.floor(N/100);U["%d"]=(L<10)?("0"+L):L;U["%e"]=L;U["%H"]=(R<10)?("0"+R):R;U["%I"]=(J<10)?("0"+J):J;U["%j"]=(T<100)?((T<10)?("00"+T):("0"+T)):T;U["%k"]=R;U["%l"]=J;U["%m"]=(A<9)?("0"+(1+A)):(1+A);U["%M"]=(C<10)?("0"+C):C;U["%n"]="\n";U["%p"]=B?"PM":"AM";U["%P"]=B?"pm":"am";U["%s"]=Math.floor(this.getTime()/1000);U["%S"]=(K<10)?("0"+K):K;U["%t"]="\t";U["%U"]=U["%W"]=U["%V"]=(P<10)?("0"+P):P;U["%u"]=Q+1;U["%w"]=Q;U["%y"]=(""+N).substr(2,2);U["%Y"]=N;U["%%"]="%";var S=/%./g;if(!Calendar.is_ie5&&!Calendar.is_khtml){return M.replace(S,function(V){return U[V]||V})}var O=M.match(S);for(var E=0;E<O.length;E++){var D=U[O[E]];if(D){S=new RegExp(O[E],"g");M=M.replace(S,D)}}return M};Date.prototype.__msh_oldSetFullYear=Date.prototype.setFullYear;Date.prototype.setFullYear=function(B){var A=new Date(this);A.__msh_oldSetFullYear(B);if(A.getMonth()!=this.getMonth()){this.setDate(28)}this.__msh_oldSetFullYear(B)};window._dynarch_popupCalendar=null;Calendar._DN=new Array("Sonntag","Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag");Calendar._SDN=new Array("So","Mo","Di","Mi","Do","Fr","Sa","So");Calendar._MN=new Array("Januar","Februar","M\u00e4rz","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember");Calendar._SMN=new Array("Jan","Feb","M\u00e4r","Apr","May","Jun","Jul","Aug","Sep","Okt","Nov","Dez");Calendar._TT={};Calendar._TT.INFO="\u00DCber dieses Kalendarmodul";Calendar._TT.ABOUT="DHTML Date/Time Selector\n(c) dynarch.com 2002-2005 / Author: Mihai Bazon\nFor latest version visit: http://www.dynarch.com/projects/calendar/\nDistributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details.\n\nDatum ausw\u00e4hlen:\n- Benutzen Sie die \xab, \xbb Buttons um das Jahr zu w\u00e4hlen\n- Benutzen Sie die "+String.fromCharCode(8249)+", "+String.fromCharCode(8250)+" Buttons um den Monat zu w\u00e4hlen\n- F\u00fcr eine Schnellauswahl halten Sie die Maustaste \u00fcber diesen Buttons fest.";Calendar._TT.ABOUT_TIME="\n\nZeit ausw\u00e4hlen:\n- Klicken Sie auf die Teile der Uhrzeit, um diese zu erh\u00F6hen\n- oder klicken Sie mit festgehaltener Shift-Taste um diese zu verringern\n- oder klicken und festhalten f\u00fcr Schnellauswahl.";Calendar._TT.TOGGLE="Ersten Tag der Woche w\u00e4hlen";Calendar._TT.PREV_YEAR="Voriges Jahr (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.PREV_MONTH="Voriger Monat (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.GO_TODAY="Heute ausw\u00e4hlen";Calendar._TT.NEXT_MONTH="N\u00e4chst. Monat (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.NEXT_YEAR="N\u00e4chst. Jahr (Festhalten f\u00fcr Schnellauswahl)";Calendar._TT.SEL_DATE="Datum ausw\u00e4hlen";Calendar._TT.DRAG_TO_MOVE="Zum Bewegen festhalten";Calendar._TT.PART_TODAY=" (Heute)";Calendar._TT.DAY_FIRST="Woche beginnt mit %s ";Calendar._TT.WEEKEND="0,6";Calendar._TT.CLOSE="Schlie\u00dfen";Calendar._TT.TODAY="Heute";Calendar._TT.TIME_PART="(Shift-)Klick oder Festhalten und Ziehen um den Wert zu \u00e4ndern";Calendar._TT.DEF_DATE_FORMAT="%d.%m.%Y";Calendar._TT.TT_DATE_FORMAT="%a, %b %e";Calendar._TT.WK="wk";Calendar._TT.TIME="Zeit:";Calendar.setup=function(K){function J(L,M){if(typeof K[L]=="undefined"){K[L]=M}}J("inputField",null);J("displayArea",null);J("button",null);J("eventName","click");J("ifFormat","%Y/%m/%d");J("daFormat","%Y/%m/%d");J("singleClick",true);J("disableFunc",null);J("dateStatusFunc",K.disableFunc);J("dateText",null);J("firstDay",null);J("align","Br");J("range",[1900,2999]);J("weekNumbers",true);J("flat",null);J("flatCallback",null);J("onSelect",null);J("onClose",null);J("onUpdate",null);J("date",null);J("showsTime",false);J("timeFormat","24");J("electric",true);J("step",2);J("position",null);J("cache",false);J("showOthers",false);J("multiple",null);var C=["inputField","displayArea","button"];for(var B in C){if(typeof K[C[B]]=="string"){K[C[B]]=document.getElementById(K[C[B]])}}if(!(K.flat||K.multiple||K.inputField||K.displayArea||K.button)){alert("Calendar.setup:\n  Nothing to setup (no fields found).  Please check your code");return false}function A(M){var L=M.params;var N=(M.dateClicked||L.electric);if(N&&L.inputField){L.inputField.value=M.date.print(L.ifFormat);if(typeof L.inputField.onchange=="function"){L.inputField.onchange()}}if(N&&L.displayArea){L.displayArea.innerHTML=M.date.print(L.daFormat)}if(N&&typeof L.onUpdate=="function"){L.onUpdate(M)}if(N&&L.flat){if(typeof L.flatCallback=="function"){L.flatCallback(M)}}if(N&&L.singleClick&&M.dateClicked){M.callCloseHandler()}}if(K.flat!=null){if(typeof K.flat=="string"){K.flat=document.getElementById(K.flat)}if(!K.flat){alert("Calendar.setup:\n  Flat specified but can't find parent.");return false}var E=new Calendar(K.firstDay,K.date,K.onSelect||A);E.showsOtherMonths=K.showOthers;E.showsTime=K.showsTime;E.time24=(K.timeFormat=="24");E.params=K;E.weekNumbers=K.weekNumbers;E.setRange(K.range[0],K.range[1]);E.setDateStatusHandler(K.dateStatusFunc);E.getDateText=K.dateText;if(K.ifFormat){E.setDateFormat(K.ifFormat)}if(K.inputField&&typeof K.inputField.value=="string"){E.parseDate(K.inputField.value)}E.create(K.flat);E.show();return false}var D=K.button||K.displayArea||K.inputField;D["on"+K.eventName]=function(){var L=K.inputField||K.displayArea;var N=K.inputField?K.ifFormat:K.daFormat;var R=false;var P=window.calendar;if(L){K.date=Date.parseDate(L.value||L.innerHTML,N)}if(!(P&&K.cache)){window.calendar=P=new Calendar(K.firstDay,K.date,K.onSelect||A,K.onClose||function(S){S.hide()});P.showsTime=K.showsTime;P.time24=(K.timeFormat=="24");P.weekNumbers=K.weekNumbers;R=true}else{if(K.date){P.setDate(K.date)}P.hide()}if(K.multiple){P.multiple={};for(var M=K.multiple.length;--M>=0;){var Q=K.multiple[M];var O=Q.print("%Y%m%d");P.multiple[O]=Q}}P.showsOtherMonths=K.showOthers;P.yearStep=K.step;P.setRange(K.range[0],K.range[1]);P.params=K;P.setDateStatusHandler(K.dateStatusFunc);P.getDateText=K.dateText;P.setDateFormat(N);if(R){P.create()}P.refresh();if(!K.position){P.showAtElement(K.button||K.displayArea||K.inputField,K.align)}else{P.showAt(K.position[0],K.position[1])}return false};return E};function array(A){for(i=0;i<A;i++){this[i]=0}this.length=A}function integer(A){return A%(4294967295+1)}function shr(B,A){B=integer(B);A=integer(A);if(B-2147483648>=0){B=B%2147483648;B>>=A;B+=1073741824>>(A-1)}else{B>>=A}return B}function shl1(A){A=A%2147483648;if(A&1073741824==1073741824){A-=1073741824;A*=2;A+=2147483648}else{A*=2}return A}function shl(B,A){B=integer(B);A=integer(A);for(var C=0;C<A;C++){B=shl1(B)}return B}function and(B,A){B=integer(B);A=integer(A);var D=(B-2147483648);var C=(A-2147483648);if(D>=0){if(C>=0){return((D&C)+2147483648)}else{return(D&A)}}else{if(C>=0){return(B&C)}else{return(B&A)}}}function or(B,A){B=integer(B);A=integer(A);var D=(B-2147483648);var C=(A-2147483648);if(D>=0){if(C>=0){return((D|C)+2147483648)}else{return((D|A)+2147483648)}}else{if(C>=0){return((B|C)+2147483648)}else{return(B|A)}}}function xor(B,A){B=integer(B);A=integer(A);var D=(B-2147483648);var C=(A-2147483648);if(D>=0){if(C>=0){return(D^C)}else{return((D^A)+2147483648)}}else{if(C>=0){return((B^C)+2147483648)}else{return(B^A)}}}function not(A){A=integer(A);return(4294967295-A)}var state=new array(4);var count=new array(2);count[0]=0;count[1]=0;var buffer=new array(64);var transformBuffer=new array(16);var digestBits=new array(16);var S11=7;var S12=12;var S13=17;var S14=22;var S21=5;var S22=9;var S23=14;var S24=20;var S31=4;var S32=11;var S33=16;var S34=23;var S41=6;var S42=10;var S43=15;var S44=21;function F(A,C,B){return or(and(A,C),and(not(A),B))}function G(A,C,B){return or(and(A,B),and(C,not(B)))}function H(A,C,B){return xor(xor(A,C),B)}function I(A,C,B){return xor(C,or(A,not(B)))}function rotateLeft(A,B){return or(shl(A,B),(shr(A,(32-B))))}function FF(C,B,K,J,A,D,E){C=C+F(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function GG(C,B,K,J,A,D,E){C=C+G(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function HH(C,B,K,J,A,D,E){C=C+H(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function II(C,B,K,J,A,D,E){C=C+I(B,K,J)+A+E;C=rotateLeft(C,D);C=C+B;return C}function transform(D,J){var C=0,B=0,K=0,E=0;var A=transformBuffer;C=state[0];B=state[1];K=state[2];E=state[3];for(i=0;i<16;i++){A[i]=and(D[i*4+J],255);for(j=1;j<4;j++){A[i]+=shl(and(D[i*4+j+J],255),j*8)}}C=FF(C,B,K,E,A[0],S11,3614090360);E=FF(E,C,B,K,A[1],S12,3905402710);K=FF(K,E,C,B,A[2],S13,606105819);B=FF(B,K,E,C,A[3],S14,3250441966);C=FF(C,B,K,E,A[4],S11,4118548399);E=FF(E,C,B,K,A[5],S12,1200080426);K=FF(K,E,C,B,A[6],S13,2821735955);B=FF(B,K,E,C,A[7],S14,4249261313);C=FF(C,B,K,E,A[8],S11,1770035416);E=FF(E,C,B,K,A[9],S12,2336552879);K=FF(K,E,C,B,A[10],S13,4294925233);B=FF(B,K,E,C,A[11],S14,2304563134);C=FF(C,B,K,E,A[12],S11,1804603682);E=FF(E,C,B,K,A[13],S12,4254626195);K=FF(K,E,C,B,A[14],S13,2792965006);B=FF(B,K,E,C,A[15],S14,1236535329);C=GG(C,B,K,E,A[1],S21,4129170786);E=GG(E,C,B,K,A[6],S22,3225465664);K=GG(K,E,C,B,A[11],S23,643717713);B=GG(B,K,E,C,A[0],S24,3921069994);C=GG(C,B,K,E,A[5],S21,3593408605);E=GG(E,C,B,K,A[10],S22,38016083);K=GG(K,E,C,B,A[15],S23,3634488961);B=GG(B,K,E,C,A[4],S24,3889429448);C=GG(C,B,K,E,A[9],S21,568446438);E=GG(E,C,B,K,A[14],S22,3275163606);K=GG(K,E,C,B,A[3],S23,4107603335);B=GG(B,K,E,C,A[8],S24,1163531501);C=GG(C,B,K,E,A[13],S21,2850285829);E=GG(E,C,B,K,A[2],S22,4243563512);K=GG(K,E,C,B,A[7],S23,1735328473);B=GG(B,K,E,C,A[12],S24,2368359562);C=HH(C,B,K,E,A[5],S31,4294588738);E=HH(E,C,B,K,A[8],S32,2272392833);K=HH(K,E,C,B,A[11],S33,1839030562);B=HH(B,K,E,C,A[14],S34,4259657740);C=HH(C,B,K,E,A[1],S31,2763975236);E=HH(E,C,B,K,A[4],S32,1272893353);K=HH(K,E,C,B,A[7],S33,4139469664);B=HH(B,K,E,C,A[10],S34,3200236656);C=HH(C,B,K,E,A[13],S31,681279174);E=HH(E,C,B,K,A[0],S32,3936430074);K=HH(K,E,C,B,A[3],S33,3572445317);B=HH(B,K,E,C,A[6],S34,76029189);C=HH(C,B,K,E,A[9],S31,3654602809);E=HH(E,C,B,K,A[12],S32,3873151461);K=HH(K,E,C,B,A[15],S33,530742520);B=HH(B,K,E,C,A[2],S34,3299628645);C=II(C,B,K,E,A[0],S41,4096336452);E=II(E,C,B,K,A[7],S42,1126891415);K=II(K,E,C,B,A[14],S43,2878612391);B=II(B,K,E,C,A[5],S44,4237533241);C=II(C,B,K,E,A[12],S41,1700485571);E=II(E,C,B,K,A[3],S42,2399980690);K=II(K,E,C,B,A[10],S43,4293915773);B=II(B,K,E,C,A[1],S44,2240044497);C=II(C,B,K,E,A[8],S41,1873313359);E=II(E,C,B,K,A[15],S42,4264355552);K=II(K,E,C,B,A[6],S43,2734768916);B=II(B,K,E,C,A[13],S44,1309151649);C=II(C,B,K,E,A[4],S41,4149444226);E=II(E,C,B,K,A[11],S42,3174756917);K=II(K,E,C,B,A[2],S43,718787259);B=II(B,K,E,C,A[9],S44,3951481745);state[0]+=C;state[1]+=B;state[2]+=K;state[3]+=E}function init(){count[0]=count[1]=0;state[0]=1732584193;state[1]=4023233417;state[2]=2562383102;state[3]=271733878;for(i=0;i<digestBits.length;i++){digestBits[i]=0}}function update(A){var B,C;B=and(shr(count[0],3),63);if(count[0]<4294967295-7){count[0]+=8}else{count[1]++;count[0]-=4294967295+1;count[0]+=8}buffer[B]=and(A,255);if(B>=63){transform(buffer,0)}}function finish(){var D=new array(8);var E;var C=0,B=0,A=0;for(C=0;C<4;C++){D[C]=and(shr(count[0],(C*8)),255)}for(C=0;C<4;C++){D[C+4]=and(shr(count[1],(C*8)),255)}B=and(shr(count[0],3),63);A=(B<56)?(56-B):(120-B);E=new array(64);E[0]=128;for(C=0;C<A;C++){update(E[C])}for(C=0;C<8;C++){update(D[C])}for(C=0;C<4;C++){for(j=0;j<4;j++){digestBits[C*4+j]=and(shr(state[C],(j*8)),255)}}}function hexa(D){var C="0123456789abcdef";var A="";var B=D;for(hexa_i=0;hexa_i<8;hexa_i++){A=C.charAt(Math.abs(B)%16)+A;B=Math.floor(B/16)}return A}var ascii="01234567890123456789012345678901 !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";function MD5(L){var A,J,B,K,E,D,C;init();for(B=0;B<L.length;B++){A=L.charAt(B);update(ascii.lastIndexOf(A))}finish();K=E=D=C=0;for(i=0;i<4;i++){K+=shl(digestBits[15-i],(i*8))}for(i=4;i<8;i++){E+=shl(digestBits[15-i],((i-4)*8))}for(i=8;i<12;i++){D+=shl(digestBits[15-i],((i-8)*8))}for(i=12;i<16;i++){C+=shl(digestBits[15-i],((i-12)*8))}J=hexa(C)+hexa(D)+hexa(E)+hexa(K);return J}function on_data(B,A){log_debug("on_data triggered");A.innerHTML=B.responseText;collapsed_boxes=getCookie("collapsed_boxes");if(collapsed_boxes){collapsed_boxes=collapsed_boxes.split("-");for(b=0;b<collapsed_boxes.length;b++){box_id=collapsed_boxes[b];if($(box_id)){Cuba.close_box(box_id)}}}Effect.Appear(A,{duration:0.5});init_fun=Cuba.element_init_functions[A.id];if(init_fun){init_fun(A)}}function app_load_interfaces(A){log_debug("in app_load_interface "+A);cb__dispatch_interface("app_left_column","/aurita/"+A+"/left",on_data);cb__dispatch_interface("app_main_content","/aurita/"+A+"/main",on_data)}var active_button;function app_load_setup(A){new Effect.Fade("app_left_column",{duration:0.5});new Effect.Fade("app_main_content",{duration:0.5});if(active_button){active_button.className="header_button"}active_button=document.getElementById("button_"+A);active_button.className="header_button_active";setTimeout(function(){app_load_interfaces(A)},550)}tinyMCE.init({plugins:"paste, auritalink, auritacode, table",theme:"advanced",relative_urls:true,valid_elements:"*[*]",extended_valid_elements:"hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",content_css:"/aurita/inc/editor_content.css",editor_css:"/aurita/inc/editor.css",theme_advanced_styles:"Header 1=header1;Header 2=header2;Header 3=header3;Code=code",theme_advanced_toolbar_align:"left",theme_advanced_buttons1:"bold,italic,underline,strikethrough,bullist,numlist,pastetext,unlink,preview,insertdatetime",theme_advanced_buttons1_add:"auritalink,auritacode,table,formatselect",theme_advanced_buttons2:"",theme_advanced_buttons3:"",theme_advanced_toolbar_location:"top",theme_advanced_resizing:true,theme_advanced_resize_horizontal:false});loading=new Image();loading.src="/aurita/images/icons/loading.gif";Cuba.context_menu_draggable=new Draggable("context_menu");new Draggable("dispatcher");Cuba.disable_context_menu_draggable=function(){Cuba.context_menu_draggable.destroy()};Cuba.enable_context_menu_draggable=function(){Cuba.context_menu_draggable=new Draggable("context_menu")};function interval_reload(A,B,C){setInterval(function(){if(!Cuba.update_targets){Cuba.load({element:A,action:B,silently:true})}},C*1000)}Cuba.check_hashvalue();>>>>>>> .r359
>>>>>>> .r362
