#!/bin/bash

docker tag marli quay.io/nyulibraries/marli:${CIRCLE_BRANCH//\//_}
docker tag marli quay.io/nyulibraries/marli:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker tag marli quay.io/nyulibraries/marli:latest
docker tag marli_test quay.io/nyulibraries/marli_test:${CIRCLE_BRANCH//\//_}
docker tag marli_test quay.io/nyulibraries/marli_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker tag marli_test quay.io/nyulibraries/marli_test:latest
docker push quay.io/nyulibraries/marli:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/marli:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push quay.io/nyulibraries/marli:latest
docker push quay.io/nyulibraries/marli_test:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/marli_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}
docker push quay.io/nyulibraries/marli_test:latest