# '' => exit
if [ -z "$1" ]; then
    echo "[FAIL]: no pg_hba argument given!"
    exit 1
fi

switchMode="$1" 
# 'close' => cp closeFile to tmplFile; rm -f configFile; touch tmplFile
# '<ip>'  => cp openFile to tmplFile; edit tmplFile; rm -f configFile; touch tmplFile

configFile=$(find /cre/glue -name "*_pg_hba.conf" -print -quit)
openFile=$(find /cre/glue -name "*_pg_hba.conf.open.tmpl" -print -quit)
closeFile=$(find /cre/glue -name "*_pg_hba.conf.close.tmpl" -print -quit)
tmplFile=$(find /cre/glue -name "*_pg_hba.conf.tmpl" -print -quit)

echo "s: $switchMode c: $configFile o: $openFile c: $closeFile t: $tmplFile"

if [[ "$switchMode" = "close" ]]; then
    echo "[SUCCESS]: pg_hba gets closed."
    exit 1
fi

octet="(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])"
ip4="^$octet\\.$octet\\.$octet\\.$octet$"

if [[ "$switchMode" =~ $ip4 ]]; then
    echo "[SUCCESS]: pg_hba gets opened."
    exit 1
fi

echo "[FAIL]: wrong pg_hba argument given!"





