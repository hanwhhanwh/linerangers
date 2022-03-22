
#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

hwndNotepad = 0x002221CE

PostMessage, 0x100, 0x11, 0x001D0001, , ahk_id %hwndNotepad% ; 0x100 = WM_KEYDOWN ; 0x11 = VK_CONTROL
PostMessage, 0x100, 0x23, 0x014F0001, , ahk_id %hwndNotepad% ; 0x100 = WM_KEYDOWN ; 0x23 = VK_END
PostMessage, 0x101, 0x23, 0xC14F0001, , ahk_id %hwndNotepad% ; 0X101 = WM_KEYUP ; 0x23 = VK_END
PostMessage, 0x101, 0x11, 0xC01D0001, , ahk_id %hwndNotepad% ; 0X101 = WM_KEYUP ; 0x11 = VK_CONTROL
