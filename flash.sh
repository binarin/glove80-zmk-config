#!/usr/bin/env bash
set -euo pipefail
# Keyboard Firmware Flash Script
# Builds firmware with ./build.sh (unless skipped) and flashes both halves
# in sequence (right then left). Supports Glove80 and GO60.

#############################################
# Usage Function
#############################################

show_usage() {
    cat << EOF
Usage: $0 <keyboard> [OPTIONS]

Flash firmware to both halves of a keyboard in sequence (right then left).

ARGUMENTS:
    keyboard    (required) Keyboard to flash: glove80 or go60

OPTIONS:
    --right     Flash only the right half
    --left      Flash only the left half
    --both      Flash both halves (default)
    --no-build  Skip building; reuse the existing .uf2 if present
    -h, --help  Show this help message

EXAMPLES:
    $0 glove80              # Build, then flash both halves (right, then left)
    $0 go60 --left          # Build, then flash only the left half
    $0 go60 --no-build      # Skip build, flash both halves with existing go60.uf2

EOF
    exit 0
}

#############################################
# Configuration & Setup
#############################################

KEYBOARD=""
FIRMWARE_FILE=""
DEVICE_LABELS=()
DEVICE_NAMES=("RIGHT" "LEFT")
BOOTLOADER_KEYS=()
SKIP_BUILD=false
# Alternate label to accept for the left half (known label bug workaround)
LEFT_ALT_LABEL=""

POLL_INTERVAL=2
TIMEOUT=60

# ANSI Color Codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# Check for figlet
HAS_FIGLET=false
if command -v figlet >/dev/null 2>&1; then
    HAS_FIGLET=true
fi

configure_keyboard() {
    case "$1" in
        glove80)
            KEYBOARD="glove80"
            FIRMWARE_FILE="glove80.uf2"
            DEVICE_LABELS=("GLV80RHBOOT" "GLV80LHBOOT")
            BOOTLOADER_KEYS=("Magic+' (on both halves)" "Magic+Esc (on left half)")
            # Glove80 left half is known to sometimes report the right label
            LEFT_ALT_LABEL="GLV80RHBOOT"
            ;;
        go60)
            KEYBOARD="go60"
            FIRMWARE_FILE="go60.uf2"
            DEVICE_LABELS=("GO60RHBOOT" "GO60LHBOOT")
            BOOTLOADER_KEYS=("Magic layer, bootloader key (top outer key of each half)" "Magic layer, bootloader key (top outer key of each half)")
            LEFT_ALT_LABEL=""
            ;;
        *)
            echo -e "${RED}${BOLD}Error: Unknown keyboard: $1${RESET}" >&2
            echo "Supported keyboards: glove80, go60" >&2
            exit 1
            ;;
    esac
}

#############################################
# Argument Parsing
#############################################

# Default: flash both halves
FLASH_RIGHT=true
FLASH_LEFT=true
SKIP_BUILD=false

# First non-option argument is the keyboard name
while [[ $# -gt 0 ]]; do
    case $1 in
        --right)
            FLASH_RIGHT=true
            FLASH_LEFT=false
            ;;
        --left)
            FLASH_RIGHT=false
            FLASH_LEFT=true
            ;;
        --both)
            FLASH_RIGHT=true
            FLASH_LEFT=true
            ;;
        --no-build)
            SKIP_BUILD=true
            ;;
        -h|--help)
            show_usage
            ;;
        -*)
            echo -e "${RED}${BOLD}Error: Unknown option: $1${RESET}" >&2
            echo "Run '$0 --help' for usage information." >&2
            exit 1
            ;;
        *)
            if [ -z "$KEYBOARD" ]; then
                configure_keyboard "$1"
            else
                echo -e "${RED}${BOLD}Error: Unexpected argument: $1${RESET}" >&2
                exit 1
            fi
            ;;
    esac
    shift
done

if [ -z "$KEYBOARD" ]; then
    echo -e "${RED}${BOLD}Error: keyboard argument is required (glove80 or go60).${RESET}" >&2
    echo "Run '$0 --help' for usage information." >&2
    exit 1
fi

#############################################
# Helper Functions
#############################################

# Find device by LABEL using blkid
# Args: $1 = label to search for (e.g., "GLV80RHBOOT")
# Returns: device path (e.g., "/dev/sda") or empty string
find_device_by_label() {
    local label="$1"
    local device=""

    # Parse blkid output line by line
    while IFS= read -r line; do
        if [[ "$line" =~ LABEL=\"$label\" ]]; then
            # Extract device path (everything before the first colon)
            device="${line%%:*}"
            echo "$device"
            return 0
        fi
    done < <(sudo blkid 2>/dev/null)

    echo ""
    return 1
}

# Wait for device to appear (either label for left half workaround)
# Args: $1 = expected label, $2 = device name for display (e.g., "RIGHT")
# Returns: device path and actual label found (format: "device|label")
wait_for_device() {
    local expected_label="$1"
    local name="$2"
    local elapsed=0
    local device=""
    local found_label=""

    echo -e "${YELLOW}⏳ Waiting for ${name} half (${expected_label})...${RESET}" >&2

    while [ $elapsed -lt $TIMEOUT ]; do
        # For left half, check alternate label too (workaround for label bug)
        local -a labels=("$expected_label")
        if [ "$name" = "LEFT" ] && [ -n "$LEFT_ALT_LABEL" ] && [ "$LEFT_ALT_LABEL" != "$expected_label" ]; then
            labels+=("$LEFT_ALT_LABEL")
        fi

        for label in "${labels[@]}"; do
            device=$(find_device_by_label "$label")
            if [ -n "$device" ]; then
                echo "${device}|${label}"
                return 0
            fi
        done

        sleep $POLL_INTERVAL
        elapsed=$((elapsed + POLL_INTERVAL))
    done

    echo -e "${RED}${BOLD}✗ Timeout: ${name} half not detected within ${TIMEOUT} seconds.${RESET}" >&2
    exit 1
}

# Get mount point for a device
# Args: $1 = device path (e.g., "/dev/sda")
# Returns: mount point path or empty string
get_mount_point() {
    local device="$1"
    local mount_point=""

    # Parse udisksctl info output for MountPoints field
    while IFS= read -r line; do
        if [[ "$line" =~ MountPoints:[[:space:]]+(/[^[:space:]]+) ]]; then
            mount_point="${BASH_REMATCH[1]}"
            echo "$mount_point"
            return 0
        fi
    done < <(udisksctl info -b "$device" 2>/dev/null)

    echo ""
    return 1
}

# Mount device and return mount point
# Args: $1 = device path
# Returns: mount point path
mount_device() {
    local device="$1"
    local mount_point=""

    # Check if already mounted
    mount_point=$(get_mount_point "$device")
    if [ -n "$mount_point" ]; then
        echo "$mount_point"
        return 0
    fi

    # Mount the device
    local output
    output=$(udisksctl mount --block-device "$device" 2>&1)

    # Parse output: "Mounted /dev/XXX at <mount_point>"
    if [[ "$output" =~ Mounted\ .+\ at\ (.+) ]]; then
        mount_point="${BASH_REMATCH[1]}"
        echo "$mount_point"
        return 0
    fi

    echo -e "${RED}${BOLD}✗ Failed to mount device ${device}${RESET}" >&2
    exit 1
}

# Wait for device to disappear (indicates successful flash and reboot)
# Args: $1 = device path, $2 = device name for display
wait_for_device_removal() {
    local device="$1"
    local name="$2"

    echo -e "${CYAN}⏳ Firmware copied, waiting for ${name} half to reboot...${RESET}" >&2

    # Poll until device disappears from blkid
    while sudo blkid "$device" >/dev/null 2>&1; do
        sleep 1
    done
}

#############################################
# Signal Handling
#############################################

trap 'echo -e "\n${RED}${BOLD}✗ Flashing interrupted.${RESET}"; exit 130' INT TERM

#############################################
# Build
#############################################

# Display banner
if [ "$HAS_FIGLET" = true ]; then
    echo -e "${MAGENTA}${BOLD}"
    figlet -f standard "${KEYBOARD} FLASH"
    echo -e "${RESET}"
else
    echo -e "${MAGENTA}${BOLD}==================================${RESET}"
    echo -e "${MAGENTA}${BOLD}    ${KEYBOARD} FIRMWARE FLASH${RESET}"
    echo -e "${MAGENTA}${BOLD}==================================${RESET}"
    echo ""
fi

# Build (or reuse existing firmware)
if [ "$SKIP_BUILD" = true ]; then
    if [ ! -f "$FIRMWARE_FILE" ]; then
        echo -e "${RED}${BOLD}✗ --no-build given but ${FIRMWARE_FILE} not found.${RESET}" >&2
        exit 1
    fi
    echo -e "${BLUE}Skipping build, using existing ${FIRMWARE_FILE}${RESET}"
else
    echo -e "${BLUE}Building firmware (./build.sh)...${RESET}"
    ./build.sh
    if [ ! -f "$FIRMWARE_FILE" ]; then
        echo -e "${RED}${BOLD}✗ Build finished but ${FIRMWARE_FILE} not found.${RESET}" >&2
        exit 1
    fi
fi

echo -e "${BLUE}Firmware: ${FIRMWARE_FILE}${RESET}"
echo -e "${BLUE}Size: $(stat -c%s "$FIRMWARE_FILE" | numfmt --to=iec-i)B${RESET}"
echo ""

#############################################
# Main Flash Loop
#############################################

# Flash each half in order (right, then left)
for i in 0 1; do
    expected_label="${DEVICE_LABELS[$i]}"
    name="${DEVICE_NAMES[$i]}"
    bootloader_keys="${BOOTLOADER_KEYS[$i]}"

    # Skip this half if not requested
    if [ $i -eq 0 ] && [ "$FLASH_RIGHT" = false ]; then
        continue
    fi
    if [ $i -eq 1 ] && [ "$FLASH_LEFT" = false ]; then
        continue
    fi

    # Display half header with figlet
    if [ "$HAS_FIGLET" = true ]; then
        echo -e "${BLUE}${BOLD}"
        figlet -f standard "$name"
        echo -e "${RESET}"
    else
        echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
        echo -e "${BLUE}${BOLD}Flashing ${name} half${RESET}"
        echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    fi

    echo -e "${YELLOW}To enter bootloader: Press ${BOLD}${bootloader_keys}${RESET}"
    echo ""

    # Wait for device
    result=$(wait_for_device "$expected_label" "$name")
    device="${result%|*}"
    found_label="${result#*|}"

    # Warn if left half shows alternate label
    if [ "$name" = "LEFT" ] && [ "$found_label" != "$expected_label" ]; then
        echo -e "${YELLOW}⚠ Warning: Left half detected with label ${found_label} instead of ${expected_label}. This is a known issue.${RESET}" >&2
    fi

    echo -e "${CYAN}✓ Found ${name} half at ${device}${RESET}" >&2

    # Wait for udisks2 to settle before mounting
    echo -e "${CYAN}⏳ Waiting for device to settle...${RESET}" >&2
    sleep 3

    # Mount device
    mount_point=$(mount_device "$device")
    echo -e "${CYAN}✓ Mounted at ${mount_point}${RESET}" >&2

    # Copy firmware
    echo -e "${CYAN}⏳ Copying firmware to ${name} half...${RESET}" >&2
    if ! cp "$FIRMWARE_FILE" "$mount_point/"; then
        echo -e "${RED}${BOLD}✗ Failed to copy firmware to ${mount_point}${RESET}" >&2
        exit 1
    fi

    # Sync filesystem
    sync

    # Wait for device to reboot
    wait_for_device_removal "$device" "$name"

    echo -e "${GREEN}${BOLD}✓ ${name} half flashed successfully!${RESET}" >&2
    echo ""
done

# Success banner
if [ "$HAS_FIGLET" = true ]; then
    echo -e "${GREEN}${BOLD}"
    figlet -f standard "SUCCESS!"
    echo -e "${RESET}"
fi

# Success message
if [ "$FLASH_RIGHT" = true ] && [ "$FLASH_LEFT" = true ]; then
    echo -e "${GREEN}${BOLD}🎉 Both halves flashed successfully!${RESET}"
elif [ "$FLASH_RIGHT" = true ]; then
    echo -e "${GREEN}${BOLD}🎉 Right half flashed successfully!${RESET}"
else
    echo -e "${GREEN}${BOLD}🎉 Left half flashed successfully!${RESET}"
fi
echo ""
