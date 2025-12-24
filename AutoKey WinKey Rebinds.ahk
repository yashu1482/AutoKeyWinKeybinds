#Requires AutoHotkey v2.0
#SingleInstance Force

;=================================================================================================
;RUN AS ADMIN

if !A_IsAdmin
{
    try
    {
        Run '*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"'
    }
    ExitApp
}
;=================================================================================================

; Tell Windows the "Mask" key is an unassigned virtual key
; This prevents the Start Menu from appearing when Win is released.

A_MenuMaskKey := "vkE8"
InstallKeybdHook(true)              

; -------------------------------------------------------------------------
; BLOCK THE START MENU
; This captures the Windows key by itself and prevents the Start Menu.
; -------------------------------------------------------------------------
~LWin::
~RWin::
{
    Send "{Blind}{vkE8}"
}
;===============================================================================
; WINDOW MANAGEMENT
;===============================================================================

; 1. --- Win + Tab acting as Alt + Tab --- (Win + Tab)
; This "remappings" the keys so Win+Tab triggers the Windows App Switcher
$#Tab::
{
    Send "{Alt Down}{Tab}"
    KeyWait "LWin"      ; Wait for you to release the Left Windows key
    Send "{Alt Up}"     ; Now safely release Alt
}
;----------------------------------------------------------------------------------

; 2. --- Quick switch between Active and Last Active window --- (Win + Space)

; Increase script speed to the absolute maximum
ListLines 0
ProcessSetPriority "High"

#Space::
{
    ; Block all input for a few milliseconds so the UI can't "catch" the keys
    Critical "On"
    
    ; Send the switch command at hardware level speed
    SendInput "{Alt Down}{Tab}{Alt Up}"
    
    ; If the Task Switcher window exists, force it to hide immediately
    if WinExist("ahk_class MultitaskingViewFrame")
        WinHide "ahk_class MultitaskingViewFrame"
        
    Critical "Off"
}
;--------------------------------------------------------------------------------

; --- 3. Snap Windows with Delay --- (Win + Q)

*#w::
{
    Send "{LWin Down}{Right}"
    Sleep 2 ; 2mms delay to let Windows process the snap
    Send "{LWin Up}"
}

;--------------------------------------------------------------------------------

; --- 3.  Fullscreen Toggle --- (Win + W)

    ; Check the state of the active window
    ; -1: Minimized, 0: Restored, 1: Maximized

*#q::
{
    if (WinGetMinMax("A") = 1) ; If Maximized
        WinRestore "A"         ; Make it normal size
    else                       ; If not Maximized
        WinMaximize "A"        ; Make it Fullscreen
}
;---------------------------------------------------------------------------------

; 4. --- Active Window Minimize --- (Win + E)

*#e::WinMinimize "A"    ; Win + E: Minimize Active Window

;----------------------------------------------------------------------------------

; REMOVE EVERYTHING BELOW IF YOU DONT NEED CUSTOM KEYBINDS
; OR ADD SEMICOLON AT START OF EVERY LINE BELOW
;==================================================================================
; CUSTOM KEYBINDS
;==================================================================================

; 1. --- Scrolling (Win + Z / Win + X) ---
*#z::Click "WheelUp"    ; Scroll Up
*#x::Click "WheelDown"  ; Scroll Down

;-----------------------------------------------------------------------------------

;-------------------------------------------------------------------------------------

;2. --- Win + A and S = Ctrl + Shift + Tab and Ctrl + Tab (For Edge Tab Switching)---

$#a::Send "^+{Tab}" ; Ctrl + Shift + Tab
$#s::Send "^{Tab}"  ; Ctrl + Tab

;--------------------------------------------------------------------------------------

; 3. --- Menu Key + WASD = Arrows --- 

#HotIf GetKeyState("AppsKey", "P")
; WASD = Arrows
w::Up
a::Left
s::Down
d::Right

#HotIf

; Prevent the Menu Key from opening the right-click menu when you use it as a modifier
*AppsKey::Return

