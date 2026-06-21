--
-- PostgreSQL database dump
--

\restrict ZsS0fda5GFOmGRQYz1VMhboOZeMQEH0CcoCofPD8W4G3eCaqJ81VX7kDtgKlrGG

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    action character varying(255) NOT NULL,
    entity character varying(255) NOT NULL,
    entity_id bigint NOT NULL,
    old_data json,
    new_data json,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_id_seq OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: bidang_keahlians; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bidang_keahlians (
    id bigint NOT NULL,
    nama_bidang character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.bidang_keahlians OWNER TO postgres;

--
-- Name: bidang_keahlians_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bidang_keahlians_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bidang_keahlians_id_seq OWNER TO postgres;

--
-- Name: bidang_keahlians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bidang_keahlians_id_seq OWNED BY public.bidang_keahlians.id;


--
-- Name: cache; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache OWNER TO postgres;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration bigint NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO postgres;

--
-- Name: catatan_privat_dosens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.catatan_privat_dosens (
    id bigint NOT NULL,
    dosen_id bigint NOT NULL,
    mahasiswa_id bigint NOT NULL,
    catatan text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.catatan_privat_dosens OWNER TO postgres;

--
-- Name: catatan_privat_dosens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.catatan_privat_dosens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.catatan_privat_dosens_id_seq OWNER TO postgres;

--
-- Name: catatan_privat_dosens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.catatan_privat_dosens_id_seq OWNED BY public.catatan_privat_dosens.id;


--
-- Name: dokumen_skripsis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dokumen_skripsis (
    id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    jenis_dokumen character varying(255) NOT NULL,
    file_url character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.dokumen_skripsis OWNER TO postgres;

--
-- Name: dokumen_skripsis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dokumen_skripsis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dokumen_skripsis_id_seq OWNER TO postgres;

--
-- Name: dokumen_skripsis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dokumen_skripsis_id_seq OWNED BY public.dokumen_skripsis.id;


--
-- Name: dosen_bidang_keahlians; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dosen_bidang_keahlians (
    id bigint NOT NULL,
    dosen_id bigint NOT NULL,
    bidang_keahlian_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.dosen_bidang_keahlians OWNER TO postgres;

--
-- Name: dosen_bidang_keahlians_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dosen_bidang_keahlians_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dosen_bidang_keahlians_id_seq OWNER TO postgres;

--
-- Name: dosen_bidang_keahlians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dosen_bidang_keahlians_id_seq OWNED BY public.dosen_bidang_keahlians.id;


--
-- Name: dosens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dosens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    nidn character varying(255) NOT NULL,
    jabatan_fungsional character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    kuota_bimbingan integer DEFAULT 10 NOT NULL
);


ALTER TABLE public.dosens OWNER TO postgres;

--
-- Name: dosens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dosens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dosens_id_seq OWNER TO postgres;

--
-- Name: dosens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dosens_id_seq OWNED BY public.dosens.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection character varying(255) NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO postgres;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: fcm_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fcm_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token character varying(255) NOT NULL,
    device_info character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.fcm_tokens OWNER TO postgres;

--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fcm_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fcm_tokens_id_seq OWNER TO postgres;

--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fcm_tokens_id_seq OWNED BY public.fcm_tokens.id;


--
-- Name: jadwal_bimbingans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jadwal_bimbingans (
    id bigint NOT NULL,
    pembimbing_id bigint NOT NULL,
    slot_bimbingan_id bigint NOT NULL,
    tanggal date NOT NULL,
    status character varying(255) DEFAULT 'scheduled'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.jadwal_bimbingans OWNER TO postgres;

--
-- Name: jadwal_bimbingans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jadwal_bimbingans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jadwal_bimbingans_id_seq OWNER TO postgres;

--
-- Name: jadwal_bimbingans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jadwal_bimbingans_id_seq OWNED BY public.jadwal_bimbingans.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO postgres;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO postgres;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: kelas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kelas (
    id bigint NOT NULL,
    nama_kelas character varying(255) NOT NULL,
    program_studi_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.kelas OWNER TO postgres;

--
-- Name: kelas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kelas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kelas_id_seq OWNER TO postgres;

--
-- Name: kelas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kelas_id_seq OWNED BY public.kelas.id;


--
-- Name: laporan_exports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.laporan_exports (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    jenis_laporan character varying(255) NOT NULL,
    file_url character varying(255),
    status character varying(255) DEFAULT 'processing'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.laporan_exports OWNER TO postgres;

--
-- Name: laporan_exports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.laporan_exports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.laporan_exports_id_seq OWNER TO postgres;

--
-- Name: laporan_exports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.laporan_exports_id_seq OWNED BY public.laporan_exports.id;


--
-- Name: logbook_bimbingans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logbook_bimbingans (
    id bigint NOT NULL,
    mahasiswa_id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    dosen_id bigint NOT NULL,
    tanggal_kegiatan date NOT NULL,
    deskripsi_kegiatan text NOT NULL,
    bukti_file_url character varying(255),
    status_approval character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT logbook_bimbingans_status_approval_check CHECK (((status_approval)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'revised'::character varying])::text[])))
);


ALTER TABLE public.logbook_bimbingans OWNER TO postgres;

--
-- Name: logbook_bimbingans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logbook_bimbingans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logbook_bimbingans_id_seq OWNER TO postgres;

--
-- Name: logbook_bimbingans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logbook_bimbingans_id_seq OWNED BY public.logbook_bimbingans.id;


--
-- Name: mahasiswas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mahasiswas (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    nim character varying(255) NOT NULL,
    program_studi_id bigint NOT NULL,
    kelas_id bigint NOT NULL,
    tahun_masuk character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.mahasiswas OWNER TO postgres;

--
-- Name: mahasiswas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mahasiswas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mahasiswas_id_seq OWNER TO postgres;

--
-- Name: mahasiswas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mahasiswas_id_seq OWNED BY public.mahasiswas.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO postgres;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: notifikasis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifikasis (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    judul character varying(255) NOT NULL,
    pesan text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.notifikasis OWNER TO postgres;

--
-- Name: notifikasis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifikasis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifikasis_id_seq OWNER TO postgres;

--
-- Name: notifikasis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifikasis_id_seq OWNED BY public.notifikasis.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO postgres;

--
-- Name: pembimbings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pembimbings (
    id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    dosen_id bigint NOT NULL,
    peran character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'aktif'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.pembimbings OWNER TO postgres;

--
-- Name: pembimbings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pembimbings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pembimbings_id_seq OWNER TO postgres;

--
-- Name: pembimbings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pembimbings_id_seq OWNED BY public.pembimbings.id;


--
-- Name: pendaftaran_sidangs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pendaftaran_sidangs (
    id bigint NOT NULL,
    mahasiswa_id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    jenis_sidang character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    file_syarat_url character varying(255),
    keterangan text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    acc_pembimbing boolean DEFAULT false NOT NULL,
    tanggal_acc date,
    ttd_digital_hash character varying(255),
    tanggal_sidang date,
    waktu_mulai time(0) without time zone,
    waktu_selesai time(0) without time zone,
    ruangan_id bigint,
    turnitin_score integer,
    turnitin_status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    turnitin_file_url character varying(255),
    CONSTRAINT pendaftaran_sidangs_jenis_sidang_check CHECK (((jenis_sidang)::text = ANY ((ARRAY['sempro'::character varying, 'akhir'::character varying])::text[]))),
    CONSTRAINT pendaftaran_sidangs_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[]))),
    CONSTRAINT pendaftaran_sidangs_turnitin_status_check CHECK (((turnitin_status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.pendaftaran_sidangs OWNER TO postgres;

--
-- Name: pendaftaran_sidangs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pendaftaran_sidangs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pendaftaran_sidangs_id_seq OWNER TO postgres;

--
-- Name: pendaftaran_sidangs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pendaftaran_sidangs_id_seq OWNED BY public.pendaftaran_sidangs.id;


--
-- Name: pengajuan_juduls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pengajuan_juduls (
    id bigint NOT NULL,
    mahasiswa_id bigint NOT NULL,
    periode_skripsi_id bigint NOT NULL,
    judul character varying(255) NOT NULL,
    deskripsi text,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.pengajuan_juduls OWNER TO postgres;

--
-- Name: pengajuan_juduls_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pengajuan_juduls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pengajuan_juduls_id_seq OWNER TO postgres;

--
-- Name: pengajuan_juduls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pengajuan_juduls_id_seq OWNED BY public.pengajuan_juduls.id;


--
-- Name: penguji_sidangs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.penguji_sidangs (
    id bigint NOT NULL,
    pendaftaran_sidang_id bigint NOT NULL,
    dosen_id bigint NOT NULL,
    peran character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.penguji_sidangs OWNER TO postgres;

--
-- Name: penguji_sidangs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.penguji_sidangs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.penguji_sidangs_id_seq OWNER TO postgres;

--
-- Name: penguji_sidangs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.penguji_sidangs_id_seq OWNED BY public.penguji_sidangs.id;


--
-- Name: pergantian_pembimbings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pergantian_pembimbings (
    id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    dosen_lama_id bigint NOT NULL,
    dosen_baru_id bigint NOT NULL,
    alasan text NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.pergantian_pembimbings OWNER TO postgres;

--
-- Name: pergantian_pembimbings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pergantian_pembimbings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pergantian_pembimbings_id_seq OWNER TO postgres;

--
-- Name: pergantian_pembimbings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pergantian_pembimbings_id_seq OWNED BY public.pergantian_pembimbings.id;


--
-- Name: periode_skripsis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periode_skripsis (
    id bigint NOT NULL,
    nama_periode character varying(255) NOT NULL,
    tanggal_mulai date NOT NULL,
    tanggal_selesai date NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.periode_skripsis OWNER TO postgres;

--
-- Name: periode_skripsis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.periode_skripsis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.periode_skripsis_id_seq OWNER TO postgres;

--
-- Name: periode_skripsis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.periode_skripsis_id_seq OWNED BY public.periode_skripsis.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name text NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.personal_access_tokens OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personal_access_tokens_id_seq OWNER TO postgres;

--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;


--
-- Name: perubahan_juduls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perubahan_juduls (
    id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    judul_lama character varying(255) NOT NULL,
    judul_baru character varying(255) NOT NULL,
    alasan text NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.perubahan_juduls OWNER TO postgres;

--
-- Name: perubahan_juduls_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.perubahan_juduls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.perubahan_juduls_id_seq OWNER TO postgres;

--
-- Name: perubahan_juduls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.perubahan_juduls_id_seq OWNED BY public.perubahan_juduls.id;


--
-- Name: pesan_chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pesan_chats (
    id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    pengirim_id bigint NOT NULL,
    penerima_id bigint NOT NULL,
    pesan text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.pesan_chats OWNER TO postgres;

--
-- Name: pesan_chats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pesan_chats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pesan_chats_id_seq OWNER TO postgres;

--
-- Name: pesan_chats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pesan_chats_id_seq OWNED BY public.pesan_chats.id;


--
-- Name: program_studis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_studis (
    id bigint NOT NULL,
    kode_prodi character varying(255) NOT NULL,
    nama_prodi character varying(255) NOT NULL,
    jenjang character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.program_studis OWNER TO postgres;

--
-- Name: program_studis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_studis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.program_studis_id_seq OWNER TO postgres;

--
-- Name: program_studis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_studis_id_seq OWNED BY public.program_studis.id;


--
-- Name: progress_skripsis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progress_skripsis (
    id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    persentase integer NOT NULL,
    keterangan text NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    bab character varying(255) NOT NULL,
    status character varying(255) DEFAULT 'pending'::character varying NOT NULL
);


ALTER TABLE public.progress_skripsis OWNER TO postgres;

--
-- Name: progress_skripsis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.progress_skripsis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.progress_skripsis_id_seq OWNER TO postgres;

--
-- Name: progress_skripsis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.progress_skripsis_id_seq OWNED BY public.progress_skripsis.id;


--
-- Name: pusat_bantuans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pusat_bantuans (
    id bigint NOT NULL,
    kategori character varying(255) DEFAULT 'faq'::character varying NOT NULL,
    judul_pertanyaan_atau_dokumen character varying(255) NOT NULL,
    isi_jawaban_atau_url_file text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT pusat_bantuans_kategori_check CHECK (((kategori)::text = ANY ((ARRAY['faq'::character varying, 'dokumen_template'::character varying])::text[])))
);


ALTER TABLE public.pusat_bantuans OWNER TO postgres;

--
-- Name: pusat_bantuans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pusat_bantuans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pusat_bantuans_id_seq OWNER TO postgres;

--
-- Name: pusat_bantuans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pusat_bantuans_id_seq OWNED BY public.pusat_bantuans.id;


--
-- Name: referensi_mahasiswas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referensi_mahasiswas (
    id bigint NOT NULL,
    mahasiswa_id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    judul_artikel character varying(255) NOT NULL,
    penulis character varying(255),
    tahun_terbit character varying(255),
    url_tautan character varying(255),
    tipe_referensi character varying(255) DEFAULT 'jurnal'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT referensi_mahasiswas_tipe_referensi_check CHECK (((tipe_referensi)::text = ANY ((ARRAY['jurnal'::character varying, 'buku'::character varying, 'website'::character varying])::text[])))
);


ALTER TABLE public.referensi_mahasiswas OWNER TO postgres;

--
-- Name: referensi_mahasiswas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.referensi_mahasiswas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.referensi_mahasiswas_id_seq OWNER TO postgres;

--
-- Name: referensi_mahasiswas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.referensi_mahasiswas_id_seq OWNED BY public.referensi_mahasiswas.id;


--
-- Name: repositories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repositories (
    id bigint NOT NULL,
    mahasiswa_id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    abstrak text,
    file_dokumen_akhir_url character varying(255),
    views_count integer DEFAULT 0 NOT NULL,
    downloads_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.repositories OWNER TO postgres;

--
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repositories_id_seq OWNER TO postgres;

--
-- Name: repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repositories_id_seq OWNED BY public.repositories.id;


--
-- Name: review_dokumens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review_dokumens (
    id bigint NOT NULL,
    versi_dokumen_id bigint NOT NULL,
    dosen_id bigint NOT NULL,
    komentar text NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.review_dokumens OWNER TO postgres;

--
-- Name: review_dokumens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_dokumens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_dokumens_id_seq OWNER TO postgres;

--
-- Name: review_dokumens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_dokumens_id_seq OWNED BY public.review_dokumens.id;


--
-- Name: riwayat_bimbingans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.riwayat_bimbingans (
    id bigint NOT NULL,
    jadwal_bimbingan_id bigint NOT NULL,
    catatan_mahasiswa text,
    catatan_dosen text,
    status character varying(255) DEFAULT 'selesai'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.riwayat_bimbingans OWNER TO postgres;

--
-- Name: riwayat_bimbingans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.riwayat_bimbingans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.riwayat_bimbingans_id_seq OWNER TO postgres;

--
-- Name: riwayat_bimbingans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.riwayat_bimbingans_id_seq OWNED BY public.riwayat_bimbingans.id;


--
-- Name: riwayat_pengajuan_juduls; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.riwayat_pengajuan_juduls (
    id bigint NOT NULL,
    pengajuan_judul_id bigint NOT NULL,
    status_sebelumnya character varying(255) NOT NULL,
    status_baru character varying(255) NOT NULL,
    keterangan text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.riwayat_pengajuan_juduls OWNER TO postgres;

--
-- Name: riwayat_pengajuan_juduls_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.riwayat_pengajuan_juduls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.riwayat_pengajuan_juduls_id_seq OWNER TO postgres;

--
-- Name: riwayat_pengajuan_juduls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.riwayat_pengajuan_juduls_id_seq OWNED BY public.riwayat_pengajuan_juduls.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_permissions_id_seq OWNER TO postgres;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: ruangans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ruangans (
    id bigint NOT NULL,
    nama_ruangan character varying(255) NOT NULL,
    kapasitas integer DEFAULT 20 NOT NULL,
    gedung character varying(255),
    status_aktif boolean DEFAULT true NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.ruangans OWNER TO postgres;

--
-- Name: ruangans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ruangans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ruangans_id_seq OWNER TO postgres;

--
-- Name: ruangans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ruangans_id_seq OWNED BY public.ruangans.id;


--
-- Name: semesters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semesters (
    id bigint NOT NULL,
    nama character varying(255) NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.semesters OWNER TO postgres;

--
-- Name: semesters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semesters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.semesters_id_seq OWNER TO postgres;

--
-- Name: semesters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semesters_id_seq OWNED BY public.semesters.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: slot_bimbingans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.slot_bimbingans (
    id bigint NOT NULL,
    dosen_id bigint NOT NULL,
    hari character varying(255) NOT NULL,
    jam_mulai time(0) without time zone NOT NULL,
    jam_selesai time(0) without time zone NOT NULL,
    kuota integer NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.slot_bimbingans OWNER TO postgres;

--
-- Name: slot_bimbingans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.slot_bimbingans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.slot_bimbingans_id_seq OWNER TO postgres;

--
-- Name: slot_bimbingans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.slot_bimbingans_id_seq OWNED BY public.slot_bimbingans.id;


--
-- Name: tahun_akademiks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tahun_akademiks (
    id bigint NOT NULL,
    tahun character varying(255) NOT NULL,
    is_active boolean DEFAULT false NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.tahun_akademiks OWNER TO postgres;

--
-- Name: tahun_akademiks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tahun_akademiks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tahun_akademiks_id_seq OWNER TO postgres;

--
-- Name: tahun_akademiks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tahun_akademiks_id_seq OWNED BY public.tahun_akademiks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    role character varying(255) DEFAULT 'mahasiswa'::character varying NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    fcm_token character varying(255),
    avatar_url character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versi_dokumens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.versi_dokumens (
    id bigint NOT NULL,
    dokumen_skripsi_id bigint NOT NULL,
    versi integer NOT NULL,
    file_url character varying(255) NOT NULL,
    catatan_revisi text,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.versi_dokumens OWNER TO postgres;

--
-- Name: versi_dokumens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.versi_dokumens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.versi_dokumens_id_seq OWNER TO postgres;

--
-- Name: versi_dokumens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.versi_dokumens_id_seq OWNED BY public.versi_dokumens.id;


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: bidang_keahlians id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bidang_keahlians ALTER COLUMN id SET DEFAULT nextval('public.bidang_keahlians_id_seq'::regclass);


--
-- Name: catatan_privat_dosens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catatan_privat_dosens ALTER COLUMN id SET DEFAULT nextval('public.catatan_privat_dosens_id_seq'::regclass);


--
-- Name: dokumen_skripsis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dokumen_skripsis ALTER COLUMN id SET DEFAULT nextval('public.dokumen_skripsis_id_seq'::regclass);


--
-- Name: dosen_bidang_keahlians id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen_bidang_keahlians ALTER COLUMN id SET DEFAULT nextval('public.dosen_bidang_keahlians_id_seq'::regclass);


--
-- Name: dosens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosens ALTER COLUMN id SET DEFAULT nextval('public.dosens_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: fcm_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fcm_tokens ALTER COLUMN id SET DEFAULT nextval('public.fcm_tokens_id_seq'::regclass);


--
-- Name: jadwal_bimbingans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal_bimbingans ALTER COLUMN id SET DEFAULT nextval('public.jadwal_bimbingans_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: kelas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas ALTER COLUMN id SET DEFAULT nextval('public.kelas_id_seq'::regclass);


--
-- Name: laporan_exports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_exports ALTER COLUMN id SET DEFAULT nextval('public.laporan_exports_id_seq'::regclass);


--
-- Name: logbook_bimbingans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logbook_bimbingans ALTER COLUMN id SET DEFAULT nextval('public.logbook_bimbingans_id_seq'::regclass);


--
-- Name: mahasiswas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswas ALTER COLUMN id SET DEFAULT nextval('public.mahasiswas_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: notifikasis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifikasis ALTER COLUMN id SET DEFAULT nextval('public.notifikasis_id_seq'::regclass);


--
-- Name: pembimbings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pembimbings ALTER COLUMN id SET DEFAULT nextval('public.pembimbings_id_seq'::regclass);


--
-- Name: pendaftaran_sidangs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendaftaran_sidangs ALTER COLUMN id SET DEFAULT nextval('public.pendaftaran_sidangs_id_seq'::regclass);


--
-- Name: pengajuan_juduls id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengajuan_juduls ALTER COLUMN id SET DEFAULT nextval('public.pengajuan_juduls_id_seq'::regclass);


--
-- Name: penguji_sidangs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penguji_sidangs ALTER COLUMN id SET DEFAULT nextval('public.penguji_sidangs_id_seq'::regclass);


--
-- Name: pergantian_pembimbings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pergantian_pembimbings ALTER COLUMN id SET DEFAULT nextval('public.pergantian_pembimbings_id_seq'::regclass);


--
-- Name: periode_skripsis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periode_skripsis ALTER COLUMN id SET DEFAULT nextval('public.periode_skripsis_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);


--
-- Name: perubahan_juduls id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perubahan_juduls ALTER COLUMN id SET DEFAULT nextval('public.perubahan_juduls_id_seq'::regclass);


--
-- Name: pesan_chats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pesan_chats ALTER COLUMN id SET DEFAULT nextval('public.pesan_chats_id_seq'::regclass);


--
-- Name: program_studis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_studis ALTER COLUMN id SET DEFAULT nextval('public.program_studis_id_seq'::regclass);


--
-- Name: progress_skripsis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_skripsis ALTER COLUMN id SET DEFAULT nextval('public.progress_skripsis_id_seq'::regclass);


--
-- Name: pusat_bantuans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pusat_bantuans ALTER COLUMN id SET DEFAULT nextval('public.pusat_bantuans_id_seq'::regclass);


--
-- Name: referensi_mahasiswas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referensi_mahasiswas ALTER COLUMN id SET DEFAULT nextval('public.referensi_mahasiswas_id_seq'::regclass);


--
-- Name: repositories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repositories ALTER COLUMN id SET DEFAULT nextval('public.repositories_id_seq'::regclass);


--
-- Name: review_dokumens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_dokumens ALTER COLUMN id SET DEFAULT nextval('public.review_dokumens_id_seq'::regclass);


--
-- Name: riwayat_bimbingans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riwayat_bimbingans ALTER COLUMN id SET DEFAULT nextval('public.riwayat_bimbingans_id_seq'::regclass);


--
-- Name: riwayat_pengajuan_juduls id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riwayat_pengajuan_juduls ALTER COLUMN id SET DEFAULT nextval('public.riwayat_pengajuan_juduls_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: ruangans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangans ALTER COLUMN id SET DEFAULT nextval('public.ruangans_id_seq'::regclass);


--
-- Name: semesters id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters ALTER COLUMN id SET DEFAULT nextval('public.semesters_id_seq'::regclass);


--
-- Name: slot_bimbingans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_bimbingans ALTER COLUMN id SET DEFAULT nextval('public.slot_bimbingans_id_seq'::regclass);


--
-- Name: tahun_akademiks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tahun_akademiks ALTER COLUMN id SET DEFAULT nextval('public.tahun_akademiks_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versi_dokumens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versi_dokumens ALTER COLUMN id SET DEFAULT nextval('public.versi_dokumens_id_seq'::regclass);


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, user_id, action, entity, entity_id, old_data, new_data, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: bidang_keahlians; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bidang_keahlians (id, nama_bidang, created_at, updated_at) FROM stdin;
1	Web Development	2026-06-18 17:22:42	2026-06-18 17:22:42
2	Mobile Development	2026-06-18 17:22:42	2026-06-18 17:22:42
3	Artificial Intelligence	2026-06-18 17:22:42	2026-06-18 17:22:42
4	Cyber Security	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: catatan_privat_dosens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.catatan_privat_dosens (id, dosen_id, mahasiswa_id, catatan, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dokumen_skripsis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dokumen_skripsis (id, pengajuan_judul_id, jenis_dokumen, file_url, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dosen_bidang_keahlians; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dosen_bidang_keahlians (id, dosen_id, bidang_keahlian_id, created_at, updated_at) FROM stdin;
1	1	1	2026-06-18 17:22:44	2026-06-18 17:22:44
2	1	2	2026-06-18 17:22:44	2026-06-18 17:22:44
3	2	3	2026-06-18 17:22:44	2026-06-18 17:22:44
\.


--
-- Data for Name: dosens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dosens (id, user_id, nidn, jabatan_fungsional, created_at, updated_at, kuota_bimbingan) FROM stdin;
1	4	0412088901	Lektor	2026-06-18 17:22:44	2026-06-18 17:22:44	10
2	5	0412088902	Asisten Ahli	2026-06-18 17:22:44	2026-06-18 17:22:44	10
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: fcm_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fcm_tokens (id, user_id, token, device_info, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: jadwal_bimbingans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jadwal_bimbingans (id, pembimbing_id, slot_bimbingan_id, tanggal, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: kelas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kelas (id, nama_kelas, program_studi_id, created_at, updated_at) FROM stdin;
1	12.6A.01	1	2026-06-18 17:22:42	2026-06-18 17:22:42
2	12.6B.01	2	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: laporan_exports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.laporan_exports (id, user_id, jenis_laporan, file_url, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: logbook_bimbingans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logbook_bimbingans (id, mahasiswa_id, pengajuan_judul_id, dosen_id, tanggal_kegiatan, deskripsi_kegiatan, bukti_file_url, status_approval, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mahasiswas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mahasiswas (id, user_id, nim, program_studi_id, kelas_id, tahun_masuk, created_at, updated_at) FROM stdin;
1	6	12210001	1	1	2022	2026-06-18 17:22:44	2026-06-18 17:22:44
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2026_06_17_062811_create_personal_access_tokens_table	1
5	2026_06_18_092040_create_bimsi_ubsi_tables	1
6	2026_06_18_164338_add_bab_and_status_to_progress_skripsis_table	1
7	2026_06_18_165452_add_fcm_token_to_users_table	1
8	2026_06_19_112147_create_pendaftaran_sidangs_table	2
9	2026_06_19_112148_create_logbook_bimbingans_table	2
10	2026_06_19_112148_create_pesan_chats_table	2
11	2026_06_19_112149_create_pusat_bantuans_table	2
12	2026_06_19_112149_create_referensi_mahasiswas_table	2
13	2026_06_19_113455_add_acc_and_ttd_to_pendaftaran_sidangs_table	3
14	2026_06_19_113457_create_catatan_privat_dosens_table	3
15	2026_06_19_132212_add_kuota_bimbingan_to_dosens_table	4
16	2026_06_19_132218_create_penguji_sidangs_table	4
17	2026_06_19_133444_create_ruangans_table	5
18	2026_06_19_133445_add_jadwal_and_turnitin_to_pendaftaran_sidangs_table	5
19	2026_06_19_133445_create_repositories_table	5
20	2026_06_20_060532_add_avatar_url_to_users_table	6
\.


--
-- Data for Name: notifikasis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifikasis (id, user_id, judul, pesan, is_read, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: pembimbings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pembimbings (id, pengajuan_judul_id, dosen_id, peran, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pendaftaran_sidangs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pendaftaran_sidangs (id, mahasiswa_id, pengajuan_judul_id, jenis_sidang, status, file_syarat_url, keterangan, created_at, updated_at, acc_pembimbing, tanggal_acc, ttd_digital_hash, tanggal_sidang, waktu_mulai, waktu_selesai, ruangan_id, turnitin_score, turnitin_status, turnitin_file_url) FROM stdin;
\.


--
-- Data for Name: pengajuan_juduls; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pengajuan_juduls (id, mahasiswa_id, periode_skripsi_id, judul, deskripsi, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: penguji_sidangs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.penguji_sidangs (id, pendaftaran_sidang_id, dosen_id, peran, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pergantian_pembimbings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pergantian_pembimbings (id, pengajuan_judul_id, dosen_lama_id, dosen_baru_id, alasan, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: periode_skripsis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periode_skripsis (id, nama_periode, tanggal_mulai, tanggal_selesai, is_active, created_at, updated_at) FROM stdin;
1	Periode Ganjil 2025/2026	2025-09-01	2026-02-28	t	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, name, created_at, updated_at) FROM stdin;
1	manage_users	2026-06-18 17:22:42	2026-06-18 17:22:42
2	manage_master_data	2026-06-18 17:22:42	2026-06-18 17:22:42
3	approve_judul	2026-06-18 17:22:42	2026-06-18 17:22:42
4	assign_pembimbing	2026-06-18 17:22:42	2026-06-18 17:22:42
5	manage_slot_bimbingan	2026-06-18 17:22:42	2026-06-18 17:22:42
6	approve_jadwal_bimbingan	2026-06-18 17:22:42	2026-06-18 17:22:42
7	input_riwayat_bimbingan	2026-06-18 17:22:42	2026-06-18 17:22:42
8	upload_dokumen	2026-06-18 17:22:42	2026-06-18 17:22:42
9	review_dokumen	2026-06-18 17:22:42	2026-06-18 17:22:42
10	view_reports	2026-06-18 17:22:42	2026-06-18 17:22:42
11	view_audit_logs	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
9	App\\Models\\User	6	auth_token	3661c35302c80f66d8129cd29c40a30c087592d43eb7e00fada1dde25276ff8f	["*"]	2026-06-19 08:35:34	\N	2026-06-19 08:33:34	2026-06-19 08:35:34
10	App\\Models\\User	1	auth_token	30f0e6b6653c784abd51dd2eaa206f326f554a98112e73237c65457ee0653dda	["*"]	2026-06-19 13:15:10	\N	2026-06-19 13:14:44	2026-06-19 13:15:10
11	App\\Models\\User	1	auth_token	6ca9099204e30c1e8c569ea306451566141d83d8990671bf96f1e2a4c7d4aa16	["*"]	2026-06-19 13:22:07	\N	2026-06-19 13:22:06	2026-06-19 13:22:07
8	App\\Models\\User	1	auth_token	88755c4ddeead953e7eb16b49f9ea9b4f19922bffc3551311600ce6a960eea72	["*"]	2026-06-19 08:22:32	\N	2026-06-19 08:22:31	2026-06-19 08:22:32
\.


--
-- Data for Name: perubahan_juduls; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perubahan_juduls (id, pengajuan_judul_id, judul_lama, judul_baru, alasan, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pesan_chats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pesan_chats (id, pengajuan_judul_id, pengirim_id, penerima_id, pesan, is_read, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: program_studis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_studis (id, kode_prodi, nama_prodi, jenjang, created_at, updated_at) FROM stdin;
1	IF	Informatika	S1	2026-06-18 17:22:42	2026-06-18 17:22:42
2	SI	Sistem Informasi	S1	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: progress_skripsis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progress_skripsis (id, pengajuan_judul_id, persentase, keterangan, created_at, updated_at, bab, status) FROM stdin;
\.


--
-- Data for Name: pusat_bantuans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pusat_bantuans (id, kategori, judul_pertanyaan_atau_dokumen, isi_jawaban_atau_url_file, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: referensi_mahasiswas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.referensi_mahasiswas (id, mahasiswa_id, pengajuan_judul_id, judul_artikel, penulis, tahun_terbit, url_tautan, tipe_referensi, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: repositories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repositories (id, mahasiswa_id, pengajuan_judul_id, abstrak, file_dokumen_akhir_url, views_count, downloads_count, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: review_dokumens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review_dokumens (id, versi_dokumen_id, dosen_id, komentar, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: riwayat_bimbingans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.riwayat_bimbingans (id, jadwal_bimbingan_id, catatan_mahasiswa, catatan_dosen, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: riwayat_pengajuan_juduls; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.riwayat_pengajuan_juduls (id, pengajuan_judul_id, status_sebelumnya, status_baru, keterangan, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (id, role_id, permission_id, created_at, updated_at) FROM stdin;
1	1	1	2026-06-18 17:22:42	2026-06-18 17:22:42
2	1	2	2026-06-18 17:22:42	2026-06-18 17:22:42
3	1	3	2026-06-18 17:22:42	2026-06-18 17:22:42
4	1	4	2026-06-18 17:22:42	2026-06-18 17:22:42
5	1	5	2026-06-18 17:22:42	2026-06-18 17:22:42
6	1	6	2026-06-18 17:22:42	2026-06-18 17:22:42
7	1	7	2026-06-18 17:22:42	2026-06-18 17:22:42
8	1	8	2026-06-18 17:22:42	2026-06-18 17:22:42
9	1	9	2026-06-18 17:22:42	2026-06-18 17:22:42
10	1	10	2026-06-18 17:22:42	2026-06-18 17:22:42
11	1	11	2026-06-18 17:22:42	2026-06-18 17:22:42
12	2	1	2026-06-18 17:22:42	2026-06-18 17:22:42
13	2	2	2026-06-18 17:22:42	2026-06-18 17:22:42
14	2	10	2026-06-18 17:22:42	2026-06-18 17:22:42
15	3	3	2026-06-18 17:22:42	2026-06-18 17:22:42
16	3	4	2026-06-18 17:22:42	2026-06-18 17:22:42
17	3	10	2026-06-18 17:22:42	2026-06-18 17:22:42
18	4	5	2026-06-18 17:22:42	2026-06-18 17:22:42
19	4	6	2026-06-18 17:22:42	2026-06-18 17:22:42
20	4	7	2026-06-18 17:22:42	2026-06-18 17:22:42
21	4	9	2026-06-18 17:22:42	2026-06-18 17:22:42
22	5	8	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, created_at, updated_at) FROM stdin;
1	super_admin	2026-06-18 17:22:42	2026-06-18 17:22:42
2	admin	2026-06-18 17:22:42	2026-06-18 17:22:42
3	kaprodi	2026-06-18 17:22:42	2026-06-18 17:22:42
4	dosen	2026-06-18 17:22:42	2026-06-18 17:22:42
5	mahasiswa	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: ruangans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ruangans (id, nama_ruangan, kapasitas, gedung, status_aktif, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: semesters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semesters (id, nama, is_active, created_at, updated_at) FROM stdin;
1	Ganjil	t	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
xcakl4xHjTMr2Y12P725jDArXDMgI7w8pgwxif8z	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0	eyJfdG9rZW4iOiJJVVpvVHkwUHA4bEpxcGtQQ2xtUXpLY3NUTktrRHV5OWcyOExXWVY2IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwIiwicm91dGUiOm51bGx9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19	1781875398
euHeZRfYjHU1EUmWyzujgJPG8Pmdt3I7Bwe8vB0h	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0	eyJfdG9rZW4iOiJramFQYWFrUkloS1QxdjVhTEtLazl4djNhelpSYVFTRXBEM0R5MXZGIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwIiwicm91dGUiOm51bGx9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19	1781933693
HCBOc3t70laot93E4DDF4EXVcBU3SduVrfial04d	\N	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0	eyJfdG9rZW4iOiJjZkQ3YUo1dXJTOHFvVlROYmZJSm13SXRuZVE2QWpxZ1p6TEZudlpDIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDgwIiwicm91dGUiOm51bGx9LCJfZmxhc2giOnsib2xkIjpbXSwibmV3IjpbXX19	1781935246
\.


--
-- Data for Name: slot_bimbingans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.slot_bimbingans (id, dosen_id, hari, jam_mulai, jam_selesai, kuota, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tahun_akademiks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tahun_akademiks (id, tahun, is_active, created_at, updated_at) FROM stdin;
1	2025/2026	t	2026-06-18 17:22:42	2026-06-18 17:22:42
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, role, email_verified_at, password, remember_token, created_at, updated_at, fcm_token, avatar_url) FROM stdin;
1	Demo Super Admin	superadmin@bimsi.ac.id	super_admin	\N	$2y$12$dk6De8WJGEH5L3bzq/HCZeueBR673iZtE42I2WZsw5XKSn3FQt5jG	\N	2026-06-18 17:22:43	2026-06-18 17:22:43	\N	\N
2	Demo Admin	admin@bimsi.ac.id	admin	\N	$2y$12$hdrKHALCZYtk7E4g7WGR3u/uz2hCiGjPlgu11cf3JoHhQ8Nr2hotq	\N	2026-06-18 17:22:43	2026-06-18 17:22:43	\N	\N
3	Demo Kaprodi	kaprodi@bimsi.ac.id	kaprodi	\N	$2y$12$zYZMdu/LCJsaSMYotlzif.0.Vrlz8Bf//LFqMq0ls4/x7rUBiR5M6	\N	2026-06-18 17:22:43	2026-06-18 17:22:43	\N	\N
4	Demo Dosen 1	dosen@bimsi.ac.id	dosen	\N	$2y$12$1l5ucSUdLMCGhS8gv7v0puMZ2tBiGRjiJXH60oLE2iwww0H3R0sxm	\N	2026-06-18 17:22:43	2026-06-18 17:22:43	\N	\N
5	Demo Dosen 2	dosen2@bimsi.ac.id	dosen	\N	$2y$12$OfRBTcVaOmYNTGwtvMfnAuS8wX1rCryJq0SvkM20oIAMStgkE98sK	\N	2026-06-18 17:22:44	2026-06-18 17:22:44	\N	\N
6	Demo Mahasiswa	mahasiswa@bimsi.ac.id	mahasiswa	\N	$2y$12$eLYVmlZq7Myfj0.rnxImxOaLhrGTVLkzpcW4cb2nQr5NlRa1SXDXa	\N	2026-06-18 17:22:44	2026-06-18 17:22:44	\N	\N
\.


--
-- Data for Name: versi_dokumens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.versi_dokumens (id, dokumen_skripsi_id, versi, file_url, catatan_revisi, created_at, updated_at) FROM stdin;
\.


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 1, false);


--
-- Name: bidang_keahlians_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bidang_keahlians_id_seq', 4, true);


--
-- Name: catatan_privat_dosens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.catatan_privat_dosens_id_seq', 1, false);


--
-- Name: dokumen_skripsis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dokumen_skripsis_id_seq', 1, false);


--
-- Name: dosen_bidang_keahlians_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dosen_bidang_keahlians_id_seq', 3, true);


--
-- Name: dosens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dosens_id_seq', 2, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: fcm_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fcm_tokens_id_seq', 1, false);


--
-- Name: jadwal_bimbingans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jadwal_bimbingans_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: kelas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kelas_id_seq', 2, true);


--
-- Name: laporan_exports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.laporan_exports_id_seq', 1, false);


--
-- Name: logbook_bimbingans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logbook_bimbingans_id_seq', 1, false);


--
-- Name: mahasiswas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mahasiswas_id_seq', 1, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.migrations_id_seq', 20, true);


--
-- Name: notifikasis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifikasis_id_seq', 1, false);


--
-- Name: pembimbings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pembimbings_id_seq', 1, false);


--
-- Name: pendaftaran_sidangs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pendaftaran_sidangs_id_seq', 1, false);


--
-- Name: pengajuan_juduls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pengajuan_juduls_id_seq', 1, false);


--
-- Name: penguji_sidangs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.penguji_sidangs_id_seq', 1, false);


--
-- Name: pergantian_pembimbings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pergantian_pembimbings_id_seq', 1, false);


--
-- Name: periode_skripsis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.periode_skripsis_id_seq', 1, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 11, true);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 11, true);


--
-- Name: perubahan_juduls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.perubahan_juduls_id_seq', 1, false);


--
-- Name: pesan_chats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pesan_chats_id_seq', 1, false);


--
-- Name: program_studis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_studis_id_seq', 2, true);


--
-- Name: progress_skripsis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.progress_skripsis_id_seq', 1, false);


--
-- Name: pusat_bantuans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pusat_bantuans_id_seq', 1, false);


--
-- Name: referensi_mahasiswas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.referensi_mahasiswas_id_seq', 1, false);


--
-- Name: repositories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repositories_id_seq', 1, false);


--
-- Name: review_dokumens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_dokumens_id_seq', 1, false);


--
-- Name: riwayat_bimbingans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.riwayat_bimbingans_id_seq', 1, false);


--
-- Name: riwayat_pengajuan_juduls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.riwayat_pengajuan_juduls_id_seq', 1, false);


--
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 22, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 5, true);


--
-- Name: ruangans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ruangans_id_seq', 1, false);


--
-- Name: semesters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semesters_id_seq', 1, true);


--
-- Name: slot_bimbingans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.slot_bimbingans_id_seq', 1, false);


--
-- Name: tahun_akademiks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tahun_akademiks_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: versi_dokumens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.versi_dokumens_id_seq', 1, false);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: bidang_keahlians bidang_keahlians_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bidang_keahlians
    ADD CONSTRAINT bidang_keahlians_pkey PRIMARY KEY (id);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: catatan_privat_dosens catatan_privat_dosens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catatan_privat_dosens
    ADD CONSTRAINT catatan_privat_dosens_pkey PRIMARY KEY (id);


--
-- Name: dokumen_skripsis dokumen_skripsis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dokumen_skripsis
    ADD CONSTRAINT dokumen_skripsis_pkey PRIMARY KEY (id);


--
-- Name: dosen_bidang_keahlians dosen_bidang_keahlians_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen_bidang_keahlians
    ADD CONSTRAINT dosen_bidang_keahlians_pkey PRIMARY KEY (id);


--
-- Name: dosens dosens_nidn_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosens
    ADD CONSTRAINT dosens_nidn_unique UNIQUE (nidn);


--
-- Name: dosens dosens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosens
    ADD CONSTRAINT dosens_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: fcm_tokens fcm_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fcm_tokens
    ADD CONSTRAINT fcm_tokens_pkey PRIMARY KEY (id);


--
-- Name: jadwal_bimbingans jadwal_bimbingans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal_bimbingans
    ADD CONSTRAINT jadwal_bimbingans_pkey PRIMARY KEY (id);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: kelas kelas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_pkey PRIMARY KEY (id);


--
-- Name: laporan_exports laporan_exports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_exports
    ADD CONSTRAINT laporan_exports_pkey PRIMARY KEY (id);


--
-- Name: logbook_bimbingans logbook_bimbingans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logbook_bimbingans
    ADD CONSTRAINT logbook_bimbingans_pkey PRIMARY KEY (id);


--
-- Name: mahasiswas mahasiswas_nim_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswas
    ADD CONSTRAINT mahasiswas_nim_unique UNIQUE (nim);


--
-- Name: mahasiswas mahasiswas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswas
    ADD CONSTRAINT mahasiswas_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: notifikasis notifikasis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifikasis
    ADD CONSTRAINT notifikasis_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: pembimbings pembimbings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pembimbings
    ADD CONSTRAINT pembimbings_pkey PRIMARY KEY (id);


--
-- Name: pendaftaran_sidangs pendaftaran_sidangs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendaftaran_sidangs
    ADD CONSTRAINT pendaftaran_sidangs_pkey PRIMARY KEY (id);


--
-- Name: pendaftaran_sidangs pendaftaran_sidangs_ttd_digital_hash_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendaftaran_sidangs
    ADD CONSTRAINT pendaftaran_sidangs_ttd_digital_hash_unique UNIQUE (ttd_digital_hash);


--
-- Name: pengajuan_juduls pengajuan_juduls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengajuan_juduls
    ADD CONSTRAINT pengajuan_juduls_pkey PRIMARY KEY (id);


--
-- Name: penguji_sidangs penguji_sidangs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penguji_sidangs
    ADD CONSTRAINT penguji_sidangs_pkey PRIMARY KEY (id);


--
-- Name: pergantian_pembimbings pergantian_pembimbings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pergantian_pembimbings
    ADD CONSTRAINT pergantian_pembimbings_pkey PRIMARY KEY (id);


--
-- Name: periode_skripsis periode_skripsis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periode_skripsis
    ADD CONSTRAINT periode_skripsis_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);


--
-- Name: perubahan_juduls perubahan_juduls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perubahan_juduls
    ADD CONSTRAINT perubahan_juduls_pkey PRIMARY KEY (id);


--
-- Name: pesan_chats pesan_chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pesan_chats
    ADD CONSTRAINT pesan_chats_pkey PRIMARY KEY (id);


--
-- Name: program_studis program_studis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_studis
    ADD CONSTRAINT program_studis_pkey PRIMARY KEY (id);


--
-- Name: progress_skripsis progress_skripsis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_skripsis
    ADD CONSTRAINT progress_skripsis_pkey PRIMARY KEY (id);


--
-- Name: pusat_bantuans pusat_bantuans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pusat_bantuans
    ADD CONSTRAINT pusat_bantuans_pkey PRIMARY KEY (id);


--
-- Name: referensi_mahasiswas referensi_mahasiswas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referensi_mahasiswas
    ADD CONSTRAINT referensi_mahasiswas_pkey PRIMARY KEY (id);


--
-- Name: repositories repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);


--
-- Name: review_dokumens review_dokumens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_dokumens
    ADD CONSTRAINT review_dokumens_pkey PRIMARY KEY (id);


--
-- Name: riwayat_bimbingans riwayat_bimbingans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riwayat_bimbingans
    ADD CONSTRAINT riwayat_bimbingans_pkey PRIMARY KEY (id);


--
-- Name: riwayat_pengajuan_juduls riwayat_pengajuan_juduls_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riwayat_pengajuan_juduls
    ADD CONSTRAINT riwayat_pengajuan_juduls_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: ruangans ruangans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ruangans
    ADD CONSTRAINT ruangans_pkey PRIMARY KEY (id);


--
-- Name: semesters semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters
    ADD CONSTRAINT semesters_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: slot_bimbingans slot_bimbingans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_bimbingans
    ADD CONSTRAINT slot_bimbingans_pkey PRIMARY KEY (id);


--
-- Name: tahun_akademiks tahun_akademiks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tahun_akademiks
    ADD CONSTRAINT tahun_akademiks_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versi_dokumens versi_dokumens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versi_dokumens
    ADD CONSTRAINT versi_dokumens_pkey PRIMARY KEY (id);


--
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- Name: failed_jobs_connection_queue_failed_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX failed_jobs_connection_queue_failed_at_index ON public.failed_jobs USING btree (connection, queue, failed_at);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_expires_at_index ON public.personal_access_tokens USING btree (expires_at);


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- Name: audit_logs audit_logs_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: catatan_privat_dosens catatan_privat_dosens_dosen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catatan_privat_dosens
    ADD CONSTRAINT catatan_privat_dosens_dosen_id_foreign FOREIGN KEY (dosen_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: catatan_privat_dosens catatan_privat_dosens_mahasiswa_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.catatan_privat_dosens
    ADD CONSTRAINT catatan_privat_dosens_mahasiswa_id_foreign FOREIGN KEY (mahasiswa_id) REFERENCES public.mahasiswas(id) ON DELETE CASCADE;


--
-- Name: dokumen_skripsis dokumen_skripsis_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dokumen_skripsis
    ADD CONSTRAINT dokumen_skripsis_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: dosen_bidang_keahlians dosen_bidang_keahlians_bidang_keahlian_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen_bidang_keahlians
    ADD CONSTRAINT dosen_bidang_keahlians_bidang_keahlian_id_foreign FOREIGN KEY (bidang_keahlian_id) REFERENCES public.bidang_keahlians(id) ON DELETE CASCADE;


--
-- Name: dosen_bidang_keahlians dosen_bidang_keahlians_dosen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosen_bidang_keahlians
    ADD CONSTRAINT dosen_bidang_keahlians_dosen_id_foreign FOREIGN KEY (dosen_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: dosens dosens_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dosens
    ADD CONSTRAINT dosens_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: fcm_tokens fcm_tokens_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fcm_tokens
    ADD CONSTRAINT fcm_tokens_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: jadwal_bimbingans jadwal_bimbingans_pembimbing_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal_bimbingans
    ADD CONSTRAINT jadwal_bimbingans_pembimbing_id_foreign FOREIGN KEY (pembimbing_id) REFERENCES public.pembimbings(id) ON DELETE CASCADE;


--
-- Name: jadwal_bimbingans jadwal_bimbingans_slot_bimbingan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.jadwal_bimbingans
    ADD CONSTRAINT jadwal_bimbingans_slot_bimbingan_id_foreign FOREIGN KEY (slot_bimbingan_id) REFERENCES public.slot_bimbingans(id) ON DELETE CASCADE;


--
-- Name: kelas kelas_program_studi_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_program_studi_id_foreign FOREIGN KEY (program_studi_id) REFERENCES public.program_studis(id) ON DELETE CASCADE;


--
-- Name: laporan_exports laporan_exports_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.laporan_exports
    ADD CONSTRAINT laporan_exports_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: logbook_bimbingans logbook_bimbingans_dosen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logbook_bimbingans
    ADD CONSTRAINT logbook_bimbingans_dosen_id_foreign FOREIGN KEY (dosen_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: logbook_bimbingans logbook_bimbingans_mahasiswa_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logbook_bimbingans
    ADD CONSTRAINT logbook_bimbingans_mahasiswa_id_foreign FOREIGN KEY (mahasiswa_id) REFERENCES public.mahasiswas(id) ON DELETE CASCADE;


--
-- Name: logbook_bimbingans logbook_bimbingans_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logbook_bimbingans
    ADD CONSTRAINT logbook_bimbingans_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: mahasiswas mahasiswas_kelas_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswas
    ADD CONSTRAINT mahasiswas_kelas_id_foreign FOREIGN KEY (kelas_id) REFERENCES public.kelas(id) ON DELETE CASCADE;


--
-- Name: mahasiswas mahasiswas_program_studi_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswas
    ADD CONSTRAINT mahasiswas_program_studi_id_foreign FOREIGN KEY (program_studi_id) REFERENCES public.program_studis(id) ON DELETE CASCADE;


--
-- Name: mahasiswas mahasiswas_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mahasiswas
    ADD CONSTRAINT mahasiswas_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: notifikasis notifikasis_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifikasis
    ADD CONSTRAINT notifikasis_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: pembimbings pembimbings_dosen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pembimbings
    ADD CONSTRAINT pembimbings_dosen_id_foreign FOREIGN KEY (dosen_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: pembimbings pembimbings_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pembimbings
    ADD CONSTRAINT pembimbings_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: pendaftaran_sidangs pendaftaran_sidangs_mahasiswa_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendaftaran_sidangs
    ADD CONSTRAINT pendaftaran_sidangs_mahasiswa_id_foreign FOREIGN KEY (mahasiswa_id) REFERENCES public.mahasiswas(id) ON DELETE CASCADE;


--
-- Name: pendaftaran_sidangs pendaftaran_sidangs_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendaftaran_sidangs
    ADD CONSTRAINT pendaftaran_sidangs_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: pendaftaran_sidangs pendaftaran_sidangs_ruangan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pendaftaran_sidangs
    ADD CONSTRAINT pendaftaran_sidangs_ruangan_id_foreign FOREIGN KEY (ruangan_id) REFERENCES public.ruangans(id) ON DELETE SET NULL;


--
-- Name: pengajuan_juduls pengajuan_juduls_mahasiswa_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengajuan_juduls
    ADD CONSTRAINT pengajuan_juduls_mahasiswa_id_foreign FOREIGN KEY (mahasiswa_id) REFERENCES public.mahasiswas(id) ON DELETE CASCADE;


--
-- Name: pengajuan_juduls pengajuan_juduls_periode_skripsi_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pengajuan_juduls
    ADD CONSTRAINT pengajuan_juduls_periode_skripsi_id_foreign FOREIGN KEY (periode_skripsi_id) REFERENCES public.periode_skripsis(id) ON DELETE CASCADE;


--
-- Name: penguji_sidangs penguji_sidangs_dosen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penguji_sidangs
    ADD CONSTRAINT penguji_sidangs_dosen_id_foreign FOREIGN KEY (dosen_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: penguji_sidangs penguji_sidangs_pendaftaran_sidang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.penguji_sidangs
    ADD CONSTRAINT penguji_sidangs_pendaftaran_sidang_id_foreign FOREIGN KEY (pendaftaran_sidang_id) REFERENCES public.pendaftaran_sidangs(id) ON DELETE CASCADE;


--
-- Name: pergantian_pembimbings pergantian_pembimbings_dosen_baru_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pergantian_pembimbings
    ADD CONSTRAINT pergantian_pembimbings_dosen_baru_id_foreign FOREIGN KEY (dosen_baru_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: pergantian_pembimbings pergantian_pembimbings_dosen_lama_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pergantian_pembimbings
    ADD CONSTRAINT pergantian_pembimbings_dosen_lama_id_foreign FOREIGN KEY (dosen_lama_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: pergantian_pembimbings pergantian_pembimbings_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pergantian_pembimbings
    ADD CONSTRAINT pergantian_pembimbings_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: perubahan_juduls perubahan_juduls_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perubahan_juduls
    ADD CONSTRAINT perubahan_juduls_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: pesan_chats pesan_chats_penerima_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pesan_chats
    ADD CONSTRAINT pesan_chats_penerima_id_foreign FOREIGN KEY (penerima_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: pesan_chats pesan_chats_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pesan_chats
    ADD CONSTRAINT pesan_chats_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: pesan_chats pesan_chats_pengirim_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pesan_chats
    ADD CONSTRAINT pesan_chats_pengirim_id_foreign FOREIGN KEY (pengirim_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: progress_skripsis progress_skripsis_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_skripsis
    ADD CONSTRAINT progress_skripsis_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: referensi_mahasiswas referensi_mahasiswas_mahasiswa_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referensi_mahasiswas
    ADD CONSTRAINT referensi_mahasiswas_mahasiswa_id_foreign FOREIGN KEY (mahasiswa_id) REFERENCES public.mahasiswas(id) ON DELETE CASCADE;


--
-- Name: referensi_mahasiswas referensi_mahasiswas_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referensi_mahasiswas
    ADD CONSTRAINT referensi_mahasiswas_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: repositories repositories_mahasiswa_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_mahasiswa_id_foreign FOREIGN KEY (mahasiswa_id) REFERENCES public.mahasiswas(id) ON DELETE CASCADE;


--
-- Name: repositories repositories_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: review_dokumens review_dokumens_dosen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_dokumens
    ADD CONSTRAINT review_dokumens_dosen_id_foreign FOREIGN KEY (dosen_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: review_dokumens review_dokumens_versi_dokumen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review_dokumens
    ADD CONSTRAINT review_dokumens_versi_dokumen_id_foreign FOREIGN KEY (versi_dokumen_id) REFERENCES public.versi_dokumens(id) ON DELETE CASCADE;


--
-- Name: riwayat_bimbingans riwayat_bimbingans_jadwal_bimbingan_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riwayat_bimbingans
    ADD CONSTRAINT riwayat_bimbingans_jadwal_bimbingan_id_foreign FOREIGN KEY (jadwal_bimbingan_id) REFERENCES public.jadwal_bimbingans(id) ON DELETE CASCADE;


--
-- Name: riwayat_pengajuan_juduls riwayat_pengajuan_juduls_pengajuan_judul_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.riwayat_pengajuan_juduls
    ADD CONSTRAINT riwayat_pengajuan_juduls_pengajuan_judul_id_foreign FOREIGN KEY (pengajuan_judul_id) REFERENCES public.pengajuan_juduls(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: slot_bimbingans slot_bimbingans_dosen_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.slot_bimbingans
    ADD CONSTRAINT slot_bimbingans_dosen_id_foreign FOREIGN KEY (dosen_id) REFERENCES public.dosens(id) ON DELETE CASCADE;


--
-- Name: versi_dokumens versi_dokumens_dokumen_skripsi_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.versi_dokumens
    ADD CONSTRAINT versi_dokumens_dokumen_skripsi_id_foreign FOREIGN KEY (dokumen_skripsi_id) REFERENCES public.dokumen_skripsis(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ZsS0fda5GFOmGRQYz1VMhboOZeMQEH0CcoCofPD8W4G3eCaqJ81VX7kDtgKlrGG

