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
-- Name: applications_search_vector(text, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.applications_search_vector(development_application_number text, location text, suburb_name text, reference_number text, description text, administration_notes text, building_surveyor text, council_name text, contact_name text, owner_name text, applicant_name text) RETURNS tsvector
    LANGUAGE plpgsql IMMUTABLE
    AS $$ BEGIN RETURN ( setweight(to_tsvector('english', COALESCE(development_application_number, '')), 'A') || setweight(to_tsvector('english', COALESCE(location, '')), 'A') || setweight(to_tsvector('english', COALESCE(suburb_name, '')), 'A') || setweight(to_tsvector('english', COALESCE(reference_number, '')), 'A') || setweight(to_tsvector('english', COALESCE(description, '')), 'A') || setweight(to_tsvector('english', COALESCE(administration_notes, '')), 'B') || setweight(to_tsvector('english', COALESCE(building_surveyor, '')), 'A') || setweight(to_tsvector('english', COALESCE(council_name, '')), 'A') || setweight(to_tsvector('english', COALESCE(contact_name, '')), 'C') || setweight(to_tsvector('english', COALESCE(owner_name, '')), 'C') || setweight(to_tsvector('english', COALESCE(applicant_name, '')), 'A') ); END; $$;


--
-- Name: applications_search_vector(text, text, text, text, text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.applications_search_vector(development_application_number text, lot_number text, street_number text, street_name text, suburb_name text, reference_number text, description text, administration_notes text, building_surveyor text, council_name text, contact_name text, owner_name text, applicant_name text) RETURNS tsvector
    LANGUAGE plpgsql IMMUTABLE
    AS $$ BEGIN RETURN ( setweight(to_tsvector('english', COALESCE(development_application_number, '')), 'A') || setweight(to_tsvector('english', COALESCE(lot_number, '')), 'A') || setweight(to_tsvector('english', COALESCE(street_number, '')), 'A') || setweight(to_tsvector('english', COALESCE(street_name, '')), 'A') || setweight(to_tsvector('english', COALESCE(suburb_name, '')), 'A') || setweight(to_tsvector('english', COALESCE(reference_number, '')), 'A') || setweight(to_tsvector('english', COALESCE(description, '')), 'A') || setweight(to_tsvector('english', COALESCE(administration_notes, '')), 'B') || setweight(to_tsvector('english', COALESCE(building_surveyor, '')), 'A') || setweight(to_tsvector('english', COALESCE(council_name, '')), 'A') || setweight(to_tsvector('english', COALESCE(contact_name, '')), 'C') || setweight(to_tsvector('english', COALESCE(owner_name, '')), 'C') || setweight(to_tsvector('english', COALESCE(applicant_name, '')), 'A') ); END; $$;


--
-- Name: applications_trigger_function(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.applications_trigger_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN NEW.searchable_tsvector := applications_search_vector( NEW.development_application_number, NEW.lot_number, NEW.street_number, NEW.street_name, (SELECT display_name FROM suburbs WHERE id = NEW.suburb_id), NEW.reference_number, NEW.description, NEW.administration_notes, NEW.building_surveyor, (SELECT name FROM councils WHERE id = NEW.council_id), (SELECT client_name FROM clients WHERE id = NEW.contact_id), (SELECT client_name FROM clients WHERE id = NEW.owner_id), (SELECT client_name FROM clients WHERE id = NEW.applicant_id) ); RETURN NEW; END; $$;


--
-- Name: update_applications_search_from_client(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_applications_search_from_client() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN UPDATE applications SET searchable_tsvector = applications_search_vector( development_application_number, lot_number, street_number, street_name, (SELECT display_name FROM suburbs WHERE id = suburb_id), reference_number, description, administration_notes, building_surveyor, (SELECT name FROM councils WHERE id = council_id), (SELECT client_name FROM clients WHERE id = contact_id), (SELECT client_name FROM clients WHERE id = owner_id), (SELECT client_name FROM clients WHERE id = applicant_id) ) WHERE contact_id = NEW.id OR owner_id = NEW.id OR applicant_id = NEW.id; RETURN NEW; END; $$;


--
-- Name: update_applications_search_from_council(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_applications_search_from_council() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN UPDATE applications SET searchable_tsvector = applications_search_vector( development_application_number, lot_number, street_number, street_name, (SELECT display_name FROM suburbs WHERE id = suburb_id), reference_number, description, administration_notes, building_surveyor, NEW.name, (SELECT client_name FROM clients WHERE id = contact_id), (SELECT client_name FROM clients WHERE id = owner_id), (SELECT client_name FROM clients WHERE id = applicant_id) ) WHERE council_id = NEW.id; RETURN NEW; END; $$;


--
-- Name: update_applications_search_from_suburb(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_applications_search_from_suburb() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN UPDATE applications SET searchable_tsvector = applications_search_vector( development_application_number, lot_number, street_number, street_name, NEW.display_name, reference_number, description, administration_notes, building_surveyor, (SELECT name FROM councils WHERE id = council_id), (SELECT client_name FROM clients WHERE id = contact_id), (SELECT client_name FROM clients WHERE id = owner_id), (SELECT client_name FROM clients WHERE id = applicant_id) ) WHERE suburb_id = NEW.id; RETURN NEW; END; $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: application_additional_informations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_additional_informations (
    id integer NOT NULL,
    info_date date,
    info_text text,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: application_additional_informations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_additional_informations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_additional_informations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_additional_informations_id_seq OWNED BY public.application_additional_informations.id;


--
-- Name: application_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_types (
    id integer NOT NULL,
    application_type text NOT NULL,
    last_used integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    display_priority integer DEFAULT 0,
    active boolean DEFAULT true NOT NULL
);


--
-- Name: application_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_types_id_seq OWNED BY public.application_types.id;


--
-- Name: application_uploads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_uploads (
    id integer NOT NULL,
    uploaded_date date,
    uploaded_text text,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: application_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_uploads_id_seq OWNED BY public.application_uploads.id;


--
-- Name: applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.applications (
    id integer NOT NULL,
    reference_number text NOT NULL,
    converted_to_from text,
    council_id bigint,
    development_application_number text,
    applicant_id bigint,
    owner_id bigint,
    contact_id bigint,
    description text,
    cancelled boolean DEFAULT false NOT NULL,
    street_number text,
    lot_number text,
    street_name text,
    suburb_id bigint,
    electronic_lodgement boolean DEFAULT false NOT NULL,
    engagement_form boolean DEFAULT false NOT NULL,
    job_type_administration text,
    quote_accepted_date date,
    administration_notes text,
    number_of_storeys integer,
    construction_value numeric(13,2),
    fee_amount numeric(13,2),
    building_surveyor text,
    risk_rating text,
    assessment_commenced date,
    consent_issued date,
    coo_issued date,
    certifier text,
    certification_notes text,
    invoice_to text,
    care_of text,
    invoice_email text,
    attention text,
    purchase_order_number text,
    fully_invoiced boolean DEFAULT false NOT NULL,
    invoice_debtor_notes text,
    applicant_email text,
    application_type_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    location character varying GENERATED ALWAYS AS (((COALESCE((lot_number || ' '::text), ''::text) || COALESCE((street_number || ' '::text), ''::text)) || street_name)) STORED,
    searchable_tsvector tsvector,
    staged_consent boolean DEFAULT false NOT NULL,
    area_m2 numeric(13,2),
    construction_industry_trading_board boolean DEFAULT false NOT NULL,
    kd_to_lodge boolean DEFAULT false NOT NULL,
    variation_requested boolean DEFAULT false NOT NULL
);


--
-- Name: applications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.applications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.applications_id_seq OWNED BY public.applications.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    client_type text,
    client_name text,
    first_name text,
    surname text,
    title text,
    initials text,
    salutation text,
    company_name text,
    street text,
    postal_address text,
    australian_business_number text,
    state text,
    phone text,
    mobile_number text,
    fax text,
    email text,
    notes text,
    bad_payer boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    suburb_id bigint,
    postal_suburb_id bigint
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: consultancies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.consultancies (
    id bigint NOT NULL,
    consultancy_type text,
    scheduled_date date,
    notes text,
    report_or_email_sent date,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: consultancies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.consultancies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: consultancies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.consultancies_id_seq OWNED BY public.consultancies.id;


--
-- Name: councils; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.councils (
    id integer NOT NULL,
    name text,
    city text,
    street text,
    state text,
    suburb_id bigint,
    postal_address text,
    postal_suburb_id bigint,
    phone text,
    fax text,
    email text,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: councils_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.councils_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: councils_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.councils_id_seq OWNED BY public.councils.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    id integer NOT NULL,
    invoice_number text,
    stage text,
    fee numeric(13,2),
    gst numeric(13,2),
    admin_fee numeric(13,2),
    invoice_date date,
    paid boolean DEFAULT false NOT NULL,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: COLUMN invoices.admin_fee; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.invoices.admin_fee IS 'Currently hidden from the UI';


--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: request_for_informations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.request_for_informations (
    id integer NOT NULL,
    request_for_information_date date,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: request_for_informations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.request_for_informations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: request_for_informations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.request_for_informations_id_seq OWNED BY public.request_for_informations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stages (
    id integer NOT NULL,
    stage_date date,
    stage_text text,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    stage_notes text
);


--
-- Name: stages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stages_id_seq OWNED BY public.stages.id;


--
-- Name: structural_engineers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.structural_engineers (
    id bigint NOT NULL,
    structural_engineer text,
    external_engineer_date date,
    structural_engineer_fee numeric(13,2),
    engineer_certificate_received date,
    certificate_reference text,
    structural_engineer_ok_to_pay boolean DEFAULT false NOT NULL,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: structural_engineers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.structural_engineers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: structural_engineers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.structural_engineers_id_seq OWNED BY public.structural_engineers.id;


--
-- Name: suburbs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suburbs (
    id integer NOT NULL,
    suburb text NOT NULL,
    state text NOT NULL,
    postcode text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    display_name character varying GENERATED ALWAYS AS (((((suburb || ', '::text) || state) || ' '::text) || postcode)) STORED
);


--
-- Name: suburbs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.suburbs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suburbs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.suburbs_id_seq OWNED BY public.suburbs.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    username character varying,
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: variations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.variations (
    id bigint NOT NULL,
    variation_date date,
    variation_type text,
    variation_issued date,
    application_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: variations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.variations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: variations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.variations_id_seq OWNED BY public.variations.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: application_additional_informations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_additional_informations ALTER COLUMN id SET DEFAULT nextval('public.application_additional_informations_id_seq'::regclass);


--
-- Name: application_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_types ALTER COLUMN id SET DEFAULT nextval('public.application_types_id_seq'::regclass);


--
-- Name: application_uploads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_uploads ALTER COLUMN id SET DEFAULT nextval('public.application_uploads_id_seq'::regclass);


--
-- Name: applications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications ALTER COLUMN id SET DEFAULT nextval('public.applications_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: consultancies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultancies ALTER COLUMN id SET DEFAULT nextval('public.consultancies_id_seq'::regclass);


--
-- Name: councils id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.councils ALTER COLUMN id SET DEFAULT nextval('public.councils_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: request_for_informations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_for_informations ALTER COLUMN id SET DEFAULT nextval('public.request_for_informations_id_seq'::regclass);


--
-- Name: stages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stages ALTER COLUMN id SET DEFAULT nextval('public.stages_id_seq'::regclass);


--
-- Name: structural_engineers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structural_engineers ALTER COLUMN id SET DEFAULT nextval('public.structural_engineers_id_seq'::regclass);


--
-- Name: suburbs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suburbs ALTER COLUMN id SET DEFAULT nextval('public.suburbs_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: variations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variations ALTER COLUMN id SET DEFAULT nextval('public.variations_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: application_additional_informations application_additional_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_additional_informations
    ADD CONSTRAINT application_additional_informations_pkey PRIMARY KEY (id);


--
-- Name: application_types application_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_types
    ADD CONSTRAINT application_types_pkey PRIMARY KEY (id);


--
-- Name: application_uploads application_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_uploads
    ADD CONSTRAINT application_uploads_pkey PRIMARY KEY (id);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: consultancies consultancies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultancies
    ADD CONSTRAINT consultancies_pkey PRIMARY KEY (id);


--
-- Name: councils councils_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.councils
    ADD CONSTRAINT councils_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: request_for_informations request_for_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_for_informations
    ADD CONSTRAINT request_for_informations_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: stages stages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT stages_pkey PRIMARY KEY (id);


--
-- Name: structural_engineers structural_engineers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structural_engineers
    ADD CONSTRAINT structural_engineers_pkey PRIMARY KEY (id);


--
-- Name: suburbs suburbs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suburbs
    ADD CONSTRAINT suburbs_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: variations variations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variations
    ADD CONSTRAINT variations_pkey PRIMARY KEY (id);


--
-- Name: applications_searchable_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX applications_searchable_idx ON public.applications USING gin (searchable_tsvector);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_application_additional_informations_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_additional_informations_on_application_id ON public.application_additional_informations USING btree (application_id);


--
-- Name: index_application_uploads_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_application_uploads_on_application_id ON public.application_uploads USING btree (application_id);


--
-- Name: index_applications_on_applicant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applications_on_applicant_id ON public.applications USING btree (applicant_id);


--
-- Name: index_applications_on_application_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applications_on_application_type_id ON public.applications USING btree (application_type_id);


--
-- Name: index_applications_on_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applications_on_contact_id ON public.applications USING btree (contact_id);


--
-- Name: index_applications_on_council_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applications_on_council_id ON public.applications USING btree (council_id);


--
-- Name: index_applications_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applications_on_owner_id ON public.applications USING btree (owner_id);


--
-- Name: index_applications_on_suburb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_applications_on_suburb_id ON public.applications USING btree (suburb_id);


--
-- Name: index_clients_on_postal_suburb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_postal_suburb_id ON public.clients USING btree (postal_suburb_id);


--
-- Name: index_clients_on_suburb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_clients_on_suburb_id ON public.clients USING btree (suburb_id);


--
-- Name: index_consultancies_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_consultancies_on_application_id ON public.consultancies USING btree (application_id);


--
-- Name: index_councils_on_postal_suburb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_councils_on_postal_suburb_id ON public.councils USING btree (postal_suburb_id);


--
-- Name: index_councils_on_suburb_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_councils_on_suburb_id ON public.councils USING btree (suburb_id);


--
-- Name: index_invoices_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_application_id ON public.invoices USING btree (application_id);


--
-- Name: index_request_for_informations_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_request_for_informations_on_application_id ON public.request_for_informations USING btree (application_id);


--
-- Name: index_stages_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stages_on_application_id ON public.stages USING btree (application_id);


--
-- Name: index_structural_engineers_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structural_engineers_on_application_id ON public.structural_engineers USING btree (application_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: index_variations_on_application_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_variations_on_application_id ON public.variations USING btree (application_id);


--
-- Name: applications applications_search_vector_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER applications_search_vector_update BEFORE INSERT OR UPDATE ON public.applications FOR EACH ROW EXECUTE FUNCTION public.applications_trigger_function();


--
-- Name: clients update_applications_search_client; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_applications_search_client AFTER UPDATE OF client_name ON public.clients FOR EACH ROW EXECUTE FUNCTION public.update_applications_search_from_client();


--
-- Name: councils update_applications_search_council; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_applications_search_council AFTER UPDATE OF name ON public.councils FOR EACH ROW EXECUTE FUNCTION public.update_applications_search_from_council();


--
-- Name: suburbs update_applications_search_suburb; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_applications_search_suburb AFTER UPDATE OF display_name ON public.suburbs FOR EACH ROW EXECUTE FUNCTION public.update_applications_search_from_suburb();


--
-- Name: application_additional_informations fk_rails_185a40dc4a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_additional_informations
    ADD CONSTRAINT fk_rails_185a40dc4a FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- Name: applications fk_rails_24be0ad691; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT fk_rails_24be0ad691 FOREIGN KEY (council_id) REFERENCES public.councils(id);


--
-- Name: councils fk_rails_2c32b53ec1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.councils
    ADD CONSTRAINT fk_rails_2c32b53ec1 FOREIGN KEY (suburb_id) REFERENCES public.suburbs(id);


--
-- Name: application_uploads fk_rails_34052c69f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_uploads
    ADD CONSTRAINT fk_rails_34052c69f9 FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- Name: applications fk_rails_493aef951a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT fk_rails_493aef951a FOREIGN KEY (contact_id) REFERENCES public.clients(id);


--
-- Name: stages fk_rails_4b8e2fe717; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stages
    ADD CONSTRAINT fk_rails_4b8e2fe717 FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- Name: clients fk_rails_85f94c06c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT fk_rails_85f94c06c7 FOREIGN KEY (suburb_id) REFERENCES public.suburbs(id);


--
-- Name: councils fk_rails_8c1a316e91; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.councils
    ADD CONSTRAINT fk_rails_8c1a316e91 FOREIGN KEY (postal_suburb_id) REFERENCES public.suburbs(id);


--
-- Name: applications fk_rails_8d6c4c62c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT fk_rails_8d6c4c62c6 FOREIGN KEY (owner_id) REFERENCES public.clients(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: applications fk_rails_ab24dfe528; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT fk_rails_ab24dfe528 FOREIGN KEY (suburb_id) REFERENCES public.suburbs(id);


--
-- Name: applications fk_rails_ad5ea13d24; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT fk_rails_ad5ea13d24 FOREIGN KEY (application_type_id) REFERENCES public.application_types(id);


--
-- Name: invoices fk_rails_b1a8bdb697; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT fk_rails_b1a8bdb697 FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- Name: consultancies fk_rails_bb575a1994; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.consultancies
    ADD CONSTRAINT fk_rails_bb575a1994 FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: variations fk_rails_cc88f7f367; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.variations
    ADD CONSTRAINT fk_rails_cc88f7f367 FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- Name: request_for_informations fk_rails_dde47abfd9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.request_for_informations
    ADD CONSTRAINT fk_rails_dde47abfd9 FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- Name: applications fk_rails_df32bd9671; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.applications
    ADD CONSTRAINT fk_rails_df32bd9671 FOREIGN KEY (applicant_id) REFERENCES public.clients(id);


--
-- Name: clients fk_rails_e7b67c7d1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT fk_rails_e7b67c7d1d FOREIGN KEY (postal_suburb_id) REFERENCES public.suburbs(id);


--
-- Name: structural_engineers fk_rails_e90077fa84; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structural_engineers
    ADD CONSTRAINT fk_rails_e90077fa84 FOREIGN KEY (application_id) REFERENCES public.applications(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250808042802'),
('20250306231800'),
('20250227114919'),
('20250227114023'),
('20250227020816'),
('20250226075617'),
('20250226064610'),
('20250220105818'),
('20250217112136'),
('20250216124147'),
('20250215120712'),
('20250214044701'),
('20250213133630'),
('20250213065251'),
('20250213064842');

