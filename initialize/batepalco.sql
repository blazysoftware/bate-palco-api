--
-- PostgreSQL database dump
--

\restrict Hg1yoftnY6xm67d95jkFoASG7idVDMtXyuAM4mIYR0NWqOB38i0aTZe73t5HWy2

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg12+1)
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: directus_access; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_access (
    id uuid NOT NULL,
    role uuid,
    "user" uuid,
    policy uuid NOT NULL,
    sort integer
);


ALTER TABLE public.directus_access OWNER TO postgres;

--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_activity (
    id integer NOT NULL,
    action character varying(45) NOT NULL,
    "user" uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip character varying(50),
    user_agent text,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    origin character varying(255)
);


ALTER TABLE public.directus_activity OWNER TO postgres;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_activity_id_seq OWNER TO postgres;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_collections (
    collection character varying(64) NOT NULL,
    icon character varying(64),
    note text,
    display_template character varying(255),
    hidden boolean DEFAULT false NOT NULL,
    singleton boolean DEFAULT false NOT NULL,
    translations json,
    archive_field character varying(64),
    archive_app_filter boolean DEFAULT true NOT NULL,
    archive_value character varying(255),
    unarchive_value character varying(255),
    sort_field character varying(64),
    accountability character varying(255) DEFAULT 'all'::character varying,
    color character varying(255),
    item_duplication_fields json,
    sort integer,
    "group" character varying(64),
    collapse character varying(255) DEFAULT 'open'::character varying NOT NULL,
    preview_url character varying(255),
    versioning boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_collections OWNER TO postgres;

--
-- Name: directus_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_comments (
    id uuid NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    comment text NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.directus_comments OWNER TO postgres;

--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_dashboards (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64) DEFAULT 'dashboard'::character varying NOT NULL,
    note text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    color character varying(255)
);


ALTER TABLE public.directus_dashboards OWNER TO postgres;

--
-- Name: directus_extensions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_extensions (
    enabled boolean DEFAULT true NOT NULL,
    id uuid NOT NULL,
    folder character varying(255) NOT NULL,
    source character varying(255) NOT NULL,
    bundle uuid
);


ALTER TABLE public.directus_extensions OWNER TO postgres;

--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_fields (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    field character varying(64) NOT NULL,
    special character varying(64),
    interface character varying(64),
    options json,
    display character varying(64),
    display_options json,
    readonly boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    sort integer,
    width character varying(30) DEFAULT 'full'::character varying,
    translations json,
    note text,
    conditions json,
    required boolean DEFAULT false,
    "group" character varying(64),
    validation json,
    validation_message text
);


ALTER TABLE public.directus_fields OWNER TO postgres;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_fields_id_seq OWNER TO postgres;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_files (
    id uuid NOT NULL,
    storage character varying(255) NOT NULL,
    filename_disk character varying(255),
    filename_download character varying(255) NOT NULL,
    title character varying(255),
    type character varying(255),
    folder uuid,
    uploaded_by uuid,
    created_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by uuid,
    modified_on timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset character varying(50),
    filesize bigint,
    width integer,
    height integer,
    duration integer,
    embed character varying(200),
    description text,
    location text,
    tags text,
    metadata json,
    focal_point_x integer,
    focal_point_y integer,
    tus_id character varying(64),
    tus_data json,
    uploaded_on timestamp with time zone
);


ALTER TABLE public.directus_files OWNER TO postgres;

--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_flows (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    icon character varying(64),
    color character varying(255),
    description text,
    status character varying(255) DEFAULT 'active'::character varying NOT NULL,
    trigger character varying(255),
    accountability character varying(255) DEFAULT 'all'::character varying,
    options json,
    operation uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_flows OWNER TO postgres;

--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_folders (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders OWNER TO postgres;

--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_migrations (
    version character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations OWNER TO postgres;

--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_notifications (
    id integer NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT 'inbox'::character varying,
    recipient uuid NOT NULL,
    sender uuid,
    subject character varying(255) NOT NULL,
    message text,
    collection character varying(64),
    item character varying(255)
);


ALTER TABLE public.directus_notifications OWNER TO postgres;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_notifications_id_seq OWNER TO postgres;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_operations (
    id uuid NOT NULL,
    name character varying(255),
    key character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    options json,
    resolve uuid,
    reject uuid,
    flow uuid NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations OWNER TO postgres;

--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_panels (
    id uuid NOT NULL,
    dashboard uuid NOT NULL,
    name character varying(255),
    icon character varying(64) DEFAULT NULL::character varying,
    color character varying(10),
    show_header boolean DEFAULT false NOT NULL,
    note text,
    type character varying(255) NOT NULL,
    position_x integer NOT NULL,
    position_y integer NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    options json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels OWNER TO postgres;

--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_permissions (
    id integer NOT NULL,
    collection character varying(64) NOT NULL,
    action character varying(10) NOT NULL,
    permissions json,
    validation json,
    presets json,
    fields text,
    policy uuid NOT NULL
);


ALTER TABLE public.directus_permissions OWNER TO postgres;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_permissions_id_seq OWNER TO postgres;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- Name: directus_policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_policies (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'badge'::character varying NOT NULL,
    description text,
    ip_access text,
    enforce_tfa boolean DEFAULT false NOT NULL,
    admin_access boolean DEFAULT false NOT NULL,
    app_access boolean DEFAULT false NOT NULL
);


ALTER TABLE public.directus_policies OWNER TO postgres;

--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_presets (
    id integer NOT NULL,
    bookmark character varying(255),
    "user" uuid,
    role uuid,
    collection character varying(64),
    search character varying(100),
    layout character varying(100) DEFAULT 'tabular'::character varying,
    layout_query json,
    layout_options json,
    refresh_interval integer,
    filter json,
    icon character varying(64) DEFAULT 'bookmark'::character varying,
    color character varying(255)
);


ALTER TABLE public.directus_presets OWNER TO postgres;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_presets_id_seq OWNER TO postgres;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_relations (
    id integer NOT NULL,
    many_collection character varying(64) NOT NULL,
    many_field character varying(64) NOT NULL,
    one_collection character varying(64),
    one_field character varying(64),
    one_collection_field character varying(64),
    one_allowed_collections text,
    junction_field character varying(64),
    sort_field character varying(64),
    one_deselect_action character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations OWNER TO postgres;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_relations_id_seq OWNER TO postgres;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_revisions (
    id integer NOT NULL,
    activity integer NOT NULL,
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    data json,
    delta json,
    parent integer,
    version uuid
);


ALTER TABLE public.directus_revisions OWNER TO postgres;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_revisions_id_seq OWNER TO postgres;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_roles (
    id uuid NOT NULL,
    name character varying(100) NOT NULL,
    icon character varying(64) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description text,
    parent uuid
);


ALTER TABLE public.directus_roles OWNER TO postgres;

--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_sessions (
    token character varying(64) NOT NULL,
    "user" uuid,
    expires timestamp with time zone NOT NULL,
    ip character varying(255),
    user_agent text,
    share uuid,
    origin character varying(255),
    next_token character varying(64)
);


ALTER TABLE public.directus_sessions OWNER TO postgres;

--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_settings (
    id integer NOT NULL,
    project_name character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url character varying(255),
    project_color character varying(255) DEFAULT '#6644FF'::character varying NOT NULL,
    project_logo uuid,
    public_foreground uuid,
    public_background uuid,
    public_note text,
    auth_login_attempts integer DEFAULT 25,
    auth_password_policy character varying(100),
    storage_asset_transform character varying(7) DEFAULT 'all'::character varying,
    storage_asset_presets json,
    custom_css text,
    storage_default_folder uuid,
    basemaps json,
    mapbox_key character varying(255),
    module_bar json,
    project_descriptor character varying(100),
    default_language character varying(255) DEFAULT 'en-US'::character varying NOT NULL,
    custom_aspect_ratios json,
    public_favicon uuid,
    default_appearance character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    default_theme_light character varying(255),
    theme_light_overrides json,
    default_theme_dark character varying(255),
    theme_dark_overrides json,
    report_error_url character varying(255),
    report_bug_url character varying(255),
    report_feature_url character varying(255),
    public_registration boolean DEFAULT false NOT NULL,
    public_registration_verify_email boolean DEFAULT true NOT NULL,
    public_registration_role uuid,
    public_registration_email_filter json,
    visual_editor_urls json,
    accepted_terms boolean DEFAULT false,
    project_id uuid,
    mcp_enabled boolean DEFAULT false NOT NULL,
    mcp_allow_deletes boolean DEFAULT false NOT NULL,
    mcp_prompts_collection character varying(255) DEFAULT NULL::character varying,
    mcp_system_prompt_enabled boolean DEFAULT true NOT NULL,
    mcp_system_prompt text
);


ALTER TABLE public.directus_settings OWNER TO postgres;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_settings_id_seq OWNER TO postgres;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_shares (
    id uuid NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    role uuid,
    password character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start timestamp with time zone,
    date_end timestamp with time zone,
    times_used integer DEFAULT 0,
    max_uses integer
);


ALTER TABLE public.directus_shares OWNER TO postgres;

--
-- Name: directus_translations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_translations (
    id uuid NOT NULL,
    language character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.directus_translations OWNER TO postgres;

--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_users (
    id uuid NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    email character varying(128),
    password character varying(255),
    location character varying(255),
    title character varying(50),
    description text,
    tags json,
    avatar uuid,
    language character varying(255) DEFAULT NULL::character varying,
    tfa_secret character varying(255),
    status character varying(16) DEFAULT 'active'::character varying NOT NULL,
    role uuid,
    token character varying(255),
    last_access timestamp with time zone,
    last_page character varying(255),
    provider character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier character varying(255),
    auth_data json,
    email_notifications boolean DEFAULT true,
    appearance character varying(255),
    theme_dark character varying(255),
    theme_light character varying(255),
    theme_light_overrides json,
    theme_dark_overrides json,
    text_direction character varying(255) DEFAULT 'auto'::character varying NOT NULL,
    plan character varying(50) DEFAULT 'free'::character varying,
    stage_name character varying(255) DEFAULT NULL::character varying,
    bio text,
    photo uuid
);


ALTER TABLE public.directus_users OWNER TO postgres;

--
-- Name: directus_versions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_versions (
    id uuid NOT NULL,
    key character varying(64) NOT NULL,
    name character varying(255),
    collection character varying(64) NOT NULL,
    item character varying(255) NOT NULL,
    hash character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid,
    delta json
);


ALTER TABLE public.directus_versions OWNER TO postgres;

--
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directus_webhooks (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    method character varying(10) DEFAULT 'POST'::character varying NOT NULL,
    url character varying(255) NOT NULL,
    status character varying(10) DEFAULT 'active'::character varying NOT NULL,
    data boolean DEFAULT true NOT NULL,
    actions character varying(100) NOT NULL,
    collections character varying(255) NOT NULL,
    headers json,
    was_active_before_deprecation boolean DEFAULT false NOT NULL,
    migrated_flow uuid
);


ALTER TABLE public.directus_webhooks OWNER TO postgres;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_webhooks_id_seq OWNER TO postgres;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- Name: live_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.live_sessions (
    id uuid NOT NULL,
    live uuid NOT NULL,
    artist uuid NOT NULL,
    name character varying(255) DEFAULT NULL::character varying,
    status character varying(255) DEFAULT NULL::character varying,
    started_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    ended_at timestamp without time zone,
    where_are_you json
);


ALTER TABLE public.live_sessions OWNER TO postgres;

--
-- Name: lives; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lives (
    id uuid NOT NULL,
    date_created timestamp with time zone,
    name character varying(255) DEFAULT NULL::character varying,
    slug character varying(255) DEFAULT NULL::character varying,
    reusable boolean DEFAULT true NOT NULL,
    is_public boolean DEFAULT true NOT NULL,
    max_messages_per_client integer DEFAULT 5,
    comment_cooldown_seconds integer DEFAULT 10,
    max_song_requests_per_client integer DEFAULT 5,
    status character varying(255) DEFAULT 'offline'::character varying,
    date_event timestamp without time zone,
    singer uuid
);


ALTER TABLE public.lives OWNER TO postgres;

--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid NOT NULL,
    live uuid NOT NULL,
    session uuid,
    sender_type character varying(255) DEFAULT NULL::character varying,
    sender_name character varying(255) DEFAULT NULL::character varying,
    sender_user uuid,
    content text,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reactions json,
    visibility json,
    is_super boolean DEFAULT false,
    is_hidden boolean DEFAULT false,
    key_live uuid,
    linked_request uuid
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.requests (
    id uuid NOT NULL,
    live uuid NOT NULL,
    session uuid,
    song uuid,
    status character varying(255) DEFAULT NULL::character varying,
    requested_by character varying(255) DEFAULT NULL::character varying,
    requested_user uuid,
    requested_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    reactions json,
    is_super boolean DEFAULT false,
    superchat_type character varying(255) DEFAULT NULL::character varying,
    played_at timestamp without time zone,
    answered_at timestamp without time zone,
    accepted_by uuid,
    key_live uuid
);


ALTER TABLE public.requests OWNER TO postgres;

--
-- Name: songs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.songs (
    id uuid NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    artist_name character varying(255) DEFAULT NULL::character varying,
    recommended boolean DEFAULT false,
    owner uuid
);


ALTER TABLE public.songs OWNER TO postgres;

--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suggestions (
    id uuid NOT NULL,
    live uuid NOT NULL,
    session uuid,
    title character varying(255) DEFAULT NULL::character varying,
    artist_name character varying(255) DEFAULT NULL::character varying,
    observations text,
    suggested_by character varying(255) DEFAULT NULL::character varying,
    suggested_user uuid,
    suggested_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.suggestions OWNER TO postgres;

--
-- Name: themes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.themes (
    id uuid NOT NULL,
    owner uuid NOT NULL,
    mode character varying(255) DEFAULT NULL::character varying,
    color1 character varying(255) DEFAULT NULL::character varying,
    color2 character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.themes OWNER TO postgres;

--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_activity ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_fields ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_notifications ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_permissions ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_presets ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_relations ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_revisions ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_webhooks ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- Data for Name: directus_access; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_access (id, role, "user", policy, sort) FROM stdin;
f22dfc76-6667-4d81-932c-c87fa2528514	\N	\N	abf8a154-5b1c-4a46-ac9c-7300570f4f17	1
1474e3d1-9472-44c1-b645-79fde5ab97c2	fba63509-785a-4c2c-af41-8397ba8a9a7b	\N	b7bebd5f-3dfd-475d-91f0-1e4d7c73686c	\N
9d6c9ee8-dfd3-48cf-a148-f9453928ca6b	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	25c07c57-7443-404e-80ee-6ea165f7a203	1
e0259e7c-3021-4bd7-93e0-3d8071a0d2d0	dc4028dd-0496-404c-9735-b6db096efe4a	\N	a55ebdcc-8f22-483c-8c27-00bc458cfbed	1
\.


--
-- Data for Name: directus_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_activity (id, action, "user", "timestamp", ip, user_agent, collection, item, origin) FROM stdin;
1	login	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:13:46.642+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6074c864-6a99-4c14-b4cb-41be600454ff	http://localhost:8055
2	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:13:50.432+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
3	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.703+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	07848022-9b32-46be-9b50-5b58efd91f31	http://localhost:8055
4	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.73+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	277dccb4-52c4-487e-99fd-aaafa1d073d0	http://localhost:8055
5	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.754+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	3c5f8ac5-dbd2-4a72-b782-1879459cd033	http://localhost:8055
6	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.78+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	6d947c5f-7d7d-45dd-96d9-eb807d69b23b	http://localhost:8055
7	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.806+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	9df37e61-0801-411d-a627-066b7784df84	http://localhost:8055
8	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.848+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	a34e5d76-06ba-411c-9443-fec304561d28	http://localhost:8055
9	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.876+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	ae0d72d0-3821-4ffd-b5ad-04692e1fdf30	http://localhost:8055
10	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.903+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	b8004aa5-583f-4db1-ba8e-b7375031fd05	http://localhost:8055
11	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.928+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	ba58e856-1838-4685-b89f-5eeb6d702158	http://localhost:8055
12	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:48.953+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	live_sessions	ea434c1f-5bff-4047-b8fe-67adffb0c373	http://localhost:8055
13	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.561+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	011144c7-5c38-4db9-8fb2-ca1b4118b85c	http://localhost:8055
14	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.589+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	024299d0-f0b9-4898-89b2-2f999b03ddc4	http://localhost:8055
15	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.613+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	0e042da6-7d06-4b1b-b1b2-29d460f8ba21	http://localhost:8055
16	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.641+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	11d4eff5-f8cb-4cfd-9dd3-c109656c51c5	http://localhost:8055
17	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.668+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	1cac7aa3-9c8c-43cd-906d-b60c10f8c8dd	http://localhost:8055
18	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.692+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	1f485870-b930-414d-95f8-ee1cbee9c6e7	http://localhost:8055
19	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.718+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	2e3cd03b-a6b3-4d3e-a930-2ca79ad44737	http://localhost:8055
20	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.753+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	36f8ae51-d0a6-416f-b3e9-c8f6c2971fa4	http://localhost:8055
21	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.816+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	457e6034-a9e6-4720-93ba-c327dedfcce7	http://localhost:8055
22	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.845+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	4e2e1725-aaae-49db-a34d-e35958501514	http://localhost:8055
23	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.869+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	6a215c7a-5028-409e-ba95-b90a8ecb3a06	http://localhost:8055
24	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.893+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	83e550d2-2384-4c46-ae66-508228ccfc97	http://localhost:8055
25	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.919+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	86acbfd8-44c3-4cb9-bbc0-b3e47667f74c	http://localhost:8055
26	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.945+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	9201a835-01fc-4158-9e43-11827e9028e6	http://localhost:8055
27	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.97+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	9604b649-11ec-439e-9ef3-d53eb58db24a	http://localhost:8055
28	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:55.993+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	bdcff69c-4bf8-4166-9d09-3c6e053985bf	http://localhost:8055
29	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:56.019+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	c3cb34e5-742c-4da9-a339-ede158b8da3e	http://localhost:8055
30	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:56.048+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	c47f9049-12f6-48de-a0a2-849257eea863	http://localhost:8055
31	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:56.075+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	ea227d02-85db-4f90-90a8-20f5b763b56b	http://localhost:8055
32	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:19:56.101+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	lives	f79c98dc-192d-4730-8375-08c56746a016	http://localhost:8055
33	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:03.963+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	00fdcb24-281a-4a05-9500-e49ea36c4c3d	http://localhost:8055
34	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:03.987+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	0285f259-82a4-40d3-a8c0-d0a70fdb7017	http://localhost:8055
35	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.011+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	043b1b96-4f7c-4615-b599-8100d8cff767	http://localhost:8055
36	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.035+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	0483dd46-d0e8-4a99-a502-9d859fedc8d3	http://localhost:8055
37	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.058+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	04d61df9-eb5f-4391-8018-d489c5756034	http://localhost:8055
38	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.081+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	0506707b-4ee9-48b5-ae4a-0fd3899b12ea	http://localhost:8055
39	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.105+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	0635e751-a8fc-4ff4-b03e-2079b079c93a	http://localhost:8055
40	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.166+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	068ddb4b-cdc3-44de-8ed3-5c4cb02f9f6f	http://localhost:8055
41	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.191+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	09392139-0165-4640-a77e-a2b6a12da47e	http://localhost:8055
42	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.219+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	09b88365-0215-450d-9e22-ad02c10de7a4	http://localhost:8055
43	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.243+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	0ba0f00e-b24e-4ec1-a475-4c8dae971ac0	http://localhost:8055
44	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.267+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	0db13b88-681c-44fc-b227-87c812f4de5c	http://localhost:8055
45	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.293+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	0e091262-b4a7-48f4-8858-1412e47d287f	http://localhost:8055
46	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.319+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	126b1118-9b02-4ae6-a469-37c7da59f745	http://localhost:8055
47	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.344+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1713fd0c-09b0-4c1d-b6be-ff2386fa2987	http://localhost:8055
48	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.369+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	19eaf29c-b093-47de-9cb4-01434848c161	http://localhost:8055
49	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.393+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1a411c82-d6ff-4373-92e9-db121ebf8a4d	http://localhost:8055
50	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.448+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1abc0989-ead4-458f-a57b-4133c8f906c9	http://localhost:8055
51	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.474+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1cd1794c-8109-4197-afd5-8316c6704bb5	http://localhost:8055
52	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.498+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1dbcda08-40de-4a84-9496-45869a911ed9	http://localhost:8055
53	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.535+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1e92729d-24dc-44df-ab57-1becef36d3fd	http://localhost:8055
54	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.563+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1eb934f1-597e-43ec-aae0-ec73519d6fa9	http://localhost:8055
55	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.589+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	1ef0a166-12f5-4cd2-9af2-949a57f784aa	http://localhost:8055
56	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.617+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	20c55091-cf62-4ca6-8f98-ff6a4a72b2cc	http://localhost:8055
57	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:04.642+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	24bef3a4-c5ac-449d-8ace-fe7bf530a590	http://localhost:8055
58	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.568+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	283753bc-90c2-474e-b58c-6772edb2ebaf	http://localhost:8055
343	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:13.676+00	127.0.0.1	node	directus_permissions	36	\N
59	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.595+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	2e11477b-bd63-4919-b5f2-6e718274254e	http://localhost:8055
60	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.621+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	2f440af1-28b9-4b7a-8eec-c36619b2d453	http://localhost:8055
61	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.647+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	303c7811-ea08-4d68-ab70-7b897e3e4009	http://localhost:8055
62	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.669+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	31c3b770-d1c2-4d0b-b50e-3fb547578909	http://localhost:8055
63	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.693+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	326263d9-387f-4152-8071-851fe50f9f5d	http://localhost:8055
64	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.746+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	3505359f-98e1-42b6-9dec-cf98856fdce4	http://localhost:8055
65	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.77+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	36c813c4-b65e-4517-a076-aa07e2ead3b1	http://localhost:8055
66	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.795+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	3a77ad75-6a5a-40b5-90e1-ce3cf1cb2cbf	http://localhost:8055
67	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.819+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	3b6b0b02-7bf9-4704-b0bf-043aafcf759a	http://localhost:8055
68	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.849+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	3c24199a-26a7-4891-a10c-f6e4cad7b7d4	http://localhost:8055
69	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.874+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	3e7ff291-a152-48a6-bc91-6270795821b6	http://localhost:8055
70	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.901+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	40c00a1d-fa48-40a3-ab16-69433b43a527	http://localhost:8055
71	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.929+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	435fc3b7-ad12-4c5f-9225-9c21c2fed0bc	http://localhost:8055
72	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.952+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	43a78ad8-4e6a-41a0-bad6-d71e044d2c93	http://localhost:8055
73	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:16.977+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	46fef9c7-4b8f-4a94-869e-b2c3a635df2d	http://localhost:8055
74	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.006+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	47b05ae1-1b58-49f8-ab12-9957c18e66f2	http://localhost:8055
75	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.053+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	4d49dff2-ccce-42b3-b109-ac1ca4874d4a	http://localhost:8055
76	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.078+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	511e19ba-a4d4-4e45-93f3-a34872853098	http://localhost:8055
77	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.103+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	54197a16-b37d-4da8-ab26-4d47a2b297cf	http://localhost:8055
78	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.13+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	57ff61ea-0a22-4596-a5da-9249ec4dc658	http://localhost:8055
79	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.309+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	5b2dc247-0bd4-4318-81f2-57715dfc5297	http://localhost:8055
80	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.346+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	5b93e1f1-9cb5-4ff8-8edc-e6ccab2acd25	http://localhost:8055
81	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.371+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	5e696f69-da34-40d3-9b17-163cc6ec3acf	http://localhost:8055
82	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.395+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	5ed6b4bb-05ee-41d5-8520-cc47600ec6dd	http://localhost:8055
83	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.42+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	5f0d7fd4-2fe9-4959-a17f-edeeecdc3fac	http://localhost:8055
84	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.443+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	60dc86ad-89bc-48b5-b384-e187d328a74e	http://localhost:8055
85	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.469+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	638dc729-8ced-44fd-902b-8a446c7a4211	http://localhost:8055
86	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.495+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	67f7cc00-0793-4594-92c8-a79389dfd2c2	http://localhost:8055
87	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.52+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	69dbc85a-13f7-4649-8fa5-4a5f443a827f	http://localhost:8055
344	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:15.648+00	127.0.0.1	node	directus_permissions	37	\N
88	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.546+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	6f4c0f78-6ebb-4a7d-b801-08172d7d5fcf	http://localhost:8055
89	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.607+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	6fedb113-5fb9-41eb-99eb-f8732d09d64d	http://localhost:8055
90	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.646+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7279ab05-770b-4c9c-8d97-918f94ae9ca2	http://localhost:8055
91	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.671+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	73428554-d26e-4170-9d47-c3cd78f4c106	http://localhost:8055
92	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.696+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	751bd866-01f6-4444-8e0e-a5c2afbf8880	http://localhost:8055
93	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.724+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	78161341-b487-43f3-9c78-f4ff5e6c0666	http://localhost:8055
94	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.749+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	79261a41-ce9b-47f2-99ca-4ab8946b9c1e	http://localhost:8055
95	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.774+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	794662dd-05c9-46ef-84e9-b84c70524e42	http://localhost:8055
96	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.799+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7a004a32-591a-4874-8bc8-c0d4dc96acfc	http://localhost:8055
97	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.822+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7aff8b25-b6cd-4249-866e-6844e2c9c618	http://localhost:8055
98	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.851+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7c73eac9-0fbd-4bb2-ac93-a532faec8b00	http://localhost:8055
99	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.877+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7c9b76a8-cce2-4b4a-b866-d7f4d6309219	http://localhost:8055
100	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.904+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7d9ff1ab-8a4c-435a-b697-71d848b7a56f	http://localhost:8055
101	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.948+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7dbf5b71-2102-4a05-9e88-5d545c0b0cbd	http://localhost:8055
102	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:17.979+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7fa53097-47b0-4f17-b945-91c50e732cae	http://localhost:8055
103	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.004+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	7fb2461f-1dcb-48ed-a53a-45939891ad5c	http://localhost:8055
104	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.03+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	815e7f2c-f764-489a-9aff-f9ce77a31d73	http://localhost:8055
105	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.056+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	84a96021-f642-4fdc-9c93-765134136f2f	http://localhost:8055
106	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.082+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	86f82081-fee0-4fe6-81d3-c353c1f21151	http://localhost:8055
107	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.126+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	8a9cb537-f0b6-4555-9b42-4e66273e557f	http://localhost:8055
108	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.159+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	8e4a96f5-b676-4248-aa43-f6175396f313	http://localhost:8055
109	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.184+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	910da328-483b-4275-bb75-38e36a4241b5	http://localhost:8055
110	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.209+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	93dfc941-9ec8-473a-9a5d-0e588c74a465	http://localhost:8055
111	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.246+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	972cf01f-3079-47c2-8de3-51b80f3cc44a	http://localhost:8055
112	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.271+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	97649fe5-db0a-45c8-8c41-8dc5bb51f6b7	http://localhost:8055
113	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.297+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	9b598d67-54a6-4bec-8dae-775e85fd4776	http://localhost:8055
114	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.322+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	a39685cd-1cf8-4ecc-b344-8a6d5214c25b	http://localhost:8055
115	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.346+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	a3e8fbd1-801c-4fd4-8d57-27c7453abe9b	http://localhost:8055
116	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.371+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	a3f96528-49f3-43d8-b0c5-6b23ed3b1ba7	http://localhost:8055
345	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:17.416+00	127.0.0.1	node	directus_permissions	38	\N
117	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.396+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	a4d1a6d4-709b-4beb-8992-7fc378b5faaa	http://localhost:8055
118	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.422+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	aa48e9fc-03b9-41dc-bf4d-7c3fe16b62bf	http://localhost:8055
119	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.449+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	aaffd1b1-e7d9-49b1-a9b5-8f7951f322f9	http://localhost:8055
120	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.475+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	aca6e1b0-3b37-47c0-956e-76c566e016b1	http://localhost:8055
121	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.499+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	acfb1531-bc65-437a-9da6-a03dd175b692	http://localhost:8055
122	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.525+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	af90e1a4-0fb9-40a3-b87d-2dde3acd816e	http://localhost:8055
123	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.55+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	b11d94e2-d319-4c7d-9360-96102687ed53	http://localhost:8055
124	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.574+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	b226f057-1f2d-4f82-ace7-47c7d0a0e6fa	http://localhost:8055
125	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.6+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	b56e4b6a-6b9c-435c-ab67-ccbbacb403e2	http://localhost:8055
126	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.624+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	b61e1b32-b263-4f3b-b0f8-be9305c4667a	http://localhost:8055
127	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.65+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	b6adc79d-c061-44c9-bd4a-92cc473b54ed	http://localhost:8055
128	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.676+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	b9e39c8e-e99b-4adb-9b7e-9df5ce54cd79	http://localhost:8055
129	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.705+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	bb616859-c478-404b-bafa-3b3bb7c0e822	http://localhost:8055
130	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.729+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	c2fef006-77b5-4ac6-8c57-492b609e89b2	http://localhost:8055
131	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.754+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	c4f7a85b-e82b-4f12-a054-58b9f46306a6	http://localhost:8055
132	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.777+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	c658eede-39a8-4e64-b7ee-7d9370d1035d	http://localhost:8055
133	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.801+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	c7bfc772-194e-4c9b-a30c-934029df5b2e	http://localhost:8055
134	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.845+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	c80d42df-4c25-4007-9e4d-049b2fded17c	http://localhost:8055
135	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.871+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	c951eb6b-d9ec-41b9-83af-61cb48befe47	http://localhost:8055
136	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.897+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	cb4fbb80-7266-479f-a975-2d100d4112e1	http://localhost:8055
137	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.92+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	d41103c2-74f3-43f3-a28a-2985db72d37f	http://localhost:8055
138	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.946+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	d49bbfd1-eee6-43aa-bc0a-623ba1bfcc40	http://localhost:8055
139	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.972+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	d9fbb27b-b0cc-4dc2-8a3b-bdcb3ce3a3ae	http://localhost:8055
140	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:18.999+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	db159311-767a-42b0-8c40-192d95f2d7df	http://localhost:8055
141	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.025+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	db4c3ef1-4835-41e0-8978-2fc6db183003	http://localhost:8055
142	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.051+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	db9d870e-0b3d-4302-af0f-63b5f4339bda	http://localhost:8055
143	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.085+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	dd88a159-199f-4002-bb9c-a481eeb31379	http://localhost:8055
144	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.111+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	de138f9a-7fbb-42fd-a947-21f743e93223	http://localhost:8055
145	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.146+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	e29ce0d4-9c1a-4103-b03e-8032d66f912c	http://localhost:8055
346	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:19.573+00	127.0.0.1	node	directus_permissions	39	\N
146	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.173+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	e6c46edf-9556-4996-909e-b53827524c19	http://localhost:8055
147	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.207+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	e750b8b4-1bb7-4cf9-8556-bb05de5226c0	http://localhost:8055
148	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.236+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	ee61b766-e0ed-4bba-930f-70816ad774ea	http://localhost:8055
149	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.26+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	f465c9dd-dd2e-40ba-9e6c-96ba1b5da84d	http://localhost:8055
150	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.285+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	f6253325-b8cc-4c41-9bbf-50319eaf499d	http://localhost:8055
151	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.311+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	f65e5a99-c4a1-4d64-bd2c-f0a8063f0b2c	http://localhost:8055
152	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:19.338+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	songs	fe1be507-a60e-41c5-a1e3-efb416d3e6e9	http://localhost:8055
153	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:25.966+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	3d34f189-435d-486a-834a-0cd54aa91045	http://localhost:8055
154	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:25.995+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	3ded563c-e1a2-4c4d-ab37-6d65d3a9f7d2	http://localhost:8055
155	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.048+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	405db777-5642-4546-9b4e-e8ea340cb180	http://localhost:8055
156	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.074+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	5fe987e9-f5b6-48e4-bfa6-d833334472f6	http://localhost:8055
157	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.104+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	6272529a-dfd7-4aa7-868c-2d2d4352b1b3	http://localhost:8055
158	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.128+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	63cad67d-b28b-4969-a892-aebe8e3b9b14	http://localhost:8055
159	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.155+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	729eaf9a-c8be-4420-90c9-0259415887de	http://localhost:8055
160	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.179+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	796082d2-71af-48f8-8fb5-1993bf296368	http://localhost:8055
161	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.204+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	7d60ba6e-01ab-430e-8b7f-9c8e98ed9b5c	http://localhost:8055
162	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.229+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	80afbe98-3e7b-4e45-998e-31a7efc96065	http://localhost:8055
163	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.253+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	8e8c68c9-1ff5-43b6-abf4-b070e6c41cb7	http://localhost:8055
164	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.279+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	8f5a0cf9-8076-4610-a2c9-f925713fb986	http://localhost:8055
165	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.303+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	99727d53-d1a8-4698-b45c-44c6d8830503	http://localhost:8055
166	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.348+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	9c9d3f71-e777-4a4e-88d4-9f815855d543	http://localhost:8055
167	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.374+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	b8a7fa1a-20d9-4bf4-8976-aed5a4469875	http://localhost:8055
168	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.399+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	c6abf76b-0b6a-4582-b810-ad414a031705	http://localhost:8055
169	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.423+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	d1b6dacc-66e0-481f-919a-c234d5f46a38	http://localhost:8055
170	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.452+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	d6bb0cda-131e-4713-b460-6aa9f84aeeaa	http://localhost:8055
171	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.478+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	f10c4482-9ab5-4dae-b8bc-ef146eef09d0	http://localhost:8055
172	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:26.501+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	themes	f4da2c99-83fa-47cd-bf04-32e371481fc0	http://localhost:8055
173	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.457+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	246f60e2-8ec4-42e6-b4c3-6e6e8a8daaec	http://localhost:8055
174	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.481+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	5ce1f5bd-3fd9-4462-ba34-834b06951177	http://localhost:8055
347	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:21.381+00	127.0.0.1	node	directus_permissions	40	\N
175	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.505+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	13fec2cc-0ca1-4c96-8362-e7aff938ae6c	http://localhost:8055
176	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.531+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	5045ef70-89ab-473d-8bea-802689b05d6a	http://localhost:8055
177	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.568+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	354cbc08-93b2-4a91-b737-98a872f04ede	http://localhost:8055
178	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.592+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	668a124f-89f7-4c5c-afab-5ed9bd23f14a	http://localhost:8055
179	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.618+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	7625c86e-f9a0-4e67-8b94-da3bd7d53c50	http://localhost:8055
180	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.675+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	efb5813a-c1f4-4978-942a-80f0ca1a156c	http://localhost:8055
181	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.699+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8fd510bb-04ea-434c-8ef6-c5430a064d6d	http://localhost:8055
182	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.723+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	5394411d-bb2f-46af-b555-0d92be256edc	http://localhost:8055
183	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.751+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	331259f2-84cc-4ccd-9bd2-72e3cff6b7f5	http://localhost:8055
184	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.777+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	b21be4b7-13f0-4210-8253-fe473f6dcb5e	http://localhost:8055
185	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.801+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	444c90c8-427c-467b-8dac-73896661673e	http://localhost:8055
186	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.825+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	7d93dd5d-afb4-42cb-a568-02485b6b9541	http://localhost:8055
187	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.849+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	1b166cbe-d1c2-4826-bc51-7b1ff6d91f0b	http://localhost:8055
188	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.878+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	ff166867-7c1a-457f-b689-8ffedd624514	http://localhost:8055
189	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.901+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	40ddc748-4df2-4a47-b1aa-8da6dedb7412	http://localhost:8055
190	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.927+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6c9edaea-4ed5-426c-8373-c51baccb1604	http://localhost:8055
191	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.965+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	e99c6c37-fc9c-4932-9d25-70579178afeb	http://localhost:8055
192	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:47.989+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	53c6fdda-0384-400b-ad16-5edfc5c611c9	http://localhost:8055
193	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.017+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	0e695911-d416-4e0a-8dbb-93d98b349fa0	http://localhost:8055
194	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.041+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	aaf87f50-e3d7-4ed0-9df1-0f9c8f976d3e	http://localhost:8055
195	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.067+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	033463ff-a752-4acf-ac22-7624c9127421	http://localhost:8055
196	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.091+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	0429f6e1-ee87-4eef-aa54-879ac65035be	http://localhost:8055
197	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.117+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8e2047b1-6fdc-4c8c-b32b-141fd6d8ecea	http://localhost:8055
198	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.142+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	f1e7624b-b7ee-4d15-81f6-fbe8fd263f03	http://localhost:8055
199	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.198+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	17c12afa-ff8e-45a0-9ad0-99880eaf2e5c	http://localhost:8055
200	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.246+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	daa8e3da-0b48-4f4f-9262-0650547d9032	http://localhost:8055
201	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.27+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	0f98fe9b-a45a-41ca-a1d5-d513c248aabf	http://localhost:8055
202	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.294+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	e9cfb678-4539-42bd-9960-593f3d1c6184	http://localhost:8055
348	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:23.168+00	127.0.0.1	node	directus_permissions	41	\N
203	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.317+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c0f0c43f-87b1-4487-bc75-cc6f575b033c	http://localhost:8055
204	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.341+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	e3de7ed2-74c5-440a-98e5-c61330588b8d	http://localhost:8055
205	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.367+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	dcbae0fe-0411-4535-8b4b-1e03d5395214	http://localhost:8055
206	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.391+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	20309e4a-3171-4c41-b3c3-f6548d99fa2c	http://localhost:8055
207	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.416+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	3876685a-12ff-41f2-8388-8929ea00d96f	http://localhost:8055
208	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.44+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	da71358a-af7e-42cd-9796-d8936d076747	http://localhost:8055
209	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.467+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	673008ae-ad7c-4d6e-9f7a-1adbb6aed678	http://localhost:8055
210	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.49+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c8f40131-c7e1-4069-b8ca-0c1acce264eb	http://localhost:8055
211	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.528+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	e01fe15d-0095-4fe8-8cb4-93aec5ebd7f7	http://localhost:8055
212	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.552+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	65b32a6d-1aab-4257-a8e2-0a547063089e	http://localhost:8055
213	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.577+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	dec23292-b00a-4d0b-a7c5-648c28fb916f	http://localhost:8055
214	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.601+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	e09d349c-040c-4da9-9c38-03bb51586dd3	http://localhost:8055
215	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.625+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4d7e5030-d8cd-42c8-b379-6065d60afb60	http://localhost:8055
216	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.65+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	9abc4a90-a7b9-4ddc-bad7-3772d5645da8	http://localhost:8055
217	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.674+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	15b0ccfd-06dc-449b-bf4a-99ff4dc590d3	http://localhost:8055
218	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.696+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8b487904-4db0-47b3-974d-06e4d45201ca	http://localhost:8055
219	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.721+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c92710d7-7cf9-4097-95e8-a177588b1d46	http://localhost:8055
220	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.747+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	d14fa04e-b87b-407e-ae5d-fbcd4f82544a	http://localhost:8055
221	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.778+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	a06f1701-83da-4461-a5a1-9d57a492123d	http://localhost:8055
222	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.811+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	0abf197e-eb90-491f-81dd-f1f475658042	http://localhost:8055
223	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.873+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	d443a560-ef33-4ab7-b077-e97a6f3beebb	http://localhost:8055
224	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.904+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	64ccf3c0-ca4a-4fc9-899b-cd2543b89fda	http://localhost:8055
225	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.931+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	05318a3e-9ac7-4ced-8b1f-8d30a920f028	http://localhost:8055
226	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.956+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	3b12ad44-4b17-4037-a3dd-ba7984831b88	http://localhost:8055
227	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:48.98+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	2a0eba43-590f-4a30-870c-0ffaddff2e22	http://localhost:8055
228	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.006+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8a6d0dcf-a58b-4a6a-9ac4-f89905d59e0c	http://localhost:8055
229	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.03+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c0fea8ce-8fb7-4de5-a688-dcb63317e050	http://localhost:8055
230	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.055+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c9494011-c0d4-400a-835f-c9aaf536314e	http://localhost:8055
349	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:25.599+00	127.0.0.1	node	directus_permissions	42	\N
231	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.081+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c51c8553-b9c7-41a7-a32a-84038b855c89	http://localhost:8055
232	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.108+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8c62c542-2c28-473c-ae27-626200112d61	http://localhost:8055
233	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.145+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	f424bf30-a1d9-46d7-8a38-03104cb76ccb	http://localhost:8055
234	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.169+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	35e63766-1108-4ade-900c-0ffbb4df87ea	http://localhost:8055
235	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.193+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	5def852d-4e68-4612-bc26-f363e37a1930	http://localhost:8055
236	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.218+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	697a463d-833a-4a73-afda-f66a4d655890	http://localhost:8055
237	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.245+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	ed557218-de7a-4f9c-8d93-68b06c218b86	http://localhost:8055
238	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.269+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c94fe793-aeef-4786-8c7c-afcd67036910	http://localhost:8055
239	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.293+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	266445a8-2742-4c17-bb78-1ff744c5e9d7	http://localhost:8055
240	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.318+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	f80077c3-402a-45b6-a5d8-4e53c2142a9f	http://localhost:8055
241	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.344+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	ac74ba82-ba2f-441a-a5a8-fe337c8cf0df	http://localhost:8055
242	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.367+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	a95940dd-6109-4b1c-b8c3-e1b0c287efdc	http://localhost:8055
243	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.391+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	ad425a21-9331-4ccf-a96c-982559b3cf35	http://localhost:8055
244	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.445+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	cff5a503-b135-42ff-aafe-6f0525e4f715	http://localhost:8055
245	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.47+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c4f8959f-8836-4648-9ad3-3e2f0bb358b8	http://localhost:8055
246	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.494+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c4f9d6fd-8d49-4ce3-8a2c-a173e7895c70	http://localhost:8055
247	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.523+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c46e38cc-4097-4e7b-96bf-d87f829aa312	http://localhost:8055
248	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.548+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	05b43bdc-3c7c-4fd4-bcad-ff51db3d85d5	http://localhost:8055
249	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.745+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	e97d4b81-b69e-461d-8e20-d2dceb9d8a5f	http://localhost:8055
250	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.769+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	660b1932-3a5a-4cb7-9ce8-e1dcea3c2935	http://localhost:8055
251	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.799+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	a0251437-8a35-4c7a-a248-8c2e23257ee1	http://localhost:8055
252	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.824+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	3e85ed35-7b10-403f-a137-fc96241a1d68	http://localhost:8055
253	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.852+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	2183c34f-0034-4cd0-b64e-d5dd54098382	http://localhost:8055
254	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.877+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	1c5029c8-2d48-4b4d-b52e-e4c40a2cef85	http://localhost:8055
255	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.901+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8591d7f7-a222-4320-b5cf-4afc8df127cf	http://localhost:8055
256	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.927+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6b9fadb0-6c4d-4086-92c7-d5cbc68bae27	http://localhost:8055
257	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.95+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6e268042-59f9-4f26-89cb-b83bc635d373	http://localhost:8055
258	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:49.975+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6e4e6148-e965-40b9-90f5-840a5aef3b08	http://localhost:8055
350	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:27.396+00	127.0.0.1	node	directus_permissions	43	\N
259	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	cab4fb4f-b167-489e-8a13-3546fc28e837	http://localhost:8055
260	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.047+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c1cb2a2c-1a04-47a8-8fdd-51eb1e8f9b5d	http://localhost:8055
261	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.073+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	05e3e8a6-731b-47f3-859f-524bfcca95db	http://localhost:8055
262	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.097+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	497d036c-a951-49d1-be98-3a58c0601749	http://localhost:8055
263	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.128+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	796eb534-6219-4500-8ace-d8c4a1ee753d	http://localhost:8055
264	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.151+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	5ccaaeec-20cd-4995-8599-fde680b8c0e8	http://localhost:8055
265	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.175+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	f40ed170-175f-4f6d-9412-e858136ddb65	http://localhost:8055
266	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.199+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	c34c6122-b2ca-4f0d-8c01-7dee94332da6	http://localhost:8055
267	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.223+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	956b1101-fede-41f7-b271-5c8f22792560	http://localhost:8055
268	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.247+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	247edfae-9a8b-49f1-8516-adbf8fa04fd5	http://localhost:8055
269	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.289+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	e0aa288c-b6c6-4ee3-a425-8f4f67360968	http://localhost:8055
270	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.314+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	a3d3fbab-af21-4075-91fc-49fe5d6e735d	http://localhost:8055
271	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.344+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6064e5dd-6d36-49d2-850f-06eda45bdf45	http://localhost:8055
272	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.367+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	301ff5ef-dba8-4796-9249-1f9a5e7c023e	http://localhost:8055
273	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.39+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6acb7713-85fd-4978-9bda-d962f2ae2d1d	http://localhost:8055
274	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.413+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8ec0c3df-4ae5-4d7b-90d3-9481916cf220	http://localhost:8055
275	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.436+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	4f28a570-a11b-4aee-9e3f-93b68ab9322c	http://localhost:8055
276	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.459+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	3ed61f7c-92b1-4c8d-9b03-1a1b3b71a192	http://localhost:8055
277	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.481+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	930214ba-5864-4a7c-ac90-c309e317e724	http://localhost:8055
278	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.506+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	8668b34b-14d3-411b-960f-b0329c164742	http://localhost:8055
279	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.531+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6c3e5807-31a0-4edc-a745-863d10f1f8cc	http://localhost:8055
280	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.558+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	fbaa4597-8315-4f78-9c7b-86c45a9e5984	http://localhost:8055
281	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.581+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	12fd91df-2629-4c06-8224-885c4d7aea68	http://localhost:8055
282	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.604+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	68112ae0-01b8-4a11-a930-cd4f4f1c4c7e	http://localhost:8055
283	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.644+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	11c7ee6c-9ba4-47f2-bc5e-f3712c6609bf	http://localhost:8055
284	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.667+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	d54095bb-8d5c-4c3e-b78d-0f183d9de39e	http://localhost:8055
285	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.693+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	99bbb209-6785-45d2-aff8-9e0485989050	http://localhost:8055
286	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.721+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	6c241012-2b8a-4014-b1ba-846be3aedf95	http://localhost:8055
404	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:06.96+00	127.0.0.1	node	directus_permissions	77	\N
287	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.746+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	0867839c-0ae6-432b-945e-f3f029ec500c	http://localhost:8055
288	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.769+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	d0ec90da-b63d-4316-a779-566d0b7f395a	http://localhost:8055
289	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.793+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	bfae8ce7-0acd-4b23-9a83-daabdffd30c0	http://localhost:8055
290	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.823+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	01b4c43f-46d1-4de2-bce9-e8f96f97c57f	http://localhost:8055
291	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.845+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	5df7c6c2-e7a6-402f-a99a-6aa49778c7c7	http://localhost:8055
292	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:20:50.867+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	bbc1b502-ebf2-4a29-80fe-08acce971d90	http://localhost:8055
293	login	efa7f426-53ea-4a0d-9c82-2f3ea7bef900	2025-09-17 17:21:32.006+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	efa7f426-53ea-4a0d-9c82-2f3ea7bef900	http://localhost:8055
294	login	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:31.423+00	127.0.0.1	node	directus_users	6074c864-6a99-4c14-b4cb-41be600454ff	\N
295	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:31.847+00	127.0.0.1	node	directus_policies	98aabdfa-8d5c-46d5-ab96-e0bb516af24c	\N
296	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:33.923+00	127.0.0.1	node	directus_policies	4aca5a5c-0f9f-47b6-8d9b-502849cecebb	\N
297	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:35.768+00	127.0.0.1	node	directus_policies	6a304535-b0c3-4d79-90b5-16c3f1a2846d	\N
298	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:37.998+00	127.0.0.1	node	directus_roles	6322ec31-92f9-4868-b569-0417a5224157	\N
299	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:38.369+00	127.0.0.1	node	directus_roles	2632b1a6-0fd7-4b4c-8c86-325fcc139ca6	\N
300	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:38.857+00	127.0.0.1	node	directus_access	b4e599f8-818f-4f17-bbd5-d6c8dd40aa77	\N
301	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:22:59.463+00	127.0.0.1	node	directus_access	38020759-3706-4b65-9b0c-11cdb35e69b4	\N
302	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:21.235+00	127.0.0.1	node	directus_access	e3ba1847-48a1-4ddd-b25c-6cec448dc249	\N
303	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:34.673+00	127.0.0.1	node	directus_roles	6322ec31-92f9-4868-b569-0417a5224157	\N
304	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:34.924+00	127.0.0.1	node	directus_roles	6322ec31-92f9-4868-b569-0417a5224157	\N
305	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:34.924+00	127.0.0.1	node	directus_roles	6322ec31-92f9-4868-b569-0417a5224157	\N
306	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:38.791+00	127.0.0.1	node	directus_access	905a022a-7d85-4df1-8410-2a1064183724	\N
307	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:41.856+00	127.0.0.1	node	directus_roles	2632b1a6-0fd7-4b4c-8c86-325fcc139ca6	\N
308	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:45.313+00	127.0.0.1	node	directus_permissions	1	\N
309	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:51.898+00	127.0.0.1	node	directus_permissions	2	\N
310	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:23:58.319+00	127.0.0.1	node	directus_permissions	3	\N
311	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:03.979+00	127.0.0.1	node	directus_permissions	4	\N
312	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:09.681+00	127.0.0.1	node	directus_permissions	5	\N
313	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:14.574+00	127.0.0.1	node	directus_permissions	6	\N
314	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:16.782+00	127.0.0.1	node	directus_permissions	7	\N
315	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:18.678+00	127.0.0.1	node	directus_permissions	8	\N
316	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:20.633+00	127.0.0.1	node	directus_permissions	9	\N
317	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:22.546+00	127.0.0.1	node	directus_permissions	10	\N
318	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:24.706+00	127.0.0.1	node	directus_permissions	11	\N
319	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:26.721+00	127.0.0.1	node	directus_permissions	12	\N
320	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:28.512+00	127.0.0.1	node	directus_permissions	13	\N
321	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:30.373+00	127.0.0.1	node	directus_permissions	14	\N
322	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:32.22+00	127.0.0.1	node	directus_permissions	15	\N
323	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:34.103+00	127.0.0.1	node	directus_permissions	16	\N
324	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:35.991+00	127.0.0.1	node	directus_permissions	17	\N
325	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:37.995+00	127.0.0.1	node	directus_permissions	18	\N
326	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:40.239+00	127.0.0.1	node	directus_permissions	19	\N
327	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:42.276+00	127.0.0.1	node	directus_permissions	20	\N
328	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:44.303+00	127.0.0.1	node	directus_permissions	21	\N
329	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:46.155+00	127.0.0.1	node	directus_permissions	22	\N
330	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:48.372+00	127.0.0.1	node	directus_permissions	23	\N
331	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:50.189+00	127.0.0.1	node	directus_permissions	24	\N
332	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:52.082+00	127.0.0.1	node	directus_permissions	25	\N
333	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:54.062+00	127.0.0.1	node	directus_permissions	26	\N
334	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:55.848+00	127.0.0.1	node	directus_permissions	27	\N
335	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:57.641+00	127.0.0.1	node	directus_permissions	28	\N
336	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:24:59.384+00	127.0.0.1	node	directus_permissions	29	\N
337	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:01.248+00	127.0.0.1	node	directus_permissions	30	\N
338	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:03.344+00	127.0.0.1	node	directus_permissions	31	\N
339	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:05.743+00	127.0.0.1	node	directus_permissions	32	\N
340	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:07.672+00	127.0.0.1	node	directus_permissions	33	\N
341	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:10.044+00	127.0.0.1	node	directus_permissions	34	\N
342	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:11.833+00	127.0.0.1	node	directus_permissions	35	\N
351	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:52.677+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	b4e599f8-818f-4f17-bbd5-d6c8dd40aa77	http://localhost:8055
352	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:52.702+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	38020759-3706-4b65-9b0c-11cdb35e69b4	http://localhost:8055
353	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:52.742+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	e3ba1847-48a1-4ddd-b25c-6cec448dc249	http://localhost:8055
354	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:25:54.241+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_roles	6322ec31-92f9-4868-b569-0417a5224157	http://localhost:8055
355	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:26:13.338+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_access	905a022a-7d85-4df1-8410-2a1064183724	http://localhost:8055
356	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:26:14.572+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_roles	2632b1a6-0fd7-4b4c-8c86-325fcc139ca6	http://localhost:8055
357	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:26:46.677+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	6a304535-b0c3-4d79-90b5-16c3f1a2846d	http://localhost:8055
358	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:26:52.865+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	98aabdfa-8d5c-46d5-ab96-e0bb516af24c	http://localhost:8055
359	delete	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:02.202+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_policies	4aca5a5c-0f9f-47b6-8d9b-502849cecebb	http://localhost:8055
360	login	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:47.874+00	127.0.0.1	node	directus_users	6074c864-6a99-4c14-b4cb-41be600454ff	\N
361	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:48.324+00	127.0.0.1	node	directus_policies	51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d	\N
362	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:49.779+00	127.0.0.1	node	directus_policies	25c07c57-7443-404e-80ee-6ea165f7a203	\N
363	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:51.586+00	127.0.0.1	node	directus_policies	a55ebdcc-8f22-483c-8c27-00bc458cfbed	\N
364	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:53.196+00	127.0.0.1	node	directus_roles	3c9b1b03-db47-4846-b6ef-f555837147e4	\N
365	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:53.571+00	127.0.0.1	node	directus_roles	dc4028dd-0496-404c-9735-b6db096efe4a	\N
366	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:54.075+00	127.0.0.1	node	directus_access	9d6c9ee8-dfd3-48cf-a148-f9453928ca6b	\N
367	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:55.144+00	127.0.0.1	node	directus_roles	3c9b1b03-db47-4846-b6ef-f555837147e4	\N
368	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:56.629+00	127.0.0.1	node	directus_access	e0259e7c-3021-4bd7-93e0-3d8071a0d2d0	\N
369	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:57.612+00	127.0.0.1	node	directus_roles	dc4028dd-0496-404c-9735-b6db096efe4a	\N
370	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:27:58.704+00	127.0.0.1	node	directus_permissions	44	\N
371	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:00.5+00	127.0.0.1	node	directus_permissions	45	\N
372	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:02.579+00	127.0.0.1	node	directus_permissions	46	\N
373	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:04.549+00	127.0.0.1	node	directus_permissions	47	\N
374	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:07.11+00	127.0.0.1	node	directus_permissions	48	\N
375	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:08.987+00	127.0.0.1	node	directus_permissions	49	\N
376	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:11.044+00	127.0.0.1	node	directus_permissions	50	\N
377	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:13.193+00	127.0.0.1	node	directus_permissions	51	\N
378	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:14.936+00	127.0.0.1	node	directus_permissions	52	\N
379	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:16.988+00	127.0.0.1	node	directus_permissions	53	\N
380	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:19.03+00	127.0.0.1	node	directus_permissions	54	\N
381	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:21.055+00	127.0.0.1	node	directus_permissions	55	\N
382	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:23.044+00	127.0.0.1	node	directus_permissions	56	\N
383	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:24.902+00	127.0.0.1	node	directus_permissions	57	\N
384	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:27.101+00	127.0.0.1	node	directus_permissions	58	\N
385	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:29.199+00	127.0.0.1	node	directus_permissions	59	\N
386	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:31.402+00	127.0.0.1	node	directus_permissions	60	\N
387	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:33.265+00	127.0.0.1	node	directus_permissions	61	\N
388	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:35.145+00	127.0.0.1	node	directus_permissions	62	\N
389	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:37.33+00	127.0.0.1	node	directus_permissions	63	\N
390	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:39.885+00	127.0.0.1	node	directus_permissions	64	\N
391	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:42.36+00	127.0.0.1	node	directus_permissions	65	\N
392	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:44.137+00	127.0.0.1	node	directus_permissions	66	\N
393	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:46.165+00	127.0.0.1	node	directus_permissions	67	\N
394	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:47.962+00	127.0.0.1	node	directus_permissions	68	\N
395	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:49.836+00	127.0.0.1	node	directus_permissions	69	\N
396	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:52.12+00	127.0.0.1	node	directus_permissions	70	\N
397	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:54.476+00	127.0.0.1	node	directus_permissions	71	\N
398	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:56.918+00	127.0.0.1	node	directus_permissions	72	\N
399	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:58.366+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
400	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:28:58.615+00	127.0.0.1	node	directus_permissions	73	\N
401	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:00.78+00	127.0.0.1	node	directus_permissions	74	\N
402	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:02.896+00	127.0.0.1	node	directus_permissions	75	\N
403	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:04.86+00	127.0.0.1	node	directus_permissions	76	\N
405	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:08.887+00	127.0.0.1	node	directus_permissions	78	\N
406	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:10.902+00	127.0.0.1	node	directus_permissions	79	\N
407	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:12.859+00	127.0.0.1	node	directus_permissions	80	\N
408	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:14.972+00	127.0.0.1	node	directus_permissions	81	\N
409	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:18.715+00	127.0.0.1	node	directus_permissions	82	\N
410	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:24.795+00	127.0.0.1	node	directus_permissions	83	\N
411	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:30.507+00	127.0.0.1	node	directus_permissions	84	\N
412	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:36.809+00	127.0.0.1	node	directus_permissions	85	\N
413	create	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:29:43.196+00	127.0.0.1	node	directus_permissions	86	\N
414	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:30:02.654+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_settings	1	http://localhost:8055
415	login	dff9753c-edf4-411a-840b-3dab5fd90b79	2025-09-17 17:31:10.982+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	dff9753c-edf4-411a-840b-3dab5fd90b79	http://localhost:8055
416	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:32:11.251+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	dff9753c-edf4-411a-840b-3dab5fd90b79	http://localhost:8055
417	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:35:14.642+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	0633d4e6-b2ec-45e3-8426-2b25e0a7c46a	http://localhost:8055
418	update	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:35:37.371+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	directus_users	efa7f426-53ea-4a0d-9c82-2f3ea7bef900	http://localhost:8055
\.


--
-- Data for Name: directus_collections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_collections (collection, icon, note, display_template, hidden, singleton, translations, archive_field, archive_app_filter, archive_value, unarchive_value, sort_field, accountability, color, item_duplication_fields, sort, "group", collapse, preview_url, versioning) FROM stdin;
live_sessions	play_circle	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
lives	move_up	\N	{{name}}{{status}}{{singer.email}}{{is_public}}{{date_event}}	f	f	\N	\N	t	\N	\N	\N	all	\N	[]	\N	\N	open	\N	f
messages	chat	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
requests	library_music	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
songs	queue_music	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
suggestions	lightbulb	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
themes	palette	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	\N	\N	\N	\N	open	\N	f
\.


--
-- Data for Name: directus_comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_comments (id, collection, item, comment, date_created, date_updated, user_created, user_updated) FROM stdin;
\.


--
-- Data for Name: directus_dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_dashboards (id, name, icon, note, date_created, user_created, color) FROM stdin;
\.


--
-- Data for Name: directus_extensions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_extensions (enabled, id, folder, source, bundle) FROM stdin;
\.


--
-- Data for Name: directus_fields; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_fields (id, collection, field, special, interface, options, display, display_options, readonly, hidden, sort, width, translations, note, conditions, required, "group", validation, validation_message) FROM stdin;
1	live_sessions	id	uuid	input	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
2	live_sessions	live	m2o	select-dropdown-m2o	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
3	live_sessions	artist	m2o	select-dropdown-m2o	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
4	live_sessions	name	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
5	live_sessions	status	\N	select-dropdown	{"choices":[{"text":"active","value":"active"},{"text":"ended","value":"ended"}]}	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
6	live_sessions	started_at	\N	datetime	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
7	live_sessions	ended_at	\N	datetime	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
8	live_sessions	where_are_you	\N	tags	\N	\N	\N	f	f	8	full	\N	Array de UUIDs (key_live) conectados	\N	f	\N	\N	\N
9	lives	id	uuid	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
10	lives	date_created	date-created	datetime	\N	datetime	{"relative":true}	t	t	2	half	\N	\N	\N	f	\N	\N	\N
11	lives	name	\N	input	{"iconLeft":"slow_motion_video","placeholder":"Nome do Evento"}	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
12	lives	slug	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
13	lives	reusable	cast-boolean	boolean	{"colorOff":"#E35169","colorOn":"#2ECDA7","iconOff":"disabled_visible","iconOn":"autorenew"}	boolean	{"colorOff":"#E35169","colorOn":"#2ECDA7","labelOff":"Nāo","labelOn":"Sim"}	f	f	7	full	\N	\N	\N	t	\N	\N	\N
14	lives	is_public	cast-boolean	boolean	{"colorOff":"#E35169","colorOn":"#2ECDA7","iconOff":"folder_limited","iconOn":"folder_eye"}	boolean	{"colorOff":"#E35169","colorOn":"#2ECDA7","iconOff":"dangerous","iconOn":"eye_tracking"}	f	f	8	full	\N	\N	\N	t	\N	\N	\N
15	lives	max_messages_per_client	\N	input	{"max":98,"min":1}	\N	\N	f	f	9	full	\N	\N	\N	t	\N	\N	\N
16	lives	comment_cooldown_seconds	\N	input	{"max":997,"min":0}	\N	\N	f	f	10	full	\N	\N	\N	t	\N	\N	\N
17	lives	max_song_requests_per_client	\N	input	{"max":1000,"min":1}	\N	\N	f	f	11	full	\N	\N	\N	t	\N	\N	\N
18	lives	status	\N	select-dropdown	{"choices":[{"text":"offline","value":"offline"},{"text":"online","value":"online"},{"text":"closed","value":"closed"}]}	\N	\N	f	f	12	full	\N	\N	\N	t	\N	\N	\N
19	lives	date_event	\N	datetime	{"relative":true}	\N	\N	f	f	13	full	\N	\N	\N	t	\N	\N	\N
20	lives	singer	m2o	select-dropdown-m2o	{"enableCreate":false,"enableLink":true,"template":"{{first_name}}{{last_name}}({{email}})"}	\N	\N	f	f	14	full	\N	\N	\N	f	\N	\N	\N
21	messages	id	uuid	input	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
22	messages	live	m2o	select-dropdown-m2o	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
23	messages	session	m2o	select-dropdown-m2o	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
24	messages	sender_type	\N	select-dropdown	{"choices":[{"text":"artist","value":"artist"},{"text":"client","value":"client"},{"text":"public","value":"public"}]}	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
25	messages	sender_name	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
26	messages	sender_user	m2o	select-dropdown-m2o	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
27	messages	content	\N	textarea	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
28	messages	sent_at	\N	datetime	\N	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N
29	messages	reactions	\N	tags	\N	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N
30	messages	visibility	\N	tags	\N	\N	\N	f	f	10	full	\N	Array de roles que podem ver: public, client, singer	\N	f	\N	\N	\N
31	messages	is_super	\N	boolean	\N	\N	\N	f	f	11	full	\N	Mensagem de SuperChat	\N	f	\N	\N	\N
32	messages	is_hidden	\N	boolean	\N	\N	\N	f	f	12	full	\N	Oculta mensagem (API não envia)	\N	f	\N	\N	\N
33	messages	key_live	\N	input	\N	\N	\N	f	f	13	full	\N	UUID (key_live) do autor (público/logado)	\N	f	\N	\N	\N
34	messages	linked_request	m2o	select-dropdown-m2o	\N	\N	\N	f	f	14	full	\N	Linka a um pedido para status em linha do chat	\N	f	\N	\N	\N
35	requests	id	uuid	input	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
36	requests	live	m2o	select-dropdown-m2o	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
37	requests	session	m2o	select-dropdown-m2o	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
38	requests	song	m2o	select-dropdown-m2o	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
39	requests	status	\N	select-dropdown	{"choices":[{"text":"pending","value":"pending"},{"text":"accepted","value":"accepted"},{"text":"rejected","value":"rejected"}]}	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
40	requests	requested_by	\N	input	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
41	requests	requested_user	m2o	select-dropdown-m2o	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
42	requests	requested_at	\N	datetime	\N	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N
43	requests	reactions	\N	tags	\N	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N
44	requests	is_super	\N	boolean	\N	\N	\N	f	f	10	full	\N	Pedido originado por SuperChat	\N	f	\N	\N	\N
45	requests	superchat_type	\N	input	\N	\N	\N	f	f	11	full	\N	Tipo escolhido no SuperChat (ex: basic/plus/vip)	\N	f	\N	\N	\N
46	requests	played_at	\N	datetime	\N	\N	\N	f	f	12	full	\N	\N	\N	f	\N	\N	\N
47	requests	answered_at	\N	datetime	\N	\N	\N	f	f	13	full	\N	\N	\N	f	\N	\N	\N
48	requests	accepted_by	m2o	select-dropdown-m2o	\N	\N	\N	f	f	14	full	\N	\N	\N	f	\N	\N	\N
49	requests	key_live	\N	input	\N	\N	\N	f	f	15	full	\N	UUID (key_live) do autor do pedido (público ou logado)	\N	f	\N	\N	\N
50	songs	id	uuid	input	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
51	songs	title	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
52	songs	artist_name	\N	input	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
53	songs	recommended	\N	boolean	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
54	songs	owner	m2o	select-dropdown-m2o	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
55	suggestions	id	uuid	input	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
56	suggestions	live	m2o	select-dropdown-m2o	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
57	suggestions	session	m2o	select-dropdown-m2o	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
58	suggestions	title	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
59	suggestions	artist_name	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
60	suggestions	observations	\N	textarea	\N	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
61	suggestions	suggested_by	\N	input	\N	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
62	suggestions	suggested_user	m2o	select-dropdown-m2o	\N	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N
63	suggestions	suggested_at	\N	datetime	\N	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N
64	suggestions	status	\N	select-dropdown	{"choices":[{"text":"pending","value":"pending"},{"text":"approved","value":"approved"},{"text":"rejected","value":"rejected"}]}	\N	\N	f	f	10	full	\N	\N	\N	f	\N	\N	\N
65	themes	id	uuid	input	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
66	themes	owner	m2o	select-dropdown-m2o	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
67	themes	mode	\N	select-dropdown	{"choices":[{"text":"Light","value":"light"},{"text":"Dark","value":"dark"}]}	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
68	themes	color1	\N	input	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
69	themes	color2	\N	input	\N	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
70	directus_users	plan	\N	select-dropdown	{"choices":[{"text":"Free","value":"free"},{"text":"Premium","value":"premium"}]}	\N	\N	f	f	1	full	\N	\N	\N	f	\N	\N	\N
71	directus_users	stage_name	\N	input	\N	\N	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
72	directus_users	bio	\N	textarea	\N	\N	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
73	directus_users	photo	file	file	\N	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
\.


--
-- Data for Name: directus_files; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_files (id, storage, filename_disk, filename_download, title, type, folder, uploaded_by, created_on, modified_by, modified_on, charset, filesize, width, height, duration, embed, description, location, tags, metadata, focal_point_x, focal_point_y, tus_id, tus_data, uploaded_on) FROM stdin;
\.


--
-- Data for Name: directus_flows; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_flows (id, name, icon, color, description, status, trigger, accountability, options, operation, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_folders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_folders (id, name, parent) FROM stdin;
\.


--
-- Data for Name: directus_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_migrations (version, name, "timestamp") FROM stdin;
20201028A	Remove Collection Foreign Keys	2025-09-17 17:11:34.661903+00
20201029A	Remove System Relations	2025-09-17 17:11:34.718026+00
20201029B	Remove System Collections	2025-09-17 17:11:34.769766+00
20201029C	Remove System Fields	2025-09-17 17:11:34.852766+00
20201105A	Add Cascade System Relations	2025-09-17 17:11:36.029283+00
20201105B	Change Webhook URL Type	2025-09-17 17:11:36.138779+00
20210225A	Add Relations Sort Field	2025-09-17 17:11:36.209565+00
20210304A	Remove Locked Fields	2025-09-17 17:11:36.259919+00
20210312A	Webhooks Collections Text	2025-09-17 17:11:36.381388+00
20210331A	Add Refresh Interval	2025-09-17 17:11:36.432267+00
20210415A	Make Filesize Nullable	2025-09-17 17:11:36.710595+00
20210416A	Add Collections Accountability	2025-09-17 17:11:36.780295+00
20210422A	Remove Files Interface	2025-09-17 17:11:36.829729+00
20210506A	Rename Interfaces	2025-09-17 17:11:38.08421+00
20210510A	Restructure Relations	2025-09-17 17:11:38.392432+00
20210518A	Add Foreign Key Constraints	2025-09-17 17:11:38.480679+00
20210519A	Add System Fk Triggers	2025-09-17 17:11:38.900314+00
20210521A	Add Collections Icon Color	2025-09-17 17:11:38.950261+00
20210525A	Add Insights	2025-09-17 17:11:39.138037+00
20210608A	Add Deep Clone Config	2025-09-17 17:11:39.19111+00
20210626A	Change Filesize Bigint	2025-09-17 17:11:39.347268+00
20210716A	Add Conditions to Fields	2025-09-17 17:11:39.399835+00
20210721A	Add Default Folder	2025-09-17 17:11:39.482717+00
20210802A	Replace Groups	2025-09-17 17:11:39.560034+00
20210803A	Add Required to Fields	2025-09-17 17:11:39.631763+00
20210805A	Update Groups	2025-09-17 17:11:39.700305+00
20210805B	Change Image Metadata Structure	2025-09-17 17:11:39.75609+00
20210811A	Add Geometry Config	2025-09-17 17:11:39.809396+00
20210831A	Remove Limit Column	2025-09-17 17:11:39.862998+00
20210903A	Add Auth Provider	2025-09-17 17:11:40.106517+00
20210907A	Webhooks Collections Not Null	2025-09-17 17:11:40.25168+00
20210910A	Move Module Setup	2025-09-17 17:11:40.329226+00
20210920A	Webhooks URL Not Null	2025-09-17 17:11:40.456382+00
20210924A	Add Collection Organization	2025-09-17 17:11:40.561753+00
20210927A	Replace Fields Group	2025-09-17 17:11:40.712723+00
20210927B	Replace M2M Interface	2025-09-17 17:11:40.771951+00
20210929A	Rename Login Action	2025-09-17 17:11:40.867937+00
20211007A	Update Presets	2025-09-17 17:11:40.980963+00
20211009A	Add Auth Data	2025-09-17 17:11:41.033909+00
20211016A	Add Webhook Headers	2025-09-17 17:11:41.096903+00
20211103A	Set Unique to User Token	2025-09-17 17:11:41.156001+00
20211103B	Update Special Geometry	2025-09-17 17:11:41.36713+00
20211104A	Remove Collections Listing	2025-09-17 17:11:41.429192+00
20211118A	Add Notifications	2025-09-17 17:11:41.583455+00
20211211A	Add Shares	2025-09-17 17:11:41.853829+00
20211230A	Add Project Descriptor	2025-09-17 17:11:41.903448+00
20220303A	Remove Default Project Color	2025-09-17 17:11:42.055318+00
20220308A	Add Bookmark Icon and Color	2025-09-17 17:11:42.107649+00
20220314A	Add Translation Strings	2025-09-17 17:11:42.161412+00
20220322A	Rename Field Typecast Flags	2025-09-17 17:11:42.22265+00
20220323A	Add Field Validation	2025-09-17 17:11:42.275936+00
20220325A	Fix Typecast Flags	2025-09-17 17:11:42.354841+00
20220325B	Add Default Language	2025-09-17 17:11:42.500638+00
20220402A	Remove Default Value Panel Icon	2025-09-17 17:11:42.652304+00
20220429A	Add Flows	2025-09-17 17:11:42.980295+00
20220429B	Add Color to Insights Icon	2025-09-17 17:11:43.029198+00
20220429C	Drop Non Null From IP of Activity	2025-09-17 17:11:43.078872+00
20220429D	Drop Non Null From Sender of Notifications	2025-09-17 17:11:43.127377+00
20220614A	Rename Hook Trigger to Event	2025-09-17 17:11:43.172768+00
20220801A	Update Notifications Timestamp Column	2025-09-17 17:11:43.322106+00
20220802A	Add Custom Aspect Ratios	2025-09-17 17:11:43.372598+00
20220826A	Add Origin to Accountability	2025-09-17 17:11:43.446811+00
20230401A	Update Material Icons	2025-09-17 17:11:43.630781+00
20230525A	Add Preview Settings	2025-09-17 17:11:43.680056+00
20230526A	Migrate Translation Strings	2025-09-17 17:11:43.782438+00
20230721A	Require Shares Fields	2025-09-17 17:11:43.875873+00
20230823A	Add Content Versioning	2025-09-17 17:11:44.085525+00
20230927A	Themes	2025-09-17 17:11:44.501403+00
20231009A	Update CSV Fields to Text	2025-09-17 17:11:44.553598+00
20231009B	Update Panel Options	2025-09-17 17:11:44.60211+00
20231010A	Add Extensions	2025-09-17 17:11:44.650816+00
20231215A	Add Focalpoints	2025-09-17 17:11:44.728843+00
20240122A	Add Report URL Fields	2025-09-17 17:11:44.779609+00
20240204A	Marketplace	2025-09-17 17:11:45.292464+00
20240305A	Change Useragent Type	2025-09-17 17:11:45.474183+00
20240311A	Deprecate Webhooks	2025-09-17 17:11:45.67799+00
20240422A	Public Registration	2025-09-17 17:11:45.754416+00
20240515A	Add Session Window	2025-09-17 17:11:45.80335+00
20240701A	Add Tus Data	2025-09-17 17:11:45.853465+00
20240716A	Update Files Date Fields	2025-09-17 17:11:45.978194+00
20240806A	Permissions Policies	2025-09-17 17:11:46.831888+00
20240817A	Update Icon Fields Length	2025-09-17 17:11:47.496785+00
20240909A	Separate Comments	2025-09-17 17:11:47.619041+00
20240909B	Consolidate Content Versioning	2025-09-17 17:11:47.669825+00
20240924A	Migrate Legacy Comments	2025-09-17 17:11:47.793317+00
20240924B	Populate Versioning Deltas	2025-09-17 17:11:47.853816+00
20250224A	Visual Editor	2025-09-17 17:11:47.926859+00
20250609A	License Banner	2025-09-17 17:11:47.982141+00
20250613A	Add Project ID	2025-09-17 17:11:48.127375+00
20250718A	Add Direction	2025-09-17 17:11:48.177088+00
20250813A	Add MCP	2025-09-17 17:11:48.233021+00
\.


--
-- Data for Name: directus_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_notifications (id, "timestamp", status, recipient, sender, subject, message, collection, item) FROM stdin;
\.


--
-- Data for Name: directus_operations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_operations (id, name, key, type, position_x, position_y, options, resolve, reject, flow, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_panels; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_panels (id, dashboard, name, icon, color, show_header, note, type, position_x, position_y, width, height, options, date_created, user_created) FROM stdin;
\.


--
-- Data for Name: directus_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_permissions (id, collection, action, permissions, validation, presets, fields, policy) FROM stdin;
44	lives	read	{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}	\N	\N	*	51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d
45	live_sessions	read	{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}},{"live.status":{"_eq":"online"}}]}	\N	\N	id,live,status,started_at,ended_at,where_are_you	51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d
46	messages	read	{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"public"}}]}	\N	\N	id,live,session,sender_type,sender_name,content,sent_at,reactions,visibility,is_super,linked_request	51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d
47	songs	read	\N	\N	\N	*	51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d
48	lives	read	{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
49	live_sessions	read	{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}}]}	\N	\N	id,live,status,started_at,ended_at,where_are_you	25c07c57-7443-404e-80ee-6ea165f7a203
50	messages	read	{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"client"}}]}	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
51	songs	read	\N	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
52	messages	create	\N	\N	{"sender_type":"client","is_hidden":false,"visibility":["public","client","singer"]}	*	25c07c57-7443-404e-80ee-6ea165f7a203
53	messages	update	{"sender_user":{"_eq":"$CURRENT_USER"}}	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
54	requests	create	\N	\N	{"status":"pending"}	*	25c07c57-7443-404e-80ee-6ea165f7a203
55	requests	read	{"live.is_public":{"_eq":true}}	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
56	requests	update	{"requested_user":{"_eq":"$CURRENT_USER"}}	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
57	suggestions	create	\N	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
58	suggestions	read	{"live.is_public":{"_eq":true}}	\N	\N	*	25c07c57-7443-404e-80ee-6ea165f7a203
59	lives	create	{}	\N	{"singer":"$CURRENT_USER"}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
60	lives	read	{"singer":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
61	lives	update	{"singer":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
62	lives	delete	{"singer":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
63	live_sessions	create	{}	\N	{"artist":"$CURRENT_USER"}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
64	live_sessions	read	{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
65	live_sessions	update	{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
66	live_sessions	delete	{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
67	songs	create	{}	\N	{"owner":"$CURRENT_USER"}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
68	songs	read	{"owner":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
69	songs	update	{"owner":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
70	songs	delete	{"owner":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
71	messages	create	{}	\N	{"sender_type":"artist","sender_user":"$CURRENT_USER","is_hidden":false}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
72	messages	read	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
73	messages	update	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
74	messages	delete	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
75	requests	create	{}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
76	requests	read	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
77	requests	update	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
78	requests	delete	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
79	suggestions	create	{}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
80	suggestions	read	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
81	suggestions	update	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
82	suggestions	delete	{"live.singer":{"_eq":"$CURRENT_USER"}}	\N	\N	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
83	themes	create	{}	\N	{"owner":"$CURRENT_USER"}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
84	themes	read	{"owner":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
85	themes	update	{"owner":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
86	themes	delete	{"owner":{"_eq":"$CURRENT_USER"}}	\N	{}	*	a55ebdcc-8f22-483c-8c27-00bc458cfbed
\.


--
-- Data for Name: directus_policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_policies (id, name, icon, description, ip_access, enforce_tfa, admin_access, app_access) FROM stdin;
abf8a154-5b1c-4a46-ac9c-7300570f4f17	$t:public_label	public	$t:public_description	\N	f	f	f
b7bebd5f-3dfd-475d-91f0-1e4d7c73686c	Administrator	verified	$t:admin_description	\N	f	t	t
51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d	Public App	public	Public App	\N	f	f	t
25c07c57-7443-404e-80ee-6ea165f7a203	Client App	person	Client App	\N	f	f	t
a55ebdcc-8f22-483c-8c27-00bc458cfbed	Singer App	mic	Singer App	\N	f	f	t
\.


--
-- Data for Name: directus_presets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_presets (id, bookmark, "user", role, collection, search, layout, layout_query, layout_options, refresh_interval, filter, icon, color) FROM stdin;
4	\N	6074c864-6a99-4c14-b4cb-41be600454ff	\N	directus_users	\N	cards	{"cards":{"sort":["email"],"limit":1000,"page":1}}	{"cards":{"icon":"account_circle","title":"{{ first_name }} {{ last_name }}","subtitle":"{{ email }}","size":4}}	\N	\N	bookmark	\N
5	\N	6074c864-6a99-4c14-b4cb-41be600454ff	\N	messages	\N	\N	{"tabular":{"page":2}}	\N	\N	\N	bookmark	\N
3	\N	6074c864-6a99-4c14-b4cb-41be600454ff	\N	requests	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
6	\N	6074c864-6a99-4c14-b4cb-41be600454ff	\N	lives	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
1	\N	6074c864-6a99-4c14-b4cb-41be600454ff	\N	songs	\N	\N	{"tabular":{"limit":1000,"page":1,"fields":["artist_name","owner","recommended","title"]}}	{"tabular":{"widths":{"artist_name":160,"owner":160,"recommended":160,"title":206.39453125}}}	\N	\N	bookmark	\N
2	\N	6074c864-6a99-4c14-b4cb-41be600454ff	\N	suggestions	\N	\N	{"tabular":{"page":1}}	\N	\N	\N	bookmark	\N
\.


--
-- Data for Name: directus_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_relations (id, many_collection, many_field, one_collection, one_field, one_collection_field, one_allowed_collections, junction_field, sort_field, one_deselect_action) FROM stdin;
1	live_sessions	live	lives	\N	\N	\N	\N	\N	nullify
2	live_sessions	artist	directus_users	\N	\N	\N	\N	\N	nullify
3	lives	singer	directus_users	\N	\N	\N	\N	\N	nullify
4	messages	live	lives	\N	\N	\N	\N	\N	nullify
5	messages	session	live_sessions	\N	\N	\N	\N	\N	nullify
6	messages	sender_user	directus_users	\N	\N	\N	\N	\N	nullify
7	messages	linked_request	requests	\N	\N	\N	\N	\N	nullify
8	requests	live	lives	\N	\N	\N	\N	\N	nullify
9	requests	session	live_sessions	\N	\N	\N	\N	\N	nullify
10	requests	song	songs	\N	\N	\N	\N	\N	nullify
11	requests	accepted_by	directus_users	\N	\N	\N	\N	\N	nullify
12	songs	owner	directus_users	\N	\N	\N	\N	\N	nullify
13	suggestions	live	lives	\N	\N	\N	\N	\N	nullify
14	suggestions	session	live_sessions	\N	\N	\N	\N	\N	nullify
15	suggestions	suggested_user	directus_users	\N	\N	\N	\N	\N	nullify
\.


--
-- Data for Name: directus_revisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_revisions (id, activity, collection, item, data, delta, parent, version) FROM stdin;
1	2	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#6644FF","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_role":null,"public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"019958a9-348d-775b-8af5-62c6afe87e84","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null}	{"accepted_terms":true}	\N	\N
2	295	directus_policies	98aabdfa-8d5c-46d5-ab96-e0bb516af24c	{"name":"Public App","app_access":true,"admin_access":false,"icon":"public","description":"Public App"}	{"name":"Public App","app_access":true,"admin_access":false,"icon":"public","description":"Public App"}	\N	\N
3	296	directus_policies	4aca5a5c-0f9f-47b6-8d9b-502849cecebb	{"name":"Client App","app_access":true,"admin_access":false,"icon":"person","description":"Client App"}	{"name":"Client App","app_access":true,"admin_access":false,"icon":"person","description":"Client App"}	\N	\N
4	297	directus_policies	6a304535-b0c3-4d79-90b5-16c3f1a2846d	{"name":"Singer App","app_access":true,"admin_access":false,"icon":"mic","description":"Singer App"}	{"name":"Singer App","app_access":true,"admin_access":false,"icon":"mic","description":"Singer App"}	\N	\N
5	298	directus_roles	6322ec31-92f9-4868-b569-0417a5224157	{"name":"Client","description":"Authenticated client role"}	{"name":"Client","description":"Authenticated client role"}	\N	\N
6	299	directus_roles	2632b1a6-0fd7-4b4c-8c86-325fcc139ca6	{"name":"Singer","description":"Singer/artist role"}	{"name":"Singer","description":"Singer/artist role"}	\N	\N
7	300	directus_access	b4e599f8-818f-4f17-bbd5-d6c8dd40aa77	{"role":"6322ec31-92f9-4868-b569-0417a5224157","policy":{"id":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb"},"sort":1}	{"role":"6322ec31-92f9-4868-b569-0417a5224157","policy":{"id":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb"},"sort":1}	\N	\N
8	301	directus_access	38020759-3706-4b65-9b0c-11cdb35e69b4	{"role":"6322ec31-92f9-4868-b569-0417a5224157","policy":{"id":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb"},"sort":1}	{"role":"6322ec31-92f9-4868-b569-0417a5224157","policy":{"id":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb"},"sort":1}	\N	\N
9	302	directus_access	e3ba1847-48a1-4ddd-b25c-6cec448dc249	{"role":"6322ec31-92f9-4868-b569-0417a5224157","policy":{"id":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb"},"sort":1}	{"role":"6322ec31-92f9-4868-b569-0417a5224157","policy":{"id":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb"},"sort":1}	\N	\N
10	306	directus_access	905a022a-7d85-4df1-8410-2a1064183724	{"role":"2632b1a6-0fd7-4b4c-8c86-325fcc139ca6","policy":{"id":"6a304535-b0c3-4d79-90b5-16c3f1a2846d"},"sort":1}	{"role":"2632b1a6-0fd7-4b4c-8c86-325fcc139ca6","policy":{"id":"6a304535-b0c3-4d79-90b5-16c3f1a2846d"},"sort":1}	\N	\N
11	308	directus_permissions	1	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	\N	\N
12	309	directus_permissions	2	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}},{"live.status":{"_eq":"online"}}]}}	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}},{"live.status":{"_eq":"online"}}]}}	\N	\N
13	310	directus_permissions	3	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"messages","action":"read","fields":["id","live","session","sender_type","sender_name","content","sent_at","reactions","visibility","is_super","linked_request"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"public"}}]}}	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"messages","action":"read","fields":["id","live","session","sender_type","sender_name","content","sent_at","reactions","visibility","is_super","linked_request"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"public"}}]}}	\N	\N
14	311	directus_permissions	4	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"songs","action":"read","fields":["*"]}	{"policy":"98aabdfa-8d5c-46d5-ab96-e0bb516af24c","collection":"songs","action":"read","fields":["*"]}	\N	\N
15	312	directus_permissions	5	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	\N	\N
16	313	directus_permissions	6	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}}]}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}}]}}	\N	\N
17	314	directus_permissions	7	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"messages","action":"read","fields":["*"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"client"}}]}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"messages","action":"read","fields":["*"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"client"}}]}}	\N	\N
18	315	directus_permissions	8	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"songs","action":"read","fields":["*"]}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"songs","action":"read","fields":["*"]}	\N	\N
19	316	directus_permissions	9	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"messages","action":"create","fields":["*"],"presets":{"sender_type":"client","is_hidden":false,"visibility":["public","client","singer"]}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"messages","action":"create","fields":["*"],"presets":{"sender_type":"client","is_hidden":false,"visibility":["public","client","singer"]}}	\N	\N
20	317	directus_permissions	10	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"messages","action":"update","fields":["*"],"permissions":{"sender_user":{"_eq":"$CURRENT_USER"}}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"messages","action":"update","fields":["*"],"permissions":{"sender_user":{"_eq":"$CURRENT_USER"}}}	\N	\N
21	318	directus_permissions	11	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"requests","action":"create","fields":["*"],"presets":{"status":"pending"}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"requests","action":"create","fields":["*"],"presets":{"status":"pending"}}	\N	\N
22	319	directus_permissions	12	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"requests","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"requests","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	\N	\N
23	320	directus_permissions	13	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"requests","action":"update","fields":["*"],"permissions":{"requested_user":{"_eq":"$CURRENT_USER"}}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"requests","action":"update","fields":["*"],"permissions":{"requested_user":{"_eq":"$CURRENT_USER"}}}	\N	\N
24	321	directus_permissions	14	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"suggestions","action":"create","fields":["*"]}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"suggestions","action":"create","fields":["*"]}	\N	\N
25	322	directus_permissions	15	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	{"policy":"4aca5a5c-0f9f-47b6-8d9b-502849cecebb","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	\N	\N
26	323	directus_permissions	16	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"create","fields":["*"],"permissions":{},"presets":{"singer":"$CURRENT_USER"}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"create","fields":["*"],"permissions":{},"presets":{"singer":"$CURRENT_USER"}}	\N	\N
27	324	directus_permissions	17	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"read","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"read","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
28	325	directus_permissions	18	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"update","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"update","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
29	326	directus_permissions	19	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"delete","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"lives","action":"delete","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
30	327	directus_permissions	20	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"create","fields":["*"],"permissions":{},"presets":{"artist":"$CURRENT_USER"}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"create","fields":["*"],"permissions":{},"presets":{"artist":"$CURRENT_USER"}}	\N	\N
31	328	directus_permissions	21	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"read","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"read","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	\N	\N
32	329	directus_permissions	22	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"update","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"update","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	\N	\N
33	330	directus_permissions	23	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"delete","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"live_sessions","action":"delete","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	\N	\N
34	331	directus_permissions	24	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	\N	\N
35	332	directus_permissions	25	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
36	333	directus_permissions	26	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
37	334	directus_permissions	27	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"songs","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
38	335	directus_permissions	28	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"create","fields":["*"],"permissions":{},"presets":{"sender_type":"artist","sender_user":"$CURRENT_USER","is_hidden":false}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"create","fields":["*"],"permissions":{},"presets":{"sender_type":"artist","sender_user":"$CURRENT_USER","is_hidden":false}}	\N	\N
97	406	directus_permissions	79	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"create","fields":["*"],"permissions":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"create","fields":["*"],"permissions":{}}	\N	\N
39	336	directus_permissions	29	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
40	337	directus_permissions	30	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
41	338	directus_permissions	31	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"messages","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
42	339	directus_permissions	32	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"create","fields":["*"],"permissions":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"create","fields":["*"],"permissions":{}}	\N	\N
43	340	directus_permissions	33	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
44	341	directus_permissions	34	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
45	342	directus_permissions	35	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"requests","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
46	343	directus_permissions	36	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"create","fields":["*"],"permissions":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"create","fields":["*"],"permissions":{}}	\N	\N
47	344	directus_permissions	37	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
48	345	directus_permissions	38	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
49	346	directus_permissions	39	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"suggestions","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
50	347	directus_permissions	40	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	\N	\N
51	348	directus_permissions	41	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
52	349	directus_permissions	42	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
53	350	directus_permissions	43	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"6a304535-b0c3-4d79-90b5-16c3f1a2846d","collection":"themes","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
54	361	directus_policies	51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d	{"name":"Public App","app_access":true,"admin_access":false,"icon":"public","description":"Public App"}	{"name":"Public App","app_access":true,"admin_access":false,"icon":"public","description":"Public App"}	\N	\N
55	362	directus_policies	25c07c57-7443-404e-80ee-6ea165f7a203	{"name":"Client App","app_access":true,"admin_access":false,"icon":"person","description":"Client App"}	{"name":"Client App","app_access":true,"admin_access":false,"icon":"person","description":"Client App"}	\N	\N
56	363	directus_policies	a55ebdcc-8f22-483c-8c27-00bc458cfbed	{"name":"Singer App","app_access":true,"admin_access":false,"icon":"mic","description":"Singer App"}	{"name":"Singer App","app_access":true,"admin_access":false,"icon":"mic","description":"Singer App"}	\N	\N
57	364	directus_roles	3c9b1b03-db47-4846-b6ef-f555837147e4	{"name":"Client","description":"Authenticated client role"}	{"name":"Client","description":"Authenticated client role"}	\N	\N
58	365	directus_roles	dc4028dd-0496-404c-9735-b6db096efe4a	{"name":"Singer","description":"Singer/artist role"}	{"name":"Singer","description":"Singer/artist role"}	\N	\N
59	366	directus_access	9d6c9ee8-dfd3-48cf-a148-f9453928ca6b	{"role":"3c9b1b03-db47-4846-b6ef-f555837147e4","policy":{"id":"25c07c57-7443-404e-80ee-6ea165f7a203"},"sort":1}	{"role":"3c9b1b03-db47-4846-b6ef-f555837147e4","policy":{"id":"25c07c57-7443-404e-80ee-6ea165f7a203"},"sort":1}	\N	\N
60	368	directus_access	e0259e7c-3021-4bd7-93e0-3d8071a0d2d0	{"role":"dc4028dd-0496-404c-9735-b6db096efe4a","policy":{"id":"a55ebdcc-8f22-483c-8c27-00bc458cfbed"},"sort":1}	{"role":"dc4028dd-0496-404c-9735-b6db096efe4a","policy":{"id":"a55ebdcc-8f22-483c-8c27-00bc458cfbed"},"sort":1}	\N	\N
61	370	directus_permissions	44	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	\N	\N
62	371	directus_permissions	45	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}},{"live.status":{"_eq":"online"}}]}}	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}},{"live.status":{"_eq":"online"}}]}}	\N	\N
63	372	directus_permissions	46	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"messages","action":"read","fields":["id","live","session","sender_type","sender_name","content","sent_at","reactions","visibility","is_super","linked_request"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"public"}}]}}	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"messages","action":"read","fields":["id","live","session","sender_type","sender_name","content","sent_at","reactions","visibility","is_super","linked_request"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"public"}}]}}	\N	\N
64	373	directus_permissions	47	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"songs","action":"read","fields":["*"]}	{"policy":"51e3cfd1-0837-436a-ac5c-6d1d0f1ab01d","collection":"songs","action":"read","fields":["*"]}	\N	\N
65	374	directus_permissions	48	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"lives","action":"read","fields":["*"],"permissions":{"_and":[{"is_public":{"_eq":true}},{"status":{"_eq":"online"}}]}}	\N	\N
66	375	directus_permissions	49	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}}]}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"live_sessions","action":"read","fields":["id","live","status","started_at","ended_at","where_are_you"],"permissions":{"_and":[{"status":{"_eq":"active"}},{"live.is_public":{"_eq":true}}]}}	\N	\N
67	376	directus_permissions	50	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"messages","action":"read","fields":["*"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"client"}}]}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"messages","action":"read","fields":["*"],"permissions":{"_and":[{"is_hidden":{"_eq":false}},{"visibility":{"_contains":"client"}}]}}	\N	\N
68	377	directus_permissions	51	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"songs","action":"read","fields":["*"]}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"songs","action":"read","fields":["*"]}	\N	\N
69	378	directus_permissions	52	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"messages","action":"create","fields":["*"],"presets":{"sender_type":"client","is_hidden":false,"visibility":["public","client","singer"]}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"messages","action":"create","fields":["*"],"presets":{"sender_type":"client","is_hidden":false,"visibility":["public","client","singer"]}}	\N	\N
70	379	directus_permissions	53	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"messages","action":"update","fields":["*"],"permissions":{"sender_user":{"_eq":"$CURRENT_USER"}}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"messages","action":"update","fields":["*"],"permissions":{"sender_user":{"_eq":"$CURRENT_USER"}}}	\N	\N
71	380	directus_permissions	54	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"requests","action":"create","fields":["*"],"presets":{"status":"pending"}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"requests","action":"create","fields":["*"],"presets":{"status":"pending"}}	\N	\N
72	381	directus_permissions	55	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"requests","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"requests","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	\N	\N
73	382	directus_permissions	56	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"requests","action":"update","fields":["*"],"permissions":{"requested_user":{"_eq":"$CURRENT_USER"}}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"requests","action":"update","fields":["*"],"permissions":{"requested_user":{"_eq":"$CURRENT_USER"}}}	\N	\N
74	383	directus_permissions	57	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"suggestions","action":"create","fields":["*"]}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"suggestions","action":"create","fields":["*"]}	\N	\N
75	384	directus_permissions	58	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	{"policy":"25c07c57-7443-404e-80ee-6ea165f7a203","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.is_public":{"_eq":true}}}	\N	\N
76	385	directus_permissions	59	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"create","fields":["*"],"permissions":{},"presets":{"singer":"$CURRENT_USER"}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"create","fields":["*"],"permissions":{},"presets":{"singer":"$CURRENT_USER"}}	\N	\N
77	386	directus_permissions	60	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"read","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"read","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
78	387	directus_permissions	61	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"update","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"update","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
79	388	directus_permissions	62	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"delete","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"lives","action":"delete","fields":["*"],"permissions":{"singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
80	389	directus_permissions	63	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"create","fields":["*"],"permissions":{},"presets":{"artist":"$CURRENT_USER"}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"create","fields":["*"],"permissions":{},"presets":{"artist":"$CURRENT_USER"}}	\N	\N
81	390	directus_permissions	64	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"read","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"read","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	\N	\N
82	391	directus_permissions	65	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"update","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"update","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	\N	\N
83	392	directus_permissions	66	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"delete","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"live_sessions","action":"delete","fields":["*"],"permissions":{"_or":[{"artist":{"_eq":"$CURRENT_USER"}},{"live.singer":{"_eq":"$CURRENT_USER"}}]},"presets":{}}	\N	\N
84	393	directus_permissions	67	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	\N	\N
85	394	directus_permissions	68	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
86	395	directus_permissions	69	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
87	396	directus_permissions	70	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"songs","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
88	397	directus_permissions	71	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"create","fields":["*"],"permissions":{},"presets":{"sender_type":"artist","sender_user":"$CURRENT_USER","is_hidden":false}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"create","fields":["*"],"permissions":{},"presets":{"sender_type":"artist","sender_user":"$CURRENT_USER","is_hidden":false}}	\N	\N
89	398	directus_permissions	72	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
90	399	directus_settings	1	{"id":1,"project_name":"Directus","project_url":null,"project_color":"#0E1C2F","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":null,"default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":false,"public_registration_verify_email":true,"public_registration_role":null,"public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"019958a9-348d-775b-8af5-62c6afe87e84","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null}	{"project_color":"#0E1C2F"}	\N	\N
91	400	directus_permissions	73	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
92	401	directus_permissions	74	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"messages","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
93	402	directus_permissions	75	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"create","fields":["*"],"permissions":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"create","fields":["*"],"permissions":{}}	\N	\N
94	403	directus_permissions	76	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
95	404	directus_permissions	77	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
96	405	directus_permissions	78	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"requests","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
98	407	directus_permissions	80	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"read","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
99	408	directus_permissions	81	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"update","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
100	409	directus_permissions	82	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"suggestions","action":"delete","fields":["*"],"permissions":{"live.singer":{"_eq":"$CURRENT_USER"}}}	\N	\N
101	410	directus_permissions	83	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"create","fields":["*"],"permissions":{},"presets":{"owner":"$CURRENT_USER"}}	\N	\N
102	411	directus_permissions	84	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"read","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
103	412	directus_permissions	85	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"update","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
104	413	directus_permissions	86	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	{"policy":"a55ebdcc-8f22-483c-8c27-00bc458cfbed","collection":"themes","action":"delete","fields":["*"],"permissions":{"owner":{"_eq":"$CURRENT_USER"}},"presets":{}}	\N	\N
105	414	directus_settings	1	{"id":1,"project_name":"Bate Palco","project_url":"https://batepalco.blazysoftware.com.br/","project_color":"#0E1C2F","project_logo":null,"public_foreground":null,"public_background":null,"public_note":null,"auth_login_attempts":25,"auth_password_policy":null,"storage_asset_transform":"all","storage_asset_presets":null,"custom_css":null,"storage_default_folder":null,"basemaps":null,"mapbox_key":null,"module_bar":null,"project_descriptor":"Blazy Software","default_language":"en-US","custom_aspect_ratios":null,"public_favicon":null,"default_appearance":"auto","default_theme_light":null,"theme_light_overrides":null,"default_theme_dark":null,"theme_dark_overrides":null,"report_error_url":null,"report_bug_url":null,"report_feature_url":null,"public_registration":true,"public_registration_verify_email":false,"public_registration_role":"3c9b1b03-db47-4846-b6ef-f555837147e4","public_registration_email_filter":null,"visual_editor_urls":null,"accepted_terms":true,"project_id":"019958a9-348d-775b-8af5-62c6afe87e84","mcp_enabled":false,"mcp_allow_deletes":false,"mcp_prompts_collection":null,"mcp_system_prompt_enabled":true,"mcp_system_prompt":null}	{"project_name":"Bate Palco","project_url":"https://batepalco.blazysoftware.com.br/","project_descriptor":"Blazy Software","public_registration":true,"public_registration_verify_email":false,"public_registration_role":"3c9b1b03-db47-4846-b6ef-f555837147e4"}	\N	\N
106	416	directus_users	dff9753c-edf4-411a-840b-3dab5fd90b79	{"id":"dff9753c-edf4-411a-840b-3dab5fd90b79","first_name":"Carlos","last_name":"Souza","email":"client2@gmail.com","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"3c9b1b03-db47-4846-b6ef-f555837147e4","token":null,"last_access":"2025-09-17T17:31:11.070Z","last_page":"/content","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","plan":"premium","stage_name":null,"bio":null,"photo":null,"policies":[]}	{"role":"3c9b1b03-db47-4846-b6ef-f555837147e4"}	\N	\N
107	417	directus_users	0633d4e6-b2ec-45e3-8426-2b25e0a7c46a	{"id":"0633d4e6-b2ec-45e3-8426-2b25e0a7c46a","first_name":"Bruna","last_name":"Santos","email":"client1@gmail.com","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"3c9b1b03-db47-4846-b6ef-f555837147e4","token":null,"last_access":null,"last_page":null,"provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","plan":"free","stage_name":null,"bio":null,"photo":null,"policies":[]}	{"role":"3c9b1b03-db47-4846-b6ef-f555837147e4"}	\N	\N
108	418	directus_users	efa7f426-53ea-4a0d-9c82-2f3ea7bef900	{"id":"efa7f426-53ea-4a0d-9c82-2f3ea7bef900","first_name":"Bruna","last_name":"Santos","email":"singer1@gmail.com","password":"**********","location":null,"title":null,"description":null,"tags":null,"avatar":null,"language":null,"tfa_secret":null,"status":"active","role":"dc4028dd-0496-404c-9735-b6db096efe4a","token":null,"last_access":"2025-09-17T17:21:32.165Z","last_page":"/content","provider":"default","external_identifier":null,"auth_data":null,"email_notifications":true,"appearance":null,"theme_dark":null,"theme_light":null,"theme_light_overrides":null,"theme_dark_overrides":null,"text_direction":"auto","plan":"premium","stage_name":"Bruna Santos","bio":null,"photo":null,"policies":[]}	{"role":"dc4028dd-0496-404c-9735-b6db096efe4a"}	\N	\N
\.


--
-- Data for Name: directus_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_roles (id, name, icon, description, parent) FROM stdin;
fba63509-785a-4c2c-af41-8397ba8a9a7b	Administrator	verified	$t:admin_description	\N
3c9b1b03-db47-4846-b6ef-f555837147e4	Client	supervised_user_circle	Authenticated client role	\N
dc4028dd-0496-404c-9735-b6db096efe4a	Singer	supervised_user_circle	Singer/artist role	\N
\.


--
-- Data for Name: directus_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_sessions (token, "user", expires, ip, user_agent, share, origin, next_token) FROM stdin;
D7KL6JlfCYRIFG8Sz4ej21pE_SrQU7dRWVTKQZaodLv6vVYgNFBzYTXQn4EHjaIw	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-24 17:22:31.141+00	127.0.0.1	node	\N	\N	\N
OjOStdaJo1MHPQ7xErsfY4psG5-w73LksM5u_6doQp363P6uogqSqjARmgUYH_pM	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-24 17:27:47.782+00	127.0.0.1	node	\N	\N	\N
fEfGx5wAt2beBxJ1gWMJhIsBSBIJs9ZDsDuS4L1S1HmVOSLTRMoGMPq8dzmaFSir	dff9753c-edf4-411a-840b-3dab5fd90b79	2025-09-17 17:32:30.301+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	http://localhost:8055	_3Xnsn3WyALUu4sAC6Nk2koPhuvtP9FUFML8oC6zhpc3Er6eVoyrdwy2_obSAdLv
_3Xnsn3WyALUu4sAC6Nk2koPhuvtP9FUFML8oC6zhpc3Er6eVoyrdwy2_obSAdLv	dff9753c-edf4-411a-840b-3dab5fd90b79	2025-09-18 17:32:20.301+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	http://localhost:8055	\N
hqMVXZ-WdTwuJvZxvzq2tS0MJH2--0Q8IbLMPOcvx9J5drzinyluiEWOhfkku97y	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-17 17:41:11.225+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	http://localhost:8055	KRmSOitp6XTRCJ0a_38vdT3ORm6p0hOIZ1QM5gwICfjE4mygpF7vkgMY6XkA4NtL
KRmSOitp6XTRCJ0a_38vdT3ORm6p0hOIZ1QM5gwICfjE4mygpF7vkgMY6XkA4NtL	6074c864-6a99-4c14-b4cb-41be600454ff	2025-09-18 17:41:01.225+00	127.0.0.1	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36	\N	http://localhost:8055	\N
\.


--
-- Data for Name: directus_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_settings (id, project_name, project_url, project_color, project_logo, public_foreground, public_background, public_note, auth_login_attempts, auth_password_policy, storage_asset_transform, storage_asset_presets, custom_css, storage_default_folder, basemaps, mapbox_key, module_bar, project_descriptor, default_language, custom_aspect_ratios, public_favicon, default_appearance, default_theme_light, theme_light_overrides, default_theme_dark, theme_dark_overrides, report_error_url, report_bug_url, report_feature_url, public_registration, public_registration_verify_email, public_registration_role, public_registration_email_filter, visual_editor_urls, accepted_terms, project_id, mcp_enabled, mcp_allow_deletes, mcp_prompts_collection, mcp_system_prompt_enabled, mcp_system_prompt) FROM stdin;
1	Bate Palco	https://batepalco.blazysoftware.com.br/	#0E1C2F	\N	\N	\N	\N	25	\N	all	\N	\N	\N	\N	\N	\N	Blazy Software	en-US	\N	\N	auto	\N	\N	\N	\N	\N	\N	\N	t	f	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	t	019958a9-348d-775b-8af5-62c6afe87e84	f	f	\N	t	\N
\.


--
-- Data for Name: directus_shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_shares (id, name, collection, item, role, password, user_created, date_created, date_start, date_end, times_used, max_uses) FROM stdin;
\.


--
-- Data for Name: directus_translations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_translations (id, language, key, value) FROM stdin;
\.


--
-- Data for Name: directus_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_users (id, first_name, last_name, email, password, location, title, description, tags, avatar, language, tfa_secret, status, role, token, last_access, last_page, provider, external_identifier, auth_data, email_notifications, appearance, theme_dark, theme_light, theme_light_overrides, theme_dark_overrides, text_direction, plan, stage_name, bio, photo) FROM stdin;
853b80df-41f6-4fc8-9d61-0f16f97e6195	Carlos	Souza	singer2@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Carlos Souza	\N	\N
0633d4e6-b2ec-45e3-8426-2b25e0a7c46a	Bruna	Santos	client1@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
ec8fa8da-e121-49c1-a33c-939096607f85	Diana	Oliveira	singer3@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Diana Oliveira	\N	\N
69597add-5563-449c-b9bd-3a73db130c95	Enzo	Pereira	singer4@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Enzo Pereira	\N	\N
8cd67d06-22bf-4b17-82f8-616a7d918b86	Fernanda	Costa	singer5@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Fernanda Costa	\N	\N
12e5c01b-dbaa-4813-a104-45bdeec8ed4f	Gabi	Rodrigues	singer6@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Gabi Rodrigues	\N	\N
53af5ddf-bae0-4df0-ba45-5ae1b67185a8	Heitor	Almeida	singer7@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Heitor Almeida	\N	\N
106980ce-8139-4687-9399-7a6e6cf7d265	Iris	Gomes	singer8@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Iris Gomes	\N	\N
df24d806-6b90-4f0e-a513-40e1e643947b	João	Martins	singer9@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	João Martins	\N	\N
308d8d5a-0006-4359-9a18-44851ffc80fc	Kauã	Rocha	singer10@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Kauã Rocha	\N	\N
615086ed-c99e-475a-96d3-f730c8d3ccc6	Lia	Lima	singer11@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Lia Lima	\N	\N
d261050e-8f17-4747-8d48-06485c52e418	Maya	Silva	singer12@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Maya Silva	\N	\N
c186d4ca-47f0-4c4b-a7f2-754c01a4233a	Noah	Santos	singer13@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Noah Santos	\N	\N
bad05839-cdc3-4b41-a1e9-d2883e1eb9c0	Otávio	Souza	singer14@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Otávio Souza	\N	\N
4196d043-c3c4-47fb-b5df-c18c2c4b9921	Noah	Martins	client93@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
0916c430-a13f-4d57-ac75-6dd415d0f654	Otávio	Rocha	client94@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
17cf3eea-9950-483a-98bd-ee9173d07d1b	Pietra	Lima	client95@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
a147efde-acc0-4876-b8a4-47554eb71ac6	Rafa	Silva	client96@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
9d6e912d-5494-4d74-9012-6c6797357eb0	Sofia	Santos	client97@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
e33be628-3316-47ec-8b68-ac7783efe0cc	Theo	Souza	client98@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
bd89d6d1-9c89-4e69-87f3-734be5760161	Vitor	Oliveira	client99@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
2be2d819-946e-44a6-89c1-b35c1dc21236	Alex	Pereira	client100@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
dff9753c-edf4-411a-840b-3dab5fd90b79	Carlos	Souza	client2@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	2025-09-17 17:32:20.35+00	/content/lives	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
870bf1e5-7c67-4f2f-803a-94bebf2d0a05	Diana	Oliveira	client3@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
86590cb8-5f8f-4182-9628-8f3d475c3858	Enzo	Pereira	client4@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
84eb7570-f8c2-4082-8ab2-589d2343eba1	Fernanda	Costa	client5@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
568dfcf1-fe26-423b-b434-7f274aae43bd	Gabi	Rodrigues	client6@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
6074c864-6a99-4c14-b4cb-41be600454ff	Admin	User	admin@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	fba63509-785a-4c2c-af41-8397ba8a9a7b	\N	2025-09-17 17:41:01.274+00	/content/themes	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
d8b7abd3-8db1-4bd9-bb26-c4c259232d69	Heitor	Almeida	client7@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
74367de9-d2d5-4e8f-8826-a7a51fb06026	Iris	Gomes	client8@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
012c0aca-c238-4bb9-84e1-1923f258a7e7	João	Martins	client9@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
7ff77dd1-16a4-4d0f-8493-1945600ceefc	Kauã	Rocha	client10@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
33fee55a-91a4-4a5e-9a20-9ac01c0e74e8	Lia	Lima	client11@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
887b25b2-4eb5-41ee-88e5-ae189fac5722	Maya	Silva	client12@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
8fb38ff0-515f-4af7-82e9-bc9ca3017c08	Noah	Santos	client13@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
9b189dad-7665-4879-b258-9d53658c21b4	Otávio	Souza	client14@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
e382d151-feea-4eca-8543-562d26e12e7b	Pietra	Oliveira	client15@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
aaa8b845-e895-4245-96ac-9294f38c556e	Rafa	Pereira	client16@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
ec7c2b16-0d44-4c48-aba8-d6d3eb7e411d	Sofia	Costa	client17@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
5f3c8a71-a85e-4775-8b84-791d12f7cdaf	Theo	Rodrigues	client18@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
8cfbc55d-886b-4aa0-af98-116eb059b452	Vitor	Almeida	client19@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
60c8d47e-a2fc-4033-b3ea-d2599bf199e1	Alex	Gomes	client20@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
b71aa2f1-9d01-4256-990d-278c5ef7c069	Bruna	Martins	client21@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
ccf04871-9fad-4128-83c4-917f33bb6d3b	Carlos	Rocha	client22@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
60d18ec1-0b71-452f-9b2c-989696d8051e	Diana	Lima	client23@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
7ae96604-1904-4e6e-be37-c7c46af26300	Enzo	Silva	client24@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
76faf34e-bf1c-4740-a0b3-b4cbb788c00b	Fernanda	Santos	client25@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
f6170e99-af54-4d52-87fc-3260dcd243cf	Gabi	Souza	client26@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
df414df2-a8f6-460f-97d9-64d620b6e47f	Heitor	Oliveira	client27@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
46220dec-a630-485a-8621-982f178233f6	Iris	Pereira	client28@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
e8d87019-21f6-42cc-a9dc-f5dfe8278cbe	João	Costa	client29@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
ca5b3c05-36a7-4007-885e-d23783089870	Kauã	Rodrigues	client30@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
32928c50-1dfc-4428-b320-1cfcb4e89852	Lia	Almeida	client31@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
2197faa4-cbb6-4d9d-a39f-2fd86e96c5ad	Maya	Gomes	client32@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
965a21e2-4674-4a02-a6b7-0d588d47e393	Noah	Martins	client33@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
f40fdb82-28b5-4a6d-b614-262c384ac2a3	Otávio	Rocha	client34@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
97d087ee-6f3f-44c9-a6be-bac8b6203d59	Pietra	Lima	client35@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
e9e992be-65f4-49ec-98ad-c45461710192	Rafa	Silva	client36@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
4b136c27-1968-4035-867c-bba0a04f76aa	Sofia	Santos	client37@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
9fc388b1-ad26-47dd-8d29-83747528d301	Theo	Souza	client38@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
e2702e57-9e4c-4d3e-9d01-3b43f6ccf03a	Vitor	Oliveira	client39@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
c868c121-f857-471a-a7d4-3552bfe4845c	Alex	Pereira	client40@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
b0a5591a-0c9d-4ea0-8a2c-4d91399b6079	Bruna	Costa	client41@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
4e9e58dd-3309-4925-9345-f828b8faa128	Carlos	Rodrigues	client42@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
2a2acc21-29ed-470e-9427-65da8e8f223d	Diana	Almeida	client43@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
ba0398d3-92f4-4cf4-94e7-c19159f93ffc	Enzo	Gomes	client44@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
670a76f7-f0d1-4f93-82b8-184d1d922ff4	Fernanda	Martins	client45@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
40bd3440-f790-48dd-9ee0-19078c94bc6f	Gabi	Rocha	client46@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
12c1c7cc-f9b7-43dd-80f2-70af35e96108	Heitor	Lima	client47@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
f0eef585-82ff-4408-8552-13a24c0ecc92	Iris	Silva	client48@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
4cbb84c0-244d-4e33-8844-ef054e3c8c1a	João	Santos	client49@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
fe3d556e-bb08-44af-be13-bf660bbba0c1	Kauã	Souza	client50@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
b04d9d5f-71b9-46ce-8c55-bd1b67782456	Lia	Oliveira	client51@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
2d5caed0-3720-4aa7-972c-068d6b55250f	Maya	Pereira	client52@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
b2164e5e-2559-42b9-a66b-8f91b02fcd49	Noah	Costa	client53@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
e876cc9f-b2c7-4911-ba07-9399afa9ddf1	Otávio	Rodrigues	client54@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
c091b8c2-f2fc-4b5f-a244-f31de064d069	Pietra	Almeida	client55@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
15640c05-441b-4110-a37f-107b84288842	Rafa	Gomes	client56@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
12d374ec-9e70-41bc-9d60-cacdda68c303	Sofia	Martins	client57@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
1a191824-af19-4add-8ec6-94be88e25ab1	Theo	Rocha	client58@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
cff145c9-ca5f-45f7-a10e-b17bfcb66609	Vitor	Lima	client59@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
2ee3bc81-caad-41f7-bda8-5625ce243149	Alex	Silva	client60@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
d9474f7a-a419-47db-941b-0e3a9f5ef915	Bruna	Santos	client61@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
55d54d77-368d-4509-bc5c-a1b5d8f424b0	Carlos	Souza	client62@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
38b1ba8a-87f3-4530-9709-d26c961967ad	Diana	Oliveira	client63@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
3d78baed-9574-424c-abc2-8d6b18bff6e7	Enzo	Pereira	client64@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
526d2a28-d928-43aa-a66e-1ceadf0d9b39	Fernanda	Costa	client65@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
0e0c0d68-5b35-47df-a406-877e2ef41320	Gabi	Rodrigues	client66@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
2129d49b-e869-4a53-a224-a42c31b06c34	Heitor	Almeida	client67@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
4eb6e26d-822b-4b2a-8014-f1dcf6d94c45	Iris	Gomes	client68@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
cee4fabf-0a6c-44d4-8939-99d1fc0a0624	João	Martins	client69@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
c2930772-eabe-4286-a830-42512e4c0b5b	Kauã	Rocha	client70@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
44c1ef76-dfe6-48ff-ae40-fb0c438108d5	Lia	Lima	client71@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
e86a3b43-4ea7-4c5e-8665-83b9beb6a206	Maya	Silva	client72@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
dba54fca-fd9e-456a-9c64-c9f368e57055	Noah	Santos	client73@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
8bddad1a-0587-408d-bea1-8dc3975211ac	Otávio	Souza	client74@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
ff85e305-8309-404d-8ced-ffe9d39b44c2	Pietra	Oliveira	client75@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
2b5d94ec-2713-441d-9d65-7a9375a8d396	Rafa	Pereira	client76@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
d4adc38d-e18e-4fa0-a522-273444a13560	Sofia	Costa	client77@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
03211374-536e-4063-9383-f5ee6f9c7120	Theo	Rodrigues	client78@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
93c251e8-81d5-44b1-b34f-328c7b587602	Vitor	Almeida	client79@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
931f56ce-fbd3-44cf-9ba5-f13332ea3ff7	Alex	Gomes	client80@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
fea75d17-0bbb-49f7-ad1f-a084a1c689db	Bruna	Martins	client81@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
a2ea83b1-08d3-4c1e-8060-4ffb511fc5e6	Carlos	Rocha	client82@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
dd43a361-6a4f-4c88-b950-8a8e72b442d2	Diana	Lima	client83@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
03566fb3-1e5b-41f5-8f03-2ba537d808a1	Enzo	Silva	client84@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
b7427dbe-ce1f-43c1-b776-d1fffab56e4b	Fernanda	Santos	client85@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
1946a00b-2cb6-47b2-aa80-806c469d78bc	Gabi	Souza	client86@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
f17b5ecd-11a8-4501-a588-a815b2a87998	Heitor	Oliveira	client87@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
bf55993a-97ea-4815-8ddb-55decd1a957c	Iris	Pereira	client88@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
f217a346-d557-4198-bdbd-4bc71ca25d4f	João	Costa	client89@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
8b08ac78-5e7b-4066-93de-0d51a0b0b830	Kauã	Rodrigues	client90@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
1c3417e8-4d11-4843-9bf7-bf2cdd3f5941	Lia	Almeida	client91@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	\N	\N	\N
ffae9c41-7b4f-4580-b1d3-28afd57a6a47	Maya	Gomes	client92@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	3c9b1b03-db47-4846-b6ef-f555837147e4	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	\N	\N	\N
d93366b3-d46d-47ee-bf4f-477d79793fca	Pietra	Oliveira	singer15@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Pietra Oliveira	\N	\N
2bc86301-a41c-4e50-bdeb-eb05b473a8da	Rafa	Pereira	singer16@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Rafa Pereira	\N	\N
d7ec7a4b-ba40-4309-aa9c-7b678c749f78	Sofia	Costa	singer17@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Sofia Costa	\N	\N
c87940b8-79b9-4e0c-9dd5-b08e3a532456	Theo	Rodrigues	singer18@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Theo Rodrigues	\N	\N
342bb433-74fd-4348-92bf-7f8924f646e2	Vitor	Almeida	singer19@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Vitor Almeida	\N	\N
b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0	Alex	Gomes	singer20@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	\N	\N	default	\N	\N	t	\N	\N	\N	\N	\N	auto	free	Alex Gomes	\N	\N
efa7f426-53ea-4a0d-9c82-2f3ea7bef900	Bruna	Santos	singer1@gmail.com	$argon2id$v=19$m=65536,t=3,p=4$eXqBMg8fwuUZwJJlNBFb1Q$hcsWIzztI78IGycvTHhjuYSh4Q2sEq3Pd2zXDC0iXZo	\N	\N	\N	\N	\N	\N	\N	active	dc4028dd-0496-404c-9735-b6db096efe4a	\N	2025-09-17 17:21:32.165+00	/content	default	\N	\N	t	\N	\N	\N	\N	\N	auto	premium	Bruna Santos	\N	\N
\.


--
-- Data for Name: directus_versions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_versions (id, key, name, collection, item, hash, date_created, date_updated, user_created, user_updated, delta) FROM stdin;
\.


--
-- Data for Name: directus_webhooks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.directus_webhooks (id, name, method, url, status, data, actions, collections, headers, was_active_before_deprecation, migrated_flow) FROM stdin;
\.


--
-- Data for Name: live_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.live_sessions (id, live, artist, name, status, started_at, ended_at, where_are_you) FROM stdin;
c586fd85-784b-4f00-93eb-0fb54a070780	c87e7317-b008-4cc6-a499-3dcdfa07260e	308d8d5a-0006-4359-9a18-44851ffc80fc	Session live-singer-1	active	2025-09-17 17:20:56.464544	\N	["3f3005b5-12a5-489a-b54c-a8c46c8f2578", "bb38abe1-d439-42c9-a01d-3269c88a8bef", "670d61d4-d6d6-4e4a-933f-9cae136eaf3d"]
996358e1-dae4-4e23-9671-0ce9dc427815	12b6937a-e9d3-4e8d-8d97-1e19adf0343a	d7ec7a4b-ba40-4309-aa9c-7b678c749f78	Session live-singer-8	active	2025-09-17 17:20:56.464544	\N	["e379327b-e912-489b-9a13-41e74bdc92c4", "e8e4d1bf-8e7a-4f83-bd08-4b944389c0bd", "bb7cd814-56d4-447d-a74b-23889e2276d6"]
b8435509-9952-426d-8b80-92440c1cf734	f6ec4aa8-3bab-4f7d-ba22-c01a6669c079	615086ed-c99e-475a-96d3-f730c8d3ccc6	Session live-singer-2	active	2025-09-17 17:20:56.464544	\N	["dc1759f5-b3e5-4284-ade9-fa6882bb2063", "dfc6994a-ecf9-40a0-99dc-ee36c58830c9", "d5f56f92-5d35-4080-8dcf-cba0db7376dd"]
256a29de-d831-45f0-a8d4-31d32a280b67	3298e1f7-be22-4176-8dc2-2f09d6c42778	c186d4ca-47f0-4c4b-a7f2-754c01a4233a	Session live-singer-4	active	2025-09-17 17:20:56.464544	\N	["c9e53540-0654-4490-a5bc-3efcc8639d0f", "fd511e42-bd18-4b3f-8b6e-b8b5a708a9b5", "eb32f1a9-ce52-4c0b-abe7-6e791d390534"]
56d83e24-930c-4ea0-a81e-a087e1fcdd92	4e311055-baf2-4778-9c4e-731f6f624f68	c87940b8-79b9-4e0c-9dd5-b08e3a532456	Session live-singer-9	active	2025-09-17 17:20:56.464544	\N	["2debe67e-5254-4cf4-aa45-08bcac32dd28", "09409edb-d489-4fec-8a11-3a622e358015", "2a504689-9a6d-4eca-9844-da0915b5b0a9"]
d864b34c-67e8-434c-8fc9-c6ee1882b1a2	7c319a9c-e2b2-4285-a9dd-787fc9ddc42e	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0	Session live-singer-5	active	2025-09-17 17:20:56.464544	\N	["cc8dff40-058f-4307-9829-00fa29bf5f42", "0ff2bfd7-413e-46c4-a156-c04af63e47b4", "507128b3-afee-41b0-ab70-0c6a7e2cae18"]
d46a246d-5af6-4ca3-8629-bc711445bcf5	4185d005-063f-4c7e-bc86-2a3a066deda1	342bb433-74fd-4348-92bf-7f8924f646e2	Session live-singer-10	active	2025-09-17 17:20:56.464544	\N	["d126709e-f723-4862-99ee-7d4839b33ff1", "514251a6-a9e0-45ba-95b8-f44d24f4afce", "83e763c3-88de-4bb6-bc1d-879e88f421a2"]
f353cbf5-8034-4640-ac05-42943794edfa	06f94cd8-d3f3-4a1b-a68b-c68ce0920ced	d93366b3-d46d-47ee-bf4f-477d79793fca	Session live-singer-6	active	2025-09-17 17:20:56.464544	\N	["56309780-9fd1-4a70-a08b-4335e6dee742", "60efe8fb-0eeb-4256-a4f7-d7f838127506", "7861133f-f232-42f3-abb5-0bb4c418b886"]
9349e62d-0094-49fd-8e47-f7ea4f4ac7de	22445f47-43fc-44b9-8940-c242ba9cee54	2bc86301-a41c-4e50-bdeb-eb05b473a8da	Session live-singer-7	active	2025-09-17 17:20:56.464544	\N	["13d71800-e3d4-4a60-ac09-9d54cd9aa168", "a31adaf7-cb27-4ed8-8754-31a6103db4bd", "fb74f167-2686-45a1-b4c9-6e2eb6efe1b2"]
053f40c0-7a87-47d4-af25-062afbcfb298	29be0ac8-f7f2-41ad-9adb-e9b6535f680e	d261050e-8f17-4747-8d48-06485c52e418	Session live-singer-3	active	2025-09-17 17:20:56.464544	\N	["c1e7aac1-3fcf-44eb-8de4-0edd04d42703", "c38f2c15-91ba-4c7d-b575-37913e771a9c", "ed5acc0c-821e-42d8-9387-cd18be086b5a"]
\.


--
-- Data for Name: lives; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lives (id, date_created, name, slug, reusable, is_public, max_messages_per_client, comment_cooldown_seconds, max_song_requests_per_client, status, date_event, singer) FROM stdin;
984cb381-e727-41d2-b21f-984a2c1867da	\N	Live João Martins	live-singer-20	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	df24d806-6b90-4f0e-a513-40e1e643947b
68a64a3c-4d68-4a26-80dc-1c343f44129f	\N	Live Fernanda Costa	live-singer-16	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	8cd67d06-22bf-4b17-82f8-616a7d918b86
c87e7317-b008-4cc6-a499-3dcdfa07260e	\N	Live Kauã Rocha	live-singer-1	t	t	98	5	20	online	2025-09-17 17:20:56.440894	308d8d5a-0006-4359-9a18-44851ffc80fc
f0888ab2-0155-4ada-8084-59afa0ead254	\N	Live Heitor Almeida	live-singer-18	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	53af5ddf-bae0-4df0-ba45-5ae1b67185a8
12b6937a-e9d3-4e8d-8d97-1e19adf0343a	\N	Live Sofia Costa	live-singer-8	t	t	98	5	20	online	2025-09-17 17:20:56.440894	d7ec7a4b-ba40-4309-aa9c-7b678c749f78
f6ec4aa8-3bab-4f7d-ba22-c01a6669c079	\N	Live Lia Lima	live-singer-2	t	t	98	5	20	online	2025-09-17 17:20:56.440894	615086ed-c99e-475a-96d3-f730c8d3ccc6
b0008b85-b59e-461b-a3be-5e36825ec56b	\N	Live Bruna Santos	live-singer-11	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	efa7f426-53ea-4a0d-9c82-2f3ea7bef900
affb62ce-6a72-46c4-b0e0-aa788d80cb3c	\N	Live Carlos Souza	live-singer-13	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	853b80df-41f6-4fc8-9d61-0f16f97e6195
3298e1f7-be22-4176-8dc2-2f09d6c42778	\N	Live Noah Santos	live-singer-4	t	t	98	5	20	online	2025-09-17 17:20:56.440894	c186d4ca-47f0-4c4b-a7f2-754c01a4233a
4e311055-baf2-4778-9c4e-731f6f624f68	\N	Live Theo Rodrigues	live-singer-9	t	t	98	5	20	online	2025-09-17 17:20:56.440894	c87940b8-79b9-4e0c-9dd5-b08e3a532456
7c319a9c-e2b2-4285-a9dd-787fc9ddc42e	\N	Live Otávio Souza	live-singer-5	t	t	98	5	20	online	2025-09-17 17:20:56.440894	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0
4c5b9b67-5af5-4abc-b09a-ba26a92b395c	\N	Live Diana Oliveira	live-singer-14	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	ec8fa8da-e121-49c1-a33c-939096607f85
4185d005-063f-4c7e-bc86-2a3a066deda1	\N	Live Vitor Almeida	live-singer-10	t	t	98	5	20	online	2025-09-17 17:20:56.440894	342bb433-74fd-4348-92bf-7f8924f646e2
e0959493-cd41-4507-8874-abead8c3ed8b	\N	Live Iris Gomes	live-singer-19	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	106980ce-8139-4687-9399-7a6e6cf7d265
06f94cd8-d3f3-4a1b-a68b-c68ce0920ced	\N	Live Pietra Oliveira	live-singer-6	t	t	98	5	20	online	2025-09-17 17:20:56.440894	d93366b3-d46d-47ee-bf4f-477d79793fca
22445f47-43fc-44b9-8940-c242ba9cee54	\N	Live Rafa Pereira	live-singer-7	t	t	98	5	20	online	2025-09-17 17:20:56.440894	2bc86301-a41c-4e50-bdeb-eb05b473a8da
1154744c-d577-4fd4-aac0-d8ba9dec30bf	\N	Live Enzo Pereira	live-singer-15	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	69597add-5563-449c-b9bd-3a73db130c95
574cfb74-0046-4c17-a81e-e99dab6ccdb7	\N	Live Alex Gomes	live-singer-12	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0
29be0ac8-f7f2-41ad-9adb-e9b6535f680e	\N	Live Maya Silva	live-singer-3	t	t	98	5	20	online	2025-09-17 17:20:56.440894	d261050e-8f17-4747-8d48-06485c52e418
edbe9fca-9d0c-4a1b-984e-a454c9de9e44	\N	Live Gabi Rodrigues	live-singer-17	t	t	98	5	20	offline	2025-09-17 17:20:56.440894	12e5c01b-dbaa-4813-a104-45bdeec8ed4f
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, live, session, sender_type, sender_name, sender_user, content, sent_at, reactions, visibility, is_super, is_hidden, key_live, linked_request) FROM stdin;
a8444a2e-87e7-4934-ab55-ef9575f75109	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	artist	Kauã Rocha	308d8d5a-0006-4359-9a18-44851ffc80fc	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	0d458173-5e5a-44fc-b5b2-a5d0a00bd24e	\N
b45a8bf9-dd79-4030-99fd-ae459f6ce961	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Alex Pereira	2be2d819-946e-44a6-89c1-b35c1dc21236	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	50d3fcd3-6840-45d4-a8da-cdea9f0b301f	\N
3562dd8d-83ab-4bc5-9881-eacfd044125e	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Kauã Rocha	7ff77dd1-16a4-4d0f-8493-1945600ceefc	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	d9a4dc77-f7a6-4ed8-aa48-a60c1e5d4154	\N
a092d866-c696-4861-a81e-fd15a13e3d19	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Lia Lima	33fee55a-91a4-4a5e-9a20-9ac01c0e74e8	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	6b45e6e0-c9ff-4899-b765-e6fcf96b6973	\N
662ec239-d8fb-426e-96c1-b0e381eb114f	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Maya Silva	887b25b2-4eb5-41ee-88e5-ae189fac5722	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	009536ad-7092-4505-9f38-4663c3d79d69	\N
6ec1b35e-4935-4546-afeb-9f42e66dd9ed	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Noah Santos	8fb38ff0-515f-4af7-82e9-bc9ca3017c08	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	fd912f89-f068-4bc3-bd6f-17fb4856b910	\N
b34d16ee-f0e4-4d8d-8cac-8970ab4b96d7	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Otávio Souza	9b189dad-7665-4879-b258-9d53658c21b4	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	af0830e4-d7e7-4ab3-b187-0c3cfec11605	\N
3262d073-7bc8-49a3-99d4-58265a8ad304	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Pietra Oliveira	e382d151-feea-4eca-8543-562d26e12e7b	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	c7cda8e5-2c15-4bb8-a7dc-72390992bd46	\N
01eef6ce-e89b-4108-81d6-bb9afcb6b802	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Rafa Pereira	aaa8b845-e895-4245-96ac-9294f38c556e	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	43b4e895-7458-4133-8fa8-48e0e5b73853	\N
a441254a-312a-4fea-a2a4-9bb2929c5d24	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Sofia Costa	ec7c2b16-0d44-4c48-aba8-d6d3eb7e411d	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	625bcf25-1b24-4352-b35f-679d927b5569	\N
fb334b25-2c16-4b1d-b2ec-9de86e7303f8	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Theo Rodrigues	5f3c8a71-a85e-4775-8b84-791d12f7cdaf	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	5edc4891-8355-43b2-a086-60e45075aeaa	\N
e96d3dc3-c126-4ac9-86be-666c8df0a243	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Vitor Almeida	8cfbc55d-886b-4aa0-af98-116eb059b452	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	19c9e65e-5d09-458a-8171-431ced0ecbc8	\N
12997fdb-9a31-4fc3-9188-539071d720a8	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Bruna Santos	0633d4e6-b2ec-45e3-8426-2b25e0a7c46a	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	b9cc1a9b-5ef3-41ec-8612-a391b7378412	\N
282c5ede-52ea-4e79-8021-fbc24794fff0	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Alex Gomes	60c8d47e-a2fc-4033-b3ea-d2599bf199e1	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	49e39b28-0b1f-4fd5-b78b-c73d4a972303	\N
ce2dc70e-b57e-40da-a22a-bfc5a834515f	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Bruna Martins	b71aa2f1-9d01-4256-990d-278c5ef7c069	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	9e04d749-f402-4c12-8f61-e8b90a89b271	\N
129413bd-6c55-4229-8b78-2ed0db1dbef1	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Carlos Rocha	ccf04871-9fad-4128-83c4-917f33bb6d3b	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	cab7549d-fa8a-48a9-ad93-7446307a615f	\N
731611f5-3b42-4794-a57e-7d39a1c0d5de	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Diana Lima	60d18ec1-0b71-452f-9b2c-989696d8051e	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	7728e8ac-c385-4a17-a92e-086c80f8a353	\N
754c1680-ea27-41b3-a8dc-7edacc91be93	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Enzo Silva	7ae96604-1904-4e6e-be37-c7c46af26300	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	d2b244da-7007-4bcc-b8b5-4a78eadeb6fd	\N
8f441a40-8cf3-4fd8-a594-0af6bdf67d7e	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Fernanda Santos	76faf34e-bf1c-4740-a0b3-b4cbb788c00b	Manda aquela clássica!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	95a995e5-8a05-47e5-8025-4fc790c67785	\N
ffb575a6-5add-4d9a-8a37-e94e62530acb	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Gabi Souza	f6170e99-af54-4d52-87fc-3260dcd243cf	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	2e85e5ec-e2ca-4b3d-8933-6ef790a0f3bc	\N
eef5505a-c0b6-466b-8861-18722475c9ca	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	client	Heitor Oliveira	df414df2-a8f6-460f-97d9-64d620b6e47f	🔥 Muito bom!	2025-09-17 17:20:56.522838	["👏","❤️"]	["public","client","singer"]	f	f	7edef741-56d5-4c49-aca8-ecf1259abd32	\N
6c19e50b-a1a5-442d-9569-58057ebaf4c0	12b6937a-e9d3-4e8d-8d97-1e19adf0343a	996358e1-dae4-4e23-9671-0ce9dc427815	artist	Sofia Costa	d7ec7a4b-ba40-4309-aa9c-7b678c749f78	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	b030edaa-cb17-4d60-be9d-7a0dc09be01a	\N
852ca099-6b3a-4c59-93b3-48ff54c7cb21	f6ec4aa8-3bab-4f7d-ba22-c01a6669c079	b8435509-9952-426d-8b80-92440c1cf734	artist	Lia Lima	615086ed-c99e-475a-96d3-f730c8d3ccc6	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	c2e82248-57db-4278-ab84-42a6fde26c0d	\N
7362f944-acb1-4d19-8a6c-274fa2044325	3298e1f7-be22-4176-8dc2-2f09d6c42778	256a29de-d831-45f0-a8d4-31d32a280b67	artist	Noah Santos	c186d4ca-47f0-4c4b-a7f2-754c01a4233a	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	cdab728f-5931-4cf3-a006-e6d6cfca6bcb	\N
7c853477-bd3f-418a-a3a3-9b80cc6ea088	4e311055-baf2-4778-9c4e-731f6f624f68	56d83e24-930c-4ea0-a81e-a087e1fcdd92	artist	Theo Rodrigues	c87940b8-79b9-4e0c-9dd5-b08e3a532456	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	9c40dd7b-53fc-42d6-a977-1a6e9c471a58	\N
37e323ee-361a-428e-b4f1-2db92c3df7b0	7c319a9c-e2b2-4285-a9dd-787fc9ddc42e	d864b34c-67e8-434c-8fc9-c6ee1882b1a2	artist	Otávio Souza	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	063e0f19-1f4c-4d71-815b-f57cbd97dcab	\N
6cb95cf9-8df0-4fd5-bace-22ac557ebc4a	4185d005-063f-4c7e-bc86-2a3a066deda1	d46a246d-5af6-4ca3-8629-bc711445bcf5	artist	Vitor Almeida	342bb433-74fd-4348-92bf-7f8924f646e2	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	12d6b03c-12be-477d-829d-a3ca09fcdeb8	\N
b9430e5e-0fda-4293-88b4-b19b59b6f4dd	06f94cd8-d3f3-4a1b-a68b-c68ce0920ced	f353cbf5-8034-4640-ac05-42943794edfa	artist	Pietra Oliveira	d93366b3-d46d-47ee-bf4f-477d79793fca	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	b8f92305-24e5-4239-9faa-a7de39dd08d7	\N
e6591513-acc3-4aaf-a71d-12bbf965b5c2	22445f47-43fc-44b9-8940-c242ba9cee54	9349e62d-0094-49fd-8e47-f7ea4f4ac7de	artist	Rafa Pereira	2bc86301-a41c-4e50-bdeb-eb05b473a8da	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	373117b9-8c2f-4aeb-9633-2e32cbae016f	\N
c4624f4f-3c81-4d7f-befa-690dbd168e98	29be0ac8-f7f2-41ad-9adb-e9b6535f680e	053f40c0-7a87-47d4-af25-062afbcfb298	artist	Maya Silva	d261050e-8f17-4747-8d48-06485c52e418	Bem-vindos à live! 🎤	2025-09-17 17:20:56.522838	["🎶","🔥"]	["public","client","singer"]	f	f	76d6873b-45c0-486a-a5fb-046acd09c93f	\N
\.


--
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.requests (id, live, session, song, status, requested_by, requested_user, requested_at, reactions, is_super, superchat_type, played_at, answered_at, accepted_by, key_live) FROM stdin;
bc395e29-1cab-44b0-9016-badd30104b79	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	51a63c69-872c-4c17-87c4-692de62b54e8	pending	Maya Silva	887b25b2-4eb5-41ee-88e5-ae189fac5722	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	339fc3ce-f034-421a-bf9a-c0ff0c7f25f9
981b8848-cddb-4e14-9b66-607ea1e25c84	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	a6bd83d2-6269-49d6-9c2a-d156141b3af8	pending	Noah Santos	8fb38ff0-515f-4af7-82e9-bc9ca3017c08	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	7d5f1780-3f79-4be5-92e0-eba507514a0f
a452605f-20a1-46f9-a5d0-34c6d679deb1	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	51a63c69-872c-4c17-87c4-692de62b54e8	pending	Otávio Souza	9b189dad-7665-4879-b258-9d53658c21b4	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	5e01627e-612a-4bad-bf87-3ec31ef1e3f4
dbe2097a-0174-4075-8a76-893232c0d4e5	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	90b785a6-5876-4469-8597-4c7ab70d9ebe	pending	Pietra Oliveira	e382d151-feea-4eca-8543-562d26e12e7b	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	29d0a452-e612-4498-8b8b-9d1c59035c2a
fafa9eb5-7f97-49f1-92a1-09726cfaa0ca	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	0aef625c-806c-43ba-9694-e3e5a9d79cf6	pending	Rafa Pereira	aaa8b845-e895-4245-96ac-9294f38c556e	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	19aee3b4-8baa-45c6-833c-1fbfa10dade9
046c631e-8b96-4c3c-9e16-5f2423fb2d8f	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	a6bd83d2-6269-49d6-9c2a-d156141b3af8	pending	Sofia Costa	ec7c2b16-0d44-4c48-aba8-d6d3eb7e411d	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	5eb49490-15cd-440b-a097-c6d4a1ac3aa3
3bda2ddc-2181-405d-bde2-ab339f2c85da	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	3a3ee5cd-8481-47d3-a80c-711c053b0148	pending	Theo Rodrigues	5f3c8a71-a85e-4775-8b84-791d12f7cdaf	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	480247c6-cdb0-4436-8f72-3258a890c169
14bb2f2e-034d-493d-b7ad-cc34a7b9cb60	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	9453ebf9-772b-41b3-a3c7-639ed292e7cb	pending	Vitor Almeida	8cfbc55d-886b-4aa0-af98-116eb059b452	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	87013eff-ad57-42f3-8a7a-83c1f7b8412e
07f53575-0842-4402-bbd3-08a03ae9d3d4	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	51a63c69-872c-4c17-87c4-692de62b54e8	pending	Bruna Santos	0633d4e6-b2ec-45e3-8426-2b25e0a7c46a	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	bdce5224-45fe-466f-9444-cba69988a184
b5cd5591-99ed-41ae-a068-388d7360515f	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	3a3ee5cd-8481-47d3-a80c-711c053b0148	pending	Alex Gomes	60c8d47e-a2fc-4033-b3ea-d2599bf199e1	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	674277b1-411e-4c19-ab60-95787839be86
ce09ac0c-1570-4b25-ab6f-86bc91a45ee5	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	90b785a6-5876-4469-8597-4c7ab70d9ebe	pending	Bruna Martins	b71aa2f1-9d01-4256-990d-278c5ef7c069	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	5804137e-0ad4-485c-a698-6102fb13f53e
b290d607-8bbf-47e9-8fc3-3e2d1c9b2574	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	3a3ee5cd-8481-47d3-a80c-711c053b0148	pending	Carlos Rocha	ccf04871-9fad-4128-83c4-917f33bb6d3b	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	0f4a70a4-a8a7-47fa-84f7-b97ca7efb85f
706e8ad3-9dda-425a-89a3-f62e444b9c47	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	3a3ee5cd-8481-47d3-a80c-711c053b0148	pending	Diana Lima	60d18ec1-0b71-452f-9b2c-989696d8051e	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	914d0deb-abfb-4cbc-957f-bf5bbf2cb698
b1427781-85b8-4930-bc50-db73744f96c1	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	3a3ee5cd-8481-47d3-a80c-711c053b0148	pending	Enzo Silva	7ae96604-1904-4e6e-be37-c7c46af26300	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	21b81784-9718-481f-91cb-c7b9f84b035c
ed0b3bfe-4f94-422e-9603-60ae903aa0ed	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	0aef625c-806c-43ba-9694-e3e5a9d79cf6	pending	Fernanda Santos	76faf34e-bf1c-4740-a0b3-b4cbb788c00b	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	a6232331-ec50-478e-80e8-a7952f71be70
c74c93ab-ba4c-4331-ad09-3e58bc79f270	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	51a63c69-872c-4c17-87c4-692de62b54e8	pending	Gabi Souza	f6170e99-af54-4d52-87fc-3260dcd243cf	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	b88782fd-bb9b-4155-9d86-a91b0be5302f
94982b58-94aa-44eb-aed5-bdadd68031d8	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	3a3ee5cd-8481-47d3-a80c-711c053b0148	pending	Heitor Oliveira	df414df2-a8f6-460f-97d9-64d620b6e47f	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	9827bacf-e92a-4a50-bf63-05013df52004
794613b3-46b5-4270-89e6-c95d2451d3e0	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	3a3ee5cd-8481-47d3-a80c-711c053b0148	pending	Alex Pereira	2be2d819-946e-44a6-89c1-b35c1dc21236	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	80f1da16-fc05-4033-9690-fd83511cbbd5
323373e0-559b-456e-9fe5-2b611649cffb	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	51a63c69-872c-4c17-87c4-692de62b54e8	pending	Kauã Rocha	7ff77dd1-16a4-4d0f-8493-1945600ceefc	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	9b4eb7ab-6f4d-45da-9965-476f6bd0d700
64bb806a-f17b-417b-a5ce-ea7b7c620272	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	51a63c69-872c-4c17-87c4-692de62b54e8	pending	Lia Lima	33fee55a-91a4-4a5e-9a20-9ac01c0e74e8	2025-09-17 17:20:56.522838	["🔥"]	f	basic	\N	\N	\N	4753a82b-c3c9-4a0a-942d-6d7c009a1824
\.


--
-- Data for Name: songs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.songs (id, title, artist_name, recommended, owner) FROM stdin;
f5989da4-b57a-4a42-bd18-608e92160eb9	Bohemian Rhapsody	Queen	t	efa7f426-53ea-4a0d-9c82-2f3ea7bef900
545073d9-22d9-47ff-a43c-b71bba9dd83a	Hotel California	Eagles	t	efa7f426-53ea-4a0d-9c82-2f3ea7bef900
9f3d3ab8-b3f3-4fb3-a456-22d0764dcd51	Wonderwall	Oasis	f	efa7f426-53ea-4a0d-9c82-2f3ea7bef900
6a300fdb-6957-4e15-88f2-18b05c2e9359	Sweet Child O' Mine	Guns N' Roses	f	efa7f426-53ea-4a0d-9c82-2f3ea7bef900
bb2cc62b-673b-41f6-a9df-1d6f30f70d1b	Shape of You	Ed Sheeran	f	efa7f426-53ea-4a0d-9c82-2f3ea7bef900
7dce9b5c-8edf-4ea4-a69e-4a163584a34e	Chandelier	Sia	f	efa7f426-53ea-4a0d-9c82-2f3ea7bef900
0aae3469-309d-44b5-8ae8-ca7f98417f5c	Bohemian Rhapsody	Queen	t	853b80df-41f6-4fc8-9d61-0f16f97e6195
50c53fb4-30cd-4ebc-9e52-a4973f4c2eac	Hotel California	Eagles	t	853b80df-41f6-4fc8-9d61-0f16f97e6195
7ddf2e09-b7c6-4f45-b4d2-08a59b489363	Wonderwall	Oasis	f	853b80df-41f6-4fc8-9d61-0f16f97e6195
5a157f1d-abd5-43ad-90a1-4d44063c28ff	Sweet Child O' Mine	Guns N' Roses	f	853b80df-41f6-4fc8-9d61-0f16f97e6195
7b70d6a1-654b-43df-90ac-19c893248bf5	Shape of You	Ed Sheeran	f	853b80df-41f6-4fc8-9d61-0f16f97e6195
eff56777-3ece-4421-931b-98cdcc326f6d	Chandelier	Sia	f	853b80df-41f6-4fc8-9d61-0f16f97e6195
b65d8412-940b-4aa4-99c9-73c44a83dfeb	Bohemian Rhapsody	Queen	t	ec8fa8da-e121-49c1-a33c-939096607f85
3e4c47c4-a76d-48a7-b774-339c4224069a	Hotel California	Eagles	t	ec8fa8da-e121-49c1-a33c-939096607f85
e089e46b-4690-4f8f-a8b2-542f2595db99	Wonderwall	Oasis	f	ec8fa8da-e121-49c1-a33c-939096607f85
dd5d49ea-da3f-4674-98ea-9c3e1805a82f	Sweet Child O' Mine	Guns N' Roses	f	ec8fa8da-e121-49c1-a33c-939096607f85
bc94cb60-33cc-4915-8b3a-d81cca1a0802	Shape of You	Ed Sheeran	f	ec8fa8da-e121-49c1-a33c-939096607f85
e5946ec5-dbbe-40b2-9db7-5b5d3f971589	Chandelier	Sia	f	ec8fa8da-e121-49c1-a33c-939096607f85
7af667e6-6b98-4675-840c-4c8e95ecba13	Bohemian Rhapsody	Queen	t	69597add-5563-449c-b9bd-3a73db130c95
c3dc62b3-a796-43de-b923-397ebeb02d2b	Hotel California	Eagles	t	69597add-5563-449c-b9bd-3a73db130c95
d661cc08-5cfe-4364-af07-77a67b3594c9	Wonderwall	Oasis	f	69597add-5563-449c-b9bd-3a73db130c95
30ab09ae-f5be-4cac-ab08-17aad8523f31	Sweet Child O' Mine	Guns N' Roses	f	69597add-5563-449c-b9bd-3a73db130c95
66184479-03c6-4a87-b998-43baacdc2dba	Shape of You	Ed Sheeran	f	69597add-5563-449c-b9bd-3a73db130c95
454159e5-6755-4508-9bcb-a33809b69bf9	Chandelier	Sia	f	69597add-5563-449c-b9bd-3a73db130c95
895222f3-dbff-4c87-9eb2-be8928376844	Bohemian Rhapsody	Queen	t	8cd67d06-22bf-4b17-82f8-616a7d918b86
932933a0-fb09-4c76-adc6-04c1fc5c79ac	Hotel California	Eagles	t	8cd67d06-22bf-4b17-82f8-616a7d918b86
5eaf1b62-a2cc-45a9-b75e-850adcf2f813	Wonderwall	Oasis	f	8cd67d06-22bf-4b17-82f8-616a7d918b86
580e897a-e00f-4cc3-8d78-5f122bbc55b7	Sweet Child O' Mine	Guns N' Roses	f	8cd67d06-22bf-4b17-82f8-616a7d918b86
5984c5fc-916b-4749-ac29-0853609866c0	Shape of You	Ed Sheeran	f	8cd67d06-22bf-4b17-82f8-616a7d918b86
aa70cad7-e193-4440-ab53-aefd64379891	Chandelier	Sia	f	8cd67d06-22bf-4b17-82f8-616a7d918b86
dc7f052d-6f43-4e21-8d04-f277c37189bf	Bohemian Rhapsody	Queen	t	12e5c01b-dbaa-4813-a104-45bdeec8ed4f
0f047b15-336e-447c-b56a-6a4774ac4b9a	Hotel California	Eagles	t	12e5c01b-dbaa-4813-a104-45bdeec8ed4f
78f5d16d-92da-49d9-891e-639d5b45becc	Wonderwall	Oasis	f	12e5c01b-dbaa-4813-a104-45bdeec8ed4f
6a8401d1-b58e-4384-be2d-23aa7d4d4a35	Sweet Child O' Mine	Guns N' Roses	f	12e5c01b-dbaa-4813-a104-45bdeec8ed4f
27d8b324-29ae-486c-badd-f391edb31d03	Shape of You	Ed Sheeran	f	12e5c01b-dbaa-4813-a104-45bdeec8ed4f
cddbf420-7332-4643-9210-8a23bb71a274	Chandelier	Sia	f	12e5c01b-dbaa-4813-a104-45bdeec8ed4f
bbd42fe2-88ff-4309-a568-40549cf5fbd0	Bohemian Rhapsody	Queen	t	53af5ddf-bae0-4df0-ba45-5ae1b67185a8
19a65d2f-8398-4cc6-9b0f-4a10d82666db	Hotel California	Eagles	t	53af5ddf-bae0-4df0-ba45-5ae1b67185a8
981e5b9e-066b-4d6b-bdc2-b538958d0f7f	Wonderwall	Oasis	f	53af5ddf-bae0-4df0-ba45-5ae1b67185a8
f071e373-2835-4d2e-8162-af4878bbc573	Sweet Child O' Mine	Guns N' Roses	f	53af5ddf-bae0-4df0-ba45-5ae1b67185a8
51ae58b0-f27f-4d36-b60b-fec6e81db41d	Shape of You	Ed Sheeran	f	53af5ddf-bae0-4df0-ba45-5ae1b67185a8
8705fad4-b72c-43aa-b0a4-8506f4436cd2	Chandelier	Sia	f	53af5ddf-bae0-4df0-ba45-5ae1b67185a8
44464d08-cdd2-4876-bfe9-4012e5eac78b	Bohemian Rhapsody	Queen	t	106980ce-8139-4687-9399-7a6e6cf7d265
8afd793f-110a-4693-98c8-09c5c10e50da	Hotel California	Eagles	t	106980ce-8139-4687-9399-7a6e6cf7d265
9b22b52c-e82f-4641-836b-e8e3888a428e	Wonderwall	Oasis	f	106980ce-8139-4687-9399-7a6e6cf7d265
14948326-dcfd-434a-94b2-c6c281e56d08	Sweet Child O' Mine	Guns N' Roses	f	106980ce-8139-4687-9399-7a6e6cf7d265
69bbb24a-ac7c-4048-853f-7c8925a353a6	Shape of You	Ed Sheeran	f	106980ce-8139-4687-9399-7a6e6cf7d265
1dd9723a-2126-4e0a-8f35-adfacd721226	Chandelier	Sia	f	106980ce-8139-4687-9399-7a6e6cf7d265
4626a3ad-a9ff-4253-bca9-9154f9b5e6e7	Bohemian Rhapsody	Queen	t	df24d806-6b90-4f0e-a513-40e1e643947b
47825aa1-bf63-4a81-9b3c-d674519827bd	Hotel California	Eagles	t	df24d806-6b90-4f0e-a513-40e1e643947b
a7c89759-945e-425a-87fd-0878ec892d92	Wonderwall	Oasis	f	df24d806-6b90-4f0e-a513-40e1e643947b
284848a5-de61-4566-8739-8c80966d5ad1	Sweet Child O' Mine	Guns N' Roses	f	df24d806-6b90-4f0e-a513-40e1e643947b
47e0095f-d7cc-4b14-bf1c-c46370ad43ee	Shape of You	Ed Sheeran	f	df24d806-6b90-4f0e-a513-40e1e643947b
1291dba6-460b-479c-9c99-0b9738f9a43e	Chandelier	Sia	f	df24d806-6b90-4f0e-a513-40e1e643947b
51a63c69-872c-4c17-87c4-692de62b54e8	Bohemian Rhapsody	Queen	t	308d8d5a-0006-4359-9a18-44851ffc80fc
90b785a6-5876-4469-8597-4c7ab70d9ebe	Hotel California	Eagles	t	308d8d5a-0006-4359-9a18-44851ffc80fc
a6bd83d2-6269-49d6-9c2a-d156141b3af8	Wonderwall	Oasis	f	308d8d5a-0006-4359-9a18-44851ffc80fc
0aef625c-806c-43ba-9694-e3e5a9d79cf6	Sweet Child O' Mine	Guns N' Roses	f	308d8d5a-0006-4359-9a18-44851ffc80fc
9453ebf9-772b-41b3-a3c7-639ed292e7cb	Shape of You	Ed Sheeran	f	308d8d5a-0006-4359-9a18-44851ffc80fc
3a3ee5cd-8481-47d3-a80c-711c053b0148	Chandelier	Sia	f	308d8d5a-0006-4359-9a18-44851ffc80fc
0b6e03d4-caa4-4ffd-ad5f-d00a38da1a80	Bohemian Rhapsody	Queen	t	615086ed-c99e-475a-96d3-f730c8d3ccc6
e4880d38-db4d-4260-852c-1bb9f75467d8	Hotel California	Eagles	t	615086ed-c99e-475a-96d3-f730c8d3ccc6
beacd02e-0ddc-4b31-bb50-ef0a84968b7c	Wonderwall	Oasis	f	615086ed-c99e-475a-96d3-f730c8d3ccc6
5b984714-5a26-4b56-a722-b3f4b1fac0c2	Sweet Child O' Mine	Guns N' Roses	f	615086ed-c99e-475a-96d3-f730c8d3ccc6
373d6f4c-e086-47c3-9d78-9dcc7937ba8c	Shape of You	Ed Sheeran	f	615086ed-c99e-475a-96d3-f730c8d3ccc6
976200e7-93a6-42d5-a63b-f08d8b2bb881	Chandelier	Sia	f	615086ed-c99e-475a-96d3-f730c8d3ccc6
d0b326ac-d448-418c-a026-27cc8a1a1b10	Bohemian Rhapsody	Queen	t	d261050e-8f17-4747-8d48-06485c52e418
c3a88f8a-64d0-49e2-aad6-500b19f3df95	Hotel California	Eagles	t	d261050e-8f17-4747-8d48-06485c52e418
018a5588-c6c2-4f26-9e5a-4f37baec021c	Wonderwall	Oasis	f	d261050e-8f17-4747-8d48-06485c52e418
431f5750-52ab-49f4-b86f-b65af0083708	Sweet Child O' Mine	Guns N' Roses	f	d261050e-8f17-4747-8d48-06485c52e418
6089391a-7a68-4fa0-849b-5dbc83b6bf94	Shape of You	Ed Sheeran	f	d261050e-8f17-4747-8d48-06485c52e418
961d49d0-152b-4a07-8a7a-a469cc28ab9e	Chandelier	Sia	f	d261050e-8f17-4747-8d48-06485c52e418
0728e7a4-bbd7-4b1a-b964-f54d9e31b68f	Bohemian Rhapsody	Queen	t	c186d4ca-47f0-4c4b-a7f2-754c01a4233a
9e5d3410-6bfd-4564-a51f-08e2b6f56689	Hotel California	Eagles	t	c186d4ca-47f0-4c4b-a7f2-754c01a4233a
95292a8b-a66c-4abb-9949-1972c0616f39	Wonderwall	Oasis	f	c186d4ca-47f0-4c4b-a7f2-754c01a4233a
278984f4-7699-43e6-b460-48445cf9bbd1	Sweet Child O' Mine	Guns N' Roses	f	c186d4ca-47f0-4c4b-a7f2-754c01a4233a
4a216408-583f-4627-9a9e-b43c0359ce6e	Shape of You	Ed Sheeran	f	c186d4ca-47f0-4c4b-a7f2-754c01a4233a
5ef5fa9b-d654-4c20-8e86-e5e25e061287	Chandelier	Sia	f	c186d4ca-47f0-4c4b-a7f2-754c01a4233a
23e44e11-b14a-469b-b02f-f84df37c3e33	Bohemian Rhapsody	Queen	t	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0
d96d0389-8d3f-4f95-b709-49c0d16e962c	Hotel California	Eagles	t	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0
4000158a-e935-46ef-892b-4342a37b9d2f	Wonderwall	Oasis	f	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0
39ae1b7b-1665-4f9f-91e9-6dc5bf3be96f	Sweet Child O' Mine	Guns N' Roses	f	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0
7c7c4c72-219b-4ead-a8d7-be586a589a70	Shape of You	Ed Sheeran	f	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0
a959723c-2d01-41cd-8348-2a177e74b0ad	Chandelier	Sia	f	bad05839-cdc3-4b41-a1e9-d2883e1eb9c0
eb67e43a-5b2b-491b-8397-4989d0bb6aa8	Bohemian Rhapsody	Queen	t	d93366b3-d46d-47ee-bf4f-477d79793fca
f1e6f641-33e2-4611-b5d3-049319a5850f	Hotel California	Eagles	t	d93366b3-d46d-47ee-bf4f-477d79793fca
3a7fd23f-336c-42fc-9969-5539adc0d98e	Wonderwall	Oasis	f	d93366b3-d46d-47ee-bf4f-477d79793fca
12da71e4-b12e-47eb-abf2-6659d2928693	Sweet Child O' Mine	Guns N' Roses	f	d93366b3-d46d-47ee-bf4f-477d79793fca
2a00b854-92ed-472e-9744-8703469566f3	Shape of You	Ed Sheeran	f	d93366b3-d46d-47ee-bf4f-477d79793fca
505a80a2-690a-459f-a8f9-0317d9b88089	Chandelier	Sia	f	d93366b3-d46d-47ee-bf4f-477d79793fca
e932094f-d684-4bf8-bbee-714d4de59984	Bohemian Rhapsody	Queen	t	2bc86301-a41c-4e50-bdeb-eb05b473a8da
6a0cc212-fd12-4317-bc27-948dc9bc2b2e	Hotel California	Eagles	t	2bc86301-a41c-4e50-bdeb-eb05b473a8da
a5435349-0d1b-4da0-b811-f3f26464689d	Wonderwall	Oasis	f	2bc86301-a41c-4e50-bdeb-eb05b473a8da
7587af46-5e9c-4940-b85d-20981d617092	Sweet Child O' Mine	Guns N' Roses	f	2bc86301-a41c-4e50-bdeb-eb05b473a8da
1039b1d2-b217-4c1a-b1e7-7fb9d763c13d	Shape of You	Ed Sheeran	f	2bc86301-a41c-4e50-bdeb-eb05b473a8da
616b2601-652b-4fbd-bbeb-cff341b63e5d	Chandelier	Sia	f	2bc86301-a41c-4e50-bdeb-eb05b473a8da
bf8974ad-c8c2-4de1-aeef-d83255593c1d	Bohemian Rhapsody	Queen	t	d7ec7a4b-ba40-4309-aa9c-7b678c749f78
45f3e06d-6a22-4849-a530-56d94123dfaa	Hotel California	Eagles	t	d7ec7a4b-ba40-4309-aa9c-7b678c749f78
f5063ad2-e60e-4e72-a395-ac80baf568ee	Wonderwall	Oasis	f	d7ec7a4b-ba40-4309-aa9c-7b678c749f78
5730bd0f-b766-4a20-bfb6-a02442167cb1	Sweet Child O' Mine	Guns N' Roses	f	d7ec7a4b-ba40-4309-aa9c-7b678c749f78
00210e90-3c8b-4e67-b918-9b2b1f53424c	Shape of You	Ed Sheeran	f	d7ec7a4b-ba40-4309-aa9c-7b678c749f78
c5f22d03-cc17-468d-879d-40eded58f4cc	Chandelier	Sia	f	d7ec7a4b-ba40-4309-aa9c-7b678c749f78
dad0a7ae-2341-418b-979b-47d9c325e1c9	Bohemian Rhapsody	Queen	t	c87940b8-79b9-4e0c-9dd5-b08e3a532456
d062c7a4-d768-4413-afaa-5c3b2bd2c08c	Hotel California	Eagles	t	c87940b8-79b9-4e0c-9dd5-b08e3a532456
46fe343f-e249-4767-97a9-d17a25441528	Wonderwall	Oasis	f	c87940b8-79b9-4e0c-9dd5-b08e3a532456
91222e52-07f1-49d2-b8b0-7e653db1d766	Sweet Child O' Mine	Guns N' Roses	f	c87940b8-79b9-4e0c-9dd5-b08e3a532456
468d302f-83a1-431b-a764-61b47a67693e	Shape of You	Ed Sheeran	f	c87940b8-79b9-4e0c-9dd5-b08e3a532456
ed6a8c02-c623-4e64-a918-df29a0e235b6	Chandelier	Sia	f	c87940b8-79b9-4e0c-9dd5-b08e3a532456
913712cd-a003-42af-9afd-aaf438e36362	Bohemian Rhapsody	Queen	t	342bb433-74fd-4348-92bf-7f8924f646e2
e4dd9492-5b75-45ee-a671-d783a2a045aa	Hotel California	Eagles	t	342bb433-74fd-4348-92bf-7f8924f646e2
431d087c-375a-4c69-8b4f-3f1b6ef8994a	Wonderwall	Oasis	f	342bb433-74fd-4348-92bf-7f8924f646e2
410efa72-cf50-4631-a9c6-f022b1a79e19	Sweet Child O' Mine	Guns N' Roses	f	342bb433-74fd-4348-92bf-7f8924f646e2
4f6744a2-a8df-4ddd-9c0f-9bc52755e47a	Shape of You	Ed Sheeran	f	342bb433-74fd-4348-92bf-7f8924f646e2
ecbe2d57-d2be-4729-b821-20a81d5615ae	Chandelier	Sia	f	342bb433-74fd-4348-92bf-7f8924f646e2
b2363ca1-5ba5-4806-a331-794b2432a42e	Bohemian Rhapsody	Queen	t	b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0
febe1caf-eea3-4923-afea-9ee8bc10ceca	Hotel California	Eagles	t	b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0
390e2b6d-4b42-4690-90ec-50ceb18c1308	Wonderwall	Oasis	f	b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0
331737e2-2d8d-4955-bc20-2bf783d3d3a6	Sweet Child O' Mine	Guns N' Roses	f	b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0
b72130f3-0ab1-4804-a771-6b1bca702218	Shape of You	Ed Sheeran	f	b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0
27674502-c51f-465c-9ee4-0b1a2fa2fd67	Chandelier	Sia	f	b6c7d49b-c94f-49e4-8f87-c186b3bf6cb0
\.


--
-- Data for Name: suggestions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suggestions (id, live, session, title, artist_name, observations, suggested_by, suggested_user, suggested_at, status) FROM stdin;
d0cab5ae-a15a-430a-a75b-5448d23a4042	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	John Lennon	Seria incrível tocar!	Otávio Souza	9b189dad-7665-4879-b258-9d53658c21b4	2025-09-17 17:20:56.522838	pending
519cb707-4664-4d7a-8777-6de0e79333bb	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	Ben E. King	Seria incrível tocar!	Pietra Oliveira	e382d151-feea-4eca-8543-562d26e12e7b	2025-09-17 17:20:56.522838	pending
7667f2c9-f60e-48cb-b0a6-443455feee84	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	John Lennon	Seria incrível tocar!	Rafa Pereira	aaa8b845-e895-4245-96ac-9294f38c556e	2025-09-17 17:20:56.522838	pending
728b8447-c288-4bc0-b58e-359d236c7155	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	John Lennon	Seria incrível tocar!	Sofia Costa	ec7c2b16-0d44-4c48-aba8-d6d3eb7e411d	2025-09-17 17:20:56.522838	pending
506a860f-1944-434b-9f00-2ac905ce88a6	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	John Lennon	Seria incrível tocar!	Theo Rodrigues	5f3c8a71-a85e-4775-8b84-791d12f7cdaf	2025-09-17 17:20:56.522838	pending
13123132-9d44-43c3-b236-1d744f6e63da	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	Ben E. King	Seria incrível tocar!	Vitor Almeida	8cfbc55d-886b-4aa0-af98-116eb059b452	2025-09-17 17:20:56.522838	pending
12d6a40f-c274-436e-8e7d-b537605617df	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	Ben E. King	Seria incrível tocar!	Bruna Santos	0633d4e6-b2ec-45e3-8426-2b25e0a7c46a	2025-09-17 17:20:56.522838	pending
8fa86d73-57c2-4ed9-9dfe-18bc1e4622a1	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	Ben E. King	Seria incrível tocar!	Alex Gomes	60c8d47e-a2fc-4033-b3ea-d2599bf199e1	2025-09-17 17:20:56.522838	pending
5cdafa53-349a-4da7-a88b-cf8e4cfca884	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	Ben E. King	Seria incrível tocar!	Bruna Martins	b71aa2f1-9d01-4256-990d-278c5ef7c069	2025-09-17 17:20:56.522838	pending
93bcdaed-7cb9-4bf5-b78c-c471acddaeac	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	John Lennon	Seria incrível tocar!	Carlos Rocha	ccf04871-9fad-4128-83c4-917f33bb6d3b	2025-09-17 17:20:56.522838	pending
4fa86ead-312e-4620-b252-161436bdc96f	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	John Lennon	Seria incrível tocar!	Diana Lima	60d18ec1-0b71-452f-9b2c-989696d8051e	2025-09-17 17:20:56.522838	pending
9c30176c-3039-4c3e-ac78-4741d7c7fbfc	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	Ben E. King	Seria incrível tocar!	Enzo Silva	7ae96604-1904-4e6e-be37-c7c46af26300	2025-09-17 17:20:56.522838	pending
1d6f35ec-e9f2-4b8f-90cd-1ab9f66b0daa	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	John Lennon	Seria incrível tocar!	Fernanda Santos	76faf34e-bf1c-4740-a0b3-b4cbb788c00b	2025-09-17 17:20:56.522838	pending
273f8d70-993c-4f7c-b493-00cba600aded	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	John Lennon	Seria incrível tocar!	Gabi Souza	f6170e99-af54-4d52-87fc-3260dcd243cf	2025-09-17 17:20:56.522838	pending
efff0151-58a5-4c92-a114-deaeb833a0f3	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	John Lennon	Seria incrível tocar!	Heitor Oliveira	df414df2-a8f6-460f-97d9-64d620b6e47f	2025-09-17 17:20:56.522838	pending
92f4899c-7256-44d5-95af-c9588a1ca824	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	John Lennon	Seria incrível tocar!	Alex Pereira	2be2d819-946e-44a6-89c1-b35c1dc21236	2025-09-17 17:20:56.522838	pending
fc412be5-1c22-40da-8b09-918dd27a0d98	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Stand by Me	John Lennon	Seria incrível tocar!	Kauã Rocha	7ff77dd1-16a4-4d0f-8493-1945600ceefc	2025-09-17 17:20:56.522838	pending
488ad3e1-5b45-4603-bc2a-deda502d14bf	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	Ben E. King	Seria incrível tocar!	Lia Lima	33fee55a-91a4-4a5e-9a20-9ac01c0e74e8	2025-09-17 17:20:56.522838	pending
65e5622f-0f8e-42ab-b220-f89799cfcd26	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	Ben E. King	Seria incrível tocar!	Maya Silva	887b25b2-4eb5-41ee-88e5-ae189fac5722	2025-09-17 17:20:56.522838	pending
d724f993-5858-445b-8773-0caca9ebbe4b	c87e7317-b008-4cc6-a499-3dcdfa07260e	c586fd85-784b-4f00-93eb-0fb54a070780	Imagine	Ben E. King	Seria incrível tocar!	Noah Santos	8fb38ff0-515f-4af7-82e9-bc9ca3017c08	2025-09-17 17:20:56.522838	pending
\.


--
-- Data for Name: themes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.themes (id, owner, mode, color1, color2) FROM stdin;
2baddd7e-b634-44b7-a9cb-63b0fc54108f	efa7f426-53ea-4a0d-9c82-2f3ea7bef900	light	#10B981	#0EA5E9
7613139e-d316-4200-a8d4-7538f46241ef	853b80df-41f6-4fc8-9d61-0f16f97e6195	light	#10B981	#0EA5E9
89740998-1589-4e8a-b0f6-9b791962deb3	ec8fa8da-e121-49c1-a33c-939096607f85	light	#10B981	#0EA5E9
06b450c7-74ef-4eb0-84de-84c9919e5e0a	69597add-5563-449c-b9bd-3a73db130c95	light	#10B981	#0EA5E9
134596e8-7197-43f0-9983-f52223fa7bc5	8cd67d06-22bf-4b17-82f8-616a7d918b86	light	#10B981	#0EA5E9
85ae0ae5-380e-46b2-afa9-1d3eddb13594	12e5c01b-dbaa-4813-a104-45bdeec8ed4f	light	#10B981	#0EA5E9
dec649c3-cdb8-48ac-9620-fa9351cdc58a	53af5ddf-bae0-4df0-ba45-5ae1b67185a8	light	#10B981	#0EA5E9
3565a3a2-9d32-4d32-b472-6d8ea0b74ee6	106980ce-8139-4687-9399-7a6e6cf7d265	light	#10B981	#0EA5E9
d6eac40f-4c2b-420d-a6f8-fbbafcc1336a	df24d806-6b90-4f0e-a513-40e1e643947b	light	#10B981	#0EA5E9
5dc35702-7a4e-4832-a024-d6153f28283e	308d8d5a-0006-4359-9a18-44851ffc80fc	light	#10B981	#0EA5E9
ae1a41d5-12b6-450e-ab8b-3f97378e03ab	efa7f426-53ea-4a0d-9c82-2f3ea7bef900	dark	#8B5CF6	#F59E0B
ab2cff3b-4878-4e6e-85bf-87d53e2554dd	853b80df-41f6-4fc8-9d61-0f16f97e6195	dark	#8B5CF6	#F59E0B
318dbab3-1d36-4761-86ab-0d1ebb75ed28	ec8fa8da-e121-49c1-a33c-939096607f85	dark	#8B5CF6	#F59E0B
794e7d8f-041f-4e94-bf51-6914f8d421c8	69597add-5563-449c-b9bd-3a73db130c95	dark	#8B5CF6	#F59E0B
d717384b-7645-43b8-87a9-29292dbee96a	8cd67d06-22bf-4b17-82f8-616a7d918b86	dark	#8B5CF6	#F59E0B
2889c685-db93-450d-b245-4f64db42ee1d	12e5c01b-dbaa-4813-a104-45bdeec8ed4f	dark	#8B5CF6	#F59E0B
f81bd8df-ed4e-474f-b148-87fdb91de779	53af5ddf-bae0-4df0-ba45-5ae1b67185a8	dark	#8B5CF6	#F59E0B
6d9c8376-8a28-42a8-a14d-8fd1ae18c73e	106980ce-8139-4687-9399-7a6e6cf7d265	dark	#8B5CF6	#F59E0B
c770a647-27e7-4d0d-8ffb-38b919991076	df24d806-6b90-4f0e-a513-40e1e643947b	dark	#8B5CF6	#F59E0B
a7db3eb6-1a8d-44b0-b1d2-44f404091477	308d8d5a-0006-4359-9a18-44851ffc80fc	dark	#8B5CF6	#F59E0B
\.


--
-- Name: directus_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_activity_id_seq', 418, true);


--
-- Name: directus_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_fields_id_seq', 73, true);


--
-- Name: directus_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_notifications_id_seq', 1, false);


--
-- Name: directus_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_permissions_id_seq', 86, true);


--
-- Name: directus_presets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_presets_id_seq', 6, true);


--
-- Name: directus_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_relations_id_seq', 15, true);


--
-- Name: directus_revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_revisions_id_seq', 108, true);


--
-- Name: directus_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_settings_id_seq', 1, true);


--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.directus_webhooks_id_seq', 1, false);


--
-- Name: directus_access directus_access_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_pkey PRIMARY KEY (id);


--
-- Name: directus_activity directus_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_activity
    ADD CONSTRAINT directus_activity_pkey PRIMARY KEY (id);


--
-- Name: directus_collections directus_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_pkey PRIMARY KEY (collection);


--
-- Name: directus_comments directus_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_pkey PRIMARY KEY (id);


--
-- Name: directus_dashboards directus_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_pkey PRIMARY KEY (id);


--
-- Name: directus_extensions directus_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_extensions
    ADD CONSTRAINT directus_extensions_pkey PRIMARY KEY (id);


--
-- Name: directus_fields directus_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_fields
    ADD CONSTRAINT directus_fields_pkey PRIMARY KEY (id);


--
-- Name: directus_files directus_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_pkey PRIMARY KEY (id);


--
-- Name: directus_flows directus_flows_operation_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_operation_unique UNIQUE (operation);


--
-- Name: directus_flows directus_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_pkey PRIMARY KEY (id);


--
-- Name: directus_folders directus_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_pkey PRIMARY KEY (id);


--
-- Name: directus_migrations directus_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_migrations
    ADD CONSTRAINT directus_migrations_pkey PRIMARY KEY (version);


--
-- Name: directus_notifications directus_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_pkey PRIMARY KEY (id);


--
-- Name: directus_operations directus_operations_reject_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_unique UNIQUE (reject);


--
-- Name: directus_operations directus_operations_resolve_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_unique UNIQUE (resolve);


--
-- Name: directus_panels directus_panels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_pkey PRIMARY KEY (id);


--
-- Name: directus_permissions directus_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_pkey PRIMARY KEY (id);


--
-- Name: directus_policies directus_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_policies
    ADD CONSTRAINT directus_policies_pkey PRIMARY KEY (id);


--
-- Name: directus_presets directus_presets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_pkey PRIMARY KEY (id);


--
-- Name: directus_relations directus_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_relations
    ADD CONSTRAINT directus_relations_pkey PRIMARY KEY (id);


--
-- Name: directus_revisions directus_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_pkey PRIMARY KEY (id);


--
-- Name: directus_roles directus_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_pkey PRIMARY KEY (id);


--
-- Name: directus_sessions directus_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_pkey PRIMARY KEY (token);


--
-- Name: directus_settings directus_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_pkey PRIMARY KEY (id);


--
-- Name: directus_shares directus_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_pkey PRIMARY KEY (id);


--
-- Name: directus_translations directus_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_translations
    ADD CONSTRAINT directus_translations_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_email_unique UNIQUE (email);


--
-- Name: directus_users directus_users_external_identifier_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_external_identifier_unique UNIQUE (external_identifier);


--
-- Name: directus_users directus_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_pkey PRIMARY KEY (id);


--
-- Name: directus_users directus_users_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_token_unique UNIQUE (token);


--
-- Name: directus_versions directus_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_pkey PRIMARY KEY (id);


--
-- Name: directus_webhooks directus_webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_pkey PRIMARY KEY (id);


--
-- Name: live_sessions live_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.live_sessions
    ADD CONSTRAINT live_sessions_pkey PRIMARY KEY (id);


--
-- Name: lives lives_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lives
    ADD CONSTRAINT lives_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- Name: songs songs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_pkey PRIMARY KEY (id);


--
-- Name: suggestions suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: themes themes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.themes
    ADD CONSTRAINT themes_pkey PRIMARY KEY (id);


--
-- Name: directus_access directus_access_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_access directus_access_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_access
    ADD CONSTRAINT directus_access_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_collections directus_collections_group_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_collections
    ADD CONSTRAINT directus_collections_group_foreign FOREIGN KEY ("group") REFERENCES public.directus_collections(collection);


--
-- Name: directus_comments directus_comments_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_comments directus_comments_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_comments
    ADD CONSTRAINT directus_comments_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_dashboards directus_dashboards_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_dashboards
    ADD CONSTRAINT directus_dashboards_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_folder_foreign FOREIGN KEY (folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_files directus_files_modified_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_modified_by_foreign FOREIGN KEY (modified_by) REFERENCES public.directus_users(id);


--
-- Name: directus_files directus_files_uploaded_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_files
    ADD CONSTRAINT directus_files_uploaded_by_foreign FOREIGN KEY (uploaded_by) REFERENCES public.directus_users(id);


--
-- Name: directus_flows directus_flows_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_flows
    ADD CONSTRAINT directus_flows_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_folders directus_folders_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_folders
    ADD CONSTRAINT directus_folders_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_folders(id);


--
-- Name: directus_notifications directus_notifications_recipient_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_recipient_foreign FOREIGN KEY (recipient) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_notifications directus_notifications_sender_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_notifications
    ADD CONSTRAINT directus_notifications_sender_foreign FOREIGN KEY (sender) REFERENCES public.directus_users(id);


--
-- Name: directus_operations directus_operations_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_flow_foreign FOREIGN KEY (flow) REFERENCES public.directus_flows(id) ON DELETE CASCADE;


--
-- Name: directus_operations directus_operations_reject_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_reject_foreign FOREIGN KEY (reject) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_resolve_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_resolve_foreign FOREIGN KEY (resolve) REFERENCES public.directus_operations(id);


--
-- Name: directus_operations directus_operations_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_operations
    ADD CONSTRAINT directus_operations_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_panels directus_panels_dashboard_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_dashboard_foreign FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards(id) ON DELETE CASCADE;


--
-- Name: directus_panels directus_panels_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_panels
    ADD CONSTRAINT directus_panels_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_permissions directus_permissions_policy_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_permissions
    ADD CONSTRAINT directus_permissions_policy_foreign FOREIGN KEY (policy) REFERENCES public.directus_policies(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_presets directus_presets_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_presets
    ADD CONSTRAINT directus_presets_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_activity_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_activity_foreign FOREIGN KEY (activity) REFERENCES public.directus_activity(id) ON DELETE CASCADE;


--
-- Name: directus_revisions directus_revisions_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_revisions(id);


--
-- Name: directus_revisions directus_revisions_version_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_revisions
    ADD CONSTRAINT directus_revisions_version_foreign FOREIGN KEY (version) REFERENCES public.directus_versions(id) ON DELETE CASCADE;


--
-- Name: directus_roles directus_roles_parent_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_roles
    ADD CONSTRAINT directus_roles_parent_foreign FOREIGN KEY (parent) REFERENCES public.directus_roles(id);


--
-- Name: directus_sessions directus_sessions_share_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_share_foreign FOREIGN KEY (share) REFERENCES public.directus_shares(id) ON DELETE CASCADE;


--
-- Name: directus_sessions directus_sessions_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_sessions
    ADD CONSTRAINT directus_sessions_user_foreign FOREIGN KEY ("user") REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: directus_settings directus_settings_project_logo_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_project_logo_foreign FOREIGN KEY (project_logo) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_background_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_background_foreign FOREIGN KEY (public_background) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_favicon_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_favicon_foreign FOREIGN KEY (public_favicon) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_foreground_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_foreground_foreign FOREIGN KEY (public_foreground) REFERENCES public.directus_files(id);


--
-- Name: directus_settings directus_settings_public_registration_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_public_registration_role_foreign FOREIGN KEY (public_registration_role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_settings directus_settings_storage_default_folder_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_settings
    ADD CONSTRAINT directus_settings_storage_default_folder_foreign FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders(id) ON DELETE SET NULL;


--
-- Name: directus_shares directus_shares_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE CASCADE;


--
-- Name: directus_shares directus_shares_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_shares
    ADD CONSTRAINT directus_shares_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_users directus_users_role_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_users
    ADD CONSTRAINT directus_users_role_foreign FOREIGN KEY (role) REFERENCES public.directus_roles(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_collection_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_collection_foreign FOREIGN KEY (collection) REFERENCES public.directus_collections(collection) ON DELETE CASCADE;


--
-- Name: directus_versions directus_versions_user_created_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_created_foreign FOREIGN KEY (user_created) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: directus_versions directus_versions_user_updated_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_versions
    ADD CONSTRAINT directus_versions_user_updated_foreign FOREIGN KEY (user_updated) REFERENCES public.directus_users(id);


--
-- Name: directus_webhooks directus_webhooks_migrated_flow_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directus_webhooks
    ADD CONSTRAINT directus_webhooks_migrated_flow_foreign FOREIGN KEY (migrated_flow) REFERENCES public.directus_flows(id) ON DELETE SET NULL;


--
-- Name: live_sessions live_sessions_artist_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.live_sessions
    ADD CONSTRAINT live_sessions_artist_foreign FOREIGN KEY (artist) REFERENCES public.directus_users(id) ON DELETE CASCADE;


--
-- Name: live_sessions live_sessions_live_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.live_sessions
    ADD CONSTRAINT live_sessions_live_foreign FOREIGN KEY (live) REFERENCES public.lives(id) ON DELETE CASCADE;


--
-- Name: lives lives_singer_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lives
    ADD CONSTRAINT lives_singer_foreign FOREIGN KEY (singer) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: messages messages_linked_request_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_linked_request_foreign FOREIGN KEY (linked_request) REFERENCES public.requests(id) ON DELETE SET NULL;


--
-- Name: messages messages_live_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_live_foreign FOREIGN KEY (live) REFERENCES public.lives(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_user_foreign FOREIGN KEY (sender_user) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: messages messages_session_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_session_foreign FOREIGN KEY (session) REFERENCES public.live_sessions(id) ON DELETE SET NULL;


--
-- Name: requests requests_accepted_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_accepted_by_foreign FOREIGN KEY (accepted_by) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: requests requests_live_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_live_foreign FOREIGN KEY (live) REFERENCES public.lives(id) ON DELETE CASCADE;


--
-- Name: requests requests_session_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_session_foreign FOREIGN KEY (session) REFERENCES public.live_sessions(id) ON DELETE SET NULL;


--
-- Name: requests requests_song_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_song_foreign FOREIGN KEY (song) REFERENCES public.songs(id) ON DELETE SET NULL;


--
-- Name: songs songs_owner_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.songs
    ADD CONSTRAINT songs_owner_foreign FOREIGN KEY (owner) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- Name: suggestions suggestions_live_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT suggestions_live_foreign FOREIGN KEY (live) REFERENCES public.lives(id) ON DELETE CASCADE;


--
-- Name: suggestions suggestions_session_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT suggestions_session_foreign FOREIGN KEY (session) REFERENCES public.live_sessions(id) ON DELETE SET NULL;


--
-- Name: suggestions suggestions_suggested_user_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suggestions
    ADD CONSTRAINT suggestions_suggested_user_foreign FOREIGN KEY (suggested_user) REFERENCES public.directus_users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict Hg1yoftnY6xm67d95jkFoASG7idVDMtXyuAM4mIYR0NWqOB38i0aTZe73t5HWy2

