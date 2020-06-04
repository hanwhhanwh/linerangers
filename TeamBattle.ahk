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

CheckAppPlayer( g_nInstance, false )

CreateLogWindow()
AppendLogWIndow( "Start TEAM_BATTLE Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )

CheckAppPlayer( g_nInstance, true )

TEAM_BATTLE_LOOP:


LoadGlobalVriable( "TEAM_BATTLE" )


CloseTeamviewer()


bTimeout := WaitTeamBattleStartButton()
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE로 이동후 실행하여 주세요...
	ExitApp, 0
}

; TEAM_BATTLE >> BATTLE 클릭
ClickClientPoint( 600, 375, 500 )
Sleep 500

CloseTeamviewer()

g_arrColorSetIsTeamBattleOpponent := [ [308, 386, 0x07DA46], [645, 58, 0xFFEE44], [658, 56, 0] ]
AppendLogWIndow( " Wait TeamBattleOpponentButton : " . A_TickCount)
bTimeout := WaitColorSet(g_arrColorSetIsTeamBattleOpponent)
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE의 OPPONENT 선택 창으로 이동하지 못하였습니다...
	ExitApp, 0
}
; TEAM_BATTLE >> CHALLENGE 클릭
ClickClientPoint( 400, 400, 1500 )


AppendLogWIndow( " Wait NextButtonOnItemSelection : " . A_TickCount)
bTimeout := WaitNextButtonOnItemSelection()
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE의 아이템 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}

; 아이템 선택에서 Next 클릭
ClickClientPoint( 400, 410, 500 ) ;Click 800, 800


AppendLogWIndow( " Wait NextButtonOnFriendSelection : " . A_TickCount)
bTimeout := WaitNextButtonOnFriendSelection()
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE의 친구 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}
CloseTeamviewer()

;SelectFriend( g_isUseFriend )

; 친구 선택에서 Next 클릭
; Sleep 500
ClickClientPoint( 400, 410, 500 ) ;Click 800, 800
Sleep 500

AppendLogWIndow( " Wait Combat... : " . A_TickCount)
bTimeout := WaitStartingTeamBattleCombat()
If ( bTimeout = 0 )
{
	AppendLogWindow( "  깃털 부족으로 TEAM BATTLE의 전투로 진입하지 못하였습니다..." )
	ClickClientPoint( 336, 318 ) ; OK 클릭
	Sleep 1500
	Run, RepeatLab.ahk
	ExitApp, 0
}
else if ( bTimeout = -1 )
	ExitApp, 0 ; 깃털이 더 이상 없음
	
Sleep 5
; 시작과 함께 Rangers produce..
nRangerPosY := 410
ClickClientPoint( 570, nRangerPosY )
ClickClientPoint( 490, nRangerPosY, 250 )
ClickClientPoint( 400, nRangerPosY, 500 )

; Click Auto ; X2
ClickClientPoint( 765, 150, 350 )
ClickClientPoint( 765, 150, 350 )

ClickClientPoint( 310, nRangerPosY, 1500 )
ClickClientPoint( 50, 90, 300 )


;ZoomOut( g_isInGameZoom ) ; 전장 전체 보기


nLoopCount := 1
nLoopTotal := 2000 ; 200초 동안 대기
While ( nLoopCount < nLoopTotal )
{
	PixelGetColor, clrOutputColor1, g_nClientX + 113, g_nClientY + 17, RGB ; 0x720000 / 0x671A49
	PixelGetColor, clrOutputColor2, g_nClientX + 196, g_nClientY + 17, RGB ; 0x720000 / 0x671A49
	PixelGetColor, clrOutputColor3, g_nClientX + 387, g_nClientY + 79, RGB ; 0xFFE63D

	If ( (clrOutputColor1 = 0x720000)  or (clrOutputColor1 = 0x5C1843) )
			and ( (clrOutputColor2 = 0x720000)  or (clrOutputColor2 = 0x5C1843) )
			and ( (clrOutputColor3 = 0xFFE63D) )
		break

	Sleep 100 ; 100ms 대기
	nLoopCount := nLoopCount + 1
}


ClickClientPoint( 200, 450, 100 ) ;Click 200, 450
Sleep 1500



Goto, TEAM_BATTLE_LOOP


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
