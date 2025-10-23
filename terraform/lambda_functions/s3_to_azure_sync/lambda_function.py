import os
import boto3
from azure.storage.blob import BlobServiceClient

s3_client = boto3.client('s3')

AZURE_STORAGE_CONNECTION_STRING = os.getenv('AZURE_STORAGE_CONNECTION_STRING')

blob_service_client = BlobServiceClient.from_connection_string(AZURE_STORAGE_CONNECTION_STRING)

def lambda_handler(event, context):
    print("Event received:", event)

    for record in event['Records']:
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']

        print(f"Processing file: s3://{bucket_name}/{object_key}")

        # Download file from S3 to /tmp (Lambda tmp space)
        download_path = f"/tmp/{object_key.replace('/', '_')}"
        s3_client.download_file(bucket_name, object_key, download_path)

        # Upload to Azure Blob Storage
        container_name = 'your-container-name'  # replace with your container or pass via env variable
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=object_key)

        with open(download_path, "rb") as data:
            blob_client.upload_blob(data, overwrite=True)

        print(f"Uploaded {object_key} to Azure Blob Storage container {container_name}")

    return {"statusCode": 200, "body": "Sync complete"}
