
Aurita.Publish = { 

  onload_page : function(page_id) { 
    Aurita.load({ element: 'background_selection_box_body', 
                  action: 'Publish::Page/background_selection_box_body/page_id='+page_id }); 
    Aurita.load({ element: 'banner_selection_list', 
                  action: 'Advert::Banner/selection_box_body/page_id='+page_id });
    Aurita.load({ element: 'marginal_selection_list', 
                  action: 'Publish::Marginal/selection_box_body/page_id='+page_id });
  }, 

  init_marginal_placement_editor : function(page_id) { 

    try { 
      Sortable.destroy('place_marginal_selection_list'); 
      Sortable.destroy('marginal_placements_left'); 
      Sortable.destroy('marginal_placements_right'); 
    } catch(e) { } 

    Sortable.create('place_marginal_selection_list', { 
      dropOnEmpty: true, 
      handle: 'header', 
      containment: [ 'place_marginal_selection_list', 'marginal_placements_right', 'marginal_placements_left' ] 
    });
    Sortable.create('marginal_placements_left', { 
      dropOnEmpty: true, 
      handle: 'header', 
      onUpdate: function(container) { 
        placements = Sortable.serialize(container.id); 
        Aurita.call({ method: 'POST', 
                      action: 'Publish::Marginal_Placement/perform_add/page_id='+page_id+'&'+placements+'&section=left' });
      }, 
      containment: [ 'place_marginal_selection_list', 'marginal_placements_right', 'marginal_placements_left' ] 
    });
    Sortable.create('marginal_placements_right', { 
      dropOnEmpty: true, 
      handle: 'header', 
      onUpdate: function(container) { 
        placements = Sortable.serialize(container.id); 
        Aurita.call({ method: 'POST', 
                      action: 'Publish::Marginal_Placement/perform_add/page_id='+page_id+'&'+placements+'&section=right' });
      }, 
      containment: [ 'place_marginal_selection_list', 'marginal_placements_right', 'marginal_placements_left' ] 
    });
  }
};



