;===============================================================================
; @file Global.ahk
; @author hbesthee@naver.com
; @date 2015-06-21
;
; @description 전역변수 등, 전체 스크립트에 공통되는 것을 처리하는 모듈
;
;===============================================================================

#NoEnv ; 변수명을 해석할 때, 환경 변수를 무시한다. 성능이 약간 향상됨. 환경변수와의 충돌 방지 ; 환경변수 참조시 EnvGet 함수 활용
#SingleInstance force

; 마우스 클릭 지연을 기본 10ms에서 5ms로 변경
SetMouseDelay, 3
; 윈도우 타이틀 비교시 정확하게 일치하는 것만 찾도록 함
SetTitleMatchMode, 3

CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

; 전역 공통 변수들
g_strManagerFullPath := "" ; AppPlayer Manager.exe 파일에 대한 전체 경로명
g_nInstance := 1 ; App Player 인스턴스 번호 ( 1 또는 2 )
g_hwndAppPlayer := 0 ; App Player 인스턴스의 HWND 핸들
g_hwndAppPlayerClient := 0, g_nClientX := 0, g_nClientY := 0 ; App Player 마우스 이벤트를 처리하는 윈도우의 HWND 핸들 및 좌표
g_hwndAppPlayerTool := 0 ; 툴 윈도우 HWND 핸들
g_hwndLogEditControl := 0 ; 로그 기록을 위한 Edit Control의 핸들
 
; 스크립트별로 값이 바뀌는 전역 변수들
g_strStageName := "" ; 진행할 단계 이름
g_isUseFriend := 0 ; 전투에서 친구의 도움을 요청할지 여부
g_nUpgradeMineral := 0  ; 미네랄 업그레이드를 얼마만큼 할 것인가? ( 0 = 안함, 5,6 = 초반 6회 클릭, 8 = MAX까지 업그레이드 )
g_isInGameZoom := 0  ; 전투화면에서 줌을 사용할 것인가?
g_isChangingTeam := 0  ; 전투에서 A, B 팀을 바꾸면서 진행할 것인가?
g_nPeriodOfChangingTeam := 0  ; 전투에서 팀을 바꾸는 주기 (ms)
g_isUseUnbeatable := 0  ; 전투에서 미네랄을 업그레이드 한 이후에 무적을 사용할 것인가?


; RETRY 창에 대한 색조합
g_arrColorSetIsRetry	:= [ [350, 306, 0x00DD44], [428, 312, 0xFFFFFF], [398, 324, 0xFFFFFF], [533, 130, 0xFFFFEE] ]
; RETRY 버튼 위치
g_ptRetryButton			:= [400, 320]

; @brief 입력한 내용을 로그 파일에 기록한다.
;		로그 파일은 .\Logs\lr-yyyyMMdd.log 파일에 시각 정보를 포함하여 기록된다.
; @param strMsg 기록할 로그의 내용
AppendLog(strMsg)
{
	FormatTime, strLogFileName, , yyyyMMdd
	strLogFileName := ".\Logs\lr-" . strLogFileName . ".log"

	FormatTime, strTime, , HH:mm:ss
	strTime .= " " . strMsg
	FileAppend, %strTime%`r`n, %strLogFileName%
}


; @brief 지정한 인스턴스에 해당하는 AppPlayer를 실행한다.
ExecuteLineRangers()
{
	PixelGetColor, clrOutputColor1, 1140, 115, RGB ; 0x35CB00
	PixelGetColor, clrOutputColor2, 700, 600, RGB ; 0x000000
	PixelGetColor, clrOutputColor3, 1547, 135, RGB ; 0xD9D9D9
	PixelGetColor, clrOutputColor4, 417, 302, RGB ; 0x59C3EF
	
	If ( clrOutputColor1 = 0x35CB00 ) and ( clrOutputColor2 = 0x000000 ) 
			and ( clrOutputColor3 = 0xD9D9D9 ) and ( clrOutputColor4 = 0x59C3EF )
	{
		Click 630, 320
		Sleep 1000
	}
}


; @brief 지정한 인스턴스에 해당하는 AppPlayer를 실행한다.
; @return 실행이 성공하면 true(1), 그렇지 않으면 false(0)을 반환한다.
ExecuteAppPlayer(nInstance)
{
	Global g_strManagerFullPath
	
	strTitle = AppPlayer Manager
	hwndAppPlayerManager := WinExist( strTitle )
	If ( hwndAppPlayerManager == 0 ) 
	{
		Run, %g_strManagerFullPath%
		Sleep 1000
		hwndAppPlayerManager := WinExist( strTitle )
	}

	If ( hwndAppPlayerManager != 0 ) 
	{
		WinActivate, ahk_id %hwndAppPlayerManager%
		WinMove, 0, 0
		Sleep 500
	}
	else
	{
		AppendLog("AppPlayerManager를 실행하지 못하였습니다.")
		MsgBox, 0x30, AppPlayer Manager 실행 실패,
			(LTrim AppPlayerManager를 정상적으로 실행하지 못하였습니다.
				먼저, App Player가 정상적으로 설치되어 있는지 확인하여 주시기 바랍니다.
				설치되어 있다면, LineRagners.ini 파일에서 AppPlayerManager의 경로를 올바로 설정하여 주시기 바랍니다.
			)
		return 0
	}
	
	If ( nInstance = 1 )
	{
		Click 125, 230 ; 첫 번째 인스턴스 선택
		Sleep 500
	}
	else
	{	
		Click 125, 190 ; 두 번째 인스턴스 선택
		Sleep 500
	}
	
	Click 150, 80 ; Start 버튼 클릭하여 해당 인스턴스 실행
	Sleep 1000
	
	return 1
}


; @brief 라인레인져에 대한 최초 설정을 초기화한다. AppPlayer Manager 경로 확인
; @return AppPlayerManager의 경로가 올바로 확인되면 true(1), 그렇지 않으면 false(0)
InitializeLineRangers()
{
	Global g_strManagerFullPath
	Global g_nInstance

	IniRead, g_strManagerFullPath, LineRangers.ini, GLOBAL_VAR, AppPlayerManagerFullPath, D:\Util\Nox\bin\MultiPlayerManager.exe
	If g_strManagerFullPath = ERROR
		g_strManagerFullPath := "D:\Util\Nox\bin\MultiPlayerManager.exe" ; AppPlayer Manager.exe 파일에 대한 전체 경로명
	If !FileExist( g_strManagerFullPath )
	{
		AppendLog("AppPlayer Manager 파일의 경로를 찾지 못함 : " . g_strManagerFullPath)
		MsgBox, 0x30, AppPlayer Manager 경로 오류,
			(LTrim AppPlayerManager를 찾을 수 없습니다.
				먼저, AppPlayer를 설치하여 주시기 바랍니다.
				설치되어 있다면, LineRagners.ini 파일에서 AppPlayerManager의 경로를 올바로 설정하여 주시기 바랍니다.
			)
		return 0
	}

	IniRead, g_nInstance, LineRangers.ini, GLOBAL_VAR, Instance, 1
	If g_nInstance = ERROR
		g_nInstance := 1
	If ( !( (g_nInstance = 1) or (g_nInstance = 2) ) )
	{
		MsgBox, 0x30, 인스턴스 설정 오류,
			(LTrim 인스턴스 번호를 잘못 지정하였습니다.
				LineRagners.ini 파일에서 Instance의 번호를 올바로 설정(1 또는 2)하여 주시기 바랍니다.
			)
		return 0
	}
	return 1
}


; @brief 스크립트별 전역 변수를 읽어온다.
LoadGlobalVriable( strSectionName )
{
	Global g_strStageName
	Global g_isUseFriend, g_nUpgradeMineral, g_isInGameZoom
	Global g_isChangingTeam, g_nPeriodOfChangingTeam, g_isUseUnbeatable

	AppendLog("LineRangers - " . strSectionName . " started...")

	g_strStageName := strSectionName

	IniRead, g_isUseFriend, LineRangers.ini, %strSectionName%, UseFriend, 0
	IniRead, g_nUpgradeMineral, LineRangers.ini, %strSectionName%, UpgradeMineral, 0
	IniRead, g_isInGameZoom, LineRangers.ini, %strSectionName%, InGameZoom, 1
	IniRead, g_isChangingTeam, LineRangers.ini, %strSectionName%, IsChangingTeam, 1
	IniRead, g_nPeriodOfChangingTeam, LineRangers.ini, %strSectionName%, PeriodOfChangingTeam, 3000
	IniRead, g_isUseUnbeatable, LineRangers.ini, %strSectionName%, UseUnbeatable, 1
}