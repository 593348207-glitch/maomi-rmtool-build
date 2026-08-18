#!/bin/bash
set -euo pipefail
: "${THEOS:?请先设置 THEOS}"
make clean package FINALPACKAGE=1
echo "DEB: $(find packages -name '*.deb' -print -quit)"
