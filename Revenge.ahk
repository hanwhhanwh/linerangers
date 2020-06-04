;===============================================================================
; @file TeamBattle.ahk
; @author hbesthee@naver.com
; @date 2015-06-18
;
; @description TEAM BATTLE 모드 자동화 ; 친구는 반드시 추가해야 함
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


LoadGlobalVriable( "TEAM_BATTLE" )


CheckAppPlayer( g_nInstance )

CloseTeamviewer()


;bTimeout := WaitNextButtonOnItemSelection()
;If ( bTimeout = 0 )
;{
;	msgbox, TEAM BATTLE의 아이템 선택으로 이동하지 못하였습니다...
;	ExitApp, 0
;}

; 아이템 선택에서 Next 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 700, 670 ) ;Click 800, 800
Sleep 500

CloseTeamviewer()

bTimeout := WaitNextButtonOnFriendSelection()
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE의 친구 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}

;SelectFriend( g_isUseFriend )

; 친구 선택에서 Next 클릭
Sleep 500
SendClickAbsolute( g_hwndAppPlayer, 700, 670 ) ;Click 800, 800
Sleep 500


bTimeout := WaitStartingTeamBattleCombat()
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE의 전투로 진입하지 못하였습니다...
	ExitApp, 0
}
else if ( bTimeout = -1 )
	ExitApp, 0 ; 깃털이 더 이상 없음
	
Sleep 5
; 시작과 함께 Rangers produce..
nRangerPosY := 737
SendClickAbsolute( g_hwndAppPlayer, 778, nRangerPosY )
;Sleep 5
;SendClickAbsolute( g_hwndAppPlayer, 1083, 667 ) ; 처음 1회 미네랄업
Sleep 5
SendClickAbsolute( g_hwndAppPlayer, 376, nRangerPosY )
Sleep 5
SendClickAbsolute( g_hwndAppPlayer, 513, nRangerPosY )
Sleep 5
SendClickAbsolute( g_hwndAppPlayer, 646, nRangerPosY )
Sleep 5
SendClickAbsolute( g_hwndAppPlayer, 917, nRangerPosY )
Sleep 100
;SendClickAbsolute( g_hwndAppPlayer, 1083, 667 ) ; 처음 1회 미네랄업

;UpgradeMineral( g_nUpgradeMineral )

;If ( g_isUseFriend )
;{ ; 친구 부르기
;	SendClickAbsolute( g_hwndAppPlayer, 205, 95 ) ;Click 205, 95
;	Sleep 10
;}
SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )

ZoomOut( g_isInGameZoom ) ; 전장 전체 보기

ProduceRangers( g_hwndAppPlayer, g_isChangingTeam, g_nPeriodOfChangingTeam )


bTimeout := WaitFinishingtTeamBattle( 200 )
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE의 전투가 끝나는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}

SendClickAbsolute( g_hwndAppPlayer, 200, 450 ) ;Click 200, 450

ExitApp, 0 ; Exit script




#x::
	MsgBox, TEAM BATTLE에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
