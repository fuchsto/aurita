
Aurita.Publish = { 

  onload_page : function(page_id) { 
    Aurita.load({ element: 'background_selection_box_body', 
                  action: 'Publish::Page/background_selection_box_body/page_id='+page_id }); 
    Aurita.load({ element: 'banner_selection_list', 
                  action: 'Advert::Banner/page_placements/page_id='+page_id });
  }

};



