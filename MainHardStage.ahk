;===============================================================================
; @file MainHardStage.ahk
; @author hbesthee@naver.com
; @date 2021-01-16
;
; @description Main Hard Stage 도우미 스크립트
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
g_nAutoMode := 1 ; Auto 배속 설정 : 0=배속 사용안함, 1=1배속, 2=2배속
g_nDelayForNextCombat := 0 ; 다음 전투를 시작하기 전에 대기할 시간(단위 : 분)
g_nUseTornado := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 토네이도(Tornado)를 사용함. 0이면 사용안함
g_nUseIceShot := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 아이스샷(Ice Shot)을 사용함. 0이면 사용안함
g_nUseUseMeteor := 0 ; 전투에 진입한 후, 지정된 시간 후(단위:초)에 메테오(Meteor)를 사용함. 0이면 사용안함
g_isUseUnbeatable := 1 ; 무적 사용
g_isChangingTeam := 1 ; 팀 교체


CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWIndow( "Start [MainhardStage Hard] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()


; Main-Hard Stage의 1 stage가 중앙에 보이도록 이동하기

ClickClientPoint( 710, 430, 1000 )
AppendLogWIndow( "click : Main-stage Hard [STAGE CHANGE]")
ClickClientPoint( 710, 390, 1000 )
AppendLogWIndow( "click : Main-stage Hard [STAGE 1]")

Sleep 3500

; 입장하여 처리할 단계에 대한 정보 ; [ [x, y, stage_num], ... ]
g_arrStages		:= [ [400, 240, 1], [300, 190, 2], [290, 220, 3], [290, 225, 4], [245, 200, 5], [200, 150, 6] ]
g_ptEnter		:= [400, 420]
nClearStage		:= 1

g_arrWaitColor	:= [[121, 427, 0x912ACE], [80, 412, 0x0B0D17], [764, 434, 0xE0D79D]]

Sleep 4000


MAIN_HARD_STAGES:


nX := g_arrStages[nClearStage][1]
nY := g_arrStages[nClearStage][2]
nStage := g_arrStages[nClearStage][3]

ClickClientPoint( nX, nY, 1000 )
AppendLogWIndow( "click : Main Hard " . nStage . " stage")

Sleep 2000


; Stage에 맞는 환경설정 정보를 다시 읽어옴
strStageName := "MAIN_HARD_STAGE" . nStage


AppendLogWIndow( "  팀 목록 호출 : " )
ClickClientPoint( 400, 160, 1000 )

AppendLogWIndow( "  팀 5 선택" )
ClickClientPoint( 400, 360, 1000 )

AppendLogWindow( "  친구 선택 진입..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 1500 )

AppendLogWindow( "  전투 진입 시도..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 1500 )

nResult := WaitStartingCombat()
If ( nResult = 0 )
{
	AppendLogWindow( "  전투 진입 실패..." )
	MsgBox, AppPlayer%g_nInstance% Main hard stage(%strStageName%)의 전투로 진입하지 못하였습니다...
	ExitApp, 0
}
else if ( bTimeout = -1 )
{
	AppendLogWindow( "  전투 진입을 위한 깃털 부족..." )
	ExitApp, 0 ; 깃털이 더 이상 없음
}

AppendLogWIndow( "  전투중..." )

; 전투 시작과 함께 레인저 소환
ProduceRanger(400)
ProduceRanger(320)
ProduceRanger(235)
ProduceRanger(485)
ProduceRanger(570)

Sleep 700

If (g_isUseUnbeatable = 1)
	SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )

nNextTeamChangeTick := A_TickCount + 5500
; 팀 변경하며 전투가 종료될 때까지 대기
While ( IsFinishCombat() = 0 )
{
	ProduceRanger(400)

	ProduceRanger(320)

	If ( IsFinishCombat() )
		Break

	ProduceRanger(235)

	ProduceRanger(485)

	If ( IsFinishCombat() )
		Break

	ProduceRanger(570)

	if ( g_isChangingTeam = 1 )
	{
		if (nNextTeamChangeTick < A_TickCount)
		{
			nNextTeamChangeTick := A_TickCount + 5500
			ClickClientPoint( 42, 50 )
		}
	}
}
AppendLogWIndow( "  전투 종료..." )


bTimeout := WaitStartingRoulette()
If ( bTimeout = 0 )
{
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 전투 결과 보상 룰렛이 동작하는 것을 감지입하지 못하였습니다...
	ExitApp, 0
}


AppendLogWIndow( "  보상 수령하기" )
AcceptClearBonus( g_arrWaitColor ) ; 보상 수령

AppendLogWIndow( "  보상 수령완료 후, 대기하기" )
Sleep 2000


nClearStage		:= nClearStage + 1

Goto, MAIN_HARD_STAGES


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
