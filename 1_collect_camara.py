#!/usr/bin/python
# -*- coding: utf-8 -*-
"""
Collect all EMENTAs from the CG Camara site
"""
import time
import psycopg2
import logging
from argparse import ArgumentParser
from bs4 import BeautifulSoup
from datetime import datetime
from selenium.webdriver import PhantomJS
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

############################################################
# GLOBAL VARIABLES
############################################################
logging.basicConfig(format='%(asctime)s : %(name)s : %(message)s', level=logging.INFO)
LOGGER = logging.getLogger('Ementa Reader')
LOGGER.setLevel(logging.INFO)


############################################################
# GLOBAL CLASSES and FUNCTIONS
############################################################
class CamaraCGCrawler(object):
    """ Camara CG Ementa Crawler """

    def __init__(self, starting_year):
        self.base_url = "http://187.115.174.90:8080/ScanLexWeb"
        self.starting_year = starting_year
        self.browser = None

    @staticmethod
    def get_ementa_id(published_date, ementa_type, ementa_doc_number, ementa_situation):
        """ Return the Ementa Unique Id """
        return "%s#%s#%s#%s" % (datetime.strftime(published_date, "%Y-%m-%d"),
                                ementa_type, ementa_doc_number, ementa_situation)

    def get_all_ementas_summary(self):
        """ Yield the next ementa information row """

        browser_table = self.browser.find_element_by_id("frmMenu:tabEmentas_data")
        bs_ementa_table = BeautifulSoup(browser_table.get_attribute("innerHTML"))

        for row in bs_ementa_table.find_all("tr"):
            cols = row.find_all("td")
            if len(cols) == 6:
                published_date = datetime.strptime(cols[0].span.text.encode("utf-8"), "%d/%m/%Y")
                doc_number = int(cols[1].span.text.encode("utf-8"))
                title = cols[2].span.text.encode("utf-8")
                ementa_type = cols[3].span.text.encode("utf-8")
                ementa_situation = cols[4].span.text.encode("utf-8")
                details_js = cols[5].a['onclick'].encode("utf-8")

                if published_date > datetime.now():
                    continue

                yield published_date, doc_number, title, ementa_type, ementa_situation, details_js

    def get_ementa_details(self, ementa_details_js):
        """ Crawl the second ementa page """

        # Waiting...
        _ = WebDriverWait(self.browser, 30).until(EC.visibility_of_element_located((By.ID, "frmfuncao:j_idt13_content")))
        _ = WebDriverWait(self.browser, 30).until(EC.visibility_of_element_located((By.ID, "frmfuncao:tabProponentes")))

        # Get Ementail Details
        bs_ementa_details = BeautifulSoup(self.browser \
            .find_element_by_id("frmfuncao:j_idt13_content").get_attribute("innerHTML"))

        rows = bs_ementa_details.find_all("tr")

        source = rows[3].td.text
        main_theme = rows[7].td.text
        sys_enter_date = datetime.strptime(rows[9].td.text, "%d/%m/%Y")
        approval_date = datetime.strptime(rows[11].td.text, "%d/%m/%Y")
        process_number = int(rows[15].td.text or "-1")
        autograph_number = int(rows[19].td.text or "-1")
        process_year = int(rows[21].td.text or "-1")
        has_image = rows[23].td.text == "Sim"

        # Get Proponent names
        bs_proponent = BeautifulSoup(self.browser.
                                     find_element_by_id("frmfuncao:tabProponentes").
                                     get_attribute("innerHTML"))

        proponents = ",".join([col.text for col in bs_proponent.find_all("td")])

        return source, proponents, main_theme, sys_enter_date, approval_date, process_number, \
            autograph_number, process_year, has_image

    def next_ementa(self, select_curs):
        """ Iterate in the years onwards and collect all the ementas """

        try:
            LOGGER.info("Opening Browser")
            self.browser = PhantomJS()

            LOGGER.info("GET [%s]", self.base_url)
            self.browser.maximize_window()

            cur_year = int(datetime.now().year)

            # Define the initial collection year
            select_curs.execute("SELECT EXTRACT (YEAR FROM MAX(published_date)) FROM ementas;")
            last_exec_year = select_curs.fetchone()
            if last_exec_year:
                collection_year = max(self.starting_year, last_exec_year[0])
            else:
                collection_year = self.starting_year

            all_proponents = ["ANDERSON MAIA", "Afonso Alexandre Régis", "Alcides Cavalcante", "Alcindor Villarim", "Aldo Cabral",
                              "Alexandre do Sindicato", "Antonio Pereira", "Antônio Alves Pimentel Filho", "Aragão Júnior",
                              "Bruno Cunha Lima Branco", "Bruno Gaudêncio", "Buchada", "Cassiano Pascoal", "Cozete Babosa",
                              "Cássio Murilo Galdino de Araujo", "Daniella Ribeiro", "Dr. Nunes", "Executivo", "Fabrinni Brito",
                              "Fernando carvalho", "Francisco Dantas Lira", "Galego do Leite", "Inacio Falcao", "Ivan Batista",
                              "Ivonete Ludgerio", "Joao Dantas", "Josimar Henrique da Silva", "José Marcos Raia ", "José Ribamar",
                              "João Dantas", "Jóia Germano", "Laelson Patricio", "Lafite", "Lindaci Medeiros Nápolis", "Lourdes Costa",
                              "Lula Cabral", "Marcos Marinho", "Maria Lopes Barbosa", "Marinaldo Cardoso", "Metuselá Agra",
                              "Miguel Rodrigues da Silva", "Miguel da Construção", "Napoleão Maracajá", "Nelson Gomes Filho",
                              "Olimpio Oliveira", "Orlandino Farias", "Paulo Muniz", "Paulo de Tarso", "Peron Ribeiro Japiassú",
                              "Renato Feliciano", "Rodolfo Rodrigues", "Rodrigo Ramos Victor", "Romero Rodrigues", "Rostand Paraíba",
                              "Rômulo Gouveia", "Saulo Germano", "Saulo Noronha", "Tia Mila", "Tovar Correia Lima", "Vaninho Aragão",
                              "Veneziano Vital do rego", "Walter Brito Neto", "Todos"]

            while collection_year <= cur_year:

                for i_prop in range(len(all_proponents)):

                    ementa_prop = all_proponents[i_prop].decode("utf-8")

                    self.browser.get(self.base_url)

                    # Waiting...
                    WebDriverWait(self.browser, 30).until(EC.element_to_be_clickable((By.ID, "frmMenu:button1")))

                    LOGGER.info("Collecting Ementas from [%d][%s - %d/%d]", collection_year, ementa_prop, i_prop+1, len(all_proponents))

                    # Set Year
                    year_field = self.browser.find_element_by_id("frmMenu:ano")
                    year_field.send_keys(collection_year)

                    # Set Proponent
                    proponent_field = self.browser.find_element_by_id("frmMenu:autoridade")
                    proponent_field.send_keys(ementa_prop)

                    # Submit the form
                    self.browser.find_element_by_id("frmMenu:button1").click()

                    # Waiting...
                    # _ = WebDriverWait(self.browser, 60).until(EC.visibility_of_element_located((By.ID, "frmMenu:tabEmentas_data")))
                    time.sleep(3)

                    for published_date, document_number, title, ementa_type, ementa_situation, ementa_details_js in self.get_all_ementas_summary():
                        ementa_id = self.get_ementa_id(published_date, ementa_type, document_number, ementa_situation)

                        select_curs.execute("""
                            SELECT ementa_id
                            FROM ementas
                            WHERE ementa_id = '%s';
                            """ % ementa_id)

                        if not select_curs.fetchone():
                            # Run the details script
                            self.browser.execute_script(ementa_details_js)
                            ementa_source, proponents, main_theme, sys_enter_date, approval_date, \
                                process_number, autograph_number, process_year, has_image = self.get_ementa_details(ementa_details_js)

                            # Come back to the table page
                            self.browser.back()

                            # Waiting...
                            _ = WebDriverWait(self.browser, 60).until(EC.visibility_of_element_located((By.ID, "frmMenu:tabEmentas_data")))

                            yield ementa_id, published_date, ementa_type, document_number, title, \
                                ementa_source, proponents, ementa_situation, main_theme, sys_enter_date, \
                                approval_date, process_number, autograph_number, process_year, has_image

                LOGGER.info("DONE [%d]", collection_year)

                self.browser.back()

                collection_year += 1

        finally:
            if self.browser:
                self.browser.quit()


def insert_ementas_db(crawler, camara_db_name):
    """ Insert the NEWS into the given camara_db_name """

    conn = psycopg2.connect(database=camara_db_name, user="augusto", password="augusto_db")
    conn.autocommit = True
    select_curs = conn.cursor()
    insert_curs = conn.cursor()

    num_inserted = 0

    for ementa_id, published_date, ementa_type, document_number, title, \
            ementa_source, proponents, ementa_situation, main_theme, sys_enter_date, \
            approval_date, process_number, autograph_number, process_year, has_image in crawler.next_ementa(select_curs):
        try:
            # INSERT the EMENTA
            insert_curs.execute("""
                INSERT INTO ementas (
                        ementa_id, published_date, ementa_type, document_number, title,
                        source, proponents, situation, main_theme, approval_date,
                        process_number, autograph_number, process_year, has_image, sys_enter_date,
                        insert_time)
                VALUES (%s, %s, %s, %s, %s,
                        %s, %s, %s, %s, %s,
                        %s, %s, %s, %s, %s,
                        %s);
                """, (ementa_id, published_date, ementa_type, str(document_number), title,
                      ementa_source, proponents, ementa_situation, main_theme, approval_date,
                      str(process_number), str(autograph_number), str(process_year), has_image, sys_enter_date, datetime.now()))
            LOGGER.info("%s - %s", datetime.strftime(published_date, "%d/%m/%Y"), ementa_id)
            num_inserted += 1

            if num_inserted % 10 == 0:
                LOGGER.info("%d ementas inserted", num_inserted)

        except psycopg2.IntegrityError as e:
            LOGGER.warning(e)

    LOGGER.info("Summary")
    LOGGER.info("%d records inserted", num_inserted)

    insert_curs.close()
    conn.close()


if __name__ == "__main__":

    PARSER = ArgumentParser()
    PARSER.add_argument("-y", "--starting_year", type=int, default=2009,
                        help="The first year to collect.")
    ARGS = PARSER.parse_args()
    STARTING_YEAR = ARGS.starting_year

    CAMARA_CRAWLER = CamaraCGCrawler(starting_year=STARTING_YEAR)
    insert_ementas_db(crawler=CAMARA_CRAWLER, camara_db_name="camara_db")
