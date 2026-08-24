#!/bin/bash
set -ex
repo="mirte-robot/mirte-ros-packages"
release_name="0.2.1" # dont add v to the release name!

gh release delete --repo "$repo" "$release_name" --cleanup-tag --yes