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
    EPRM = SAFE_RANGE,
    VRSN
};


const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =
{ [BASE] = LAYOUT_ergodox
    // left hand
    ( KC_CAPS,           KC_1,          KC_2,          KC_3,            KC_4,                  KC_5, _______
    , KC_GRV,            KC_Q,          KC_W,          KC_E,            KC_R,                  KC_T, KC_PGUP
    , LT(MEDIA, KC_TAB), KC_A,          KC_S,          KC_D,            KC_F,                  KC_G
    , LSFT_T(KC_LBRC),   KC_Z,          KC_X,          KC_C,            KC_V,                  KC_B, KC_PGDN
    , KC_APP,            OSM(MOD_RALT), LSFT(KC_RALT), LCTL_T(KC_LEFT), LGUI_T(KC_RIGHT)
    ,                                                                            LT(NUMPAD, KC_ESC), KC_HOME
    ,                                                                                                LSFT(KC_RALT)
    ,                                                         LSFT_T(KC_BSPC), LT(FUNCTION, KC_TAB), LALT_T(KC_DEL)
    // right hand
    , _______, KC_6, KC_7,            KC_8,          KC_9,          KC_0,          TG(NUMPAD)
    , KC_EQL,  KC_Y, KC_U,            KC_I,          KC_O,          KC_P,          KC_BSLS
    ,          KC_H, KC_J,            KC_K,          KC_L,          KC_SCLN,       LT(MOUSE, KC_QUOT)
    , KC_MINS, KC_N, KC_M,            KC_COMM,       KC_DOT,        KC_SLSH,       RSFT_T(KC_RBRC)
    ,                LALT_T(KC_DOWN), RGUI_T(KC_UP), RSFT(KC_RALT), OSM(MOD_RALT), KC_APP
    , KC_END, RCTL_T(KC_GRV)
    , OSM(MOD_RALT)
    , RGUI_T(KC_GRV), LT(FUNCTION, KC_ENT), RSFT_T(KC_SPC)
    )
, [MAC] = LAYOUT_ergodox
    // DESIGN: 2024-02-03: I believe I have found a way to use both Linux and
    // Mac systems to my liking that doesn't require toggling between layers.  I
    // haven't ripped out the layer because I want to try my new base layer on
    // both systems for a little while.  For now, this layer just changes the
    // associated layer lighting, no more.
    //
    // left hand
    ( _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______
    ,                                              _______, _______
    ,                                                       _______
    ,                                     _______, _______, _______
    // right hand
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    ,          _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    ,                   _______, _______, _______, _______, _______
    , _______, _______
    , _______
    , _______, _______, _______
    )
, [FUNCTION] = LAYOUT_ergodox
    // left hand
    ( _______, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   _______
    , _______, KC_EXLM, KC_AT,   KC_LCBR, KC_RCBR, KC_QUOT, KC_HOME
    , _______, KC_CIRC, KC_DLR,  KC_LPRN, KC_RPRN, KC_DQUO
    , _______, KC_HASH, KC_PERC, KC_LBRC, KC_RBRC, KC_GRV,  KC_END
    , _______, _______, _______, KC_LEFT, KC_RGHT
    ,                                        OSM(MOD_LGUI), _______
    ,                                                       _______
    ,                                      KC_BSPC, KC_TAB, KC_DEL
    // right hand
    , TG(MAC), KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  _______
    , KC_PLUS, KC_TILD, KC_AMPR, KC_ASTR, KC_SLSH, KC_BSLS, KC_F11
    ,          KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_COLN, KC_F12
    , KC_UNDS, _______, KC_PIPE, KC_LT,   KC_GT,   KC_QUES, _______
    ,                   KC_DOWN, KC_UP,   _______, _______, _______
    , _______, KC_GRV
    , _______
    , OSM(MOD_RGUI),  KC_ENT,  KC_SPC
    )
, [NUMPAD] = LAYOUT_ergodox
    // left hand
    ( _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______
    , VRSN,    _______, _______, _______, _______, _______, _______
    , QK_BOOT, _______, _______, _______, _______
    ,                                              _______, _______
    ,                                                       _______
    ,                                     _______, _______, _______
    // right hand
    , _______, _______, _______, KC_PAST, KC_PSLS, _______, _______
    , _______, KC_LPRN, KC_7,    KC_8,    KC_9,    KC_RPRN, _______
    ,          KC_BSPC, KC_4,    KC_5,    KC_6,    KC_PPLS, _______
    , _______, KC_0,    KC_1,    KC_2,    KC_3,    KC_PMNS, KC_PEQL
    ,                   KC_DOT,  _______, _______, _______, _______
    , _______, _______
    , _______
    , KC_TAB, _______, _______
    )
, [MEDIA] = LAYOUT_ergodox
    // left hand
    ( _______, _______, _______, _______, _______, _______, _______
    , _______, _______, KC_MRWD, KC_MSTP, KC_MFFD, _______, _______
    , _______, _______, KC_MPRV, KC_MPLY, KC_MNXT, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______
    ,                                              _______, _______
    ,                                                       _______
    ,                                     KC_VOLD, KC_VOLU, KC_MUTE
    // right hand
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    ,          _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    ,                   _______, _______, _______, _______, _______
    , _______, _______
    , _______
    , _______, KC_WBAK, KC_WFWD
    )
, [MOUSE] = LAYOUT_ergodox
    // left hand
    ( _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, MS_UP,   _______, _______, _______
    , _______, _______, MS_LEFT, MS_DOWN, MS_RGHT, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______
    ,                                              _______, _______
    ,                                                       _______
    ,                                     MS_BTN1, MS_BTN2, MS_BTN3
    // right hand
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, MS_WHLU, _______, _______, _______
    ,          _______, MS_WHLL, MS_WHLD, MS_WHLR, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    ,                   _______, _______, _______, _______, _______
    , _______, _______
    , _______
    , _______, MS_BTN4, MS_BTN5
    )
};


bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (record->event.pressed) {
        switch (keycode) {
            case EPRM:
                eeconfig_init();
                return false;
            case VRSN:
                SEND_STRING
                    (     QMK_KEYBOARD
                    "/"   QMK_KEYMAP
                    " @ " QMK_VERSION
                    );
                return false;
            case KC_CAPS:
                if (host_keyboard_led_state().caps_lock) {
                    ergodox_right_led_1_off();
                } else {
                    ergodox_right_led_1_on();
                }
                register_code(KC_CAPS);
                return false;
        }
    }
    return true;
}

// Runs just one time when the keyboard initializes.
void keyboard_post_init_user(void) {
#ifdef RGBLIGHT_COLOR_LAYER_0
    rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
#endif
};

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

// Runs whenever there is a layer state change.
layer_state_t layer_state_set_user(layer_state_t state) {

    if (layer_state_cmp(state, MAC)) {
        ergodox_right_led_2_on();
    } else {
        ergodox_right_led_2_off();
    }

    if (host_keyboard_led_state().caps_lock) {
        ergodox_right_led_1_on();
    } else {
        ergodox_right_led_1_off();
    }

    ergodox_right_led_3_off();

    switch (get_highest_layer(state)) {
        case BASE:
            #ifdef RGBLIGHT_COLOR_LAYER_0
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
            #else
            #ifdef RGBLIGHT_ENABLE
            rgblight_init();
            #endif
            #endif
            break;
        case MAC:
            ergodox_right_led_2_on();
            #ifdef RGBLIGHT_COLOR_LAYER_1
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_1);
            #endif
            break;
        case FUNCTION:
            ergodox_right_led_1_on();
            #ifdef RGBLIGHT_COLOR_LAYER_2
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_2);
            #endif
            break;
        case NUMPAD:
            ergodox_right_led_3_on();
            #ifdef RGBLIGHT_COLOR_LAYER_3
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_3);
            #endif
            break;
        case MEDIA:
            ergodox_right_led_1_on();
            ergodox_right_led_2_on();
            #ifdef RGBLIGHT_COLOR_LAYER_4
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_4);
            #endif
            break;
        case MOUSE:
            ergodox_right_led_2_on();
            ergodox_right_led_3_on();
            #ifdef RGBLIGHT_COLOR_LAYER_5
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_5);
            #endif
            break;
        default:
            break;
    }
    return state;
};
