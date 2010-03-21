
var Aurita.Stats = { 
  var tracker = false; 
  track_url : function(url) { 
    if(Aurita.Stats.tracker) { 
      Aurita.stats.tracker._trackPageview(url); 
    }
  }
}

