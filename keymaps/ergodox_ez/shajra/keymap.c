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


enum custom_keycodes
{ EPRM = SAFE_RANGE
, VRSN
, RGB_SLD
};


const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =
{ [BASE] = LAYOUT_ergodox
    // left hand
    ( KC_CAPS,           KC_1,          KC_2,          KC_3,            KC_4,                  KC_5, _______
    , KC_GRV,            KC_Q,          KC_W,          KC_E,            KC_R,                  KC_T, KC_PGUP
    , LT(MEDIA, KC_TAB), KC_A,          KC_S,          KC_D,            KC_F,                  KC_G
    , LSFT_T(KC_LBRC),   KC_Z,          KC_X,          KC_C,            KC_V,                  KC_B, KC_PGDN
    , _______,           OSM(MOD_RALT), LSFT(KC_RALT), LCTL_T(KC_LEFT), LGUI_T(KC_RIGHT)
    ,                                                                            LT(NUMPAD, KC_DEL), KC_HOME
    ,                                                                                                KC_APP
    ,                                                         LSFT_T(KC_BSPC), LT(FUNCTION, KC_TAB), LALT_T(KC_ESC)
    // right hand
    , TG(MAC), KC_6, KC_7,            KC_8,          KC_9,          KC_0,          TG(NUMPAD)
    , KC_EQL,  KC_Y, KC_U,            KC_I,          KC_O,          KC_P,          KC_BSLS
    ,          KC_H, KC_J,            KC_K,          KC_L,          KC_SCLN,       LT(MOUSE, KC_QUOT)
    , KC_MINS, KC_N, KC_M,            KC_COMM,       KC_DOT,        KC_SLSH,       RSFT_T(KC_RBRC)
    ,                LALT_T(KC_DOWN), RCTL_T(KC_UP), RSFT(KC_RALT), OSM(MOD_RALT), _______
    , KC_END, KC_INS
    , KC_APP
    , RGUI_T(KC_GRV), LT(FUNCTION, KC_ENT), LSFT_T(KC_SPC)
    )
, [MAC] = LAYOUT_ergodox
    // left hand
    ( _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, LALT_T(KC_RIGHT)
    ,                                              _______, _______
    ,                                                       _______
    ,                                     _______, _______, LGUI_T(KC_ESC)
    // right hand
    , _______, _______, _______,         _______, _______, _______, _______
    , _______, _______, _______,         _______, _______, _______, _______
    ,          _______, _______,         _______, _______, _______, _______
    , _______, _______, _______,         _______, _______, _______, _______
    ,                   RGUI_T(KC_DOWN), _______, _______, _______, _______
    , _______, _______
    , _______
    , LALT_T(KC_GRV), _______, _______
    )
, [FUNCTION] = LAYOUT_ergodox
    // left hand
    ( _______, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   VRSN
    , _______, KC_EXLM, KC_AT,   KC_LCBR, KC_RCBR, KC_QUOT, KC_HOME
    , _______, KC_CIRC, KC_DLR,  KC_LPRN, KC_RPRN, KC_DQUO
    , _______, KC_HASH, KC_PERC, KC_LBRC, KC_RBRC, KC_GRV,  KC_END
    , _______, _______, _______, KC_LEFT, KC_RGHT
    ,                                              KC_DEL,  _______
    ,                                                       _______
    ,                                     KC_BSPC, KC_TAB,  KC_ESC
    // right hand
    , EPRM,    KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  _______
    , KC_PLUS, _______, KC_AMPR, KC_ASTR, KC_TILD, KC_SLSH, KC_F11
    ,          KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_COLN, KC_F12
    , KC_UNDS, KC_BSLS, KC_PIPE, KC_LT,   KC_GT,   KC_QUES, _______
    ,                   KC_DOWN, KC_UP,   _______, _______, _______
    , _______, _______
    , _______
    , KC_GRV,  KC_ENT,  KC_SPC
    )
, [NUMPAD] = LAYOUT_ergodox
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
    , _______, _______, KC_7,    KC_8,    KC_9,    KC_MINS, _______
    ,          KC_BSPC, KC_4,    KC_5,    KC_6,    KC_PLUS, _______
    , _______, _______, KC_1,    KC_2,    KC_3,    KC_EQL,  _______
    ,                   KC_0,    KC_DOT,  KC_ASTR, KC_SLSH, _______
    , _______, _______
    , _______
    , _______, _______, _______
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
    , _______, _______, _______, KC_MS_U, _______, _______, _______
    , _______, _______, KC_MS_L, KC_MS_D, KC_MS_R, _______
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, _______, _______
    ,                                              _______, _______
    ,                                                       _______
    ,                                     KC_BTN1, KC_BTN2, KC_BTN3
    // right hand
    , _______, _______, _______, _______, _______, _______, _______
    , _______, _______, _______, KC_WH_U, _______, _______, _______
    ,          _______, KC_WH_L, KC_WH_D, KC_WH_R, _______, _______
    , _______, _______, _______, _______, _______, _______, _______
    ,                   _______, _______, _______, _______, _______
    , _______, _______
    , _______
    , _______, KC_BTN4, KC_BTN5
    )
};


bool process_record_user(uint16_t keycode, keyrecord_t *record)
{
    if (record->event.pressed)
    {
        switch (keycode)
        {
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
            #ifdef RGBLIGHT_ENABLE
            case RGB_SLD:
                rgblight_mode(1);
                return false;
            #endif
        }
    }
    return true;
}

// Runs just one time when the keyboard initializes.
void matrix_init_user(void)
{
    #ifdef RGBLIGHT_COLOR_LAYER_0
    rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
    #endif
};

// Runs whenever there is a layer state change.
uint32_t layer_state_set_user(uint32_t state)
{
    ergodox_board_led_off();
    ergodox_right_led_1_off();
    ergodox_right_led_2_off();
    ergodox_right_led_3_off();
    uint8_t layer = biton32(state);
    switch (layer)
    {
        case 0:
            #ifdef RGBLIGHT_COLOR_LAYER_0
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_0);
            #else
            #ifdef RGBLIGHT_ENABLE
            rgblight_init();
            #endif
            #endif
            break;
        case 1:
            ergodox_right_led_1_on();
            #ifdef RGBLIGHT_COLOR_LAYER_1
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_1);
            #endif
            break;
        case 2:
            ergodox_right_led_2_on();
            #ifdef RGBLIGHT_COLOR_LAYER_2
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_2);
            #endif
            break;
        case 3:
            ergodox_right_led_3_on();
            #ifdef RGBLIGHT_COLOR_LAYER_3
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_3);
            #endif
            break;
        case 4:
            ergodox_right_led_1_on();
            ergodox_right_led_2_on();
            #ifdef RGBLIGHT_COLOR_LAYER_4
            rgblight_setrgb(RGBLIGHT_COLOR_LAYER_4);
            #endif
            break;
        case 5:
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
