#!/usr/bin/env sh

cd $(dirname $0)

ACC_ID=976964122004
ECR_URI=$ACC_ID.dkr.ecr.us-east-1.amazonaws.com

aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_URI

#for i in `find -mindepth 1 -maxdepth 1 -type d`; do
for i in `ls -t1 | grep -v .sh`; do
  repo=`echo $i | cut -d / -f2`
  echo "Working on $repo"
  #./$repo/build.sh 
  docker build -t $repo $repo/
  docker tag $repo $ECR_URI/$repo
  docker push $ECR_URI/$repo
done
