#!/usr/bin/env nix-shell
#!nix-shell --pure -i bash -p wget -p gnupg -p cacert

# Update patch set for GNU Bash or Readline.

if [ $# -ne 2 ]
then
    echo "Usage: $(basename $0) PROJECT VERSION"
    echo ""
    echo "Update the patch set for PROJECT (one of \`bash' or \`readline') for"
    echo "the given version (e.g., \`4.0').  Produce \`PROJECT-patches.nix'."
    exit 1
fi

PROJECT="$1"
VERSION="$2"
VERSION_CONDENSED="$(echo $VERSION | sed -es/\\.//g)"
PATCH_LIST="$PROJECT-$VERSION-patches.nix"

set -e

start=1
end=100 # must be > 99 for correct padding

rm -vf "$PATCH_LIST"

wget "https://tiswww.case.edu/php/chet/gpgkey.asc"
echo "4ef5051ce7200241e65d29c11eb57df8  gpgkey.asc" > gpgkey.asc.md5
md5sum -c gpgkey.asc.md5
gpg --import ./gpgkey.asc
rm gpgkey.asc{,.md5}

( echo "# Automatically generated by \`$(basename $0)'; do not edit." ;	\
  echo "" ;								\
  echo "patch: [" )							\
>> "$PATCH_LIST"

for i in `seq -w $start $end`
do
    wget ftp.gnu.org/gnu/$PROJECT/$PROJECT-$VERSION-patches/$PROJECT$VERSION_CONDENSED-$i || break
    wget ftp.gnu.org/gnu/$PROJECT/$PROJECT-$VERSION-patches/$PROJECT$VERSION_CONDENSED-$i.sig
    gpg --verify $PROJECT$VERSION_CONDENSED-$i.sig
    echo "(patch \"$i\" \"$(nix-hash --flat --type sha256 --base32 $PROJECT$VERSION_CONDENSED-$i)\")"	\
    >> "$PATCH_LIST"

    rm -f $PROJECT$VERSION_CONDENSED-$i{,.sig}
done

echo "]" >> "$PATCH_LIST"

echo "Got $(expr $i - 1) patches."
echo "Patch list has been written to \`$PATCH_LIST'."
