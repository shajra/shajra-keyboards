- [About the Project](#sec-1)
- [The mappings](#sec-2)
    - [Model 01 "shajra" keymap](#sec-2-0-1)
    - [Ergodox EZ "shajra" keymap (Moonlander similar)](#sec-2-0-2)
- [Using these key mappings](#sec-3)
    - [1. Install Nix on your GNU/Linux distribution](#sec-3-0-1)
    - [2. Set up Cachix](#sec-3-0-2)
    - [3. Make sure your udev rules are set](#sec-3-0-3)
    - [4. For Kaleidoscope, join the necessary OS group](#sec-3-0-4)
    - [5. Unplug and replug your keyboard](#sec-3-0-5)
    - [6. Get the code and run it](#sec-3-0-6)
- [Reverting to the factory default mapping](#sec-4)
- [Customization](#sec-5)
  - [Customizing Keymaps](#sec-5-1)
  - [Development](#sec-5-2)
- [Release](#sec-6)
- [License](#sec-7)
- [Contribution](#sec-8)

[![img](https://github.com/shajra/shajra-keyboards/workflows/CI/badge.svg)](https://github.com/shajra/shajra-keyboards/actions)

# About the Project<a id="sec-1"></a>

This project has the "shajra" keyboard mappings for three ergonomic split keyboards:

-   [Keyboardio's Model 01](https://shop.keyboard.io), programmed with [Kaleidoscope](https://github.com/keyboardio/Kaleidoscope) firmware.
-   [ZSA Technology Labs' Ergodox EZ](https://ergodox-ez.com), programmed with [QMK](https://docs.qmk.fm) firmware
-   [ZSA Technology Labs' Moonlander](https://www.zsa.io/moonlander/), programmed with [QMK](https://docs.qmk.fm) firmware

Beyond the keymap, this project offers some streamlined automation with [Nix](https://nixos.org/nix) that you can use for your own keymap. This automation works for GNU/Linux only (sorry, not MacOS or Windows). See [the provided documentation on Nix](doc/nix.md) for more on what Nix is, why we're motivated to use it, and how to get set up with it for this project.

The rest of this document discusses using this automation. To get the most out of the keymap itself, you may be interested in the [design document](doc/design.md) explaining the motivation behind the mapping.

# The mappings<a id="sec-2"></a>

The "shajra" keymaps for these keyboards are extremely similar, which works out well because the physical layouts of these keyboards are also similar. We can more easily switch from one keyboard to another, and retain the design benefits of the mapping.

### Model 01 "shajra" keymap<a id="sec-2-0-1"></a>

![img](doc/model-01-shajra-layout.png)

### Ergodox EZ "shajra" keymap (Moonlander similar)<a id="sec-2-0-2"></a>

Note the Moonlander keyboard is almost an identical layout to the EZ, and not illustrated here. There are just two two less keys on the thumb cluster. The leads to not having either Home or End on the base layer for the Moonlander. And the "application menu" keycodes are moved to the bottom-outer corners.

![img](doc/ergodox-ez-shajra-layout.png)

# Using these key mappings<a id="sec-3"></a>

This project only supports a GNU/Linux operating system (sorry, not MacOS or Windows) with the [Nix package manager](https://nixos.org/nix) installed.

QMK and Kaleidoscope have build complexities and dependencies that can take a moment to work through. Nix can automate this hassle away by downloading and setting up all the necessary third-party dependencies in a way that

-   is highly reproducible
-   won't conflict with your current system/configuration.

By using Nix, we won't have to worry about downloading QMK or Kaleidoscope, or making sure we have the right version of build tools like Arduino installed, or messing with Git submodules, or setting up environment variables. Nix does all this for us. The provided scripts simplify using Nix even further.

The following steps will get your keyboard flashed.

### 1. Install Nix on your GNU/Linux distribution<a id="sec-3-0-1"></a>

> **<span class="underline">NOTE:</span>** You don't need this step if you're running NixOS, which comes with Nix baked in.

If you don't already have Nix, the official installation script should work on a variety of UNIX-like operating systems. The easiest way to run this installation script is to execute the following shell command as a user other than root:

```shell
curl https://nixos.org/nix/install | sh
```

This script will download a distribution-independent binary tarball containing Nix and its dependencies, and unpack it in `/nix`.

The Nix manual describes [other methods of installing Nix](https://nixos.org/nix/manual/#chap-installation) that may suit you more.

### 2. Set up Cachix<a id="sec-3-0-2"></a>

It's recommended to configure Nix to use shajra.cachix.org as a Nix *substituter*. This project pushes built Nix packages to [Cachix](https://cachix.org) as part of its continuous integration. Once configured, Nix will pull down these pre-built packages instead of building them locally.

You can configure shajra.cachix.org as a substituter with the following command:

```shell
nix run \
    --file https://cachix.org/api/v1/install \
    cachix \
    --command cachix use shajra
```

This will perform user-local configuration of Nix at `~/.config/nix/nix.conf`. This configuration will be available immediately, and any subsequent invocation of Nix commands will take advantage of the Cachix cache.

If you're running NixOS, you can configure Cachix globally by running the above command as a root user. The command will then configure `/etc/nixos/cachix/shajra.nix`, and will output instructions on how to tie this configuration into your NixOS configuration.

### 3. Make sure your udev rules are set<a id="sec-3-0-3"></a>

To program either keyboard with a new mapping, you need to augment your OS configuration with new udev rules.

The following are recommended rules for each keyboard:

    # For Ergodox EZ
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", \
        ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", \
        ENV{MTP_NO_PROBE}="1"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", \
        ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", \
        ATTRS{idProduct}=="04[789B]?", MODE:="0666"
    
    # For Moonlander
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
        MODE:="0666", SYMLINK+="stm32_dfu"
    
    # For Model 01
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2300", \
        SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", \
        ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2301", \
        SYMLINK+="model01", ENV{ID_MM_DEVICE_IGNORE}:="1", \
        ENV{ID_MM_CANDIDATE}:="0", TAG+="uaccess", TAG+="seat"

These settings should correspond to the official documentation of tools and libraries used by this project:

-   [QMK documentation for configuring Halfkey bootloader used by the Ergodox EZ](https://docs.qmk.fm/#/flashing?id=halfkay)
-   [Teensy CLI documentation, used internally for flashing the Ergodox EZ](https://www.pjrc.com/teensy/loader_cli.html)
-   [Wally CLI, used internally for flashing the Moonlander](https://github.com/zsa/wally/blob/master/dist/linux64/50-wally.rules)
-   [Kaleidoscope documentation](https://kaleidoscope.readthedocs.io/en/latest/setup_toolchain.html#a-name-arduino-linux-a-install-arduino-on-linux)

Each distribution is different, but on many GNU/Linux systems, udev rules are put in a file in `/etc/udev/rules.d` with a ".rules" extension.

On some systems, you can activate these rules with the following commands:

```shell
udevadm control --reload-rules udevadm trigger
```

Or just restart the computer.

### 4. For Kaleidoscope, join the necessary OS group<a id="sec-3-0-4"></a>

> ***NOTE:*** You don't need this step if you're flashing the Ergodox EZ or Moonlander.

Once udev is configured, when you plug in the Keyboardio Model 01, a serial device should show up under `/dev/serial/by-id` with a name matching "usb-Keyboardio\_Model\_01\_\*". This is a human-readable symlink pointing to the real device which should be something like `/dev/ttyACM0`. On many systems, this device is group-owned by the "dialout" or the "uucp" group:

In the following example, we can see the device is group-owned by the "dialout" group.

```shell
ls -lL /dev/serial/by-id/usb-Keyboardio_Model_01_*
```

    crw-rw---- 1 root dialout 166, 0 Dec 28 20:09 /dev/serial/by-id/usb-Keyboardio_Model_01_Ckbio01E-if00

On most distributions, the follow commands should work to join a group (substituting `$TTY_GROUP` and `$USERNAME`):

```shell
sudo usermod -a -G $TTY_GROUP $USERNAME
newgrp $TTY_GROUP
```

You should see memberships in the new group with the `groups` command:

```shell
groups | grep dialout
```

    users wheel video dialout docker

### 5. Unplug and replug your keyboard<a id="sec-3-0-5"></a>

Unplug your keyboard(s) and plug them back in, to make sure everything's set to program. Rebooting your computer is probably overkill, but would probably work too.

### 6. Get the code and run it<a id="sec-3-0-6"></a>

Clone this code base and go into the directory:

```shell
cd $SOME_WORKING_DIR
clone https://github.com/shajra/shajra-keyboards.git
cd shajra-keyboards
```

Note, the first time you run the commands described below, you'll see Nix doing a lot of downloading and compiling. After that, subsequent invocations should be quicker with less output.

1.  Flashing an Ergodox EZ keyboard

    You can run the following to flash your Ergodox EZ with the new keymap, pressing the reset button when prompted (access the reset button with an unbent paperclip inserted into the small hole in the top right corner of the right keyboard half):
    
    ```shell
    ./flash-ergodoxez
    ```
    
        
        Flashing ZSA Technology Lab's Ergodox EZ (custom "shajra" keymap)
        =================================================================
        
        FLASH SOURCE: /nix/store/8drs78jm19qax3y6z4irpq52nxvd0nfw-qmk-custom-shajra-src
        FLASH BINARY: /nix/store/70apchb7c6nhdlyaq3p2sf14nwlpvxd5-ergodoxez-custom-shajra.hex
        
        Teensy Loader, Command Line, Version 2.1
        Read "/nix/store/70apchb7c6nhdlyaq3p2sf14nwlpvxd5-ergodoxez-custom-shajra.hex": 22594 bytes, 70.0% usage
        Waiting for Teensy device...
         (hint: press the reset button)

2.  Flashing a Moonlander keyboard

    You can run the following to flash your Moonlander with the new keymap, pressing the reset button when prompted (access the reset button with an unbent paperclip inserted into the small hole in the top left corner of the left keyboard half):
    
    ```shell
    ./flash-moonlander
    ```
    
        
        Flashing ZSA Technology Lab's Moonlander (custom "shajra" keymap)
        =================================================================
        
        FLASH SOURCE: /nix/store/nifk1m0rch0ld2yv9fmdhd7njhq4anl4-qmk-custom-shajra-src
        FLASH BINARY: /nix/store/a30vj554xl76jxm3mdmqsfnf7yfmac3x-moonlander-custom-shajra.bin
        
        ⠋ Press the reset button of your keyboard.

3.  Flashing a Keyboardio Model 01 keyboard

    You can run the following to flash your Keyboardio Model 01, holding down the `Prog` key and then pressing `Enter` when prompted:
    
    ```shell
    ./flash-model01
    ```
    
        
        Flashing Keyboardio's Model 01 (custom "shajra" keymap)
        =======================================================
        
        FLASH SOURCE: /nix/store/s3b3ff9r6w7jnvcbgb7a9f28acavvv1c-model01-custom-shajra-src
        FLASH BINARY: /nix/store/hvykhbfy7d8lfyj75zspgmqb0qjwx8mj-model01-custom-shajra-hex
        DETECTED PORT: /dev/ttyACM0
        
        To flash your keyboard, you must hold down the 'Prog' key.
        While holding the 'Prog' key, press 'Enter', but continue to
        hold the 'Prog' key.  You can release it once flashing has
        started, and the key glows red.
        
        Do these steps now, or Ctrl-C to quit...
    
    The `Prog` key is hardwired to be the top-left-most key of the Keyboardio Model 01, but the `Enter` key can be remapped. If you forget where the `Enter` has been mapped to on your Keyboard, you can hit `Enter` on another connected keyboard.

# Reverting to the factory default mapping<a id="sec-4"></a>

This project's scripts won't save off your previous keymap from your keyboard. But we can revert to the keymap that your keyboard shipped with.

This can be done with the `-F` / `--factory` switch, which all the flashing scripts support. These scripts have a `-h` / `--help` switch in case you forget your options.

# Customization<a id="sec-5"></a>

## Customizing Keymaps<a id="sec-5-1"></a>

The provided code is fairly compact. If you look in the `keymaps` directory, you should find familiar files that you would edit in QMK or Kaleidoscope projects, respectively. These keymaps are compiled into the flashing scripts provided with this project.

For both keyboards, The "shajra" keymap is in its own directory. You can make your own keymaps and put them in a sibling directory with the name of your choice, and they'll be compiled in as well.

If you don't want to use keymaps compiled into the flashing scripts, you can use another directory of keymaps at runtime with the `-K` / `-keymaps` switch.

Then you can use the `-k` / `--keymap` switch of either script to load your custom keymap by the name you chose for the keymap in the "keymaps" directory. The scripts should pick up changes, rebuild anything necessary, and flash your keyboard.

The used keymap source code is copied into `/nix/store`, and the invocation of the flashing scripts will print out a "FLASH SOURCE:" line indicating the source used for compiling/flashing for your reference. These are the full source trees you'd normally use if following the QMK or Kaleidoscope documentation manually.

## Development<a id="sec-5-2"></a>

This project relies heavily on Nix, primarily to help deal with all the complexity of setting up dependencies.

The [provided documentation on Nix](doc/nix.md) introduces Nix and how to use it in the context of this project.

If you want to check that everything builds before flashing your keyboard, you can build locally everything built by this project's continuous integration:

```shell
nix build --no-link --file nix/ci.nix \
    && nix path-info --file nix/ci.nix
```

    /nix/store/06wl9nphb0prdwch3py1722a03ypzlj3-ergodoxez-factory-flash
    /nix/store/0yxwixfgk651kwqnjxhfamp9fjcws66j-flash-ergodoxez
    /nix/store/10p3sla3gy65h70zka42dyw9hfqmqfjp-moonlander-custom-shajra-flash
    /nix/store/691l77fzy5ckhbynyj6p6i6s4w88gn8v-ergodoxez-custom-shajra-flash
    /nix/store/70apchb7c6nhdlyaq3p2sf14nwlpvxd5-ergodoxez-custom-shajra.hex
    /nix/store/8h40ppyd83nhff8v9fj1vq7g06acr58h-moonlander-factory-flash
    /nix/store/a30vj554xl76jxm3mdmqsfnf7yfmac3x-moonlander-custom-shajra.bin
    /nix/store/bsis29fb2gx9dnaz8d5a1k8qik42fs2a-model01-factory-flash
    /nix/store/d41whymrh6fa2xi112lpq1hg2z8v2swn-moonlander-factory.bin
    /nix/store/h5l4618sgq7p1jcccpag6kwvdcc8k3lz-ergodoxez-factory.hex
    /nix/store/hmqycz5rfb3qs1l5ncnw84c2bqjic424-model01-factory-hex
    /nix/store/hvykhbfy7d8lfyj75zspgmqb0qjwx8mj-model01-custom-shajra-hex
    /nix/store/lxg681wki06hhsnq88lx3k0snnp5pxxm-flash-moonlander
    /nix/store/r143pkmcdqxsnjikd2l7li5zf44znz84-shajra-keyboards-licenses
    /nix/store/y921d1qkmprsmbswax55nj2v8rsra7l9-model01-custom-shajra-flash
    /nix/store/yavkns1a7g2d3ha6487vf4dhc13b5y6l-flash-model01

# Release<a id="sec-6"></a>

The "master" branch of the repository on GitHub has the latest released version of this code. There is currently no commitment to either forward or backward compatibility. However the scripts for compiling/flashing are largely stable and are less likely to change than the "shajra" keymap.

"user/shajra" branches are personal branches that may be force-pushed to. The "master" branch should not experience force-pushes and is recommended for general use.

# License<a id="sec-7"></a>

This project is not a modified work in the traditional sense. It provides scripts the end user runs to make a modified work. Most of the source code modified (QMK, Kaleidoscope, and Model 01) is licensed under either GPLv2 or GPLv3.

If you have Nix installed, then a provided script `licenses-thirdparty` can be run to download all original source used, including license information.

In the spirit of the projects we build upon, all files in this "shajra-keyboards" project are licensed under the terms of GPLv3 or (at your option) any later version.

Please see the [COPYING.md](./COPYING.md) file for more details.

# Contribution<a id="sec-8"></a>

Feel free to file issues and submit pull requests with GitHub. Ideas for how to improve automation are welcome. If you have ideas on how to improve the "shajra" keymap, just make a compelling argument considering the factors that have already gone into [its design](doc/design.md).

There is only one author to date, so the following copyright covers all files in this project:

Copyright © 2019 Sukant Hajra
