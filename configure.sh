#!/bin/bash
set -e
PROFILE_NAME=hyperdx
CLUSTER_NAME=hyperdx
REGION=ap-northeast-2
LAUNCH_TYPE=FARGATE
ecs-cli configure profile --profile-name "$PROFILE_NAME" --access-key "$AWS_ACCESS_KEY_ID" --secret-key "$AWS_SECRET_ACCESS_KEY"
ecs-cli configure --cluster "$CLUSTER_NAME" --default-launch-type "$LAUNCH_TYPE" --region "$REGION" --config-name "$PROFILE_NAME"

# https://aws.amazon.com/ko/blogs/containers/deploy-applications-on-amazon-ecs-using-docker-compose/
HYPERDX_FRONTEND_URL=https://hyperdx.seoltab.com HYPERDX_FRONTEND_PORT=443 ecs-cli compose --project-name hyperdx --file docker-compose.yml --region ap-northeast-2 --ecs-params ecs-params.yml create --launch-type FARGATE --create-log-groups

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_definition_parameters.html
aws ecs create-service --service-name hyperdx --cluster hyperdx --cli-input-json file://service-definition.json
