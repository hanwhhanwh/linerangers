;===============================================================================
; @file SpecialStage-Normal.ahk
; @author hbesthee@naver.com
; @date 2017-06-26
;
; @description SPECIAL STAGE NORMAL�� ���� ��ũ��Ʈ
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

AppendLogWIndow( "Start [SpecialStage Normal] Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


CloseTeamviewer()


AppendLogWIndow(  "Special Stage�� Normal �������� ���� ���̵��� ȭ�� �� �������� �̵��ϱ�" )
Sleep 500

; Special Stage�� Normal ������ ���̵��� ȭ�� �� ���������� �̵��ϱ�
DragMouse( 795, 335, 5, 335 )
Sleep 500
DragMouse( 795, 335, 5, 335 )
Sleep 500
DragMouse( 795, 335, 5, 335 )
Sleep 500

; �� ȭ�� ������ �������� ��ũ���Ͽ� ������ �ʴ� �������̰� �ణ�� ���̵��� ��
DragMouse( 35, 335, 725, 335 )
Sleep 500



; �����Ͽ� ó���� �ܰ迡 ���� ���� ; [ [x, y, stage_num], ... ]
g_arrStages := [ [723, 245, 6], [733, 165, 5], [662, 100, 4], [421, 175, 15], [104, 158, 25], [41, 106, 24] ]


nSpecialStage := 1





SPECIAL_STAGES:

if (nSpecialStage > g_arrStages.Length() )
{
	MsgBox, % g_arrStages.Length() . " stages complete!..."
	ExitApp, 0
}

nX := g_arrStages[nSpecialStage][1]
nY := g_arrStages[nSpecialStage][2]
nStage := g_arrStages[nSpecialStage][3]


ClickClientPoint( nX, nY, 5000 )
AppendLogWIndow( "#" . nStage . ") Special Stage(Normal) ���� ����......" )


; Stage�� �´� ȯ�漳�� ������ �ٽ� �о��
strStageName := "SPECIAL_STAGE_ND"
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
