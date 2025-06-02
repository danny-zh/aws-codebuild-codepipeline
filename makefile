.PHONY: deploy

APP_NAME=test
GRP_NAME=test-group
S3_BUCKET=<>
DEPLOY_METHOD=CodeDeployDefault.OneAtATime
EC2_TAG=CodeDeployDemo
ARN_CODEDEPLOY_ROLE=<>
CODEBUILD_ZIP=${APP_NAME}-cb.zip
CODEDEPLOY_ZIP=${APP_NAME}-cd.zip
BUILD_KEY=build/${CODEBUILD_ZIP}
DEPLOY_KEY=deploy/${CODEDEPLOY_ZIP}

package-codebuild:
	zip ${CODEBUILD_ZIP} buildspec.yml Dockerfile 

package-codedeploy:
	zip -r ${CODEDEPLOY_ZIP} appspec.yml scripts 

package: package-codebuild package-codedeploy
	aws s3 cp ${CODEBUILD_ZIP} s3://${S3_BUCKET}/${BUILD_KEY}
	aws s3 cp ${CODEDEPLOY_ZIP} s3://${S3_BUCKET}/${DEPLOY_KEY}

deploy: package
	chmod +x scripts/*

	aws deploy create-application --application-name ${APP_NAME}

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
	--s3-location bucket=${S3_BUCKET},bundleType=zip,key=${DEPLOY_KEY}

destroy:
	aws deploy delete-deployment-group --application-name ${APP_NAME} --deployment-group-name ${GRP_NAME}
	aws deploy delete-application --application-name ${APP_NAME}
	aws s3 rm s3://${S3_BUCKET}/${BUILD_KEY}
	aws s3 rm s3://${S3_BUCKET}/${DEPLOY_KEY}
	rm -f ${CODEBUILD_ZIP} ${CODEDEPLOY_ZIP}
	echo "Deployment group and application deleted, S3 files removed, local zip files cleaned up."