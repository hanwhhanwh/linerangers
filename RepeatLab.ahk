;===============================================================================
; @file RepeatLab.ahk
; @author hbesthee@naver.com
; @date 2016-09-23
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
g_arrColorSetIsGear				:= [ [20, 32, 0xFFFFEE], [106, 45, 0x00AAFF], [143, 42, 0xFFEE44] ]
; Line Rangers HOME ȭ������ Ȯ���� ���� �÷� ����
g_arrColorSetIsHome				:= [ [129, 357, 0xFFFFFF], [15, 39, 0x351609], [706, 443, 0xFFFFFF] ]
; �Ʒ��� ���Կ� �������� ��� ��ġ�ϰ� �Ʒ� �Ϸ� ����
g_arrColorSetIsCompleteSlot		:= [ [237, 268, 0x17110B], [238, 382, 0x3A1B00], [239, 381, 0x50320F] ]


g_arrColorSetWaitTrainingReword	:= [ [482, 192, 0xFFFFFF], [630, 229, 0xFFE63D], [770, 247, 0xFF9800] ]


; ������ > �Ʒ����� ���� Ŭ�� ��ġ : �� 4��
g_arrPointSetSlot	:= [ [230, 370], [500, 370], [770, 370], [1040, 370] ]

g_nAvailableSlotCount := 4 ; Ȱ��ȭ�� �Ʒ� ������ ����


; InputBox, strWaitSeconds, REPEAT LAB, ����� �ð�(��)�� �Է��Ͽ� �ֽʽÿ�.


g_arrColorSetIsTrainingComplete1		:= [ [190, 481, 0xE2E1D9], [240, 481, 0xE2E1D9], [290, 481, 0xE2E1D9] ] ; ROOM�� ������ 270px
g_arrColorSetIsTrainingComplete2		:= [ [190, 481, 0xFDFDF4], [240, 481, 0xFDFDF4], [290, 481, 0xFDFDF4] ] ; ROOM�� ������ 270px


; ROOM�� �Ϸ� ���θ� Ȯ���� �� ����
g_arrColorSetIsTrainingComplete			:= [ [183, 441, 0xDEDED5], [293, 441, 0xF2F2E9], [232, 463, 0xE7E6E5] ]
g_nRoomGap								:= 270 ; ROOM�� ������ 270px


Loop, 3
{ ; ������ Room �Ʒ� �ϷḦ �˻��� �� �ֵ��� �� ���� ��ġ ����
	g_arrColorSetIsTrainingComplete1[A_Index][1] := g_arrColorSetIsTrainingComplete1[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
	g_arrColorSetIsTrainingComplete2[A_Index][1] := g_arrColorSetIsTrainingComplete2[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
}
; MsgBox % Format(" Before g_arrColorSetIsTrainingComplete1 : 1 = {1:i} / 2 = {2:i} / 3 = {3:i}", g_arrColorSetIsTrainingComplete1[1][1], g_arrColorSetIsTrainingComplete1[2][1], g_arrColorSetIsTrainingComplete1[3][1] )


CloseTeamviewer() ; ���� â �ݱ�
CheckAppPlayer( g_nInstance, false ) ; ���� �ν��Ͻ��� Ȱ��ȭ
CreateLogWindow()

AppendLogWindow( "Start RepeatLab Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


if ( IsSimilarColorSet( g_arrColorSetIsBackground ) )
{
	AppendLogWindow("    Launch LineRangers : " . A_TickCount)
	;LaunchLineRangers( g_hwndAppPlayer )
	ClickClientPoint( 151, 243, 500 )
	
	if ( WaitColorSet( g_arrColorSetIsLeonardLab, 30 ) = 0 )
	{
		MsgBox, Line Rangers�� �ٽ� �����ϰ�, Lab���� �̵��ϴµ� ���� �߻�
		ExitApp, 0
	}
}


if ( IsSimilarColorSet( g_arrColorSetIsSettingsNotice ) )
{ ; ����â �����̸�, �������� â�� ����
	AppendLogWindow( "    Close Settings > Notice : " . A_TickCount)
	ClickClientPoint( 777, 23, 500 )
	Sleep 700
}


if ( IsSimilarColorSet( g_arrColorSetIsSettings ) )
{ ; ����â �����̸�, ����â�� ����
	DEBUG_STR(g_nInstance, "    Close Settings : " . A_TickCount)
	ClickClientPoint( 696, 42, 500 )
	Sleep 1700
}



LAB_INIT: ; ������ �ʱ�ȭ

; Line Rangers Leonard's LAB ȭ������ Ȯ���� ���� �÷� ����
;g_arrColorSetIsLeonardLab				:= [ [193, 45, 0x00A2FF], [229, 43, 0x00A2FF], [258, 42, 0xFFEE44] ]
g_arrColorSetIsLeonardLab			:= [ [34, 32, 0xFFEE44], [229, 43, 0x00A1FD], [259, 42, 0xFFEE44] ]

g_ptShortMoveButton		:= [771, 39]
g_ptSbLaboratory	:= [757, 337]
;if ( IsSameColorSet( g_arrColorSetIsLeonardLab ) == 0 )
if ( IsSimilarColorSet( g_arrColorSetIsLeonardLab ) == 0 )
{ ; Leonard's Lab ���� �̵�

	ClickClientPoint( g_ptShortMoveButton[1], g_ptShortMoveButton[2], 700 )
	ClickClientPoint( g_ptSbLaboratory[1], g_ptSbLaboratory[2], 700 )

	AppendLogWindow( "    Wait move Leonard's Lab : " . A_TickCount)
	if ( WaitColorSet( g_arrColorSetIsLeonardLab, 30 ) = 0 )
	{
		AppendLog("    Fail to move Leonard's Lab!")
		MsgBox, Fail to move Leonard's Lab!
		ExitApp, 0
	}
}
AppendLogWindow( "    Leonard's Lab Ȯ�� : " . A_TickCount)









strIniSctionName := "Repeat LAB"
LoadGlobalVriable( strIniSctionName ) ; �����ҿ� ���� ���� ���� �ε�

IniRead, isCraftMatirial, LineRangers.ini, %strIniSctionName%, isCraftMatirial, 0
IniRead, isUltimate, LineRangers.ini, %strIniSctionName%, isUltimate, 0
IniRead, isAsendingGrade, LineRangers.ini, %strIniSctionName%, isAsendingGrade, 0
IniRead, nMatirialScrollCount, LineRangers.ini, %strIniSctionName%, nMatirialScrollCount, 5
IniRead, nMaririalClickY, LineRangers.ini, %strIniSctionName%, nMaririalClickY, 257
IniRead, nSleepTime, LineRangers.ini, %strIniSctionName%, SleepTime, 600000


if ( IsSameColorSet( g_arrColorSetIsLeonardLab ) )
{
	AppendLogWindow( "    Move Train Center : " . A_TickCount)
	ClickClientPoint( 400, 330, 700 )

	; �Ʒ��� ���Ϳ��� ������ ��ٸ��µ� ����ϴ� �� ����
	g_arrColorSetWaitTrainingCenter	:= [ [798, 397, 0x850106], [167, 46, 0x00A2FF], [296, 37, 0xFFEE44] ]

	AppendLogWindow( "    Waiting Training Center...")
	if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
	{
		MsgBox, Lab -> Training Center �̵��� ���� �߻�
		ExitApp, 0
	}
}
else
{
	AppendLogWindow( "    AppPlayer%g_nInstance% Leonard's Lab Ȯ�� ����")
	MsgBox, AppPlayer%g_nInstance% Leonard's Lab Ȯ�� ����
	ExitApp, 0
}

isTrainingComplete := 0
nX := 147
nY := 241
g_nRoomGap								:= 169 ; ROOM�� ����
Loop, 4
{
	nRoomIndex := A_Index
	AppendLogWindow( "    Is traning complete? : #" . nRoomIndex)
	Sleep 1000
	
	arrColorSetCompleteTrain := [ [146, 230, 0x3A1B00], [146, 241, 0xEABC00], [179, 280, 0xF1F1F1] ]
	; �˻��� Room�� �°� �Ʒ� �Ϸ� ���� �˻��� �� ������ ��ǥ �̵���
	{
		arrColorSetCompleteTrain[1][1] := arrColorSetCompleteTrain[1][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetCompleteTrain[2][1] := arrColorSetCompleteTrain[2][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetCompleteTrain[3][1] := arrColorSetCompleteTrain[3][1] + (nRoomIndex - 1) * g_nRoomGap
	}
	
	if ( IsSimilarColorSet(arrColorSetCompleteTrain, 50) ) ; nRoomIndex Room�� �Ʒ��� �Ϸ�Ǿ��°�?
	{
		isTrainingComplete := isTrainingComplete := 1
		AppendLogWindow( "    #" . nRoomIndex . " ROOM training completed")

		; �Ʒ��� �Ϸ�� �뿡 �� ������ �����Ѵ�.
		ClickClientPoint( nX, nY, 500 )

		; ���� ���� Ȯ�� ������
		g_arrColorSetWaitTrainingBonus	:= [ [484, 86, 0xFF0000], [463, 69, 0xFFFFFF], [486, 74, 0xFFE63D] ]
		AppendLogWindow( "    WaitTrainingBonus : #" . nRoomIndex)
		if ( WaitColorSet( g_arrColorSetWaitTrainingBonus, 30 ) = 0 )
		{
			MsgBox, Select ROOM �̵��� ���� �߻�
			ExitApp, 0
		}
		AppendLogWindow( "    WaitTrainingReword : #" . nRoomIndex)
		ClickClientPoint( 400, 50, 800 )
		ClickClientPoint( 400, 50, 800 )
		ClickClientPoint( 400, 50, 800 )
		Sleep 1500
	}
/*
	arrColorSetNeedTrain := [ [133, 240, 0xE4D100], [160, 239, 0xEDD900], [140, 250, 0xE8D400] ]
	; �˻��� Room�� �°� �Ʒ� �ʿ� ���� �˻��� �� ������ ��ǥ �̵���
	{
		arrColorSetNeedTrain[1][1] := arrColorSetNeedTrain[1][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetNeedTrain[2][1] := arrColorSetNeedTrain[2][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetNeedTrain[3][1] := arrColorSetNeedTrain[3][1] + (nRoomIndex - 1) * g_nRoomGap
	}

	if ( IsSimilarColorSet(arrColorSetNeedTrain, 30) ) ; nRoomIndex Room�� �Ʒ��� �ʿ��Ѱ�?
	{
		; �뿡 �� ������ �������� �Ʒý�Ų��.
		ClickClientPoint( nX, nY, 500 )

		; �Ʒ��� ���Ϳ��� ������ ROOOM������ ������ ��ٸ��µ� ����ϴ� �� ����
		g_arrColorSetWaitEnteringRoom	:= [ [305, 408, 0x19BBD6], [446, 427, 0xFFFFFF], [661, 419, 0xF0D942] ]

		AppendLogWindow( "      Wait for Entering TrainingRoom : #" . nRoomIndex)
		if ( WaitColorSet( g_arrColorSetWaitEnteringRoom, 30 ) = 0 )
		{
			MsgBox, Select ROOM �̵��� ���� �߻�
			ExitApp, 0
		}

		; ������ ���� ó��
		AppendLogWindow( "      Change ranger sort order #" . nRoomIndex)
		ClickClientPoint( 746, 274, 1000 ) ; Filter ����
		if (nRoomIndex < 3) ; 1, 2 �Ʒ����� ���
			ClickClientPoint( 492, 129, 1000 ) ; 7�� ������ ����
		if (nRoomIndex > 2) ; 3, 4 �Ʒ����� ���
			ClickClientPoint( 275, 172, 1000 ) ; �Ϲݷ����� ����
		ClickClientPoint( 465, 420, 1000 ) ; OK ����
		ClickClientPoint( 640, 277, 1000 ) ; Sort by ����
		ClickClientPoint( 620, 319, 1000 ) ; ���� ���� ����
		;ClickClientPoint( 409, 354, 1000 ) ; �����ȼ�
		;ClickClientPoint( 510, 354, 1000 ) ; ��޼�
		Sleep 2500
		
		; LAB���� ������ �̵� ��ǥ ���
		g_arrPointSetDragBegin	:= [ [65, 340], [145, 340], [225, 340], [305, 340], [385, 340] ] ; ������ ���� 80 px
		g_arrPointSetDragEnd	:= [ [205, 206], [304, 186], [400, 206], [500, 186], [600, 206] ]

		nPointCount := 5
		Loop %nPointCount%
		{
			AppendLogWindow( "     Move Ranger Slot #" . nRoomIndex . " : " . A_Index . "/" . nPointCount)
			Sleep 200
			;MouseClickDrag, L, g_arrPointSetDragBegin[A_Index][1], g_arrPointSetDragBegin[A_Index][2],  g_arrPointSetDragEnd[A_Index][1], g_arrPointSetDragEnd[A_Index][2], 10
			DragMouse(g_arrPointSetDragBegin[A_Index][1], g_arrPointSetDragBegin[A_Index][2], g_arrPointSetDragEnd[A_Index][1], g_arrPointSetDragEnd[A_Index][2])
			Sleep 1200
		}

		ClickClientPoint( 400, 420, 500 ) ; Click Traning button

		; �Ʒ� ROOM���� TRAINING�� ����, ���� â�� ��Ÿ���� ���� ��ٸ��µ� ����ϴ� �� ����
		g_arrColorSetWaitTrainingStatus	:= [ [305, 444, 0x24AAC6], [755, 435, 0xFFFFFF], [493, 451, 0x057188] ]

		AppendLogWindow( "    Waiting training status...")
		if ( WaitColorSet( g_arrColorSetWaitTrainingStatus, 10 ) = 0 )
		{
			; �̵��� ���� �߻�
			MsgBox, training status �̵��� ���� �߻�
			ExitApp, 0
		}

		ClickClientPoint( 28, 38, 1000 ) ; �ڷ� Ŭ�� -> �Ʒ� ���ͷ� �̵�
		AppendLogWindow( "    Waiting Training Center...")
		if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
		{
			MsgBox, Select ROOM �̵��� ���� �߻�
			ExitApp, 0
		}
	}
*/
	nX := nX + g_nRoomGap ; ���� Room Ŭ�� ��ġ
}


ClickClientPoint( 28, 38, 1000 ) ; �ڷ� Ŭ�� -> Lab ���� �̵�
AppendLogWindow( "    Waiting Lab...")
if ( WaitColorSet( g_arrColorSetIsLeonardLab, 30 ) = 0 )
{
	MsgBox, Move Lab �̵��� ���� �߻�
	ExitApp, 0
}

Sleep 1000


if ( !isCraftMatirial )
	Goto, SKIP_CRAFT_MATIRIAL

AppendLogWindow( "    >>> Matirial Lab ������..." )
ClickClientPoint( 400, 250, 1000 )

arrColorSetIsMatirialLab := [ [50, 347, 0x40961B], [494, 384, 0x1D8C0E], [770, 100, 0x0C2803] ]
if ( WaitColorSet( arrColorSetIsMatirialLab, 30 ) = 0 )
{ ; 
	AppendLogWindow( "    >>> Matirial Lab ���� ����. Repeat Lab ��ũ��Ʈ �ʱ�ȭ..." )
	Goto, LAB_INIT
}

Sleep 1500
; �Ϸ� ���θ� �˻��� ���� ��ġ
arrCheckCompletedSlot := [ [397, 140], [518, 140], [638, 140], [458, 251] ] ; 0xFFFFFE
; �� �������� �˻��� ��ġ
;arrCheckEmptySlot := [ [422, 169, 0x070A06], [543, 169, 0x070A06], [663, 169, 0x070A06], [482, 277, 0x070A06] ] ; 0x070A06
arrCheckProducingSlot := [ [424, 244, 0x000100], [535, 244, 0x000100], [655, 244, 0x000100], [474, 352, 0x000100] ] ; 0x070A06

nEmptySlotCount := 0
for nIndex, arrColorSetProducingSlot in arrCheckProducingSlot
{
	if ( IsSameColorSet( [ arrColorSetProducingSlot ] ) )
	{
		AppendLogWindow( "    ��� Slot #" . nIndex . "������..." )
		continue
	}

	if ( IsSameColor( arrCheckCompletedSlot[nIndex], 0xFFFFFE ) )
	{
		AppendLogWindow( "    ��� Slot #" . nIndex . " : ��ȭ��� ���� �Ϸ�" )
		ClickClientPoint( arrColorSetProducingSlot[1], arrColorSetProducingSlot[2] - 50, 1000 )
		ClickClientPoint( 400, 405, 1000 ) ; "OK" ���� ; ���ۿϷ� ��� �ޱ�
		nEmptySlotCount := nEmptySlotCount + 1
		Sleep 1000
		continue
	}

;	if ( IsSimilarColorSet( [ arrColorSetProducingSlot ], 10 ) )
	if ( !IsSameColorSet( [ arrColorSetProducingSlot ] ) )
	{
		nEmptySlotCount := nEmptySlotCount + 1
	}
}


if (nEmptySlotCount > 0)
{ ; �� ������ ���� ��쿡�� ��ȭ��Ḧ �����ϵ��� ��
	AppendLogWindow( "    ��ȭ ��� �� ���� ����" )
	nToChangeUltimateMatirialX := 147
	nToChangeRegularMatirialX := 263
	nToChangeMatirialY := 79

	if ( !isUltimate )
	{
		AppendLogWindow( "    �Ϲ� ��ȭ��� ����")
		ClickClientPoint( nToChangeRegularMatirialX, nToChangeMatirialY, 1000 ) ; Regular ����
	}

	if ( isAsendingGrade )
	{
		AppendLogWindow( "    ��ȭ��� �������� ����")
		ClickClientPoint( 300, 125, 1000 ) ; ��� �������� ���� ����
	}
	Sleep 1000

	AppendLogWindow( "	  INI���� ������ ��ŭ ��� ��ġ�� �̵�" )
	nToScrollMatirialX := 200
	nToScrollMatirialTopY := 145
	nToScrollMatirialBottomY := 400

	;nMatirialScrollCount := 4
	Loop, %nMatirialScrollCount%
	{ ; INI�� ������ ��ȭ���� �̵�
		DragMouse(nToScrollMatirialX, nToScrollMatirialBottomY, nToScrollMatirialX, nToScrollMatirialTopY, 300, 500)
		Sleep 1000
	}

	for nIndex, arrColorSetProducingSlot in arrCheckProducingSlot
	{ ; ��ȭ��� ���� ó��
;		if ( IsSimilarColorSet( [ arrColorSetProducingSlot ], 10 ) )
		if ( !IsSameColorSet( [ arrColorSetProducingSlot ] )
			and !IsSameColor( arrCheckCompletedSlot[nIndex], 0xFFFFFE ) )
		{
			ClickClientPoint( 312, nMaririalClickY, 1000 ) ; 143, 193, 257, 320, 384
			ClickClientPoint( 420, 320, 1000 ) ; "CRAFTING" ����
			ClickClientPoint( 420, 320, 1000 ) ; "OK" ���� ; ����
			if ( WaitColorSet( arrColorSetIsMatirialLab, 30 ) = 0 )
			{ ; 
			}
			AppendLogWindow( "    >> ��ȭ��� ���� ���� : Slot #" . nIndex )
		}
	}
}

ClickClientPoint( 28, 38, 1000 ) ; �ڷ� Ŭ�� -> Lab ���� �̵�
AppendLogWindow( "    Waiting Lab...")
if ( WaitColorSet( g_arrColorSetIsLeonardLab, 30 ) = 0 )
{
	MsgBox, Move Lab �̵��� ���� �߻�
	ExitApp, 0
}

Sleep 1000


SKIP_CRAFT_MATIRIAL:


; Lab ���򸻷� �̵��Ͽ� �޽�
ClickClientPoint( 252, 39, 1000 ) ; ? ��ư Ŭ��

AppendLogWindow( "  Sleeping... " . nSleepTime)
Sleep %nSleepTime%
;Sleep 30000
InitializeClientPosition()


CloseTeamviewer() ; ���� â �ݱ�

ClickClientPoint( 764, 28 ) ; �ݱ� ��ư Ŭ��
Sleep 3000


; CheckAppPlayer( g_nInstance ) ; ���� �ν��Ͻ��� Ȱ��ȭ


Goto, LAB_INIT





#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0
