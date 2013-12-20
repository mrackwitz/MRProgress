#!/bin/sh

_PATH=$PATH

which appledoc &> /dev/null
if [[ $? == 1 ]]; then
	PATH=$PATH:/usr/local/bin:/opt/local/bin
	which appledoc &> /dev/null
	if [[ $? == 1 ]]; then
		echo "Appledoc was not found. Try installing it by 'brew install appledoc'."
		exit 127
	fi
fi

appledoc \
	--project-name 'MRProgress' \
	--project-company 'Marius Rackwitz' \
	--company-id 'com.mariusrackwitz' \
	--no-warn-invalid-crossref \
	--logformat xcode \
	--output build/doc \
	--create-html \
	--keep-intermediate-files \
	--create-docset \
	--install-docset \
	--publish-docset \
	--index-desc README.md \
	--docset-bundle-id 'com.mariusrackwitz.MRProgress' \
	--docset-bundle-name 'MRProgress' \
	--docset-feed-url 'http://mrackwitz.github.io/mrackwitz/doc/com.mariusrackwitz.MRProgress.atom' \
	--docset-package-url 'com.mariusrackwitz.MRProgress' \
	--docset-publisher-name 'Marius Rackwitz'  \
	--docset-platform-family 'iOS' \
	--ignore build \
	--ignore Example \
	--ignore pages \
	.

PATH=$_PATH
