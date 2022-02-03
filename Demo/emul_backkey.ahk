#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


; BACK 버튼 마우스 선택 모의
PostMessage, 0x0201, 0x00000001, 0x01980015, , ahk_id 0x00050B1A ; 0x0201 = WM_LBUTTONDOWN / LPARAM = (X, Y)
PostMessage, 0x0202, 0x00000000, 0x01980015, , ahk_id 0x00050B1A ; 0x0202 = WM_LBUTTONUP
