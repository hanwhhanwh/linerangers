;===============================================================================
; @file Test.ahk
; @author hbesthee@naver.com
; @date 2016-09-23
;
; @description Lab 자동화 ; 훈련소를 계속 동작시킴
;
;===============================================================================

#include Global.ahk
#include Wait_inc.ahk
#include Utils_inc.ahk

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
g_arrColorSetIsGear				:= [ [36, 59, 0xFFFFEE], [110, 85, 0x00AAFF], [217, 80, 0xFFEE44] ]
; Line Rangers LAB 화면인지 확인할 때의 컬러 조합
g_arrColorSetIsLab				:= [ [36, 59, 0xFFFFEE], [370, 65, 0x00A2FF], [400, 75, 0xFFEE44] ]
; 훈련장 슬롯에 레인저를 모두 배치하고 훈련 완료 여부
g_arrColorSetIsCompleteSlot		:= [ [237, 268, 0x17110B], [238, 382, 0x3A1B00], [239, 381, 0x50320F] ]
; 훈련장 센터에서 입장을 기다리는데 사용하는 색 조합
g_arrColorSetWaitTrainingCenter	:= [ [921, 92, 0x2B1C0E], [675, 193, 0x894E15], [785, 588, 0x62381A] ]
; 훈련장 센터에서 입장한 ROOOM으로의 입장을 기다리는데 사용하는 색 조합
g_arrColorSetWaitEnteringRoom	:= [ [491, 663, 0x19BBD6], [715, 675, 0xFFFFFF], [1058, 680, 0xFFD43D] ]
; 훈련 ROOM에서 TRAINING을 눌러, 상태 창이 나타나는 것을 기다리는데 사용하는 색 조합
g_arrColorSetWaitTrainingStatus	:= [ [492, 650, 0x19BBD6], [1200, 710, 0xFFFFFF], [1058, 703, 0xFFD43D] ]

g_arrColorSetWaitTrainingBonus	:= [ [425, 215, 0x8F0000], [743, 120, 0xFFFFFF], [780, 128, 0xFFE63D] ]
g_arrColorSetWaitTrainingReword	:= [ [482, 192, 0xFFFFFF], [630, 229, 0xFFE63D], [770, 247, 0xFF9800] ]

; LAB에서 레인저 이동 좌표 목록
g_arrPointSetDragBegin	:= [ [110, 555], [238, 555], [366, 555], [494, 555], [622, 555] ] ; 레인저 간격 128px
g_arrPointSetDragEnd	:= [ [332, 316], [485, 273], [645, 316], [799, 273], [953, 316] ]

; 연구실 > 훈련장의 슬롯 클릭 위치 : 총 4개
g_arrPointSetSlot	:= [ [230, 370], [500, 370], [770, 370], [1040, 370] ]

g_nAvailableSlotCount := 3 ; 활성화된 훈련 슬롯의 개수


; InputBox, strWaitSeconds, REPEAT LAB, 대기할 시간(분)을 입력하여 주십시요.



g_arrColorSetIsTrainingComplete		:= [ [218, 286, 0xEEBB00], [237, 365, 0x3A1B00], [344, 379, 0xEDC007] ] ; ROOM간 간격은 270px

Loop, 3
{ ; 마지막 Room 훈련 완료를 검사할 수 있도록 색 조합 위치 수정
	g_arrColorSetIsTrainingComplete[A_Index][1] := g_arrColorSetIsTrainingComplete[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
}


LAB_LOOP: ; 강제 종료전까지 무한 반복


CloseTeamviewer() ; 팀뷰 창 닫기
LoadGlobalVriable( "LAB" ) ; 연구소에 대한 설정 정보 로딩

CheckAppPlayer( g_nInstance ) ; 실행 인스턴스를 활성화

/*

strTitle := "subWin1"
strClass := "sub"
g_hwndAppPlayer := WinExist( strTitle, strClass )
If ( g_hwndAppPlayer ) 
{
	DEBUG_STR(g_nInstance, "Find subWin")
	
	SendClickAbsolute( g_hwndAppPlayer, 638, 246 ) ; 라인 레인져스 아이콘 클릭
	
	MsgBox, "Find subWin"
}

ExitApp, 0

if ( IsSameColorSet( g_arrColorSetIsLab ) )
{
	DEBUG_STR(g_nInstance, " In Lab : " . A_TickCount)
	MsgBox, In Lab
}

; 1060, 630

Click 1300, 690 ; AppPlayer의 Home 버튼 클릭 = 라인 레인져스를 백그라운드로 숨기기(CPU 점유율 최소화)
*/

if ( IsSimilarColorSet( g_arrColorSetIsBackground ) )
{
	DEBUG_STR(g_nInstance, " Launch LineRangers : " . A_TickCount)
	LaunchLineRangers( g_hwndAppPlayer )
	
	if ( WaitColorSet( g_arrColorSetIsLab, 30 ) = 0 )
	{
		MsgBox, Line Rangers를 다시 실행하고, Lab으로 이동하는데 문제 발생
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
		MsgBox, Lab -> Training Center 이동중 문제 발생
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
			MsgBox, Select ROOM 이동중 문제 발생
			ExitApp, 0
		}
		Click %nX%, %nY%
		DEBUG_STR(g_nInstance, " WaitTrainingReword : " . A_TickCount)
		Sleep 1500
		Click %nX%, %nY%
		DEBUG_STR(g_nInstance, " WaitTrainingCenter : " . A_TickCount)
		if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
		{
			MsgBox, Select ROOM 이동중 문제 발생
			ExitApp, 0
		}

		DEBUG_STR(g_nInstance, "Select ROOM #" . A_Index)
		SendClickAbsolute( g_hwndAppPlayer, g_arrPointSetSlot[A_Index][1], g_arrPointSetSlot[A_Index][2] ) ; 훈련 셋 클릭

		if ( WaitColorSet( g_arrColorSetWaitEnteringRoom, 30 ) = 0 )
		{
			MsgBox, Select ROOM 이동중 문제 발생
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
			; 이동중 문제 발생
			MsgBox, training status 이동중 문제 발생
			ExitApp, 0
		}

		SendClickAbsolute( g_hwndAppPlayer, 48, 72, 1000 ) ; 뒤로 클릭 -> 훈련 센터로 이동
		DEBUG_STR(g_nInstance, " Waiting Training Center...")
		if ( WaitColorSet( g_arrColorSetWaitTrainingCenter, 30 ) = 0 )
		{
			MsgBox, Select ROOM 이동중 문제 발생
			ExitApp, 0
		}

		nX += 270
	} ; Loop %g_nAvailableSlotCount%
}

ExitApp, 0


SendClickAbsolute( g_hwndAppPlayer, 48, 72, 1000 ) ; 뒤로 클릭 -> Lab로 이동
DEBUG_STR(g_nInstance, " Waiting Lab...")
if ( WaitColorSet( g_arrColorSetIsLab, 30 ) = 0 )
{
	MsgBox, Move Lab 이동중 문제 발생
	ExitApp, 0
}

Sleep 500
Click 1300, 690 ; AppPlayer의 Home 버튼 클릭 = 라인 레인져스를 백그라운드로 숨기기(CPU 점유율 최소화)

nDelayTime := 60
Loop %nDelayTime%
{ ; 1분 동안 대기
	DEBUG_STR(g_nInstance, " Sleeping... : " . (nDelayTime - A_Index + 1) . "sec ramained" )
	Sleep 1000
}


; ExitApp, 0
Goto, LAB_LOOP


#b::
	MsgBox, REPEAT LAB에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
