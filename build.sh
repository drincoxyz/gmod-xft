#!/bin/sh

version=`date +%-Y.%-m.%-d-%-H.%-M.%-S`
obfuscator='.lib/LuaObfuscator/__main__.py --level 2'
tmpdir='.tmp'
buildsdir='.builds'

mkdir -p $buildsdir

echo Version: $version

read -p "Press enter to start build..."

mkdir -pv $tmpdir

rm -rfv $tmpdir

read -p "Press enter to exit..."