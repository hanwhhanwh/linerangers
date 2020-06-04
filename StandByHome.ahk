;===============================================================================
; @file StandByHome.ahk
; @author hbesthee@naver.com
; @date 2015-08-02
;
; @description HOME에서 대기하도록 하는 스크립트
;
;===============================================================================

#include Global.ahk
#include Utils_inc.ahk
#include Wait_inc.ahk
#include Worker_inc.ahk

if ( !InitializeLineRangers() )
{
	MsgBox LineRangers 스크립트 초기화 실패!!!
	ExitApp, 0
}

LoadGlobalVriable( "NORMAL_STAGE" )

NORMAL_STAGE_LOOP:


CheckAppPlayer( g_nInstance )

bTimeout := WaitHome()
If ( bTimeout = 0 )
{
	MsgBox, HOME 으로 이동후 실행하여 주세요...
	ExitApp, 0
}

CloseTeamviewer()


StandByHome( 60 ) ; HOME 화면에서 깃털이 추가될 때까지 대기하도록 함


Goto, NORMAL_STAGE_LOOP


#x::
	MsgBox, Stand by Home 에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
