--==============================================
-- CAMARA DB
--==============================================

------------------------------------------------
-- EMENTAS
------------------------------------------------

-- ementas
DROP TABLE IF EXISTS ementas;
CREATE TABLE ementas(
    ementa_id           VARCHAR(200) NOT NULL,

    -- First page (table with all ementa names)
    published_date      TIMESTAMP without time zone NOT NULL,
    ementa_type         VARCHAR(100) NOT NULL,
    document_number     INTEGER NOT NULL,
    title               TEXT NOT NULL,

    -- Second page (ementa details only)
    source              VARCHAR(30) NOT NULL,
    proponents          TEXT,
    situation           VARCHAR(30) NOT NULL,
    main_theme          VARCHAR(100),
    approval_date       TIMESTAMP without time zone NOT NULL,

    process_number      INTEGER,
    autograph_number    INTEGER,
    process_year        INTEGER,
    has_image           BOOLEAN,

    sys_enter_date      TIMESTAMP without time zone NOT NULL,
    insert_time         TIMESTAMP,

    CONSTRAINT ementa_pkey PRIMARY KEY (ementa_id)
) WITH (
    OIDS=FALSE
);
ALTER TABLE ementas OWNER TO augusto;
