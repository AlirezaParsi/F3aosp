# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=alioth
device.name2=aliothin
device.name3=
device.name4=
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=1;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 750 750 $ramdisk/*;

# Banner
ui_print " ";
ui_print " ";
ui_print "  █████╗ ██╗     ██████╗ ";
ui_print " ██╔══██╗██║     ██╔══██╗";
ui_print " ███████║██║     ██████╔╝";
ui_print " ██╔══██║██║     ██╔═══╝ ";
ui_print " ██║  ██║███████╗██║     ";
ui_print " ╚═╝  ╚═╝╚══════╝╚═╝     ";
ui_print " ";
ui_print " Kernel by AlirezaParsi ";
ui_print " ";
ui_print " ";

# Kernel naming scene
ui_print " ";
ui_print "Kernel Naming : "$ZIPFILE" ";
ui_print " ";

# Convert ZIPFILE to lowercase for case-insensitive comparison
ZIPFILE_LOWER=$(echo "$ZIPFILE" | tr '[:upper:]' '[:lower:]')

# Handle DTBO variants (MIUI or AOSP)
case "$ZIPFILE_LOWER" in
  *miui*)
    ui_print "MIUI Detected,";
    ui_print "Using MIUI DTBO... ";
    mv miui-dtbo.img $home/dtbo.img;
    rm -f aosp-dtbo.img;
  ;;
  *)
    ui_print "AOSP Detected (default),";
    ui_print "Using AOSP DTBO... ";
    mv aosp-dtbo.img $home/dtbo.img;
    rm -f miui-dtbo.img;
  ;;
esac
ui_print " ";

# Handle DTB variants (4500 mAh or 5000 mAh)
case "$ZIPFILE_LOWER" in
  *bat*)
    ui_print "4500 mAh Battery Detected,";
    ui_print "Using 4500 mAh DTB... ";
    mv *-bat-dtb $home/dtb;
    rm -f *-5000-dtb;
  ;;
  *)
    ui_print "5000 mAh Battery Detected (default),";
    ui_print "Using 5000 mAh DTB... ";
    mv *-5000-dtb $home/dtb;
    rm -f *-bat-dtb;
  ;;
esac

## AnyKernel install
dump_boot;

# Begin Ramdisk Changes

# migrate from /overlay to /overlay.d to enable SAR Magisk
if [ -d $ramdisk/overlay ]; then
  rm -rf $ramdisk/overlay;
fi;

write_boot;
## end install

## vendor_boot shell variables
block=/dev/block/bootdevice/by-name/vendor_boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
dump_boot;

write_boot;
## end vendor_boot install
