#!/usr/bin/env bash
if ! type dirname > /dev/null 2>&1; then
    echo "Not even a linux or macOS, Windoze? We don't support it. Abort."
    exit 1
fi

. "$(dirname "$0")"/../common/common.sh

init_with_root_or_sudo "$0"

SCRIPT_ABS_PATH=$(turn_to_absolute_path $0)

begin_banner "Top level" "build framework"

cp -R "${SCRIPT_ABS_PATH}"/template/* "$1/$2/"

for FILE_TO_SED in $(grep -R MY_PROJECT_NAME "$1/$2/"*|awk -F":" '{print $1}'|sort|uniq)
do
   sed -i.bak.for.sed.inplace.edit "s/MY_PROJECT_NAME/$2/g" ${FILE_TO_SED}
   rm -fr ${FILE_TO_SED}.bak.for.sed.inplace.edit
done

#update index-state in the cabal.project file
echo "packages : ." > "$1/$2"/cabal.project
echo "index-state : $(date +%Y-%m-%dT00:00:00Z)" >> "$1/$2"/cabal.project

#update niv sources list
set +u
[[ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]] && . $HOME/.nix-profile/etc/profile.d/nix.sh
set -u

# Pin to the latest stable channel instead
#MY_CHANNEL=$(nix-channel --list | awk -F"/" '{print $NF}')
MY_CHANNEL=$(get_last_stable_nix_channel)
MY_CHANNEL_NUM=$(echo "${MY_CHANNEL}" | awk -F"-" '{print $2}')
case ${THE_DISTRIBUTION_ID} in
  debian|ubuntu|rhel|centos)
    cd $1/$2
    "${SCRIPT_ABS_PATH}"/niv init --no-nixpkgs
    # following is for Linux
    "${SCRIPT_ABS_PATH}"/niv add nixpkgs -b "nixos-${MY_CHANNEL_NUM}"
    # following is for OSX
    "${SCRIPT_ABS_PATH}"/niv add nixpkgs-darwin -b "nixpkgs-${MY_CHANNEL_NUM}-darwin"
    "${SCRIPT_ABS_PATH}"/niv add input-output-hk/haskell.nix
    ;;
  *)
    nix-shell '<nixpkgs>' -p haskellPackages.niv --run "cd $1/$2; niv init --no-nixpkgs; niv add nixpkgs -b nixos-${MY_CHANNEL}; niv add nixpkgs-darwin -b nixpkgs-${MY_CHANNEL_NUM}-darwin; niv add input-output-hk/haskell.nix"
    ;;
esac

# set the nixpkgs to the latest stable channel in the nix file
# also set the ghc version accordingly.
MY_NIXPKGS=$(echo "${MY_CHANNEL}" | sed 's/\-darwin//g' | sed 's/nixos/nixpkgs/g' | sed 's/\.//g')
MY_GHC_VER=$(nix-env -f "<nixpkgs>" -qa ghc | sed 's/\-//g' | sed 's/\.//g')
sed -i.bak.for.replace.my_nixpkgs "s/MY_NIXPKGS/${MY_NIXPKGS}/g" "$1/$2/default.nix"
sed -i.bak.for.replace.my_ghc_ver "s/MY_GHC_VER/${MY_GHC_VER}/g" "$1/$2/default.nix"
rm -fr "$1/$2"/default.nix.bak.for.replace.my_nixpkgs
rm -fr "$1/$2"/default.nix.bak.for.replace.my_ghc_ver

done_banner "Top level" "build framework"
