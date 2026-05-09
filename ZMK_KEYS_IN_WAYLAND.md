# Non-Standard ZMK Keys That Work in Wayland

Comprehensive cross-reference of ZMK key definitions → Linux HID-to-evdev mapping → xkb keysym mapping → what `wev` shows in Wayland.

Keys that produce a **named keysym** (not `NoSymbol`) in xkb will show up in `wev` as recognisable key names. Keys producing `NoSymbol` will show the raw evdev keycode number instead.

---

## Media Keys (Keyboard Page 0x07 extended)

| ZMK name         | HID usage | evdev code         | xkb keysym (`wev` output)          |
|------------------|-----------|--------------------|------------------------------------|
| `K_MUTE`         | `0x7F`    | `KEY_MUTE`         | `XF86AudioMute`                    |
| `K_VOLUME_UP`    | `0x80`    | `KEY_VOLUMEUP`     | `XF86AudioRaiseVolume`             |
| `K_VOLUME_DOWN`  | `0x81`    | `KEY_VOLUMEDOWN`   | `XF86AudioLowerVolume`             |
| `K_PLAY_PAUSE`   | `0xE8`    | `KEY_PLAYPAUSE`    | `XF86AudioPlay` / `XF86AudioPause` |
| `K_STOP2`        | `0xE9`    | `KEY_STOPCD`       | `XF86AudioStop` / `XF86Eject`      |
| `K_PREVIOUS`     | `0xEA`    | `KEY_PREVIOUSSONG` | `XF86AudioPrev`                    |
| `K_NEXT`         | `0xEB`    | `KEY_NEXTSONG`     | `XF86AudioNext`                    |
| `K_EJECT`        | `0xEC`    | `KEY_EJECTCD`      | `XF86Eject`                        |
| `K_VOLUME_UP2`   | `0xED`    | `KEY_VOLUMEUP`     | `XF86AudioRaiseVolume`             |
| `K_VOLUME_DOWN2` | `0xEE`    | `KEY_VOLUMEDOWN`   | `XF86AudioLowerVolume`             |
| `K_MUTE2`        | `0xEF`    | `KEY_MUTE`         | `XF86AudioMute`                    |
| `K_MENU`         | `0x76`    | `KEY_MENU`         | `XF86MenuKB`                       |

## Web/Internet Keys (Keyboard Page 0x07)

| ZMK name        | HID usage | evdev code       | xkb keysym                          |
|-----------------|-----------|------------------|-------------------------------------|------------------------------|
| `K_WWW`         | `0xF0`    | `KEY_WWW`        | `XF86WWW`                           |
| `K_BACK`        | `0xF1`    | `KEY_BACK`       | `XF86Back`                          | ✅ confirmed                 |
| `K_FORWARD`     | `0xF2`    | `KEY_FORWARD`    | `XF86Forward`                       | ✅ confirmed                 |
| `K_STOP3`       | `0xF3`    | `KEY_STOPCD`     | `XF86AudioStop` / `XF86Eject`       |
| `K_FIND2`       | `0xF4`    | `KEY_FIND`       | `Find`                              | ✅ same as `K_FIND`          |
| `K_REFRESH`     | `0xFA`    | `KEY_REFRESH`    | `XF86Reload`                        | ✅ confirmed (as `W_RELOAD`) |
| `K_SCROLL_UP`   | `0xF5`    | `KEY_SCROLLUP`   | `XF86ScrollUp`                      |
| `K_SCROLL_DOWN` | `0xF6`    | `KEY_SCROLLDOWN` | `XF86ScrollDown`                    |
| `K_EDIT`        | `0xF7`    | `KEY_EDIT`       | **NoSymbol** ⚠️ (not mapped in xkb)  |
| `K_FIND`        | `0x7E`    | `KEY_FIND`       | `Find`                              |

## System Keys (Keyboard Page 0x07)

| ZMK name                                                 | HID usage | evdev code                | xkb keysym          |
|----------------------------------------------------------|-----------|---------------------------|---------------------|----------------------------------|
| `K_POWER`                                                | `0x66`    | `KEY_POWER`               | `XF86PowerOff`      |
| `K_SLEEP`                                                | `0xF8`    | `KEY_SLEEP`               | `XF86Sleep`         |
| `K_LOCK` / `K_SCREENSAVER` / `K_COFFEE`                  | `0xF9`    | `KEY_COFFEE`              | `XF86ScreenSaver`   |
| `K_CALCULATOR` / `K_CALC`                                | `0xFB`    | `KEY_CALC`                | `XF86Calculator`    | ✅ confirmed (as `W_CALCULATOR`) |
| `K_HELP`                                                 | `0x75`    | `KEY_HELP`                | `Help`              |
| `K_APPLICATION` / `K_APP` / `K_CONTEXT_MENU` / `K_CMENU` | `0x65`    | `KEY_COMPOSE`             | `Menu`              | ✅ confirmed                     |
| `SYSREQ`                                                 | `0x9A`    | `KEY_SYSRQ`               | `Print` / `Sys_Req` |
| `K_EXECUTE`                                              | `0x74`    | `KEY_EXECUTE` (evdev 116) | `Execute`           | ✅ confirmed (as `W_OPEN`)       |

## Edit Keys (Keyboard Page 0x07)

| ZMK name             | HID usage | evdev code     | xkb keysym      |
|----------------------|-----------|----------------|-----------------|------------------------------|
| `K_AGAIN` / `K_REDO` | `0x79`    | `KEY_AGAIN`    | `Redo`          |
| `K_UNDO`             | `0x7A`    | `KEY_UNDO`     | `Undo`          |
| `K_CUT`              | `0x7B`    | `KEY_CUT`      | `XF86Cut`       |
| `K_COPY`             | `0x7C`    | `KEY_COPY`     | `XF86Copy`      |
| `K_PASTE`            | `0x7D`    | `KEY_PASTE`    | `XF86Paste`     |
| `K_FIND`             | `0x7E`    | `KEY_FIND`     | `Find`          | ✅ confirmed (as `W_FIND`)   |
| `K_STOP`             | `0x78`    | `KEY_STOP`     | `Cancel`        | ✅ confirmed (as `W_CANCEL`) |
| `K_SELECT`           | `0x77`    | `KEY_SELECT`   | **NoSymbol** ⚠️  |
| `K_CANCEL`           | `0x9B`    | `KEY_CANCEL`   | `Cancel`        |
| `ALT_ERASE`          | `0x99`    | `KEY_ALTERASE` | **NoSymbol** ⚠️  |

## Obscure/Historical Keys (Keyboard Page 0x07)

| ZMK name      | HID usage | xkb keysym      |
|---------------|-----------|-----------------|
| `CLEAR`       | `0x9C`    | **NoSymbol** ⚠️  |
| `PRIOR`       | `0x9D`    | **NoSymbol** ⚠️  |
| `RETURN2`     | `0x9E`    | **NoSymbol** ⚠️  |
| `SEPARATOR`   | `0x9F`    | **NoSymbol** ⚠️  |
| `OUT`         | `0xA0`    | **NoSymbol** ⚠️  |
| `OPER`        | `0xA1`    | **NoSymbol** ⚠️  |
| `CLEAR_AGAIN` | `0xA2`    | **NoSymbol** ⚠️  |
| `CRSEL`       | `0xA3`    | **NoSymbol** ⚠️  |
| `EXSEL`       | `0xA4`    | **NoSymbol** ⚠️  |

## Locking Keys (Keyboard Page 0x07)

| ZMK name         | HID usage | xkb keysym                             |
|------------------|-----------|----------------------------------------|
| `LOCKING_CAPS`   | `0x82`    | **NoSymbol** ⚠️ (not in modern kernel)  |
| `LOCKING_NUM`    | `0x83`    | **NoSymbol** ⚠️                         |
| `LOCKING_SCROLL` | `0x84`    | **NoSymbol** ⚠️                         |

## International / Language Keys (Keyboard Page 0x07)

| ZMK name                             | HID usage | xkb keysym                 |
|--------------------------------------|-----------|----------------------------|
| `INTERNATIONAL_1` / `INT_RO`         | `0x87`    | `backslash` / `underscore` |
| `INTERNATIONAL_2` / `INT_KANA`       | `0x88`    | `Hiragana_Katakana`        |
| `INTERNATIONAL_3` / `INT_YEN`        | `0x89`    | `Yen`                      |
| `INTERNATIONAL_4` / `INT_HENKAN`     | `0x8A`    | `Henkan`                   |
| `INTERNATIONAL_5` / `INT_MUHENKAN`   | `0x8B`    | `Muhenkan`                 |
| `INTERNATIONAL_6` / `INT_KPJPCOMMA`  | `0x8C`    | `KP_Comma`-like (varies)   |
| `INTERNATIONAL_7`                    | `0x8D`    | varies by layout           |
| `INTERNATIONAL_8`                    | `0x8E`    | varies by layout           |
| `INTERNATIONAL_9`                    | `0x8F`    | varies by layout           |
| `LANGUAGE_1` / `LANG_HANGEUL`        | `0x90`    | `Hangul`                   |
| `LANGUAGE_2` / `LANG_HANJA`          | `0x91`    | `Hangul_Hanja`             |
| `LANGUAGE_3` / `LANG_KATAKANA`       | `0x92`    | `Katakana`                 |
| `LANGUAGE_4` / `LANG_HIRAGANA`       | `0x93`    | `Hiragana`                 |
| `LANGUAGE_5` / `LANG_ZENKAKUHANKAKU` | `0x94`    | `Zen_Kaku_Han_Kaku`        |
| `LANGUAGE_6`                         | `0x95`    | varies                     |
| `LANGUAGE_7`                         | `0x96`    | varies                     |
| `LANGUAGE_8`                         | `0x97`    | varies                     |
| `LANGUAGE_9`                         | `0x98`    | varies                     |

## Function Keys F13–F24 (Keyboard Page 0x07)

Requires `#include <dt-bindings/zmk/keys.h>` and `fkeys:basic_13-24` in the keymap node.

| ZMK name | HID usage | xkb keysym                                         |
|----------|-----------|----------------------------------------------------|--------------------------|
| `F13`    | `0x68`    | `XF86Tools`                                        | ✅ confirmed             |
| `F14`    | `0x69`    | `XF86Launch5`                                      | ✅ confirmed             |
| `F15`    | `0x6A`    | `XF86Launch6`                                      | ✅ confirmed             |
| `F16`    | `0x6B`    | `XF86Launch7`                                      | ✅ confirmed             |
| `F17`    | `0x6C`    | `XF86Launch8`                                      | ✅ confirmed             |
| `F18`    | `0x6D`    | `XF86Launch9`? (varies)                            | ✅ confirmed             |
| `F19`    | `0x6E`    | keysym name (varies)                               | ✅ confirmed (nav_layer) |
| `F20`    | `0x6F`    | `XF86AudioMicMute`                                 | ✅ confirmed (nav_layer) |
| `F21`    | `0x70`    | `XF86TouchpadToggle`                               | ✅ confirmed (nav_layer) |
| `F22`    | `0x71`    | `XF86TouchpadOn`                                   | ✅ confirmed             |
| `F23`    | `0x72`    | `XF86TouchpadOff` / `XF86Assistant`                | ✅ confirmed             |
| `F24`    | `0x73`    | **NoSymbol** ⚠️ (but available for custom mapping)  |

---

## Consumer Page (0x0C) Keys

These come from the separate consumer HID report. ZMK has extensive consumer key support.

### Media Playback (Consumer Page)

| ZMK name                      | Consumer usage | xkb keysym                                                |
|-------------------------------|----------------|-----------------------------------------------------------|
| `C_PLAY`                      | `0xB0`         | `XF86AudioPlay`                                           |
| `C_PAUSE`                     | `0xB1`         | `Pause` / `XF86AudioPause`                                |
| `C_RECORD` / `C_REC`          | `0xB2`         | `XF86AudioRecord`                                         |
| `C_FAST_FORWARD` / `C_FF`     | `0xB3`         | `XF86AudioForward`                                        |
| `C_REWIND` / `C_RW`           | `0xB4`         | `XF86AudioRewind`                                         |
| `C_NEXT`                      | `0xB5`         | `XF86AudioNext`                                           |
| `C_PREVIOUS` / `C_PREV`       | `0xB6`         | `XF86AudioPrev`                                           |
| `C_STOP`                      | `0xB7`         | `XF86AudioStop` / `XF86Eject`                             |
| `C_EJECT`                     | `0xB8`         | `XF86Eject`                                               |
| `C_RANDOM_PLAY` / `C_SHUFFLE` | `0xB9`         | `XF86AudioRandomPlay`                                     |
| `C_PLAY_PAUSE` / `C_PP`       | `0xCD`         | `XF86AudioPlay` / `XF86AudioPause`                        |
| `C_REPEAT`                    | `0xBC`         | **NoSymbol** ⚠️ (no xkb mapping)                           |
| `C_SLOW`                      | `0xF5`         | **NoSymbol** ⚠️                                            |
| `C_SLOW_TRACKING`             | `0xBB`         | **NoSymbol** ⚠️                                            |
| `C_STOP_EJECT`                | `0xCC`         | **NoSymbol** ⚠️ (maps to KEY_STOP_EJECT, unmapped in xkb)  |
| `C_ALTERNATE_AUDIO_INCREMENT` | `0xE6`         | **NoSymbol** ⚠️                                            |

### Volume Control (Consumer Page)

| ZMK name                     | Consumer usage | xkb keysym                                        |
|------------------------------|----------------|---------------------------------------------------|
| `C_MUTE`                     | `0xE2`         | `XF86AudioMute`                                   |
| `C_VOLUME_UP` / `C_VOL_UP`   | `0xE9`         | `XF86AudioRaiseVolume`                            |
| `C_VOLUME_DOWN` / `C_VOL_DN` | `0xEA`         | `XF86AudioLowerVolume`                            |
| `C_BASS_BOOST`               | `0xE5`         | **NoSymbol** ⚠️ (KEY_BASSBOOST not mapped in xkb)  |

### TV/Display (Consumer Page)

| ZMK name                             | Consumer usage | xkb keysym                                       |
|--------------------------------------|----------------|--------------------------------------------------|--------------|
| `C_RED_BUTTON` / `C_RED`             | `0x69`         | `XF86Red`                                        | ✅ confirmed |
| `C_GREEN_BUTTON` / `C_GREEN`         | `0x6A`         | `XF86Green`                                      | ✅ confirmed |
| `C_BLUE_BUTTON` / `C_BLUE`           | `0x6B`         | `XF86Blue`                                       | ✅ confirmed |
| `C_YELLOW_BUTTON` / `C_YELLOW`       | `0x6C`         | `XF86Yellow`                                     | ✅ confirmed |
| `C_BRIGHTNESS_INC` / `C_BRI_UP`      | `0x6F`         | `XF86MonBrightnessUp`                            |
| `C_BRIGHTNESS_DEC` / `C_BRI_DN`      | `0x70`         | `XF86MonBrightnessDown`                          |
| `C_BRIGHTNESS_MINIMUM` / `C_BRI_MIN` | `0x79`         | `XF86BrightnessMin`                              |
| `C_BRIGHTNESS_MAXIMUM` / `C_BRI_MAX` | `0x7A`         | `XF86BrightnessMax`                              |
| `C_BRIGHTNESS_AUTO` / `C_BRI_AUTO`   | `0x7C`         | **NoSymbol** ⚠️                                   |
| `C_BACKLIGHT_TOGGLE` / `C_BKLT_TOG`  | `0x72`         | **NoSymbol** ⚠️ (KEY_BACKLIGHT_TOGGLE, unmapped)  |
| `C_ASPECT`                           | `0x6D`         | `XF86AspectRatio`                                |
| `C_DATA_ON_SCREEN`                   | `0x60`         | `XF86Info`                                       |
| `C_CAPTIONS` / `C_SUBTITLES`         | `0x61`         | `XF86AudioSubtitle` (varies)                     |

### Channel / Media Navigation (Consumer Page)

| ZMK name                       | Consumer usage | xkb keysym        |
|--------------------------------|----------------|-------------------|
| `C_CHANNEL_INC` / `C_CHAN_INC` | `0x9C`         | `XF86ChannelUp`   |
| `C_CHANNEL_DEC` / `C_CHAN_DEC` | `0x9D`         | `XF86ChannelDown` |
| `C_MEDIA_STEP` / `C_MODE_STEP` | `0x1A`         | **NoSymbol** ⚠️    |
| `C_MEDIA_REPEAT`               | `0x94`         | `XF86MediaRepeat` |
| `C_RECALL_LAST`                | `0x95`         | **NoSymbol** ⚠️    |
| `C_SNAPSHOT`                   | `0x65`         | `XF86WebCam`      |
| `C_PIP`                        | `0x67`         | **NoSymbol** ⚠️    |

### Media Source Selection (Consumer Page)

| ZMK name             | Consumer usage | xkb keysym        |
|----------------------|----------------|-------------------|
| `C_MEDIA_COMPUTER`   | `0x83`         | **NoSymbol** ⚠️    |
| `C_MEDIA_TV`         | `0x84`         | ⚠️ uncommon        |
| `C_MEDIA_WWW`        | `0x85`         | ⚠️ uncommon        |
| `C_MEDIA_DVD`        | `0x86`         | ⚠️ uncommon        |
| `C_MEDIA_PHONE`      | `0x87`         | `XF86Phone`       |
| `C_MEDIA_GUIDE`      | `0x88`         | `XF86Program`     |
| `C_MEDIA_VIDEOPHONE` | `0x89`         | `XF86VideoPhone`  |
| `C_MEDIA_GAMES`      | `0x8A`         | `XF86Game`        |
| `C_MEDIA_MESSAGES`   | `0x8B`         | `XF86Messenger`   |
| `C_MEDIA_CD`         | `0x8C`         | `XF86CD` (varies) |
| `C_MEDIA_VCR`        | `0x8D`         | ⚠️ uncommon        |
| `C_MEDIA_TUNER`      | `0x8E`         | ⚠️ uncommon        |
| `C_MEDIA_TAPE`       | `0x93`         | ⚠️ uncommon        |
| `C_MEDIA_CABLE`      | `0x94`         | ⚠️ uncommon        |
| `C_MEDIA_SATELLITE`  | `0x95`         | ⚠️ uncommon        |
| `C_MEDIA_HOME`       | `0x96`         | `XF86HomePage`    |

### Application Launch (AL) Keys (Consumer Page)

| ZMK name                                         | Consumer usage | xkb keysym                                    |
|--------------------------------------------------|----------------|-----------------------------------------------|
| `C_AL_WORD`                                      | `0x184`        | `XF86Word`                                    |
| `C_AL_TEXT_EDITOR`                               | `0x185`        | `XF86Editor`                                  |
| `C_AL_SPREADSHEET` / `C_AL_SHEET`                | `0x186`        | `XF86Excel`                                   |
| `C_AL_GRAPHICS_EDITOR`                           | `0x187`        | `XF86GraphicsEditor`                          |
| `C_AL_PRESENTATION`                              | `0x188`        | `XF86Presentation`                            |
| `C_AL_DATABASE` / `C_AL_DB`                      | `0x189`        | `XF86Database`                                |
| `C_AL_EMAIL` / `C_AL_MAIL`                       | `0x18A`        | `XF86Mail`                                    |
| `C_AL_NEWS`                                      | `0x18B`        | `XF86News`                                    |
| `C_AL_VOICEMAIL`                                 | `0x18C`        | `XF86Voicemail`                               |
| `C_AL_CONTACTS` / `C_AL_ADDRESS_BOOK`            | `0x18D`        | `XF86Addressbook`                             |
| `C_AL_CALENDAR` / `C_AL_CAL`                     | `0x18E`        | `XF86Calendar`                                |
| `C_AL_TASK_MANAGER`                              | `0x18F`        | `XF86Taskmanager`                             |
| `C_AL_JOURNAL`                                   | `0x190`        | `XF86Journal`                                 |
| `C_AL_FINANCE`                                   | `0x191`        | `XF86Finance`                                 |
| `C_AL_CALCULATOR` / `C_AL_CALC`                  | `0x192`        | `XF86Calculator`                              |
| `C_AL_MY_COMPUTER`                               | `0x194`        | `XF86MyComputer`                              |
| `C_AL_WWW`                                       | `0x196`        | `XF86WWW`                                     |
| `C_AL_NETWORK_CHAT` / `C_AL_CHAT`                | `0x199`        | `XF86Chat` (varies)                           |
| `C_AL_LOGOFF`                                    | `0x19C`        | `XF86LogOff`                                  |
| `C_AL_LOCK` / `C_AL_COFFEE` / `C_AL_SCREENSAVER` | `0x19E`        | `XF86ScreenSaver`                             |
| `C_AL_CONTROL_PANEL`                             | `0x19F`        | `XF86ControlPanel`                            |
| `C_AL_SELECT_TASK`                               | `0x1A2`        | `XF86AppSelect`                               |
| `C_AL_NEXT_TASK`                                 | `0x1A3`        | `XF86AudioNext` ⚠️ (same evdev as next-track)  |
| `C_AL_PREVIOUS_TASK`                             | `0x1A4`        | `XF86AudioPrev` ⚠️ (same evdev as prev-track)  |
| `C_AL_HELP`                                      | `0x1A6`        | `Help`                                        |
| `C_AL_DOCUMENTS` / `C_AL_DOCS`                   | `0x1A7`        | **NoSymbol** ⚠️                                |
| `C_AL_SPELLCHECK` / `C_AL_SPELL`                 | `0x1B6`        | `XF86SpellCheck`                              |
| `C_AL_KEYBOARD_LAYOUT`                           | `0x1B7`        | `XF86Keyboard`                                |
| `C_AL_SCREEN_SAVER`                              | `0x1BC`        | `XF86Screensaver`                             |
| `C_AL_FILE_BROWSER` / `C_AL_FILES`               | `0x1BC`        | `XF86Explorer`                                |
| `C_AL_IMAGE_BROWSER` / `C_AL_IMAGES`             | `0x1C6`        | `XF86Images`                                  |
| `C_AL_AUDIO_BROWSER` / `C_AL_MUSIC`              | `0x1C7`        | `XF86Audio`                                   |
| `C_AL_MOVIE_BROWSER` / `C_AL_MOVIES`             | `0x1C8`        | `XF86Video`                                   |
| `C_AL_INSTANT_MESSAGING` / `C_AL_IM`             | `0x1CA`        | `XF86Messenger`                               |
| `C_AL_OEM_FEATURES` / `C_AL_TIPS`                | `0x1CB`        | `XF86Info`                                    |
| `C_AL_AV_CAPTURE_PLAYBACK`                       | `0x193`        | ⚠️ uncommon                                    |
| `C_AL_CCC`                                       | `0x183`        | **NoSymbol** ⚠️                                |

### Application Control (AC) Keys (Consumer Page)

| ZMK name                             | Consumer usage | xkb keysym                      |
|--------------------------------------|----------------|---------------------------------|
| `C_AC_NEW`                           | `0x201`        | **NoSymbol** ⚠️                  |
| `C_AC_OPEN`                          | `0x202`        | `XF86Open`                      |
| `C_AC_CLOSE`                         | `0x203`        | `XF86Close`                     |
| `C_AC_EXIT`                          | `0x204`        | `XF86Close` (mapped to same) ⚠️  |
| `C_AC_SAVE`                          | `0x207`        | **NoSymbol** ⚠️                  |
| `C_AC_PRINT`                         | `0x208`        | `Print`                         |
| `C_AC_PROPERTIES` / `C_AC_PROPS`     | `0x209`        | `SunProps`                      |
| `C_AC_UNDO`                          | `0x21A`        | `Undo`                          |
| `C_AC_COPY`                          | `0x21B`        | `XF86Copy`                      |
| `C_AC_CUT`                           | `0x21C`        | `XF86Cut`                       |
| `C_AC_PASTE`                         | `0x21D`        | `XF86Paste`                     |
| `C_AC_FIND`                          | `0x21F`        | `Find`                          |
| `C_AC_SEARCH`                        | `0x221`        | `XF86Search`                    |
| `C_AC_GOTO`                          | `0x222`        | `XF86Go`                        |
| `C_AC_HOME`                          | `0x223`        | `XF86HomePage`                  |
| `C_AC_BACK`                          | `0x224`        | `XF86Back`                      |
| `C_AC_FORWARD`                       | `0x225`        | `XF86Forward`                   |
| `C_AC_STOP`                          | `0x226`        | `Cancel`                        |
| `C_AC_REFRESH`                       | `0x227`        | `XF86Reload`                    |
| `C_AC_BOOKMARKS` / `C_AC_FAVORITES`  | `0x22A`        | `XF86Favorites`                 |
| `C_AC_ZOOM_IN`                       | `0x22D`        | `XF86ZoomIn`                    |
| `C_AC_ZOOM_OUT`                      | `0x22E`        | `XF86ZoomOut`                   |
| `C_AC_ZOOM`                          | `0x22F`        | `XF86ZoomReset`                 |
| `C_AC_VIEW_TOGGLE`                   | `0x230`        | **NoSymbol** ⚠️                  |
| `C_AC_SCROLL_UP`                     | `0x233`        | `XF86ScrollUp`                  |
| `C_AC_SCROLL_DOWN`                   | `0x234`        | `XF86ScrollDown`                |
| `C_AC_EDIT`                          | `0x238`        | **NoSymbol** ⚠️                  |
| `C_AC_CANCEL`                        | `0x23B`        | `Cancel`                        |
| `C_AC_INSERT` / `C_AC_INS`           | `0x23C`        | **NoSymbol** ⚠️                  |
| `C_AC_DEL`                           | `0x23D`        | **NoSymbol** ⚠️                  |
| `C_AC_REDO`                          | `0x25E`        | `Redo`                          |
| `C_AC_REPLY`                         | `0x279`        | **NoSymbol** ⚠️                  |
| `C_AC_FORWARD_MAIL`                  | `0x27B`        | **NoSymbol** ⚠️                  |
| `C_AC_SEND`                          | `0x27C`        | `XF86Send`                      |
| `C_AC_DESKTOP_SHOW_ALL_WINDOWS`      | `0x29F`        | **NoSymbol** ⚠️                  |
| `C_AC_DESKTOP_SHOW_ALL_APPLICATIONS` | `0x2A0`        | **NoSymbol** ⚠️                  |
| `C_AC_NEXT_KEYBOARD_LAYOUT_SELECT`   | `0x29D`        | `ISO_Next_Group`                |

### Input Assist (Consumer Page)

| ZMK name                                                     | Consumer usage | xkb keysym                    |
|--------------------------------------------------------------|----------------|-------------------------------|
| `C_KEYBOARD_INPUT_ASSIST_PREVIOUS` / `C_KBIA_PREV`           | `0x2C7`        | `XF86KbdInputAssistPrev`      |
| `C_KEYBOARD_INPUT_ASSIST_NEXT` / `C_KBIA_NEXT`               | `0x2C8`        | `XF86KbdInputAssistNext`      |
| `C_KEYBOARD_INPUT_ASSIST_PREVIOUS_GROUP` / `C_KBIA_PREV_GRP` | `0x2C9`        | `XF86KbdInputAssistPrevgroup` |
| `C_KEYBOARD_INPUT_ASSIST_NEXT_GROUP` / `C_KBIA_NEXT_GRP`     | `0x2CA`        | `XF86KbdInputAssistNextgroup` |
| `C_KEYBOARD_INPUT_ASSIST_ACCEPT` / `C_KBIA_ACCEPT`           | `0x2CB`        | `XF86KbdInputAssistAccept`    |
| `C_KEYBOARD_INPUT_ASSIST_CANCEL` / `C_KBIA_CANCEL`           | `0x2CC`        | `XF86KbdInputAssistCancel`    |

### Power / System (Consumer Page)

| ZMK name            | Consumer usage | xkb keysym                                     |
|---------------------|----------------|------------------------------------------------|
| `C_POWER` / `C_PWR` | `0x30`         | `XF86PowerOff`                                 |
| `C_RESET`           | `0x31`         | **NoSymbol** ⚠️ (KEY_RESTART, unmapped in xkb)  |
| `C_SLEEP`           | `0x32`         | `XF86Sleep`                                    |
| `C_SLEEP_MODE`      | `0x34`         | **NoSymbol** ⚠️                                 |

### Menu Controls (Consumer Page)

| ZMK name                         | Consumer usage | xkb keysym                           |
|----------------------------------|----------------|--------------------------------------|------------------------------|
| `C_MENU`                         | `0x40`         | `XF86MenuKB`                         | ✅ confirmed (as `W_MENUKB`) |
| `C_MENU_PICK` / `C_MENU_SELECT`  | `0x41`         | `XF86Select` (varies)                |
| `C_MENU_UP`                      | `0x42`         | `Up`                                 |
| `C_MENU_DOWN`                    | `0x43`         | `Down`                               |
| `C_MENU_LEFT`                    | `0x44`         | `Left`                               |
| `C_MENU_RIGHT`                   | `0x45`         | `Right`                              |
| `C_MENU_ESCAPE` / `C_MENU_ESC`   | `0x46`         | `Escape`                             |
| `C_MENU_INCREASE` / `C_MENU_INC` | `0x47`         | `KP_Add` ⚠️ (confusing mapping)       |
| `C_MENU_DECREASE` / `C_MENU_DEC` | `0x48`         | `KP_Subtract` ⚠️ (confusing mapping)  |

### Misc (Consumer Page)

| ZMK name           | Consumer usage | xkb keysym         |
|--------------------|----------------|--------------------|
| `C_QUIT`           | `0x97`         | **NoSymbol** ⚠️     |
| `C_HELP`           | `0x98`         | `Help`             |
| `C_VOICE_COMMAND`  | `0xCF`         | `XF86VoiceCommand` |
| `C_MEDIA_VCR_PLUS` | `0x96`         | **NoSymbol** ⚠️     |

---

## Keypad Keys (Keyboard Page 0x07)

| ZMK name                           | HID usage | xkb keysym                                |
|------------------------------------|-----------|-------------------------------------------|
| `KP_LEFT_PARENTHESIS` / `KP_LPAR`  | `0xB6`    | `parenleft`                               |
| `KP_RIGHT_PARENTHESIS` / `KP_RPAR` | `0xB7`    | `parenright`                              |
| `KP_CLEAR`                         | `0xD8`    | **NoSymbol** ⚠️ (available for remapping)  |

---

## Notes

- **⚠️ = NoSymbol**: These keys send a valid Linux evdev keycode but xkb has no keysym mapping. `wev` will show a raw keycode number instead of a name. However, the key event still arrives at the compositor — you can bind these keycodes in applications that support raw keycodes.

- **Duplicate mappings**: Many consumer keys share evdev codes with keyboard page keys. For example `C_AL_NEXT_TASK` (0x1A3) and `C_NEXT` (0xB5) both map to `KEY_NEXTSONG`, producing the same `XF86AudioNext` keysym. The consumer page and keyboard page are separate HID reports, but they converge at the evdev layer.

- **Color buttons** (`C_RED`/`C_GREEN`/`C_BLUE`/`C_YELLOW`): ✅ confirmed working in Wayland, producing `XF86Red`/`XF86Green`/`XF86Blue`/`XF86Yellow` keysyms. Used by media center apps (Kodi) and some compositors.

- **Vendor-specific consumer codes** above `0x2FF` are typically not mapped by the kernel's generic hid driver and will produce no evdev event at all.

## Renamed / Remapped Keys

Several USB HID usages produce different keysyms than their HID spec names suggest, due to kernel and xkb historical reassignments:

### Kernel renamed the evdev constant

| ZMK key         | HID spec name      | Kernel evdev  | xkb keysym        | Why                                                                         |
|-----------------|--------------------|---------------|-------------------|-----------------------------------------------------------------------------|
| `K_APPLICATION` | Application (0x65) | `KEY_COMPOSE` | `Menu`            | Repurposed to Compose/Menu key                                              |
| `K_EXECUTE`     | Execute (0x74)     | `KEY_OPEN`    | `XF86Open`        | `KEY_EXECUTE` removed (slot 116→`KEY_POWER`), reassigned to `KEY_OPEN`(134) |
| `K_LOCK`        | Lock (0xF9)        | `KEY_COFFEE`  | `XF86ScreenSaver` | X11-era joke: "coffee" key runs screensaver                                 |

### xkb maps evdev to unexpected keysym

| ZMK key   | HID spec name | Kernel evdev | xkb keysym | Why                                            |
|-----------|---------------|--------------|------------|------------------------------------------------|
| `K_STOP`  | Stop (0x78)   | `KEY_STOP`   | `Cancel`   | xkb maps `<STOP>` → `Cancel` in `symbols/inet` |
| `K_AGAIN` | Again (0x79)  | `KEY_AGAIN`  | `Redo`     | xkb maps `<AGAI>` → `Redo`                     |

### Kernel added media-specific prefix (still works correctly)

| ZMK key      | HID spec name   | Kernel evdev       | xkb keysym      |
|--------------|-----------------|--------------------|-----------------|
| `K_STOP2`    | Stop (0xE9)     | `KEY_STOPCD`       | `XF86AudioStop` |
| `K_PREVIOUS` | Previous (0xEA) | `KEY_PREVIOUSSONG` | `XF86AudioPrev` |
| `K_NEXT`     | Next (0xEB)     | `KEY_NEXTSONG`     | `XF86AudioNext` |
| `K_EJECT`    | Eject (0xEC)    | `KEY_EJECTCD`      | `XF86Eject`     |

### Abandoned to high-number evdev purgatory (no xkb keysym)

| ZMK key    | HID spec name | Kernel evdev       | xkb                                            |
|------------|---------------|--------------------|------------------------------------------------|
| `K_SELECT` | Select (0x77) | `KEY_SELECT` (353) | `<I361>` → **NoSymbol**                        |
| `K_EDIT`   | Edit (0xF7)   | `KEY_EDIT`         | `<I184>` → **NoSymbol** (commented out in xkb) |
