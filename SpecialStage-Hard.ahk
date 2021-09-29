;===============================================================================
; @file SpecialStage-Hard.ahk
; @author hbesthee@naver.com
; @date 2017-06-23
;
; @description SPECIAL STAGE Hard를 위한 스크립트
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

AppendLogWIndow( "Start [SpecialStage Hard] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()


;AppendLogWIndow(  "Special Stage의 Hard 진행중인 곳이 보이도록 화면 맨 왼쪽으로 이동하기" )
;Sleep 500
;
;; Special Stage의 Diffcult 레벨이 보이도록 화면 맨 오른쪽으로 이동하기
;DragMouse( 795, 335, 5, 335 )
;Sleep 500
;DragMouse( 795, 335, 5, 335 )
;Sleep 500



; 입장하여 처리할 단계에 대한 정보 ; [ [x, y, stage_num], ... ]
;g_arrStages := [ [358, 269, 6], [358, 183, 5], [287, 120, 4], [190, 120, 3], [125, 180, 2], [132, 267, 1] ]
g_arrStages := [ [358, 269, 6], [129, 165, 2] ]
if (A_WDay = 4 or A_WDay = 7 or A_WDay = 1) ; Wen, Sat, Sun can earn double money.
{
	AppendLogWindow( A_WDay . " : more money!!!" )
	g_arrStages := [ [358, 269, 6], [358, 183, 5], [287, 120, 4], [129, 165, 2] ]
}

nSpecialStage := 1





SPECIAL_STAGES:

if (nSpecialStage > g_arrStages.Length() )
{
	AppendLogWindow( g_arrStages.Length() . " stages complete!..." )
	;Run, RepeatLab.ahk
	ExitApp, 0
}

nX := g_arrStages[nSpecialStage][1]
nY := g_arrStages[nSpecialStage][2]
nStage := g_arrStages[nSpecialStage][3]


ClickClientPoint( nX, nY, 5000 )
AppendLogWIndow( "#" . nStage . ") Special Stage(Hard) 로의 진입......" )


; Stage에 맞는 환경설정 정보를 다시 읽어옴
strStageName := "SPECIAL_STAGE_HARD" . nStage
AutoCombatSpecialStage( strStageName )


Sleep 1000
nSpecialStage := nSpecialStage + 1

if ( nSpecialStage > 6 )
{
	ExitApp, 0
}


Goto, SPECIAL_STAGES


#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
