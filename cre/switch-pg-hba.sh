# '' => exit
if [ -z "$1" ]; then
    echo "[FAIL]: no pg_hba argument given!"
    exit 1
fi

switchMode="$1" 

configFile=$(find /cre/glue -name "*_pg_hba.conf" -print -quit)
openFile=$(find /cre/glue -name "*_pg_hba.conf.open" -print -quit)
tmpOpen="$openFile.temporary"
closeFile=$(find /cre/glue -name "*_pg_hba.conf.close" -print -quit)
## tmplFile=$(find /cre/glue -name "*_pg_hba.conf.tmpl" -print -quit)

#echo "s: $switchMode c: $configFile o: $openFile c: $closeFile t: $tmplFile"

if [[ "$switchMode" = "close" ]]; then
    # copy closed file back
    cp -f $closeFile $configFile
    echo "[SUCCESS]: pg_hba gets closed."
    chmod 000 /cre/www/dumps
    exit 1
fi

octet="(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])"
ip4="^$octet\\.$octet\\.$octet\\.$octet$"

if [[ "$switchMode" =~ $ip4 ]]; then
    #copy and modify open file
    cp -f $openFile $tmpOpen
    changeLines=$(grep "10.255.255.255/24" $openFile)
    while IFS= read -r oldLine; do
      newLine=$(sed -e "s/10.255.255.255/${switchMode}/g" <<< $oldLine)
      newLine=$(sed -e "s/#hostssl/hostssl/g" <<< $newLine)
      #sed -i 's/'"$oldLine"'/'"$newLine"'/1' $openFile2  ## / not working, as they part of replacement
      sed -i 's+'"$oldLine"'+'"$newLine"'+1' $tmpOpen
    done <<< "$changeLines"
    cp -f $tmpOpen $configFile
    echo "[SUCCESS]: pg_hba gets opened."
    chmod 666 /cre/www/dumps
    exit 1
fi

echo "[FAIL]: wrong pg_hba argument given!"





