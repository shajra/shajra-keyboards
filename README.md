- [About the project](#sec-1)
- [The mappings](#sec-2)
  - [Model 100 and Model 01 “shajra” keymap](#sec-2-1)
  - [Ergodox EZ “shajra” keymap (Moonlander similar)](#sec-2-2)
- [Using these key mappings](#sec-3)
  - [1. Install Nix on your GNU/Linux distribution](#sec-3-1)
  - [2. Make sure your udev rules are set](#sec-3-2)
  - [4. For Kaleidoscope, join the necessary OS group](#sec-3-3)
  - [5. Unplug and replug your keyboard](#sec-3-4)
  - [6. Flash your keyboard](#sec-3-5)
    - [Flashing an Ergodox EZ keyboard](#sec-3-5-1)
    - [Flashing a Moonlander keyboard](#sec-3-5-2)
    - [Flashing a Keyboardio keyboard](#sec-3-5-3)
- [Reverting to the factory default mapping](#sec-4)
- [Customization](#sec-5)
  - [Customizing keymaps](#sec-5-1)
  - [Development](#sec-5-2)
- [Release](#sec-6)
- [License](#sec-7)
- [Contribution](#sec-8)

[![img](https://github.com/shajra/shajra-keyboards/workflows/CI/badge.svg)](https://github.com/shajra/shajra-keyboards/actions)

# About the project<a id="sec-1"></a>

This project has the “shajra” keyboard mappings for four ergonomic split keyboards:

-   [Keyboardio's Model 100](https://shop.keyboard.io), programmed with [Kaleidoscope](https://github.com/keyboardio/Kaleidoscope) firmware
-   [Keyboardio's Model 01 (discontinued)](https://shop.keyboard.io), also programmed with [Kaleidoscope](https://github.com/keyboardio/Kaleidoscope)
-   [ZSA Technology Labs' Moonlander](https://www.zsa.io/moonlander/), programmed with [QMK](https://docs.qmk.fm) firmware
-   [ZSA Technology Labs' Ergodox EZ](https://ergodox-ez.com), also programmed with [QMK](https://docs.qmk.fm).

Beyond the keymap, this project offers some streamlined automation with [Nix](https://nixos.org/nix) that you can use for your own keymap. Or you can use this automation to return your keyboard to its factory default.

This automation works for GNU/Linux only (sorry, not MacOS or Windows). If you're new to Nix this project bundles a few guides to get you started:

-   [Introduction to Nix and motivations to use it](doc/nix-introduction.md)
-   [Nix installation and configuration guide](doc/nix-installation.md)
-   [Nix end user guide](doc/nix-usage-flakes.md)
-   [Introduction to the Nix programming language](doc/nix-language.md)

The rest of this document discusses using this automation. To get the most out of the keymap itself, you may be interested in the [design document](doc/design.md) explaining the motivation behind the mapping.

# The mappings<a id="sec-2"></a>

The “shajra” keymaps for all four keyboards are extremely similar, which works out well because the physical layouts of these keyboards are also similar. We can more easily switch from one keyboard to another, and retain the design benefits of the mapping.

## Model 100 and Model 01 “shajra” keymap<a id="sec-2-1"></a>

![img](doc/model-100-shajra-layout.png)

## Ergodox EZ “shajra” keymap (Moonlander similar)<a id="sec-2-2"></a>

![img](doc/ergodox-ez-shajra-layout.png)

Note the Moonlander keyboard is almost an identical layout to the EZ, and not illustrated here. There are just two less keys on the thumb cluster. This leads to not having either Home or End on the base layer for the Moonlander. And the "application menu" keycodes are moved to the bottom-outer corners.

# Using these key mappings<a id="sec-3"></a>

This project only supports a GNU/Linux operating system (sorry, not MacOS or Windows) with the [Nix package manager](https://nixos.org/nix) installed.

QMK and Kaleidoscope have build complexities and dependencies that can take a moment to work through. Nix can automate this hassle away by downloading and setting up all the necessary third-party dependencies in a way that

-   is highly reproducible
-   won't conflict with your current system/configuration.

By using Nix, we won't have to worry about downloading QMK or Kaleidoscope, or making sure we have the right version of build tools like Arduino installed, or messing with Git submodules, or setting up environment variables. Nix does all this for us. The provided scripts simplify using Nix even further.

The following steps will get your keyboard flashed.

## 1. Install Nix on your GNU/Linux distribution<a id="sec-3-1"></a>

If you don't have Nix installed and configured on your system, follow the [instructions provided](doc/nix-installation.md). As discussed, setting up Cachix and enabling the experimental *flakes* feature are both recommended.

## 2. Make sure your udev rules are set<a id="sec-3-2"></a>

To program either keyboard with a new mapping, you need to augment your OS configuration with new udev rules.

The following are recommended rules for each keyboard:

    # For Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", TAG+="uaccess"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", TAG+="uaccess"
    
    # For Moonlander
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
        TAG+="uaccess", SYMLINK+="stm32_dfu"
    
    # For Model 100
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="0005", \
        SYMLINK+="model100", ENV{ID_MM_DEVICE_IGNORE}:="1", \
        ENV{ID_MM_CANDIDATE}:="0", MODE="0666", TAG+="uaccess", TAG+="seat"
    
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="3496", ATTRS{idProduct}=="0006", \
        SYMLINK+="model100", ENV{ID_MM_DEVICE_IGNORE}:="1", \
        ENV{ID_MM_CANDIDATE}:="0", MODE="0666", TAG+="uaccess", TAG+="seat"
    
    # For Model 01
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2300", \
        SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1",   \
        ENV{ID_MM_CANDIDATE}:="0", MODE="0666", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2301", \
        SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1",   \
        ENV{ID_MM_CANDIDATE}:="0", MODE="0666", TAG+="uaccess", TAG+="seat"

These settings should roughly correspond to the official documentation of tools and libraries used by this project:

-   [QMK documentation for configuring Halfkey bootloader used by the Ergodox EZ](https://docs.qmk.fm/#/flashing?id=halfkay)
-   [Teensy CLI documentation, used internally for flashing the Ergodox EZ](https://www.pjrc.com/teensy/loader_cli.html)
-   [Wally CLI, used internally for flashing the Moonlander](https://github.com/zsa/wally/blob/master/dist/linux64/50-wally.rules)
-   [Kaleidoscope documentation](https://kaleidoscope.readthedocs.io/en/latest/setup_toolchain.html#a-name-arduino-linux-a-install-arduino-on-linux)

Note, if the `MODE="0666"` settings above are not set, you may require root-privileges (sudo) to call the flashing scripts.

Each distribution is different, but on many GNU/Linux systems, udev rules are put in a file in `/etc/udev/rules.d` with a ".rules" extension.

On some systems, you can activate these rules with the following commands:

```sh
udevadm control --reload-rules udevadm trigger
```

Or just restart the computer.

## 4. For Kaleidoscope, join the necessary OS group<a id="sec-3-3"></a>

> ***NOTE:*** You don't need this step if you're flashing the Ergodox EZ or Moonlander.

Once udev is configured, when you plug in the Keyboardio Model 01, a serial device should show up under `/dev/serial/by-id` with a name matching "usb-Keyboardio\_Model\_01\_\*". This is a human-readable symlink pointing to the real device which should be something like `/dev/ttyACM0`. On many systems, this device is group-owned by the "dialout" or the "uucp" group:

In the following example, we can see the device is group-owned by the "dialout" group.

```sh
ls -lL /dev/serial/by-id/usb-Keyboardio_Model_01_*
```

    crw-rw---- 1 root dialout 166, 0 Dec 28 20:09 /dev/serial/by-id/usb-Keyboardio_Model_01_Ckbio01E-if00

On most distributions, the follow commands should work to join a group (substituting `$TTY_GROUP` and `$USERNAME`):

```sh
sudo usermod -a -G $TTY_GROUP $USERNAME
newgrp $TTY_GROUP
```

You should see memberships in the new group with the `groups` command:

```sh
groups | grep dialout
```

    users wheel video dialout docker

## 5. Unplug and replug your keyboard<a id="sec-3-4"></a>

Unplug your keyboard(s) and plug them back in, to make sure everything's set to program. Rebooting your computer is probably overkill, but would probably work too.

## 6. Flash your keyboard<a id="sec-3-5"></a>

There are four scripts provided by this project:

-   `flash-ergodoxez`
-   `flash-model01`
-   `flash-model100`
-   `flash-moonlander`

Calling these scripts without any arguments will flash your respective keyboard with the "shajra" keymap. There is a "&#x2013;factory" switch to flash your keyboard back to a factory default keymap.

If you enabled flakes in your Nix installation, you can run these scripts without installing them. Here's an invocation illustrating doing so with `flash-ergodoxez`:

```sh
nix run github:shajra/shajra-keyboards#flash-ergodoxez
```

    
    Flashing ZSA Technology Lab's Ergodox EZ (custom "shajra" keymap)
    =================================================================
    
    FLASH SOURCE: /nix/store/30yrf298k6y7hs17d819xmr8b6anhij7-qmk-builtin-shajra-src
    FLASH BINARY: /nix/store/bzv89kgfr2yqsbdngm42277qp420d6vz-ergodoxez-builtin-shajra.hex
    
    ⠋ Press the reset button of your keyboard

The same works for the other three flashing scripts. Just replace "flash-ergodoxez" in the invocation above with the script of your choice.

Alternatively, the four flashing scripts are provided at the root of this project. Just clone this repository, and you can call them directly:

```sh
cd $SOME_WORKING_DIR
clone https://github.com/shajra/shajra-keyboards.git
cd shajra-keyboards
./flash-ergodoxez
```

Note, the first time you run the commands described below, you'll see Nix doing a lot of downloading and compiling. After that, subsequent invocations should be quicker with less output.

### Flashing an Ergodox EZ keyboard<a id="sec-3-5-1"></a>

When flashing with `flash-ergodoxez`, you will be prompted to press a reset button. Access this button with an unbent paperclip inserted into the small hole in the top right corner of the right keyboard half.

### Flashing a Moonlander keyboard<a id="sec-3-5-2"></a>

When flashing with `flash-ergodoxez`, you will be prompted to press a reset button. Access this button with an unbent paperclip inserted into the small hole in the top left corner of the left keyboard half.

### Flashing a Keyboardio keyboard<a id="sec-3-5-3"></a>

When flashing with `flash-model100` or `flash-model01`, you will be prompted with instructions to hold down the `Prog` key, and then press `Enter`.

The `Prog` key is hardwired to be the top-left-most key of the Keyboardio Model 01, but the `Enter` key can be remapped. If you forget where the `Enter` has been mapped to on your Keyboard, you can hit `Enter` on another connected keyboard.

# Reverting to the factory default mapping<a id="sec-4"></a>

This project's scripts won't save off your previous keymap from your keyboard. But we can revert to the keymap that your keyboard shipped with.

This can be done with the `-F` / `--factory` switch, which all the flashing scripts support. These scripts have a `-h` / `--help` switch in case you forget your options.

# Customization<a id="sec-5"></a>

## Customizing keymaps<a id="sec-5-1"></a>

The provided code is fairly compact. If you look in the `keymaps` directory, you should find familiar files that you would edit in QMK or Kaleidoscope projects, respectively. These keymaps are compiled into the flashing scripts provided with this project.

For both keyboards, The “shajra” keymap is in its own directory. You can make your own keymaps and put them in a sibling directory with the name of your choice, and they'll be compiled in as well.

If you don't want to use keymaps compiled into the flashing scripts, you can use another directory of keymaps at runtime with the `-K` / `-keymaps` switch.

Then you can use the `-k` / `--keymap` switch of either script to load your custom keymap by the name you chose for the keymap in the "keymaps" directory. The scripts should pick up changes, rebuild anything necessary, and flash your keyboard.

The used keymap source code is copied into `/nix/store`, and the invocation of the flashing scripts will print out a "FLASH SOURCE:" line indicating the source used for compiling/flashing for your reference. These are the full source trees you'd normally use if following the QMK or Kaleidoscope documentation manually.

## Development<a id="sec-5-2"></a>

This project relies heavily on Nix, primarily to help deal with all the complexity of setting up dependencies. The development of this project also relies on an experimental feature of Nix called *flakes*, not required to use the project. See the included [introduction to Nix](doc/nix-introduction.md) if you're new to Nix or flakes.

If you want to check that everything builds before flashing your keyboard, you can build locally everything built by this project's continuous integration:

```sh
tree $(nix build --no-link --print-out-paths) 2>/dev/null
```

    /nix/store/w4s9xdcqvrb1pg90965hzzpf4lxixgag-shajra-keyboards-ci
    ├── build-ergodoxez-builtin-shajra-flash -> /nix/store/fmdkmccwwmil3llbjrikhpr853fag3ap-ergodoxez-builtin-shajra-flash
    ├── build-ergodoxez-builtin-shajra-hex -> /nix/store/bzv89kgfr2yqsbdngm42277qp420d6vz-ergodoxez-builtin-shajra.hex
    ├── build-ergodoxez-factory-flash -> /nix/store/2nphw8ncjd34wb77zq1maip3xlkmj848-ergodoxez-factory-flash
    ├── build-ergodoxez-factory-hex -> /nix/store/v8y8nbsc8f964bab7q4ars30avh80mvj-ergodoxez-factory.hex
    ├── build-model01-builtin-shajra-flash -> /nix/store/rh6b9lq1xfmpx0pgnqsqdi1mc3kfnsap-model01-builtin-shajra-flash
    ├── build-model01-builtin-shajra-hex -> /nix/store/cwxljyfg6lp8lymlgrd64jhsgygnqis8-model01-builtin-shajra-hex
    ├── build-model01-factory-flash -> /nix/store/jl8xj9qq3f4mh5b7m7l2arhk2v2a3bqv-model01-factory-flash
    ├── build-model01-factory-hex -> /nix/store/l3dq1n74my4ppzfzg3sk2s0jchcv1h0n-model01-factory-hex
    ├── build-model100-builtin-shajra-flash -> /nix/store/rjw80na5kky7q058w79syh238srabhsl-model100-builtin-shajra-flash
    ├── build-model100-builtin-shajra-hex -> /nix/store/0if8k8mghbas4k9mpmv5n75wmhkwk56g-model100-builtin-shajra-hex
    ├── build-model100-factory-flash -> /nix/store/c0zw70qx4z3nvjyimdzmv560d1a31yri-model100-factory-flash
    ├── build-model100-factory-hex -> /nix/store/sqy6ngs4bcfggxjnl292wkmv823f4cp2-model100-factory-hex
    ├── build-moonlander-builtin-shajra-flash -> /nix/store/0nlv0y2204ksg68ir39h0sg7z3kmyhcc-moonlander-builtin-shajra-flash
    ├── build-moonlander-builtin-shajra-hex -> /nix/store/js2yvr01sz5zs2k84f6mh3nn208pna0k-moonlander-builtin-shajra.bin
    ├── build-moonlander-factory-flash -> /nix/store/d92zdnx8l2mpx33klrvjnmdjs3lwylfi-moonlander-factory-flash
    ├── build-moonlander-factory-hex -> /nix/store/1206ymbcancln1nqxd7ihv8hpn0ndf81-moonlander-factory.bin
    ├── flash-ergodoxez -> /nix/store/5yzk0yvbza1m12fqaq7zw6r0a1nsz1sg-flash-ergodoxez
    ├── flash-model01 -> /nix/store/fxlhxa7xwlk6ki77fpajzd0hnndai93h-flash-model01
    ├── flash-model100 -> /nix/store/ga16ryxp0ygiwh4zifqyadlhildbvwjr-flash-model100
    ├── flash-moonlander -> /nix/store/nxg135ny2f65zqxjwr3sz103mqipvxky-flash-moonlander
    └── licenses -> /nix/store/6nryh742rmj5xpn8ikgwdlq5xsn9nkr0-shajra-keyboards-licenses
    
    18 directories, 4 files

# Release<a id="sec-6"></a>

The "main" branch of the repository on GitHub has the latest released version of this code. There is currently no commitment to either forward or backward compatibility. However the scripts for compiling/flashing are largely stable and are less likely to change than the “shajra” keymap.

"user/shajra" branches are personal branches that may be force-pushed to. The "main" branch should not experience force-pushes and is recommended for general use.

# License<a id="sec-7"></a>

This project is not a modified work in the traditional sense. It provides scripts the end user runs to make a modified work. Most of the source code modified (QMK, Kaleidoscope, and Model 01) is licensed under either GPLv2 or GPLv3.

If you have Nix installed, then a provided script `licenses-thirdparty` can be run to download all original source used, including license information.

In the spirit of the projects we build upon, all files in this "shajra-keyboards" project are licensed under the terms of GPLv3 or (at your option) any later version.

Please see the [COPYING.md](./COPYING.md) file for more details.

# Contribution<a id="sec-8"></a>

Feel free to file issues and submit pull requests with GitHub. Ideas for how to improve automation are welcome. If you have ideas on how to improve the “shajra” keymap, just make a compelling argument considering the factors that have already gone into [its design](doc/design.md).

There is only one author to date, so the following copyright covers all files in this project:

Copyright © 2019 Sukant Hajra
