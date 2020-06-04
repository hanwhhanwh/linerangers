;===============================================================================
; @file SpecialStage.ahk
; @author hbesthee@naver.com
; @date 2015-06-09
;
; @description SPECIAL STAGE를 위한 통합 스크립트
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

g_nStartingMinute := Mod(A_Min, 10)
g_nStartCombat := 0
g_nDelayForNextCombat := 0 ; 다음 전투를 시작하기 전에 대기할 시간(단위 : 분)
g_nUseTornado := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 토네이도(Tornado)를 사용함. 0이면 사용안함
g_nUseIceShot := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 아이스샷(Ice Shot)을 사용함. 0이면 사용안함
g_nUseUseMeteor := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 메테오(Meteor)를 사용함. 0이면 사용안함


CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWindow( "Start SpecialStage Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )

strStageName := "SPECIAL_STAGE_ND"

nSpecialStage := 0

g_ptEnter		:= [400, 420]

LoadGlobalVriable( strStageName )

IniRead, g_nDelayForNextCombat, LineRangers.ini,% strStageName, DelayForNextCombat, 0
IniRead, g_nUseTornado, LineRangers.ini,% strStageName, UseTornado, 0
IniRead, g_nUseIceShot, LineRangers.ini,% strStageName, UseIceShot, 0
IniRead, g_nUseUseMeteor, LineRangers.ini,% strStageName, UseUseMeteor, 0


SPECIAL_STAGE:

; Line Rangers GEAR 화면인지 확인할 때의 컬러 조합
g_arrColorSetIsSpecialStage				:= [ [291, 405, 0xEB1B00], [394, 427, 0xCF0F00], [504, 448, 0xB41000] ]

bTimeout := WaitColorSet(g_arrColorSetIsSpecialStage)
;bTimeout := WaitSpecialStage()
If ( bTimeout = 0 )
{
	AppendLogWindow( " AppPlayer%g_nInstance% SPECIAL stage(%strStageName%) 화면에서 시작하여 주시기 바랍니다..." )
	Run, RepeatLab.ahk
	ExitApp, 0
}

CloseTeamviewer()

; SPECIAL STAGE >> ENTER 클릭
AppendLogWindow( "SPECIAL STAGE >> ENTER 클릭" )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )

Sleep 500

; OK 버튼 색조합 ; 오늘의 입장 횟수를 모두 사용했는지 확인하기
g_arrColorSetOkButton			:= [ [ 350, 307, 0x00DD44 ], [404, 317, 0xFFFFFF], [447, 337, 0x009922] ]
if ( IsSameColorSet(g_arrColorSetOkButton) )
{
	AppendLogWindow( "SpecialStage > 오늘의 입장 횟수를 모두 사용했음")
	ClickClientPoint( 404, 317, 1000 )
	Run, RepeatLab.ahk
	ExitApp, 0
}


; 전투 진입단계 자동 처리
nResult := HandlerNextButton()
If (nResult = -1)
{
	AppendLogWindow( "SpecialStage > Item 선택 화면으로 진입 실패")
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 Item 선택 화면으로 진입 실패...
	ExitApp, 0
}
Else If (nResult = -2)
{
	AppendLogWindow( "SpecialStage > 친구 선택 화면으로 진입 실패")
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 친구 선택 화면으로 진입 실패...
	ExitApp, 0
}


AppendLogWindow( "  SPECIAL STAGE >> 전투 진입 시도..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )


nResult := WaitStartingCombat()
If ( nResult = 0 )
{
	AppendLogWindow( "  SPECIAL STAGE >> 전투 진입 실패..." )
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 전투로 진입하지 못하였습니다...
	ExitApp, 0
}
else if ( bTimeout = -1 )
{
	AppendLogWindow( "  SPECIAL STAGE >> 전투 진입을 위한 깃털 부족..." )
	ExitApp, 0 ; 깃털이 더 이상 없음
}

AppendLogWindow( "  SPECIAL STAGE >> 전투 시작..." )


; Auto combat X2
ClickClientPoint( 767, 110 )
ClickClientPoint( 767, 110, 500 )


;ZoomOut( g_isInGameZoom ) ; 전장 전체 보기

Sleep 2200 ; 자동 전투에서 무적 사용전 잠시 대기하기

If (g_isUseUnbeatable == 1)
	SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )
If ( g_isUseFriend )
{ ; 친구 부르기
	ClickClientPoint( 100, 55 )
	Sleep 10
}
g_nStartCombat := A_TickCount
isUseTornado := 0
isUseUseIceShot := 0

COMBAT_ITEM_START_X		:= 100
COMBAT_ITEM_Y			:= 55
COMBAT_ITEM_GAP			:= 56

CloseTeamviewer()
; 팀 변경하며 대기
While ( IsFinishCombat() = 0 )
{
	Loop, 30 ; = Sleep 3600
	{
		nCurrentTick := A_TickCount
		If ( (g_nUseTornado > 0) And (isUseTornado == 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseTornado * 1000) ) )
		{ ; Tornado 아이템 사용하기
			isUseTornado := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 2
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			strMsg = "g_nUseTornado = %g_nUseTornado%,  nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%"
			AppendLogWindow( strMsg )
		}

		If ( (g_nUseIceShot > 0) And (isUseUseIceShot == 0) And ( (nCurrentTick - g_nStartCombat) > (g_nUseIceShot * 1000) ) )
		{ ; IceShot 아이템 사용하기
			isUseUseIceShot := 1
			nItemStartX := COMBAT_ITEM_START_X + COMBAT_ITEM_GAP * 1
			If ( g_isUseFriend )
				nItemStartX += COMBAT_ITEM_GAP
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			ClickClientPoint( nItemStartX, COMBAT_ITEM_Y, 100 )
			strMsg = "g_nUseIceShot = %g_nUseIceShot%,  nItemStartX = %nItemStartX%  COMBAT_ITEM_Y = %COMBAT_ITEM_Y%"
			AppendLogWindow( strMsg )
		}

		Sleep, 100 ; 3초 대기
		If ( IsFinishCombat() )
			Break
	}
	If ( IsFinishCombat() )
		Break

	if ( g_isChangingTeam )
		ClickClientPoint( 42, 50 )
}
AppendLogWindow( "전투 종료..." )

CloseTeamviewer()

bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 전투 결과 보상 룰렛이 동작하는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}


AppendLogWindow( "보상 수령하기" )
AcceptClearBonus( g_arrColorSetIsSpecialStage ) ; 보상 수령

Sleep 1000

nSpecialStage := nSpecialStage + 1

if ( nSpecialStage = 20 )
{
	Run, RepeatLab.ahk
	ExitApp, 0
}

Sleep 1000
If ( g_nDelayForNextCombat > 0 )
{
	Sleep 3000
	Send {HOME} ; Click 1300, 690 ; AppPlayer HOME ( == HOME )
	strMsg = SPECIAL stage(%strStageName%) S_Minute = %g_nStartingMinute% Delay = %g_nDelayForNextCombat%
	DEBUG_STR( g_nInstance, strMsg )
	nTotal := g_nDelayForNextCombat / 10
	nLoop := 0
	While (nLoop < nTotal)
	{
		Sleep 420000 ; 7분 동안 대기
		While ( g_nStartingMinute != Mod(A_Min, 10) )
		{
			CloseTeamviewer()
			Sleep 2000
		}
		CheckAppPlayer( g_nInstance )
		Sleep 2000
		Click 600, 290 ; LineRangers 실행
		Sleep 4000

		SendClickAbsolute( g_hwndAppPlayer, 645, 685 )  ;Click 810, 845
		bTimeout := WaitNextButtonOnItemSelection()
		If ( bTimeout = 0 )
		{
			MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 아이템 선택 화면으로의 이동 실패
			ExitApp, 0
		}
		else if ( bTimeout = -1 )
		{
			ExitApp, 0
		}

		Sleep 2000
		SendClickAbsolute( g_hwndAppPlayer, 51, 73 ) ;Click 60, 90
		bTimeout := WaitSpecialStage()
		If ( bTimeout = 0 )
		{
			MsgBox, AppPlayer%g_nInstance% Delay SPECIAL stage(%strStageName%) 화면으로의 이동 실패
			ExitApp, 0
		}

		nLoop := nLoop + 1
		strMsg = SPECIAL stage(%strStageName%) S_Minute = %g_nStartingMinute% nLoop = %nLoop%
		DEBUG_STR( g_nInstance, strMsg )
		Sleep 2000
		If ( nLoop < nTotal )
			Send {HOME} ; Click 1300, 690 ; AppPlayer HOME ( == HOME )
	}
}
CloseTeamviewer()
strMsg = 루프 마지막 : SPECIAL stage(%strStageName%) S_Minute = %g_nStartingMinute%
AppendLogWindow( strMsg )

Goto, SPECIAL_STAGE

Return


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	;MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
