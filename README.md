# CG Insights Data Generation

### Coletando dados da Câmara Campinense 
* Crie o BD com *db_script/create_ementa_table.sql*
* Realize a coleta com *1_preprocess_load_db.py* (a coleta é incremental, guarda o último dia coletado e segue daí em diante)

### Enriquecendo o Banco com dados do TSE

* Execute o *2_preprocess_load_db.sh* (antes disso requisite os dados a @augustoqm)
    - Caso deseje baixar o banco já pronto siga para o repositório ([cg-insights-data](https://github.com/augustoqm/cg-insights-data))
