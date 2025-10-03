build:
		poetry export -f requirements.txt --without-hashes -o requirements.txt
		mkdir -p build
		pip install -r requirements.txt -t build/
		rsync -av --exclude='.env' src/ build/
		cd build && zip -r ../image-processor.zip .
