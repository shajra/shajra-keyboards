#include QMK_KEYBOARD_H
#include "version.h"


enum layers {
    BASE,
    MAC,
    FUNCTION,
    NUMPAD,
    MEDIA,
    MOUSE
};

enum custom_keycodes {
    VRSN = SAFE_RANGE,
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =
{ [BASE] = LAYOUT_moonlander
    ( KC_CAPS,           KC_1, KC_2, KC_3, KC_4, KC_5, RGB_MOD, /**/ RGB_RMOD, KC_6, KC_7, KC_8,    KC_9,   KC_0,    TG(NUMPAD)
    , KC_GRV,            KC_Q, KC_W, KC_E, KC_R, KC_T, KC_PGUP, /**/ KC_EQL,   KC_Y, KC_U, KC_I,    KC_O,   KC_P,    KC_BSLS
    , LT(MEDIA, KC_TAB), KC_A, KC_S, KC_D, KC_F, KC_G, KC_PGDN, /**/ KC_MINS,  KC_H, KC_J, KC_K,    KC_L,   KC_SCLN, LT(MOUSE, KC_QUOT)
    , LSFT_T(KC_LBRC),   KC_Z, KC_X, KC_C, KC_V, KC_B,          /**/           KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, RSFT_T(KC_RBRC)

    , KC_APP, OSM(MOD_RALT), LSFT(KC_RALT), LCTL_T(KC_LEFT), LGUI_T(KC_RIGHT),                LT(NUMPAD, KC_ESC)
    ,                        RCTL_T(KC_GRV),                 LALT_T(KC_DOWN),  RCTL_T(KC_UP), RSFT(KC_RALT), OSM(MOD_RALT), KC_APP

    , LSFT_T(KC_BSPC), LT(FUNCTION, KC_TAB), LALT_T(KC_DEL), /**/ RGUI_T(KC_INS), LT(FUNCTION, KC_ENT), RSFT_T(KC_SPC)
    )
, [MAC] = LAYOUT_moonlander
    // DESIGN: 2024-02-03: I believe I have found a way to use both Linux and
    // Mac systems to my liking that doesn't require toggling between layers.  I
    // haven't ripped out the layer because I want to try my new base layer on
    // both systems for a little while.  For now, this layer just changes the
    // associated layer lighting, no more.
    ( _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______,          /**/          _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______,          _______, /**/ _______,          _______, _______, _______, _______, _______
    ,                                     _______, _______, _______, /**/ _______, _______, _______
    )
, [FUNCTION] = LAYOUT_moonlander
    ( RGB_VAI, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   RGB_TOG, /**/ TG(MAC), KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  _______
    , RGB_VAD, KC_EXLM, KC_AT,   KC_LCBR, KC_RCBR, KC_QUOT, KC_HOME, /**/ KC_PLUS, KC_TILD, KC_AMPR, KC_ASTR, KC_SLSH, KC_BSLS, KC_F11
    , RGB_HUI, KC_CIRC, KC_DLR,  KC_LPRN, KC_RPRN, KC_DQUO, KC_END,  /**/ KC_UNDS, KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_COLN, KC_F12
    , RGB_HUD, KC_HASH, KC_PERC, KC_LBRC, KC_RBRC, KC_GRV,           /**/          _______, KC_PIPE, KC_LT,   KC_GT,   KC_QUES, _______
    , _______, _______, _______, KC_LEFT, KC_RGHT,    OSM(MOD_LGUI), /**/ KC_GRV,           KC_DOWN, KC_UP,   _______, _______, _______
    ,                                       KC_BSPC, KC_TAB, KC_DEL, /**/ OSM(MOD_RGUI), KC_ENT, KC_SPC
    )
, [NUMPAD] = LAYOUT_moonlander
    ( _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, KC_PAST, KC_PSLS, _______, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, KC_LPRN, KC_7,    KC_8,    KC_9,    KC_RPRN, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, KC_BSPC, KC_4,    KC_5,    KC_6,    KC_PPLS, _______
    , VRSN,    _______, _______, _______, _______, _______,          /**/          KC_0,    KC_1,    KC_2,    KC_3,    KC_PMNS, KC_PEQL
    , QK_BOOT, _______, _______, _______, _______,          _______, /**/ _______,          KC_DOT,  _______, _______, _______, _______
    ,                                     _______, _______, _______, /**/ KC_TAB,  _______, _______
    )
, [MEDIA] = LAYOUT_moonlander
    ( _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, KC_MRWD, KC_MSTP, KC_MFFD, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, KC_MPRV, KC_MPLY, KC_MNXT, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______,          /**/          _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______,          _______, /**/ _______,          _______, _______, _______, _______, _______
    ,                                     KC_VOLD, KC_VOLU, KC_MUTE, /**/ _______, KC_WBAK, KC_WFWD
    )
, [MOUSE] = LAYOUT_moonlander
    ( _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, KC_MS_U, _______, _______, _______, /**/ _______, _______, _______, KC_WH_U, _______, _______, _______
    , _______, _______, KC_MS_L, KC_MS_D, KC_MS_R, _______, _______, /**/ _______, _______, KC_WH_L, KC_WH_D, KC_WH_R, _______, _______
    , _______, _______, _______, _______, _______, _______,          /**/          _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______,          _______, /**/ _______,          _______, _______, _______, _______, _______
    ,                                     KC_BTN1, KC_BTN2, KC_BTN3, /**/ _______, KC_BTN4, KC_BTN5
    )
};

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (record->event.pressed) {
        switch (keycode) {
            case VRSN:
                SEND_STRING
                    (     QMK_KEYBOARD
                    "/"   QMK_KEYMAP
                    " @ " QMK_VERSION
                    );
                return false;
            case KC_CAPS:
                if (host_keyboard_led_state().caps_lock) {
                    ML_LED_1(false);
                    ML_LED_4(false);
                } else {
                    ML_LED_1(1);
                    ML_LED_4(1);
                }
                register_code(KC_CAPS);
                return false;
        }
    }
    return true;
}

// DESIGN: the small LEDs are just always on.  This is useful because it's good
// to always have some indication if the "MAC" layer is on, even if the RGB
// lighting for the keys is disabled.  The LEDs are far less distracting than
// the RGB lighting.
//
void matrix_init_user(void)
{
    keyboard_config.led_level = 1;
    eeconfig_update_kb(keyboard_config.raw);
    layer_state_set_kb(layer_state);
};

// DESIGN: RGB lighting combines a background with one of two possible overlays.
//
// The background RGB lighting is the stock patterns QMK provides (rainbow
// effects, heat sink, etc.).
//
// Here's controls for just the background RGB lighting:
//
//     RGB_TOG: toggle background RGB background lighting on/off
//     RGB_MOD: cycle between different patterns (there's a lot)
//     RGB_HUI: move forward in hue cycle
//     RGB_HUD: move backward in hue cycle
//     RGB_VAI: increase brightness
//     RGB_VAD: decrease brightness
//
// This just lays down a background lighting.  On top of this background, we can
// toggle layer-based lighting with TOGGLE_LAYER_COLOR.  This toggles between
// the following modes:
//
//     - lighting of a visible row of keys when the capslock is enabled
//
//     - lighting the blocks of keys when available for the NUMPAD, MEDIA, and
//       MOUSE layers.
//
// Also, note that the hue and brightness controls don't affect the hue or
// brightness of the overlays, which are hardcoded at a medium brightness.
//
// RGB index-to-location mapping:
//
//   0  5 10 15 20 25 29          65 61 56 51 46 41 36
//   1  6 11 16 21 26 30          66 62 57 52 47 42 37
//   2  7 12 17 22 27 31          67 63 58 53 48 43 38
//   3  8 13 18 23 28                64 59 54 49 44 39
//   4  9 14 19 24    35          71    60 55 50 45 40
//                 32 33 34    70 69 68
//
#ifdef RGB_MATRIX_ENABLE

#define SOLARIZED_YELLOW    (RGB){181, 137, 0}
#define SOLARIZED_ORANGE    (RGB){203, 75,  22}
#define SOLARIZED_RED       (RGB){220, 50,  47}
#define SOLARIZED_MAGENTA   (RGB){211, 54,  130}
#define SOLARIZED_VIOLET    (RGB){108, 113, 196}
#define SOLARIZED_BLUE      (RGB){38,  139, 210}
#define SOLARIZED_CYAN      (RGB){42,  161, 152}
#define SOLARIZED_GREEN     (RGB){113, 173, 0}

RGB dimmed(RGB color) {
    uint8_t brightness = rgb_matrix_get_val();
    return (RGB){
        color.r * brightness / 255,
        color.g * brightness / 255,
        color.b * brightness / 255};
}

void set_color(int index, RGB rgb_color) {
    return rgb_matrix_set_color(
        index,
        rgb_color.r,
        rgb_color.g,
        rgb_color.b);
}

#define RGB_MATRIX_SET_THUMBS(color) \
    set_color(32, color); \
    set_color(33, color); \
    set_color(34, color); \
    set_color(35, color); \
    set_color(68, color); \
    set_color(69, color); \
    set_color(70, color); \
    set_color(71, color)

#define RGB_MATRIX_SET_LEFT_INNER_KEYS(color) \
    set_color(29, color); \
    set_color(30, color); \
    set_color(31, color)

#define RGB_MATRIX_SET_RIGHT_INNER_KEYS(color) \
    set_color(65, color); \
    set_color(66, color); \
    set_color(67, color)

#define RGB_MATRIX_SET_OUTER_KEYS(color) \
    set_color( 0, color); \
    set_color( 1, color); \
    set_color( 2, color); \
    set_color( 3, color); \
    set_color( 4, color); \
    set_color( 9, color); \
    set_color(14, color); \
    set_color(19, color); \
    set_color(24, color); \
    set_color(36, color); \
    set_color(37, color); \
    set_color(38, color); \
    set_color(39, color); \
    set_color(40, color); \
    set_color(45, color); \
    set_color(50, color); \
    set_color(55, color); \
    set_color(60, color)

bool is_caps_lock_on(void) {
    led_t led_state = host_keyboard_led_state();
    return led_state.caps_lock;
}

bool is_oneshot_on(void) {
    uint8_t osm = get_oneshot_mods();
    return osm & MOD_MASK_CSAG;
}

bool rgb_dirty = false;

void rgb_cleanup(void) {
    if (rgb_matrix_is_enabled()) {
        if (rgb_dirty) {
            rgb_matrix_set_color_all(RGB_OFF);
            rgb_dirty = false;
        }
    }
}

bool rgb_matrix_indicators_user(void) {
    if (! rgb_matrix_is_enabled()) {
        return false;  // false indicates QMK to not process further
    }
    if (   layer_state_cmp(layer_state, NUMPAD)
        || layer_state_cmp(layer_state, MEDIA)
        || layer_state_cmp(layer_state, MOUSE)
        || is_caps_lock_on()
        || is_oneshot_on()) {
        rgb_matrix_set_color_all(RGB_OFF);
        rgb_dirty = true;
    } else {
        rgb_cleanup();
        return true;
    }
    if (layer_state_cmp(layer_state, NUMPAD)) {
        RGB color = dimmed(SOLARIZED_RED);
        set_color(42, color);
        set_color(43, color);
        set_color(44, color);
        set_color(45, color);
        set_color(47, color);
        set_color(48, color);
        set_color(49, color);
        set_color(50, color);
        set_color(52, color);
        set_color(53, color);
        set_color(54, color);
        set_color(55, color);
        set_color(57, color);
        set_color(58, color);
        set_color(59, color);
        set_color(60, color);
        set_color(63, color);
    }
    if (layer_state_cmp(layer_state, MEDIA)) {
        RGB color  = dimmed(SOLARIZED_GREEN);
        set_color(11, color);
        set_color(12, color);
        set_color(16, color);
        set_color(17, color);
        set_color(21, color);
        set_color(22, color);
        //
        set_color(32, color);
        set_color(33, color);
        set_color(34, color);
        //
        set_color(68, color);
        set_color(69, color);
    }
    if (layer_state_cmp(layer_state, MOUSE)) {
        RGB color = dimmed(SOLARIZED_VIOLET);
        set_color(12, color);
        set_color(16, color);
        set_color(17, color);
        set_color(22, color);
        //
        set_color(32, color);
        set_color(33, color);
        set_color(34, color);
        //
        set_color(48, color);
        set_color(52, color);
        set_color(53, color);
        set_color(58, color);
        //
        set_color(68, color);
        set_color(69, color);
    }
    if (is_caps_lock_on()) {
        RGB_MATRIX_SET_LEFT_INNER_KEYS(dimmed(SOLARIZED_ORANGE));
    }
    if (is_oneshot_on()) {
        RGB_MATRIX_SET_RIGHT_INNER_KEYS(dimmed(SOLARIZED_ORANGE));
    }
    return true;
}

#endif

// DESIGN: The left-side LEDs are light up identically to the right-side ones.
// It's a bit hard to know whether I'll have an easier view of the small LEDs on
// the right half or the left half.
//
// These LEDs indicate the highest layer enabled, even if RGB lighting is
// toggled off.
//
//   LED indices on left half:  1, 2, 3
//   LED indices on right half: 4, 5, 6
//
//   MAC:           o * o  (2, 5)
//   FUNCTION/CAPS: * o o  (1, 4)
//   NUMPAD:        o o *  (3, 6)
//   MEDIA:         * * o  (1, 2, 4, 5)
//   MOUSE:         o * *  (2, 3, 5, 6)

layer_state_t layer_state_set_user(layer_state_t state) {

    ML_LED_2(layer_state_cmp(state, MAC));
    ML_LED_5(layer_state_cmp(state, MAC));
    ML_LED_1(host_keyboard_led_state().caps_lock);
    ML_LED_4(host_keyboard_led_state().caps_lock);
    ML_LED_3(false);
    ML_LED_6(false);

    switch (get_highest_layer(state)) {
        case MAC:
            ML_LED_2(1);
            ML_LED_5(1);
            break;
        case FUNCTION:
            ML_LED_1(1);
            ML_LED_4(1);
            break;
        case NUMPAD:
            ML_LED_3(1);
            ML_LED_6(1);
            break;
        case MEDIA:
            ML_LED_1(1);
            ML_LED_2(1);
            ML_LED_4(1);
            ML_LED_5(1);
            break;
        case MOUSE:
            ML_LED_2(1);
            ML_LED_3(1);
            ML_LED_5(1);
            ML_LED_6(1);
            break;
        default:
            break;
    }

    return state;
}
