#!/usr/bin/env bash
# Usage: DNS_IP=178.22.122.100 ./scripts/build.sh
# Builds MikroTik .rsc files from bootmortis/iran-hosted-domains domains.txt
set -euo pipefail
DNS_IP="${DNS_IP:-178.22.122.100}"
LIST="${LIST:-iran-sites}"
SRC="https://github.com/bootmortis/iran-hosted-domains/releases/latest/download/domains.txt"

curl -sfL --retry 3 "$SRC" -o domains.txt
tr -d '\r' < domains.txt | grep -E '^[A-Za-z0-9.-]+$' | sort -u > clean.txt
[ "$(wc -l < clean.txt)" -gt 1000 ] || { echo "domains.txt looks wrong"; exit 1; }

# Light: all .ir domains with a single regexp rule (small, safe for any router)
{
  echo "/ip dns static"
  echo "add regexp=\".*\\\\.ir\$\" type=FWD forward-to=$DNS_IP address-list=$LIST comment=iran-domains"
} > iran-ir.rsc

# Full: light + every non-.ir domain (tens of thousands of entries; needs lots of RAM)
{
  cat iran-ir.rsc
  grep -v '\.ir$' clean.txt | awk -v dns="$DNS_IP" -v l="$LIST" \
    '{printf "add name=%s type=FWD match-subdomain=yes forward-to=%s address-list=%s comment=iran-domains\n",$1,dns,l}'
} > iran-full.rsc

rm -f domains.txt clean.txt
wc -l iran-ir.rsc iran-full.rsc
