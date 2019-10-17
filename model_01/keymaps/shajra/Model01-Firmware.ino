#include "Kaleidoscope.h"
#include "Kaleidoscope-Colormap.h"
#include "Kaleidoscope-EEPROM-Keymap.h"
#include "Kaleidoscope-FocusSerial.h"
#include "Kaleidoscope-HardwareTestMode.h"
#include "Kaleidoscope-HostPowerManagement.h"
#include "Kaleidoscope-LED-ActiveLayerColor.h"
#include "Kaleidoscope-LEDEffect-BootGreeting.h"
#include "Kaleidoscope-LEDEffect-SolidColor.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-MagicCombo.h"
#include "Kaleidoscope-MouseKeys.h"
#include "Kaleidoscope-NumPad.h"
#include "Kaleidoscope-OneShot.h"
#include "Kaleidoscope-Qukeys.h"
#include "Kaleidoscope-USB-Quirks.h"

#include "src/Version.h"


/** Layer names enumerated */
enum
    { BASE
    , MAC
    , FUNCTION
    , NUMPAD
    , MEDIA
    , MOUSE
    };

/** Macro names enumerated */
enum { MACRO_VERSION_INFO };

/** Magic combos names enumerated */
enum
    { COMBO_TOGGLE_NKRO_MODE
    , COMBO_ENTER_TEST_MODE
    };


KEYMAPS
    ( [BASE] = KEYMAP_STACKED
        // left hand
        ( Key_CapsLock,    Key_1, Key_2, Key_3, Key_4, Key_5, Key_LEDEffectNext
        , Key_Backtick,    Key_Q, Key_W, Key_E, Key_R, Key_T, Key_PageUp
        , Key_Tab,         Key_A, Key_S, Key_D, Key_F, Key_G
        , Key_LeftBracket, Key_Z, Key_X, Key_C, Key_V, Key_B, Key_PageDown
        , Key_Delete, Key_Backspace, Key_Tab, Key_Escape
        , Key_Home
        // right hand
        , LockLayer(MAC), Key_6, Key_7, Key_8,     Key_9,      Key_0,         LockLayer(NUMPAD)
        , Key_Equals,     Key_Y, Key_U, Key_I,     Key_O,      Key_P,         Key_Backslash
        ,                 Key_H, Key_J, Key_K,     Key_L,      Key_Semicolon, Key_Quote
        , Key_Minus,      Key_N, Key_M, Key_Comma, Key_Period, Key_Slash,     Key_RightBracket
        , Key_Backtick, Key_Enter, Key_Spacebar, Key_Insert
        , Key_End
        )
    , [MAC] = KEYMAP_STACKED
        // left hand
        ( ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, Key_Tab, Key_Escape
        , ___
        // right hand
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        ,      ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , Key_Backtick, Key_Enter, ___, ___
        , ___
        )
    , [FUNCTION] = KEYMAP_STACKED
        // left hand
        ( ___,                  Key_F1,        Key_F2,        Key_F3,               Key_F4,                Key_F5,            M(MACRO_VERSION_INFO)
        , ___,                  LSHIFT(Key_1), LSHIFT(Key_2), Key_LeftCurlyBracket, Key_RightCurlyBracket, Key_Quote,         Key_Home
        , LSHIFT(Key_RightAlt), LSHIFT(Key_6), LSHIFT(Key_4), Key_LeftParen,        Key_RightParen,        LSHIFT(Key_Quote)
        , OSM(RightAlt),        LSHIFT(Key_3), LSHIFT(Key_5), Key_LeftBracket,      Key_RightBracket,      Key_Backtick,      Key_End
        , Key_Delete, Key_Backspace, Key_Tab, Key_Escape
        , ShiftToLayer(NUMPAD)
        // right hand
        , ___,                Key_F6,        Key_F7,                Key_F8,            Key_F9,               Key_F10,               Key_F11
        , LSHIFT(Key_Equals), ___,           LSHIFT(Key_7),         LSHIFT(Key_8),     LSHIFT(Key_Backtick), Key_Slash,             Key_F12
        ,                     Key_LeftArrow, Key_DownArrow,         Key_UpArrow,       Key_RightArrow,       LSHIFT(Key_Semicolon), LSHIFT(Key_RightAlt)
        , LSHIFT(Key_Minus),  Key_Backslash, LSHIFT(Key_Backslash), LSHIFT(Key_Comma), LSHIFT(Key_Period),   LSHIFT(Key_Slash),     OSM(RightAlt)
        , Key_Backtick, Key_Enter, Key_Spacebar, Key_Insert
        , ShiftToLayer(NUMPAD)
        )
    , [NUMPAD] =  KEYMAP_STACKED
        // left hand
        ( ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___
        , ___
        // right hand
        , ___, ___,           Key_7, Key_8,      Key_9,              Key_KeypadSubtract, ___
        , ___, Key_Backspace, Key_4, Key_5,      Key_6,              Key_KeypadAdd,      ___
        ,      ___,           Key_1, Key_2,      Key_3,              Key_Equals,         ___
        , ___, ___,           Key_0, Key_Period, Key_KeypadMultiply, Key_KeypadDivide,   ___
        , ___, ___, ___, ___
        , ___
        )
    , [MEDIA] = KEYMAP_STACKED
        // left hand
        ( ___, ___, ___,                        ___,                     ___,                    ___, ___
        , ___, ___, Consumer_Rewind,            Consumer_Stop,           Consumer_FastForward,   ___, ___
        , ___, ___, Consumer_ScanPreviousTrack, Consumer_PlaySlashPause, Consumer_ScanNextTrack, ___
        , ___, ___, ___,                        ___,                     ___,                    ___, ___
        , Consumer_Mute, Consumer_VolumeDecrement, Consumer_VolumeIncrement, ___
        , ___
        // right hand
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        ,      ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , ___, Consumer_AC_Back, Consumer_AC_Forward, ___
        , ___
        )
    , [MOUSE] = KEYMAP_STACKED
        // left hand
        ( ___, ___, ___,          ___,         ___,          ___, ___
        , ___, ___, Key_mouseUpL, Key_mouseUp, Key_mouseUpR, Key_mouseWarpEnd, Key_mouseWarpNE
        , ___, ___, Key_mouseL,   Key_mouseDn, Key_mouseR,   Key_mouseWarpNW
        , ___, ___, Key_mouseDnL, ___,         Key_mouseDnR, Key_mouseWarpSW,  Key_mouseWarpSE
        , Key_mouseBtnM, Key_mouseBtnL, Key_mouseBtnR, Key_mouseBtnM
        , ___
        // right hand
        , ___, ___, ___,              ___,               ___,              ___, ___
        , ___, ___, ___,              Key_mouseScrollUp, ___,              ___, ___
        ,      ___, Key_mouseScrollL, Key_mouseScrollDn, Key_mouseScrollR, ___, ___
        , ___, ___, ___,              ___,               ___,              ___, ___
        , ___, Key_mouseBtnP, Key_mouseBtnN, ___
        , ___
        )
)


// Colors calibrated to draw 500mA or less from LEDs
//
static kaleidoscope::plugin::LEDSolidColor solidRed(160, 0, 0);
static kaleidoscope::plugin::LEDSolidColor solidOrange(140, 70, 0);
static kaleidoscope::plugin::LEDSolidColor solidYellow(130, 100, 0);
static kaleidoscope::plugin::LEDSolidColor solidGreen(0, 160, 0);
static kaleidoscope::plugin::LEDSolidColor solidBlue(0, 70, 130);
static kaleidoscope::plugin::LEDSolidColor solidIndigo(0, 0, 170);
static kaleidoscope::plugin::LEDSolidColor solidViolet(130, 0, 120);


static void versionInfoMacro(uint8_t keyState)
{
    if (keyToggledOn(keyState))
    {
        Macros.type(PSTR(BUILD_INFORMATION));
    }
}

const macro_t *macroAction(uint8_t macroIndex, uint8_t keyState)
{
    switch (macroIndex)
    {
        case MACRO_VERSION_INFO:
            versionInfoMacro(keyState);
            break;
    }
    return MACRO_NONE;
}

void toggleLedsOnSuspendResume(kaleidoscope::plugin::HostPowerManagement::Event event)
{
    switch (event)
    {
        case kaleidoscope::plugin::HostPowerManagement::Suspend:
            LEDControl.set_all_leds_to({0, 0, 0});
            LEDControl.syncLeds();
            LEDControl.paused = true;
            break;
        case kaleidoscope::plugin::HostPowerManagement::Resume:
            LEDControl.paused = false;
            LEDControl.refreshAll();
            break;
        case kaleidoscope::plugin::HostPowerManagement::Sleep:
            break;
    }
}

void hostPowerManagementEventHandler(kaleidoscope::plugin::HostPowerManagement::Event event) {
    toggleLedsOnSuspendResume(event);
}

static void toggleKeyboardProtocol(uint8_t combo_index) {
    USBQuirks.toggleKeyboardProtocol();
}

static void enterHardwareTestMode(uint8_t combo_index) {
    HardwareTestMode.runTests();
}


USE_MAGIC_COMBOS
    (   { .action = toggleKeyboardProtocol
        , .keys = { R3C6, R2C6, R3C7 } // Left Fn + Esc + Shift
        }
    ,   { .action = enterHardwareTestMode
        , .keys = { R3C6, R0C0, R0C6 } // Left Fn + Prog + LED
        }
    );


// DESIGN: order can be important (for example, LED effects are added in the
// order they're listed here)
KALEIDOSCOPE_INIT_PLUGINS
    ( Qukeys  // DESIGN: Qukeys is recommended first

    , EEPROMKeymap
    , EEPROMSettings
    , Focus
    , FocusEEPROMCommand
    , FocusSettingsCommand
    , HardwareTestMode
    , HostPowerManagement

    , LEDControl
    , LEDPaletteTheme
    , LEDOff
    , LEDActiveLayerColorEffect
    , BootGreetingEffect

    , Macros
    , MagicCombo
    , MouseKeys
    , NumPad
    , OneShot
    , USBQuirks
    );

void setup()
{
    static const cRGB layerColormap[] PROGMEM =
        { CRGB(128, 128,   0)  // BASE     = yellow
        , CRGB(0,   128, 128)  // MAC      = cyan
        , CRGB(128,   0, 128)  // FUNCTION = magenta
        , CRGB(0,     0,   0)  // NUMPAD   = off
        , CRGB(0,   128,   0)  // MEDIA    = green
        , CRGB(0,     0, 128)  // MOUSE    = blue
        };

    Kaleidoscope.setup();

    // DESIGN: Key Addresses for Qukeys Plugin
    //
    // r0c0 r0c1 r0c2 r0c3 r0c4 r0c5 r0c6
    // r1c0 r1c1 r1c2 r1c3 r1c4 r1c5 r1c6
    // r2c0 r2c1 r2c2 r2c3 r2c4 r2c5
    // r3c0 r3c1 r3c2 r3c3 r3c4 r3c5 r2c6
    // r0c7 r1c7 r2c7 r3c7
    // r3c6
    //
    // r0c9 r0c10 r0c11 r0c12 r0c13 r0c14 r0c15
    // r1c9 r1c10 r1c11 r1c12 r1c13 r1c14 r1c15
    //      r2c10 r2c11 r2c12 r2c13 r2c14 r2c15
    // r2c9 r3c10 r3c11 r3c12 r3c13 r3c14 r3c15
    // r3c8 r2c8 r1c8 r0c8
    // r3c9
    //
    QUKEYS
        ( kaleidoscope::plugin::Qukey(BASE, KeyAddr(3, 0),  Key_LeftShift)
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(3, 15), Key_RightShift)

        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(3, 6), ShiftToLayer(FUNCTION))
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(3, 9), ShiftToLayer(FUNCTION))

        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(2, 0),  ShiftToLayer(MEDIA))
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(2, 15), ShiftToLayer(MOUSE))

        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(0, 7), Key_LeftGui)
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(1, 7), Key_LeftShift)
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(2, 7), Key_LeftControl)
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(3, 7), Key_LeftAlt)

        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(0, 8), Key_LeftAlt)
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(1, 8), Key_RightShift)
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(2, 8), Key_RightControl)
        , kaleidoscope::plugin::Qukey(BASE, KeyAddr(3, 8), Key_RightGui)

        , kaleidoscope::plugin::Qukey(MAC, KeyAddr(0, 7), Key_LeftAlt)
        , kaleidoscope::plugin::Qukey(MAC, KeyAddr(3, 7), Key_LeftGui)

        , kaleidoscope::plugin::Qukey(MAC, KeyAddr(0, 8), Key_RightGui)
        , kaleidoscope::plugin::Qukey(MAC, KeyAddr(3, 8), Key_LeftAlt)
        )

    EEPROMKeymap.setup(6);
    HardwareTestMode.setActionKey(R3C6);
    LEDActiveLayerColorEffect.setColormap(layerColormap);
    LEDOff.activate();
    MouseKeys.accelSpeed = 3;
    MouseKeys.speed = 3;
    NumPad.numPadLayer = NUMPAD;
}

void loop()
{
    Kaleidoscope.loop();
}
