--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE credentials (
    id integer NOT NULL,
    beeminder_user_id character varying NOT NULL,
    provider_name character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    info json DEFAULT '{}'::json NOT NULL,
    credentials json DEFAULT '{}'::json NOT NULL,
    extra json DEFAULT '{}'::json NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    password character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE credentials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE credentials_id_seq OWNED BY credentials.id;


--
-- Name: goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE goals (
    id integer NOT NULL,
    credential_id integer NOT NULL,
    slug character varying NOT NULL,
    last_value double precision,
    params json DEFAULT '{}'::json NOT NULL,
    metric_key character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    fail_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goals_id_seq OWNED BY goals.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE scores (
    id integer NOT NULL,
    value double precision NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    goal_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    "unique" boolean
);


--
-- Name: scores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scores_id_seq OWNED BY scores.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    beeminder_user_id character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY credentials ALTER COLUMN id SET DEFAULT nextval('credentials_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals ALTER COLUMN id SET DEFAULT nextval('goals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scores ALTER COLUMN id SET DEFAULT nextval('scores_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credentials
    ADD CONSTRAINT credentials_pkey PRIMARY KEY (id);


--
-- Name: goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- Name: scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY scores
    ADD CONSTRAINT scores_pkey PRIMARY KEY (id);


--
-- Name: fk__goals_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fk__goals_provider_id ON goals USING btree (credential_id);


--
-- Name: index_credentials_on_provider_name_and_beeminder_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_credentials_on_provider_name_and_beeminder_user_id ON credentials USING btree (provider_name, beeminder_user_id);


--
-- Name: index_credentials_on_provider_name_and_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_credentials_on_provider_name_and_uid ON credentials USING btree (provider_name, uid);


--
-- Name: index_goals_on_metric_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_goals_on_metric_key ON goals USING btree (metric_key);


--
-- Name: index_goals_on_slug_and_credential_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_goals_on_slug_and_credential_id ON goals USING btree (slug, credential_id);


--
-- Name: index_scores_on_goal_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scores_on_goal_id ON scores USING btree (goal_id);


--
-- Name: index_scores_on_goal_id_and_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_scores_on_goal_id_and_timestamp ON scores USING btree (goal_id, "timestamp");


--
-- Name: index_users_on_beeminder_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_beeminder_user_id ON users USING btree (beeminder_user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_credentials_beeminder_user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY credentials
    ADD CONSTRAINT fk_credentials_beeminder_user_id FOREIGN KEY (beeminder_user_id) REFERENCES users(beeminder_user_id);


--
-- Name: fk_goals_provider_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goals
    ADD CONSTRAINT fk_goals_provider_id FOREIGN KEY (credential_id) REFERENCES credentials(id);


--
-- Name: fk_scores_goal_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY scores
    ADD CONSTRAINT fk_scores_goal_id FOREIGN KEY (goal_id) REFERENCES goals(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES
('20140714204840'),
('20140729165051'),
('20150719185636'),
('20150721223451'),
('20150907205208'),
('20150908234553'),
('20150909225051'),
('20150926194732'),
('20150926210204'),
('20160316220158'),
('20160519212602'),
('20170125204752');


