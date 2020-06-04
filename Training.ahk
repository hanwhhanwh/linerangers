;===============================================================================
; @file Test.ahk
; @author hbesthee@naver.com
; @date 2016-09-23
;
; @description Lab �ڵ�ȭ ; �ƷüҸ� ��� ���۽�Ŵ
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk

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

g_nAvailableSlotCount := 3 ; Ȱ��ȭ�� �Ʒ� ������ ����


; InputBox, strWaitSeconds, REPEAT LAB, ����� �ð�(��)�� �Է��Ͽ� �ֽʽÿ�.



g_arrColorSetIsTrainingComplete		:= [ [218, 286, 0xEEBB00], [237, 365, 0x3A1B00], [344, 379, 0xEDC007] ] ; ROOM�� ������ 270px

Loop, 3
{ ; ������ Room �Ʒ� �ϷḦ �˻��� �� �ֵ��� �� ���� ��ġ ����
	g_arrColorSetIsTrainingComplete[A_Index][1] := g_arrColorSetIsTrainingComplete[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
}


LAB_LOOP: ; ���� ���������� ���� �ݺ�


CloseTeamviewer() ; ���� â �ݱ�
LoadGlobalVriable( "LAB" ) ; �����ҿ� ���� ���� ���� �ε�

CheckAppPlayer( g_nInstance ) ; ���� �ν��Ͻ��� Ȱ��ȭ

/*

strTitle := "subWin1"
strClass := "sub"
g_hwndAppPlayer := WinExist( strTitle, strClass )
If ( g_hwndAppPlayer ) 
{
	DEBUG_STR(g_nInstance, "Find subWin")
	
	SendClickAbsolute( g_hwndAppPlayer, 638, 246 ) ; ���� �������� ������ Ŭ��
	
	MsgBox, "Find subWin"
}

ExitApp, 0

if ( IsSameColorSet( g_arrColorSetIsLab ) )
{
	DEBUG_STR(g_nInstance, " In Lab : " . A_TickCount)
	MsgBox, In Lab
}

; 1060, 630

Click 1300, 690 ; AppPlayer�� Home ��ư Ŭ�� = ���� ���������� ��׶���� �����(CPU ������ �ּ�ȭ)
*/

if ( IsSimilarColorSet( g_arrColorSetIsBackground ) )
{
	DEBUG_STR(g_nInstance, " Launch LineRangers : " . A_TickCount)
	LaunchLineRangers( g_hwndAppPlayer )
	
	if ( WaitColorSet( g_arrColorSetIsLab, 30 ) = 0 )
	{
		MsgBox, Line Rangers�� �ٽ� �����ϰ�, Lab���� �̵��ϴµ� ���� �߻�
		ExitApp, 0
	}
}


if ( IsSameColorSet( g_arrColorSetIsGear ) )
{
	DEBUG_STR(g_nInstance, " In Gear : " . A_TickCount)

	SendClickAbsolute( g_hwndAppPlayer, 1230, 78, 500 ) ;Click 1230, 78
	; Goto LAB
	SendClickAbsolute( g_hwndAppPlayer, 1078, 557, 1000 ) ;Click 1078, 557
	if ( WaitColorSet( g_arrColorSetIsLab, 30 ) = 0 )
	{
		MsgBox, Fail to move LAB
		ExitApp, 0
	}
}


if ( IsSameColorSet( g_arrColorSetIsLab ) )
{
	DEBUG_STR(g_nInstance, " Move Train Center : " . A_TickCount)
	SendClickAbsolute( g_hwndAppPlayer, 400, 570, 1000 ) ;Click 1230, 78

	DEBUG_STR(g_nInstance, " Waiting Training Center...")
	if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
	{
		MsgBox, Lab -> Training Center �̵��� ���� �߻�
		ExitApp, 0
	}
/*
	;239, 319 ; 0x50320F
	;239, 383 ; 0x3A1B00
	
	if ( IsSameColorSet( g_arrColorSetIsCompleteSlot ) )
	{
		DEBUG_STR(g_nInstance, " Complete Slot #1 : " . A_TickCount)
		SendClickAbsolute( g_hwndAppPlayer, 237, 397, 1500)
	}
*/
}

/*
Sleep 2000
SendClickAbsolute( g_hwndAppPlayer, 1230, 78 ) ;Click 1230, 78
Sleep 2000
SendClickAbsolute( g_hwndAppPlayer, 1078, 300 ) ;Click 1078, 557

if ( IsSameColorSet( g_arrColorSetIsGear ) )
{
	Sleep 2000
	Click 1303, 692
}
*/

if ( IsSimilarColorSet(g_arrColorSetIsTrainingComplete, 25) )
{
	nX := 237
	nY := 379
	DEBUG_STR(g_nInstance, " IsTrainingComplete : " . A_TickCount)
	Loop %g_nAvailableSlotCount%
	{
		Click %nX%, %nY%
		DEBUG_STR(g_nInstance, " WaitTrainingBonus : " . A_TickCount)
		if ( WaitColorSet( g_arrColorSetWaitTrainingBonus, 30 ) = 0 )
		{
			MsgBox, Select ROOM �̵��� ���� �߻�
			ExitApp, 0
		}
		Click %nX%, %nY%
		DEBUG_STR(g_nInstance, " WaitTrainingReword : " . A_TickCount)
		Sleep 1500
		Click %nX%, %nY%
		DEBUG_STR(g_nInstance, " WaitTrainingCenter : " . A_TickCount)
		if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
		{
			MsgBox, Select ROOM �̵��� ���� �߻�
			ExitApp, 0
		}

		DEBUG_STR(g_nInstance, "Select ROOM #" . A_Index)
		SendClickAbsolute( g_hwndAppPlayer, g_arrPointSetSlot[A_Index][1], g_arrPointSetSlot[A_Index][2] ) ; �Ʒ� �� Ŭ��

		if ( WaitColorSet( g_arrColorSetWaitEnteringRoom, 30 ) = 0 )
		{
			MsgBox, Select ROOM �̵��� ���� �߻�
			ExitApp, 0
		}

		DEBUG_STR(g_nInstance, " Change ranger sort order " . A_TickCount)
		Click 900, 450 ; SendClickAbsolute( g_hwndAppPlayer, 900, 450 )
		Sleep 500
		;SendClickAbsolute( g_hwndAppPlayer, 900, 450, 500 )
		Click 900, 450
		
		nPointCount := 5
		Loop %nPointCount%
		{
			DEBUG_STR(g_nInstance, " Move Ranger Slot #" . A_Index . "/" . nPointCount)
			Sleep 1000
			MouseClickDrag, L, g_arrPointSetDragBegin[A_Index][1], g_arrPointSetDragBegin[A_Index][2],  g_arrPointSetDragEnd[A_Index][1], g_arrPointSetDragEnd[A_Index][2], 20
		}

		SendClickAbsolute( g_hwndAppPlayer, 643, 688, 1000) ; Click Traning button
		DEBUG_STR(g_nInstance, " Waiting training status...")
		if ( WaitColorSet( g_arrColorSetWaitTrainingStatus, 10 ) = 0 )
		{
			; �̵��� ���� �߻�
			MsgBox, training status �̵��� ���� �߻�
			ExitApp, 0
		}

		SendClickAbsolute( g_hwndAppPlayer, 48, 72, 1000 ) ; �ڷ� Ŭ�� -> �Ʒ� ���ͷ� �̵�
		DEBUG_STR(g_nInstance, " Waiting Training Center...")
		if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
		{
			MsgBox, Select ROOM �̵��� ���� �߻�
			ExitApp, 0
		}

		nX += 270
	} ; Loop %g_nAvailableSlotCount%
}

ExitApp, 0


SendClickAbsolute( g_hwndAppPlayer, 48, 72, 1000 ) ; �ڷ� Ŭ�� -> Lab�� �̵�
DEBUG_STR(g_nInstance, " Waiting Lab...")
if ( WaitColorSet( g_arrColorSetIsLab, 30 ) = 0 )
{
	MsgBox, Move Lab �̵��� ���� �߻�
	ExitApp, 0
}

Sleep 500
Click 1300, 690 ; AppPlayer�� Home ��ư Ŭ�� = ���� ���������� ��׶���� �����(CPU ������ �ּ�ȭ)

nDelayTime := 60
Loop %nDelayTime%
{ ; 1�� ���� ���
	DEBUG_STR(g_nInstance, " Sleeping... : " . (nDelayTime - A_Index + 1) . "sec ramained" )
	Sleep 1000
}


; ExitApp, 0
Goto, LAB_LOOP


#b::
	MsgBox, REPEAT LAB�� ���� ��ũ��Ʈ�� ������ �����մϴ�.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
