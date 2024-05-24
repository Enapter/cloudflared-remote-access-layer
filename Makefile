# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

SKOPEO_COPY ?= skopeo copy --insecure-policy
UMOUNT ?= umount
MKSQUASHFS ?= mksquashfs
MKDIR ?= mkdir
CP ?= cp
LN ?= ln
CD ?= cd
RM ?= rm

CLOUDFLARED_VERSION ?= 2024.5.0

PROJECT_ROOT ?= `pwd`
LAYER_TMP ?= "$(PROJECT_ROOT)/build/cloudflared-remote-access-layer"
LAYER_TMP_ROOTFS = "$(LAYER_TMP)/rootfs"
LAYER_TMP_IMAGES = "$(LAYER_TMP)/images"

LAYER_PATH ?= build/cloudflared-remote-access.img

SKOPEO_TARGET = "overlay@$(LAYER_TMP_IMAGES)"

build:
	$(MKDIR) -p $(LAYER_TMP)
	$(SKOPEO_COPY) docker://cloudflare/cloudflared:$(CLOUDFLARED_VERSION) containers-storage:[$(SKOPEO_TARGET)]cloudflared:latest
	$(UMOUNT) $(LAYER_TMP_IMAGES)/overlay || true
	$(MKDIR) -p $(LAYER_TMP_ROOTFS)
	$(MKDIR) -p $(LAYER_TMP_ROOTFS)/usr/lib/systemd/system/
	$(MKDIR) -p $(LAYER_TMP_ROOTFS)/etc/systemd/system/default.target.wants/
	$(MKDIR) -p $(LAYER_TMP_ROOTFS)/etc/systemd/system/multi-user.target.wants/
	$(CP) $(PROJECT_ROOT)/files/cloudflared-remote-access.service $(LAYER_TMP_ROOTFS)/usr/lib/systemd/system/cloudflared-remote-access.service
	$(LN) -s /usr/lib/systemd/system/cloudflared-remote-access.service $(LAYER_TMP_ROOTFS)/etc/systemd/system/default.target.wants/cloudflared-remote-access.service
	$(LN) -s /usr/lib/systemd/system/cloudflared-remote-access.service $(LAYER_TMP_ROOTFS)/etc/systemd/system/multi-user.target.wants/cloudflared-remote-access.service
	$(MKSQUASHFS) $(LAYER_TMP) $(LAYER_PATH) -noappend -comp lzo -all-root

.PHONY: build

clean:
	$(UMOUNT) $(LAYER_TMP_IMAGES)/overlay || true
	$(RM) -f $(LAYER_PATH)
	$(RM) -rf $(LAYER_TMP)

.PHONY: clean
