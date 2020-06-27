;===============================================================================
; @file EndlessStage.ahk
; @author hbesthee@naver.com
; @date 2015-06-09
;
; @description ENDLESS 모드 자동화
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

LoadGlobalVriable( "ENDLESS_MODE" )

g_nDealyCount := 30
g_nWaitTime := 0

IniRead, g_nDealyCount, LineRangers.ini, ENDLESS_MODE, DealyCount, 30
IniRead, g_nWaitTime, LineRangers.ini, ENDLESS_MODE, WaitTime, 30000

;MsgBox %g_strStageName% Script start g_nDealyCount = %g_nDealyCount%  g_nWaitTime = %g_nWaitTime%

ENDLESS_LOOP:

CloseTeamviewer()
CheckAppPlayer( g_nInstance )

bTimeout := WaitEndlessStartButton()
If ( bTimeout = 0 )
{
	msgbox, ENDLESS stage로 이동후 실행하여 주세요...
	ExitApp, 0
}

; ENDLESS STAGE >> ENTER 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 1200, 750) ;Click 1200, 750
Sleep 500

CloseTeamviewer()

bTimeout := WaitNextButtonOnItemSelection()
If ( bTimeout = 0 )
{
	msgbox, ENDLESS mode의 아이템 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}

; 아이템 선택에서 Next 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 800, 800) ;Click 800, 800
Sleep 500

CloseTeamviewer()

bTimeout := WaitNextButtonOnFriendSelection()
If ( bTimeout = 0 )
{
	msgbox, ENDLESS mode의 친구 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}

; 친구 선택에서 Next 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 800, 800) ;Click 800, 800
Sleep 500

CloseTeamviewer()

bTimeout := WaitStartingCombat()
If ( bTimeout = 0 )
{
	msgbox, ENDLESS mode의 전투로 진입하지 못하였습니다...
	ExitApp, 0
}
else if ( bTimeout = -1 )
	ExitApp, 0 ; 깃털이 더 이상 없음


; Auto 클릭하여 켜기
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 1530, 270) ;Click 1530, 270

; Wave 10 정도까지 대기
Loop %g_nDealyCount%
{
	Sleep, %g_nPeriodOfChangingTeam% ; 3초 대기
	SendClickAbsolute( g_hwndAppPlayer, 90, 95) ;Click 90, 95 ; 팀 바꾸기
}

CloseTeamviewer()

; Auto 끄기
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 1530, 270) ;Click 1530, 270

Sleep %g_nWaitTime%

CloseTeamviewer()

bTimeout := WaitFinishingCombat( 200 )
If ( bTimeout = 0 )
{
	msgbox, ENDLESS mode의 전투가 끝나는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}

SendClickAbsolute( g_hwndAppPlayer, 200, 450) ;Click 200, 450
Sleep 500


bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	msgbox, ENDLESS mode의 전투가 끝난 후, 보상 룰렛이 동작하는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 800, 780) ;Click 800, 780 ; 룰렛 멈추기

Sleep 1500 

; 보상 수령
SendClickAbsolute( g_hwndAppPlayer, 800, 780) ;Click 800, 780
Sleep 500


Goto, ENDLESS_LOOP


#x::
	MsgBox, ENDLESS 모드에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
