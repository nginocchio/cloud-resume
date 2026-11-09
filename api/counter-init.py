import os
from azure.data.tables import TableServiceClient
import logging

client = TableServiceClient.from_connection_string(
    conn_str = os.environ["COSMOS_CONNECTION_STRING"]
)

table = client.get_table_client("VisitorCount")
PARTITION_KEY = "counter"
ROW_KEY = "visitors"

counter_entity = {
    "RowKey": ROW_KEY,
    "PartitionKey": PARTITION_KEY,
    "count": 0
}

def init_counter():
    try:
        table.create_entity(counter_entity)
    except ResourceExistsError:
        print("Counter already exists")

if __name__ == "__main__":
    init_counter()
