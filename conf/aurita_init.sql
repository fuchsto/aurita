--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: internal; Type: SCHEMA; Schema: -; Owner: aurita
--

CREATE SCHEMA internal;


ALTER SCHEMA internal OWNER TO aurita;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: fuchsto
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO fuchsto;

SET search_path = public, pg_catalog;

--
-- Name: access_restriction; Type: DOMAIN; Schema: public; Owner: aurita
--

CREATE DOMAIN access_restriction AS character varying(10)
	CONSTRAINT access_restriction_check CHECK ((((((VALUE)::text = 'PUBLIC'::text) OR ((VALUE)::text = 'PRIVATE'::text)) OR ((VALUE)::text = 'FRIENDS'::text)) OR ((VALUE)::text = 'BY_RBAC'::text)));


ALTER DOMAIN public.access_restriction OWNER TO aurita;

--
-- Name: group_visibility; Type: DOMAIN; Schema: public; Owner: aurita
--

CREATE DOMAIN group_visibility AS character varying(10)
	CONSTRAINT group_visibility_check CHECK (((((VALUE)::text = 'PUBLIC'::text) OR ((VALUE)::text = 'MEMBERS'::text)) OR ((VALUE)::text = 'FRIENDS'::text)));


ALTER DOMAIN public.group_visibility OWNER TO aurita;

--
-- Name: visibility; Type: DOMAIN; Schema: public; Owner: aurita
--

CREATE DOMAIN visibility AS character varying(10)
	CONSTRAINT visibility_check CHECK (((((VALUE)::text = 'PRIVATE'::text) OR ((VALUE)::text = 'PUBLIC'::text)) OR ((VALUE)::text = 'FRIENDS'::text)));


ALTER DOMAIN public.visibility OWNER TO aurita;

--
-- Name: grantall(); Type: FUNCTION; Schema: public; Owner: fuchsto
--

CREATE FUNCTION grantall() RETURNS void
    AS $$
declare
  tn text;
begin 
  for tn in select tablename from pg_tables where tablename not like 'pg_%' and tablename not like 'sql_%' loop
grant all on t to aurita; 
  end loop;
end;$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.grantall() OWNER TO fuchsto;

--
-- Name: irlike(text, text); Type: FUNCTION; Schema: public; Owner: fuchsto
--

CREATE FUNCTION irlike(text, text) RETURNS boolean
    AS $_$select $2 ilike $1$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.irlike(text, text) OWNER TO fuchsto;

--
-- Name: rlike(text, text); Type: FUNCTION; Schema: public; Owner: fuchsto
--

CREATE FUNCTION rlike(text, text) RETURNS boolean
    AS $_$select $2 like $1$_$
    LANGUAGE sql IMMUTABLE STRICT;


ALTER FUNCTION public.rlike(text, text) OWNER TO fuchsto;

--
-- Name: update_container(); Type: FUNCTION; Schema: public; Owner: fuchsto
--

CREATE FUNCTION update_container() RETURNS integer
    AS $$
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
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.update_container() OWNER TO fuchsto;

--
-- Name: update_text_assets(); Type: FUNCTION; Schema: public; Owner: fuchsto
--

CREATE FUNCTION update_text_assets() RETURNS integer
    AS $$
declare 
  ta RECORD; 
  cnt integer; 
begin
  cnt := 0; 
  for ta in select text_asset_id, content_id from text_asset join asset on ( text_asset.asset_id = asset.asset_id ) loop 
    cnt := cnt+1; 
    raise notice '% -> %', ta.text_asset_id, ta.content_id; 
      update text_asset set container_id = ( select container_id from container where container.content_id_child = (ta.content_id::integer) ) where text_asset.text_asset_id = ta.text_asset_id; 
  end loop; 
  return cnt; 
end; 
$$
    LANGUAGE plpgsql;


ALTER FUNCTION public.update_text_assets() OWNER TO fuchsto;

--
-- Name: ~~~; Type: OPERATOR; Schema: public; Owner: fuchsto
--

CREATE OPERATOR ~~~ (
    PROCEDURE = rlike,
    LEFTARG = text,
    RIGHTARG = text,
    COMMUTATOR = ~~
);


ALTER OPERATOR public.~~~ (text, text) OWNER TO fuchsto;

--
-- Name: ~~~~; Type: OPERATOR; Schema: public; Owner: fuchsto
--

CREATE OPERATOR ~~~~ (
    PROCEDURE = irlike,
    LEFTARG = text,
    RIGHTARG = text,
    COMMUTATOR = ~~
);


ALTER OPERATOR public.~~~~ (text, text) OWNER TO fuchsto;

SET search_path = internal, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: group_leader; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE group_leader (
    user_id integer NOT NULL,
    user_group_id integer NOT NULL
);


ALTER TABLE internal.group_leader OWNER TO aurita;

--
-- Name: permission; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE permission (
    permission_id integer NOT NULL,
    role_id integer NOT NULL,
    content_id integer DEFAULT 0 NOT NULL,
    type integer DEFAULT 0 NOT NULL
);


ALTER TABLE internal.permission OWNER TO aurita;

--
-- Name: permission_id_seq; Type: SEQUENCE; Schema: internal; Owner: aurita
--

CREATE SEQUENCE permission_id_seq
    START WITH 100
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE internal.permission_id_seq OWNER TO aurita;

--
-- Name: permission_id_seq; Type: SEQUENCE SET; Schema: internal; Owner: aurita
--

SELECT pg_catalog.setval('permission_id_seq', 100, false);


--
-- Name: role; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE role (
    role_id integer NOT NULL,
    role_name character varying(25) NOT NULL
);


ALTER TABLE internal.role OWNER TO aurita;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: internal; Owner: aurita
--

CREATE SEQUENCE role_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE internal.role_id_seq OWNER TO aurita;

--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: internal; Owner: aurita
--

SELECT pg_catalog.setval('role_id_seq', 112, true);


--
-- Name: role_permission; Type: TABLE; Schema: internal; Owner: fuchsto; Tablespace: 
--

CREATE TABLE role_permission (
    role_permission_id integer NOT NULL,
    role_id integer NOT NULL,
    name character varying(50),
    value character varying(500)
);


ALTER TABLE internal.role_permission OWNER TO fuchsto;

--
-- Name: role_permission_id_seq; Type: SEQUENCE; Schema: internal; Owner: fuchsto
--

CREATE SEQUENCE role_permission_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE internal.role_permission_id_seq OWNER TO fuchsto;

--
-- Name: role_permission_id_seq; Type: SEQUENCE SET; Schema: internal; Owner: fuchsto
--

SELECT pg_catalog.setval('role_permission_id_seq', 1136, true);


--
-- Name: user_group; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE user_group (
    user_group_id integer NOT NULL,
    user_group_name character varying(25) NOT NULL,
    atomic boolean DEFAULT true,
    hidden boolean DEFAULT false NOT NULL,
    division character varying(100) DEFAULT ''::character varying,
    language character varying(3) DEFAULT 'de'::character varying NOT NULL
);


ALTER TABLE internal.user_group OWNER TO aurita;

--
-- Name: user_group_hierarchy; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE user_group_hierarchy (
    user_group_id__parent integer NOT NULL,
    user_group_id__child integer NOT NULL
);


ALTER TABLE internal.user_group_hierarchy OWNER TO aurita;

--
-- Name: user_group_id_seq; Type: SEQUENCE; Schema: internal; Owner: fuchsto
--

CREATE SEQUENCE user_group_id_seq
    START WITH 1001
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE internal.user_group_id_seq OWNER TO fuchsto;

--
-- Name: user_group_id_seq; Type: SEQUENCE SET; Schema: internal; Owner: fuchsto
--

SELECT pg_catalog.setval('user_group_id_seq', 1001, false);


--
-- Name: user_login_data; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE user_login_data (
    login character varying(32) NOT NULL,
    pass character varying(32) NOT NULL,
    user_group_id integer NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    deleted boolean DEFAULT false
);


ALTER TABLE internal.user_login_data OWNER TO aurita;

--
-- Name: user_profile; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE user_profile (
    user_group_id integer NOT NULL,
    forename character varying(50) NOT NULL,
    surname character varying(50) NOT NULL,
    title character varying(10),
    picture_asset_id integer DEFAULT 1,
    phone_office character varying(20),
    phone_home character varying,
    mobile_office character varying,
    mobile_home character varying,
    email_office character varying(255),
    email_home character varying(255),
    tags character varying[],
    hits integer DEFAULT 0 NOT NULL,
    time_registered timestamp without time zone DEFAULT now() NOT NULL,
    gender boolean DEFAULT true NOT NULL,
    location character varying(100),
    about_me text,
    occupation character varying(200) DEFAULT ''::character varying NOT NULL,
    messenger character varying(500) DEFAULT ''::character varying NOT NULL,
    signature text,
    tag_count integer DEFAULT 0 NOT NULL,
    nick_youtube character varying(255) DEFAULT ''::character varying NOT NULL,
    user_profile_config_id integer DEFAULT 0 NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    theme character varying(30) DEFAULT 'default'::character varying
);


ALTER TABLE internal.user_profile OWNER TO aurita;

--
-- Name: user_role; Type: TABLE; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE TABLE user_role (
    user_group_id integer NOT NULL,
    role_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE internal.user_role OWNER TO aurita;

SET search_path = public, pg_catalog;

--
-- Name: archive; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE archive (
    archive_id integer NOT NULL,
    media_asset_id integer NOT NULL,
    archive_run_id integer NOT NULL
);


ALTER TABLE public.archive OWNER TO fuchsto;

--
-- Name: archive_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE archive_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.archive_id_seq OWNER TO fuchsto;

--
-- Name: archive_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('archive_id_seq', 107, true);


--
-- Name: archive_run; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE archive_run (
    archive_run_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    status character varying(15) DEFAULT 'scheduled'::character varying NOT NULL
);


ALTER TABLE public.archive_run OWNER TO fuchsto;

--
-- Name: archive_run_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE archive_run_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.archive_run_id_seq OWNER TO fuchsto;

--
-- Name: archive_run_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('archive_run_id_seq', 119, true);


--
-- Name: article; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE article (
    article_id integer NOT NULL,
    content_id integer NOT NULL,
    template_id integer DEFAULT 0 NOT NULL,
    title character varying(100),
    view_count integer DEFAULT 0 NOT NULL,
    published boolean DEFAULT false NOT NULL,
    header character varying(500)
);


ALTER TABLE public.article OWNER TO aurita;

--
-- Name: article_access; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE article_access (
    article_id integer NOT NULL,
    user_group_id integer NOT NULL,
    changed timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.article_access OWNER TO aurita;

--
-- Name: article_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE article_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 1000
    CACHE 1;


ALTER TABLE public.article_id_seq OWNER TO aurita;

--
-- Name: article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('article_id_seq', 2536, true);


--
-- Name: article_layout; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE article_layout (
    article_layout_id integer NOT NULL,
    layout_name character varying(200),
    columns integer[]
);


ALTER TABLE public.article_layout OWNER TO fuchsto;

--
-- Name: article_layout_asset; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE article_layout_asset (
    article_layout_asset_id integer NOT NULL,
    article_layout_id integer NOT NULL,
    asset_id integer NOT NULL,
    "position" integer NOT NULL
);


ALTER TABLE public.article_layout_asset OWNER TO fuchsto;

--
-- Name: article_layout_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE article_layout_asset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.article_layout_asset_id_seq OWNER TO fuchsto;

--
-- Name: article_layout_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('article_layout_asset_id_seq', 1, false);


--
-- Name: article_layout_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE article_layout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.article_layout_id_seq OWNER TO fuchsto;

--
-- Name: article_layout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('article_layout_id_seq', 1, false);


--
-- Name: article_version; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE article_version (
    article_version_id integer NOT NULL,
    article_id integer NOT NULL,
    version integer NOT NULL,
    user_group_id integer DEFAULT 0 NOT NULL,
    timestamp_created timestamp without time zone DEFAULT now() NOT NULL,
    dump text,
    action_type character varying(20)
);


ALTER TABLE public.article_version OWNER TO fuchsto;

--
-- Name: article_version_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE article_version_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.article_version_id_seq OWNER TO fuchsto;

--
-- Name: article_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('article_version_id_seq', 4879, true);


--
-- Name: asset; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE asset (
    asset_id integer NOT NULL,
    content_id integer NOT NULL,
    concrete_model character varying(200)
);


ALTER TABLE public.asset OWNER TO aurita;

--
-- Name: asset_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 1000
    CACHE 1;


ALTER TABLE public.asset_id_seq OWNER TO aurita;

--
-- Name: asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('asset_id_seq', 6395, true);


--
-- Name: banner_ad; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE banner_ad (
    banner_ad_id integer NOT NULL,
    media_asset_id integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL
);


ALTER TABLE public.banner_ad OWNER TO fuchsto;

--
-- Name: banner_ad_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE banner_ad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.banner_ad_id_seq OWNER TO fuchsto;

--
-- Name: banner_ad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('banner_ad_id_seq', 1, false);


--
-- Name: bookmark; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE bookmark (
    bookmark_id integer NOT NULL,
    user_id integer NOT NULL,
    url character varying(255) DEFAULT '/aurita/#undefined'::character varying NOT NULL,
    tags character varying(50)[] DEFAULT '{bookmark}'::character varying[],
    title character varying(100) NOT NULL,
    type character varying(10) DEFAULT 'EXTERNAL'::character varying,
    bookmark_folder_id integer DEFAULT 0 NOT NULL,
    sortpos integer
);


ALTER TABLE public.bookmark OWNER TO aurita;

--
-- Name: bookmark_folder; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE bookmark_folder (
    bookmark_folder_id integer NOT NULL,
    parent_folder_id integer DEFAULT 0 NOT NULL,
    folder_name character varying(200),
    user_group_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.bookmark_folder OWNER TO fuchsto;

--
-- Name: bookmark_folder_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE bookmark_folder_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.bookmark_folder_id_seq OWNER TO fuchsto;

--
-- Name: bookmark_folder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('bookmark_folder_id_seq', 31, true);


--
-- Name: bookmark_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE bookmark_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.bookmark_id_seq OWNER TO aurita;

--
-- Name: bookmark_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('bookmark_id_seq', 581, true);


--
-- Name: category; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE category (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    is_private boolean DEFAULT false NOT NULL,
    public_writeable boolean DEFAULT false,
    public_readable boolean DEFAULT false,
    registered_writeable boolean DEFAULT false,
    registered_readable boolean DEFAULT false,
    versioned boolean DEFAULT true,
    category_id_parent integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.category OWNER TO aurita;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE category_id_seq
    START WITH 1001
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.category_id_seq OWNER TO aurita;

--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('category_id_seq', 1001, false);


--
-- Name: company_person; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE company_person (
    contact_company_id integer NOT NULL,
    contact_person_id integer NOT NULL
);


ALTER TABLE public.company_person OWNER TO fuchsto;

--
-- Name: component_position; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE component_position (
    component_dom_id character varying(40) NOT NULL,
    "position" integer NOT NULL,
    gui_context character varying(40) NOT NULL,
    component_position_id integer NOT NULL,
    user_group_id integer NOT NULL
);


ALTER TABLE public.component_position OWNER TO fuchsto;

--
-- Name: component_position_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE component_position_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.component_position_id_seq OWNER TO fuchsto;

--
-- Name: component_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('component_position_id_seq', 1134, true);


--
-- Name: contact_company; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE contact_company (
    contact_company_id integer NOT NULL,
    company_name character varying(200),
    email character varying(255),
    website character varying(255),
    comment text
);


ALTER TABLE public.contact_company OWNER TO fuchsto;

--
-- Name: contact_company_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE contact_company_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.contact_company_id_seq OWNER TO fuchsto;

--
-- Name: contact_company_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('contact_company_id_seq', 5, true);


--
-- Name: contact_person; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE contact_person (
    contact_person_id integer NOT NULL,
    content_id integer NOT NULL,
    forename character varying(255),
    surname character varying(255) NOT NULL,
    work_phone character varying(30),
    work_mobile character varying(30),
    home_phone character varying(30),
    home_mobile character varying(30),
    home_email character varying(30),
    comment text,
    city character varying(255),
    zip character(5),
    street character varying(255),
    home_fax character varying(30),
    work_fax character varying(30),
    country character varying(3),
    work_email character varying(255),
    contact_company_id integer
);


ALTER TABLE public.contact_person OWNER TO aurita;

--
-- Name: contact_person_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE contact_person_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.contact_person_id_seq OWNER TO aurita;

--
-- Name: contact_person_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('contact_person_id_seq', 120, true);


--
-- Name: container; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE container (
    content_id_parent integer NOT NULL,
    content_id_child integer,
    sortpos smallint DEFAULT 0 NOT NULL,
    content_type character varying(50) DEFAULT 'content'::text NOT NULL,
    asset_id_child integer
);


ALTER TABLE public.container OWNER TO aurita;

--
-- Name: content; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE content (
    content_id integer NOT NULL,
    user_group_id integer DEFAULT 0 NOT NULL,
    tags character varying(50)[] NOT NULL,
    changed timestamp with time zone DEFAULT now(),
    created timestamp with time zone,
    hits integer DEFAULT 0 NOT NULL,
    locked boolean DEFAULT false,
    deleted boolean DEFAULT false,
    version integer DEFAULT 0 NOT NULL,
    concrete_model character varying(100)
);


ALTER TABLE public.content OWNER TO aurita;

--
-- Name: content_access; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE content_access (
    content_id integer NOT NULL,
    user_group_id integer NOT NULL,
    changed timestamp without time zone DEFAULT now() NOT NULL,
    res_type character varying(20) DEFAULT 'ARTICLE'::character varying NOT NULL
);


ALTER TABLE public.content_access OWNER TO fuchsto;

--
-- Name: content_category; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE content_category (
    content_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.content_category OWNER TO aurita;

--
-- Name: content_comment; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE content_comment (
    content_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    content_comment_id integer NOT NULL,
    user_group_name character varying(100),
    user_group_id integer DEFAULT 0 NOT NULL,
    message character varying(2000)
);


ALTER TABLE public.content_comment OWNER TO aurita;

--
-- Name: content_comment_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE content_comment_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.content_comment_id_seq OWNER TO aurita;

--
-- Name: content_comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('content_comment_id_seq', 342, true);


--
-- Name: content_history; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE content_history (
    content_history_id integer NOT NULL,
    user_group_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    type character varying(100) DEFAULT 'CHANGED'::character varying NOT NULL,
    content_id integer NOT NULL
);


ALTER TABLE public.content_history OWNER TO aurita;

--
-- Name: content_history_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE content_history_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 1000
    CACHE 1;


ALTER TABLE public.content_history_id_seq OWNER TO aurita;

--
-- Name: content_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('content_history_id_seq', 30418, true);


--
-- Name: content_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE content_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 1000
    CACHE 1;


ALTER TABLE public.content_id_seq OWNER TO aurita;

--
-- Name: content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('content_id_seq', 10155, true);


--
-- Name: content_permissions; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE content_permissions (
    content_permissions_id integer NOT NULL,
    content_id integer NOT NULL,
    user_group_id integer NOT NULL,
    readonly boolean DEFAULT false
);


ALTER TABLE public.content_permissions OWNER TO aurita;

--
-- Name: content_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE content_permissions_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.content_permissions_id_seq OWNER TO aurita;

--
-- Name: content_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('content_permissions_id_seq', 90, true);


--
-- Name: content_rating; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE content_rating (
    content_id integer NOT NULL,
    total_ratings integer DEFAULT 0 NOT NULL,
    value numeric DEFAULT 0.0 NOT NULL,
    aspect integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.content_rating OWNER TO aurita;

--
-- Name: content_recommendation; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE content_recommendation (
    content_recommendation_id integer NOT NULL,
    user_group_id_from integer NOT NULL,
    user_group_id integer NOT NULL,
    viewed boolean DEFAULT false NOT NULL,
    content_id integer NOT NULL,
    type character varying(20) NOT NULL,
    message text
);


ALTER TABLE public.content_recommendation OWNER TO aurita;

--
-- Name: content_recommendation_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE content_recommendation_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.content_recommendation_id_seq OWNER TO aurita;

--
-- Name: content_recommendation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('content_recommendation_id_seq', 121, true);


--
-- Name: event; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE event (
    event_id integer NOT NULL,
    date_begin date DEFAULT now() NOT NULL,
    date_end date DEFAULT now() NOT NULL,
    name character varying(300) NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    time_begin time without time zone DEFAULT '00:00:00'::time without time zone NOT NULL,
    time_end time without time zone DEFAULT '24:00:00'::time without time zone NOT NULL,
    max_participants integer DEFAULT 0 NOT NULL,
    visible visibility DEFAULT ('PUBLIC'::character varying)::visibility NOT NULL,
    content_id integer NOT NULL,
    repeat_annual boolean DEFAULT false,
    repeat_weekly integer,
    repeat_monthly integer,
    repeat_monthly_day integer
);


ALTER TABLE public.event OWNER TO aurita;

--
-- Name: event_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE event_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.event_id_seq OWNER TO aurita;

--
-- Name: event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('event_id_seq', 164, true);


--
-- Name: feed_cache_entry; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE feed_cache_entry (
    feed_cache_entry_id integer NOT NULL,
    title text,
    url character varying(255),
    feed_type character varying(10),
    feed_data_type character varying(20),
    etag character varying(255),
    last_modified character varying(100) DEFAULT now(),
    feed_collection_entry_id integer NOT NULL,
    content text
);


ALTER TABLE public.feed_cache_entry OWNER TO aurita;

--
-- Name: feed_cache_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE feed_cache_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.feed_cache_entry_id_seq OWNER TO fuchsto;

--
-- Name: feed_cache_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('feed_cache_entry_id_seq', 7703, true);


--
-- Name: feed_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE feed_cache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.feed_cache_id_seq OWNER TO aurita;

--
-- Name: feed_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('feed_cache_id_seq', 1, false);


--
-- Name: feed_collection; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE feed_collection (
    feed_collection_id integer NOT NULL,
    collection_name character varying(200),
    content_id integer NOT NULL
);


ALTER TABLE public.feed_collection OWNER TO fuchsto;

--
-- Name: feed_collection_entry; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE feed_collection_entry (
    feed_collection_entry_id integer NOT NULL,
    feed_collection_id integer NOT NULL,
    url character varying(255),
    max_entries smallint DEFAULT 20,
    per_page smallint DEFAULT 5,
    title character varying(200)
);


ALTER TABLE public.feed_collection_entry OWNER TO fuchsto;

--
-- Name: feed_collection_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE feed_collection_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.feed_collection_entry_id_seq OWNER TO fuchsto;

--
-- Name: feed_collection_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('feed_collection_entry_id_seq', 112, true);


--
-- Name: feed_collection_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE feed_collection_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.feed_collection_id_seq OWNER TO fuchsto;

--
-- Name: feed_collection_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('feed_collection_id_seq', 106, true);


--
-- Name: flickr_feed_col_entry; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE flickr_feed_col_entry (
    flickr_feed_col_entry_id integer NOT NULL,
    feed_collection_id integer NOT NULL,
    flickr_user character varying(200) NOT NULL,
    media_asset_folder_id integer NOT NULL
);


ALTER TABLE public.flickr_feed_col_entry OWNER TO fuchsto;

--
-- Name: flickr_feed_col_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE flickr_feed_col_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.flickr_feed_col_entry_id_seq OWNER TO fuchsto;

--
-- Name: flickr_feed_col_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('flickr_feed_col_entry_id_seq', 2, true);


--
-- Name: flickr_media_asset; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE flickr_media_asset (
    flickr_media_asset_id integer NOT NULL,
    media_asset_id integer NOT NULL,
    flickr_photo_id character varying(50)
);


ALTER TABLE public.flickr_media_asset OWNER TO fuchsto;

--
-- Name: flickr_media_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE flickr_media_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.flickr_media_asset_id_seq OWNER TO fuchsto;

--
-- Name: flickr_media_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('flickr_media_asset_id_seq', 108, true);


--
-- Name: form_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE form_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.form_asset_id_seq OWNER TO aurita;

--
-- Name: form_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('form_asset_id_seq', 1097, true);


--
-- Name: forum_group_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE forum_group_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.forum_group_id_seq OWNER TO aurita;

--
-- Name: forum_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('forum_group_id_seq', 107, true);


--
-- Name: forum_post_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE forum_post_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.forum_post_id_seq OWNER TO aurita;

--
-- Name: forum_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('forum_post_id_seq', 117, true);


--
-- Name: forum_topic_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE forum_topic_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.forum_topic_id_seq OWNER TO aurita;

--
-- Name: forum_topic_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('forum_topic_id_seq', 104, true);


--
-- Name: hierarchy; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE hierarchy (
    hierarchy_id integer NOT NULL,
    header character varying(25) NOT NULL,
    category character varying(15) DEFAULT 'MYBASE'::text
);


ALTER TABLE public.hierarchy OWNER TO aurita;

--
-- Name: hierarchy_category; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE hierarchy_category (
    hierarchy_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.hierarchy_category OWNER TO fuchsto;

--
-- Name: hierarchy_entry; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE hierarchy_entry (
    hierarchy_entry_id integer NOT NULL,
    hierarchy_id integer NOT NULL,
    interface character varying(255),
    entry_type character varying(10) DEFAULT ''::character varying NOT NULL,
    hierarchy_entry_id_parent integer DEFAULT 0,
    sortpos integer DEFAULT 1 NOT NULL,
    content_id integer,
    label character varying(200)
);


ALTER TABLE public.hierarchy_entry OWNER TO aurita;

--
-- Name: hierarchy_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE hierarchy_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.hierarchy_entry_id_seq OWNER TO aurita;

--
-- Name: hierarchy_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('hierarchy_entry_id_seq', 1257, true);


--
-- Name: hierarchy_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE hierarchy_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.hierarchy_id_seq OWNER TO aurita;

--
-- Name: hierarchy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('hierarchy_id_seq', 1035, true);


--
-- Name: media_asset; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE media_asset (
    media_asset_id integer NOT NULL,
    asset_id integer NOT NULL,
    mime character varying(100) NOT NULL,
    media_folder_id integer DEFAULT 0 NOT NULL,
    description text,
    user_submitted boolean DEFAULT false NOT NULL,
    filesize integer DEFAULT 0 NOT NULL,
    title character varying(300),
    extension character varying(8),
    original_filename character varying(255),
    checksum character varying(32),
    old_id integer
);


ALTER TABLE public.media_asset OWNER TO aurita;

--
-- Name: media_asset_bookmark; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE media_asset_bookmark (
    user_group_id integer NOT NULL,
    media_asset_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.media_asset_bookmark OWNER TO aurita;

--
-- Name: media_asset_download; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE media_asset_download (
    media_asset_download_id integer NOT NULL,
    user_group_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    media_asset_id integer
);


ALTER TABLE public.media_asset_download OWNER TO fuchsto;

--
-- Name: media_asset_download_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE media_asset_download_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.media_asset_download_id_seq OWNER TO fuchsto;

--
-- Name: media_asset_download_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('media_asset_download_id_seq', 785, true);


--
-- Name: media_asset_folder; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE media_asset_folder (
    media_asset_folder_id integer NOT NULL,
    physical_path character varying(255) NOT NULL,
    media_folder_id__parent integer DEFAULT 0,
    user_group_id integer DEFAULT 301 NOT NULL,
    access access_restriction DEFAULT ('PUBLIC'::character varying)::access_restriction NOT NULL,
    trashbin boolean DEFAULT false NOT NULL
);


ALTER TABLE public.media_asset_folder OWNER TO aurita;

--
-- Name: media_asset_folder_category; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE media_asset_folder_category (
    folder_category_id integer NOT NULL,
    media_asset_folder_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.media_asset_folder_category OWNER TO fuchsto;

--
-- Name: media_asset_folder_category_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE media_asset_folder_category_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.media_asset_folder_category_id_seq OWNER TO fuchsto;

--
-- Name: media_asset_folder_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('media_asset_folder_category_id_seq', 1321, true);


--
-- Name: media_asset_folder_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE media_asset_folder_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 300
    CACHE 1;


ALTER TABLE public.media_asset_folder_id_seq OWNER TO aurita;

--
-- Name: media_asset_folder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('media_asset_folder_id_seq', 1026, true);


--
-- Name: media_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE media_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 1000
    CACHE 1;


ALTER TABLE public.media_asset_id_seq OWNER TO aurita;

--
-- Name: media_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('media_asset_id_seq', 2922, true);


--
-- Name: media_asset_version; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE media_asset_version (
    media_asset_version_id integer NOT NULL,
    media_asset_id integer NOT NULL,
    version integer NOT NULL,
    timestamp_created timestamp without time zone DEFAULT now() NOT NULL,
    user_group_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.media_asset_version OWNER TO fuchsto;

--
-- Name: media_asset_version_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE media_asset_version_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.media_asset_version_id_seq OWNER TO fuchsto;

--
-- Name: media_asset_version_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('media_asset_version_id_seq', 1194, true);


--
-- Name: media_container; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE media_container (
    media_container_id integer NOT NULL,
    asset_id integer NOT NULL
);


ALTER TABLE public.media_container OWNER TO fuchsto;

--
-- Name: media_container_entry; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE media_container_entry (
    media_container_entry_id integer NOT NULL,
    media_container_id integer NOT NULL,
    media_asset_id integer NOT NULL,
    "position" integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.media_container_entry OWNER TO fuchsto;

--
-- Name: media_container_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE media_container_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.media_container_entry_id_seq OWNER TO fuchsto;

--
-- Name: media_container_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('media_container_entry_id_seq', 1600, true);


--
-- Name: media_container_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE media_container_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.media_container_id_seq OWNER TO fuchsto;

--
-- Name: media_container_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('media_container_id_seq', 1499, true);


--
-- Name: media_iptc; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE media_iptc (
    media_asset_id integer NOT NULL,
    headline character varying(256),
    caption character varying(2000),
    keywords character varying(64)[],
    by_line character varying(32),
    by_line_title character varying(32),
    copyright character varying(128),
    credit character varying(32),
    contract character varying(128),
    object_name character varying(64),
    date_created character varying(8) DEFAULT '00'::character varying,
    time_created character varying(11),
    digital_creation_date character varying(8),
    digital_creation_time character varying(11),
    city character varying(32),
    sublocation character varying(32),
    province_state character varying(32),
    country_code character varying(3),
    country_name character varying(64),
    special_instructions character varying(256),
    source character varying(32),
    originating_program character varying(32),
    edit_status character varying(64),
    envelope_priority character(1),
    object_cycle character(1),
    original_transmission_ref character varying(32),
    fixture_identifier character varying(32),
    writer character varying(128)
);


ALTER TABLE public.media_iptc OWNER TO fuchsto;

--
-- Name: memo_article; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE memo_article (
    memo_article_id integer NOT NULL,
    article_id integer NOT NULL,
    release_date date DEFAULT now(),
    company character varying(100),
    comment text,
    memo_type integer,
    signature character varying(50)
);


ALTER TABLE public.memo_article OWNER TO fuchsto;

--
-- Name: memo_article_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE memo_article_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.memo_article_id_seq OWNER TO fuchsto;

--
-- Name: memo_article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('memo_article_id_seq', 107, true);


--
-- Name: model_register; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE model_register (
    model_register_id integer NOT NULL,
    fields character varying(100)[] NOT NULL,
    types character varying(50)[] NOT NULL,
    pkeys character varying(100)[] NOT NULL,
    aggregates character varying(50)[] NOT NULL,
    name character varying(50) NOT NULL,
    is_a character varying(100)[]
);


ALTER TABLE public.model_register OWNER TO aurita;

--
-- Name: model_register_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE model_register_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.model_register_id_seq OWNER TO aurita;

--
-- Name: model_register_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('model_register_id_seq', 1055, true);


--
-- Name: movie_voter_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE movie_voter_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.movie_voter_id_seq OWNER TO fuchsto;

--
-- Name: movie_voter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('movie_voter_id_seq', 1479, true);


--
-- Name: movie_voting_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE movie_voting_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.movie_voting_id_seq OWNER TO fuchsto;

--
-- Name: movie_voting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('movie_voting_id_seq', 8829, true);


--
-- Name: page; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE page (
    page_id integer NOT NULL,
    content_id integer NOT NULL,
    title character varying(200)
);


ALTER TABLE public.page OWNER TO fuchsto;

--
-- Name: page_element; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE page_element (
    page_element_id integer NOT NULL,
    content_id integer NOT NULL,
    "position" integer NOT NULL,
    page_id integer NOT NULL
);


ALTER TABLE public.page_element OWNER TO fuchsto;

--
-- Name: page_element_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE page_element_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.page_element_id_seq OWNER TO fuchsto;

--
-- Name: page_element_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('page_element_id_seq', 20, true);


--
-- Name: page_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE page_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.page_id_seq OWNER TO fuchsto;

--
-- Name: page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('page_id_seq', 17, true);


--
-- Name: poll; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE poll (
    poll_id integer NOT NULL,
    time_created timestamp without time zone DEFAULT now() NOT NULL,
    deadline timestamp without time zone,
    title text NOT NULL,
    user_group_id integer NOT NULL,
    options character varying(255)[] NOT NULL
);


ALTER TABLE public.poll OWNER TO fuchsto;

--
-- Name: poll_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE poll_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.poll_id_seq OWNER TO fuchsto;

--
-- Name: poll_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('poll_id_seq', 16, true);


--
-- Name: poll_voting; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE poll_voting (
    poll_voting_id integer NOT NULL,
    poll_id integer NOT NULL,
    user_group_id integer NOT NULL,
    option integer NOT NULL
);


ALTER TABLE public.poll_voting OWNER TO fuchsto;

--
-- Name: poll_voting_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE poll_voting_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.poll_voting_id_seq OWNER TO fuchsto;

--
-- Name: poll_voting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('poll_voting_id_seq', 51, true);


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE role_permissions (
    role_id integer NOT NULL,
    is_super_admin boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    may_upload_files boolean DEFAULT true,
    may_upload_large_files boolean DEFAULT false,
    may_create_forum_groups boolean DEFAULT false,
    may_moderate_foreign_forum_groups boolean DEFAULT false,
    may_publish_articles boolean DEFAULT true,
    may_edit_foreign_articles boolean DEFAULT false,
    may_create_events boolean DEFAULT false,
    may_create_regular_events boolean DEFAULT false,
    may_edit_calendar boolean DEFAULT false,
    may_edit_own_asset_comments boolean DEFAULT true NOT NULL,
    may_edit_foreign_asset_comments boolean DEFAULT false NOT NULL,
    is_developer boolean DEFAULT false,
    may_create_public_folders boolean DEFAULT false NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO aurita;

--
-- Name: shoutbox_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE shoutbox_id_seq
    START WITH 1000
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.shoutbox_id_seq OWNER TO fuchsto;

--
-- Name: shoutbox_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('shoutbox_id_seq', 1000, false);


--
-- Name: tag_blacklist; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE tag_blacklist (
    tag character varying(100) NOT NULL
);


ALTER TABLE public.tag_blacklist OWNER TO aurita;

--
-- Name: tag_feed; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE tag_feed (
    tag_feed_id integer NOT NULL,
    tags character varying[] NOT NULL,
    user_group_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.tag_feed OWNER TO aurita;

--
-- Name: tag_feed_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE tag_feed_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.tag_feed_id_seq OWNER TO aurita;

--
-- Name: tag_feed_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('tag_feed_id_seq', 1049, true);


--
-- Name: tag_index; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE tag_index (
    tag character varying(50) NOT NULL,
    content_id integer NOT NULL,
    tag_type character varying(50) DEFAULT 'IMMEDIATE'::text NOT NULL,
    res_type character varying(20) DEFAULT 'ARTICLE'::text NOT NULL,
    relevance integer DEFAULT 50 NOT NULL
);


ALTER TABLE public.tag_index OWNER TO aurita;

--
-- Name: tag_relevance; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE tag_relevance (
    tag character varying(50) NOT NULL,
    hits integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.tag_relevance OWNER TO aurita;

--
-- Name: tag_synonym; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE tag_synonym (
    tag character varying(50),
    synonym character varying(50)
);


ALTER TABLE public.tag_synonym OWNER TO fuchsto;

--
-- Name: text_asset; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE text_asset (
    text_asset_id integer NOT NULL,
    asset_id integer NOT NULL,
    text text,
    display_text text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.text_asset OWNER TO aurita;

--
-- Name: text_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE text_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 1000
    CACHE 1;


ALTER TABLE public.text_asset_id_seq OWNER TO aurita;

--
-- Name: text_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('text_asset_id_seq', 2895, true);


--
-- Name: todo_asset; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_asset (
    todo_asset_id integer NOT NULL,
    asset_id integer NOT NULL,
    name character varying(255),
    comment text,
    concrete_model character varying(100)
);


ALTER TABLE public.todo_asset OWNER TO fuchsto;

--
-- Name: todo_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_asset_id_seq OWNER TO fuchsto;

--
-- Name: todo_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_asset_id_seq', 2089, true);


--
-- Name: todo_basic_asset; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_basic_asset (
    todo_basic_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_basic_asset OWNER TO fuchsto;

--
-- Name: todo_basic_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_basic_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_basic_asset_id_seq OWNER TO fuchsto;

--
-- Name: todo_basic_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_basic_asset_id_seq', 124, true);


--
-- Name: todo_calculation_asset; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_calculation_asset (
    todo_calculation_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_calculation_asset OWNER TO fuchsto;

--
-- Name: todo_calculation_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_calculation_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_calculation_asset_id_seq OWNER TO fuchsto;

--
-- Name: todo_calculation_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_calculation_asset_id_seq', 9, true);


--
-- Name: todo_calculation_entry; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_calculation_entry (
    todo_calculation_entry_id integer NOT NULL,
    cost numeric DEFAULT 0.0 NOT NULL,
    todo_entry_id integer NOT NULL
);


ALTER TABLE public.todo_calculation_entry OWNER TO fuchsto;

--
-- Name: todo_calculation_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_calculation_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_calculation_entry_id_seq OWNER TO fuchsto;

--
-- Name: todo_calculation_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_calculation_entry_id_seq', 140, true);


--
-- Name: todo_container_asset; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_container_asset (
    todo_container_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_container_asset OWNER TO fuchsto;

--
-- Name: todo_container_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_container_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_container_asset_id_seq OWNER TO fuchsto;

--
-- Name: todo_container_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_container_asset_id_seq', 106, true);


--
-- Name: todo_container_entry; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_container_entry (
    todo_container_entry_id integer NOT NULL,
    todo_entry_id integer NOT NULL,
    article_id integer NOT NULL
);


ALTER TABLE public.todo_container_entry OWNER TO fuchsto;

--
-- Name: todo_container_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_container_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_container_entry_id_seq OWNER TO fuchsto;

--
-- Name: todo_container_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_container_entry_id_seq', 113, true);


--
-- Name: todo_entry; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_entry (
    todo_entry_id integer NOT NULL,
    todo_asset_id integer NOT NULL,
    title character varying(500),
    done boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    priority integer DEFAULT 1 NOT NULL,
    user_group_id integer NOT NULL,
    description text,
    duration_days integer DEFAULT 0,
    duration_hours integer DEFAULT 0,
    deadline date,
    percent_done integer DEFAULT 0
);


ALTER TABLE public.todo_entry OWNER TO fuchsto;

--
-- Name: todo_entry_history; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_entry_history (
    todo_entry_history_id integer NOT NULL,
    todo_entry_id integer NOT NULL,
    user_group_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    action character varying(20),
    diff text
);


ALTER TABLE public.todo_entry_history OWNER TO fuchsto;

--
-- Name: todo_entry_history_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_entry_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_entry_history_id_seq OWNER TO fuchsto;

--
-- Name: todo_entry_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_entry_history_id_seq', 1, false);


--
-- Name: todo_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_entry_id_seq OWNER TO fuchsto;

--
-- Name: todo_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_entry_id_seq', 1133, true);


--
-- Name: todo_entry_user; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_entry_user (
    todo_entry_user_id integer NOT NULL,
    todo_entry_id integer NOT NULL,
    user_group_id integer NOT NULL
);


ALTER TABLE public.todo_entry_user OWNER TO fuchsto;

--
-- Name: todo_entry_user_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_entry_user_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_entry_user_id_seq OWNER TO fuchsto;

--
-- Name: todo_entry_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_entry_user_id_seq', 342, true);


--
-- Name: todo_time_calc_asset; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_time_calc_asset (
    todo_time_calc_asset_id integer NOT NULL,
    todo_asset_id integer NOT NULL
);


ALTER TABLE public.todo_time_calc_asset OWNER TO fuchsto;

--
-- Name: todo_time_calc_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_time_calc_asset_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_time_calc_asset_id_seq OWNER TO fuchsto;

--
-- Name: todo_time_calc_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_time_calc_asset_id_seq', 110, true);


--
-- Name: todo_time_calc_entry; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE todo_time_calc_entry (
    todo_time_calc_entry_id integer NOT NULL,
    unit_cost numeric DEFAULT 0 NOT NULL,
    todo_entry_id integer NOT NULL
);


ALTER TABLE public.todo_time_calc_entry OWNER TO fuchsto;

--
-- Name: todo_time_calc_entry_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE todo_time_calc_entry_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.todo_time_calc_entry_id_seq OWNER TO fuchsto;

--
-- Name: todo_time_calc_entry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('todo_time_calc_entry_id_seq', 228, true);


--
-- Name: user_action; Type: TABLE; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE TABLE user_action (
    user_group_id integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    controller character varying(100),
    method character varying(40),
    params text,
    excep_trace text,
    user_action_id integer NOT NULL,
    num_queries integer,
    num_tuples integer,
    duration double precision,
    runmode character(1) DEFAULT ''::bpchar
);


ALTER TABLE public.user_action OWNER TO fuchsto;

--
-- Name: user_action_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE user_action_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_action_id_seq OWNER TO fuchsto;

--
-- Name: user_action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('user_action_id_seq', 2135876, true);


--
-- Name: user_asset; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE user_asset (
    user_asset_id integer NOT NULL,
    asset_id integer NOT NULL,
    user_group_id integer NOT NULL,
    visiblel visibility DEFAULT ('PUBLIC'::character varying)::visibility NOT NULL
);


ALTER TABLE public.user_asset OWNER TO aurita;

--
-- Name: user_category; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE user_category (
    user_group_id integer NOT NULL,
    category_id integer NOT NULL,
    write_permission boolean DEFAULT false,
    read_permission boolean DEFAULT false
);


ALTER TABLE public.user_category OWNER TO aurita;

--
-- Name: user_media_asset_folder; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE user_media_asset_folder (
    user_group_id integer NOT NULL,
    media_asset_folder_id integer NOT NULL
);


ALTER TABLE public.user_media_asset_folder OWNER TO aurita;

--
-- Name: user_message; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE user_message (
    user_group_id integer NOT NULL,
    user_group_id_from integer NOT NULL,
    timestamp_sent timestamp without time zone DEFAULT now() NOT NULL,
    title character varying(200) DEFAULT '[notitle]'::character varying,
    read boolean DEFAULT false NOT NULL,
    user_message_id integer,
    deleted boolean DEFAULT false NOT NULL,
    answered boolean DEFAULT false NOT NULL,
    message text,
    sender_deleted boolean DEFAULT false,
    system_message boolean DEFAULT false,
    perm_deleted boolean DEFAULT false,
    sender_perm_deleted boolean DEFAULT false
);


ALTER TABLE public.user_message OWNER TO aurita;

--
-- Name: user_message_id_seq; Type: SEQUENCE; Schema: public; Owner: aurita
--

CREATE SEQUENCE user_message_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    MINVALUE 100
    CACHE 1;


ALTER TABLE public.user_message_id_seq OWNER TO aurita;

--
-- Name: user_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: aurita
--

SELECT pg_catalog.setval('user_message_id_seq', 418, true);


--
-- Name: user_online; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE user_online (
    user_group_id integer NOT NULL,
    time_from timestamp without time zone DEFAULT now() NOT NULL,
    session_id character varying(32) NOT NULL,
    time_to timestamp without time zone,
    time_mod timestamp without time zone
);


ALTER TABLE public.user_online OWNER TO aurita;

--
-- Name: user_profile_config; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE user_profile_config (
    poke_me boolean DEFAULT true NOT NULL,
    invisible visibility DEFAULT ('PUBLIC'::character varying)::visibility NOT NULL,
    show_visits visibility DEFAULT ('PUBLIC'::character varying)::visibility NOT NULL,
    show_groups visibility DEFAULT ('PUBLIC'::character varying)::visibility NOT NULL,
    show_pic_flags visibility DEFAULT ('PUBLIC'::character varying)::visibility NOT NULL,
    show_guestbook visibility DEFAULT ('PUBLIC'::character varying)::visibility NOT NULL,
    show_realname visibility DEFAULT ('FRIENDS'::character varying)::visibility NOT NULL,
    mail_messages boolean DEFAULT true NOT NULL,
    play_message_sound boolean DEFAULT true NOT NULL,
    hide_visits boolean DEFAULT false NOT NULL,
    user_profile_config_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_profile_config OWNER TO aurita;

--
-- Name: user_profile_config_id_seq; Type: SEQUENCE; Schema: public; Owner: fuchsto
--

CREATE SEQUENCE user_profile_config_id_seq
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_profile_config_id_seq OWNER TO fuchsto;

--
-- Name: user_profile_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fuchsto
--

SELECT pg_catalog.setval('user_profile_config_id_seq', 80, true);


--
-- Name: user_profile_visit; Type: TABLE; Schema: public; Owner: aurita; Tablespace: 
--

CREATE TABLE user_profile_visit (
    user_group_id integer NOT NULL,
    user_group_id_visitor integer NOT NULL,
    "time" timestamp without time zone DEFAULT now() NOT NULL,
    hidden boolean DEFAULT false NOT NULL
);


ALTER TABLE public.user_profile_visit OWNER TO aurita;

SET search_path = internal, pg_catalog;

--
-- Data for Name: group_leader; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY group_leader (user_id, user_group_id) FROM stdin;
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY permission (permission_id, role_id, content_id, type) FROM stdin;
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY role (role_id, role_name) FROM stdin;
100	tl:superadmin
1	tl:registered_users
\.


--
-- Data for Name: role_permission; Type: TABLE DATA; Schema: internal; Owner: fuchsto
--

COPY role_permission (role_permission_id, role_id, name, value) FROM stdin;
1105	1	send_messages	true
1106	1	delete_hierarchies	false
1107	1	view_recent_comments	false
1108	1	create_events	false
1109	1	edit_foreign_events	false
1110	1	see_calendar	true
1111	1	create_articles	true
1112	1	edit_foreign_articles	false
1113	1	create_public_folders	false
1114	1	view_foreign_article_versions	true
1115	1	view_foreign_media_versions	true
1116	1	reactivate_foreign_article_versions	false
1117	1	delete_foreign_articles	false
1118	1	change_meta_data_of_foreign_articles	true
1119	1	delete_foreign_files	false
1120	1	change_meta_data_of_foreign_files	false
1087	100	is_admin	t
1088	100	is_super_admin	t
1089	100	send_messages	true
1090	100	delete_hierarchies	true
1091	100	view_recent_comments	true
1092	100	create_events	true
1093	100	edit_foreign_events	true
1094	100	see_calendar	true
1095	100	create_articles	true
1096	100	edit_foreign_articles	true
1097	100	create_public_folders	true
1098	100	view_foreign_article_versions	true
1099	100	view_foreign_media_versions	true
1100	100	reactivate_foreign_article_versions	true
1101	100	delete_foreign_articles	true
1102	100	change_meta_data_of_foreign_articles	true
1103	100	delete_foreign_files	true
1104	100	change_meta_data_of_foreign_files	true
\.


--
-- Data for Name: user_group; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY user_group (user_group_id, user_group_name, atomic, hidden, division, language) FROM stdin;
0	guest	t	t	\N	de
5	aurita	t	t	\N	de
100	admin	t	t	\N	de
\.


--
-- Data for Name: user_group_hierarchy; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY user_group_hierarchy (user_group_id__parent, user_group_id__child) FROM stdin;
\.


--
-- Data for Name: user_login_data; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY user_login_data (login, pass, user_group_id, locked, deleted) FROM stdin;
none	none	0	f	f
none2	none2	5	f	f
fadfbb67bc6ed1b077c6c737ab6f943d	098f6bcd4621d373cade4e832627b4f6	1	f	f
21232f297a57a5a743894a0e4a801fc3	098f6bcd4621d373cade4e832627b4f6	100	f	f
\.


--
-- Data for Name: user_profile; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY user_profile (user_group_id, forename, surname, title, picture_asset_id, phone_office, phone_home, mobile_office, mobile_home, email_office, email_home, tags, hits, time_registered, gender, location, about_me, occupation, messenger, signature, tag_count, nick_youtube, user_profile_config_id, comment, theme) FROM stdin;
5				0	\N	\N	\N	\N	\N		\N	0	2010-02-24 18:51:01.231043	t	\N	\N			\N	0		0		default
0	guest	 	 	1	\N	-	\N	\N	\N		{user}	0	2010-02-24 18:51:01.231043	t	\N	\N			\N	0		0		default
100	 	admin	 	2657		-				\N	{admin}	7	2010-02-24 18:51:01.231043	t						0		0		default
\.


--
-- Data for Name: user_role; Type: TABLE DATA; Schema: internal; Owner: aurita
--

COPY user_role (user_group_id, role_id) FROM stdin;
100	100
\.


SET search_path = public, pg_catalog;

--
-- Data for Name: archive; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY archive (archive_id, media_asset_id, archive_run_id) FROM stdin;
\.


--
-- Data for Name: archive_run; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY archive_run (archive_run_id, "time", status) FROM stdin;
\.


--
-- Data for Name: article; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY article (article_id, content_id, template_id, title, view_count, published, header) FROM stdin;
\.


--
-- Data for Name: article_access; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY article_access (article_id, user_group_id, changed) FROM stdin;
\.


--
-- Data for Name: article_layout; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY article_layout (article_layout_id, layout_name, columns) FROM stdin;
\.


--
-- Data for Name: article_layout_asset; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY article_layout_asset (article_layout_asset_id, article_layout_id, asset_id, "position") FROM stdin;
\.


--
-- Data for Name: article_version; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY article_version (article_version_id, article_id, version, user_group_id, timestamp_created, dump, action_type) FROM stdin;
\.


--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY asset (asset_id, content_id, concrete_model) FROM stdin;
\.


--
-- Data for Name: banner_ad; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY banner_ad (banner_ad_id, media_asset_id, width, height) FROM stdin;
\.


--
-- Data for Name: bookmark; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY bookmark (bookmark_id, user_id, url, tags, title, type, bookmark_folder_id, sortpos) FROM stdin;
\.


--
-- Data for Name: bookmark_folder; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY bookmark_folder (bookmark_folder_id, parent_folder_id, folder_name, user_group_id) FROM stdin;
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY category (category_id, category_name, is_private, public_writeable, public_readable, registered_writeable, registered_readable, versioned, category_id_parent) FROM stdin;
100	admin	t	f	f	f	f	t	0
1000	tl:general	f	f	t	f	f	t	0
1	tl:no_category	f	f	f	f	f	t	0
\.


--
-- Data for Name: company_person; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY company_person (contact_company_id, contact_person_id) FROM stdin;
\.


--
-- Data for Name: component_position; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY component_position (component_dom_id, "position", gui_context, component_position_id, user_group_id) FROM stdin;
\.


--
-- Data for Name: contact_company; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY contact_company (contact_company_id, company_name, email, website, comment) FROM stdin;
\.


--
-- Data for Name: contact_person; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY contact_person (contact_person_id, content_id, forename, surname, work_phone, work_mobile, home_phone, home_mobile, home_email, comment, city, zip, street, home_fax, work_fax, country, work_email, contact_company_id) FROM stdin;
\.


--
-- Data for Name: container; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY container (content_id_parent, content_id_child, sortpos, content_type, asset_id_child) FROM stdin;
\.


--
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY content (content_id, user_group_id, tags, changed, created, hits, locked, deleted, version, concrete_model) FROM stdin;
\.


--
-- Data for Name: content_access; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY content_access (content_id, user_group_id, changed, res_type) FROM stdin;
\.


--
-- Data for Name: content_category; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY content_category (content_id, category_id) FROM stdin;
\.


--
-- Data for Name: content_comment; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY content_comment (content_id, "time", content_comment_id, user_group_name, user_group_id, message) FROM stdin;
\.


--
-- Data for Name: content_history; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY content_history (content_history_id, user_group_id, "time", type, content_id) FROM stdin;
\.


--
-- Data for Name: content_permissions; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY content_permissions (content_permissions_id, content_id, user_group_id, readonly) FROM stdin;
\.


--
-- Data for Name: content_rating; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY content_rating (content_id, total_ratings, value, aspect) FROM stdin;
\.


--
-- Data for Name: content_recommendation; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY content_recommendation (content_recommendation_id, user_group_id_from, user_group_id, viewed, content_id, type, message) FROM stdin;
\.


--
-- Data for Name: event; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY event (event_id, date_begin, date_end, name, description, time_begin, time_end, max_participants, visible, content_id, repeat_annual, repeat_weekly, repeat_monthly, repeat_monthly_day) FROM stdin;
\.


--
-- Data for Name: feed_cache_entry; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY feed_cache_entry (feed_cache_entry_id, title, url, feed_type, feed_data_type, etag, last_modified, feed_collection_entry_id, content) FROM stdin;
\.


--
-- Data for Name: feed_collection; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY feed_collection (feed_collection_id, collection_name, content_id) FROM stdin;
\.


--
-- Data for Name: feed_collection_entry; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY feed_collection_entry (feed_collection_entry_id, feed_collection_id, url, max_entries, per_page, title) FROM stdin;
\.


--
-- Data for Name: flickr_feed_col_entry; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY flickr_feed_col_entry (flickr_feed_col_entry_id, feed_collection_id, flickr_user, media_asset_folder_id) FROM stdin;
1	105	photoallergic	583
2	105	The Library of Congress	585
\.


--
-- Data for Name: flickr_media_asset; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY flickr_media_asset (flickr_media_asset_id, media_asset_id, flickr_photo_id) FROM stdin;
\.


--
-- Data for Name: hierarchy; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY hierarchy (hierarchy_id, header, category) FROM stdin;
\.


--
-- Data for Name: hierarchy_category; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY hierarchy_category (hierarchy_id, category_id) FROM stdin;
\.


--
-- Data for Name: hierarchy_entry; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY hierarchy_entry (hierarchy_entry_id, hierarchy_id, interface, entry_type, hierarchy_entry_id_parent, sortpos, content_id, label) FROM stdin;
\.


--
-- Data for Name: media_asset; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY media_asset (media_asset_id, asset_id, mime, media_folder_id, description, user_submitted, filesize, title, extension, original_filename, checksum, old_id) FROM stdin;
\.


--
-- Data for Name: media_asset_bookmark; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY media_asset_bookmark (user_group_id, media_asset_id, "time") FROM stdin;
\.


--
-- Data for Name: media_asset_download; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY media_asset_download (media_asset_download_id, user_group_id, "time", media_asset_id) FROM stdin;
\.


--
-- Data for Name: media_asset_folder; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY media_asset_folder (media_asset_folder_id, physical_path, media_folder_id__parent, user_group_id, access, trashbin) FROM stdin;
1	Medien	0	1	PUBLIC	f
100	Benutzer	0	1	PUBLIC	f
0	/	\N	0	PUBLIC	f
1026	admin	0	100	PRIVATE	f
\.


--
-- Data for Name: media_asset_folder_category; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY media_asset_folder_category (folder_category_id, media_asset_folder_id, category_id) FROM stdin;
1321	1026	100
\.


--
-- Data for Name: media_asset_version; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY media_asset_version (media_asset_version_id, media_asset_id, version, timestamp_created, user_group_id) FROM stdin;
\.


--
-- Data for Name: media_container; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY media_container (media_container_id, asset_id) FROM stdin;
\.


--
-- Data for Name: media_container_entry; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY media_container_entry (media_container_entry_id, media_container_id, media_asset_id, "position") FROM stdin;
\.


--
-- Data for Name: media_iptc; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY media_iptc (media_asset_id, headline, caption, keywords, by_line, by_line_title, copyright, credit, contract, object_name, date_created, time_created, digital_creation_date, digital_creation_time, city, sublocation, province_state, country_code, country_name, special_instructions, source, originating_program, edit_status, envelope_priority, object_cycle, original_transmission_ref, fixture_identifier, writer) FROM stdin;
\.


--
-- Data for Name: memo_article; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY memo_article (memo_article_id, article_id, release_date, company, comment, memo_type, signature) FROM stdin;
\.


--
-- Data for Name: model_register; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY model_register (model_register_id, fields, types, pkeys, aggregates, name, is_a) FROM stdin;
\.


--
-- Data for Name: page; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY page (page_id, content_id, title) FROM stdin;
\.


--
-- Data for Name: page_element; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY page_element (page_element_id, content_id, "position", page_id) FROM stdin;
\.


--
-- Data for Name: poll; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY poll (poll_id, time_created, deadline, title, user_group_id, options) FROM stdin;
\.


--
-- Data for Name: poll_voting; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY poll_voting (poll_voting_id, poll_id, user_group_id, option) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY role_permissions (role_id, is_super_admin, is_admin, may_upload_files, may_upload_large_files, may_create_forum_groups, may_moderate_foreign_forum_groups, may_publish_articles, may_edit_foreign_articles, may_create_events, may_create_regular_events, may_edit_calendar, may_edit_own_asset_comments, may_edit_foreign_asset_comments, is_developer, may_create_public_folders) FROM stdin;
100	t	t	t	t	t	t	t	t	t	t	t	t	f	f	f
1	f	f	t	t	t	f	t	t	t	t	t	t	f	f	f
\.


--
-- Data for Name: tag_blacklist; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY tag_blacklist (tag) FROM stdin;
\.


--
-- Data for Name: tag_feed; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY tag_feed (tag_feed_id, tags, user_group_id) FROM stdin;
\.


--
-- Data for Name: tag_index; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY tag_index (tag, content_id, tag_type, res_type, relevance) FROM stdin;
\.


--
-- Data for Name: tag_relevance; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY tag_relevance (tag, hits) FROM stdin;
\.


--
-- Data for Name: tag_synonym; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY tag_synonym (tag, synonym) FROM stdin;
\.


--
-- Data for Name: text_asset; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY text_asset (text_asset_id, asset_id, text, display_text) FROM stdin;
\.


--
-- Data for Name: todo_asset; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_asset (todo_asset_id, asset_id, name, comment, concrete_model) FROM stdin;
\.


--
-- Data for Name: todo_basic_asset; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_basic_asset (todo_basic_asset_id, todo_asset_id) FROM stdin;
\.


--
-- Data for Name: todo_calculation_asset; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_calculation_asset (todo_calculation_asset_id, todo_asset_id) FROM stdin;
\.


--
-- Data for Name: todo_calculation_entry; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_calculation_entry (todo_calculation_entry_id, cost, todo_entry_id) FROM stdin;
\.


--
-- Data for Name: todo_container_asset; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_container_asset (todo_container_asset_id, todo_asset_id) FROM stdin;
\.


--
-- Data for Name: todo_container_entry; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_container_entry (todo_container_entry_id, todo_entry_id, article_id) FROM stdin;
\.


--
-- Data for Name: todo_entry; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_entry (todo_entry_id, todo_asset_id, title, done, created, priority, user_group_id, description, duration_days, duration_hours, deadline, percent_done) FROM stdin;
\.


--
-- Data for Name: todo_entry_history; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_entry_history (todo_entry_history_id, todo_entry_id, user_group_id, "time", action, diff) FROM stdin;
\.


--
-- Data for Name: todo_entry_user; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_entry_user (todo_entry_user_id, todo_entry_id, user_group_id) FROM stdin;
\.


--
-- Data for Name: todo_time_calc_asset; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_time_calc_asset (todo_time_calc_asset_id, todo_asset_id) FROM stdin;
\.


--
-- Data for Name: todo_time_calc_entry; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY todo_time_calc_entry (todo_time_calc_entry_id, unit_cost, todo_entry_id) FROM stdin;
\.


--
-- Data for Name: user_action; Type: TABLE DATA; Schema: public; Owner: fuchsto
--

COPY user_action (user_group_id, "time", controller, method, params, excep_trace, user_action_id, num_queries, num_tuples, duration, runmode) FROM stdin;
0	2010-06-18 00:45:04.410567	Aurita::AHA::App_Main_Controller	start	\N	\N	2135767	9	2	0.031695000000000001	d
0	2010-06-18 00:45:04.598912	Aurita::AHA::App_Main_Controller	start	\N	\N	2135768	6	0	0.026700999999999999	d
0	2010-06-18 00:47:46.334841	Aurita::AHA::App_Main_Controller	start	\N	\N	2135769	6	0	0.027189999999999999	d
0	2010-06-18 00:47:46.604516	Aurita::AHA::App_Main_Controller	start	\N	\N	2135770	6	0	0.038989000000000003	d
0	2010-06-18 00:48:01.619786	Aurita::AHA::App_Main_Controller	start	\N	\N	2135771	6	0	0.026516000000000001	d
0	2010-06-18 00:48:05.001716	Aurita::AHA::App_Main_Controller	start	\N	\N	2135772	6	0	0.027026000000000001	d
0	2010-06-18 00:48:35.940219	Aurita::AHA::App_Main_Controller	start	\N	\N	2135773	6	0	0.027144000000000001	d
0	2010-06-18 00:48:38.434004	Aurita::AHA::App_Main_Controller	start	\N	\N	2135774	6	0	0.026415000000000001	d
0	2010-06-18 00:49:27.761935	Aurita::AHA::App_Main_Controller	start	\N	\N	2135775	6	0	0.027394999999999999	d
0	2010-06-18 00:49:28.010071	Aurita::AHA::App_Main_Controller	start	\N	\N	2135776	6	0	0.026159999999999999	d
0	2010-06-18 00:50:21.765411	Aurita::AHA::App_Main_Controller	start	\N	\N	2135777	6	0	0.027	d
0	2010-06-18 00:50:22.007391	Aurita::AHA::App_Main_Controller	start	\N	\N	2135778	6	0	0.025874000000000001	d
0	2010-06-18 00:50:22.829851	Aurita::AHA::App_Main_Controller	start	\N	\N	2135779	6	0	0.026808999999999999	d
0	2010-06-18 00:50:44.923512	Aurita::AHA::App_Main_Controller	start	\N	\N	2135780	6	0	0.026549	d
0	2010-06-18 00:50:47.001637	Aurita::AHA::App_Main_Controller	start	\N	\N	2135781	6	0	0.026787999999999999	d
0	2010-06-18 00:50:51.26952	Aurita::AHA::App_Main_Controller	login	\N	\N	2135782	0	0	0.001756	d
100	2010-06-18 00:50:55.647541	Aurita::AHA::App_Main_Controller	validate_user	pass=bcfb6e47cf890dea35364272182b9364&login=21232f297a57a5a743894a0e4a801fc3	\N	2135783	1	1	0.0028340000000000001	d
100	2010-06-18 00:50:55.801221	Aurita::AHA::App_Main_Controller	start	password=eskimo&login=admin	\N	2135784	47	8	0.11725099999999999	d
100	2010-06-18 00:50:55.923744	Aurita::AHA::App_Main_Controller	start	\N	\N	2135785	47	9	0.115371	d
100	2010-06-18 00:50:56.199158	Aurita::AHA::App_Main_Controller	start	\N	\N	2135786	47	10	0.117213	d
100	2010-06-18 00:50:59.446276	Aurita::Main::App_Admin_Controller	left	\N	\N	2135787	5	5	0.026769000000000001	d
100	2010-06-18 00:50:59.456756	Aurita::Main::App_Admin_Controller	main	\N	\N	2135788	0	0	0.00086300000000000005	d
100	2010-06-18 00:51:01.805881	Aurita::Main::User_Profile_Controller	show_own	\N	\N	2135789	4	3	0.012152	d
100	2010-06-18 00:51:03.424037	Aurita::Main::User_Profile_Controller	update	user_group_id=100	\N	2135790	2	2	0.023560999999999999	d
0	2010-06-18 00:51:18.276897	Aurita::AHA::App_Main_Controller	logout	\N	\N	2135791	0	0	0.0031649999999999998	d
0	2010-06-18 00:51:18.401869	Aurita::AHA::App_Main_Controller	logout	\N	\N	2135792	0	0	0.0029359999999999998	d
0	2010-06-18 00:51:23.674207	Aurita::AHA::App_Main_Controller	start	\N	\N	2135793	6	0	0.027005000000000001	d
0	2010-06-18 00:51:23.857219	Aurita::AHA::App_Main_Controller	start	\N	\N	2135794	6	0	0.026436999999999999	d
0	2010-06-18 00:51:31.726317	Aurita::AHA::App_Main_Controller	login	\N	\N	2135795	0	0	0.0017910000000000001	d
100	2010-06-18 00:51:36.840301	Aurita::AHA::App_Main_Controller	validate_user	pass=bcfb6e47cf890dea35364272182b9364&login=21232f297a57a5a743894a0e4a801fc3	\N	2135796	1	1	0.0018929999999999999	d
100	2010-06-18 00:51:36.963001	Aurita::AHA::App_Main_Controller	start	password=eskimo&login=admin	\N	2135797	47	16	0.084404000000000007	d
100	2010-06-18 00:51:37.089741	Aurita::AHA::App_Main_Controller	start	\N	\N	2135798	47	17	0.119324	d
100	2010-06-18 00:51:37.36028	Aurita::AHA::App_Main_Controller	start	\N	\N	2135799	47	18	0.118766	d
100	2010-06-18 00:51:39.51278	Aurita::Main::App_Admin_Controller	left	\N	\N	2135800	5	5	0.026953999999999999	d
100	2010-06-18 00:51:39.524796	Aurita::Main::App_Admin_Controller	main	\N	\N	2135801	0	0	0.00092599999999999996	d
0	2010-06-18 00:52:30.921905	Aurita::AHA::App_Main_Controller	logout	\N	\N	2135802	0	0	0.003101	d
0	2010-06-18 00:52:31.052611	Aurita::AHA::App_Main_Controller	logout	\N	\N	2135803	0	0	0.002967	d
0	2010-06-18 00:52:32.082184	Aurita::AHA::App_Main_Controller	start	\N	\N	2135804	6	0	0.026702	d
0	2010-06-18 00:52:34.720342	Aurita::AHA::App_Main_Controller	login	\N	\N	2135805	0	0	0.0017489999999999999	d
100	2010-06-18 00:52:37.329621	Aurita::AHA::App_Main_Controller	validate_user	pass=bcfb6e47cf890dea35364272182b9364&login=21232f297a57a5a743894a0e4a801fc3	\N	2135806	1	1	0.0029350000000000001	d
100	2010-06-18 00:52:37.461334	Aurita::AHA::App_Main_Controller	start	password=eskimo&login=admin	\N	2135807	47	22	0.119751	d
100	2010-06-18 00:52:37.558343	Aurita::AHA::App_Main_Controller	start	\N	\N	2135808	47	23	0.089819999999999997	d
100	2010-06-18 00:52:40.656906	Aurita::Main::User_Profile_Controller	show_own	\N	\N	2135809	4	3	0.011686999999999999	d
100	2010-06-18 00:52:41.603223	Aurita::Main::User_Profile_Controller	update	user_group_id=100	\N	2135810	2	2	0.022891999999999999	d
100	2010-06-18 00:52:44.495601	Aurita::Main::User_Profile_Controller	show_own	\N	\N	2135811	4	3	0.011918	d
100	2010-06-18 00:52:46.289418	Aurita::Main::User_Profile_Controller	update	user_group_id=100	\N	2135812	2	2	0.023182000000000001	d
100	2010-06-18 00:52:53.725255	Aurita::Main::User_Profile_Controller	perform_update	pass_confirm=test&internal.user_profile.picture_asset_id=2657&forename= &pass=&internal.user_login_data.pass=&picture_asset_id=2657&email_home=&internal.user_profile.forename= &user_group_name=admin&internal.user_profile.email_home=&internal.user_login_data.login=21232f297a57a5a743894a0e4a801fc3&tags=admin&login=21232f297a57a5a743894a0e4a801fc3&internal.user_profile.tags=admin&internal.user_profile.user_group_id=100&user_group_id=100&internal.user_group.user_group_name=admin&internal.user_group.user_group_id=100&surname=admin&internal.user_login_data.user_group_id=100&internal.user_profile.surname=admin	\N	2135813	5	2	0.025852	d
100	2010-06-18 00:52:53.804018	Aurita::Main::User_Profile_Controller	show	id=100	\N	2135814	5	4	0.013875999999999999	d
100	2010-06-18 00:52:55.62206	Aurita::Main::App_General_Controller	left	\N	\N	2135815	189	8	0.40899200000000002	d
100	2010-06-18 00:52:55.731825	Aurita::Main::App_General_Controller	main	\N	\N	2135816	43	6	0.093469999999999998	d
100	2010-06-18 00:52:58.989236	Aurita::Plugins::Wiki::Article_Controller	add	\N	\N	2135817	13	26	0.028958999999999999	d
100	2010-06-18 00:53:22.049316	Aurita::Plugins::Calendar::Event_Controller	list	day=2010.06.16	\N	2135818	2	2	0.0044260000000000002	d
100	2010-06-18 00:53:22.742723	Aurita::Plugins::Calendar::Event_Controller	list	day=2010.06.17	\N	2135819	2	2	0.0038600000000000001	d
100	2010-06-18 00:53:23.979561	Aurita::Plugins::Wiki::Media_Asset_Folder_Controller	add	\N	\N	2135820	11	25	0.022089000000000001	d
100	2010-06-18 00:53:26.811936	Aurita::Plugins::Wiki::Media_Asset_Folder_Controller	perform_add	public.category.category_id=100&media_folder_id__parent=0&concrete_model=Aurita::Plugins::Wiki::Media_Asset_Folder&public.category.category_id_select=-&user_group_id=100&public.media_asset_folder.media_folder_id__parent=0&category_id_select=-&physical_path=admin&category_id=100&trashbin=f&public.media_asset_folder.physical_path=admin	\N	2135821	10	4	0.017417999999999999	d
100	2010-06-18 00:53:26.891742	Aurita::Plugins::Wiki::Media_Asset_Folder_Controller	tree_box_body	\N	\N	2135822	7	4	0.015599	d
100	2010-06-18 00:53:26.947974	Aurita::Plugins::Wiki::Media_Asset_Folder_Controller	show	id=1026	\N	2135823	8	5	0.018183000000000001	d
100	2010-06-18 00:53:28.477527	Aurita::Main::User_Profile_Controller	show_own	\N	\N	2135824	4	3	0.011996	d
100	2010-06-18 00:53:29.637916	Aurita::Plugins::Wiki::Media_Asset_Folder_Controller	add	\N	\N	2135825	11	25	0.021953	d
100	2010-06-18 00:53:38.181807	Aurita::Main::Async_Feedback_Controller	get	x=1	\N	2135826	1	1	0.0027409999999999999	d
100	2010-06-18 00:54:38.197812	Aurita::Main::App_General_Controller	users_online_box_body	\N	\N	2135827	1	35	0.016118	d
100	2010-06-18 00:54:38.213255	Aurita::Main::Async_Feedback_Controller	get	x=1	\N	2135828	1	1	0.0022100000000000002	d
100	2010-06-18 00:55:38.185694	Aurita::Main::Async_Feedback_Controller	get	x=1	\N	2135829	1	1	0.0024940000000000001	d
100	2010-06-18 00:56:00.084912	Aurita::Main::App_My_Place_Controller	left	\N	\N	2135830	14	4	0.031167	d
100	2010-06-18 00:56:00.183716	Aurita::Main::App_My_Place_Controller	main	\N	\N	2135831	43	6	0.091922000000000004	d
100	2010-06-18 00:56:02.081402	Aurita::Main::App_General_Controller	left	\N	\N	2135832	190	9	0.42199399999999998	d
100	2010-06-18 00:56:02.164553	Aurita::Main::App_General_Controller	main	\N	\N	2135833	43	6	0.068237999999999993	d
100	2010-06-18 00:56:08.650309	Aurita::Main::App_General_Controller	left	\N	\N	2135834	190	9	0.471111	d
100	2010-06-18 00:56:08.755717	Aurita::Main::App_General_Controller	main	\N	\N	2135835	43	6	0.090884000000000006	d
100	2010-06-18 00:56:38.201725	Aurita::Main::App_General_Controller	users_online_box_body	\N	\N	2135836	1	32	0.015339	d
100	2010-06-18 00:56:38.219691	Aurita::Main::Async_Feedback_Controller	get	x=1	\N	2135837	1	1	0.0022680000000000001	d
100	2010-06-18 00:56:54.714502	Aurita::Plugins::Wiki::Media_Asset_Folder_Controller	add	\N	\N	2135838	11	25	0.023713000000000001	d
100	2010-06-18 00:56:56.40153	Aurita::Plugins::Wiki::Media_Asset_Folder_Controller	show	media_asset_folder_id=1026	\N	2135839	8	5	0.019075000000000002	d
100	2010-06-18 00:56:57.157266	Aurita::Plugins::Wiki::Media_Asset_Controller	add	media_folder_id=1026	\N	2135840	21	33	0.039399000000000003	d
100	2010-06-18 00:57:38.212131	Aurita::Main::Async_Feedback_Controller	get	x=1	\N	2135841	1	1	0.0025709999999999999	d
100	2010-06-18 00:57:54.89195	Aurita::Plugins::Wiki::Article_Controller	add	\N	\N	2135842	13	26	0.027737999999999999	d
100	2010-06-18 01:04:55.300032	Aurita::AHA::App_Main_Controller	start	\N	\N	2135843	47	7	0.26891399999999999	d
100	2010-06-18 01:05:00.549594	Aurita::AHA::App_Main_Controller	start	\N	\N	2135844	47	8	0.32913300000000001	d
100	2010-06-18 01:05:02.261377	Aurita::Main::App_General_Controller	left	\N	\N	2135845	190	9	0.98025499999999999	d
100	2010-06-18 01:05:02.512189	Aurita::Main::App_General_Controller	main	\N	\N	2135846	43	6	0.215305	d
100	2010-06-18 01:05:04.183008	Aurita::Plugins::Wiki::Article_Controller	add	\N	\N	2135847	13	26	0.029843000000000001	d
100	2010-06-18 01:05:26.671668	Aurita::Plugins::Calendar::Event_Controller	add	\N	\N	2135848	11	25	0.043123000000000002	d
100	2010-06-18 01:05:32.278648	Aurita::Main::App_My_Place_Controller	left	\N	\N	2135849	14	4	0.032076	d
100	2010-06-18 01:05:32.568528	Aurita::Main::App_My_Place_Controller	main	\N	\N	2135850	43	6	0.28298099999999998	d
100	2010-06-18 01:05:33.528775	Aurita::Plugins::Wiki::Article_Controller	add	\N	\N	2135851	13	26	0.028757000000000001	d
100	2010-06-18 01:05:35.930343	Aurita::Plugins::Wiki::Article_Controller	add	\N	\N	2135852	13	26	0.029117000000000001	d
100	2010-06-18 01:06:00.189881	Aurita::Main::Async_Feedback_Controller	get	x=1	\N	2135853	1	1	0.0029099999999999998	d
100	2010-06-18 01:06:08.75027	Aurita::Main::App_Admin_Controller	left	\N	\N	2135854	5	5	0.027268000000000001	d
100	2010-06-18 01:06:08.766531	Aurita::Main::App_Admin_Controller	main	\N	\N	2135855	0	0	0.00092199999999999997	d
100	2010-06-18 01:06:11.24697	Aurita::Main::User_Profile_Controller	show_own	\N	\N	2135856	4	3	0.012019	d
100	2010-06-18 01:06:13.42237	Aurita::Main::User_Profile_Controller	update	user_group_id=100	\N	2135857	2	2	0.025006	d
100	2010-06-18 01:06:14.7262	Aurita::Plugins::Wiki::Media_Asset_Controller	choose_from_user_folders	user_group_id=&image_dom_id=internal_user_profile_picture_asset_id	\N	2135858	7	5	0.013651999999999999	d
100	2010-06-18 01:06:56.925683	Aurita::Main::Category_Controller	update	category_id=1000	\N	2135859	10	11	0.036489000000000001	d
100	2010-06-18 01:07:00.160654	Aurita::Main::App_General_Controller	users_online_box_body	\N	\N	2135860	1	17	0.010198	d
100	2010-06-18 01:07:00.190729	Aurita::Main::Async_Feedback_Controller	get	x=1	\N	2135861	1	1	0.0028389999999999999	d
100	2010-06-18 01:07:06.586012	Aurita::Main::App_General_Controller	left	\N	\N	2135862	190	9	1.064808	d
100	2010-06-18 01:07:06.822996	Aurita::Main::App_General_Controller	main	\N	\N	2135863	43	6	0.22320400000000001	d
100	2010-06-18 01:07:09.891695	Aurita::Main::App_My_Place_Controller	left	\N	\N	2135864	14	4	0.031343999999999997	d
100	2010-06-18 01:07:10.179186	Aurita::Main::App_My_Place_Controller	main	\N	\N	2135865	43	6	0.275453	d
100	2010-06-18 01:07:10.893032	Aurita::Plugins::Wiki::Article_Controller	add	\N	\N	2135866	13	26	0.028892000000000001	d
100	2010-06-18 01:07:12.269783	Aurita::Plugins::Messaging::Mailbox_Controller	show	\N	\N	2135867	4	1	0.013958	d
100	2010-06-18 01:07:15.753455	Aurita::Main::App_Admin_Controller	left	\N	\N	2135868	5	5	0.027208	d
100	2010-06-18 01:07:15.768557	Aurita::Main::App_Admin_Controller	main	\N	\N	2135869	0	0	0.00087000000000000001	d
100	2010-06-18 01:07:16.62744	Aurita::Main::Tag_Synonym_Controller	edit	\N	\N	2135870	0	0	0.0033440000000000002	d
100	2010-06-18 01:07:18.068433	Aurita::Main::Tag_Synonym_Controller	list_all	\N	\N	2135871	1	0	0.0026380000000000002	d
100	2010-06-18 01:07:19.11044	Aurita::Main::User_Login_Data_Controller	update	user_group_id=0	\N	2135872	11	8	0.030036	d
100	2010-06-18 01:07:19.957104	Aurita::Main::User_Login_Data_Controller	update	user_group_id=100	\N	2135873	14	11	0.043406	d
100	2010-06-18 01:07:20.434711	Aurita::Main::User_Profile_Controller	admin_add	\N	\N	2135874	0	0	0.015058999999999999	d
100	2010-06-18 01:07:24.355777	Aurita::Main::App_General_Controller	left	\N	\N	2135875	190	9	1.0622670000000001	d
100	2010-06-18 01:07:24.58754	Aurita::Main::App_General_Controller	main	\N	\N	2135876	43	6	0.218718	d
\.


--
-- Data for Name: user_asset; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY user_asset (user_asset_id, asset_id, user_group_id, visiblel) FROM stdin;
\.


--
-- Data for Name: user_category; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY user_category (user_group_id, category_id, write_permission, read_permission) FROM stdin;
100	100	t	t
100	1000	f	f
\.


--
-- Data for Name: user_media_asset_folder; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY user_media_asset_folder (user_group_id, media_asset_folder_id) FROM stdin;
100	998
100	999
\.


--
-- Data for Name: user_message; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY user_message (user_group_id, user_group_id_from, timestamp_sent, title, read, user_message_id, deleted, answered, message, sender_deleted, system_message, perm_deleted, sender_perm_deleted) FROM stdin;
\.


--
-- Data for Name: user_online; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY user_online (user_group_id, time_from, session_id, time_to, time_mod) FROM stdin;
\.


--
-- Data for Name: user_profile_config; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY user_profile_config (poke_me, invisible, show_visits, show_groups, show_pic_flags, show_guestbook, show_realname, mail_messages, play_message_sound, hide_visits, user_profile_config_id) FROM stdin;
\.


--
-- Data for Name: user_profile_visit; Type: TABLE DATA; Schema: public; Owner: aurita
--

COPY user_profile_visit (user_group_id, user_group_id_visitor, "time", hidden) FROM stdin;
\.


SET search_path = internal, pg_catalog;

--
-- Name: permission_id; Type: CONSTRAINT; Schema: internal; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT permission_id PRIMARY KEY (permission_id);


--
-- Name: role_id; Type: CONSTRAINT; Schema: internal; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_id PRIMARY KEY (role_id);


--
-- Name: user_group_hierarchy_id; Type: CONSTRAINT; Schema: internal; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY user_group_hierarchy
    ADD CONSTRAINT user_group_hierarchy_id PRIMARY KEY (user_group_id__parent, user_group_id__child);


--
-- Name: user_group_id; Type: CONSTRAINT; Schema: internal; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY user_group
    ADD CONSTRAINT user_group_id PRIMARY KEY (user_group_id);


--
-- Name: user_login_data_id; Type: CONSTRAINT; Schema: internal; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY user_login_data
    ADD CONSTRAINT user_login_data_id PRIMARY KEY (login, pass);


--
-- Name: user_profile_pkey; Type: CONSTRAINT; Schema: internal; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY user_profile
    ADD CONSTRAINT user_profile_pkey PRIMARY KEY (user_group_id);


--
-- Name: user_role_id; Type: CONSTRAINT; Schema: internal; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_id PRIMARY KEY (user_group_id, role_id);


SET search_path = public, pg_catalog;

--
-- Name: article_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY article
    ADD CONSTRAINT article_id PRIMARY KEY (article_id);


--
-- Name: asset_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT asset_id PRIMARY KEY (asset_id);


--
-- Name: content_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY content
    ADD CONSTRAINT content_id PRIMARY KEY (content_id);


--
-- Name: content_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY content_permissions
    ADD CONSTRAINT content_permissions_pkey PRIMARY KEY (content_permissions_id);


--
-- Name: hierarchy_entry_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY hierarchy_entry
    ADD CONSTRAINT hierarchy_entry_id PRIMARY KEY (hierarchy_entry_id);


--
-- Name: hierarchy_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY hierarchy
    ADD CONSTRAINT hierarchy_id PRIMARY KEY (hierarchy_id);


--
-- Name: media_asset_folder_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY media_asset_folder
    ADD CONSTRAINT media_asset_folder_id PRIMARY KEY (media_asset_folder_id);


--
-- Name: tag_feed_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY tag_feed
    ADD CONSTRAINT tag_feed_id PRIMARY KEY (tag_feed_id);


--
-- Name: tag_index_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY tag_index
    ADD CONSTRAINT tag_index_id PRIMARY KEY (tag, content_id);


--
-- Name: text_asset_id; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY text_asset
    ADD CONSTRAINT text_asset_id PRIMARY KEY (text_asset_id);


--
-- Name: user_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: aurita; Tablespace: 
--

ALTER TABLE ONLY user_asset
    ADD CONSTRAINT user_asset_pkey PRIMARY KEY (user_asset_id);


SET search_path = internal, pg_catalog;

--
-- Name: internal_user_group_id_idx; Type: INDEX; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE UNIQUE INDEX internal_user_group_id_idx ON user_group USING btree (user_group_id);


--
-- Name: user_login_data_idx; Type: INDEX; Schema: internal; Owner: aurita; Tablespace: 
--

CREATE UNIQUE INDEX user_login_data_idx ON user_login_data USING btree (user_group_id);


SET search_path = public, pg_catalog;

--
-- Name: category_id_ix; Type: INDEX; Schema: public; Owner: aurita; Tablespace: 
--

CREATE UNIQUE INDEX category_id_ix ON category USING btree (category_id);


--
-- Name: content_id_idz; Type: INDEX; Schema: public; Owner: aurita; Tablespace: 
--

CREATE UNIQUE INDEX content_id_idz ON content USING btree (content_id);


--
-- Name: content_permissions_idx; Type: INDEX; Schema: public; Owner: aurita; Tablespace: 
--

CREATE INDEX content_permissions_idx ON content_permissions USING btree (content_id, user_group_id);


--
-- Name: content_tag_index; Type: INDEX; Schema: public; Owner: aurita; Tablespace: 
--

CREATE INDEX content_tag_index ON content USING btree (tags);


--
-- Name: content_tags_idx; Type: INDEX; Schema: public; Owner: aurita; Tablespace: 
--

CREATE INDEX content_tags_idx ON content USING btree (tags);


--
-- Name: tag_index_idx; Type: INDEX; Schema: public; Owner: aurita; Tablespace: 
--

CREATE UNIQUE INDEX tag_index_idx ON tag_index USING btree (tag, content_id);


--
-- Name: user_action_id_idx; Type: INDEX; Schema: public; Owner: fuchsto; Tablespace: 
--

CREATE UNIQUE INDEX user_action_id_idx ON user_action USING btree (user_action_id);


--
-- Name: user_category_idx; Type: INDEX; Schema: public; Owner: aurita; Tablespace: 
--

CREATE UNIQUE INDEX user_category_idx ON user_category USING btree (user_group_id, category_id);


SET search_path = internal, pg_catalog;

--
-- Name: content_id; Type: FK CONSTRAINT; Schema: internal; Owner: aurita
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT content_id FOREIGN KEY (content_id) REFERENCES public.content(content_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: role_id; Type: FK CONSTRAINT; Schema: internal; Owner: aurita
--

ALTER TABLE ONLY permission
    ADD CONSTRAINT role_id FOREIGN KEY (role_id) REFERENCES role(role_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_group_id; Type: FK CONSTRAINT; Schema: internal; Owner: aurita
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_group_id FOREIGN KEY (user_group_id) REFERENCES user_group(user_group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_group_id; Type: FK CONSTRAINT; Schema: internal; Owner: aurita
--

ALTER TABLE ONLY user_profile
    ADD CONSTRAINT user_group_id FOREIGN KEY (user_group_id) REFERENCES user_group(user_group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_group_id__child; Type: FK CONSTRAINT; Schema: internal; Owner: aurita
--

ALTER TABLE ONLY user_group_hierarchy
    ADD CONSTRAINT user_group_id__child FOREIGN KEY (user_group_id__parent) REFERENCES user_group(user_group_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: user_group_id__parent; Type: FK CONSTRAINT; Schema: internal; Owner: aurita
--

ALTER TABLE ONLY user_group_hierarchy
    ADD CONSTRAINT user_group_id__parent FOREIGN KEY (user_group_id__parent) REFERENCES user_group(user_group_id) ON UPDATE CASCADE ON DELETE RESTRICT;


SET search_path = public, pg_catalog;

--
-- Name: article_content_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY article
    ADD CONSTRAINT article_content_id_fkey FOREIGN KEY (content_id) REFERENCES content(content_id);


--
-- Name: asset_fk; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY media_asset
    ADD CONSTRAINT asset_fk FOREIGN KEY (asset_id) REFERENCES asset(asset_id);


--
-- Name: asset_id; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY media_asset
    ADD CONSTRAINT asset_id FOREIGN KEY (asset_id) REFERENCES asset(asset_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: asset_id; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY text_asset
    ADD CONSTRAINT asset_id FOREIGN KEY (asset_id) REFERENCES asset(asset_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_fk; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY asset
    ADD CONSTRAINT content_fk FOREIGN KEY (content_id) REFERENCES content(content_id);


--
-- Name: content_fk; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY article
    ADD CONSTRAINT content_fk FOREIGN KEY (content_id) REFERENCES content(content_id);


--
-- Name: content_id; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY tag_index
    ADD CONSTRAINT content_id FOREIGN KEY (content_id) REFERENCES content(content_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_id_child; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY container
    ADD CONSTRAINT content_id_child FOREIGN KEY (content_id_child) REFERENCES content(content_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content_id_parent; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY container
    ADD CONSTRAINT content_id_parent FOREIGN KEY (content_id_parent) REFERENCES content(content_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hierarchy_id; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY hierarchy_entry
    ADD CONSTRAINT hierarchy_id FOREIGN KEY (hierarchy_id) REFERENCES hierarchy(hierarchy_id) ON UPDATE CASCADE ON DELETE SET DEFAULT;


--
-- Name: media_asset_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY media_asset
    ADD CONSTRAINT media_asset_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES asset(asset_id);


--
-- Name: text_asset_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY text_asset
    ADD CONSTRAINT text_asset_asset_id_fkey FOREIGN KEY (asset_id) REFERENCES asset(asset_id);


--
-- Name: user_group_id; Type: FK CONSTRAINT; Schema: public; Owner: aurita
--

ALTER TABLE ONLY tag_feed
    ADD CONSTRAINT user_group_id FOREIGN KEY (user_group_id) REFERENCES internal.user_group(user_group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


SET search_path = internal, pg_catalog;

--
-- Name: permission_id_seq; Type: ACL; Schema: internal; Owner: aurita
--

REVOKE ALL ON SEQUENCE permission_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE permission_id_seq FROM aurita;
GRANT SELECT,UPDATE ON SEQUENCE permission_id_seq TO aurita;
GRANT SELECT,UPDATE ON SEQUENCE permission_id_seq TO PUBLIC;


--
-- Name: role_id_seq; Type: ACL; Schema: internal; Owner: aurita
--

REVOKE ALL ON SEQUENCE role_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE role_id_seq FROM aurita;
GRANT SELECT,UPDATE ON SEQUENCE role_id_seq TO aurita;
GRANT SELECT,UPDATE ON SEQUENCE role_id_seq TO PUBLIC;


--
-- Name: role_permission; Type: ACL; Schema: internal; Owner: fuchsto
--

REVOKE ALL ON TABLE role_permission FROM PUBLIC;
REVOKE ALL ON TABLE role_permission FROM fuchsto;
GRANT ALL ON TABLE role_permission TO fuchsto;
GRANT ALL ON TABLE role_permission TO aurita;


--
-- Name: role_permission_id_seq; Type: ACL; Schema: internal; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE role_permission_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE role_permission_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE role_permission_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE role_permission_id_seq TO aurita;


--
-- Name: user_group_id_seq; Type: ACL; Schema: internal; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE user_group_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_group_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE user_group_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE user_group_id_seq TO aurita;


SET search_path = public, pg_catalog;

--
-- Name: archive; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE archive FROM PUBLIC;
REVOKE ALL ON TABLE archive FROM fuchsto;
GRANT ALL ON TABLE archive TO fuchsto;
GRANT ALL ON TABLE archive TO aurita;


--
-- Name: archive_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE archive_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE archive_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE archive_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE archive_id_seq TO aurita;


--
-- Name: archive_run; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE archive_run FROM PUBLIC;
REVOKE ALL ON TABLE archive_run FROM fuchsto;
GRANT ALL ON TABLE archive_run TO fuchsto;
GRANT ALL ON TABLE archive_run TO aurita;


--
-- Name: archive_run_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE archive_run_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE archive_run_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE archive_run_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE archive_run_id_seq TO aurita;


--
-- Name: article; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE article FROM PUBLIC;
REVOKE ALL ON TABLE article FROM aurita;
GRANT ALL ON TABLE article TO aurita;


--
-- Name: article_id_seq; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON SEQUENCE article_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE article_id_seq FROM aurita;
GRANT ALL ON SEQUENCE article_id_seq TO aurita;


--
-- Name: article_layout; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE article_layout FROM PUBLIC;
REVOKE ALL ON TABLE article_layout FROM fuchsto;
GRANT ALL ON TABLE article_layout TO fuchsto;
GRANT ALL ON TABLE article_layout TO aurita;


--
-- Name: article_layout_asset; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE article_layout_asset FROM PUBLIC;
REVOKE ALL ON TABLE article_layout_asset FROM fuchsto;
GRANT ALL ON TABLE article_layout_asset TO fuchsto;
GRANT ALL ON TABLE article_layout_asset TO aurita;


--
-- Name: article_layout_asset_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE article_layout_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE article_layout_asset_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE article_layout_asset_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE article_layout_asset_id_seq TO aurita;


--
-- Name: article_layout_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE article_layout_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE article_layout_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE article_layout_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE article_layout_id_seq TO aurita;


--
-- Name: article_version; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE article_version FROM PUBLIC;
REVOKE ALL ON TABLE article_version FROM fuchsto;
GRANT ALL ON TABLE article_version TO fuchsto;
GRANT ALL ON TABLE article_version TO aurita;


--
-- Name: article_version_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE article_version_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE article_version_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE article_version_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE article_version_id_seq TO aurita;


--
-- Name: banner_ad; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE banner_ad FROM PUBLIC;
REVOKE ALL ON TABLE banner_ad FROM fuchsto;
GRANT ALL ON TABLE banner_ad TO fuchsto;
GRANT ALL ON TABLE banner_ad TO aurita;


--
-- Name: banner_ad_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE banner_ad_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE banner_ad_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE banner_ad_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE banner_ad_id_seq TO aurita;


--
-- Name: bookmark_folder; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE bookmark_folder FROM PUBLIC;
REVOKE ALL ON TABLE bookmark_folder FROM fuchsto;
GRANT ALL ON TABLE bookmark_folder TO fuchsto;
GRANT ALL ON TABLE bookmark_folder TO aurita;


--
-- Name: bookmark_folder_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE bookmark_folder_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE bookmark_folder_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE bookmark_folder_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE bookmark_folder_id_seq TO aurita;


--
-- Name: company_person; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE company_person FROM PUBLIC;
REVOKE ALL ON TABLE company_person FROM fuchsto;
GRANT ALL ON TABLE company_person TO fuchsto;
GRANT ALL ON TABLE company_person TO aurita;


--
-- Name: component_position; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE component_position FROM PUBLIC;
REVOKE ALL ON TABLE component_position FROM fuchsto;
GRANT ALL ON TABLE component_position TO fuchsto;
GRANT ALL ON TABLE component_position TO aurita;


--
-- Name: component_position_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE component_position_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE component_position_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE component_position_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE component_position_id_seq TO aurita;


--
-- Name: contact_company; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE contact_company FROM PUBLIC;
REVOKE ALL ON TABLE contact_company FROM fuchsto;
GRANT ALL ON TABLE contact_company TO fuchsto;
GRANT ALL ON TABLE contact_company TO aurita;


--
-- Name: contact_company_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE contact_company_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE contact_company_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE contact_company_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE contact_company_id_seq TO aurita;


--
-- Name: contact_person; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE contact_person FROM PUBLIC;
REVOKE ALL ON TABLE contact_person FROM aurita;
GRANT ALL ON TABLE contact_person TO aurita;


--
-- Name: contact_person_id_seq; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON SEQUENCE contact_person_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE contact_person_id_seq FROM aurita;
GRANT ALL ON SEQUENCE contact_person_id_seq TO aurita;


--
-- Name: content; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE content FROM PUBLIC;
REVOKE ALL ON TABLE content FROM aurita;
GRANT ALL ON TABLE content TO aurita;


--
-- Name: content_access; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE content_access FROM PUBLIC;
REVOKE ALL ON TABLE content_access FROM fuchsto;
GRANT ALL ON TABLE content_access TO fuchsto;
GRANT ALL ON TABLE content_access TO aurita;


--
-- Name: content_id_seq; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON SEQUENCE content_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE content_id_seq FROM aurita;
GRANT ALL ON SEQUENCE content_id_seq TO aurita;


--
-- Name: content_permissions; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE content_permissions FROM PUBLIC;
REVOKE ALL ON TABLE content_permissions FROM aurita;
GRANT ALL ON TABLE content_permissions TO aurita;


--
-- Name: content_permissions_id_seq; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON SEQUENCE content_permissions_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE content_permissions_id_seq FROM aurita;
GRANT SELECT,UPDATE ON SEQUENCE content_permissions_id_seq TO aurita;


--
-- Name: content_rating; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE content_rating FROM PUBLIC;
REVOKE ALL ON TABLE content_rating FROM aurita;
GRANT ALL ON TABLE content_rating TO aurita;


--
-- Name: feed_cache_entry; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE feed_cache_entry FROM PUBLIC;
REVOKE ALL ON TABLE feed_cache_entry FROM aurita;
GRANT ALL ON TABLE feed_cache_entry TO aurita;


--
-- Name: feed_cache_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE feed_cache_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE feed_cache_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE feed_cache_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE feed_cache_entry_id_seq TO aurita;


--
-- Name: feed_cache_id_seq; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON SEQUENCE feed_cache_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE feed_cache_id_seq FROM aurita;
GRANT SELECT,UPDATE ON SEQUENCE feed_cache_id_seq TO aurita;


--
-- Name: feed_collection; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE feed_collection FROM PUBLIC;
REVOKE ALL ON TABLE feed_collection FROM fuchsto;
GRANT ALL ON TABLE feed_collection TO fuchsto;
GRANT ALL ON TABLE feed_collection TO aurita;


--
-- Name: feed_collection_entry; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE feed_collection_entry FROM PUBLIC;
REVOKE ALL ON TABLE feed_collection_entry FROM fuchsto;
GRANT ALL ON TABLE feed_collection_entry TO fuchsto;
GRANT ALL ON TABLE feed_collection_entry TO aurita;


--
-- Name: feed_collection_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE feed_collection_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE feed_collection_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE feed_collection_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE feed_collection_entry_id_seq TO aurita;


--
-- Name: feed_collection_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE feed_collection_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE feed_collection_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE feed_collection_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE feed_collection_id_seq TO aurita;


--
-- Name: flickr_feed_col_entry; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE flickr_feed_col_entry FROM PUBLIC;
REVOKE ALL ON TABLE flickr_feed_col_entry FROM fuchsto;
GRANT ALL ON TABLE flickr_feed_col_entry TO fuchsto;
GRANT ALL ON TABLE flickr_feed_col_entry TO aurita;


--
-- Name: flickr_feed_col_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE flickr_feed_col_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE flickr_feed_col_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE flickr_feed_col_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE flickr_feed_col_entry_id_seq TO aurita;


--
-- Name: flickr_media_asset; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE flickr_media_asset FROM PUBLIC;
REVOKE ALL ON TABLE flickr_media_asset FROM fuchsto;
GRANT ALL ON TABLE flickr_media_asset TO fuchsto;
GRANT ALL ON TABLE flickr_media_asset TO aurita;


--
-- Name: flickr_media_asset_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE flickr_media_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE flickr_media_asset_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE flickr_media_asset_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE flickr_media_asset_id_seq TO aurita;


--
-- Name: hierarchy_category; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE hierarchy_category FROM PUBLIC;
REVOKE ALL ON TABLE hierarchy_category FROM fuchsto;
GRANT ALL ON TABLE hierarchy_category TO fuchsto;
GRANT ALL ON TABLE hierarchy_category TO aurita;


--
-- Name: media_asset_bookmark; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE media_asset_bookmark FROM PUBLIC;
REVOKE ALL ON TABLE media_asset_bookmark FROM aurita;
GRANT ALL ON TABLE media_asset_bookmark TO aurita;


--
-- Name: media_asset_download; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE media_asset_download FROM PUBLIC;
REVOKE ALL ON TABLE media_asset_download FROM fuchsto;
GRANT ALL ON TABLE media_asset_download TO fuchsto;
GRANT ALL ON TABLE media_asset_download TO aurita;


--
-- Name: media_asset_download_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE media_asset_download_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE media_asset_download_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE media_asset_download_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE media_asset_download_id_seq TO aurita;


--
-- Name: media_asset_folder; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE media_asset_folder FROM PUBLIC;
REVOKE ALL ON TABLE media_asset_folder FROM aurita;
GRANT ALL ON TABLE media_asset_folder TO aurita;
GRANT ALL ON TABLE media_asset_folder TO PUBLIC;


--
-- Name: media_asset_folder_category; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE media_asset_folder_category FROM PUBLIC;
REVOKE ALL ON TABLE media_asset_folder_category FROM fuchsto;
GRANT ALL ON TABLE media_asset_folder_category TO fuchsto;
GRANT ALL ON TABLE media_asset_folder_category TO aurita;


--
-- Name: media_asset_folder_category_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE media_asset_folder_category_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE media_asset_folder_category_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE media_asset_folder_category_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE media_asset_folder_category_id_seq TO aurita;


--
-- Name: media_asset_version; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE media_asset_version FROM PUBLIC;
REVOKE ALL ON TABLE media_asset_version FROM fuchsto;
GRANT ALL ON TABLE media_asset_version TO fuchsto;
GRANT ALL ON TABLE media_asset_version TO aurita;


--
-- Name: media_asset_version_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE media_asset_version_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE media_asset_version_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE media_asset_version_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE media_asset_version_id_seq TO aurita;


--
-- Name: media_container; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE media_container FROM PUBLIC;
REVOKE ALL ON TABLE media_container FROM fuchsto;
GRANT ALL ON TABLE media_container TO fuchsto;
GRANT ALL ON TABLE media_container TO aurita;


--
-- Name: media_container_entry; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE media_container_entry FROM PUBLIC;
REVOKE ALL ON TABLE media_container_entry FROM fuchsto;
GRANT ALL ON TABLE media_container_entry TO fuchsto;
GRANT ALL ON TABLE media_container_entry TO aurita;


--
-- Name: media_container_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE media_container_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE media_container_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE media_container_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE media_container_entry_id_seq TO aurita;


--
-- Name: media_container_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE media_container_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE media_container_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE media_container_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE media_container_id_seq TO aurita;


--
-- Name: media_iptc; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE media_iptc FROM PUBLIC;
REVOKE ALL ON TABLE media_iptc FROM fuchsto;
GRANT ALL ON TABLE media_iptc TO fuchsto;
GRANT ALL ON TABLE media_iptc TO aurita;


--
-- Name: memo_article; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE memo_article FROM PUBLIC;
REVOKE ALL ON TABLE memo_article FROM fuchsto;
GRANT ALL ON TABLE memo_article TO fuchsto;
GRANT ALL ON TABLE memo_article TO aurita;


--
-- Name: memo_article_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE memo_article_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE memo_article_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE memo_article_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE memo_article_id_seq TO aurita;


--
-- Name: movie_voter_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE movie_voter_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE movie_voter_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE movie_voter_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE movie_voter_id_seq TO aurita;


--
-- Name: movie_voting_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE movie_voting_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE movie_voting_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE movie_voting_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE movie_voting_id_seq TO aurita;


--
-- Name: page; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE page FROM PUBLIC;
REVOKE ALL ON TABLE page FROM fuchsto;
GRANT ALL ON TABLE page TO fuchsto;
GRANT ALL ON TABLE page TO aurita;


--
-- Name: page_element; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE page_element FROM PUBLIC;
REVOKE ALL ON TABLE page_element FROM fuchsto;
GRANT ALL ON TABLE page_element TO fuchsto;
GRANT ALL ON TABLE page_element TO aurita;


--
-- Name: page_element_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE page_element_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE page_element_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE page_element_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE page_element_id_seq TO aurita;


--
-- Name: page_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE page_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE page_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE page_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE page_id_seq TO aurita;


--
-- Name: poll; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE poll FROM PUBLIC;
REVOKE ALL ON TABLE poll FROM fuchsto;
GRANT ALL ON TABLE poll TO fuchsto;
GRANT ALL ON TABLE poll TO aurita;


--
-- Name: poll_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE poll_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE poll_id_seq FROM fuchsto;
GRANT SELECT,UPDATE ON SEQUENCE poll_id_seq TO fuchsto;
GRANT SELECT,UPDATE ON SEQUENCE poll_id_seq TO aurita;


--
-- Name: poll_voting; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE poll_voting FROM PUBLIC;
REVOKE ALL ON TABLE poll_voting FROM fuchsto;
GRANT ALL ON TABLE poll_voting TO fuchsto;
GRANT ALL ON TABLE poll_voting TO aurita;


--
-- Name: poll_voting_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE poll_voting_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE poll_voting_id_seq FROM fuchsto;
GRANT SELECT,UPDATE ON SEQUENCE poll_voting_id_seq TO fuchsto;
GRANT SELECT,UPDATE ON SEQUENCE poll_voting_id_seq TO aurita;


--
-- Name: shoutbox_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE shoutbox_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE shoutbox_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE shoutbox_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE shoutbox_id_seq TO aurita;


--
-- Name: tag_blacklist; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON TABLE tag_blacklist FROM PUBLIC;
REVOKE ALL ON TABLE tag_blacklist FROM aurita;
GRANT ALL ON TABLE tag_blacklist TO aurita;


--
-- Name: tag_synonym; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE tag_synonym FROM PUBLIC;
REVOKE ALL ON TABLE tag_synonym FROM fuchsto;
GRANT ALL ON TABLE tag_synonym TO fuchsto;
GRANT ALL ON TABLE tag_synonym TO aurita;


--
-- Name: todo_asset; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_asset FROM fuchsto;
GRANT ALL ON TABLE todo_asset TO fuchsto;
GRANT ALL ON TABLE todo_asset TO aurita;


--
-- Name: todo_asset_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_asset_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_asset_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_asset_id_seq TO aurita;


--
-- Name: todo_basic_asset; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_basic_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_basic_asset FROM fuchsto;
GRANT ALL ON TABLE todo_basic_asset TO fuchsto;
GRANT ALL ON TABLE todo_basic_asset TO aurita;


--
-- Name: todo_basic_asset_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_basic_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_basic_asset_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_basic_asset_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_basic_asset_id_seq TO aurita;


--
-- Name: todo_calculation_asset; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_calculation_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_calculation_asset FROM fuchsto;
GRANT ALL ON TABLE todo_calculation_asset TO fuchsto;
GRANT ALL ON TABLE todo_calculation_asset TO aurita;


--
-- Name: todo_calculation_asset_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_calculation_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_calculation_asset_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_calculation_asset_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_calculation_asset_id_seq TO aurita;


--
-- Name: todo_calculation_entry; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_calculation_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_calculation_entry FROM fuchsto;
GRANT ALL ON TABLE todo_calculation_entry TO fuchsto;
GRANT ALL ON TABLE todo_calculation_entry TO aurita;


--
-- Name: todo_calculation_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_calculation_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_calculation_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_calculation_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_calculation_entry_id_seq TO aurita;


--
-- Name: todo_container_asset; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_container_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_container_asset FROM fuchsto;
GRANT ALL ON TABLE todo_container_asset TO fuchsto;
GRANT ALL ON TABLE todo_container_asset TO aurita;


--
-- Name: todo_container_asset_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_container_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_container_asset_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_container_asset_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_container_asset_id_seq TO aurita;


--
-- Name: todo_container_entry; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_container_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_container_entry FROM fuchsto;
GRANT ALL ON TABLE todo_container_entry TO fuchsto;
GRANT ALL ON TABLE todo_container_entry TO aurita;


--
-- Name: todo_container_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_container_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_container_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_container_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_container_entry_id_seq TO aurita;


--
-- Name: todo_entry; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_entry FROM fuchsto;
GRANT ALL ON TABLE todo_entry TO fuchsto;
GRANT ALL ON TABLE todo_entry TO aurita;


--
-- Name: todo_entry_history; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_entry_history FROM PUBLIC;
REVOKE ALL ON TABLE todo_entry_history FROM fuchsto;
GRANT ALL ON TABLE todo_entry_history TO fuchsto;
GRANT ALL ON TABLE todo_entry_history TO aurita;


--
-- Name: todo_entry_history_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_entry_history_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_entry_history_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_entry_history_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_entry_history_id_seq TO aurita;


--
-- Name: todo_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_entry_id_seq TO aurita;


--
-- Name: todo_entry_user; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_entry_user FROM PUBLIC;
REVOKE ALL ON TABLE todo_entry_user FROM fuchsto;
GRANT ALL ON TABLE todo_entry_user TO fuchsto;
GRANT ALL ON TABLE todo_entry_user TO aurita;


--
-- Name: todo_entry_user_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_entry_user_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_entry_user_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_entry_user_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_entry_user_id_seq TO aurita;


--
-- Name: todo_time_calc_asset; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_time_calc_asset FROM PUBLIC;
REVOKE ALL ON TABLE todo_time_calc_asset FROM fuchsto;
GRANT ALL ON TABLE todo_time_calc_asset TO fuchsto;
GRANT ALL ON TABLE todo_time_calc_asset TO aurita;


--
-- Name: todo_time_calc_asset_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_time_calc_asset_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_time_calc_asset_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_time_calc_asset_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_time_calc_asset_id_seq TO aurita;


--
-- Name: todo_time_calc_entry; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE todo_time_calc_entry FROM PUBLIC;
REVOKE ALL ON TABLE todo_time_calc_entry FROM fuchsto;
GRANT ALL ON TABLE todo_time_calc_entry TO fuchsto;
GRANT ALL ON TABLE todo_time_calc_entry TO aurita;


--
-- Name: todo_time_calc_entry_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE todo_time_calc_entry_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE todo_time_calc_entry_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE todo_time_calc_entry_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE todo_time_calc_entry_id_seq TO aurita;


--
-- Name: user_action; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON TABLE user_action FROM PUBLIC;
REVOKE ALL ON TABLE user_action FROM fuchsto;
GRANT ALL ON TABLE user_action TO fuchsto;
GRANT ALL ON TABLE user_action TO aurita;


--
-- Name: user_action_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE user_action_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_action_id_seq FROM fuchsto;
GRANT ALL ON SEQUENCE user_action_id_seq TO fuchsto;
GRANT ALL ON SEQUENCE user_action_id_seq TO aurita;


--
-- Name: user_message_id_seq; Type: ACL; Schema: public; Owner: aurita
--

REVOKE ALL ON SEQUENCE user_message_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_message_id_seq FROM aurita;
GRANT SELECT,UPDATE ON SEQUENCE user_message_id_seq TO aurita;


--
-- Name: user_profile_config_id_seq; Type: ACL; Schema: public; Owner: fuchsto
--

REVOKE ALL ON SEQUENCE user_profile_config_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE user_profile_config_id_seq FROM fuchsto;
GRANT SELECT,UPDATE ON SEQUENCE user_profile_config_id_seq TO fuchsto;
GRANT SELECT,UPDATE ON SEQUENCE user_profile_config_id_seq TO aurita;


--
-- PostgreSQL database dump complete
--

