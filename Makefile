# 諸々設定
PROJECT_ID =
IMAGE =
GOOGLE_APPLICATION_CREDENTIALS=

local-run:
	pipenv shell python src/app.py

test :
	pipenv shell pytest

test-coverage:
	pipenv shell pytest --cov=src tests/ --cov-report html

test-lint-fix:
	pipenv shell autopep8 src --recursive --in-place --pep8-passes 2000 --verbose

test-pylint:
	pipenv shell pylint src

precommit-check:
	@make test-coverage
	@make test-lint-fix
	@make test-pylint

app-local-build:
	docker build --no-cache=true -t gcr.io/$(PROJECT_ID)/$(IMAGE) .

app-local-run:
	docker run gcr.io/$(PROJECT_ID)/$(IMAGE)

gcloud-app-build-submit:
	gcloud config set project $(PROJECT_ID)
	gcloud builds submit --tag gcr.io/$(PROJECT_ID)/$(IMAGE)

# gcloud-app-build-submitでコンテナをビルドしてから実行 リージョン東京 サービス名はtest
gcloud-app-test-deploy:
	gcloud config set project $(PROJECT_ID)
	gcloud beta run deploy --image gcr.io/$(PROJECT_ID)/$(IMAGE) --platform managed \
	--set-env-vars APP_ENV=test,PROJECT_ID=$(PROJECT_ID),CREDENTIAL_FILE=credentials.json,GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}

# gcloud-app-build-submitでコンテナをビルドしてから実行 リージョン東京
gcloud-app-production-deploy:
	gcloud config set project $(PROJECT_ID)
	gcloud beta run deploy --image gcr.io/$(PROJECT_ID)/$(IMAGE) --platform managed \
	--set-env-vars APP_ENV=prod,PROJECT_ID=$(PROJECT_ID),CREDENTIAL_FILE=credentials.json,GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_APPLICATION_CREDENTIALS}
