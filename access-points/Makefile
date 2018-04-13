all: its

export IMAGEBUILDER_URL = http://downloads.lede-project.org/releases/17.01.4/targets/ar71xx/generic/lede-imagebuilder-17.01.4-ar71xx-generic.Linux-x86_64.tar.xz

its:
	./build-image.sh control/tl-wr841-v10
	./build-image.sh control/ubnt-unifiac-lite

DATE = $(shell date +'%Y%m%d')
VERSION = v0.$(DATE)

release: tag all release-images

tag:
	git tag -f access-points/v0.$(DATE)

release-images:
	git add images/$(VERSION)/*.image-manifest
	git annex add images/$(VERSION)
	git commit -m "aps: Release $(VERSION)"
