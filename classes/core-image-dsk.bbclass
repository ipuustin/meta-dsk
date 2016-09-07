# core image dsk class
 
IMAGE_INSTALL = " \
		kernel-modules \
		linux-firmware \
        util-linux \
		packagegroup-core-boot \
                ${ROOTFS_PKGMANAGE_BOOTSTRAP} \
                ${CORE_IMAGE_EXTRA_INSTALL} \
		"

IMAGE_LINGUAS = " "
LICENSE = "MIT"
NOISO = "1"

COMPRESSIONTYPES_append = " zip"
ZIP_COMPRESSION_LEVEL ?= "-9"
COMPRESS_CMD_zip = "zip ${ZIP_COMPRESSION_LEVEL} ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${type}.zip ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${type}"
COMPRESS_DEPENDS_zip = "zip-native"

#IMAGE_FSTYPES_remove_genericx86-64 = "live"
#IMAGE_FSTYPES_append_genericx86-64 = " dsk dsk.bmap"
IMAGE_FSTYPES_remove = "live"
IMAGE_FSTYPES_append = " dsk dsk.bmap"

IMAGE_CLASSES += "image-dsk"

INITRD_IMAGE ?= "core-image-dsk-initramfs"
inherit core-image extrausers image-buildinfo

BUILD_ID ?= "${DATETIME}"
# Do not re-trigger builds just because ${DATETIME} changed.
BUILD_ID[vardepsexclude] += "DATETIME"
IMAGE_BUILDINFO_VARS_append = " BUILD_ID"

IMAGE_NAME = "${IMAGE_BASENAME}-${MACHINE}-${BUILD_ID}"

# Enable initramfs based on initramfs-framework (chosen in
# core-image-minimal-initramfs.bbappend). All machines must
# boot with a suitable initramfs, because IMA initialization is done
# in it.
#INITRD_IMAGE = "core-image-minimal-initramfs"
#INITRD_IMAGE_genericx86-64 = "core-image-dsk-recipe-initramfs"
#INITRD_IMAGE_genericx86-64 = "core-image-minimal-initramfs"

# The expected disk layout is not compatible with the HDD format:
# HDD places the rootfs as loop file in a VFAT partition (UEFI),
# while the rootfs is expected to be in its own partition.
NOHDD = "1"

# Image creation: add here the desired value for the PARTUUID of
# the rootfs. WARNING: any change to this value will trigger a
# rebuild (and re-sign, if enabled) of the combo EFI application.
REMOVABLE_MEDIA_ROOTFS_PARTUUID_VALUE = "12345678-9abc-def0-0fed-cba987654321"
# The second value is needed for the system installed onto
# the device's internal storage in order to mount correct rootfs
# when an installation media is still inserted into the device.
INT_STORAGE_ROOTFS_PARTUUID_VALUE = "12345678-9abc-def0-0fed-cba987654320"

# Create all users and groups normally created only at runtime already at build time.
#inherit systemd-sysusers

#ROOTFS_POSTPROCESS_COMMAND += "ostro_image_system_serialgetty; "
