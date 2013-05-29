#!/sbin/sh
#
# This leverages the loki_patch utility created by djrbliss which allows us
# to bypass the bootloader checks on jfltevzw and jflteatt
# See here for more information on loki: https://github.com/djrbliss/loki
#
#
# Run loki patch on boot images with certain bootloaders
#
# Valid:
# Bootloader Version I337UCUAMDB (AT&T)
# Bootloader Version I337UCUAMDL (AT&T)
# Bootloader Version I545VRUAMDK (Verizon)

export C=/tmp/loki_tmpdir

egrep -q '(bootloader=I337UCUAMDB)|(bootloader=I337UCUAMDL)|(bootloader=I545VRUAMDK)' /proc/cmdline
if [ $? -eq 0 ];then
  mkdir -p $C
  dd if=/dev/block/platform/msm_sdcc.1/by-name/aboot of=$C/aboot.img
  /tmp/loki_patch boot $C/aboot.img /tmp/boot.img $C/boot.lok || exit 1
  /tmp/loki_flash boot $C/boot.lok || exit 1
  rm -rf $C
fi

exit 0
