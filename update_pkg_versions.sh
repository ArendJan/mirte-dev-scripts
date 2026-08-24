#!/bin/bash

# Update pkg versions.


set -ex
set -o pipefail

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(realpath "$SCRIPT_DIR")

release_name="0.2.1" # dont add v to the release name!
latest=true
release_candidate=false
release_candidate_number=2
sd_image_owner="mirte-robot"

if [ "$release_candidate" = true ]; then
    release_name="${release_name}-rc${release_candidate_number}"
fi

# if latest and rc, error
if [ "$latest" = true ] && [ "$release_candidate" = true ]; then
    echo "Cannot be both latest and release candidate"
    exit 1
fi

# read repos.yaml and get the list of packages
repos_file="$SCRIPT_DIR/repos_dev.yaml"
repos_file="$SCRIPT_DIR/repos.yaml"
if [ ! -f "$repos_file" ]; then
    echo "$repos_file not found!"
    exit 1
fi

# get the list of packages from repos.yaml
packages=$(yq e '.repositories[].url' "$repos_file")
branches=$(yq e '.repositories[].version' "$repos_file")


i=1
for package in $packages; do
    branch=$(echo "$branches" | sed -n "${i}p")
    i=$((i + 1))
    echo "Processing $package on branch $branch"

    # use gh workflow list to check if the workflow exists
    workflow_exists=$(gh workflow list -R $package | grep "Update Package Version" || true)
    if [ -z "$workflow_exists" ]; then
        # echo "Workflow 'Update Package Version' does not exist in $package on branch $branch"
        continue
    fi
    echo "Workflow 'Update Package Version' exists in $package on branch $branch"
    gh workflow run "Update Package Version" -R $package -r $branch -F version="$release_name" || true
    
done

