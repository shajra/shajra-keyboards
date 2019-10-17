# Ergonomic Keyboard "shajra" Mappings (with Nix)

[![Master Branch Build Status](https://img.shields.io/travis/shajra/shajra-keyboards/master.svg?label=master)](https://travis-ci.org/shajra/shajra-keyboards)

This project has the "shajra" keyboard mappings for two ergonomic split
keyboards:

- [Keyboardio's Model 01][KBDIO], programmed with [Kaleidoscope][KSCOPE]
  firmware.
- [ZSA Technology Labs' Ergodox EZ][ERGEZ], programmed with [QMK][QMK] firmware

Beyond the keymap, this project offers some streamlined automation with
[Nix][NIX] that you can use for your own keymap.

The rest of this document discusses using this automation.  To get the most out
of the keymap itself, you may be interested in the [design
document](doc/design.md) explaining the motivation behind the mapping.

[ERGEZ]: https://ergodox-ez.com/
[KBDIO]: https://shop.keyboard.io/
[KSCOPE]: https://github.com/keyboardio/Kaleidoscope
[NIX]: https://nixos.org/nix/
[QMK]: https://docs.qmk.fm

## Contents

<!--ts-->
* [The mappings](#the-mappings)
   * [Model 01 "shajra" keymap](#model-01-shajra-keymap)
   * [Ergodox EZ "shajra" keymap](#ergodox-ez-shajra-keymap)
* [Using these key mappings](#using-these-key-mappings)
   * [1. Install Nix on your GNU/Linux distribution](#1-install-nix-on-your-gnulinux-distribution)
   * [2. Make sure your udev rules are set](#2-make-sure-your-udev-rules-are-set)
   * [3. For Kaleidoscope, join the necessary OS group](#3-for-kaleidoscope-join-the-necessary-os-group)
   * [4. Unplug and replug your keyboard](#4-unplug-and-replug-your-keyboard)
   * [5. Get the code and run it](#5-get-the-code-and-run-it)
      * [Flashing an Ergodox EZ keyboard](#flashing-an-ergodox-ez-keyboard)
      * [Flashing a Keyboardio Model 01 keyboard](#flashing-a-keyboardio-model-01-keyboard)
* [Reverting to the factory default mapping](#reverting-to-the-factory-default-mapping)
* [Modifying and testing](#modifying-and-testing)
* [Release](#release)
* [Contribution](#contribution)
* [License](#license)
* [Authorship and copyright](#authorship-and-copyright)
<!--te-->

## The mappings

The "shajra" keymaps for both keyboards are extremely similar, which works out
well because the physical layouts of these keyboards are also similar.  We can
more easily switch from one keyboard to another, and retain the design benefits
of the mapping.

### Model 01 "shajra" keymap

!["shajra" keymap for Model 01](doc/model-01-shajra-layout.png)

### Ergodox EZ "shajra" keymap

!["shajra" keymap for Ergodox EZ](doc/ergodox-ez-shajra-layout.png)

## Using these key mappings

This project only supports a GNU/Linux operating system with the [Nix package
manager][NIX] installed.

QMK and Kaleidoscope have build complexities and dependencies that can take a
moment to work through.  Nix can automate this hassle away by downloading and
setting up all the necessary third-party dependencies in way that

- is highly reproducible
- won't conflict with your current system/configuration.

By using Nix, we won't have to worry about downloading QMK or Kaleidoscope, or
making sure we have the right version of build tools like Arduino installed, or
messing with Git submodules, or setting up environment variables.  Nix does all
this for us.  The provided scripts simplify using Nix even further.

The following steps will get your keyboard flashed.

### 1. Install Nix on your GNU/Linux distribution

> **_NOTE:_** You don't need this step if you're running NixOS, which comes with
> Nix baked in.

> **_NOTE:_** Nix on Macs (nix-darwin) currently won't work with this project
> and is not supported for Macs.

If you don't already have Nix, the official installation script should work on a
variety of GNU/Linux distributions.  The easiest way to run this installation
script is to execute the following shell command as a user other than root:

```
$ curl https://nixos.org/nix/install | sh
```

This script will download a distribution-independent binary tarball containing
Nix and its dependencies, and unpack it in `/nix`.

If you prefer to install Nix another way, reference the [Nix
manual][NIXINSTALL].

[NIXINSTALL]: https://nixos.org/nix/manual/#chap-installation

### 2. Make sure your udev rules are set

To program either keyboard with a new mapping, you need to augment your OS
configuration with new udev rules.

The following are recommended rules for each keyboard:

```
# For Teensy/Ergodox
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# For Kaleidoscope/Keyboardio
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2300", SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2301", SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", ENV{ID_MM_CANDIDATE}:="0"
```

These settings should correspond to the official documentation:

- [QMK documentation for configuring udev][QUDEV]
- [Kaleidoscope documentation for configuring udev][KUDEV]

[QUDEV]: https://github.com/qmk/qmk_firmware/tree/master/keyboards/ergodox_ez
[KUDEV]: https://github.com/keyboardio/Kaleidoscope/wiki/Install-Arduino-support-on-Linux

Each distribution is different, but on many GNU/Linux systems, udev rules are
put in a file in `/etc/udev/rules.d` with a ".rules" extension.

On some systems, you can activate these rules with the following commands:

```
$ udevadm control --reload-rules
$ udevadm trigger
```

Or just restart the computer.

### 3. For Kaleidoscope, join the necessary OS group

> **_NOTE:_** You don't need this step if you're flashing the Ergodox EZ.

Once udev is configured, when you plug in the Keyboardio Model 01, a
`/dev/ttyACM0` should appear.  On many systems, this device is group-owned by
the "dialout" or the "uucp" group:

In the following example, we can see the device is group-owned by the "dialout"
group.

```
$ ls -l /dev/ttyACM0
crw-rw---- 1 root dialout 166, 0 Sep 30 21:33 /dev/ttyACM0
```

On most distributions, the follow commands should work to join a group
(substituting `$TTY_GROUP` and `$USERNAME`):

```
$ sudo usermod -a -G $TTY_GROUP $USERNAME
$ newgrp $TTY_GROUP
```

You should see memberships in the new group with the `groups` command:

```
$ groups | grep dialout
users wheel video dialout docker
```

### 4. Unplug and replug your keyboard

Unplug your keyboard(s) and plug them back in, to make sure everything's set to
program.

### 5. Get the code and run it

Clone this code base and go into the directory:

```
$ cd $SOME_WORKING_DIR
$ clone https://github.com/shajra/shajra-keyboards.git
$ cd shajra-keyboards
```

Note, the first time you run the commands described below, you'll see Nix doing
a lot of downloading and compiling.  After that, subsequent invocations should
be quicker with less output.

#### Flashing an Ergodox EZ keyboard

You can run the following to flash your Ergodox EZ with the new keymap, pressing
the reset button when prompted (access the reset button with an unbent paperclip
inserted into the small hole in the top right corner of the right keyboard
half):

```
$ ./flash-ergodoxez

Flashing ZSA Technology Lab's Ergodox EZ (custom "shajra" keymap)
=================================================================

FLASH SOURCE: /nix/store/4jy89rfqhiv15pwiybbnnlmldpn7c6jd-qmk-custom-shajra-src
FLASH BINARY: /nix/store/j5lzkvqhjm4vw6x2g0sdj165gpq80zw0-ergodoxez-custom-shajra-hex

Teensy Loader, Command Line, Version 2.1                                             
Read "/nix/store/j5lzkvqhjm4vw6x2g0sdj165gpq80zw0-ergodoxez-custom-shajra-hex": 27088 bytes, 84.0% usage
Waiting for Teensy device...
 (hint: press the reset button)
```

#### Flashing a Keyboardio Model 01 keyboard

You can run the following to flash your Keyboardio Model 01, holding down the
`Prog` key and then pressing `Enter` when prompted:

```
$ ./flash-model01  

Flashing Keyboardio's Model 01 (custom "shajra" keymap)
=======================================================

FLASH SOURCE: /nix/store/iffr3wcbpw4xxkv5bp8z8zlnp5a9199g-model01-custom-shajra-src

BOARD_HARDWARE_PATH="/nix/store/i6ay4l97lz03bi73rwz5zbyfsmjdl416-kaleidoscope-src/arduino/hardware" /nix/store/i6ay4l97lz03bi73rwz5zbyfsmjdl416-kaleidoscope-src/arduino/hardware/keyboardio/avr/libraries/Kaleidoscope/bin//kaleidoscope-builder flash
Building ./Model01-Firmware 0.0.0 into /tmp/kaleidoscope-/sketch/1852415-Model01-Firmware.ino/output...
- Size: firmware/Model01-Firmware/Model01-Firmware-0.0.0.elf
  - Program:   25326 bytes (88.3% Full)
  - Data:       1206 bytes (47.1% Full)

To update your keyboard's firmware, hold down the 'Prog' key on your keyboard,
and then press 'Enter'.

When the 'Prog' key glows red, you can release it.
```

The `Prog` key is hardwired to be the top-left-most key of the Keyboardio Model
01, but the `Enter` key can be remapped.  If you forget where the `Enter` has
been mapped to on your Keyboard, you can hit `Enter` on another connected
keyboard.

## Reverting to the factory default mapping

This project's scripts won't save off your previous keymap from your keyboard.
But we can revert to the keymap that your keyboard shipped with.

This can be done with the `-F`/`--factory` switch, which both
`./flash-ergodoxez` and `./flash-model01` support.  Both scripts have a
`-h`/`--help` in case you forget your options.

## Modifying and testing

The provided code is fairly compact.  If you look in the
[./ergodox\_ez/keymaps](./ergodox_ez/keymaps) and
[./model\_01/keymaps](./model_01/keymaps), you should find familiar files that
you would edit in QMK or Kaleidoscope projects, respectively.

For both keyboards, The "shajra" keymap is in it's own directory.  You can make
your own keymaps and put them in a sibling directory with the name of your
choice.

Then you can use the `-k`/`--keymap` switch of either script to load your custom
keymap by the name you chose for the keymap in the "keymaps" directory.  The
scripts should pick up changes, rebuild anything necessary, and flash your
keyboard.

Nix will copy your source code into `/nix/store`, and the invocation of both
scripts will print out a "FLASH SOURCE:" line indicating the source used for
compiling/flashing for your reference.  These are the full source trees you'd
normally use if following the QMK or Kaleidoscope documentation manually.

If you want to check that everything builds before flashing your keyboard, you
can run a `nix-build` invocation:

```
$ nix-build --no-out-link 
/nix/store/nfjh64lh72260yvsinddyqwpirxr7nca-ergodoxez-custom-shajra-flash
/nix/store/j5lzkvqhjm4vw6x2g0sdj165gpq80zw0-ergodoxez-custom-shajra-hex
/nix/store/086rn3nj1nsngdn8zgkdyv9ki2wjxbza-ergodoxez-factory-flash
/nix/store/hvdfzigh9zmh7pc9ylb2m8rlzsgw93h0-ergodoxez-factory-hex
/nix/store/634d3fr3dhi8472xmqmpa85zl3ynv1gj-model01-custom-shajra-flash
/nix/store/93rhn23wc5dav8hhr1arvhdkxcjavix2-model01-custom-shajra-hex
/nix/store/za6yalm95lf1a1a40fwyhw04bsyhwdrx-model01-factory-flash
/nix/store/3nylzbchxa1v8r1yy0xwli3ip15c367g-model01-factory-hex
```

If you run `nix-build` without the `--no-out-link` switch, Nix will leave
symlinks behind in your working directory that point to the built artifacts,
which Nix always stores in a special `/nix/store` directory.  The names of these
symlinks are all prefixed with "result".

You can garbage collect `/nix/store` by running `nix-collect-garbage`:

```
$ nix-collect-garbage 
finding garbage collector roots...
deleting garbage...
deleting '/nix/store/5yw0sx938gxbdrspq1ww01biibnlmf3v-source'
deleting '/nix/store/khcdgnbv73yxlpbf5pmqyijcc0ncc00g-nss-cacert-3.46'
deleting '/nix/store/kdmwba7cavpkl9lrzfpq11yzfgx4hnsx-model_01'
deleting '/nix/store/yds60gn308yxlhg8xg4r0fgapjcqk2qj-source'
deleting '/nix/store/0dfy1005lidbdq2xvzi0c2c6li38dzl8-source'
deleting '/nix/store/dvfckwy7a147x7fdpc55r91wp4ya5d15-qmk-custom-shajra-src'
deleting '/nix/store/k7yalpjh53xra535xaip1pfq6q4jgsc0-stdenv-linux'
deleting '/nix/store/zbyqndn83nmysgrwx250p4xran00a2ph-qmk-custom-shajra-old-src'
deleting '/nix/store/vb1ch91xq5fgzjby6pc76qnhvqg7r0f8-ergodox_ez'
deleting '/nix/store/cbvkz43c8w1djr30cldarmrm5xf27jkm-source'
deleting '/nix/store/7qhbwl2a77m358qgryn8jam2l4c0waqv-git-2.23.0'
deleting '/nix/store/trash'
deleting unused links...
note: currently hard linking saves -0.00 MiB
11 store paths deleted, 593.18 MiB freed
```

The "result" symlinks generated by `nix-build` keep built artifacts from by
garbage collected by `nix-collect-garbage`.  Otherwise, these symlink are safe
to delete, and [ignored by Git](./.gitignore).

## Release

The "master" branch of the repository on GitHub has the latest released version
of this code.  There is currently no commitment to either forward or backwards
compatibility.  However the scripts for compiling/flashing are largely stable
and are less likely to change than the "shajra" keymap.

The "user/shajra" branch is a personal branch that is force-pushed to.  The
"master" branch should not experience force-pushes and is recommended for
general use.

## License

This project is not a modified work in the traditional sense.  It provides
scripts the end user runs to make a modified work.  Most of the source code
modified (QMK, Kaleidoscope, and Model 01) is licensed under either GPLv2 or
GPLv3.

If you have Nix installed, then a provided script `licenses-thirdparty` can be
run to download all original source used, including license information.

In the spirit of the projects we build upon, all files in this
"shajra-keyboards" project are licensed under the terms of GPLv3 or (at your
option) any later version.

Please see the [COPYING.md](./COPYING.md) file for more details.

## Contribution

Feel free to file issues and submit pull requests with GitHub.  Ideas for how to
improve automation are welcome.  If you have ideas on how to improve the
"shajra" keymap, just make a compelling argument considering the factors that
have already gone into [its design](doc/design.md).

There is only one author to date, so the following copyright covers all files in
this project:

Copyright © 2019 Sukant Hajra
