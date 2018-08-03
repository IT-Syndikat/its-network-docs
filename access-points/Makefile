all: its

its-tl-wr841-v10:
	IMAGEBUILDER_URL='https://downloads.openwrt.org/releases/18.06.0/targets/ar71xx/tiny/openwrt-imagebuilder-18.06.0-ar71xx-tiny.Linux-x86_64.tar.xz' ./build-image.sh control/tl-wr841-v10

its-ubnt-unifiac-lite:
	IMAGEBUILDER_URL='https://downloads.openwrt.org/releases/18.06.0/targets/ar71xx/generic/openwrt-imagebuilder-18.06.0-ar71xx-generic.Linux-x86_64.tar.xz' ./build-image.sh control/ubnt-unifiac-lite

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
