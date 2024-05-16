#!/bin/bash

# Download latest repo from Google Storage
# sudo curl https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo && sudo chmod a+x /usr/local/bin/repo

git config --global user.email "github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"
git config --global color.ui true

repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
repo sync build/make

wget -O - https://raw.githubusercontent.com/waydroid/android_vendor_waydroid/lineage-20/manifest_scripts/generate-manifest.sh | bash

repo sync

. build/envsetup.sh

apply-waydroid-patches

. build/envsetup.sh
lunch lineage_waydroid_x86_64-eng
make systemimage -j$(nproc --all)
make vendorimage -j$(nproc --all)

simg2img $OUT/system.img ~/system.img
simg2img $OUT/vendor.img ~/vendor.img
