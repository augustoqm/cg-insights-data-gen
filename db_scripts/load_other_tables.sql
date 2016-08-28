-- ========================
-- COPY AUXILIAR TABLES
-- ========================
\copy comissoes_tecnicas from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/camara-cg_comissoes-tecnicas.csv' CSV;
\copy mesa_diretora from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/camara-cg_mesa-diretora.csv' CSV;
\copy map_ementa_candidato from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/camara-cg_to_candidatos_map-ementa-candidato.csv' CSV;
\copy map_proponent_candidato from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/camara-cg_to_candidatos_map-proponent-candidato.csv' CSV;

-- ========================
-- COPY TSE TABLES
-- ========================
\copy bem_candidato from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/candidatos_bem-candidato.csv' CSV;
\copy consulta_cand from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/candidatos_consulta-cand.csv' CSV;
\copy consulta_legendas from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/candidatos_consulta-legendas.csv' CSV;
\copy consulta_vagas from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/candidatos_consulta-vagas.csv' CSV;

\copy perfil_eleitor_secao from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/eleitorado_perfil-eleitor-secao.csv' CSV;

\copy votacao_candidato_mun_zona from '/home/augusto/git/cg-insights-data-gen/data/parsed_data/resultados_votacao-candidato-mun-zona.csv' CSV;
