;===============================================================================
; @file Test.ahk
; @author hbesthee@naver.com
; @date 2016-10-01
;
; @description Lab �ڵ�ȭ ; �ƷüҸ� ��� ���۽�Ŵ
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk
#include ColorSet_inc.ahk

if ( !InitializeLineRangers() )
{
	MsgBox LineRangers ��ũ��Ʈ �ʱ�ȭ ����!!!
	ExitApp, 0
}


; ���� �������� ��Ȱ��ȭ ������ ���� Ȯ�ο� �� ����
g_arrColorSetIsBackground		:= [ [233, 645, 0xFFFFFF], [1060, 690, 0x667294], [644, 100, 0x698491] ]
; ���� ���������� Ȱ��ȭ �Ǿ����� Ȯ���� �� ����ϴ� �� ����
g_arrColorSetWaitLineRangers	:= [ [35, 60, 0xFFFFEE], [39, 72, 0x0], [1234, 79, 0xFFFFFF] ]

; LAB ���� ��� ���� �κ�
; Line Rangers GEAR ȭ������ Ȯ���� ���� �÷� ����
g_arrColorSetIsGear				:= [ [36, 59, 0xFFFFEE], [110, 85, 0x00AAFF], [217, 80, 0xFFEE44] ]
; Line Rangers HOME ȭ������ Ȯ���� ���� �÷� ����
g_arrColorSetIsHome				:= [ [76, 297, 0x0], [160, 55, 0x351609], [1130, 715, 0xFFFFFF] ]
; Line Rangers LAB ȭ������ Ȯ���� ���� �÷� ����
g_arrColorSetIsLab				:= [ [36, 59, 0xFFFFEE], [370, 65, 0x00A2FF], [400, 75, 0xFFEE44] ]
; �Ʒ��� ���Կ� �������� ��� ��ġ�ϰ� �Ʒ� �Ϸ� ����
g_arrColorSetIsCompleteSlot		:= [ [237, 268, 0x17110B], [238, 382, 0x3A1B00], [239, 381, 0x50320F] ]
; �Ʒ��� ���Ϳ��� ������ ��ٸ��µ� ����ϴ� �� ����
g_arrColorSetWaitTrainingCenter	:= [ [921, 92, 0x2B1C0E], [675, 193, 0x894E15], [785, 588, 0x62381A] ]
; �Ʒ��� ���Ϳ��� ������ ROOOM������ ������ ��ٸ��µ� ����ϴ� �� ����
g_arrColorSetWaitEnteringRoom	:= [ [491, 663, 0x19BBD6], [715, 675, 0xFFFFFF], [1058, 680, 0xFFD43D] ]
; �Ʒ� ROOM���� TRAINING�� ����, ���� â�� ��Ÿ���� ���� ��ٸ��µ� ����ϴ� �� ����
g_arrColorSetWaitTrainingStatus	:= [ [492, 650, 0x19BBD6], [1200, 710, 0xFFFFFF], [1058, 703, 0xFFD43D] ]

g_arrColorSetWaitTrainingBonus	:= [ [425, 215, 0x8F0000], [743, 120, 0xFFFFFF], [780, 128, 0xFFE63D] ]
g_arrColorSetWaitTrainingReword	:= [ [482, 192, 0xFFFFFF], [630, 229, 0xFFE63D], [770, 247, 0xFF9800] ]

; LAB���� ������ �̵� ��ǥ ���
g_arrPointSetDragBegin	:= [ [110, 555], [238, 555], [366, 555], [494, 555], [622, 555] ] ; ������ ���� 128px
g_arrPointSetDragEnd	:= [ [332, 316], [485, 273], [645, 316], [799, 273], [953, 316] ]

; ������ > �Ʒ����� ���� Ŭ�� ��ġ : �� 4��
g_arrPointSetSlot	:= [ [230, 370], [500, 370], [770, 370], [1040, 370] ]

g_nAvailableSlotCount := 4 ; Ȱ��ȭ�� �Ʒ� ������ ����


; InputBox, strWaitSeconds, REPEAT LAB, ����� �ð�(��)�� �Է��Ͽ� �ֽʽÿ�.



g_arrColorSetIsTrainingComplete		:= [ [218, 286, 0xEEBB00], [237, 365, 0x3A1B00], [344, 379, 0xEDC007] ] ; ROOM�� ������ 270px

Loop, 3
{ ; ������ Room �Ʒ� �ϷḦ �˻��� �� �ֵ��� �� ���� ��ġ ����
	g_arrColorSetIsTrainingComplete[A_Index][1] := g_arrColorSetIsTrainingComplete[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
}
; MsgBox % Format(" Before g_arrColorSetIsTrainingComplete : 1 = {1:i} / 2 = {2:i} / 3 = {3:i}", g_arrColorSetIsTrainingComplete[1][1], g_arrColorSetIsTrainingComplete[2][1], g_arrColorSetIsTrainingComplete[3][1] )


CloseTeamviewer() ; ���� â �ݱ�
CheckAppPlayer( g_nInstance ) ; ���� �ν��Ͻ��� Ȱ��ȭ

if ( IsSameColorSet( g_arrColorSetIsLab ) == 0 )
{ ; Leonard's Lab ���� �̵�
	ClickPoint( g_ptShortButton, 700 )
	ClickPoint( g_ptSbLaboratory, 700 )

	DEBUG_STR(g_nInstance, " Wait move Leonard's Lab : " . A_TickCount)
	if ( WaitColorSet( g_arrColorSetIsLab, 30 ) = 0 )
	{
		AppendLog("Fail to move Leonard's Lab!")
		MsgBox, Fail to move Leonard's Lab!
		ExitApp, 0
	}
}

ClickPoint( g_ptLabCrystalLab, 700 )
DEBUG_STR(g_nInstance, " Wait move Leonard's Lab > Crystal Lab : " . A_TickCount)
if ( WaitColorSet( g_arrColorSetIsCrystalLab, 30 ) = 0 )
{
	AppendLog("Fail to move Leonard's Lab > Crystal Lab!")
	MsgBox, Fail to move Leonard's Lab > Crystal Lab!
	ExitApp, 0
}
AppendLog("success: move to Leonard's Lab > Crystal Lab.")


LAB_LOOP: ; ���� ���������� ���� �ݺ�


LoadGlobalVriable( "LAB" ) ; �����ҿ� ���� ���� ���� �ε�


DEBUG_STR(g_nInstance, " Ranger ascending order. " . A_TickCount)
while ( IsSimilarColorSet( g_arrColorSetIsLevelAscending, 15 ) == 0 )
{ ; �������� ���� ������������ ������
	ClickPoint( g_ptLabCrystalLabLevelOrder, 1000 )
	DEBUG_STR(g_nInstance, " Click ascending order. " . A_TickCount)
	Sleep 2000
}

DEBUG_STR(g_nInstance, " Select Leonard Ranger. " . A_TickCount)
Loop %g_nAvailableSlotCount%
{
	DEBUG_STR(g_nInstance, " Select Leonard Ranger: #" . A_Index)
	ClickPoint( g_ptLabCrystalLabRangerChecks[A_Index], 800 )
	;Sleep 2000
}

DEBUG_STR(g_nInstance, " Wait Leonard's Lab > Crystal Lab > Extract OK/Cancel window. " . A_TickCount)
ClickPoint( g_ptLabCrystalLabExtractButton, 700 )
if ( WaitColorSet( g_arrColorSetIsExtractCrystalYesNo, 30 ) = 0 )
{
	AppendLog("Fail to move Leonard's Lab > Crystal Lab > Extract!")
	MsgBox, Fail to move Leonard's Lab > Crystal Lab > Extract!
	ExitApp, 0
}

ClickPoint( g_ptLabCrystalLabExtractOkButton, 700 )
DEBUG_STR(g_nInstance, " Wait Leonard's Lab > Crystal Lab > Extract Completing. " . A_TickCount)
if ( WaitColorSet( g_arrColorSetIsExtractCrystalComplete, 30 ) = 0 )
{
	AppendLog("Fail to move Leonard's Lab > Crystal Lab > Extract complete!")
	MsgBox, Fail to move Leonard's Lab > Crystal Lab > Extract complete!
	ExitApp, 0
}

ClickPoint( g_ptLabCrystalLabExtractedOkButton, 700 )
DEBUG_STR(g_nInstance, " Wait Leonard's Lab > Crystal Lab " . A_TickCount)
if ( WaitColorSet( g_arrColorSetIsCrystalLab, 30 ) = 0 )
{
	AppendLog("Fail to move Leonard's Lab!!")
	MsgBox, Fail to move Leonard's Lab > Crystal Lab!!
	ExitApp, 0
}

CloseTeamviewer() ; ���� â �ݱ�
CheckAppPlayer( g_nInstance ) ; ���� �ν��Ͻ��� Ȱ��ȭ

; ExitApp, 0
Goto, LAB_LOOP


#b::
	MsgBox, REPEAT LAB�� ���� ��ũ��Ʈ�� ������ �����մϴ�.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
