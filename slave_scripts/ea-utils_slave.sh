#!/usr/bin/env bash
## Add extra ppas slave script
## Author: Andrew Krohn
## Date: 2015-10-28
## License: MIT
## Version 0.0.1
set -e

## Define variables from inputs
stdout="$1"
stderr="$2"
log="$3"
homedir="$4"
scriptdir="$5"
date0=`date`

## Install ea-utils
	eautilstest=`command -v fastq-mcf 2>/dev/null | wc -l`
	if [[ $eautilstest == 0 ]]; then

echo "Installing ea-utils.
"
echo "Installing ea-utils.
" >> $log
tar -xzvf $scriptdir/ea-utils.1.1.2-806.tar.gz -C /bin/
cd /bin/ea-utils.1.1.2-806/
make install 1>$stdout 2>$stderr || true
echo "***** stdout:" >> $log
cat $stdout >> $log
echo "***** stderr:" >> $log
cat $stderr >> $log
echo "" >> $log
wait
	else
echo "ea-utils already installed.  Skipping.
"
	fi

exit 0