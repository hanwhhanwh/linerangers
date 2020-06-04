;===============================================================================
; @file NormalStage-800.ahk
; @author hbesthee@naver.com
; @date 2015-06-12
;
; @description Normal 모드 자동화 ( 800, 460 )
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

g_nMousePosX4EnterLevel := 800
g_nDelayForHome := 20 ; HOME 화면에서의 대기 시간(분)

IniRead, g_nMousePosX4EnterLevel, LineRangers.ini, NORMAL_STAGE, MousePosX4EnterLevel, 800
IniRead, g_nDelayForHome, LineRangers.ini, NORMAL_STAGE, DelayForHome, 20


NORMAL_STAGE_LOOP:


CheckAppPlayer( g_nInstance )

bTimeout := WaitHome()
If ( bTimeout = 0 )
{
	MsgBox, HOME 으로 이동후 실행하여 주세요...
	ExitApp, 0
}

CloseTeamviewer()


; START 버튼 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 1450, 770 ) ;Click 1450, 770
Sleep 500


bTimeout := WaitMainStage()
If ( bTimeout = 0 )
{
	MsgBox, Main Stage로 이동하지 못하였습니다...
	ExitApp, 0
}

; 800, 460 위치의 Stage 클릭하여 들어가기
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, g_nMousePosX4EnterLevel, 460 ) ;Click 800, 460
Sleep 500


bTimeout := WaitNextButtonOnItemSelection()
If ( bTimeout = 0 )
{
	MsgBox, Normal mode의 아이템 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}

; 아이템 선택에서 Next 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 800, 800 ) ;Click 800, 800
Sleep 500


bTimeout := WaitNextButtonOnFriendSelection()
If ( bTimeout = 0 )
{
	MsgBox, Normal mode의 친구 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}

SelectFriend( g_isUseFriend )

; 친구 선택에서 Next 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 800, 800 ) ;Click 800, 800
Sleep 500


bTimeout := WaitStartingCombat()
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage의 전투로 진입하지 못하였습니다...
	ExitApp, 0
}
else if ( bTimeout = -1 )
	ExitApp, 0 ; 깃털이 더 이상 없음

SendClickAbsolute( g_hwndAppPlayer, 200, 460 ) ;Click 200, 460

UpgradeMineral( g_nUpgradeMineral )

ZoomOut( g_isInGameZoom ) ; 전장 전체 보기

; Auto 클릭하여 켜기
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 1530, 215 ) ;Click 1530, 215

SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )
If ( g_isUseFriend )
{
	SendClickAbsolute( g_hwndAppPlayer, 205, 95 ) ;Click 205, 95
	Sleep 10
}

Sleep, 10000 ; 10초 대기

; 팀 변경하며 대기
While ( IsFinishCombat() = 0 )
{
	Loop, 12 ; = Sleep 3600
	{
		Sleep, 300 ; 3초 대기
		If ( IsFinishCombat() )
			Break
	}
	If ( IsFinishCombat() )
		Break
	SendClickAbsolute( g_hwndAppPlayer, 90, 95 ) ;Click 90, 95 ; 팀 바꾸기
}


bTimeout := WaitFinishingCombat( 180 )
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage의 전투가 끝나는 것을 감지하지 못하였습니다...
	ExitApp, 0
}

Sleep 1500
SendClickAbsolute( g_hwndAppPlayer, 200, 450 ) ;Click 200, 450


ClickLevelUp()

bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage의 전투가 끝난 후, 보상 룰렛이 동작하는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}
Sleep 1000
SendClickAbsolute( g_hwndAppPlayer, 800, 780 ) ;Click 800, 780 ; 룰렛 멈추기


AcceptClearBonus() ; 보상 수령


bTimeout := WaitMainStage()
If ( bTimeout = 0 )
{
	MsgBox, Main Stage로 이동하지 못하였습니다...
	ExitApp, 0
}


Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 60, 90 ) ;Click 60, 90
Sleep 500


bTimeout := WaitHome()
If ( bTimeout = 0 )
{
	MsgBox, HOME 화면으로의 이동이 실패하였습니다...
	ExitApp, 0
}


StandByHome( g_nDelayForHome ) ; HOME 화면에서 깃털이 추가될 때까지 대기하도록 함


Goto, NORMAL_STAGE_LOOP


#x::
	MsgBox, NORMAL stage에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
