from PIL import Image, ImageDraw, ImageFont
import io
import base64
import boto3
from datetime import datetime

class ImageService:
  def __init__(self, prefix_env):
    self.prefix_env = prefix_env
    self.bucket_name = f"rate-currency-tracker-images-{self.prefix_env}"

  def load_font(self, size):
    try:
        # Try system fonts first
        font_paths = [
            "/System/Library/Fonts/Helvetica.ttc",  # macOS
            "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",  # Linux
        ]
        for path in font_paths:
            try:
                return ImageFont.truetype(path, size)
            except:
                continue
    except:
        pass
  
    # Fallback with larger default size
    return ImageFont.load_default()

  def create_image(self, exchange_rate, buy_price, sell_price, save_locally=False) -> bytes:
    img_width, img_height = 800, 400
    image = Image.new("RGB", (img_width, img_height), color=(33, 33, 33))

    draw = ImageDraw.Draw(image)

    # Draw title
    draw.text((220, 50), "Exchange Rate", font=self.load_font(50), fill=(245, 245, 245))

    # Draw exchange rate, buy price, sell price
    draw.text((40, 150), f"Rate: {exchange_rate} USD ", font=self.load_font(40), fill=(255, 255, 255))
    draw.text((40, 210), f"Buy: {buy_price} USD", font=self.load_font(40), fill=(144, 238, 144))
    draw.text((40, 270), f"Sell: {sell_price} USD", font=self.load_font(40), fill=(255, 99, 71))

    # Save image to bytes
    img_bytes = io.BytesIO()
    image.save(img_bytes, format='JPEG')
    img_bytes.seek(0)
    img_base64 = base64.b64encode(img_bytes.read())

    # Save the image locally as JPG
    if save_locally:
      with open("output_image.jpg", "wb") as f:
        f.write(base64.b64decode(img_base64))

    return img_base64

  def upload_to_s3(self, image_base64, image_name=None):
    """
    Upload base64 encoded image to S3
    
    Args:
        image_base64 (str): Base64 encoded image string
        image_name (str, optional): Name for the S3 object. If None, generates timestamp-based name
    
    Returns:
        dict: Upload result with S3 URL and metadata
    """
    self.s3_client = boto3.client('s3')
    try:
        # Generate image name if not provided
        if not image_name:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            image_name = f"exchange_rate_{timestamp}.jpg"
        
        # Decode base64 to bytes for upload
        image_data = base64.b64decode(image_base64)
        
        # Upload to S3
        self.s3_client.put_object(
            Bucket=self.bucket_name, 
            Key=image_name, 
            Body=image_data,  # Use decoded bytes, not base64 string
            ContentType='image/jpeg'
        )
        
        # Generate S3 URL
        s3_url = f"https://{self.bucket_name}.s3.amazonaws.com/{image_name}"
        
        print(f"Image uploaded successfully to S3 bucket {self.bucket_name} with key {image_name}")
        
        return {
            'success': True,
            'url': s3_url,
            'bucket': self.bucket_name,
            'key': image_name
        }
        
    except Exception as e:
        print(f"Error uploading to S3: {str(e)}")
        return {
            'success': False,
            'error': str(e)
        }
