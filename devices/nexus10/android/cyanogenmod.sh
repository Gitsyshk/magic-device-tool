clear
echo ""
echo "Installing Cyanogenmod 13"
echo ""
sleep 1
echo "Please boot your Nexus 10 into fastboot mode by pressing Power & Volume Up (+) & Volume Down (-)"
echo ""
sleep 1
echo -n "Is your Nexus 10 in bootloader/fastboot mode now? [Y] "; read bootloadermode
if [ "$bootloadermode"==Y -o "$bootloadermode"==y -o "$bootloadermode"=="" ]; then
  clear
  echo ""
  echo "Detecting device"
  echo ""
  sleep 1
  fastboot devices > /tmp/AttachedDevices
fi
if grep 'device$\|fastboot$' /tmp/AttachedDevices
then
  echo "Device detected !"
  sleep 1
  clear
  fastboot format cache
  fastboot format userdata
  fastboot reboot-bootloader
  sleep 6
  clear
  echo ""
  echo "Downloading TWRP recovery"
  echo ""
  wget -c --quiet --show-progress --tries=10 http://people.ubuntu.com/~marius.quabeck/magic-device-tool/recoverys/twrp-3.0.2-0-manta.img
  sleep 1
  echo ""
  echo "Downloading Cyanogenmod 13.."
  echo ""
  sleep 1
  wget -c --quiet --show-progress --tries=10 https://download.cyanogenmod.org/get/manta-snapshot.zip
  echo ""
  echo "Downloading Open Gapps.."
  echo ""
  sleep 1
  wget -c --quiet --show-progress --tries=10 http://people.ubuntu.com/~marius.quabeck/magic-device-tool/gapps/open_gapps-arm-6.0-nano-20160811.zip
  sleep 2
  clear
  echo ""
  echo "Installing TWRP recovery"
  echo ""
  fastboot flash recovery twrp-3.0.2-0-manta.img
  sleep 1
  echo ""
  echo "Rebooting device.."
  echo ""
  echo "This will take ~35 seconds. Don't disconnect your device!"
  echo ""
  fastboot reboot-bootloader
  sleep 7
  fastboot boot twrp-3.0.2-0-manta.img
  sleep 8
  adb reboot recovery
  sleep 19
  echo ""
  clear
  echo ""
  echo "Pushing zip's to device"
  sleep 1
  echo ""
  echo "Please wait this can take a while"
  echo ""
  echo "You may see a prompt asking you for read/write permissions"
  echo "Ignore that prompt, the tool will take care of the installation"
  echo ""
  echo "  → CM 13 zip "
  adb push -p manta-snapshot.zip /sdcard/
  echo ""
  echo "  → gapps zip"
  adb push -p open_gapps-arm-6.0-nano-20160811.zip /sdcard/
  echo ""
  echo "========================================="
  sleep 1
  echo ""
  echo "Installing Cyanogenmod.."
  echo ""
  adb shell twrp install /sdcard/manta-snapshot.zip
  sleep 1
  echo ""
  echo "Installing GApps.."
  echo ""
  sleep 3
  adb shell twrp install /sdcard/open_gapps-arm-6.0-nano-20160811.zip
  echo ""
  echo "Wipe cache.."
  echo ""
  #adb shell twrp wipe cache
  #adb shell twrp wipe dalvik
  echo ""
  adb reboot
  echo "The device is now rebooting. Give it time to flash the new ROM. It will boot on its own."
  echo ""
  sleep 5
  echo ""
  echo "Cleaning up.."
  rm -f /tmp/AttachedDevices
  echo ""
  sleep 1
  echo "Exiting script. Bye Bye"
  sleep 1

else
  echo "Device not found"
  rm -f /tmp/AttachedDevices
  sleep 1
  echo ""
  echo "Back to menu"
  sleep 1
  . ./launcher.sh
fi
