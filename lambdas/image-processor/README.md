## Step-by-Step Deployment Instructions

1. **Export dependencies**  
  Generate a `requirements.txt` file from your Poetry environment:
  ```bash
  poetry export -f requirements.txt --without-hashes -o requirements.txt
  ```

2. **Prepare build directory**  
  Create a directory to hold your Lambda package:
  ```bash
  mkdir -p build
  ```

3. **Install dependencies**  
  Install the required Python packages into the build directory:
  ```bash
  pip install -r requirements.txt -t build/
  ```

4. **Copy source files**  
  Add your Lambda function code to the build directory:
  ```bash
  rsync -av --exclude='.env' src/ build/
  ```

5. **Package the Lambda**  
  Create a zip archive of the build directory:
  ```bash
  cd build
  zip -r ../image-processor.zip .
  cd ..
  ```

Note: Add Pillow library when testing locally and remove it when building.
poetry add pillow
poetry remove pillow