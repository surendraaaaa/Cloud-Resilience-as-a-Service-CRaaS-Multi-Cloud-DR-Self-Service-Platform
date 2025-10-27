import os
import boto3
from azure.storage.blob import BlobServiceClient, BlobClient

# Initialize AWS S3 client
s3_client = boto3.client('s3')

# Get environment variables
AZURE_STORAGE_CONNECTION_STRING = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
AZURE_CONTAINER_NAME = os.getenv('AZURE_CONTAINER_NAME')

if not AZURE_STORAGE_CONNECTION_STRING or not AZURE_CONTAINER_NAME:
    raise ValueError("Environment variables AZURE_STORAGE_CONNECTION_STRING and AZURE_CONTAINER_NAME must be set.")

    # Initialize Azure Blob client
    blob_service_client = BlobServiceClient.from_connection_string(AZURE_STORAGE_CONNECTION_STRING)

    def lambda_handler(event, context):
        print("Event received:", event)

            for record in event.get('Records', []):
                    bucket_name = record['s3']['bucket']['name']
                            object_key = record['s3']['object']['key']

                                    print(f"Processing file: s3://{bucket_name}/{object_key}")

                                            # Prepare temporary download path
                                                    safe_filename = object_key.replace('/', '_')
                                                            download_path = f"/tmp/{safe_filename}"

                                                                    # Download file from S3
                                                                            try:
                                                                                        s3_client.download_file(bucket_name, object_key, download_path)
                                                                                                    print(f"Downloaded {object_key} from S3 to {download_path}")
                                                                                                            except Exception as e:
                                                                                                                        print(f"Failed to download {object_key} from S3: {e}")
                                                                                                                                    continue

                                                                                                                                            # Upload to Azure Blob Storage
                                                                                                                                                    try:
                                                                                                                                                                blob_client = blob_service_client.get_blob_client(container=AZURE_CONTAINER_NAME, blob=object_key)
                                                                                                                                                                            with open(download_path, "rb") as data:
                                                                                                                                                                                            blob_client.upload_blob(data, overwrite=True)
                                                                                                                                                                                                        print(f"Uploaded {object_key} to Azure Blob Storage container {AZURE_CONTAINER_NAME}")
                                                                                                                                                                                                                except Exception as e:
                                                                                                                                                                                                                            print(f"Failed to upload {object_key} to Azure: {e}")
                                                                                                                                                                                                                                        continue

                                                                                                                                                                                                                                            return {"statusCode": 200, "body": "S3 to Azure sync complete."}
                                                                                                                                                                                                                                            