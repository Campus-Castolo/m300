import boto3
import os
from datetime import datetime

rds = boto3.client("rds")

def lambda_handler(event, context):
    db_identifier = os.environ["RDS_INSTANCE_IDENTIFIER"]
    now = datetime.utcnow()
    snapshot_id = f"{db_identifier}-snapshot-{now.strftime('%Y%m%d-%H%M%S')}"
    timestamp_tag = now.strftime('%d %m %Y %H %M %S')

    print(f"Creating snapshot: {snapshot_id}")

    rds.create_db_snapshot(
        DBInstanceIdentifier=db_identifier,
        DBSnapshotIdentifier=snapshot_id,
        Tags=[
            {"Key": "Name", "Value": timestamp_tag},
            {"Key": "Created", "Value": timestamp_tag},
            {"Key": "Project", "Value": "m300"},
            {"Key": "Owner", "Value": "rayan"}
        ]
    )
