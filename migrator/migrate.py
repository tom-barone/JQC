import sys

import mysql.connector
import pandas as pd
import psycopg2
from dotenv import dotenv_values
from mysql.connector import Error as MySQLError
from psycopg2 import Error as PostgresError
from sqlalchemy import create_engine, text

pd.set_option("future.no_silent_downcasting", True)

"""
This migrates data from the MySQL database to a new PostgreSQL database.
Does a bit of data cleansing in the process.
"""


def transfer_data(
    mysql_config, postgres_config, table_name, dtype=None, batch_size=5000
):
    mysql_conn = mysql.connector.connect(**mysql_config)
    mysql_cursor = mysql_conn.cursor()
    postgres_conn = psycopg2.connect(**postgres_config)
    postgres_cursor = postgres_conn.cursor()
    try:
        # Get total count of the rows to transfer
        mysql_cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
        total_rows = mysql_cursor.fetchone()
        if type(total_rows) != tuple:
            raise Exception("Expected a tuple result")
        if type(total_rows[0]) != int:
            raise Exception("Expected an integer value")
        total_rows = total_rows[0]
        print(
            f"Total rows to transfer from mysql.{table_name} to Postgres: {total_rows}"
        )

        # Create SQLAlchemy engines for both databases
        mysql_engine = create_engine(
            f"mysql+mysqlconnector://{mysql_config['user']}:{mysql_config['password']}@"
            f"{mysql_config['host']}:{mysql_config.get('port', 3306)}/{mysql_config['database']}"
        )
        postgres_engine = create_engine(
            f"postgresql://{postgres_config['user']}:{postgres_config['password']}@"
            f"{postgres_config['host']}:{postgres_config.get('port', 5432)}/{postgres_config['database']}"
        )

        # Delete all rows from the table first
        with postgres_engine.connect() as conn:
            conn.execute(text(f"DELETE FROM {table_name}"))
            conn.commit()

        for offset in range(0, total_rows, batch_size):
            query = f"SELECT * FROM {table_name} LIMIT {batch_size} OFFSET {offset}"
            df = pd.read_sql(query, mysql_engine, dtype=dtype)

            if df.empty:
                break

            # For the created_at and updated_at columns, if the value is NULL, set it to a fallback date
            fallback_date = pd.to_datetime("1970-01-01 00:00:00")
            df["created_at"] = df["created_at"].fillna(fallback_date)
            df["updated_at"] = df["updated_at"].fillna(fallback_date)

            # Table specific data cleaning
            if table_name == "suburbs":
                # Drop the display_name column
                df.drop(columns=["display_name"], inplace=True)
            if table_name == "applications":
                # This approach is dumb and slow but not enough for me to care
                invalid_client_ids = [
                    316,
                    528,
                    1145,
                    1563,
                    3338,
                    3352,
                    3365,
                    3401,
                    3427,
                    3925,
                    4597,
                    4621,
                    4670,
                    4785,
                    5033,
                    5786,
                    5894,
                    6332,
                    6395,
                    7141,
                    7177,
                    7379,
                    7452,
                    10709,
                    12834,
                    13079,
                    16116,
                    16247,
                    16248,
                    16331,
                    16457,
                    16488,
                    16552,
                    16720,
                    16733,
                    16885,
                    17238,
                    17239,
                    17240,
                    17242,
                    17243,
                    17244,
                    17245,
                    17249,
                    17255,
                    17256,
                    17258,
                    17259,
                    17260,
                    17261,
                    17263,
                    17265,
                    17267,
                    17268,
                    17270,
                    18287,
                    19384,
                    45138,
                    48617,
                    5861,
                    7160,
                    17246,
                    17252,
                    17271,
                    18404,
                    23300,
                    5922,
                    8881,
                    17273,
                ]

                for id in invalid_client_ids:
                    df.loc[df["applicant_id"] == id, "applicant_id"] = None
                    df.loc[df["owner_id"] == id, "owner_id"] = None
                    df.loc[df["contact_id"] == id, "contact_id"] = None
                invalid_council_ids = [
                    9,
                    23,
                    1373,
                    4682,
                    10754,
                    16285,
                    16835,
                    16902,
                    17083,
                    17348,
                    44134,
                ]
                for id in invalid_council_ids:
                    df.loc[df["council_id"] == id, "council_id"] = None

            # Write batch to PostgreSQL
            try:
                df.to_sql(
                    table_name,
                    postgres_engine,
                    if_exists="append",
                    index=False,
                    method="multi",
                )
            except Exception as err:
                # print only first 100 characters of the error message
                print(f"Error writing data to PostgreSQL: {str(err)[:200]}")
                sys.exit(1)

            print(
                f"{table_name}: Transferred rows {offset} to {min(offset + batch_size, total_rows)}"
            )

        print("Data transfer completed successfully!")

        # Reset primary key sequences for the table
        with postgres_engine.connect() as conn:
            conn.execute(
                text(
                    f"SELECT setval(pg_get_serial_sequence('{table_name}', 'id'), coalesce(max(id)+1, 1), false) FROM {table_name}"
                )
            )
            conn.commit()

    except MySQLError as mysql_err:
        print(f"MySQL Error: {mysql_err}")
        sys.exit(1)
    except PostgresError as pg_err:
        print(f"PostgreSQL Error: {pg_err}")
        sys.exit(1)
    except Exception as err:
        print(f"Error: {err}")
        sys.exit(1)
    finally:
        # Close all connections
        mysql_cursor.close()
        mysql_conn.close()
        postgres_cursor.close()
        postgres_conn.close()


if __name__ == "__main__":
    config = dotenv_values(".env")
    mysql_config = {
        "host": config["MYSQL_HOST"],
        "user": config["MYSQL_USER"],
        "password": config["MYSQL_PASSWORD"],
        "database": config["MYSQL_DATABASE"],
    }
    postgres_config = {
        "host": config["POSTGRES_HOST"],
        "user": config["POSTGRES_USER"],
        "password": config["POSTGRES_PASSWORD"],
        "database": config["POSTGRES_DATABASE"],
    }

    # Start the transfer
    transfer_data(mysql_config, postgres_config, "suburbs")
    transfer_data(mysql_config, postgres_config, "clients", dtype={"bad_payer": bool})
    transfer_data(mysql_config, postgres_config, "councils")
    transfer_data(mysql_config, postgres_config, "application_types")
    transfer_data(
        mysql_config,
        postgres_config,
        "applications",
        dtype={
            "cancelled": bool,
            "electronic_lodgement": bool,
            "engagement_form": bool,
            "fully_invoiced": bool,
        },
    )
    transfer_data(mysql_config, postgres_config, "application_additional_informations")
    transfer_data(mysql_config, postgres_config, "application_uploads")
    transfer_data(mysql_config, postgres_config, "invoices", dtype={"paid": bool})
    transfer_data(mysql_config, postgres_config, "request_for_informations")
    transfer_data(mysql_config, postgres_config, "stages")
