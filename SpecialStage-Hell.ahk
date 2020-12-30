;===============================================================================
; @file SpecialStage-Hell.ahk
; @author hbesthee@naver.com
; @date 2017-06-23
;
; @description SPECIAL STAGE Hell ���� ��ũ��Ʈ
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk
#include SpecialStage_inc.ahk


if ( !InitializeLineRangers() )
{
	MsgBox LineRangers ��ũ��Ʈ �ʱ�ȭ ����!!!
	ExitApp, 0
}

g_nCountOfClearStage := 3
g_nStartingMinute := Mod(A_Min, 10)
g_nStartCombat := 0
g_nDelayForNextCombat := 0 ; ���� ������ �����ϱ� ���� ����� �ð�(���� : ��)
g_nUseTornado := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ����̵�(Tornado)�� �����. 0�̸� ������
g_nUseIceShot := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���̽���(Ice Shot)�� �����. 0�̸� ������
g_nUseUseMeteor := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���׿�(Meteor)�� �����. 0�̸� ������


IniRead, g_nCountOfClearStage, LineRangers.ini, SPECIAL_STAGE_ND, CountOfClearStage, 0


CheckAppPlayer( g_nInstance )

CreateLogWindow()
AppendLogWindow( "Start SpecialStage Hell Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )

CloseTeamviewer()


; Wen, Sat, Sun : All stages, else 4 stages
if (A_WDay in 1,4,7)
	g_arrStages := [ [675, 242, 6], [673, 184, 5], [610, 105, 4], [518, 105, 3], [452, 163, 2], [438, 238, 1] ]
else
	g_arrStages := [ [675, 242, 6], [673, 184, 5], [610, 105, 4], [452, 163, 2] ]


;g_arrStages := [ [675, 242, 6], [673, 184, 5], [610, 105, 4], [452, 163, 2] ]
g_arrStages := [ [675, 242, 6], [673, 184, 5], [610, 105, 4], [518, 105, 3], [452, 163, 2], [438, 238, 1] ]
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
AppendLogWindow( "#" . nStage . ") Special Stage(HELL) ���� ����......" )


; Stage�� �´� ȯ�漳�� ������ �ٽ� �о��
strStageName := "SPECIAL_STAGE_HELL" . nStage
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
