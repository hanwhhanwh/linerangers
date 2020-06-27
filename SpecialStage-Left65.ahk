;===============================================================================
; @file SpecialStage-Left65.ahk
; @author hbesthee@naver.com
; @date 2020-06-26
;
; @description SPECIAL STAGE Left 6, 5 stages�� ���� ���� ��ũ��Ʈ
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

g_nStartingMinute := Mod(A_Min, 10)
g_nStartCombat := 0
g_nDelayForNextCombat := 0 ; ���� ������ �����ϱ� ���� ����� �ð�(���� : ��)
g_nUseTornado := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ����̵�(Tornado)�� �����. 0�̸� ������
g_nUseIceShot := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���̽���(Ice Shot)�� �����. 0�̸� ������
g_nUseUseMeteor := 0 ; ������ ������ ��, ������ �ð� ��(����:��)�� ���׿�(Meteor)�� �����. 0�̸� ������



CheckAppPlayer( g_nInstance )
CreateLogWindow()

AppendLogWIndow( "Start SpecialStage Left65 Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()



; �����Ͽ� ó���� �ܰ迡 ���� ���� ; [ [x, y, stage_num], ... ]
;g_arrStages := [ [675, 242, 6], [673, 184, 5], [610, 105, 4], [518, 105, 3], [452, 163, 2], [438, 238, 1] ]
g_arrStages := [ [358, 269, 6], [358, 183, 5] ]


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
AppendLogWIndow( "#" . nStage . ") Special Stage(Left65) ���� ����......" )


; Stage�� �´� ȯ�漳�� ������ �ٽ� �о��
strStageName := "SPECIAL_STAGE_LEFT" . nStage
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