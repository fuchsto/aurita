
alter table content add concrete_model varchar(100); 


update content set concrete_model = 'Aurita::Plugins::Calendar::Event' where content_id in ( 
  select content_id from event
); 
update content set concrete_model = 'Aurita::Plugins::Contact::Contact_Person' where content_id in ( 
  select content_id from contact_person
); 
update content set concrete_model = 'Aurita::Plugins::Wiki::Article' where content_id in ( 
  select content_id from article 
); 
update content set concrete_model = 'Aurita::Plugins::Memo::Memo_Article' where content_id in ( 
  select content_id from article where article_id in ( select article_id from memo_article )
); 
update content set concrete_model = 'Aurita::Plugins::Wiki::Media_Asset' where content_id in ( 
  select content_id from asset where asset_id in (select asset_id from media_asset) 
); 
update content set concrete_model = 'Aurita::Plugins::Form_Generator::Form_Asset' where content_id in ( 
  select content_id from asset where asset_id in (select asset_id from form_asset) 
);
update content set concrete_model = 'Aurita::Plugins::Wiki::Text_Asset' where content_id in ( 
  select content_id from asset where asset_id in (select asset_id from text_asset) 
);
update content set concrete_model = 'Aurita::Plugins::Todo::Todo_Asset' where content_id in ( 
  select content_id from asset where asset_id in (select asset_id from todo_asset) 
); 
update content set concrete_model = 'Aurita::Plugins::Todo::Todo_Calculation_Asset' where content_id in ( 
  select content_id from asset where asset_id in (select asset_id from todo_asset where todo_asset_id in ( select todo_asset_id from todo_calculation_asset) ) 
); 
update content set concrete_model = 'Aurita::Plugins::Todo::Todo_Time_Calculation_Asset' where content_id in ( 
  select content_id from asset where asset_id in (select asset_id from todo_asset where todo_asset_id in ( select todo_asset_id from todo_time_calc_asset) ) 
); 

