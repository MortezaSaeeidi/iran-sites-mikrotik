#!/usr/bin/env bash
# Builds iran-ip.rsc (MikroTik address-list of Iran IPv4 ranges) from ipverse/country-ip-blocks
set -euo pipefail
LIST="${IP_LIST:-iran-ipv4}"
SRC="https://raw.githubusercontent.com/ipverse/country-ip-blocks/master/country/ir/ipv4-aggregated.txt"

curl -sfL --retry 3 "$SRC" -o ip-raw.txt
tr -d '\r' < ip-raw.txt | grep -E '^[0-9]{1,3}(\.[0-9]{1,3}){3}/[0-9]{1,2}$' | sort -u > ip-clean.txt
N=$(wc -l < ip-clean.txt)
echo "valid CIDR entries: $N"
[ "$N" -gt 500 ] || { echo "IP list looks wrong ($N entries)"; exit 1; }

{
  echo "/ip firewall address-list"
  awk -v l="$LIST" '{printf "add list=%s address=%s comment=iran-ip\n",l,$1}' ip-clean.txt
} > iran-ip.rsc
rm -f ip-raw.txt ip-clean.txt
wc -l iran-ip.rsc
