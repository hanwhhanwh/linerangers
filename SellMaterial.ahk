;===============================================================================
; @file SellMaterial.ahk
; @author hbesthee@naver.com
; @date 2015-11-13
;
; @description 재료를 입력한 개수만큼 판매하는 스크립트
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk

if ( !InitializeLineRangers() )
{
	MsgBox LineRangers 스크립트 초기화 실패!!!
	ExitApp, 0
}

InputBox, strSellCount, Sell Materials, 판매할 아이템의 개수를 입력하여 주십시요.

CheckAppPlayer( g_nInstance )
Sleep 300

Loop, %strSellCount%
{
	Click 955, 555
	Sleep 15
}




#x::
	MsgBox, SellMaterial 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
