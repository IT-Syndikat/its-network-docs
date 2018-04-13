ITS WiFi Access Points Setup
============================

We build the access points in use at the space using the LEDE/OpenWrt image
builder. The deployed images are completely hands-off no configuration of the
running firmware should be necessary as all the device specific setup is done
using `/etc/uci-defaults/` by keying off the MAC address.

See [`files/common/its/etc/uci-defaults/50-config-from-mac`](files/common/its/etc/uci-defaults/50-config-from-mac) for details.

Building Images
---------------

To build the `its` images, run:

```
$ make its
```

the resulting images land in `images/v0.$(date +'%Y%m%d')`. The build system
also produces a `*.image-manifest` file which contains the URL to the
ImageBuilder used as well its hash and the corresponding image's hash.

Using Released Binaries
-----------------------

The offically released and deployed images are added to the repo using
[`git annex`](https://git-annex.branchable.com) since this will not actually add
the files to git but rather just a symlink containing its hash. The actual
binary images can then be uploaded to an internal server.

We also use git-annex to add secrets to the repo which will then only be
available to authorized people using the internal git-annex store. For an
example, see
[`files/common/its/etc/uci-defaults/51-secrets`](files/common/its/etc/uci-defaults/51-secrets). This
file just sets up secrets, such as the WiFi/root password.
