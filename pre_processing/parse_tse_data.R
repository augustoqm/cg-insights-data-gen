rm(list = ls())

library(readr)
library(dplyr)
library(stringr)
library(magrittr)

# =============================================================================
# FUNCTIONS
# =============================================================================

ParseFileAllYears <- function(file_dir, file_pattern, out_file){
    ReadFileAllYears <- function(file_dir, file_pattern){
        txt_files <- list.files(file_dir, pattern = file_pattern, full.names = T)
        result <- NULL
        for (f in txt_files) {
            new_df <- read.csv2(f, header = F, fileEncoding = "latin1", quote = "", stringsAsFactors = F)
            # Fixing CONSULTA_CAND differences
            if (str_detect(f, "consulta_cand_2008_PB.txt$")) {
                # Append missing columns (CODIGO_COR_RACA - 36th, DESCRICAO_COR_RACA - 37th and NM_EMAIL - 44th column)
                new_df1 <- new_df[,1:35]
                new_df2 <- new_df[,36:43]
                new_df1$V36 <- ""
                new_df1$V37 <- ""
                new_df2$V44 <- ""
                new_df <- cbind(new_df1, new_df2)
                colnames(new_df) <- paste0("V", 1:ncol(new_df))
                rm(new_df1, new_df2)
            }
            if (str_detect(f, "consulta_cand_2012_PB.txt$")) {
                # Append missing columns (CODIGO_COR_RACA - 36th and DESCRICAO_COR_RACA - 37th)
                new_df1 <- new_df[,1:35]
                new_df2 <- new_df[,36:43]
                new_df1$V36 <- ""
                new_df1$V37 <- ""
                new_df2$V44 <- ""
                new_df <- cbind(new_df1, new_df2)
                colnames(new_df) <- paste0("V", 1:ncol(new_df))
                rm(new_df1, new_df2)
            }

            result <- rbind(result, new_df)
        }
        for (col in colnames(result)) {
            result[,col] <- str_sub(result[,col], 2, -2) %>%
                gsub("\"", "\"\"", .)
        }

        if (file_pattern == 'perfil_eleitor_secao_.*_PB.txt') {
            # Select the CG records only
            result <- filter(result, V6 == 'CAMPINA GRANDE')
        }

        result
    }

    if (!file.exists(out_file)) {
        df <- ReadFileAllYears(file_dir, file_pattern)
        write_csv(df, path = out_file, col_names = F, na = "")
    }
}

# =============================================================================
# MAIN
# =============================================================================
input_dir <- "data/repositorio_eleitoral_PB"
output_dir <- "data/parsed_data"
dir.create(output_dir, showWarnings = F, recursive = T)

# -----------------------------------------------------------------------------
# BEM_CANDIDATO
# -----------------------------------------------------------------------------
cat("Parsing BEM_CANDIDATO...\n")
bem_file <- paste0(output_dir, "/candidatos_bem-candidato.csv")
ParseFileAllYears(paste0(input_dir, "/candidatos"), "bem_candidato_.*_PB.txt", bem_file)

# -----------------------------------------------------------------------------
# CONSULTA_CAND
# -----------------------------------------------------------------------------
cat("Parsing CONSULTA_CAND...\n")
cand_file <- paste0(output_dir, "/candidatos_consulta-cand.csv")
ParseFileAllYears(paste0(input_dir, "/candidatos"), "consulta_cand_.*_PB.txt", cand_file)

# -----------------------------------------------------------------------------
# CONSULTA_LEGENDAS
# -----------------------------------------------------------------------------
cat("Parsing CONSULTA_LEGENDAS...\n")
leg_file <- paste0(output_dir, "/candidatos_consulta-legendas.csv")
ParseFileAllYears(paste0(input_dir, "/candidatos"), "consulta_legendas_.*_PB.txt", leg_file)

# -----------------------------------------------------------------------------
# CONSULTA_VAGAS
# -----------------------------------------------------------------------------
cat("Parsing CONSULTA_VAGAS...\n")
vagas_file <- paste0(output_dir, "/candidatos_consulta-vagas.csv")
ParseFileAllYears(paste0(input_dir, "/candidatos"), "consulta_vagas_.*_PB.txt", vagas_file)

# -----------------------------------------------------------------------------
# PERFIL_ELEITOR_SECAO
# -----------------------------------------------------------------------------
cat("Parsing PERFIL_ELEITOR_SECAO...\n")
eleitor_file <- paste0(output_dir, "/eleitorado_perfil-eleitor-secao.csv")
ParseFileAllYears(paste0(input_dir, "/eleitorado"), "perfil_eleitor_secao_.*_PB.txt", eleitor_file)

# -----------------------------------------------------------------------------
# VOTACAO_CANDIDATO_MUN_ZONA
# -----------------------------------------------------------------------------
cat("Parsing VOTACAO_CANDIDATO_MUN_ZONA...\n")
resultado_file <- paste0(output_dir, "/resultados_votacao-candidato-mun-zona.csv")
ParseFileAllYears(paste0(input_dir, "/resultados"), "votacao_candidato_munzona_.*_PB.txt", resultado_file)

cat("Parsing DONE!\n")
