all: its

OPENWRT_VERSION=18.06.1

its-tl-wr841-v10:
	IMAGEBUILDER_URL='https://downloads.openwrt.org/releases/$(OPENWRT_VERSION)/targets/ar71xx/tiny/openwrt-imagebuilder-$(OPENWRT_VERSION)-ar71xx-tiny.Linux-x86_64.tar.xz' ./build-image.sh control/tl-wr841-v10

its-ubnt-unifiac-lite:
	IMAGEBUILDER_URL='https://downloads.openwrt.org/releases/$(OPENWRT_VERSION)/targets/ar71xx/generic/openwrt-imagebuilder-$(OPENWRT_VERSION)-ar71xx-generic.Linux-x86_64.tar.xz' ./build-image.sh control/ubnt-unifiac-lite

its: its-ubnt-unifiac-lite its-tl-wr841-v10

DATE = $(shell date +'%Y%m%d')
VERSION = v0.$(DATE)

release-candidate: all release-images

tag:
	git tag -f access-points/v0.$(DATE)

release-images:
	git add images/$(VERSION)/*.image-manifest
	git annex add images/$(VERSION)
	git commit -m "aps: Release $(VERSION)"
