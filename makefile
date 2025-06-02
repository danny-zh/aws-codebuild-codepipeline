.PHONY: deploy

APP_NAME=<>
GRP_NAME=<>
S3_BUCKET=<>
DEPLOY_METHOD=<>
EC2_TAG=<>
ARN_CODEDEPLOY_ROLE=<>

deploy:
	chmod +x scripts/*

	aws deploy create-application --application-name ${APP_NAME}

	aws deploy push \
	--application-name ${APP_NAME} \
	--s3-location s3://${S3_BUCKET}/${APP_NAME}.zip \
	--ignore-hidden-files

	aws deploy create-deployment-group \
	--application-name ${APP_NAME} \
	--deployment-group-name ${GRP_NAME} \
	--deployment-config-name ${DEPLOY_METHOD} \
	--ec2-tag-filters Key=Name,Value=${EC2_TAG},Type=KEY_AND_VALUE \
	--service-role-arn ${ARN_CODEDEPLOY_ROLE}

	aws deploy create-deployment \
	--application-name ${APP_NAME} \
	--deployment-group-name ${GRP_NAME} \
	--deployment-config-name ${DEPLOY_METHOD} \
	--s3-location bucket=${S3_BUCKET},bundleType=zip,key=${APP_NAME}.zip