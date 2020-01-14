#!/bin/bash
# Run tests in Jenkins environment.

pip install -e .[testing] stdeb3

# Build distro images.
python setup.py --command-packages=stdeb3.command bdist_deb
rm ./*.tar.gz
python setup.py bdist_wheel
VERSION=$(python setup.py --version)
echo "${VERSION}" > ./VERSION
if [[ -z "$BRANCH" ]]; then
    BRANCH="$(git rev-parse --abbrev-ref HEAD | sed -e 's%/%-%g')"
fi
mkdir -p build
sed\
 -e "s/VERSION/${VERSION}/g"\
 -e "s/BRANCH/${BRANCH}/g"\
  artifactory.json > build/artifactory.json
