- [Principles and assumptions](#principles_and_assumptions)
- [The keymaps](#sec-2)
    - [Model 01 "shajra" keymap](#sec-2-0-1)
    - [Ergodox EZ "shajra" keymap](#sec-2-0-2)
    - [Reading the keymap diagrams](#sec-2-0-3)
- [Ergodox EZ keyboard modifications](#sec-3)
- [Principle-guided decisions](#sec-4)
    - [Core QWERTY layout](#sec-4-0-1)
    - [Using Mod-Tap and Qukeys](#sec-4-0-2)
    - [Avoid One-Shot Modifiers (OSM)](#sec-4-0-3)
    - [Working around a problem with Mod-Tap and Qukeys](#sec-4-0-4)
    - [Mapping modifiers](#sec-4-0-5)
    - [More on `Alt Gr` and `Compose`](#altgr_and_compose)
    - [Mapping more non-modifiers](#sec-4-0-7)
    - [Mapping the Function layer](#sec-4-0-8)
    - [Swapping `GUI` and `Alt` mappings](#sec-4-0-9)
    - [Media and Mouse layers](#sec-4-0-10)

This document discusses the rationale of the "shajra" keymap for the Ergodox EZ and Model 01 keyboards.

It seems a waste to have a nice ergonomic split keyboard, only to program it with a keymap full of ergonomic setbacks. The number of possible mappings can be overwhelming. We could just choose something, good or bad, and iterate on it as we think of improvements. This though can be a tedious process because we have to train through the inconvenience of muscle memory to really assess how well a mapping is working out. And we have to be diligent not to confuse familiarity with ergonomic improvement.

To help deal with this problem, the "shajra" keymap is built upon a few guiding principles and constraints. Ideally, these principles and constraints would hone in on exactly one solution. Unfortunately, reality is not that tidy, though the options do narrow down a bit.

Keyboard customization is very personal, so it's common to end up with your own keymap. Maybe this one can work for you, possibly with a few tweaks.

# Principles and assumptions<a id="principles_and_assumptions"></a>

Here's a list of some guiding principles that have some cascading impact on how we can map keys.

-   Prioritize ergonomics over typing speed, though speeds shouldn't be slow.
-   Satisfy the needs of typing both prose and computer programs.
-   Reward [Vim](https://www.vim.org)-style application keybindings.
-   Typing too fast or slowly should not cause typos from timing problems.
-   What mode/state the keyboard is in should be extremely simple and predictable.
-   All reasonable modifier combinations should be possible, most ergonomically.
-   Paired keys should be adjacent or symmetrically laid out.
-   Support convenient one-handed use where possible
-   If no other factors apply, lean on familiarity with common layouts.
-   The keymapping should support the entry of non-standard characters, but English will be the dominant language typed.

Additionally, there's a few physical assumptions that factor into some decisions:

-   The original author has larger hands, which means some keys are assumed reachable that may not be for everyone.
-   For the Ergodox EZ, the original author has also modified the switches and keycaps to make more keys accessible by thumb keypresses.

# The keymaps<a id="sec-2"></a>

For reference, below are diagrams of the keymaps for the Model 01 and Ergodox EZ.

### Model 01 "shajra" keymap<a id="sec-2-0-1"></a>

![img](./model-01-shajra-layout.png)

### Ergodox EZ "shajra" keymap<a id="sec-2-0-2"></a>

![img](./ergodox-ez-shajra-layout.png)

### Reading the keymap diagrams<a id="sec-2-0-3"></a>

1.  Coloring

    -   Black labels represent the Base layer.
    -   Blue labels represent the Function layer.
    -   Red labels represent the Num Pad layer.
    -   Yellow keys should be easily pressed by thumbs or palms.
    -   Beige keys are core keys easily pressed by fingers.

2.  Modifiers

    -   The lower-right corner label on some keys shows the modifier accessed by holding it (other labels reference keycodes accessed by tapping).
    -   The "Shift," "Ctrl," and "GUI" labels represent "Left" or "Right" keycodes, respective to which keyboard half they are on.
    -   For both halves, the keycode represented by the "Alt" label is for only the `Left Alt` keycode.
    -   The following labels represent keycodes used for entering characters beyond a typical US/English keyboard:
        -   The "Alt Gr" label represents a [`Alt Graph` modifier](https://en.wikipedia.org/wiki/AltGr_key), which we emulate with the `Right Alt` keycode.
        -   The "⎄" label represents a [`Compose` key](https://en.wikipedia.org/wiki/Compose_key), which we emulate with `Shift + Right Alt`.
    -   The Media and Mouse layers are not shown in these diagrams to avoid clutter.
    
    Note that we've given some special treatment to the right and left `Alt` keycodes. This is explained more [later](#altgr_and_compose).

# Ergodox EZ keyboard modifications<a id="sec-3"></a>

There's two problems one might find with the stock Ergodox EZ keyboard (that the Model 01 doesn't seem to have):

-   four of the bottom row keys (the yellow keys assigned arrow keycodes in the diagram above) are more easily accessible by thumbs, but the provided keycaps may not well accomodate thumb presses

-   the 2u keycaps in the thumb cluster tend to bind with offset keypresses (the Ergodox EZ doesn't have stabilizers on any keys).

Fortunately, the Ergodox EZ allows for easy customization not only of keycaps, but also switches (without soldering).

By replacing the switches with something smoother and lighter like [Zilent 62g switches](https://zealpc.net/products/zilents), we can reduce the likelihood of binding.

To further reduce binding, the 2u keycaps of the thumb cluster can be replaced with 1.5u keycaps. Another benefit, the 1.5u keycap leaves a gap between it and any keycap right above it, which makes it easier to press a 1u key above without accidentally pressing the 1.5u key below. This gap is illustrated in the Ergodox EZ diagram above.

If your Ergodox EZ shipped with DSA (unsculptured) keycaps, you may find you can conveniently press all the yellow keys in the keymap diagram with your thumbs. If your Ergodox shipped with DCS (sculptured) keycaps, you will likely find four bottom row keys (mentioned earlier) sculptured too sharply for comfortable thumb presses. Replacing these keycaps is recommended to use the "shajra" keymap.

[Signature Plastics](https://pimpmykeyboard.com/key-cap-family-specs) is a popular place to get alternate keycaps. If you do get keycaps from a third party like Signature Plastics, consider the G20 keycaps, which work well for thumb presses because of their low profile and rounded edges.

# Principle-guided decisions<a id="sec-4"></a>

Here's a few decisions that fell from the principles mentioned earlier.

### Core QWERTY layout<a id="sec-4-0-1"></a>

Alternative layouts may have some merits, but the time commitment to learn a new layout seems steep for what may only be a small improvement in typing speed or ergonomic comfort.

Furthermore, the most common ergonomic layouts like Colemak or Dvorak move the `h`, `j`, `k`, and `l` keys used by Vim-style keybindings for navigation. These days there's a lot of applications that use Vim-style keybindings, and it's too much work to rebind them all at the application level.

For keys easily reached by fingers (the beige keys in our diagrams), we'll use a QWERTY layout. This includes letters, numbers, and also `,`, `.`, `/`, and `;`.

If we really want something like Colemak or Dvorak we could implement it later as a layer to toggle to/from. But QWERTY will be the base.

### Using Mod-Tap and Qukeys<a id="sec-4-0-2"></a>

With the Ergodox EZ and Model 01, we get new keys that can get much more utility from our thumbs/palms, which are sturdier than any of our fingers. Our thumbs/palms get home keys of their own (the Model 01 even has physical homing bumps on its thumb keys). These keys are a central feature of both keyboards.

In traditional keyboards, commonly pressed keys like `Enter` and `Shift` are pressed by pinky fingers (the hand's weakest), and are not close to home keys. These keys are great candidates to move towards the new thumb/palm home keys made available.

To further capitalize on these thumb/palm keys, We can use QMK's [Mod-Tap](https://docs.qmk.fm/#/mod_tap) or Kaleidoscope's [Qukey](https://kaleidoscope.readthedocs.io/en/latest/plugins/Qukeys.html) features to allow each key to share both a modifier and a non-modifier keycode. The modifier is accessed when holding the key, and the non-modifier when tapping the key. In our diagrams, the modifier of a Mod-Tap/Qukey-enhanced key is labeled in its lower-right corner. The key's other labels indicate other keycodes sharing the key.

Mod-Tap/Qukey is not good for every key, though. It can lead to some typos when typing fast, especially with a hint of rollover that can register as an accidental hold. For this reason, it's not good to use it with normal alphanumeric keys. So we won't use Mod-Tap for our core QWERTY keys (the beige keys).

### Avoid One-Shot Modifiers (OSM)<a id="sec-4-0-3"></a>

Thus far, we've presumed that modifiers need to be oriented such that we can expressively and ergonomically chord them. However, [Kaleidoscope's OneShot plugin](https://kaleidoscope.readthedocs.io/en/latest/plugins/OneShot.html) and [QMK's One-Shot feature](https://docs.qmk.fm/#/one_shot_keys) allow us to use tapping to emulate holding a modifier.

Unfortunately, One-Shot is incompatible with Mod-Tap/Qukeys, which we've reasoned above will help us get more keycodes closer to our thumb/palm home keys.

This is a point of design tension. Some would argue that chording increases the likelihood of repetitive stress injury. Traditional keyboards put a lot of the stress on pinky fingers by having them hold keys while stretching from their home position. A One-Shot approach removes the need for holding the keys, but may not necessarily move the key to a better location. The pinky finger may still need to stretch for the keypress.

The "shajra" keymap instead uses Mod-Tap/Qukeys to reduce not only the need to hold, but even to stretch our pinkies to farther keys. It does this not only for modifiers (like `Shift` and `Ctrl`), but also common keycodes (like `Tab`, `Esc`, `Enter`, and `Backspace`). The key-sharing of Mod-Tap/Qukeys allows us to map all of these to our thumbs/palms. With One-Shot, without keycodes sharing keys, we will invariably have some of these commonly used keycodes spill into the outer keys stretched to by our pinkies. With Mod-Tap/Qukeys, we generally shouldn't find our pinkies having to reach beyond the beige keys in our diagrams.

For these reasons, we'll mostly avoid One-Shot, and prefer Mod-Tap/Qukeys instead.

### Working around a problem with Mod-Tap and Qukeys<a id="sec-4-0-4"></a>

With Kaleidoscope, when we use Qukeys, we lose the ability to hold a key and have it repeat (because holding a key registers as the modifier sharing the key instead). Some keys like `Space` and `Backspace` can be annoying to use without a repeating hold.

QMK has a feature where you can tap a Mod-Tap key quickly before holding it to have it register as a repeating hold. Unfortunately, this can lead to typos when typing quickly. For instance, if we assigned `Space` and `Shift` to the same key, then if we typed a space too quickly right before shifting (say for a capital letter), Mod-Tap will register the hold as a repeating space instead. As mentioned in [our principles](#principles_and_assumptions) earlier in this document, we don't want to have these kinds of timing problems.

Fortunately, there's a workaround. We can use the Function layer to overlay on top of any keycode that can't repeat, the same keycode for repeating. So in our example, if we collocated `Space` and `Shift` in the same key with Mod-Tap/Qukey, but used our workaround, we could chord and hold `Function+Space` to get a repeating space. This workaround seems manageable for the few common keys we have collocated with modifiers using Mod-Tap/Qukeys.

The "shajra" keymap uses this workaround, and you can see it used for the thumb keys in the keymap diagrams above for both the Ergodox EZ and the Model 01.

### Mapping modifiers<a id="sec-4-0-5"></a>

The modifiers below have been ordered from most frequently used to least:

| Modifier   | Other common keyboard labels |
|---------- |---------------------------- |
| `Shift`    | `⇧`                          |
| `Function` | `Fn`                         |
| `GUI`      | `Win` `Cmd` `❖` `⌘`          |
| `Ctrl`     | `✲`                          |
| `Alt`      | `Option` `⎇` `⌥`             |
| `Media`    |                              |
| `Mouse`    |                              |
| `Alt Gr`   |                              |

Though the order above is subjective to a degree, the `Shift` and `Function` modifiers are more obviously used the most. We'll want these modifiers near our thumb home keys so that when typing prose we stay in one position as much as possible.

Note that we'll want each modifier on both the left and right keyboard halves. We get a more comfortable reach with the fingers of one hand, when using the thumb of the other hand for a modifier. And we want to be able to modify keys on either half with similar ease.

Furthermore, we sometimes need two modifiers for chording, and have to use both hands. If the two modifiers we need were only on the same split, we'd be out of luck with only one thumb per hand.

Three-modifier chording does happen, but we only support such chords where one of the three modifiers is a `Shift`. This is why we have `Shift` modifiers not just on thumb keys, but also in their traditional outer keys. Thumbs of each hand would press the other two modifiers, while one of the pinkies presses a `Shift`.

There are a few other chords not ergonomically supported. If we have two modifiers of `Alt`, `GUI`, or `Ctrl`, combined with a non-modifier of `Del`, `Space`, or `Enter`, all of these keys are on thumb keys as laid out in the "shajra" keymap (and we only have two thumbs!). But these chords shouldn't be too common (despite including the famous `Ctrl+Alt+Del`). If they do arise, we can for a moment move one of our hands from home position to press the modifiers we need with our fingers, while pressing the non-modifier with the other hand.

Having the same modifier on both sides also allows us an occasional one-handed chording if our other hand is off the keyboard. To further support one-handed chording, we want the `Ctrl`, `Alt`, and `GUI` keys pressed by thumbs. Note that when pressing one of the yellow keys with our thumbs, all fingers are free to press a key. If we use a pinky finger for a modifier, then then other keys normally depressed by the pinky are less available for a one-handed chord. The same is true for any of our fingers. More chords are ergonomically available for one-handed chording in a home position when we use our thumbs for modifiers.

You'll notice in the "shajra" keymap that the modifiers line the bottom keys pressed by thumbs/keys and wrapping around to some modifiers accessed by pinky fingers. The Mouse and Media layers are designed to be used while chording with a pinky modifier. Fortunately, we don't access these layers too often, so our pinky fingers shouldn't get too fatigued.

For the most part the modifiers are laid out symmetrically, with one exception. One half swaps the `Alt` and `GUI` locations of the other half. We do this because the inner-most thumb keys are a little bit of a stretch for holding a modifier key. So we try to balance the load across two modifiers.

### More on `Alt Gr` and `Compose`<a id="altgr_and_compose"></a>

Historically, some keyboards targetting an international audience provide a [`Alt Graph` (`Alt Gr`) modifier](https://en.wikipedia.org/wiki/AltGr_key) where a `Right Alt` key would be (and thus only one `Alt` key on the left side). With this modifier some operating systems would support entry of a variety of currency and language symbols (such as "€" or "ä") beyond those on a standard US/English keyboard.

On Macs, both left and right `Option` (`⌥`) keys help enter alternate symbols similarly to an `Alt Gr` key. And keyboards that emit the `Alt` keycodes are interpretted by Macs as an `Option` keycodes.

On GNU/Linux and Windows, the `Right Alt` keycode can be configured to serve as an `Alt Gr` key, leaving the `Left Alt` available for user/application/OS keybinding.

Under the assumption that the `Right Alt` modifier may be used (as an `Alt Gr` key) differently from the `Left Alt` modifier, the "shajra" keymap puts each on both the right and left sides. This way we can retain the benefits of having the same modifier on both sides as we have for all our other modifiers.

The "shajra" keymap makes this `Alt Gr` keys a One-Shot Modifier (OSM), to make it easier to use. Note that due to limited space on the Model 01, the `Right Alt` (`Alt Gr`) keycode is placed in the Function layer. Hopefully as an OSM, this modifier will still be convenient enough, despite being in a Function layer.

Note that on GNU/Linux, `Shift+Right Alt` is often configured to be a [`Compose` (`⎄`) key](https://en.wikipedia.org/wiki/Compose_key), which serves a similar function to an `Alt Gr` key. The major difference is that `Compose` keys are one-shot (tapped, not held) by nature, and therefore not a traditional modifier.

Because they are similar in function, the `Alt Gr` and `Compose` keys are placed adjacent to one another in both Model 01 and Ergodox EZ "shajra" keymaps.

### Mapping more non-modifiers<a id="sec-4-0-7"></a>

Because we've decided to support chording with Mod-Tap/Qukeys, we want our Base layer to have all the keys commonly used for applications keybinds. Otherwise, when chording, we also need the `Function` modifier. Of the keys on a full 104-key keyboard, we may not have room for the function keys, the numpad, and some less used keys like `Print Screen`, `Scroll Lock`, and `Pause`. But we should have the rest on our Base layer.

The following non-modifier keycodes below have been ordered from most frequently used to least:

| Keycode                    | Commonly used icons | Notes on usage                                             |
|-------------------------- |------------------- |---------------------------------------------------------- |
| `Space`                    | `␣`                 | essential for all tasks                                    |
| `Backspace`                | `⌫`                 | essential for all tasks (mistakes happen)                  |
| `Enter`                    | `⏎`                 | essential for all tasks                                    |
| `'`                        |                     | apostrophes common in text, but historically next to `;`   |
| `Esc`                      | `⎋`                 | essential for Vim-style keybinds                           |
| `Tab`                      | `↹`                 | very useful for shell/programming tab-complete             |
| `-` `=`                    |                     | CLI switches, "zoom" keybindings, common in programming    |
| `Left` `Right` `Down` `Up` | `⬅` `➡` `⬇` `⬆`     | very useful in a variety of contexts                       |
| `` ` ``                    |                     | common in "markdown" languages for verbatim text           |
| `Page Down` `Page Up`      | `⇟` `⇞`             | useful when reading a large page                           |
| `[` `]`                    |                     | occurs occasionally when programming                       |
| `\`                        |                     | used for delimiting and more commonly shifted to get a `\` |
| `Insert` `Delete`          | `⎀` `⌦`             | occasionally useful (`Shift-Insert` for pasting)           |
| `Home` `End`               | `↖` `↘`             | useful for navigating text fields                          |

This ordering is subjective to some degree, and certainly context-sensitive. However `Space`, `Backspace`, and `Enter` are obviously used more than the rest.

To increase ergonomics the "shajra" keymap maps the keycodes above in order of usefulness, first to good thumb keys, then good index finger keys, and lastly pinky keys. There is one notable exception, though. The single quote `'` key in a QWERTY layout has a history of placement next to the semicolon `;` key. And for many touch typers, this is deeply ingrained in memory. The pinky does not stretch far to reach this key, so we'll continue to place `'` there. And as an alternative, the single quote is also in our Function layer.

Also, we've tried to keep naturally paired keys either adjacent, or symmetrically balanced across the two keyboard halves.

### Mapping the Function layer<a id="sec-4-0-8"></a>

There's a few ways to lay out keycodes in the Function layer. Here's some reasoning for how the keycodes on the Function layer are mapped in the "shajra" keymap:

| Keycode                    | Notes on placement                                              |
|-------------------------- |--------------------------------------------------------------- |
| `!` `@` `&` `*`            | placed a row below their shifted counterparts on the Base layer |
| `^` `$`                    | adjacent for their usage within regular expressions             |
| `#` `%`                    | adjacent for their usage in Shell parameter substitution        |
| `Home` `End`               | over the Base layer's `Page Up` and `Page Down`                 |
| `(` `)` `[` `]` `{` `}`    | balanced enclosing marks are adjacent                           |
| `` ` `` `'` `"`            | all these quotes are adjacent                                   |
| `Left` `Down` `Up` `Right` | placed above `h`, `j`, `k`, and `l` for Vim-style navigation    |
| `~` `/`                    | adjacent because home directories are prefixed "~/"             |
| `+` `_` `<` `>` `?` `:`    | placed such that `Function` is the same as `Shift`              |

Regarding the last item in this table, some keys already exist from our Base layer with shifting, but it's nice to have all our symbols on one layer, so we don't have to toggle between switching between shifting the Base layer and toggling the Function layer (for example, this occurs with programming operators such as `<*>`, and `<$>`).

### Swapping `GUI` and `Alt` mappings<a id="sec-4-0-9"></a>

For different operating systems, we want to have a modifier to set user-specific custom key bindings. We might even want to have similar operations between different operating systems. For instance, we might have user-specific keybindings for window management to have a consistent experience between different operating systems. But we don't want these keybindings to overlap with useful default OS/application-level keybindings.

On Macs, the `Option` (`⌥`) key is used less frequently for default OS/application keybindings than `Cmd` (`⌘`) or `Ctrl`. So the `Left Alt` keycode is good to use as a user/custom modifier, since it's interpretted as `Left Option` key by Macs.

On GNU/Linux and Windows, the `Super` (`Windows`) key is used less frequently for default OS/application keybinding than `Ctrl` or `Alt`. So the `Left GUI` keycode is good to use as a user/custom modifier, since it's interpretted as a `Left Super` (`Left Windows`) key. However, Macs interpret this keycode as `Cmd` (`⌘`), which conflicts with very common keybindings (`⌘-c` or `⌘-v` for copy/paste, for instance).

If we put our custom keybindings on the `GUI` keycode for GNU/Linux and Windows operating systems, and if we put similar keybindings on the `Alt` keycode for Macs, then it can be useful to swap the locations of these two modifiers when switching between operating systems. This way, similar keybinds retain the same location our on Ergodox EZ and Model 01 keyboards.

This is why the "shajra" keymap provides a key to swap the `GUI` and `Left Alt` keycode locations.

### Media and Mouse layers<a id="sec-4-0-10"></a>

This project doesn't provide diagrams of the Media or Mouse layers, but hopefully you can follow the code for these layers in the respective code for the [Ergodox EZ](https://github.com/shajra/shajra-keyboards/blob/master/ergodox_ez/keymaps/shajra/keymap.c#L103-L143) and the [Model 01](https://github.com/shajra/shajra-keyboards/blob/master/model_01/keymaps/shajra/Model01-Firmware.ino#L106-L138).

For both layers, while holding a pinky to enter the layer, the layer offers some keys laid out in a directional orientation, accessed by fingers. Some thumb keys are also used. These layers were more creatively laid out, but hopefully they are intuitive enough to commit to memory.
