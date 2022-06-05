#!/bin/bash

# Download the packages
declare -a os=( "windows" "linux" "macOS" "alpine" )
declare -a version=( 11 17 )
declare -a arch=( "x64" "aarch64" )

function download () {
    local url=$1
    wget -N $url
}

for a in "${arch[@]}"
do
    echo "# Downloads for architecture [$a]"
    for v in "${version[@]}"
    do
        echo
        echo "  ## Downloads for JDK [$v]"
        for o in "${os[@]}"
        do
            
            ext="tar.gz"
            if [ "$o" == "windows" ]; then
                ext="zip"
            fi
            
            if [ "$o" == "alpine" ] && [ "$a" == "aarch64" ]; then
                continue
            else
                # Download package
                url="https://aka.ms/download-jdk/microsoft-jdk-$v-$o-$a.$ext"
                echo "    Downloading url: $url"
                download $url
            fi
        done
    done
    echo
done

# Identify first folder/entry of the package
for i in *.{zip,tar.gz};
do
    if [ "${i: -4}" == ".zip" ]; then
        headentry=`unzip -qql $i | head -n1 | tr -s ' ' | cut -d' ' -f5-`
    else
        headentry=`tar -tf $i | head -2 | tail -1`
    fi
    testperiod=`echo $headentry | cut -d/ -f1`
    if [[ "$testperiod" == "." ]]; then
        headentry=`echo $headentry | cut -d/ -f2`
    else
        headentry=`echo $headentry | cut -d/ -f1`
    fi

    echo -e "$i \t --> $headentry"
done
