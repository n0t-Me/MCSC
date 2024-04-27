#!/bin/bash

# Yep creds are pushed with the repo, bcuz learner lab change it every 4 hours
mkdir ~/.aws
cp creds ~/.aws/credentials

aws configure set region us-east-1
