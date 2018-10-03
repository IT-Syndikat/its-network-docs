ITS WiFi Access Points Setup
============================

We build the access points in use at the space using the OpenWrt image
builder. The deployed images are completely hands-off. No configuration of the
running firmware should be necessary as all the device specific setup is done
using `/etc/uci-defaults/` by keying off the device's MAC address.

See [`files/common/its/etc/uci-defaults/50-config-from-mac`](files/common/its/etc/uci-defaults/50-config-from-mac) for details.

Building Images
---------------

The [`Makefile`](./Makefile) provides a target for each device type we have
images for, to build images for all devices at the space you can use:

```
$ make its
[...]
Wrote images to images/v0.20180506-3-g115cc99-dirty
```

the resulting sysupgrade images land in a directory in `images/`. The symlink
`images/latest` points to the directory of the image built most recently. The
build system also produces a `*.image-manifest` file which contains the URL to
the ImageBuilder used as well its hash and the corresponding image's hash.

Each produced image file contains the target, subtarget and profile names for
the targeted device (among other things), for example the Ubiquity UniFi AC
Lite's image is called `*-ar71xx-generic-ubnt-unifiac-lite*-sysupgrade.bin`
standing for `TARGET=ar71xx`, `SUBTARGET=generic`, `PROFILE=ubnt-unifiac-lite`.

These images can then be deployed by copying them to the respective device in
`/tmp` using `scp` and then running, over ssh:

    # sysupgrade -n /tmp/*-sysupgrade.bin

If this fails for some reason and the target device is subsequently bricked so
bad it cannot even boot into
[failsafe mode](https://openwrt.org/docs/guide-user/troubleshooting/failsafe_and_factory_reset#entering_failsafe_mode)
any more, see
[OpenWrt Debricking Guide](https://openwrt.org/docs/guide-user/troubleshooting/generic.debrick).

Using Released Binaries
-----------------------

The offically released and deployed images are available in this repo in the
[`images/`](images/) directory. They need to be retrived from an internal server
using [`git annex`](https://git-annex.branchable.com) before they can be
accessed. The public git repo only contains their hashes.

We also use git-annex to add the secrets used for generating the images to the
repo, which will then only be available to authorized people using the internal
git-annex store. For an example, see
[`files/common/its/etc/uci-defaults/51-secrets`](files/common/its/etc/uci-defaults/51-secrets). This
file just sets up secrets, such as the WiFi/root password.
