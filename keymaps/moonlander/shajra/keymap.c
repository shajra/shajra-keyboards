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
    VRSN = ML_SAFE_RANGE,
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] =
{ [BASE] = LAYOUT_moonlander
    ( KC_CAPS,           KC_1, KC_2, KC_3, KC_4, KC_5, RGB_TOG, /**/ TG(MAC), KC_6, KC_7, KC_8,    KC_9,   KC_0,    TG(NUMPAD)
    , KC_GRV,            KC_Q, KC_W, KC_E, KC_R, KC_T, KC_PGUP, /**/ KC_EQL,  KC_Y, KC_U, KC_I,    KC_O,   KC_P,    KC_BSLS
    , LT(MEDIA, KC_TAB), KC_A, KC_S, KC_D, KC_F, KC_G, KC_PGDN, /**/ KC_MINS, KC_H, KC_J, KC_K,    KC_L,   KC_SCLN, LT(MOUSE, KC_QUOT)
    , LSFT_T(KC_LBRC),   KC_Z, KC_X, KC_C, KC_V, KC_B,          /**/          KC_N, KC_M, KC_COMM, KC_DOT, KC_SLSH, RSFT_T(KC_RBRC)

    , KC_APP, OSM(MOD_RALT), LSFT(KC_RALT), LCTL_T(KC_LEFT), LGUI_T(KC_RIGHT), LT(NUMPAD, KC_DEL)
    , KC_INS, LALT_T(KC_DOWN), RCTL_T(KC_UP), RSFT(KC_RALT), OSM(MOD_RALT), KC_APP

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
    ( RGB_MOD, KC_F1,   KC_F2,   KC_F3,   KC_F4,   KC_F5,   VRSN,    /**/ EEP_RST, KC_F6,   KC_F7,   KC_F8,   KC_F9,   KC_F10,  RESET
    , RGB_HUI, KC_EXLM, KC_AT,   KC_LCBR, KC_RCBR, KC_QUOT, KC_HOME, /**/ KC_PLUS, _______, KC_AMPR, KC_ASTR, KC_TILD, KC_SLSH, KC_F11
    , RGB_HUD, KC_CIRC, KC_DLR,  KC_LPRN, KC_RPRN, KC_DQUO, KC_END,  /**/ KC_UNDS, KC_LEFT, KC_DOWN, KC_UP,   KC_RGHT, KC_COLN, KC_F12
    , RGB_VAI, KC_HASH, KC_PERC, KC_LBRC, KC_RBRC, KC_GRV,           /**/          KC_BSLS, KC_PIPE, KC_LT,   KC_GT,   KC_QUES, _______
    , RGB_VAD, _______, _______, KC_LEFT, KC_RGHT,          KC_DEL,  /**/ _______,          KC_DOWN, KC_UP,   _______, _______, _______
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
            SEND_STRING (QMK_KEYBOARD "/" QMK_KEYMAP " @ " QMK_VERSION);
            return false;
        }
    }
    return true;
}
