--==============================================
-- CAMARA DB
--==============================================

------------------------------------------------
-- CANDIDATOS
------------------------------------------------

-- bem_candidato
DROP TABLE IF EXISTS bem_candidato;
CREATE TABLE bem_candidato
(
    DATA_GERACAO                TEXT,
    HORA_GERACAO                TEXT,
    ANO_ELEICAO                 INTEGER,
    DESCRICAO_ELEICAO           TEXT,               -- JOINable column
    SIGLA_UF                    TEXT,               -- JOINable column
    SQ_CANDIDATO                BIGINT,             -- JOINable column
    CD_TIPO_BEM_CANDIDATO       INTEGER,
    DS_TIPO_BEM_CANDIDATO       TEXT,
    DETALHE_BEM                 TEXT,
    VALOR_BEM                   NUMERIC(18,2),
    DATA_ULTIMA_ATUALIZACAO     TEXT,
    HORA_ULTIMA_ATUALIZACAO     TEXT
) WITH
(
    OIDS=FALSE
);
ALTER TABLE bem_candidato OWNER TO augusto;


-- consulta_cand
DROP TABLE IF EXISTS consulta_cand;
CREATE TABLE consulta_cand
(
    DATA_GERACAO                    TEXT,
    HORA_GERACAO                    TEXT,
    ANO_ELEICAO                     INTEGER,
    NUM_TURNO                       INTEGER,        -- JOINable column
    DESCRICAO_ELEICAO               TEXT,           -- JOINable column
    SIGLA_UF                        TEXT,
    SIGLA_UE                        INTEGER,        -- JOINable column
    DESCRICAO_UE                    TEXT,
    CODIGO_CARGO                    INTEGER,        -- JOINable column
    DESCRICAO_CARGO                 TEXT,
    NOME_CANDIDATO                  TEXT,
    SEQUENCIAL_CANDIDATO            BIGINT,         -- JOINable column
    NUMERO_CANDIDATO                INTEGER,
    CPF_CANDIDATO                   TEXT,
    NOME_URNA_CANDIDATO             TEXT,
    COD_SITUACAO_CANDIDATURA        INTEGER,
    DES_SITUACAO_CANDIDATURA        TEXT,
    NUMERO_PARTIDO                  INTEGER,
    SIGLA_PARTIDO                   TEXT,
    NOME_PARTIDO                    TEXT,
    CODIGO_LEGENDA                  BIGINT,
    SIGLA_LEGENDA                   TEXT,
    COMPOSICAO_LEGENDA              TEXT,
    NOME_LEGENDA                    TEXT,
    CODIGO_OCUPACAO                 INTEGER,
    DESCRICAO_OCUPACAO              TEXT,
    DATA_NASCIMENTO                 TEXT,
    NUM_TITULO_ELEITORAL_CANDIDATO  TEXT,
    IDADE_DATA_ELEICAO              INTEGER,
    CODIGO_SEXO                     INTEGER,
    DESCRICAO_SEXO                  TEXT,
    COD_GRAU_INSTRUCAO              INTEGER,
    DESCRICAO_GRAU_INSTRUCAO        TEXT,
    CODIGO_ESTADO_CIVIL             INTEGER,
    DESCRICAO_ESTADO_CIVIL          TEXT,
    CODIGO_COR_RACA                 TEXT,
    DESCRICAO_COR_RACA              TEXT,
    CODIGO_NACIONALIDADE            INTEGER,
    DESCRICAO_NACIONALIDADE         TEXT,
    SIGLA_UF_NASCIMENTO             TEXT,
    CODIGO_MUNICIPIO_NASCIMENTO     INTEGER,
    NOME_MUNICIPIO_NASCIMENTO       TEXT,
    DESPESA_MAX_CAMPANHA            NUMERIC(18,2),
    COD_SIT_TOT_TURNO               INTEGER,
    DESC_SIT_TOT_TURNO              TEXT,
    EMAIL_CANDIDATO                 TEXT
) WITH
(
    OIDS=FALSE
);
ALTER TABLE consulta_cand OWNER TO augusto;

-- consulta_legendas
DROP TABLE IF EXISTS consulta_legendas;
CREATE TABLE consulta_legendas
(
    DATA_GERACAO                TEXT,
    HORA_GERACAO                TEXT,
    ANO_ELEICAO                 INTEGER,
    NUM_TURNO                   INTEGER,            -- JOINable column
    DESCRICAO_ELEICAO           TEXT,               -- JOINable column
    SIGLA_UF                    TEXT,
    SIGLA_UE                    INTEGER,            -- JOINable column
    NOME_UE                     TEXT,
    CODIGO_CARGO                INTEGER,            -- JOINable column
    DESCRICAO_CARGO             TEXT,
    TIPO_LEGENDA                TEXT,
    NUM_PARTIDO                 INTEGER,            -- JOINable column
    SIGLA_PARTIDO               TEXT,
    NOME_PARTIDO                TEXT,
    SIGLA_COLIGACAO             TEXT,
    NOME_COLIGACAO              TEXT,
    COMPOSICAO_COLIGACAO        TEXT,
    SEQUENCIAL_COLIGACAO        TEXT
) WITH
(
    OIDS=FALSE
);
ALTER TABLE consulta_legendas OWNER TO augusto;

-- consulta_vagas
DROP TABLE IF EXISTS consulta_vagas;
CREATE TABLE consulta_vagas
(
    DATA_GERACAO                TEXT,
    HORA_GERACAO                TEXT,
    ANO_ELEICAO                 INTEGER,
    DESCRICAO_ELEICAO           TEXT,               -- JOINable column
    SIGLA_UF                    TEXT,
    SIGLA_UE                    INTEGER,            -- JOINable column
    NOME_UE                     TEXT,
    CODIGO_CARGO                INTEGER,            -- JOINable column
    DESCRICAO_CARGO             TEXT,
    QTDE_VAGAS                  INTEGER
) WITH
(
    OIDS=FALSE
);
ALTER TABLE consulta_vagas OWNER TO augusto;

------------------------------------------------
-- ELEITORADO
------------------------------------------------

-- perfil_eleitor_secao
DROP TABLE IF EXISTS perfil_eleitor_secao;
CREATE TABLE perfil_eleitor_secao
(
    DATA_GERACAO                    TEXT,
    HORA_GERACAO                    TEXT,
    PERIODO                         INTEGER,
    UF                              TEXT,
    COD_MUNICIPIO_TSE               INTEGER,
    MUNICIPIO                       TEXT,
    NUM_ZONA                        INTEGER,        -- JOINable column
    NUM_SECAO                       INTEGER,        -- JOINable column
    CODIGO_ESTADO_CIVIL             INTEGER,
    DESCRICAO_ESTADO_CIVIL          TEXT,
    COD_FAIXA_ETARIA                INTEGER,
    DESC_FAIXA_ETARIA               TEXT,
    COD_GRAU_ESCOLARIDADE           INTEGER,
    DESC_GRAU_DE_ESCOLARIDADE       TEXT,
    CODIGO_SEXO                     INTEGER,
    DESCRICAO_SEXO                  TEXT,
    QTD_ELEITORES_NO_PERFIL         INTEGER
) WITH
(
    OIDS=FALSE
);
ALTER TABLE perfil_eleitor_secao OWNER TO augusto;

------------------------------------------------
-- RESULTADOS
------------------------------------------------
-- votacao_candidato_munzona
DROP TABLE IF EXISTS votacao_candidato_mun_zona;
CREATE TABLE votacao_candidato_mun_zona
(
    DATA_GERACAO                    TEXT,
    HORA_GERACAO                    TEXT,
    ANO_ELEICAO                     INTEGER,
    NUM_TURNO                       INTEGER,        -- JOINable column
    DESCRICAO_ELEICAO               TEXT,           -- JOINable column
    SIGLA_UF                        TEXT,
    SIGLA_UE                        INTEGER,        -- JOINable column
    CODIGO_MUNICIPIO                INTEGER,        -- JOINable column
    NOME_MUNICIPIO                  TEXT,
    NUMERO_ZONA                     INTEGER,        -- JOINable column
    CODIGO_CARGO                    INTEGER,        -- JOINable column
    NUMERO_CAND                     INTEGER,        -- JOINable column
    SQ_CANDIDATO                    BIGINT,         -- JOINable column
    NOME_CANDIDATO                  TEXT,
    NOME_URNA_CANDIDATO             TEXT,
    DESCRICAO_CARGO                 TEXT,
    COD_SIT_CAND_SUPERIOR           INTEGER,
    DESC_SIT_CAND_SUPERIOR          TEXT,
    CODIGO_SIT_CANDIDATO            INTEGER,
    DESC_SIT_CANDIDATO              TEXT,
    CODIGO_SIT_CAND_TOT             INTEGER,
    DESC_SIT_CAND_TOT               TEXT,
    NUMERO_PARTIDO                  INTEGER,
    SIGLA_PARTIDO                   TEXT,
    NOME_PARTIDO                    TEXT,
    SEQUENCIAL_LEGENDA              BIGINT,
    NOME_COLIGACAO                  TEXT,
    COMPOSICAO_LEGENDA              TEXT,
    TOTAL_VOTOS                     INTEGER
) WITH
(
    OIDS=FALSE
);
ALTER TABLE votacao_candidato_mun_zona OWNER TO augusto;


---------------------------------
-- CREATED BY ME
---------------------------------

-- comissoes_tecnicas
DROP TABLE IF EXISTS comissoes_tecnicas;
CREATE TABLE comissoes_tecnicas
(
    ANO_ELEICAO                 INTEGER,
    NOME_COMISSAO               TEXT,
    CARGO_COMISSAO              TEXT,
    NOME_VEREADOR               TEXT,
    SEQUENCIAL_CANDIDATO        BIGINT              -- JOINable column
) WITH
(
    OIDS=FALSE
);
ALTER TABLE comissoes_tecnicas OWNER TO augusto;

-- mesa_diretora
DROP TABLE IF EXISTS mesa_diretora;
CREATE TABLE mesa_diretora
(
    ANO_ELEICAO                 INTEGER,
    CARGO_MESA                  TEXT,
    NOME_VEREADOR               TEXT,
    SEQUENCIAL_CANDIDATO        BIGINT              -- JOINable column
) WITH
(
    OIDS=FALSE
);
ALTER TABLE mesa_diretora OWNER TO augusto;

-- map_ementa_candidato
DROP TABLE IF EXISTS map_ementa_candidato;
CREATE TABLE map_ementa_candidato
(
    EMENTA_ID                   VARCHAR(200) NOT NULL,      -- JOINable column
    PUBLISHED_DATE              TIMESTAMP without time zone NOT NULL,
    SEQUENCIAL_CANDIDATO        BIGINT                      -- JOINable column
) WITH
(
    OIDS=FALSE
);
ALTER TABLE mesa_diretora OWNER TO augusto;

-- map_proponent_candidato
DROP TABLE IF EXISTS map_proponent_candidato;
CREATE TABLE map_proponent_candidato
(
    ANO_ELEICAO                 INTEGER,
    PROPONENT                   TEXT,
    NOME_CANDIDATO              TEXT,
    SEQUENCIAL_CANDIDATO        BIGINT              -- JOINable column
) WITH
(
    OIDS=FALSE
);
ALTER TABLE mesa_diretora OWNER TO augusto;
