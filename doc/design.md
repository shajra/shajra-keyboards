# Design of the "shajra" Keymap

This document discusses the rationale for the keymapping for the Ergodox EZ and
Model 01 keyboards.

It seems a waste to have a nice ergonomic split keyboard, only to program it
with a keymap full of ergonomic setbacks.  The number of possible mappings can
be overwhelming.  We could just choose something, good or bad, and iterate on it
as we think of improvements.  This though can be a tedious process because we
have to train through the inconvenience of muscle memory to really assess how
well a mapping is working out.  And we have to be diligent not to confuse
familiarity with ergonomic improvement.

To help deal with this problem, the "shajra" keymap is built upon a few guiding
principles and constraints.  Ideally, these principles and constraints would
hone in on exactly one solution.  Unfortunately, reality is not that tidy,
though the options do narrow down a bit.

Keyboard customization is very personal, so it's very common to end up with your
own keymap.  Maybe this one can work for you, possibly with a few tweaks.

**Contents:**

<!--ts-->
* [Principles and assumptions](#principles-and-assumptions)
* [The keymaps](#the-keymaps)
   * [Model 01 "shajra" keymap](#model-01-shajra-keymap)
   * [Ergodox EZ "shajra" keymap](#ergodox-ez-shajra-keymap)
* [Ergodox EZ keyboard modifications](#ergodox-ez-keyboard-modifications)
* [Principle-guided decisions](#principle-guided-decisions)
   * [Core QWERTY layout](#core-qwerty-layout)
   * [Using Mod-Tap and Qukeys](#using-mod-tap-and-qukeys)
   * [No One-Shot Modifiers (OSM)](#no-one-shot-modifiers-osm)
   * [Working around a problem with Mod-Tap and Qukeys](#working-around-a-problem-with-mod-tap-and-qukeys)
   * [Mapping modifiers](#mapping-modifiers)
   * [Mapping more non-modifiers](#mapping-more-non-modifiers)
   * [Mapping the function layer](#mapping-the-function-layer)
<!--te-->

## Principles and assumptions

Here's a list of some guiding principles that have some cascading consequences
of how we can map keys.

- Prioritize ergonomics over typing speed, though speeds shouldn't be slow.
- Satisfy the needs of typing both prose and computer programs.
- Reward [Vim][VIM]-style application keybindings.
- Typing too fast or slowly should not cause typos from timing problems.
- What mode/state the keyboard is in should be extremely simple and predictable.
- All reasonable modifier combinations should be possible, most ergonomically.
- Paired keys should be adjacent, or symmetrically laid out.
- If no other factors matter, lean on familiarity with common layouts.
- The keymapping should support the entry of Unicode characters, but English
  will be the dominant language typed.

Additionally, there's a few physical assumptions that factor into some
decisions:

- The author has larger hands, which means some keys are assumed reachable that
  may not be for everyone.
- For the Ergodox EZ, the author has modified the switches and keycaps to make
  more keys accessible by thumb keypresses.

[VIM]: https://www.vim.org

## The keymaps

For reference, below are diagrams of the keymaps for the Ergodox EZ and 
Model 01.  The following holds for both diagrams:

- Black labels represent the `Base` layer.
- Blue labels represent the `Function` layer.
- Red labels represent the `Num Pad` layer.
- Yellow keys should be pressed by thumbs or palms.
- Beige keys are core keys accessed easily by fingers.
- The lower-right corner label shows the modifier accessed by holding a key
  (other labels reference keycodes accessed by tapping).
- Mac's left and right `Command`/`⌘` modifiers are the same keycodes as the left
  and right "Windows key" modifiers, and we collectively call them "OS".
- Mac's left and right `Option`/`⌥` modifier both have the same keycode as `Left
  Alt`.
- The [`Alt Gr` modifier][ALTGR] is used for entering Unicode characters, which
  we emulate with `Right Alt` as is common on many operating systems.
- The `⎄` icon represents a [`Compose` key][COMPOSE], also used for entering
  Unicode characters, which we emulate with `Shift + Right Alt` as is common
  with many GNU/Linux distributions.
- The `Media` and `Mouse` layers are not shown in these diagrams to avoid
  clutter.

[COMPOSE]: https://en.wikipedia.org/wiki/Compose_key
[ALTGR]: https://en.wikipedia.org/wiki/AltGr_key

### Model 01 "shajra" keymap

!["shajra" keymap for Model 01](./model-01-shajra-layout.png)

### Ergodox EZ "shajra" keymap

!["shajra" keymap for Ergodox EZ](./ergodox-ez-shajra-layout.png)

## Ergodox EZ keyboard modifications

There's two problems one might find with the stock Ergodox EZ keyboard (that the
Model 01 doesn't seem to have):

- some of the bottom row keys (the yellow keys assigned arrow keycodes in the
  diagram above) are more easily accessible by thumbs, but the provided keycaps
  may not well accomodate thumb presses

- the 2u keycaps in the thumb cluster tend to bind with offset keypresses (the
  Ergodox EZ doesn't have stabilizers on any keys).

Fortunately, the Ergodox EZ allows for easy customization of not only keycaps,
but also switches (without soldering).

By replacing the switches with something a smoother and lighter switch like 
[Zilent 62g switches][ZILENT], we can reduce the likelihood of binding.

To further reduce binding, the 2u keycaps of the thumb cluster can be replaced
with 1.5u keycaps.  Another benefit, the 1.5u keycap leaves a gap between it and
any keycap right above it, which makes it easier to press a 1u key above without
accidentally pressing the 1.5u key below.  This gap is illustrated in the
Ergodox diagram above.

If your Ergodox EZ shipped with DSA (unsculptured) keycaps, you may find you can
conveniently press all the the yellow keys in the keymap diagram with your
thumbs.  If your Ergodox EZ shipped with DCS (sculptured) keycaps, you will
likely find the bottom "row 4" keys sculptured too sharply for comfortable thumb
presses.  Replacing these keycaps is recommended to use the "shajra" keymap.

[Signature Plastics][KEYCAPS] is a popular place to get alternate keycaps.  If
you do get keycaps from a third party like Signature Plastics, consider the G20
keycaps, which work well for thumb presses because of their low profile and
rounded edges.

[ZILENT]: https://zealpc.net/products/zilents
[KEYCAPS]: https://pimpmykeyboard.com/key-cap-family-specs/

## Principle-guided decisions

Here's a few decisions that fell from the principles mentioned earlier.

### Core QWERTY layout

Alternative layouts may have some merits, but the author isn't yet ready for the
time commitment to learn a new layout for what may only be a small improvement
in typing speed or ergonomic comfort.

Furthermore, the most common ergonomic layouts like Colemak or Dvorak move the
`h`, `j`, `k`, and `l` keys used by Vim-style keybindings for navigation.  These
days there's a lot of applications that use Vim-style keybindings, and it's too
much work to rebind them all at the application level.

For keys easily reached by fingers (the beige keys in our diagrams), we'll use a
QWERTY layout.  This includes letters, numbers, and also `,`, `.`, `/`, and `;`.

If we really want something like Colemak or Dvorak we could implement it later
as a layer to toggle to/from.  But QWERTY will be the base.

### Using Mod-Tap and Qukeys

With the Ergodox EZ and Model 01, we get new keys that can get much more utility
from our thumbs/palms, which are sturdier than any of our fingers.  Our
thumbs/palms get home keys of their own.  This is an central feature of both
keyboards.

In traditional keyboards, commonly pressed keys like `Enter` and `Shift` are
pressed by pinky fingers (the hand's weakest), and are not close to home keys.
So they are great candidates to move towards the new thumb/palm home keys made
available.

To capitalize on these thumb/palm keys, We can use QMK's [Mod-Tap][MODTAP] or
Kaleidoscope's [Qukey][QUKEY] features to allow each key to share both a
modifier and a non-modifier keycode.  The modifier is accessed when holding the
key, and the non-modifier when tapping the key.  In our diagrams, the modifier
of a Mod-Tap/Qukey-enhanced key is labeled in the lower-right corner.  The other
labels indicate other keycodes sharing the key.

[MODTAP]: https://docs.qmk.fm/#/feature_advanced_keycodes?id=mod-tap
[QUKEY]: https://github.com/keyboardio/Kaleidoscope/blob/master/doc/plugin/Qukeys.md

Mod-Tap/Qukey is not good for every key, though.  It can lead to some typos when
typing fast, especially with a hint of rollover that can register as an
accidental hold.  For this reason, it's not good to use it with normal
alphanumeric keys.  So we won't use Mod-Tap for our core QWERTY keys (the beige
keys).

### No One-Shot Modifiers (OSM)

Thus far, we've presumed that modifiers need to be oriented such that we can
expressively and ergonomically chord them.  However, [Kaleidoscope's OneShot
plugin][OSM-K] and [QMK's One-Shot feature][OSM-QMK] allow us to use tapping to
emulate holding a modifier.

Unfortunately, One-Shot is incompatible with Mod-Tap/Qukeys, which we've
reasoned above will help us get more keycodes closer to our thumb/palm home
keys.

This is a point of design tension.  Some would argue that chording increases the
likelihood of repetitive stress injury.  Traditional keyboards put a lot of the
stress on pinky fingers by having them hold keys while stretching from their
home position.  A One-Shot approach removes the need for holding the keys, but
may not necessarily move the key to a better location.  The pinky finger may
still need to stretch for the keypress.

The "shajra" keymap instead uses Mod-Tap/Qukeys to reduce the need not only
hold, but even stretch our pinkies to farther keys.   It does this not only for
modifiers (like `Shift` and `Ctrl`), but also common keycodes (like `Tab`,
`Esc`, `Enter`, and `Backspace`).  The key-sharing of Mod-Tap/Qukeys allows us
to map all of these to our thumbs/palms.  With One-Shot, without keycodes
sharing keys, we will invariably have some of these commonly used keycodes spill
into the outer keys stretched to by our pinkies.  With Mod-Tap/Qukeys, we
generally shouldn't find our pinkies having to reach beyond the beige keys in
our diagrams.

For these reasons, we'll mostly avoid One-Shot, and prefer Mod-Tap/Qukeys
instead.

[OSM-QMK]: https://docs.qmk.fm/features/feature_advanced_keycodes#one-shot-keys
[OSM-K]: https://github.com/keyboardio/Kaleidoscope/blob/master/doc/plugin/OneShot.md

### Working around a problem with Mod-Tap and Qukeys

With Kaleidoscope, when we use Qukeys, we lose the ability to hold a key and
have it repeat (because holding a key registers as the modifier sharing the key
instead).  Some keys like `Space` and `Backspace` can be annoying to use without
a repeating hold.

QMK has a feature where you can tap a Mod-Tap key quickly before holding it to
have it register as a repeating hold.  Unfortunately, this can lead to typos
when typing quickly.  For instance, if we assigned `Space` and `Shift` to the
same key, then if we typed a space too quickly right before shifting (say for a
capital letter), Mod-Tap can easily register it as a repeating space instead.
As mentioned in [the principles](#principles-and-assumptions) earlier in this
document, we don't want to have these kinds of timing problems.

Fortunately, there's a workaround.  We can use the `Function` layer to overlay
on top of any keycode that can't repeat, the same keycode for repeating.  So in
our example, if we collocated `Space` and `Shift` in the same key with
Mod-Tap/Qukey, but used our workaround, we could chord and hold `Function+Space`
to get repeating `Space`.  This workaround seems manageable for the few common
keys we have collocated with modifiers using Mod-Tap/Qukeys.

The "shajra" keymap uses this workaround, and you can see it used for the thumb
keys in the keymap diagrams above for both the Ergodox EZ and the Model 01.

### Mapping modifiers

The modifiers below have been ordered from most frequently used to least:

| Keycode          | Commonly used icons   |
| ---------------- | --------------------- |
| `Shift`          | `⇧`                   |
| `Function`/`Fn`  | `ƒ`                   |
| `Win`/`Cmd`/`OS` | `❖`/`⌘`               |
| `Ctrl`           | `✲`                   |
| `Alt`/`Option`   | `⎇`/`⌥`               |
| `Media`          |                       |
| `Mouse`          |                       |
| `Alt Gr`         |                       |

Though the order above is subjective to a degree, the `Shift` and `Fn` modifiers
are more obviously used the most.  We'll want these modifiers near our thumb
home keys so that when typing prose we stay in one position as much as possible.

Note that we'll want the same modifier on both the left and right keyboard
halves.  We get a more comfortable reach with the fingers of one hand, when
using the thumb of the other hand for a modifier.

Furthermore, we sometimes need two modifiers for chording, and have to use both
hands.  If the two modifiers we need were only on the same split, we'd be out of
luck with only one thumb per hand.

Three-modifier chording does happen, but we only support such chords where one
of the three modifiers is a `Shift`.  This is why we have `Shift` modifiers not
just on thumb keys, but also in their traditional outer keys.  Thumbs of each
hand would press the other two modifiers, while one of the pinkies presses a
`Shift`.

There are a few other chords not ergonomically supported.  If we have two
modifiers of `Alt`, `OS`, or `Ctrl`, combined with a non-modifier of `Del`,
`Space`, or `Enter`, all of these keys are on thumb keys a laid out in the
"shajra" keymap (and we only have two thumbs!).  But these chords shouldn't be
too common (despite including the famous `Ctrl+Alt+Del`).  If they do arise, we
can for a moment move one of our hands from home position to press the modifiers
we need with our fingers, while pressing the non-modifier with the other hand.

Having the same modifier on both sides also allows us an occasional one-handed
chording if our other hand is off the keyboard.  To further support one-handed
chording, we want the `Ctrl`, `Alt`, and `OS` keys pressed by thumbs.  Note that
when pressing one of the yellow keys with our thumbs, all fingers are free to
press a key.  If we use a pinky finger for a modifier, then then other keys
normally depressed by the pinky are unavailable for a one-handed chord.  The
same is true for any of our fingers.  More chords are available for one-handed
chording when we use our thumbs for modifiers.

You'll notice in the "shajra" keymap that the modifiers line the bottom keys
pressed by thumbs/keys and wrapping around to some modifiers accesses by pinky
fingers.  The mouse and media layers are designed to be used while chording with
a pinky modifier.  Fortunately, we don't access these layers too often, so our
pinky fingers shouldn't get too fatigued.

For the most part the modifiers are laid out symmetrically, with one exception.
We swap the `Alt` and `OS` keys.  We do this because the inner-most thumb keys
are a little bit of a stretch for holding a modifier key.  So we try to balance
the load across two modifiers.

### Mapping more non-modifiers

Because we've decided to support chording with Mod-Tap/Qukeys, we want our base
layer to have all the keys commonly used for applications keybinds.  Otherwise,
when chording, we also need the `Fn` modifier.  Of the keys on a full 104-key
keyboard, we may not have room for the function keys, the numpad, and some less
used keys like `Print Screen`, `Scroll Lock`, and `Pause`.  But we should have
the rest on our base layer.

The following non-modifier keycodes below have been ordered from most frequently
used to least:

| Keycode                    | Commonly used icons | Notes on usage                                          |
| -------------------------- | --------------- | ----------------------------------------------------------- |
| `Space`                    | `␣`             | essential for all tasks                                     |
| `Backspace`                | `⌫`             | essential for all tasks (mistakes happen)                   |
| `Enter`                    | `⏎`             | essential for all tasks                                     |
| `'`                        |                 | apostrophes common in text, but historically next to `;`    |
| `Esc`                      | `⎋`             | essential for Vim-style keybinds                            |
| `Tab`                      | `↹`             | very useful for shell/programming tab-complete              |
| `-`/`=`                    |                 | CLI switches, "zoom" keybindings, common in programming     |
| `Left`/`Right`/`Down`/`Up` | `⬅`/`➡`/`⬇`/`⬆` | very useful in a variety of contexts                        |
| ``` ` ```                  |                 | common in "markdown" languages for verbatim text            |
| `Page Down`/`Page Up`      | `⇟`/`⇞`         | useful when reading a large page                            |
| `Home`/`End`               | `↖`/`↘`         | useful for navigating text fields                           |
| `[`/`]`                    |                 | occurs occasionally when programming                        |
| `\`                        |                 | used for delimiting and more commonly shifted to get a `\|` |
| `Insert`/`Delete`          | `⎀`/`⌦`         | occasionally useful (`Shift-Insert` for pasting)            |

This ording is subjective to some degree, and certainly context-sensitive.
However it's generally accepted how often `Space`, `Backspace`, and `Enter` are
used.  

The distance from a home position of these keys should correspond to how useful
they are.

Also, we've tried to keep naturally paired keys either adjacent, or
symmetrically balanced across the two keyboard halves.

### Mapping the function layer

There's a few ways to lay out keycodes in the function layer.  Here's some
reasoning for how the keycodes on the function layer are mapped:

| Keycode                    | Notes on placement                                     |
| -------------------------- | ------------------------------------------------------ |
| `!`, `@`, `&`, `*`         | placed below their counterparts on the base layer      |
| `^`/`$`                    | paired for their usage within regular expressions      |
| `#`/`%`                    | paired for their usage in Shell parameter substitution |
| `Home`/`End`               | above `Page Up` and `Page Down` as navigation keys     |
| `(`/`)`, `[`/`]`, `{`/`}`  | balanced enclosing marks are paired                    |
| ``` ` ```, `'`, `"`        | quotes are adjacent                                    |
| `Left`/`Right`/`Down`/`Up` | placed above `h`/`j`/`k`/`l` for Vim-style navigation  |
| `~`/`/`                    | adjacent because home directories are prefixed "~/"    |
| `+`, ```_```, `<`, `>`, `?`, `:` | placed such that `Function` is the same as `Shift`  |

Regarding the last item in this table, some keys already exist from our base
layer with shifting, but it's nice to have all our symbols on one layer, so we
don't have to toggle between switching between shifting the base layer and the
function layer (for example, this occurs with common [Haskell][HASKELL]
operators like ```<*>```, and `<$>`.

[HASKELL]: https://haskell.org
