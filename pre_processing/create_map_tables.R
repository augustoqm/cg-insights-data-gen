rm(list = ls())

library(stringi)
library(stringr)
library(dplyr)
library(readr)
source("pre_processing/camara_db_utils.R")

# =============================================================================
# SCRIPT GOALS:
# 
# MAP EMENTA_IDs to SEQUENCIAL_CANDIDATO
# ementa_id, published_date, sequencial_candidato
#
# MAP PROPONENTS to SEQUENCIAL_CANDIDATO
# ano_eleicao, proponent, nome_candidato, sequencial_candidato
# =============================================================================


out_dir <- "data/temporary_data"
dir.create(out_dir, showWarnings = F, recursive = T)

cat("Querying DB for the ementas and the candidatos...\n")
# READ CONSULTA_CAND
cand_seq <- tbl(StartCamaraDB(),
                sql("SELECT ano_eleicao, nome_candidato, sequencial_candidato, DESC_SIT_TOT_TURNO
                     FROM consulta_cand
                     WHERE DESCRICAO_UE = 'CAMPINA GRANDE' AND
                           ANO_ELEICAO in (2008, 2012) AND
                           DESC_SIT_TOT_TURNO IN ('ELEITO', 'ELEITO POR MÉDIA', 'MÉDIA', 'ELEITO POR QP', 'SUPLENTE')
                     ORDER BY ANO_ELEICAO, nome_candidato")) %>%
    collect()

write_csv(cand_seq, paste0(out_dir, "/1_cand_seq_TEMP.csv"))

# READ EMENTAS
ementas <- tbl(StartCamaraDB(), sql("SELECT * FROM ementas")) %>%
    mutate(ano_eleicao = ifelse(published_date < '2013-01-01', 2008, 2012)) %>%
    select(ementa_id, published_date, ano_eleicao, proponents) %>%
    filter(proponents != "") %>%
    arrange(ano_eleicao, proponents) %>%
    collect() %>%
    mutate(proponents = stri_trans_general(proponents, 'LATIN-ASCII') %>% str_to_lower() %>% str_replace_all("[ ]{2,}", " "))

# CREATE THE DATA FRAME: ANO_ELEICAO, PROPONENT
prop_uniq_2008 <- ementas %>% filter(ano_eleicao == 2008) %>% .$proponents %>%
    str_split(",", -1) %>% unlist() %>% str_trim() %>% unique() %>%
    sort() %>% .[. != ""] %>%
    data_frame(ano_eleicao = rep(2008, length(.)), proponent = .)

prop_uniq_2012 <- ementas %>% filter(ano_eleicao == 2012) %>% .$proponents %>%
    str_split(",", -1) %>% unlist() %>% str_trim() %>% unique() %>%
    sort() %>% .[. != ""] %>%
    data_frame(ano_eleicao = rep(2012, length(.)), proponent = .)
write_csv(bind_rows(prop_uniq_2008, prop_uniq_2012), paste0(out_dir, "/2_proponents_TEMP.csv"))

# ATTENTION!!!
# TO CREATE THE proponent_to_sequencial_cand.csv REQUIRES MANUAL INTERVENTION
# FORMAT: ANO_ELEICAO, PROPONENT, NOME_CANDIDATO, SEQUENCIAL_CANDIDATO
cat("Reading the MANUALLY generated table that maps the Proponents to Candidatos\n")
prop_cand_seq <- read_csv(paste0(out_dir, "/3_proponent_to_sequencial_cand_all_MANUAL.csv"))

# CREATE THE DATA FRAME with: EMENTA_ID, ANO_ELEICAO, PROPONENT (one by row)
all_proponents_list <- ementas$proponents %>% str_split(",", -1)
ementa_prop_final <- data_frame()
for (i in 1:length(all_proponents_list)) {
    prop_vec <- all_proponents_list[[i]]
    row <- ementas[i, c("ementa_id", "published_date", "ano_eleicao")]
    row <- row[rep(1, length(prop_vec)),]
    row$proponent <- prop_vec
    ementa_prop_final <- ementa_prop_final %>% bind_rows(row)
}
ementa_prop_final <- ementa_prop_final %>% 
    mutate(proponent = str_trim(proponent)) %>% 
    filter(proponent != "")

# Join Ementas: EMENTA_ID, PUBLISHED_DATE, ANO_ELEICAO, PROPONENT with 
#      Candidatos: ANO_ELEICAO, PROPONENT, NOME_CANDIDATO, SEQUENCIAL_CANDIDATO
ementa_id_cand_seq <- ementa_prop_final %>%
    inner_join(prop_cand_seq, by = c("ano_eleicao", "proponent")) %>%
    select(ementa_id, published_date, sequencial_candidato)

cat(length(ementa_prop_final$ementa_id %>% unique()) - length(ementa_id_cand_seq$ementa_id %>% unique()),
    "ementas were removed after joining with map_proponent_candidato table.\n")

write_csv(ementa_id_cand_seq, paste0(out_dir, "/4_ementaid_to_sequencial_cand_FINAL.csv"))

# WRINTING OUTPUTS
cat("Writing final tables to:", out_dir, "\n")
write_csv(prop_cand_seq, paste0(out_dir, "/camara-cg_to_candidatos_map-proponent-candidato.csv"), col_names = F)
write_csv(ementa_id_cand_seq, paste0(out_dir, "/camara-cg_to_candidatos_map-ementa-candidato.csv"), col_names = F)

cat("DONE!\n")

