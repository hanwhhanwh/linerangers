;===============================================================================
; @file SpecialStage-Event.ahk
; @author hbesthee@naver.com
; @date 2017-03-03
;
; @description SPECIAL STAGE Event를 위한 통합 스크립트
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk
#include SpecialStage_inc.ahk


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

AppendLogWIndow( "Start SpecialStage EVENT Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )

CloseTeamviewer()


; 입장하여 처리할 단계에 대한 정보 ; [ [x, y, stage_num], ... ]
g_arrStages := [ [358, 183, 5], [132, 267, 1], [190, 120, 3], [287, 120, 4], [125, 180, 2], [358, 269, 6] ]


nSpecialStage := 1





SPECIAL_STAGES:

if (nSpecialStage > g_arrStages.Length() )
{
	AppendLogWindow( g_arrStages.Length() . " stages complete!..." )
	Run, RepeatLab.ahk
	ExitApp, 0
}

nX := g_arrStages[nSpecialStage][1]
nY := g_arrStages[nSpecialStage][2]
nStage := g_arrStages[nSpecialStage][3]


ClickClientPoint( nX, nY, 5000 )
AppendLogWIndow( "#" . nStage . ") Special Stage(EVENT) 로의 진입......" )


; Stage에 맞는 환경설정 정보를 다시 읽어옴
strStageName := "SPECIAL_STAGE_EVENT" . nStage
AutoCombatSpecialStage( strStageName )


Sleep 1000
nSpecialStage := nSpecialStage + 1

if ( nSpecialStage > 6 )
{
	Run, RepeatLab.ahk
	ExitApp, 0
}


Goto, SPECIAL_STAGES


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return