﻿;===============================================================================
; @file SpecialStage_inc.ahk
; @author hbesthee@naver.com
; @date 2017-06-23
;
; @description SPECIAL STAGE를 위한 함수 스크립트
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk




AutoCombatSpecialStage( strStageName )
{

; Stage에 맞는 환경설정 정보를 다시 읽어옴
LoadGlobalVriable( strStageName )

IniRead, g_isUseUnbeatable, LineRangers.ini,% strStageName, UseUnbeatable, 0
IniRead, g_nUseTornado, LineRangers.ini,% strStageName, UseTornado, 0
IniRead, g_nUseIceShot, LineRangers.ini,% strStageName, UseIceShot, 0
IniRead, g_nUseUseMeteor, LineRangers.ini,% strStageName, UseUseMeteor, 0
IniRead, g_isChangingTeam, LineRangers.ini,% strStageName, IsChangingTeam, 1
IniRead, g_nTermOfChangeTeam, LineRangers.ini,% strStageName, PeriodOfChangingTeam, 4500

g_ptEnter		:= [400, 420]



SPECIAL_STAGE:


; Line Rangers GEAR 화면인지 확인할 때의 컬러 조합
;g_arrColorSetIsSpecialStage				:= [ [291, 405, 0xF52004], [394, 427, 0xD3170D], [504, 448, 0xA60F00] ]
g_arrColorSetIsSpecialStage				:= [ [291, 405, 0xF72000], [400, 440, 0xD61408], [504, 448, 0xA50C00] ]

bTimeout := WaitColorSet(g_arrColorSetIsSpecialStage)
;bTimeout := WaitSpecialStage()
If ( bTimeout = 0 )
{
	AppendLogWIndow( "SpecialStage > 진입실패!" )
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%) 화면에서 시작하여 주시기 바랍니다...
	ExitApp, 0
}

CloseTeamviewer()

; SPECIAL STAGE >> ENTER 클릭
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 1500 )
AppendLogWIndow( "SPECIAL STAGE >> ENTER 클릭" )

Sleep 4500

; OK 버튼 색조합 ; 오늘의 입장 횟수를 모두 사용했는지 확인하기
;g_arrColorSetOkButton			:= [ [ 350, 307, 0x00DD44 ], [404, 317, 0xFFFFFF], [447, 337, 0x009922] ]
g_arrColorSetOkButton			:= [ [ 350, 307, 0x00DB42 ], [404, 317, 0xFFFFFF], [447, 337, 0x009A21] ]
;if ( IsSameColorSet(g_arrColorSetOkButton) )
if ( IsSimilarColorSet(g_arrColorSetOkButton, 10) )
{ ; 깃털이 더 이상 없으면, 나가서 다음 단계를 진행하도록 함
	AppendLogWIndow( "SpecialStage > 오늘의 입장 횟수를 모두 사용했음")
	ClickClientPoint( 404, 317, 1000 )
	ClickClientPoint( 30, 40, 1000 )

	nSpecialStage := nSpecialStage + 1

	return true ; 깃털이 더 이상 없음
}

; 전투 진입단계 자동 처리
; nResult := HandlerNextButton()
; If (nResult = -1)
; {
; 	AppendLogWindow( "SpecialStage > Item 선택 화면으로 진입 실패")
; 	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 Item 선택 화면으로 진입 실패...
; 	ExitApp, 0
; }
; Else If (nResult = -2)
; {
; 	AppendLogWindow( "SpecialStage > 친구 선택 화면으로 진입 실패")
; 	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 친구 선택 화면으로 진입 실패...
; 	ExitApp, 0
; }
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )


AppendLogWindow( "  SPECIAL STAGE >> 전투 진입 시도..." )
ClickClientPoint( 600, g_ptEnter[2], 1500 )

Sleep 500
{
	arrFreeButton := [ [276, 346, 0xA555EF], [289, 355, 0x8C2CE7], [340, 374, 0x6B20AD] ]
	If (IsSimilarColorSet(arrFreeButton))
	{
		AppendLogWindow( "  무료 광고 시청을 통한 깃털 받기" )
		ClickClientPoint( 276, 346, 500 ) ; 무료 광고 보기
		; ClickClientPoint( 730, 50, 32000 ) ; 30초 대기 후, 광고창 닫기
		Sleep 31000
		;Send, {Esc}
		SendBackButton()
		ClickClientPoint( 400, 410, 1500 ) ; 무료 깃털 받기
		ClickClientPoint( 600, 410, 2000 ) ; 전투진입 재시도
	}
}


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


AppendLogWIndow( "  전투중..." )

; Auto combat X2
;ClickClientPoint( 767, 110, 500 )
;ClickClientPoint( 767, 110, 1000 )


;ZoomOut( g_isInGameZoom ) ; 전장 전체 보기


If (g_isUseUnbeatable = 1)
	Sleep 2500 ; 자동 전투에서 무적 사용전 잠시 대기하기
	SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )
If ( g_isUseFriend )
{ ; 친구 부르기
	ClickClientPoint( 100, 55 )
	Sleep 100
}
g_nStartCombat := A_TickCount
isUseTornado := 0
isUseUseIceShot := 0

COMBAT_ITEM_START_X		:= 100
COMBAT_ITEM_Y			:= 55
COMBAT_ITEM_GAP			:= 56


; 팀 변경하며 전투가 종료될 때까지 대기
While ( IsFinishCombat() = 0 )
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

	ProduceRanger(400)

	ProduceRanger(320)

	ProduceRanger(235)

	ProduceRanger(485)

	ProduceRanger(570)

	if ( g_isChangingTeam )
	{
		if (nNextTeamChangeTick < A_TickCount)
		{
			nNextTeamChangeTick := A_TickCount + g_nTermOfChangeTeam
			ClickClientPoint( 42, 50 )
		}
	}

	If ( IsFinishCombat() )
		Break
}
AppendLogWIndow( "전투 종료..." )


bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 전투 결과 보상 룰렛이 동작하는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}


AppendLogWIndow( "보상 수령하기" )
AcceptClearBonus( g_arrColorSetIsSpecialStage ) ; 보상 수령


if ( nSpecialStage >= 20 )
{
	ExitApp, 0
}

CloseTeamviewer()
strMsg = 루프 마지막 : %strStageName% nStage = %nStage%
AppendLogWIndow( strMsg )


Goto, SPECIAL_STAGE


return true

}
