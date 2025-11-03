#!/bin/bash

# create release of all the specified packages in repos.yaml and publish a release to sd-image tools with all the changelogs


set -ex
set -o pipefail

SCRIPT_DIR=$(dirname "$0")
SCRIPT_DIR=$(realpath "$SCRIPT_DIR")

release_name="v0.2.0-rc.1"
latest=false
# read repos.yaml and get the list of packages
repos_file="$SCRIPT_DIR/repos.yaml"

if [ ! -f "$repos_file" ]; then
    echo "repos.yaml not found!"
    exit 1
fi

# get the list of packages from repos.yaml
packages=$(yq e '.repositories[].url' "$repos_file")
branches=$(yq e '.repositories[].version' "$repos_file")

all_notes=""

i=1
for package in $packages; do
    branch=$(echo "$branches" | sed -n "${i}p")
    i=$((i + 1))
    echo "Processing $package on branch $branch"
    # gh release --repo "$package" create "$release_name" --target "$branch" --title "$release_name" --generate-notes --latest="$latest" || true
    notes=$(gh release --repo "$package" view "$release_name" --json body -q .body)
    all_notes+="## Release notes for $(basename "$package")\n\n"
    all_notes+="$notes\n\n"
done
# exit 0

# add download link to the top of the notes
all_notes="### [Download the latest sd-image](https://surfdrive.surf.nl/s/193nJP6OkYzHds0)\n\n$all_notes"

# write all notes to a file
echo -e "$all_notes" > "$SCRIPT_DIR/all_release_notes.md"

# create a release in sd-image tools with all the changelogs
sd_image_repo="https://github.com/mirte-robot/mirte-sd-image-tools.git"
release_branch="main"

gh release --repo "$sd_image_repo" create "$release_name" --target "$release_branch" --title "$release_name" --notes-file "$SCRIPT_DIR/all_release_notes.md" --prerelease || true