#!/bin/bash
#

TORDIR=$HOME/tor-browser_en-US/Browser/TorBrowser/Tor
TOR=$TORDIR/tor
export LD_LIBRARY_PATH=$TORDIR

mkdir -p ./data
chmod go-rwx ./data

cat /dev/null > ./data/empty.rc
cat /dev/null > ./data/hostname
cat /dev/null > ./data/private_key

$TOR --quiet --PublishHidServDescriptors 0 -f ./data/empty.rc --defaults-torrc ./data/empty.rc --DataDirectory ./data --HiddenServiceDir ./data --HiddenServiceVersion 2 --HiddenServicePort 9999 --SocksPort 0 --FetchServerDescriptors 0 --DisableNetwork 1 --PidFile ./data/pid.txt &

while true
do
#if [[ -s ./data/hostname ]]
ST=`stat --format "%s" -t  ./data/hostname`
if [ $ST -eq 23 ]
then
  kill -TERM `cat ./data/pid.txt`

  HOS=`base64 -w0 ./data/hostname`
  PRI=`base64 -w0 ./data/private_key`

  echo "----------------------------------------------------------------"
  echo -n "hostname: "
  cat ./data/hostname
  echo "----------------------------------------------------------------"

  echo "private_key: "
  cat ./data/private_key
  echo "================================================================"

  echo "echo -n \"$HOS\" | base64 -d > hostname"
  echo "echo -n \"$PRI\" | base64 -d > private_key"

  break
fi
done
