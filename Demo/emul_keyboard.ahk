#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

WinActivate, *���� ����

Send Hello AutoHotKey

; escape Ű ����
PostMessage, 0x100, 0x1B, 0x00010001, Edit1, ���� ���� ; 0x100 = WM_KEYDOWN ; 0x1B = VK_ESCAPE
PostMessage, 0x102, 0x1B, 0x00010001, Edit1, ���� ���� ; 0X102 = WM_CHAR
PostMessage, 0x101, 0x1B, 0xC0010001, Edit1, ���� ���� ; 0X101 = WM_KEYUP ; 0x1B = VK_ESCAPE
