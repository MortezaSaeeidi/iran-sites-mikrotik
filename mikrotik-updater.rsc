# Edit URL (YOUR file: iran-ir.rsc = light, iran-full.rsc = all domains)
/system script add name=update-iran-domains policy=read,write,test,policy,ftp source={
  :local url "https://raw.githubusercontent.com/MortezaSaeeidi/iran-sites-mikrotik/main/iran-ir.rsc"
  :do {
    /tool fetch url=$url dst-path=iran-domains.rsc mode=https check-certificate=no
    :delay 3s
    /ip dns static remove [find comment="iran-domains"]
    /import file-name=iran-domains.rsc
    /ip dns cache flush
    :log info "iran-domains updated"
  } on-error={ :log error "iran-domains update failed" }
}
/system scheduler add name=update-iran-domains interval=1d start-time=04:00:00 on-event="/system script run update-iran-domains"
