
Aurita.Bookmarking = { 

  on_bookmark_reorder : function(container)
  {
      position_values = Sortable.serialize(container.id);
      Aurita.load_silently({ element: 'dispatcher', 
                             method: 'POST', 
                             action: 'Bookmarking::Bookmark/perform_reorder/' + position_values }); 
  }

}; 

