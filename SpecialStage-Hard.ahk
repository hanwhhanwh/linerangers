;===============================================================================
; @file SpecialStage-Hard.ahk
; @author hbesthee@naver.com
; @date 2017-06-23
;
; @description SPECIAL STAGE Hard�� ���� ��ũ��Ʈ
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

AppendLogWIndow( "Start [SpecialStage Hard] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()


;AppendLogWIndow(  "Special Stage�� Hard �������� ���� ���̵��� ȭ�� �� �������� �̵��ϱ�" )
;Sleep 500
;
;; Special Stage�� Diffcult ������ ���̵��� ȭ�� �� ���������� �̵��ϱ�
;DragMouse( 795, 335, 5, 335 )
;Sleep 500
;DragMouse( 795, 335, 5, 335 )
;Sleep 500



; �����Ͽ� ó���� �ܰ迡 ���� ���� ; [ [x, y, stage_num], ... ]
;g_arrStages := [ [358, 269, 6], [358, 183, 5], [287, 120, 4], [190, 120, 3], [125, 180, 2], [132, 267, 1] ]
g_arrStages := [ [358, 269, 6], [129, 165, 2] ]
;if (A_WDay = 4 or A_WDay = 7 or A_WDay = 1) ; Wen, Sat, Sun can earn double money.
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
AppendLogWIndow( "#" . nStage . ") Special Stage(Hard) ���� ����......" )


; Stage�� �´� ȯ�漳�� ������ �ٽ� �о��
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
