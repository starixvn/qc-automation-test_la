import pyodbc

# def connect_db():
#     conn = pyodbc.connect(
#         "DRIVER={ODBC Driver 17 for SQL Server};"
#         "SERVER=TESTDB053;"
#         "DATABASE=bodb_LicenseeReport;"
#         "Trusted_Connection=yes;"
#     )
#     return conn

# def execute_sql_file(file_path):
#     conn = connect_db()
#     cursor = conn.cursor()
#     with open(file_path, "r", encoding="utf-8") as file:
#         sql_script = file.read()
#     cursor.execute(sql_script)
#     conn.commit()
#     cursor.close()
#     conn.close()

def connect_db(server, database):
    conn = pyodbc.connect(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={server};"
        f"DATABASE={database};"
        "Trusted_Connection=yes;"
    )
    return conn

def execute_sql_file(file_path, server, database):
    conn = connect_db(server, database)
    cursor = conn.cursor()
    with open(file_path, "r", encoding="utf-8") as file:
        sql_script = file.read()
    cursor.execute(sql_script)
    conn.commit()
    cursor.close()
    conn.close()
