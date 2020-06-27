;===============================================================================
; @file Test.ahk
; @author hbesthee@naver.com
; @date 2016-10-01
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
g_arrColorSetIsGear				:= [ [36, 59, 0xFFFFEE], [110, 85, 0x00AAFF], [217, 80, 0xFFEE44] ]
; Line Rangers HOME 화면인지 확인할 때의 컬러 조합
g_arrColorSetIsHome				:= [ [76, 297, 0x0], [160, 55, 0x351609], [1130, 715, 0xFFFFFF] ]
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

g_nAvailableSlotCount := 4 ; 활성화된 훈련 슬롯의 개수


; InputBox, strWaitSeconds, REPEAT LAB, 대기할 시간(분)을 입력하여 주십시요.



g_arrColorSetIsTrainingComplete		:= [ [218, 286, 0xEEBB00], [237, 365, 0x3A1B00], [344, 379, 0xEDC007] ] ; ROOM간 간격은 270px

Loop, 3
{ ; 마지막 Room 훈련 완료를 검사할 수 있도록 색 조합 위치 수정
	g_arrColorSetIsTrainingComplete[A_Index][1] := g_arrColorSetIsTrainingComplete[A_Index][1] + 270 * (g_nAvailableSlotCount - 1)
}
; MsgBox % Format(" Before g_arrColorSetIsTrainingComplete : 1 = {1:i} / 2 = {2:i} / 3 = {3:i}", g_arrColorSetIsTrainingComplete[1][1], g_arrColorSetIsTrainingComplete[2][1], g_arrColorSetIsTrainingComplete[3][1] )


CloseTeamviewer() ; 팀뷰 창 닫기
CheckAppPlayer( g_nInstance ) ; 실행 인스턴스를 활성화

if ( IsSameColorSet( g_arrColorSetIsLab ) == 0 )
{ ; Leonard's Lab 으로 이동
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


LAB_LOOP: ; 강제 종료전까지 무한 반복


LoadGlobalVriable( "LAB" ) ; 연구소에 대한 설정 정보 로딩


DEBUG_STR(g_nInstance, " Ranger ascending order. " . A_TickCount)
while ( IsSimilarColorSet( g_arrColorSetIsLevelAscending, 15 ) == 0 )
{ ; 레인져를 레벨 오름차순으로 정렬함
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

CloseTeamviewer() ; 팀뷰 창 닫기
CheckAppPlayer( g_nInstance ) ; 실행 인스턴스를 활성화

; ExitApp, 0
Goto, LAB_LOOP


#b::
	MsgBox, REPEAT LAB에 대한 스크립트를 강제로 종료합니다.
	ExitApp, 0  ; Assign a hotkey to terminate this script.
return
