#!/bin/bash

# Ask inputs
read -p "Enter GitHub Username: " USERNAME
read -p "Enter Repository Name: " REPONAME

# Initialize git
git init

# Add files
git add .

# Commit
git commit -m "Initial commit"

# Set branch
git branch -M main

# Set remote
git remote remove origin 2>/dev/null
git remote add origin git@github.com:$USERNAME/$REPONAME.git

# Push
git push -u origin main



