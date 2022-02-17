all: its

OPENWRT_VERSION=19.07.8

its-ubnt-unifiac-lite:
	IMAGEBUILDER_URL='https://downloads.openwrt.org/releases/$(OPENWRT_VERSION)/targets/ath79/generic/openwrt-imagebuilder-$(OPENWRT_VERSION)-ath79-generic.Linux-x86_64.tar.xz' ./build-image.sh control/ubnt-unifiac-lite

its: its-ubnt-unifiac-lite

DATE = $(shell date +'%Y%m%d')
VERSION = v0.$(DATE)

release-candidate: all release-images

tag:
	git tag -f access-points/v0.$(DATE)

release-images:
	git add images/$(VERSION)/*.image-manifest
	git annex add images/$(VERSION)
	git commit -m "aps: Release $(VERSION)"
