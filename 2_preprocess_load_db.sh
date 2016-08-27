#!/bin/bash

# -----------------------------------------------------------------------------
# Pre-Processing (run on demand only)
# -----------------------------------------------------------------------------
# TSE Tables
Rscript pre_processing/parse_tse_data.R

# Auxiliar Tables (they may require a MANUAL to map the ano_eleicao,proponent to ano_eleicao,sequencial_candidato)
Rscript pre_processing/map_proponents_to_candidatos.R

# -----------------------------------------------------------------------------
# DB Creation and LOAD
# -----------------------------------------------------------------------------
# Create the Tables
psql -U augusto -d camara_db -a -f db_scripts/create_other_tables.sql

# Load the Tables
psql -U augusto -d camara_db -a -f db_scripts/load_other_tables.sql
