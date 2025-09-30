import json
from .services.images_service import ImageService

def lambda_handler(event, context):
  # Example: Log the received event
  print("Received event:", json.dumps(event))

  # Your image processing logic goes here
  # Extract values from event
  exchange_rate = event.get("exchangeRate", "")
  buy_price = event.get("buyPrice", "")
  sell_price = event.get("sellPrice", "")

  # Create ImageService instance and generate image
  image_service = ImageService('dev') # Use appropriate environment prefix
  img_base64 = image_service.create_image(exchange_rate, buy_price, sell_price, save_locally=True)
  result = image_service.upload_to_s3(img_base64)

  if not result['success']:
    return {
      'statusCode': 500,
      'message': 'Failed to upload image to S3'
    }

  # Add image to response body
  response_body = {
    'statusCode': 200,
    'message': 'Image processed successfully'
  }

  # Example response
  return response_body
