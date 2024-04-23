#!/bin/bash

set -eo pipefail

# shellcheck source=builds/proj/proj.sh
source "$(dirname "$0")/proj.sh"
deploy_proj "9.4.0"
