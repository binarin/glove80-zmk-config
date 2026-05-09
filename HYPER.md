# Comprehensive Analysis: Adding Proper Hyper Modifier

## 1. Current State

**ZMK's "Hyper":** Not a real modifier. It's just a macro in keymap files:

```c
#define HYPER LC(LS(LG(LALT)))  // presses all 4 left modifiers simultaneously
#define HYP(x) LC(LS(LG(LA(x))))
```

**USB HID protocol** has NO Hyper key. The keyboard modifier byte is exactly 8 bits covering `0xE0`–`0xE7` (LCTRL, LSHIFT, LALT, LGUI, RCTRL, RSHIFT, RALT, RGUI). There is no room for a 9th modifier bit.

**Linux evdev** has NO `KEY_HYPER` defined in `input-event-codes.h` (checked kernel 6.16). The standard modifier keycodes are `KEY_LEFTCTRL`–`KEY_RIGHTMETA` (8 of them).

**However**, xkeyboard-config already has **Hyper infrastructure**:

- `<HYPR> = 207;` in `keycodes/evdev` — evdev keycode 207 is mapped to the xkb `<HYPR>` key
- `key <HYPR> {[ NoSymbol, Hyper_L ]};` in `symbols/pc` — it produces `Hyper_L` keysym
- `modifier_map Mod3 { <HYPR> };` — acts as Mod3 modifier
- `XKB_KEY_Hyper_L` (0xffed) and `XKB_KEY_Hyper_R` (0xffee) keysyms exist in libxkbcommon

But keycode 207 is `KEY_PLAY` — it comes from the *Consumer* page, not the keyboard page — so a standard USB keyboard can't cleanly emit it.

## 2. The Solution

The approach needs to bridge three layers:

```
ZMK (USB HID) → Linux kernel (evdev) → xkb (keysym)
```

Since Hyper can't occupy the modifier byte, it will be sent as a **regular key in the HID key array**, and xkb will interpret it as a modifier — this is actually how Level3/Level5 (e.g., CapsLock-as-modifier) already work on Linux.

### Step 1 — ZMK: Pick a keyboard HID usage to repurpose

The report descriptor in `moergo-zmk/app/include/zmk/hid.h` covers usages `0x00`–`0xFF` on the keyboard page. We need an unused code. Good candidates:

| HID usage | ZMK constant | Description |
|-----------|-------------|-------------|
| `0xDC` | `HID_USAGE_KEY_KEYPAD_CLEAR` | Keypad Clear — nearly never used |
| `0xD9` | `HID_USAGE_KEY_KEYPAD_CLEAR_ENTRY` | Keypad Clear Entry — also unused |

These are already defined in `hid_usage.h` and available in the report descriptor range.

Add a key definition in `moergo-zmk/app/include/dt-bindings/zmk/keys.h`:

```c
/* Hyper modifier — uses keypad clear slot, to be remapped on the host side */
#define HYPER_KEY (ZMK_HID_USAGE(HID_USAGE_KEY, HID_USAGE_KEY_KEYPAD_CLEAR))
```

Then in your keymap you can use `&kp HYPER_KEY` (after adding it to `behaviors.dtsi` or directly).

### Step 2 — Linux: Remap the HID usage to an evdev keycode

Using udev hwdb. The USB HID scancode format is `700dc` (for usage `0x07` `0xDC`). Create `/etc/udev/hwdb.d/61-hyper-key.hwdb`:

```
# Glove80 Hyper key — remap HID usage 0x700DC to KEY_PLAY (207)
# which xkb maps to <HYPR> producing Hyper_L + Mod3
evdev:input:b0003v*
 KEYBOARD_KEY_700dc=play
```

Then:
1
```bash
sudo systemd-hwdb update
sudo udevadm trigger /dev/input/event*
```

This remaps the USB HID scancode for keypad-clear (which you'll never use) to `KEY_PLAY` (207). xkb then maps `KEY_PLAY` → `<HYPR>` → `Hyper_L` keysym + `Mod3` modifier.

`wev` will show `Hyper_L` when you press it.

### Step 3 — Optional: Cleaner xkb approach without KEY_PLAY collision

If you don't want to reuse `KEY_PLAY`, use an unused evdev code like `KEY_PROG1` (148) instead and add a custom xkb keycodes file:

```
# /etc/udev/hwdb.d/61-hyper-key.hwdb
evdev:input:b0003v*
 KEYBOARD_KEY_700dc=prog1
```

Then create `~/.config/xkb/keycodes/hyper`:

```
xkb_keycodes "hyper" {
    <HYPR> = 148;  // KEY_PROG1
};
```

And `~/.config/xkb/symbols/hyper`:

```
partial modifier_keys
xkb_symbols "hyper" {
    key <HYPR> { [ Hyper_L ] };
    modifier_map Mod3 { <HYPR> };
};
```

Then configure your xkb to use these extras.

## 3. Important Caveats

**Hyper is NOT in the modifier byte.** It's sent as a regular keypress in the 6-key rollover array. xkb treats it as a modifier at the keysym/action level — this means it behaves identically from the user's perspective: hold Hyper + press A = Hyper+A. The kernel doesn't know or care about "modifier" vs "regular key" — it just passes keycodes to xkb.

**Only one Hyper key** with this approach (not separate Left/Right). If you want both, use two different unused HID usages (e.g., `0xDC` for left, `0xD9` for right) and map them to different xkb keys producing `Hyper_L`/`Hyper_R`.

**NKRO works fine** — the usage code is well within the `0x00`–`0xFF` range covered by the NKRO bitmap report descriptor.

## 4. Summary

| Layer | What changes |
|-------|-------------|
| **ZMK** | Add key definition using unused HID keyboard usage (e.g., `0xDC`), use `&kp HYPER_KEY` |
| **Kernel** | udev hwdb remaps the HID scancode `700dc` → `KEY_PLAY` (207) or `KEY_PROG1` (148) |
| **xkb** | Already maps `KEY_PLAY`(207) → `<HYPR>` → `Hyper_L` + `Mod3` (or create custom mapping) |
| **Result** | `wev` shows `Hyper_L`, usable as a real 5th modifier alongside Ctrl/Alt/Shift/GUI |

## 5. Source Code References

- `moergo-zmk/app/include/dt-bindings/zmk/hid_usage.h` — HID usage definitions (keyboard page 0x07)
- `moergo-zmk/app/include/dt-bindings/zmk/hid_usage_pages.h` — HID usage page constants
- `moergo-zmk/app/include/dt-bindings/zmk/keys.h` — ZMK key definitions
- `moergo-zmk/app/include/dt-bindings/zmk/modifiers.h` — Modifier bit definitions (8 mods only)
- `moergo-zmk/app/include/zmk/hid.h` — HID report descriptor and report structures
- `moergo-zmk/app/src/hid.c` — Modifier tracking (hardcoded to 8 mods)
- `moergo-zmk/app/src/hid_listener.c` — Keycode-to-HID dispatch
- `libinput/include/linux/linux/input-event-codes.h` — Linux evdev keycodes (no KEY_HYPER)
- `libxkbcommon/include/xkbcommon/xkbcommon-keysyms.h` — XKB_KEY_Hyper_L/Hyper_R definitions
- `xkeyboard-config/.../keycodes/evdev` — `<HYPR> = 207` mapping
- `xkeyboard-config/.../symbols/pc` — `key <HYPR> {[ NoSymbol, Hyper_L ]}`
