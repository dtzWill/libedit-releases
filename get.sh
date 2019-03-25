#!/usr/bin/env bash

set -euo pipefail

VERSIONS=( $( \
  curl http://thrysoee.dk/editline/ \
  | grep -Eo '^[0-9]{4}-[0-9]{2}-[0-9]{2}' \
  | tr -d '-' ) )

IMPORT_TARS="$(nix-build --no-out-link '<nixpkgs>' -A git)/share/git/contrib/fast-import/import-tars.perl"

git init .

mkdir -p tars tmp

for v in "${VERSIONS[@]}"; do
  t="libedit-${v}-3.1.tar.gz"
  [ -e tars/$t ] && continue
  wget "http://thrysoee.dk/editline/$t" -O tmp/$t || continue
  mv tmp/$t tars/$t
  git add tars/$t
  git commit -m "add tarball: $t"
done

$IMPORT_TARS tars/*
