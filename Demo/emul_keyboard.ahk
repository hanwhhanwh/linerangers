#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

WinActivate, *제목 없음

Send Hello AutoHotKey

; escape 키 모의
PostMessage, 0x100, 0x1B, 0x00010001, Edit1, 제목 없음 ; 0x100 = WM_KEYDOWN ; 0x1B = VK_ESCAPE
PostMessage, 0x102, 0x1B, 0x00010001, Edit1, 제목 없음 ; 0X102 = WM_CHAR
PostMessage, 0x101, 0x1B, 0xC0010001, Edit1, 제목 없음 ; 0X101 = WM_KEYUP ; 0x1B = VK_ESCAPE

; notepad는 key down 으로 키보드 모의가 안됨
PostMessage, 0x100, 0x61, 0xC0000001, Edit1, *제목 없음 ; 0X100 = WM_DOWN ; a
PostMessage, 0x100, 0x62, 0xC0000001, Edit1, *제목 없음 ; 0X100 = WM_DOWN ; b
PostMessage, 0x100, 0x63, 0xC0000001, Edit1, *제목 없음 ; 0X100 = WM_DOWN ; c

PostMessage, 0x102, 0x41, 0x1, Edit1, *제목 없음 ; 0X102 = WM_CHAR ; A
PostMessage, 0x102, 0x42, 0x1, Edit1, *제목 없음 ; 0X102 = WM_CHAR ; B
PostMessage, 0x102, 0x43, 0x1, Edit1, *제목 없음 ; 0X102 = WM_CHAR ; C

PostMessage, 0x102, 0x61, 0x1, Edit1, *제목 없음 ; 0X102 = WM_UP ; a
PostMessage, 0x102, 0x62, 0x1, Edit1, *제목 없음 ; 0X102 = WM_UP ; b
PostMessage, 0x102, 0x63, 0x1, Edit1, *제목 없음 ; 0X102 = WM_UP ; c
