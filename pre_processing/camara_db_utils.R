library(RPostgreSQL)

camara_db <- NULL

StartCamaraDB <- function(){
    if (is.null(camara_db)) {
        postgres_user <- Sys.getenv("POSTGRES_USER")
        postgres_pass <- Sys.getenv("POSTGRES_PASS")
        camara_db <<- src_postgres(dbname = "camara_db", user = postgres_user, password = postgres_pass)
    }
    camara_db
}
