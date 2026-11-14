# iran-sites-mikrotik
Daily-updated MikroTik DNS-static rules (filling address-list `iran-sites`) built from
[bootmortis/iran-hosted-domains](https://github.com/bootmortis/iran-hosted-domains).

- `iran-ir.rsc`  – one regexp rule for all `.ir` domains (light, recommended)
- `iran-full.rsc` – plus all non-.ir Iranian-hosted domains (tens of thousands of rules; heavy)

Set repo variable `DNS_IP` (Settings → Variables → Actions) to your local DNS server.
Install on the router: see `mikrotik-updater.rsc`.
