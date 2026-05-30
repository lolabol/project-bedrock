import json
import logging
import urllib.parse

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(
            record['s3']['object']['key'],
            encoding='utf-8'
        )
        logger.info(f"Image received: {key}")
        print(f"Image received: {key}")
        print(f"Bucket: {bucket}")
        print(f"File size: {record['s3']['object']['size']} bytes")
    
    return {
        'statusCode': 200,
        'body': json.dumps('File processed successfully')
    }
