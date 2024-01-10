/* DESIGN: https://github.com/keyboardio/Kaleidoscope/blob/master/examples/Devices/Keyboardio/Model01/Model01.ino
 * This code largely mimics the default example.  In general, I try to keep this
 * code similarly structured to ease maintenance if the upstream code changes.
 */

#include "Kaleidoscope.h"
#include "Kaleidoscope-EEPROM-Settings.h"
#include "Kaleidoscope-FirmwareVersion.h"
#include "Kaleidoscope-MouseKeys.h"
#include "Kaleidoscope-Macros.h"
#include "Kaleidoscope-LEDControl.h"
#include "Kaleidoscope-LEDEffects.h"
#include "Kaleidoscope-LED-ActiveLayerColor.h"
#include "Kaleidoscope-LEDEffect-Breathe.h"
#include "Kaleidoscope-LEDEffect-Chase.h"
#include "Kaleidoscope-LEDEffect-DigitalRain.h"
#include "Kaleidoscope-LEDEffect-Rainbow.h"
#include "Kaleidoscope-LEDEffect-SolidColor.h"
#include "Kaleidoscope-LED-Stalker.h"
#include "Kaleidoscope-LED-Wavepool.h"
#include "Kaleidoscope-HardwareTestMode.h"
#include "Kaleidoscope-HostPowerManagement.h"
#include "Kaleidoscope-IdleLEDs.h"
#include "Kaleidoscope-DefaultLEDModeConfig.h"
#include "Kaleidoscope-OneShot.h"
#include "Kaleidoscope-Qukeys.h"
#include "Kaleidoscope-USB-Quirks.h"
#include "Version.h"


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
enum
    { MACRO_VERSION
    , MACRO_BRIGHT_UP
    , MACRO_BRIGHT_DOWN
    };

KEYMAPS
    ( [BASE] = KEYMAP_STACKED
        // left hand
        ( Key_CapsLock,      Key_1, Key_2, Key_3, Key_4, Key_5, Key_LEDEffectNext
        , Key_PcApplication, Key_Q, Key_W, Key_E, Key_R, Key_T, Key_PageUp
        , Key_Tab,           Key_A, Key_S, Key_D, Key_F, Key_G
        , Key_LeftBracket,   Key_Z, Key_X, Key_C, Key_V, Key_B, Key_PageDown
        , Key_Delete, Key_Backspace, Key_Tab, Key_Escape
        , Key_Home
        // right hand
        , Key_LEDEffectPrevious, Key_6, Key_7, Key_8,     Key_9,      Key_0,         LockLayer(NUMPAD)
        , Key_Equals,            Key_Y, Key_U, Key_I,     Key_O,      Key_P,         Key_Backslash
        ,                        Key_H, Key_J, Key_K,     Key_L,      Key_Semicolon, Key_Quote
        , Key_Minus,             Key_N, Key_M, Key_Comma, Key_Period, Key_Slash,     Key_RightBracket
        , Key_Backtick, Key_Enter, Key_Spacebar, Key_Insert
        , Key_End
        )
    , [MAC] = KEYMAP_STACKED
        // left hand
        ( ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , Key_Delete, ___, ___, Key_Escape
        , ___
        // right hand
        , ___, ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        ,      ___, ___, ___, ___, ___, ___
        , ___, ___, ___, ___, ___, ___, ___
        , Key_Backtick, ___, ___, Key_Insert
        , ___
        )
    , [FUNCTION] = KEYMAP_STACKED
        // left hand
        ( M(MACRO_BRIGHT_UP),   Key_F1,        Key_F2,        Key_F3,               Key_F4,                Key_F5,            Key_LEDToggle
        , M(MACRO_BRIGHT_DOWN), LSHIFT(Key_1), LSHIFT(Key_2), Key_LeftCurlyBracket, Key_RightCurlyBracket, Key_Quote,         Key_Home
        , LSHIFT(Key_RightAlt), LSHIFT(Key_6), LSHIFT(Key_4), Key_LeftParen,        Key_RightParen,        LSHIFT(Key_Quote)
        , OSM(RightAlt),        LSHIFT(Key_3), LSHIFT(Key_5), Key_LeftBracket,      Key_RightBracket,      Key_Backtick,      Key_End
        , Key_Delete, Key_Backspace, Key_Tab, Key_Escape
        , ShiftToLayer(NUMPAD)
        // right hand
        , LockLayer(MAC),     Key_F6,        Key_F7,                Key_F8,            Key_F9,               Key_F10,               Key_F11
        , LSHIFT(Key_Equals), ___,           LSHIFT(Key_7),         LSHIFT(Key_8),     LSHIFT(Key_Backtick), Key_Slash,             Key_F12
        ,                     Key_LeftArrow, Key_DownArrow,         Key_UpArrow,       Key_RightArrow,       LSHIFT(Key_Semicolon), LSHIFT(Key_RightAlt)
        , LSHIFT(Key_Minus),  Key_Backslash, LSHIFT(Key_Backslash), LSHIFT(Key_Comma), LSHIFT(Key_Period),   LSHIFT(Key_Slash),     OSM(RightAlt)
        , Key_Backtick, Key_Enter, Key_Spacebar, Key_Insert
        , ShiftToLayer(NUMPAD)
        )
    , [NUMPAD] =  KEYMAP_STACKED
        // left hand
        ( ___,              ___, ___, ___, ___, ___, ___
        , ___,              ___, ___, ___, ___, ___, ___
        , ___,              ___, ___, ___, ___, ___
        , M(MACRO_VERSION), ___, ___, ___, ___, ___, ___
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
        ( ___, ___, ___,          ___,         ___,          ___,              ___
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

#define solarizedYellow  CRGB(181, 137,   0)
#define solarizedOrange  CRGB(203,  75,  22)
#define solarizedRed     CRGB(220,  50,  47)
#define solarizedMagenta CRGB(211,  54, 130)
#define solarizedViolet  CRGB(108, 113, 196)
#define solarizedBlue    CRGB( 38, 139, 210)
#define solarizedCyan    CRGB( 42, 161, 152)
#define solarizedGreen   CRGB(113, 173,   0)

#define solarizedHueYellow   45 * 255 / 360
#define solarizedHueOrange   18 * 255 / 360
#define solarizedHueRed       1 * 255 / 360
#define solarizedHueMagenta 331 * 255 / 360
#define solarizedHueViolet  237 * 255 / 360
#define solarizedHueBlue    205 * 255 / 360
#define solarizedHueCyan    175 * 255 / 360
#define solarizedHueGreen    68 * 255 / 360

#define rgbBase   solarizedYellow
#define hueBase   solarizedHueYellow
#define rgbMac    solarizedCyan
#define hueMac    solarizedHueCyan
#define rgbFn     solarizedMagenta
#define hueFn     solarizedHueMagenta
#define rgbNumpad solarizedRed
#define hueNumpad solarizedHueRed
#define rgbMedia  solarizedGreen
#define hueMedia  solarizedHueGreen
#define rgbMouse  solarizedViolet
#define hueMouse  solarizedHueViolet

#define keyPalmLeft  KeyAddr(3,6)
#define keyPalmRight KeyAddr(3,9)

namespace kaleidoscope {
    namespace plugin {
        class LocalLEDEffect :  public Plugin {
            private:
                cRGB    leftRgb = CRGB(0,0,0);
                uint8_t leftHue = 0;
                cRGB    rightRgb = CRGB(0,0,0);
                uint8_t rightHue = 0;
                bool    rightBreathe = false;
                cRGB breath_fast(uint8_t hue) {
                    uint8_t i = (uint16_t)Runtime.millisAtCycleStart() >> 2;
                    if (i & 0x80) { i = 255 - i; }
                    i           = i << 1;
                    uint8_t ii  = (i * i) >> 8;
                    uint8_t iii = (ii * i) >> 8;
                    i = (((3 * (uint16_t)(ii)) - (2 * (uint16_t)(iii))) / 2) + 80;
                    return hsvToRgb(hue, 255, i);
                }
            public:
                EventHandlerResult onSetup() {
                    return onLayerChange();
                }

                EventHandlerResult onLayerChange() {
                    if (Layer.isActive(MEDIA)) {
                        leftRgb = rgbMedia; leftHue = hueMedia;
                    } else if (Layer.isActive(FUNCTION)
                               && Runtime.device().isKeyswitchPressed(keyPalmLeft)) {
                        leftRgb = rgbFn;    leftHue = hueFn;
                    } else if (Layer.isActive(MAC)) {
                        leftRgb = rgbMac;   leftHue = hueMac;
                    } else {
                        leftRgb = rgbBase;  leftHue = hueBase;
                    };
                    if (Layer.isActive(MOUSE)) {
                        rightRgb = rgbMouse; rightHue = hueMouse;
                    } else if (Layer.isActive(FUNCTION)
                               && Runtime.device().isKeyswitchPressed(keyPalmRight)) {
                        rightRgb = rgbFn;    rightHue = hueFn;
                    } else if (Layer.isActive(MAC)) {
                        rightRgb = rgbMac;   rightHue = hueMac;
                    } else {
                        rightRgb = rgbBase;  rightHue = hueBase;
                    };
                    rightBreathe = Layer.isActive(NUMPAD);
                    return EventHandlerResult::OK;
                }
                EventHandlerResult afterEachCycle() {
                    cRGB color = leftRgb;
                    bool leftBreathe =
                        Runtime.hid().keyboard().getKeyboardLEDs() & LED_CAPS_LOCK;
                    if (leftBreathe) {
                        color = breath_fast(leftHue);
                    }
                    ::LEDControl.setCrgbAt(keyPalmLeft, color);
                    color = rightRgb;
                    if (rightBreathe) {
                        color = breath_fast(rightHue);
                    }
                    ::LEDControl.setCrgbAt(keyPalmRight, color);
                    if (Layer.isActive(MOUSE)
                        || Layer.isActive(MEDIA)
                        || Layer.isActive(NUMPAD)) {
                        for (auto keyAddr : KeyAddr::all()) {
                            if (keyPalmLeft == KeyAddr(keyAddr)
                                || keyPalmRight == KeyAddr(keyAddr)) {
                                continue;
                            }
                            uint8_t keyLayer = Layer.lookupActiveLayer(keyAddr);
                            color = CRGB(0,0,0);
                            switch (keyLayer) {
                                case MOUSE:  color = rgbMouse;  break;
                                case MEDIA:  color = rgbMedia;  break;
                                case NUMPAD: color = rgbNumpad; break;
                            }
                            ::LEDControl.setCrgbAt(KeyAddr(keyAddr), color);
                        }
                    }
                    return EventHandlerResult::OK;
                }
        };
    }
}

kaleidoscope::plugin::LocalLEDEffect LocalLEDEffect;  // singleton instance

const macro_t *macroAction(uint8_t macroIndex, KeyEvent &event) {
    uint8_t brightness = 0;
    LEDControl.getBrightness();
    if (keyToggledOn(event.state)) {
        switch (macroIndex) {
            case MACRO_VERSION:
                Macros.type(PSTR(BUILD_INFORMATION));
                break;
            case MACRO_BRIGHT_UP:
                brightness = LEDControl.getBrightness();
                if (brightness < 245) brightness +=  10;
                else brightness = 255;
                LEDControl.setBrightness(brightness);
                break;
            case MACRO_BRIGHT_DOWN:
                brightness = LEDControl.getBrightness();
                if (brightness > 10) brightness -=  10;
                else brightness = 0;
                LEDControl.setBrightness(brightness);
                break;
        }
    }
    return MACRO_NONE;
}

void toggleLedsOnSuspendResume(kaleidoscope::plugin::HostPowerManagement::Event event) {
    switch (event) {
        case kaleidoscope::plugin::HostPowerManagement::Suspend:
        case kaleidoscope::plugin::HostPowerManagement::Sleep:
            LEDControl.disable();
            break;
        case kaleidoscope::plugin::HostPowerManagement::Resume:
            LEDControl.enable();
            break;
    }
}

void hostPowerManagementEventHandler(kaleidoscope::plugin::HostPowerManagement::Event event) {
    toggleLedsOnSuspendResume(event);
}

// DESIGN: order can be important; keeping to the order from the example
KALEIDOSCOPE_INIT_PLUGINS

    ( EEPROMSettings

    , IdleLEDs

    , Qukeys  // DESIGN: Qukeys is recommended early
    , OneShot
    , Macros
    , MouseKeys

    , LEDControl
    , LEDDigitalRainEffect
    , LEDActiveLayerColorEffect
    , LEDBreatheEffect
    , WavepoolEffect
    , StalkerEffect
    , MiamiEffect
    , LocalLEDEffect

    , HostPowerManagement
    );

void setup()
{
    static const cRGB layerColormap[] PROGMEM =
        { rgbBase
        , rgbMac
        , rgbFn
        , rgbNumpad
        , rgbMedia
        , rgbMouse
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

    LEDActiveLayerColorEffect.setColormap(layerColormap);
    LEDBreatheEffect.hue = solarizedHueYellow;
    LEDDigitalRainEffect.setDecayMs(8000);
    LEDDigitalRainEffect.setDropMs(180);
    LEDDigitalRainEffect.setNewDropProbability(3);  // Range: 0-255
    LEDDigitalRainEffect.setTintShadeRatio(127);    // Range: 0-255
    LEDDigitalRainEffect.setMaximumTint(200);       // Range: 0-255
    LEDDigitalRainEffect.setColorChannel(LEDDigitalRainEffect.ColorChannel::RED);
    LEDRainbowEffect.brightness(170);
    LEDRainbowWaveEffect.brightness(160);
    StalkerEffect.variant = STALKER(BlazingTrail);
    LEDControl.setBrightness(147);
}

void loop() {
    Kaleidoscope.loop();
}
