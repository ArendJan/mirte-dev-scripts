# mirte-dev-scripts

Tools for MIRTE robots.

## Create release
This will create a release in all the repos listed in repos.yaml with the version specified.

Edit the files first before running them.

First run update_pkg_versios.sh to update the package versions in mirte-ros-packages and gazebo repos

create_release.sh will create releases and finally create a release with all the release notes for mirte-sd-image-tools.

Change known_issues.md to list known issues or any other message that should be at the top of the sd-img release.

The sd-image-tools workflows will also add the repos to the release and add the telemetrix uf2 to it.

After some time the release will be on the [buildmirte.me.tudelft.nl/)](https://buildmirte.me.tudelft.nl/) server.

## Rest of the scripts

Should be self-explenatory, just some helpful scripts.