#!/usr/bin/env bash

cd $(dirname $0)

APP_NAME="leXoR"
BRANCH_NAME="branch"

APP_ID=`aws amplify list-apps | jq '.apps[] | select(.name == "'$APP_NAME'") | .appId' | xargs`

if [[ -n $APP_ID ]] 
then
  echo "Recreating App"
  aws amplify delete-app --app-id $APP_ID | jq
  APP_ID=`aws amplify create-app --name $APP_NAME | jq '.app.appId' | xargs`
else
  echo "App doesn't exist"
  APP_ID=`aws amplify create-app --name $APP_NAME | jq '.app.appId' | xargs`
fi

echo "APP_ID: $APP_ID"
BRANCH_EXIST=`aws amplify list-branches --app-id $APP_ID | jq '.branches[] | select(.branchName == "'$BRANCH_NAME'")' | xargs`
echo $BRANCH_EXIST

if [[ -n $BRANCH_EXIST ]]
then
  echo "Branch exist"
else
  echo "Branch doesn't exist"
  aws amplify create-branch --app-id $APP_ID --branch-name $BRANCH_NAME | jq
fi

ZIP_UPLOAD_URL=`aws amplify create-deployment --app-id $APP_ID --branch-name $BRANCH_NAME | jq '.zipUploadUrl' | tr -d \"`
JOB_ID=`aws amplify list-jobs --app-id $APP_ID --branch-name $BRANCH_NAME | jq '.jobSummaries[] | select(.status == "PENDING") | .jobId' | tr -d \"`

echo "Uploading to $ZIP_UPLOAD_URL"
curl -X PUT -T "website.zip" $ZIP_UPLOAD_URL

aws amplify start-deployment --app-id $APP_ID --branch-name $BRANCH_NAME --job-id $JOB_ID | jq

DOMAIN=`aws amplify get-app --app-id $APP_ID | jq '.app.defaultDomain' | xargs`

echo "App deployed to https://$BRANCH_NAME.$DOMAIN"
