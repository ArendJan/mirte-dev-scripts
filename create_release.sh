#!/bin/bash

# create release of all the specified packages in repos.yaml and publish a release to sd-image tools with all the changelogs

# IMPORTANT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# RUN ./update_pkg_versions.sh first to update the versions in the packages before creating a release!
# then wait for the workflows to finish, then run this script to create the release and publish the changelogs to sd-image tools

set -ex
set -o pipefail

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(realpath "$SCRIPT_DIR")

# SETTINGS:
# edit repos.yaml to add/remove repos
release_name="0.2.1" # dont add v to the release name!
latest=true
release_candidate=false
release_candidate_number=2
sd_image_owner="mirte-robot"

skip_packages=false
skip_sd_image_tools=false
dry_run=false

#END SETTINGS

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


if [ "$skip_packages" = true ]; then
    echo "Skipping packages, only creating release in sd-image tools"
    packages=""
    branches=""
fi
all_notes=""

i=1
for package in $packages; do
    branch=$(echo "$branches" | sed -n "${i}p")
    i=$((i + 1))
    echo "Processing $package on branch $branch"
    $dry_run || gh release --repo "$package" create "$release_name" --target "$branch" --title "$release_name" --generate-notes --prerelease="$release_candidate" --latest="$latest" || true
    $dry_run || notes=$(gh release --repo "$package" view "$release_name" --json body -q .body)
    all_notes+="## Release notes for $(basename "$package")\n\n"
    all_notes+="$notes\n\n"
    sleep 5    
done

known_issues_file="$SCRIPT_DIR/known_issues.md"
known_issues=""
if [ -f "$known_issues_file" ]; then
    known_issues="$(cat "$known_issues_file")"
fi

# add download link to the top of the notes
all_notes="### [Download the latest sd-image](https://buildmirte.me.tudelft.nl/$release_name)\n\n$known_issues\n\n$all_notes"

if [ "$skip_packages" != true ]; then
    # write all notes to a file
    echo -e "$all_notes" > "$SCRIPT_DIR/all_release_notes.md"
fi

# create a release in sd-image tools with all the changelogs
sd_image_repo="https://github.com/${sd_image_owner}/mirte-sd-image-tools.git"
release_branch="main"

if [ "$skip_sd_image_tools" = true ]; then
    echo "Skipping sd-image tools release"
    exit 0
else
    $dry_run || gh release --repo "$sd_image_repo" create "$release_name" --target "$release_branch" --title "$release_name" --notes-file "$SCRIPT_DIR/all_release_notes.md" --prerelease="$release_candidate" --latest="$latest"  || true
fi