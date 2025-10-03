import sys
import os

# Add src to Python path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))

from src.image_processor import handler

# Test the lambda
if __name__ == "__main__":
    test_event = {
        "exchangeRate": "3.6",
        "buyPrice": "3.5",
        "sellPrice": "3.7"
    }
    
    class MockContext:
        def __init__(self):
            self.function_name = "test-function"
            self.memory_limit_in_mb = 128
            self.invoked_function_arn = "test-arn"
            self.aws_request_id = "test-request-id"
    
    result = handler(test_event, MockContext())
    print("Result:", result)