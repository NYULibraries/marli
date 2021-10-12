#!/bin/bash

docker pull quay.io/nyulibraries/marli:${CIRCLE_BRANCH//\//_} || docker pull quay.io/nyulibraries/marli:latest
docker pull quay.io/nyulibraries/marli_test:${CIRCLE_BRANCH//\//_} || docker pull quay.io/nyulibraries/marli_test:latest
