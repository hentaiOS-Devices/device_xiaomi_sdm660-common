#!/bin/bash
#
# Copyright (C) 2018 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE_COMMON=sdm660-common
VENDOR=xiaomi

INITIAL_COPYRIGHT_YEAR=2018

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..

HELPER="$LINEAGE_ROOT"/vendor/carbon/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Initialize the common helper
setup_vendor "$DEVICE_COMMON" "$VENDOR" "$LINEAGE_ROOT" true

# Copyright headers and guards
write_headers "twolip jasmine_sprout wayne clover platina"

write_makefiles "$MY_DIR"/proprietary-files.txt true

# Finish
write_footers

if [ -s "$MY_DIR"/../$DEVICE/proprietary-files.txt ]; then
    # Reinitialize the helper for device
    INITIAL_COPYRIGHT_YEAR="$DEVICE_BRINGUP_YEAR"
    setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" false

    # Copyright headers and guards
    write_headers

    # The standard device blobs
    write_makefiles "$MY_DIR"/../$DEVICE/proprietary-files.txt true

    # We are done!
    write_footers
fi
