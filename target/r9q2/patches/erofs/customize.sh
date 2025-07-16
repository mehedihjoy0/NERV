SKIPUNZIP=1

if $TARGET_FS_CHANGED; then
    LOG "- Copying patched fstab to /vendor/etc"
    cp -f "$SRC_DIR/target/$TARGET_CODENAME/patches/erofs/vendor/etc/fstab.qcom" "$WORK_DIR/vendor/etc"

    # r9q2's fstab file in vendor_boot is "fstab.qcom", while in vendor it's "fstab.default"
    # the patched file is named ".qcom" due to the EROFS patch script
    # for now, let's keep it this way and rename it after copying it to vendor
    rm -f "$WORK_DIR/vendor/etc/fstab.default"
    mv "$WORK_DIR/vendor/etc/fstab.qcom" "$WORK_DIR/vendor/etc/fstab.default"
else
    LOG "- TARGET_OS_FILE_SYSTEM is not EROFS. Ignoring"
fi
