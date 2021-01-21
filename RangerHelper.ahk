;===============================================================================
; @file RangerHelper.ahk
; @author hbesthee@naver.com
; @date 2021-01-17
;
; @description Ranger 출격 도우미 스크립트
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
g_isChangingTeam := 1 ; 팀 자동 변경하기
g_nTermOfChangeTeam := 5000 ; 팀 변경 시간



CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWIndow( "Start [Ranger Helper] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()


LOOP_COMBAT:

nResult := WaitStartingCombat(300)
If ( nResult = 0 )
{
	AppendLogWindow( "  전투 진입 실패..." )
	MsgBox, AppPlayer%g_nInstance% 전투로 진입하지 않았습니다...
	ExitApp, 0
}

AppendLogWIndow( "  전투중..." )

; 전투 시작과 함께 레인저 소환
ProduceRanger(400)
ProduceRanger(320)
ProduceRanger(235)
ProduceRanger(485)
ProduceRanger(570)

Sleep 2500 ; 자동 전투에서 무적 사용전 잠시 대기하기

If (g_isUseUnbeatable = 1)
	SelectUnbeatable( g_isUseUnbeatable, g_isUseFriend )

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

	if ( g_isChangingTeam )
	{
		if (nNextTeamChangeTick > A_TickCount)
		{
			nNextTeamChangeTick := A_TickCount + g_nTermOfChangeTeam
			ClickClientPoint( 42, 50 )
		}
	}
}
AppendLogWIndow( "  전투 종료..." )


Goto, LOOP_COMBAT

#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
