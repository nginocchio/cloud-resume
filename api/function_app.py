import os
import json
from azure.data.tables import TableServiceClient, UpdateMode
import azure.functions as func
import logging

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

client = TableServiceClient.from_connection_string(
    conn_str = os.environ["COSMOS_CONNECTION_STRING"]
)
table = client.get_table_client("VisitorCount")
PARTITION_KEY = "counter"
ROW_KEY = "visitors"

def get_count_entity():
    return table.get_entity(
        partition_key=PARTITION_KEY,
        row_key=ROW_KEY
    )

@app.route(route="counter", methods=["GET"])
def http_get(req: func.HttpRequest) -> func.HttpResponse:
    entity = get_count_entity()

    return func.HttpResponse(
        body=json.dumps({"count": entity["count"]}),
        mimetype="application/json",
        status_code=200,
    )

@app.route(route="counter/increment", methods=["POST"])
def http_post(req: func.HttpRequest) -> func.HttpResponse:
    entity = get_count_entity()
    entity["count"] = entity.get("count", 0) + 1

    table.update_entity(
        entity=entity,
        mode=UpdateMode.MERGE,
    )
    return func.HttpResponse(
        status_code=201
    )
