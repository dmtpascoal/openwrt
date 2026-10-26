#!/bin/sh
# Pin the AmneziaWG sources to the commits behind their release tags, so a
# moved tag cannot change what gets built.
set -eu
pin() { # makefile commit
	sed -i "s|^PKG_SOURCE_VERSION:=.*|PKG_SOURCE_VERSION:=$2|" "$1"
	grep -qx "PKG_SOURCE_VERSION:=$2" "$1"
}
# amneziawg-linux-kernel-module v3.1.20260906
pin feeds/amneziawg/kmod-amneziawg/Makefile 4569c4c67f3a57414969260cafbbd04694fbaae0
# amneziawg-tools v3.1.20260812
pin feeds/amneziawg/amneziawg-tools/Makefile ee0f0a9aa34ff0a0da4b3433b9512781cfe02843
