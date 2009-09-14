
function on_bookmark_reorder(container)
{
    position_values = Sortable.serialize(container.id);
    cb__load_interface_silently('dispatcher','/aurita/Bookmarking::Bookmark/perform_reorder/' + position_values); 
}
var reorder_hierarchy_id; 
function on_hierarchy_entry_reorder(entry)
{
    position_values = Sortable.serialize(entry.id);
    Aurita.load_silently({ element: 'dispatcher', 
                           action: 'Hierarchy/perform_reorder/' + position_values + '&hierarchy_id=' + reorder_hierarchy_id }); 
}

