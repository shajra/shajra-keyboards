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
    ( KC_CAPS,           KC_1, KC_2, KC_3, KC_4, KC_5, RGB_TOG, /**/ TG(MAC), KC_6, KC_7, KC_8,    KC_9,   KC_0,    TG(NUMPAD)
    , KC_GRV,            KC_Q, KC_W, KC_E, KC_R, KC_T, KC_PGUP, /**/ KC_EQL,  KC_Y, KC_U, KC_I,    KC_O,   KC_P,    KC_BSLS
    , LT(MEDIA, KC_TAB), KC_A, KC_S, KC_D, KC_F, KC_G, KC_PGDN, /**/ KC_MINS, KC_H, KC_J, KC_K,    KC_L,   KC_SCLN, LT(MOUSE, KC_QUOT)
    , LSFT_T(KC_LBRC),   KC_Z, KC_X, KC_C, KC_V, KC_B,          /**/          KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, RSFT_T(KC_RBRC)

    , KC_APP, OSM(MOD_RALT), LSFT(KC_RALT), LCTL_T(KC_LEFT), LGUI_T(KC_RIGHT), LT(NUMPAD, KC_DEL)
    ,                                         KC_INS, LALT_T(KC_DOWN), RCTL_T(KC_UP), RSFT(KC_RALT), OSM(MOD_RALT), KC_APP

    , LSFT_T(KC_BSPC), LT(FUNCTION, KC_TAB), LALT_T(KC_ESC), /**/ RGUI_T(KC_GRV), LT(FUNCTION, KC_ENT), LSFT_T(KC_SPC)
    )
, [MAC] = LAYOUT_moonlander
    ( _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______,          /**/          _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, LALT_T(KC_RIGHT), _______, /**/ _______,  RGUI_T(KC_DOWN), _______, _______, _______, _______
    ,                              _______, _______, LGUI_T(KC_ESC), /**/ LALT_T(KC_GRV), _______, _______
    )
, [FUNCTION] = LAYOUT_moonlander
    ( RGB_MOD, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   TOGGLE_LAYER_COLOR
    ,                                                                /**/ EE_CLR,  KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  RESET
    , RGB_HUI, KC_EXLM, KC_AT,   KC_LCBR, KC_RCBR, KC_QUOT, KC_HOME, /**/ KC_PLUS, _______, KC_AMPR, KC_ASTR, KC_TILD, KC_SLSH, KC_F11
    , RGB_HUD, KC_CIRC, KC_DLR,  KC_LPRN, KC_RPRN, KC_DQUO, KC_END,  /**/ KC_UNDS, KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_COLN, KC_F12
    , RGB_VAI, KC_HASH, KC_PERC, KC_LBRC, KC_RBRC, KC_GRV,           /**/          KC_BSLS, KC_PIPE, KC_LT,   KC_GT,   KC_QUES, _______
    , RGB_VAD, _______, _______, KC_LEFT, KC_RGHT,          KC_DEL,  /**/ _______,          KC_DOWN, KC_UP,   _______, _______, VRSN
    ,                                     KC_BSPC, KC_TAB,  KC_ESC,  /**/ KC_GRV,  KC_ENT,  KC_SPC
    )
, [NUMPAD] = LAYOUT_moonlander
    ( _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, _______, KC_7,    KC_8,    KC_9,    KC_MINS, _______
    , _______, _______, _______, _______, _______, _______, _______, /**/ _______, KC_BSPC, KC_4,    KC_5,    KC_6,    KC_PLUS, _______
    , _______, _______, _______, _______, _______, _______,          /**/          _______, KC_1,    KC_2,    KC_3,    KC_EQL,  _______
    , _______, _______, _______, _______, _______,          _______, /**/ _______,          KC_0,    KC_DOT,  KC_ASTR, KC_SLSH, _______
    ,                                     _______, _______, _______, /**/ _______, _______, _______
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
//     - lighting the bottom and outer rows of both halves a solid color
//       indicating the highest enabled layer
//
//     - lighting the blocks of keys when available for the NUMPAD, MEDIA, and
//       MOUSE layers.
//
// Technically, this means that the RGB lighting can never be 100% disabled, but
// when toggling off both RGB_TOG and TOGGLE_LAYER_COLOR, the only remaining
// lighting is from NUMPAD, MEDIA, and MOUSE usage, which is generally not that
// common.
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

#define RGB_DIM_RED    160,   0,   0
#define RGB_DIM_ORANGE 140,  70,   0
#define RGB_DIM_YELLOW 130, 100,   0
#define RGB_DIM_GREEN    0, 160,   0
#define RGB_DIM_BLUE     0,  70, 130
#define RGB_DIM_INDIGO   0,   0, 170
#define RGB_DIM_VIOLET 130,   0, 120
#define RGB_DIM_OFF      0,   0,   0

#define RGB_MATRIX_SET_INNER_KEYS(color) \
    rgb_matrix_set_color(29, color); \
    rgb_matrix_set_color(30, color); \
    rgb_matrix_set_color(31, color); \
    rgb_matrix_set_color(65, color); \
    rgb_matrix_set_color(66, color); \
    rgb_matrix_set_color(67, color)

#define RGB_MATRIX_SET_OUTER_KEYS(color) \
    rgb_matrix_set_color( 0, color); \
    rgb_matrix_set_color( 1, color); \
    rgb_matrix_set_color( 2, color); \
    rgb_matrix_set_color( 3, color); \
    rgb_matrix_set_color( 4, color); \
    rgb_matrix_set_color( 9, color); \
    rgb_matrix_set_color(14, color); \
    rgb_matrix_set_color(19, color); \
    rgb_matrix_set_color(24, color); \
    rgb_matrix_set_color(36, color); \
    rgb_matrix_set_color(37, color); \
    rgb_matrix_set_color(38, color); \
    rgb_matrix_set_color(39, color); \
    rgb_matrix_set_color(40, color); \
    rgb_matrix_set_color(45, color); \
    rgb_matrix_set_color(50, color); \
    rgb_matrix_set_color(55, color); \
    rgb_matrix_set_color(60, color)

bool is_caps_lock_on(void) {
    led_t led_state = host_keyboard_led_state();
    return led_state.caps_lock;
}

bool rgb_matrix_indicators_user(void) {
    if (keyboard_config.disable_layer_led) {
        switch (rgb_matrix_get_flags()) {
            case LED_FLAG_NONE:
                rgb_matrix_set_color_all(0, 0, 0);
                break;
            default:
                break;
        }
        if (layer_state_cmp(layer_state, NUMPAD)) {
            rgb_matrix_set_color(42, RGB_DIM_RED);
            rgb_matrix_set_color(43, RGB_DIM_RED);
            rgb_matrix_set_color(44, RGB_DIM_RED);
            rgb_matrix_set_color(45, RGB_DIM_RED);
            rgb_matrix_set_color(47, RGB_DIM_RED);
            rgb_matrix_set_color(48, RGB_DIM_RED);
            rgb_matrix_set_color(49, RGB_DIM_RED);
            rgb_matrix_set_color(50, RGB_DIM_RED);
            rgb_matrix_set_color(52, RGB_DIM_RED);
            rgb_matrix_set_color(53, RGB_DIM_RED);
            rgb_matrix_set_color(54, RGB_DIM_RED);
            rgb_matrix_set_color(55, RGB_DIM_RED);
            rgb_matrix_set_color(57, RGB_DIM_RED);
            rgb_matrix_set_color(58, RGB_DIM_RED);
            rgb_matrix_set_color(59, RGB_DIM_RED);
            rgb_matrix_set_color(60, RGB_DIM_RED);
            rgb_matrix_set_color(63, RGB_DIM_RED);
        }
        if (layer_state_cmp(layer_state, MEDIA)) {
            rgb_matrix_set_color(11, RGB_DIM_BLUE);
            rgb_matrix_set_color(12, RGB_DIM_BLUE);
            rgb_matrix_set_color(16, RGB_DIM_BLUE);
            rgb_matrix_set_color(17, RGB_DIM_BLUE);
            rgb_matrix_set_color(21, RGB_DIM_BLUE);
            rgb_matrix_set_color(22, RGB_DIM_BLUE);
            //
            rgb_matrix_set_color(32, RGB_DIM_BLUE);
            rgb_matrix_set_color(33, RGB_DIM_BLUE);
            rgb_matrix_set_color(34, RGB_DIM_BLUE);
            //
            rgb_matrix_set_color(68, RGB_DIM_BLUE);
            rgb_matrix_set_color(69, RGB_DIM_BLUE);
        }
        if (layer_state_cmp(layer_state, MOUSE)) {
            rgb_matrix_set_color(12, RGB_DIM_INDIGO);
            rgb_matrix_set_color(16, RGB_DIM_INDIGO);
            rgb_matrix_set_color(17, RGB_DIM_INDIGO);
            rgb_matrix_set_color(22, RGB_DIM_INDIGO);
            //
            rgb_matrix_set_color(32, RGB_DIM_INDIGO);
            rgb_matrix_set_color(33, RGB_DIM_INDIGO);
            rgb_matrix_set_color(34, RGB_DIM_INDIGO);
            //
            rgb_matrix_set_color(48, RGB_DIM_INDIGO);
            rgb_matrix_set_color(52, RGB_DIM_INDIGO);
            rgb_matrix_set_color(53, RGB_DIM_INDIGO);
            rgb_matrix_set_color(58, RGB_DIM_INDIGO);
            //
            rgb_matrix_set_color(68, RGB_DIM_INDIGO);
            rgb_matrix_set_color(69, RGB_DIM_INDIGO);
        }
    } else {
        switch (biton32(layer_state)) {
            case MAC:
                RGB_MATRIX_SET_OUTER_KEYS(RGB_DIM_GREEN);
                break;
            case FUNCTION:
                RGB_MATRIX_SET_OUTER_KEYS(RGB_DIM_VIOLET);
                break;
            case NUMPAD:
                RGB_MATRIX_SET_OUTER_KEYS(RGB_DIM_RED);
                break;
            case MEDIA:
                RGB_MATRIX_SET_OUTER_KEYS(RGB_DIM_BLUE);
                break;
            case MOUSE:
                RGB_MATRIX_SET_OUTER_KEYS(RGB_DIM_INDIGO);
                break;
            default:
                RGB_MATRIX_SET_OUTER_KEYS(RGB_DIM_YELLOW);
                break;
        }
    }
    if (is_caps_lock_on()) {
        RGB_MATRIX_SET_INNER_KEYS(RGB_DIM_RED);
    }
    return false;
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
