;===============================================================================
; @file ChallengeNormal.ahk
; @author hbesthee@naver.com
; @date 2015-06-09
;
; @description NORMAL STAGE 최초 도전 자동화
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

LoadGlobalVriable( "CHALLENGE_STAGE" )

CheckAppPlayer( g_nInstance )

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

SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )
If ( g_isUseFriend )
{ ; 친구 부르기
	;SendClickAbsolute( g_hwndAppPlayer, 205, 95 ) ;Click 205, 95
	Sleep 10
}

ProduceRangers( g_hwndAppPlayer, g_isChangingTeam, g_nPeriodOfChangingTeam, 95 )


bTimeout := WaitFinishingCombat( 120 )
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage의 전투가 끝나는 것을 감지하지 못하였습니다...
	ExitApp, 0
}

Sleep 500
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


nSpecialStage := nSpecialStage + 1

if ( nSpecialStage = 3 )
{
	ExitApp, 0
}

CloseTeamviewer(  )



#x::
	MsgBox, NORMAL stage에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
