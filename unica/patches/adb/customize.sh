# Only enable on debug builds
if ! $DEBUG; then
    return 0
fi

# Start adbd on boot
# https://android.googlesource.com/platform/packages/modules/adb/+/refs/heads/main/docs/dev/how_adbd_starts.md
SET_PROP_IF_DIFF "product" "persist.sys.usb.config" "$(GET_PROP "product" "persist.sys.usb.config"),adb"
SET_PROP_IF_DIFF "odm" "persist.sys.usb.config" "$(GET_PROP "odm" "persist.sys.usb.config"),adb"
SET_PROP_IF_DIFF "odm_dlkm" "persist.sys.usb.config" "$(GET_PROP "odm_dlkm" "persist.sys.usb.config"),adb"
SET_PROP_IF_DIFF "system_dlkm" "persist.sys.usb.config" "$(GET_PROP "system_dlkm" "persist.sys.usb.config"),adb"
SET_PROP_IF_DIFF "vendor" "persist.sys.usb.config" "$(GET_PROP "vendor" "persist.sys.usb.config"),adb"
SET_PROP_IF_DIFF "vendor_dlkm" "persist.sys.usb.config" "$(GET_PROP "vendor_dlkm" "persist.sys.usb.config"),adb"

# Disable adb authentication
# https://android.googlesource.com/platform/packages/modules/adb/+/refs/tags/android-15.0.0_r1/daemon/main.cpp#213
SET_PROP_IF_DIFF "system" "ro.adb.secure" "0"
SET_PROP_IF_DIFF "vendor" "ro.adb.secure" "0"

# Do not filter out Samsung processes in logs
SET_PROP_IF_DIFF "system" "persist.log.semlevel" "0xFFFFFFFF"

if [ -f "$WORK_DIR/vendor/etc/init/hw/init.target.rc" ]; then
    if ! grep -q "persist.vendor.radio.port_index" "$WORK_DIR/vendor/etc/init/hw/init.target.rc"; then
        {
            echo ""
            echo "on property:persist.vendor.radio.port_index=\"\""
            echo "    setprop sys.usb.config adb"
        } >> "$WORK_DIR/vendor/etc/init/hw/init.target.rc"
    fi
fi
