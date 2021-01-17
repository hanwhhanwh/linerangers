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



CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWIndow( "Start [MainhardStage Hard] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()


;AppendLogWIndow( "Main-Hard Stage의 5 stage가 중앙에 보이도록 이동하기" )
;Sleep 500
;
;; Special Stage의 Diffcult 레벨이 보이도록 화면 맨 오른쪽으로 이동하기
;DragMouse( 795, 335, 5, 335 )
;Sleep 500
;DragMouse( 795, 335, 5, 335 )
;Sleep 500

; Main-Hard Stage의 5 stage가 중앙에 보이도록 이동하기
ClickClientPoint( 222, 430, 1500 )
AppendLogWIndow( "click : Main-stage Hard")
ClickClientPoint( 125, 357, 5000 )
AppendLogWIndow( "click : Hard 6 stage")
ClickClientPoint( 30, 40, 5000 )
AppendLogWIndow( "click : Back")
ClickClientPoint( 245, 325, 5000 )
AppendLogWIndow( "click : Hard 5 stage")
ClickClientPoint( 30, 40, 5000 )
AppendLogWIndow( "click : Back")
Sleep(5000)

; 입장하여 처리할 단계에 대한 정보 ; [ [x, y, stage_num], ... ]
g_arr5Stages	:= [ [665, 350, 1], [567, 300, 2], [457, 283, 3], [349, 273, 4] ]
g_arrStages		:= [ [300, 206, 2], [300, 206, 3], [300, 206, 4] ]
g_ptEnter		:= [400, 420]
nClearStage		:= 1

; 1 Hard-stage부터 입장이 가능한지 확인하여 입장되면 다음 진행
While ( nClearStage <= g_arrStages.Length() )
{
	nX := g_arrStages[nClearStage][1]
	nY := g_arrStages[nClearStage][2]
	nStage := g_arrStages[nClearStage][3]

	AppendLogWIndow( "click : Hard " . nStage . " stage")
	ClickClientPoint( nX, nY, 1000 )
	; 이미 clear된 것인지 확인
	if ( CheckOkButton(339, 296) )
	{
		AppendLogWIndow( "  cleard : Hard " . nStage . " stage")
		ClickClientPoint( 400, 320, 1000 )
		nClearStage := nClearStage + 1
		continue
	}
	break
}


MAIN_HARD_STAGES:

if (nClearStage > g_arrStages.Length() )
{
	AppendLogWindow( g_arrStages.Length() . " HARD stages complete!..." )
	;Run, RepeatLab.ahk
	ExitApp, 0
}



; Stage에 맞는 환경설정 정보를 다시 읽어옴
strStageName := "MAIN_HARD_STAGE" . nStage
;AutoCombatSpecialStage( strStageName )


AppendLogWIndow( "  팀 목록 호출 : " )
ClickClientPoint( 400, 160, 1000 )

AppendLogWIndow( "  팀 5 선택" )
ClickClientPoint( 400, 360, 1000 )

AppendLogWindow( "  친구 선택 진입..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )

AppendLogWindow( "  전투 진입 시도..." )
ClickClientPoint( g_ptEnter[1], g_ptEnter[2], 500 )

nResult := WaitStartingCombat()
If ( nResult = 0 )
{
	AppendLogWindow( "  전투 진입 실패..." )
	MsgBox, AppPlayer%g_nInstance% SPECIAL stage(%strStageName%)의 전투로 진입하지 못하였습니다...
	ExitApp, 0
}
else if ( bTimeout = -1 )
{
	AppendLogWindow( "  전투 진입을 위한 깃털 부족..." )
	ExitApp, 0 ; 깃털이 더 이상 없음
}

AppendLogWIndow( "  전투중..." )

; 전투 시작과 함께 레인저 소환
ProduceRanger( hwndAppPlayer, 400)
ProduceRanger( hwndAppPlayer, 320)
ProduceRanger( hwndAppPlayer, 235)
ProduceRanger( hwndAppPlayer, 485)
ProduceRanger( hwndAppPlayer, 570)

Sleep 2500 ; 자동 전투에서 무적 사용전 잠시 대기하기

If (g_isUseUnbeatable = 1)
	SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )

; 팀 변경하며 전투가 종료될 때까지 대기
While ( IsFinishCombat() = 0 )
{
	ProduceRanger( hwndAppPlayer, 400)

	ProduceRanger( hwndAppPlayer, 320)

	If ( IsFinishCombat() )
		Break

	ProduceRanger( hwndAppPlayer, 235)

	ProduceRanger( hwndAppPlayer, 485)

	If ( IsFinishCombat() )
		Break

	ProduceRanger( hwndAppPlayer, 570)

	if ( g_isChangingTeam )
	{
		if (nNextTeamChangeTick > GetTickCount)
		{
			nNextTeamChangeTick := nNextTeamChangeTick + 5000
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
AcceptClearBonus( g_arrColorSetIsSpecialStage ) ; 보상 수령

Sleep 1000

AppendLogWIndow( "  다음 Stage 진입 전..." )
nX := g_arrStages[nClearStage][1]
nY := g_arrStages[nClearStage][2]
nStage := g_arrStages[nClearStage][3]

nClearStage := nClearStage + 1

ClickClientPoint( nX, nY, 1000 )
AppendLogWIndow( "#" . nStage . ") HARD stage 로의 진입......" )


Goto, MAIN_HARD_STAGES


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
