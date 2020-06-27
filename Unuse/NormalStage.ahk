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

CheckAppPlayer( g_nInstance, false )

CreateLogWindow()
AppendLogWIndow( "Start Main Stage Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


strStageName := "NORMAL_STAGE"

g_nStartingMinute := Mod(A_Min, 10)
g_nStartCombat := 0
g_nDelayForNextCombat := 0 ; 다음 전투를 시작하기 전에 대기할 시간(단위 : 분)
g_nUseTornado := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 토네이도(Tornado)를 사용함. 0이면 사용안함
g_nUseIceShot := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 아이스샷(Ice Shot)을 사용함. 0이면 사용안함
g_nUseUseMeteor := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 메테오(Meteor)를 사용함. 0이면 사용안함
g_nMousePosX4EnterLevel := 400
g_nDelayForHome := 50 ; HOME 화면에서의 대기 시간(분)
g_nClearMaxCount := 5 ; 한번에 깰 MainStage 개수

nNormalStage := 0


g_arrColorSetIsMainStage				:= [ [115, 38, 0x00AAFF], [191, 38, 0x00AAFF], [498, 35, 0xFFEE44] ]


NORMAL_STAGE_LOOP:

LoadGlobalVriable( strStageName )

IniRead, g_nMousePosX4EnterLevel, LineRangers.ini, NORMAL_STAGE, MousePosX4EnterLevel, 643
IniRead, g_nDelayForHome, LineRangers.ini, NORMAL_STAGE, DelayForHome, 20
IniRead, g_nDelayForNextCombat, LineRangers.ini,% strStageName, DelayForNextCombat, 0
IniRead, g_nUseTornado, LineRangers.ini,% strStageName, UseTornado, 0
IniRead, g_nUseIceShot, LineRangers.ini,% strStageName, UseIceShot, 0
IniRead, g_nUseUseMeteor, LineRangers.ini,% strStageName, UseUseMeteor, 0
IniRead, g_nClearMaxCount, LineRangers.ini,% strStageName, ClearMaxCount, 5
;MsgBox %strStageName% Script start %g_nMousePosX4EnterLevel% %g_nUpgradeMineral%  %g_isInGameZoom% g_nDelayForNextCombat = %g_nDelayForNextCombat%


CloseTeamviewer()
CheckAppPlayer( g_nInstance )


AppendLogWIndow( "  NORMAL_STAGE >> Center stage 클릭 : #" . nNormalStage . " | " . g_nMousePosX4EnterLevel)
ClickClientPoint( g_nMousePosX4EnterLevel, 240, 500 )
Sleep 500


bTimeout := WaitNextButtonOnItemSelection()
If ( bTimeout = 0 )
{
	MsgBox, Normal mode의 아이템 선택으로 이동하지 못하였습니다...
	AppendLogWIndow( "    NORMAL_STAGE >> 아이템 선택으로 이동하지 못하여 종료. : " . A_TickCount)
	ExitApp, 0
}

AppendLogWIndow( "    NORMAL_STAGE >> 아이템 선택에서 Next 클릭 : " . A_TickCount)
ClickClientPoint( 400, 400, 1000 )


bTimeout := WaitNextButtonOnFriendSelection()
If ( bTimeout = 0 )
{
	MsgBox, Normal mode의 친구 선택으로 이동하지 못하였습니다...
	AppendLogWIndow( "    NORMAL_STAGE >> 친구 선택으로 이동하지 못하여 종료. : " . A_TickCount)
	ExitApp, 0
}

SelectFriend( g_isUseFriend )

AppendLogWIndow( "    NORMAL_STAGE >> 친구 선택에서 Next 클릭 : " . A_TickCount)
ClickClientPoint( 400, 400, 1000 )


bTimeout := WaitStartingCombat()
If ( bTimeout = 0 )
{
	MsgBox, NORMAL stage의 전투로 진입하지 못하였습니다...
	AppendLogWIndow( "    NORMAL_STAGE >> NORMAL stage의 전투로 진입하지 못하여 종료. : " . A_TickCount)
	ExitApp, 0
}
else if ( bTimeout = -1 )
{
	AppendLogWIndow( "    NORMAL_STAGE >> 깃털이 더 이상 없어 종료. : " . A_TickCount)
	ExitApp, 0 ; 깃털이 더 이상 없음
}

AppendLogWIndow( "    NORMAL_STAGE >> in combat... : " . A_TickCount)
Sleep 300

If ( g_isUseFriend )
{
	AppendLogWIndow( "    NORMAL_STAGE >> 친구 부르기 : " . A_TickCount)
	ClickClientPoint( 100, 55 )
	Sleep 100
}


; 시작과 함께 Rangers produce..
nRangerPosY := 410
ClickClientPoint( 570, nRangerPosY )
ClickClientPoint( 490, nRangerPosY, 300 )
ClickClientPoint( 400, nRangerPosY, 399 )
ClickClientPoint( 310, nRangerPosY, 899 )
;ClickClientPoint( 230, nRangerPosY, 99 )

; Click Auto ; X2
ClickClientPoint( 765, 110, 299 )
ClickClientPoint( 765, 110, 800 )


;ZoomOut( g_isInGameZoom ) ; 전장 전체 보기


SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )
If ( g_isUseFriend )
{
	SendClickAbsolute( g_hwndAppPlayer, 205, 95 ) ;Click 205, 95
	Sleep 10
}


COMBAT_ITEM_START_X		:= 100
COMBAT_ITEM_Y			:= 55
COMBAT_ITEM_GAP			:= 56

; 팀 변경하며 전투가 종료될 때까지 대기
While ( IsFinishCombat() = 0 )
{
	Loop, 30 ; = Sleep 3600
	{
		nCurrentTick := A_TickCount
		If ( (g_nUseTornado > 0) And (isUseTornado = 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseTornado * 1000) ) )
		{ ; Tornado 아이템 사용하기
			isUseTornado := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 2
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			strMsg = "g_nUseTornado = %g_nUseTornado%,  nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%"
			AppendLogWIndow( strMsg )
		}

		If ( (g_nUseIceShot > 0) And (isUseUseIceShot = 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseIceShot * 1000) ) )
		{ ; IceShot 아이템 사용하기
			isUseUseIceShot := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 1
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			strMsg = "g_nUseIceShot = %g_nUseIceShot%,  nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%"
			AppendLogWIndow( strMsg )
		}

		Sleep, 100 ; 3초 대기
		If ( IsFinishCombat() )
			Break
	}

	CloseTeamviewer()

	If ( IsFinishCombat() )
		Break

	if ( g_isChangingTeam )
		ClickClientPoint( 42, 50 )
}
AppendLogWIndow( "    NORMAL_STAGE >> 전투 종료..." )
Sleep 2000


bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% Normal stage의 전투 결과 보상 룰렛이 동작하는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}


AppendLogWIndow( "    NORMAL_STAGE >> 보상 수령하기" )
AcceptClearBonus(g_arrColorSetIsMainStage) ; 보상 수령


nNormalStage := nNormalStage + 1


AppendLogWIndow( "    NORMAL_STAGE >> Loop 마지막 : MainStage 대기하기" )

bTimeout := WaitColorSet(g_arrColorSetIsMainStage)
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% Main stage 화면에서 시작하여 주시기 바랍니다...
	AppendLogWIndow( "    NORMAL_STAGE >> Main stage 화면으로 이동하지 못하여 종료. : " . A_TickCount)
	ExitApp, 0
}

if ( nNormalStage < g_nClearMaxCount )
{
	Goto, NORMAL_STAGE_LOOP
}

ExitApp, 0


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
