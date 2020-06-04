;===============================================================================
; @file Infinitower.ahk
; @author hbesthee@naver.com
; @date 2017-12-09
;
; @description INFINITOWER 자동화
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
AppendLogWindow( "Start INFINITOWER Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )

CheckAppPlayer( g_nInstance, true )

INFINITOWER_LOOP:


LoadGlobalVriable( "INFINITOWER" )


CloseTeamviewer()


g_arrColorSetIsInfinitower := [ [199, 44, 0x00AAFF], [530, 79, 0x4F2E10], [636, 383, 0xB41000] ]
AppendLogWindow( "  Check INFINITOWER...")
bTimeout := WaitColorSet(g_arrColorSetIsInfinitower)
If ( bTimeout = 0 )
{
	AppendLogWindow( "  INFINITOWER 로 이동후 실행하여 주세요...")
	msgbox, INFINITOWER로 이동후 실행하여 주세요...
	ExitApp, 0
}

; INFINITOWER >> BATTLE 클릭
ClickClientPoint( 553, 385, 1000 )
Sleep 500

CloseTeamviewer()

g_arrColorSetIsSelectItem := [ [294, 397, 0x19BBD6], [390, 412, 0xFFFFFF], [494, 440, 0x057188] ]
AppendLogWindow( "  Wait item selection button")
bTimeout := WaitColorSet(g_arrColorSetIsSelectItem)
If ( bTimeout = 0 )
{
	AppendLogWindow( "  INFINITOWER의 ITEM 선택 부분으로 이동하지 못하였습니다...")
	msgbox, INFINITOWER의 ITEM 선택 부분으로 이동하지 못하였습니다...
	ExitApp, 0
}
; INFINITOWER >> NEXT 클릭
ClickClientPoint( 400, 415, 1000 )


AppendLogWindow( " Wait NextButtonOnFriendSelection : " . A_TickCount)
bTimeout := WaitNextButtonOnFriendSelection()
If ( bTimeout = 0 )
{
	msgbox, TEAM BATTLE의 친구 선택으로 이동하지 못하였습니다...
	ExitApp, 0
}
;SelectFriend( g_isUseFriend )

; 친구 선택에서 Next 클릭
ClickClientPoint( 400, 410, 500 )
Sleep 1000


Sleep 1000
ClickClientPoint( 400, 410, 500 )
Sleep 4000 ; 실제 전투로 들어올 때까지 대기하는 시간
g_arrColorSetIsInfinitowerCombat := [ [760, 29, 0x030201], [761, 76, 0x030201], [777, 53, 0x79391A] ]
AppendLogWindow( "  Wait INFINITOWER combat...")
bTimeout := WaitColorSet(g_arrColorSetIsInfinitowerCombat)
If ( bTimeout = 0 )
{
	AppendLogWindow( "  INFINITOWER의 전투로 진입하지 못하였습니다...")
	msgbox, INFINITOWER의 전투로 진입하지 못하였습니다...
	ExitApp, 0
}
else if ( bTimeout = -1 )
{
	AppendLogWindow( "  깃털이 없어서 INFINITOWER 스크립트를 종료합니다...")
	ExitApp, 0 ; 깃털이 더 이상 없음
}

; 시작과 함께 Rangers produce..
g_arrColorSetIsTimeLimitCombat := [ [577, 395, 0xEFAA77], [610, 400, 0xEFAA77], [661, 395, 0xEFAA77] ]
If ( IsSameColorSet(g_arrColorSetIsTimeLimitCombat) )
{
	nRangerPosY := 410, nLanePosX := 200

	ClickClientPoint( nLanePosX, 300 )
	ClickClientPoint( 134, nRangerPosY )
	ClickClientPoint( 220, nRangerPosY, 500 )

	ClickClientPoint( nLanePosX, 247, 500 )
	ClickClientPoint( 300, nRangerPosY, 500 )
	ClickClientPoint( 385, nRangerPosY, 500 )

	ClickClientPoint( nLanePosX, 196, 500 )
	ClickClientPoint( 465, nRangerPosY, 500 )
}
else
{
	nRangerPosY := 410, nLanePosX := 200

	ClickClientPoint( nLanePosX, 300 )
	ClickClientPoint( 236, nRangerPosY )
	ClickClientPoint( 318, nRangerPosY, 500 )

	ClickClientPoint( nLanePosX, 247, 500 )
	ClickClientPoint( 400, nRangerPosY, 500 )
	ClickClientPoint( 489, nRangerPosY, 500 )

	ClickClientPoint( nLanePosX, 196, 500 )
	ClickClientPoint( 569, nRangerPosY, 500 )
}

; Click Auto ; X2
ClickClientPoint( 763, 139, 500 )
ClickClientPoint( 765, 139, 500 )


nLoopCount := 1, nLoopTotal := 2000, nLaneY := 196
g_arrColorSetIsCombatComplete := [ [268, 222, 0], [286, 227, 0xF39AF8], [394, 232, 0xAA24B6] ]
g_arrColorSetIsBossDefeat := [ [259, 272, 0xEB51F3], [346, 259, 0xEB51F3], [528, 261, 0xEB51F3] ]
While ( nLoopCount < nLoopTotal )
{
	Sleep 1830

	If ( IsSameColorSet(g_arrColorSetIsCombatComplete) )
	{
		AppendLogWindow( "  INFINITOWER의 전투 종료...")
		break
	}
	If ( IsSameColorSet(g_arrColorSetIsBossDefeat) )
	{
		AppendLogWindow( "  INFINITOWER의BOSS Defeat...")
		break
	}

	nLaneY := nLaneY + 50
	if (nLaneY > 310)
		nLaneY := 196

	ClickClientPoint( nLanePosX, nLaneY )

	nLoopCount := nLoopCount + 1
}


ClickClientPoint( 380, 410, 3000 )
ClickClientPoint( 380, 410, 3000 )
ClickClientPoint( 380, 410, 3000 )
ClickClientPoint( 380, 410, 3000 )
ClickClientPoint( 380, 410, 3000 )

Sleep 1000


Goto, INFINITOWER_LOOP


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
