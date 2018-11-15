#!/bin/bash
#

LD_LIBRARY_PATH="$HOME/tor-browser_en-US/Browser/TorBrowser/Tor"
export LD_LIBRARY_PATH

TOR=$HOME/tor-browser_en-US/Browser/TorBrowser/Tor/tor

mkdir -p ./data
chmod go-rwx ./data

cat /dev/null > ./data/empty.rc
cat /dev/null > ./data/hostname
cat /dev/null > ./data/hs_ed25519_public_key
cat /dev/null > ./data/hs_ed25519_secret_key

$TOR --quiet --PublishHidServDescriptors 0 -f ./data/empty.rc --defaults-torrc ./data/empty.rc --DataDirectory ./data --HiddenServiceDir ./data --HiddenServiceVersion 3 --HiddenServicePort 9999 --SocksPort 0 --FetchServerDescriptors 0 --DisableNetwork 1 --PidFile ./data/pid.txt &

while true
do
#if [[ -s ./data/hostname ]]
ST=`stat --format "%s" -t  ./data/hostname`
if [ $ST -eq 63 ]
then
  kill -TERM `cat ./data/pid.txt`

  HOS=`base64 -w0 ./data/hostname`
  PUB=`base64 -w0 ./data/hs_ed25519_public_key`
  SEC=`base64 -w0 ./data/hs_ed25519_secret_key`

  echo "----------------------------------------------------------------"
  echo -n "hostname: "
  cat ./data/hostname
  echo "----------------------------------------------------------------"

  echo -n "hs_ed25519_public_key: "
  echo "$PUB"
  echo "----------------------------------------------------------------"

  echo -n "hs_ed25519_secret_key: "
  echo "$SEC"
  echo "================================================================"

  echo "echo -n \"$HOS\" | base64 -d > hostname"
  echo "echo -n \"$PUB\" | base64 -d > hs_ed25519_public_key"
  echo "echo -n \"$SEC\" | base64 -d > hs_ed25519_secret_key"

  break
fi
done
