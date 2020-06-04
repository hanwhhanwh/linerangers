;===============================================================================
; @file RepeatLab.ahk
; @author hbesthee@naver.com
; @date 2016-09-23
;
; @description Lab 자동화 ; 훈련소를 계속 동작시킴
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk
#include ColorSet_inc.ahk

if ( !InitializeLineRangers() )
{
	MsgBox LineRangers 스크립트 초기화 실패!!!
	ExitApp, 0
}


; 라인 레인져스 비활성화 상태인 여부 확인용 색 조합
g_arrColorSetIsBackground		:= [ [233, 645, 0xFFFFFF], [1060, 690, 0x667294], [644, 100, 0x698491] ]
; 라인 레인져스가 활성화 되었음을 확인할 때 사용하는 색 조합
g_arrColorSetWaitLineRangers	:= [ [35, 60, 0xFFFFEE], [39, 72, 0x0], [1234, 79, 0xFFFFFF] ]

; LAB 관련 상수 정의 부분
; Line Rangers GEAR 화면인지 확인할 때의 컬러 조합
g_arrColorSetIsGear				:= [ [20, 32, 0xFFFFEE], [106, 45, 0x00AAFF], [143, 42, 0xFFEE44] ]
; Line Rangers HOME 화면인지 확인할 때의 컬러 조합
g_arrColorSetIsHome				:= [ [129, 357, 0xFFFFFF], [15, 39, 0x351609], [706, 443, 0xFFFFFF] ]
; 훈련장 슬롯에 레인저를 모두 배치하고 훈련 완료 여부
g_arrColorSetIsCompleteSlot		:= [ [237, 268, 0x17110B], [238, 382, 0x3A1B00], [239, 381, 0x50320F] ]


g_arrColorSetWaitTrainingReword	:= [ [482, 192, 0xFFFFFF], [630, 229, 0xFFE63D], [770, 247, 0xFF9800] ]


; 연구실 > 훈련장의 슬롯 클릭 위치 : 총 4개
g_arrPointSetSlot	:= [ [230, 370], [500, 370], [770, 370], [1040, 370] ]

g_nAvailableSlotCount := 4 ; 활성화된 훈련 슬롯의 개수


; InputBox, strWaitSeconds, REPEAT LAB, 대기할 시간(분)을 입력하여 주십시요.


g_arrColorSetIsTrainingComplete1		:= [ [190, 481, 0xE2E1D9], [240, 481, 0xE2E1D9], [290, 481, 0xE2E1D9] ] ; ROOM간 간격은 270px
g_arrColorSetIsTrainingComplete2		:= [ [190, 481, 0xFDFDF4], [240, 481, 0xFDFDF4], [290, 481, 0xFDFDF4] ] ; ROOM간 간격은 270px


; ROOM의 완료 여부를 확인할 색 조합
g_arrColorSetIsTrainingComplete			:= [ [183, 441, 0xDEDED5], [293, 441, 0xF2F2E9], [232, 463, 0xE7E6E5] ]
g_nRoomGap								:= 270 ; ROOM간 간격은 270px


Loop, 3
{ ; 마지막 Room 훈련 완료를 검사할 수 있도록 색 조합 위치 수정
	g_arrColorSetIsTrainingComplete1[A_Index][1] := g_arrColorSetIsTrainingComplete1[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
	g_arrColorSetIsTrainingComplete2[A_Index][1] := g_arrColorSetIsTrainingComplete2[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
}
; MsgBox % Format(" Before g_arrColorSetIsTrainingComplete1 : 1 = {1:i} / 2 = {2:i} / 3 = {3:i}", g_arrColorSetIsTrainingComplete1[1][1], g_arrColorSetIsTrainingComplete1[2][1], g_arrColorSetIsTrainingComplete1[3][1] )


CloseTeamviewer() ; 팀뷰 창 닫기
CheckAppPlayer( g_nInstance, false ) ; 실행 인스턴스를 활성화
CreateLogWindow()

AppendLogWindow( "Start RepeatLab Script : Client Hwnd = " . g_hwndAppPlayerClient . " Client X = " . g_nClientX . " | Client Y = " . g_nClientY )


if ( IsSimilarColorSet( g_arrColorSetIsBackground ) )
{
	AppendLogWindow("    Launch LineRangers : " . A_TickCount)
	;LaunchLineRangers( g_hwndAppPlayer )
	ClickClientPoint( 151, 243, 500 )
	
	if ( WaitColorSet( g_arrColorSetIsLeonardLab, 30 ) = 0 )
	{
		MsgBox, Line Rangers를 다시 실행하고, Lab으로 이동하는데 문제 발생
		ExitApp, 0
	}
}


if ( IsSimilarColorSet( g_arrColorSetIsSettingsNotice ) )
{ ; 공지창 상태이면, 공지사항 창을 닫음
	AppendLogWindow( "    Close Settings > Notice : " . A_TickCount)
	ClickClientPoint( 777, 23, 500 )
	Sleep 700
}


if ( IsSimilarColorSet( g_arrColorSetIsSettings ) )
{ ; 설정창 상태이면, 설정창을 닫음
	DEBUG_STR(g_nInstance, "    Close Settings : " . A_TickCount)
	ClickClientPoint( 696, 42, 500 )
	Sleep 1700
}



LAB_INIT: ; 연구소 초기화

; Line Rangers Leonard's LAB 화면인지 확인할 때의 컬러 조합
;g_arrColorSetIsLeonardLab				:= [ [193, 45, 0x00A2FF], [229, 43, 0x00A2FF], [258, 42, 0xFFEE44] ]
g_arrColorSetIsLeonardLab			:= [ [34, 32, 0xFFEE44], [229, 43, 0x00A1FD], [259, 42, 0xFFEE44] ]

g_ptShortMoveButton		:= [771, 39]
g_ptSbLaboratory	:= [757, 337]
;if ( IsSameColorSet( g_arrColorSetIsLeonardLab ) == 0 )
if ( IsSimilarColorSet( g_arrColorSetIsLeonardLab ) == 0 )
{ ; Leonard's Lab 으로 이동

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
AppendLogWindow( "    Leonard's Lab 확인 : " . A_TickCount)









strIniSctionName := "Repeat LAB"
LoadGlobalVriable( strIniSctionName ) ; 연구소에 대한 설정 정보 로딩

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

	; 훈련장 센터에서 입장을 기다리는데 사용하는 색 조합
	g_arrColorSetWaitTrainingCenter	:= [ [798, 397, 0x850106], [167, 46, 0x00A2FF], [296, 37, 0xFFEE44] ]

	AppendLogWindow( "    Waiting Training Center...")
	if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
	{
		MsgBox, Lab -> Training Center 이동중 문제 발생
		ExitApp, 0
	}
}
else
{
	AppendLogWindow( "    AppPlayer%g_nInstance% Leonard's Lab 확인 실패")
	MsgBox, AppPlayer%g_nInstance% Leonard's Lab 확인 실패
	ExitApp, 0
}

isTrainingComplete := 0
nX := 147
nY := 241
g_nRoomGap								:= 169 ; ROOM간 간격
Loop, 4
{
	nRoomIndex := A_Index
	AppendLogWindow( "    Is traning complete? : #" . nRoomIndex)
	Sleep 1000
	
	arrColorSetCompleteTrain := [ [146, 230, 0x3A1B00], [146, 241, 0xEABC00], [179, 280, 0xF1F1F1] ]
	; 검사할 Room에 맞게 훈련 완료 여부 검사할 색 조합의 좌표 이동중
	{
		arrColorSetCompleteTrain[1][1] := arrColorSetCompleteTrain[1][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetCompleteTrain[2][1] := arrColorSetCompleteTrain[2][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetCompleteTrain[3][1] := arrColorSetCompleteTrain[3][1] + (nRoomIndex - 1) * g_nRoomGap
	}
	
	if ( IsSimilarColorSet(arrColorSetCompleteTrain, 50) ) ; nRoomIndex Room의 훈련이 완료되었는가?
	{
		isTrainingComplete := isTrainingComplete := 1
		AppendLogWindow( "    #" . nRoomIndex . " ROOM training completed")

		; 훈련이 완료된 룸에 들어가 보상을 수령한다.
		ClickClientPoint( nX, nY, 500 )

		; 보상 수령 확인 색조합
		g_arrColorSetWaitTrainingBonus	:= [ [484, 86, 0xFF0000], [463, 69, 0xFFFFFF], [486, 74, 0xFFE63D] ]
		AppendLogWindow( "    WaitTrainingBonus : #" . nRoomIndex)
		if ( WaitColorSet( g_arrColorSetWaitTrainingBonus, 30 ) = 0 )
		{
			MsgBox, Select ROOM 이동중 문제 발생
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
	; 검사할 Room에 맞게 훈련 필요 여부 검사할 색 조합의 좌표 이동중
	{
		arrColorSetNeedTrain[1][1] := arrColorSetNeedTrain[1][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetNeedTrain[2][1] := arrColorSetNeedTrain[2][1] + (nRoomIndex - 1) * g_nRoomGap
		arrColorSetNeedTrain[3][1] := arrColorSetNeedTrain[3][1] + (nRoomIndex - 1) * g_nRoomGap
	}

	if ( IsSimilarColorSet(arrColorSetNeedTrain, 30) ) ; nRoomIndex Room의 훈련이 필요한가?
	{
		; 룸에 들어가 보상을 레인져를 훈련시킨다.
		ClickClientPoint( nX, nY, 500 )

		; 훈련장 센터에서 입장한 ROOOM으로의 입장을 기다리는데 사용하는 색 조합
		g_arrColorSetWaitEnteringRoom	:= [ [305, 408, 0x19BBD6], [446, 427, 0xFFFFFF], [661, 419, 0xF0D942] ]

		AppendLogWindow( "      Wait for Entering TrainingRoom : #" . nRoomIndex)
		if ( WaitColorSet( g_arrColorSetWaitEnteringRoom, 30 ) = 0 )
		{
			MsgBox, Select ROOM 이동중 문제 발생
			ExitApp, 0
		}

		; 레인저 정렬 처리
		AppendLogWindow( "      Change ranger sort order #" . nRoomIndex)
		ClickClientPoint( 746, 274, 1000 ) ; Filter 선택
		if (nRoomIndex < 3) ; 1, 2 훈련장인 경우
			ClickClientPoint( 492, 129, 1000 ) ; 7성 레인져 선택
		if (nRoomIndex > 2) ; 3, 4 훈련장인 경우
			ClickClientPoint( 275, 172, 1000 ) ; 일반레인저 선택
		ClickClientPoint( 465, 420, 1000 ) ; OK 선택
		ClickClientPoint( 640, 277, 1000 ) ; Sort by 선택
		ClickClientPoint( 620, 319, 1000 ) ; 레벨 역순 선택
		;ClickClientPoint( 409, 354, 1000 ) ; 오래된순
		;ClickClientPoint( 510, 354, 1000 ) ; 등급순
		Sleep 2500
		
		; LAB에서 레인저 이동 좌표 목록
		g_arrPointSetDragBegin	:= [ [65, 340], [145, 340], [225, 340], [305, 340], [385, 340] ] ; 레인저 간격 80 px
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

		; 훈련 ROOM에서 TRAINING을 눌러, 상태 창이 나타나는 것을 기다리는데 사용하는 색 조합
		g_arrColorSetWaitTrainingStatus	:= [ [305, 444, 0x24AAC6], [755, 435, 0xFFFFFF], [493, 451, 0x057188] ]

		AppendLogWindow( "    Waiting training status...")
		if ( WaitColorSet( g_arrColorSetWaitTrainingStatus, 10 ) = 0 )
		{
			; 이동중 문제 발생
			MsgBox, training status 이동중 문제 발생
			ExitApp, 0
		}

		ClickClientPoint( 28, 38, 1000 ) ; 뒤로 클릭 -> 훈련 센터로 이동
		AppendLogWindow( "    Waiting Training Center...")
		if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
		{
			MsgBox, Select ROOM 이동중 문제 발생
			ExitApp, 0
		}
	}
*/
	nX := nX + g_nRoomGap ; 다음 Room 클릭 위치
}


ClickClientPoint( 28, 38, 1000 ) ; 뒤로 클릭 -> Lab 으로 이동
AppendLogWindow( "    Waiting Lab...")
if ( WaitColorSet( g_arrColorSetIsLeonardLab, 30 ) = 0 )
{
	MsgBox, Move Lab 이동중 문제 발생
	ExitApp, 0
}

Sleep 1000


if ( !isCraftMatirial )
	Goto, SKIP_CRAFT_MATIRIAL

AppendLogWindow( "    >>> Matirial Lab 입장중..." )
ClickClientPoint( 400, 250, 1000 )

arrColorSetIsMatirialLab := [ [50, 347, 0x40961B], [494, 384, 0x1D8C0E], [770, 100, 0x0C2803] ]
if ( WaitColorSet( arrColorSetIsMatirialLab, 30 ) = 0 )
{ ; 
	AppendLogWindow( "    >>> Matirial Lab 입장 실패. Repeat Lab 스크립트 초기화..." )
	Goto, LAB_INIT
}

Sleep 1500
; 완료 여부를 검사할 슬롯 위치
arrCheckCompletedSlot := [ [397, 140], [518, 140], [638, 140], [458, 251] ] ; 0xFFFFFE
; 빈 슬롯인지 검사할 위치
;arrCheckEmptySlot := [ [422, 169, 0x070A06], [543, 169, 0x070A06], [663, 169, 0x070A06], [482, 277, 0x070A06] ] ; 0x070A06
arrCheckProducingSlot := [ [424, 244, 0x000100], [535, 244, 0x000100], [655, 244, 0x000100], [474, 352, 0x000100] ] ; 0x070A06

nEmptySlotCount := 0
for nIndex, arrColorSetProducingSlot in arrCheckProducingSlot
{
	if ( IsSameColorSet( [ arrColorSetProducingSlot ] ) )
	{
		AppendLogWindow( "    재료 Slot #" . nIndex . "생산중..." )
		continue
	}

	if ( IsSameColor( arrCheckCompletedSlot[nIndex], 0xFFFFFE ) )
	{
		AppendLogWindow( "    재료 Slot #" . nIndex . " : 진화재료 생산 완료" )
		ClickClientPoint( arrColorSetProducingSlot[1], arrColorSetProducingSlot[2] - 50, 1000 )
		ClickClientPoint( 400, 405, 1000 ) ; "OK" 선택 ; 제작완료 재료 받기
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
{ ; 빈 슬롯이 있을 경우에만 진화재료를 생산하도록 함
	AppendLogWindow( "    진화 재료 및 정렬 선택" )
	nToChangeUltimateMatirialX := 147
	nToChangeRegularMatirialX := 263
	nToChangeMatirialY := 79

	if ( !isUltimate )
	{
		AppendLogWindow( "    일반 진화재료 선택")
		ClickClientPoint( nToChangeRegularMatirialX, nToChangeMatirialY, 1000 ) ; Regular 선택
	}

	if ( isAsendingGrade )
	{
		AppendLogWindow( "    진화재료 오름차순 정렬")
		ClickClientPoint( 300, 125, 1000 ) ; 등급 오름차순 정렬 선택
	}
	Sleep 1000

	AppendLogWindow( "	  INI에서 지정한 만큼 재료 위치로 이동" )
	nToScrollMatirialX := 200
	nToScrollMatirialTopY := 145
	nToScrollMatirialBottomY := 400

	;nMatirialScrollCount := 4
	Loop, %nMatirialScrollCount%
	{ ; INI에 지정한 진화재료로 이동
		DragMouse(nToScrollMatirialX, nToScrollMatirialBottomY, nToScrollMatirialX, nToScrollMatirialTopY, 300, 500)
		Sleep 1000
	}

	for nIndex, arrColorSetProducingSlot in arrCheckProducingSlot
	{ ; 진화재료 생산 처리
;		if ( IsSimilarColorSet( [ arrColorSetProducingSlot ], 10 ) )
		if ( !IsSameColorSet( [ arrColorSetProducingSlot ] )
			and !IsSameColor( arrCheckCompletedSlot[nIndex], 0xFFFFFE ) )
		{
			ClickClientPoint( 312, nMaririalClickY, 1000 ) ; 143, 193, 257, 320, 384
			ClickClientPoint( 420, 320, 1000 ) ; "CRAFTING" 선택
			ClickClientPoint( 420, 320, 1000 ) ; "OK" 선택 ; 제작
			if ( WaitColorSet( arrColorSetIsMatirialLab, 30 ) = 0 )
			{ ; 
			}
			AppendLogWindow( "    >> 진화재료 생산 시작 : Slot #" . nIndex )
		}
	}
}

ClickClientPoint( 28, 38, 1000 ) ; 뒤로 클릭 -> Lab 으로 이동
AppendLogWindow( "    Waiting Lab...")
if ( WaitColorSet( g_arrColorSetIsLeonardLab, 30 ) = 0 )
{
	MsgBox, Move Lab 이동중 문제 발생
	ExitApp, 0
}

Sleep 1000


SKIP_CRAFT_MATIRIAL:


; Lab 도움말로 이동하여 휴식
ClickClientPoint( 252, 39, 1000 ) ; ? 버튼 클릭

AppendLogWindow( "  Sleeping... " . nSleepTime)
Sleep %nSleepTime%
;Sleep 30000
InitializeClientPosition()


CloseTeamviewer() ; 팀뷰 창 닫기

ClickClientPoint( 764, 28 ) ; 닫기 버튼 클릭
Sleep 3000


; CheckAppPlayer( g_nInstance ) ; 실행 인스턴스를 활성화


Goto, LAB_INIT





#b::
GUI_EXIT:
GUI_Close:
GUI_Escape:
	ExitApp, 0
