#!/bin/sh
# autogen.sh for libquvi.

source=.gitignore
cachedir=autom4te.cache

gen_manual()
{
  echo "Generate manual..."
  MAN=doc/man3/libquvi.3 ; POD=$MAN.pod ; VN=`./gen-ver.sh`
  pod2man -c "libquvi manual" -n libquvi -s 3 -r "$VN" "$POD" "$MAN"
  return $?
}

cleanup()
{
  echo "WARNING!
Removes _files_ listed in $source and $cachedir directory.
Last chance to bail out (^C) before we continue."
  read n1
  [ -f Makefile ] && make distclean
  for file in `cat $source`; do # Remove files only.
    [ -e "$file" ] && [ -f "$file" ] && rm -f "$file"
  done
  [ -e "$cachedir" ] && rm -rf "$cachedir"
  exit 0
}

help()
{
  echo "Usage: $0 [-c|-h]
-h  Show this help and exit
-c  Make the source tree 'maintainer clean'
Run without options to (re)generate the configuration files."
  exit 0
}

while [ $# -gt 0 ]
do
  case "$1" in
    -c) cleanup;;
    -h) help;;
    *) break;;
  esac
  shift
done

echo "Generate configuration files..."
autoreconf -if && gen_manual && echo "You can now run 'configure'"