
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;
SET search_path = public, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

----------------------

CREATE TABLE component_position (
    component_dom_id character varying(40) NOT NULL,
    "position" integer NOT NULL,
    gui_context character varying(40) NOT NULL,
    component_position_id integer NOT NULL,
    user_group_id integer NOT NULL
);

ALTER TABLE public.component_position OWNER TO fuchsto;

CREATE SEQUENCE component_position_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.component_position_id_seq OWNER TO fuchsto;

GRANT ALL ON TABLE component_position TO fuchsto;
GRANT ALL ON TABLE component_position TO cuba;

GRANT ALL ON SEQUENCE component_position_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE component_position_id_seq TO cuba;

----------------------

alter table category add public_writeable boolean default 'f'; 
alter table category add public_readable boolean default 'f'; 
alter table category add registered_writeable boolean default 'f'; 
alter table category add registered_readable boolean default 'f'; 

alter table user_category add read_permission boolean default 'f'; 
alter table user_category add write_permission boolean default 'f'; 

alter table category add versioned boolean default 't'; 

update user_category set read_permission = 't', write_permission = 't'; 
update user_category set read_permission = 't', write_permission = 'f' where readonly = 't'; 

CREATE TABLE media_container (
    media_container_id integer NOT NULL,
    asset_id integer NOT NULL
);
grant all on media_container to cuba; 
CREATE SEQUENCE media_container_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
grant all on media_container_id_seq to cuba; 

CREATE TABLE media_container_entry (
    media_container_entry_id integer NOT NULL,
    media_container_id integer NOT NULL,
    media_asset_id integer NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);
grant all on media_container_entry to cuba; 

CREATE SEQUENCE media_container_entry_id_seq
    START WITH 1000
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;
grant all on media_container_entry_id_seq to cuba; 

alter table asset add concrete_model varchar(200); 
update asset set concrete_model = 'Aurita::Plugins::Wiki::Media_Container' where asset_id in ( select asset_id from media_asset ); 
update asset set concrete_model = 'Aurita::Plugins::Wiki::Text_Asset' where asset_id in ( select asset_id from text_asset ); 
update asset set concrete_model = 'Aurita::Plugins::Todo::Todo_Asset' where asset_id in ( select asset_id from todo_asset ); 
update asset set concrete_model = 'Aurita::Plugins::Form_Generator::Form_Asset' where asset_id in ( select asset_id from form_asset ); 
alter table asset drop version; 
alter table asset drop deleted; 

alter table container add asset_id_child integer; 
alter table container drop constraint container_id; 
alter table container alter content_id_child drop not null; 
alter table container add primary key container_id ( content_id_parent, asset_id_child ); 

-- create sequence container_id_seq start with 100 increment by 1; 
-- grant all on container_id_seq to cuba; 
-- alter table container add container_id integer not null; 
-- update container set container_id = nextval('public.container_id_seq'::text); 

create language plpgsql; 

create or replace function update_container() returns integer as $$
declare 
  cnt integer; 
  co RECORD; 
begin
  cnt := 0; 
  for co in select * from container join asset on ( asset.content_id = container.content_id_child ) loop
    cnt := cnt+1; 
    update container set asset_id_child = co.asset_id::integer where container.content_id_child = co.content_id_child; 
  end loop; 
  return cnt; 
end; 
$$ language plpgsql; 

select * from update_container(); 

------------------------------

alter table media_asset_folder alter media_folder_id__parent drop not null; 
insert into media_asset_folder values ( '0', '/', NULL, '0', 'PUBLIC', 'f' ); 
