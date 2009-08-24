
alter table internal.user_profile alter title drop not null; 

create table internal.role_permission ( role_permission_id integer not null, role_id integer not null, name varchar(100), value varchar(500) ); 
create sequence internal.role_permission_id_seq start with 100 increment by 1; 
grant all on internal.role_permission to cuba; 
grant all on internal.role_permission_id_seq to cuba; 

insert into internal.role_permission values ( 1, 100, 'is_admin', 't' ); 

drop table role_permissions;

drop table contact_company; 
drop sequence contact_company_id_seq; 
create table contact_company ( contact_company_id integer not null, company_name integer not null ) ; 
create sequence contact_company_id_seq start with 100 increment by 1; 
grant all on contact_company to cuba; 
grant all on contact_company_id_seq to cuba; 

create table company_person ( company_person_id integer not null,  contact_company_id integer not null, contact_person_id integer not null ); 
create sequence company_person_id_seq start with 100 increment by 1; 
grant all on company_person to cuba; 
grant all on company_person_id_seq to cuba; 

drop table todo_entry_history; 
drop sequence todo_entry_history_id_seq; 
create table todo_entry_history ( todo_entry_history_id integer not null, todo_entry_id integer not null, 
  user_group_id integer not null, message text, action varchar(20) ) ; 
create sequence todo_entry_history_id_seq start with 100 increment by 1; 
grant all on todo_entry_history to cuba; 
grant all on todo_entry_history_id_seq to cuba; 

alter table todo_entry add duration_days integer default 0; 
alter table todo_entry add duration_hours integer default 0; 
alter table todo_entry add deadline date; 
alter table todo_entry add percent_done integer default 0; 

alter table contact_person alter forename drop not null; 

alter table internal.user_profile drop birthday; 
alter table internal.user_profile drop fav_bands; 
alter table internal.user_profile drop hobbies; 
alter table internal.user_profile drop rel_status; 
alter table internal.user_profile drop fav_links; 
alter table internal.user_profile drop nick_myspace; 
alter table internal.user_profile drop nick_lokalisten; 
alter table internal.user_profile drop fav_movies; 
alter table internal.user_profile drop fav_clubs; 

-- -------------------

insert into category values (1, 'Ohne Kategorie', 'f'); 
