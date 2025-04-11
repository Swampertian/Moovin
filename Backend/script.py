import psycopg2
conn = psycopg2.connect(
    dbname="moovin",
    user="postgres",
    password="admin1234",
    host="localhost",
    port="5432"
)
print("Connection successful")
conn.close()