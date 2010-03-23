
Aurita.Stats = { 
  tracker : false, 
  track_url : function(url) { 
    if(Aurita.Stats.tracker) { 
      Aurita.Stats.tracker._trackPageview(url); 
    }
  }
}; 

