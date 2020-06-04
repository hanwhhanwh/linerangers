;===============================================================================
; @file ColorSet_inc.ahk
; @author hbesthee@naver.com
; @date 2016-10-01
;
; @description 특정 버튼, 상태, 메뉴 확인 및 대기를 위한 색 조합
;
;===============================================================================



;;; 현재 위치 확인용 색조합

; HOME 화면인지 확인
g_arrColorSetIsHome					:= [ [396, 646, 0xFFFFFF], [670, 442, 0x74AC20], [1131, 691, 0xFFFFFF] ]
; Gacha 화면인지 확인
g_arrColorSetIsGacha				:= [ [87, 42, 0x69412F], [487, 169, 0xFFE63D], [823, 161, 0x7A4219] ]
; ARENA 화면인지 확인
g_arrColorSetIsArena				:= [ [156, 443, 0xFFEE44], [680, 392, 0xFFD43D], [180, 45, 0x00AAFF] ]

g_arrColorSetIsLeonardLab			:= [ [34, 32, 0xFFEE44], [215, 46, 0x00A2FF], [259, 42, 0xFFEE44] ]


;;; 공통 : RETRY / OK 등 여러 화면에서 공통적을 사용되는 색조합

; 친구 선택화면 여부 확인용 색조합
g_arrColorSetIsFirends				:= [ [472, 645, 0x07DA46], [700, 662, 0xFFFFFF], [785, 713, 0x009B20] ]



;;; 공통 : 각종 전투에서 WIN / LOSS를 확인하는데 사용되는 색조합

; 전투 승리 WIN 확인용 색조합
g_arrColorSetIsWin				:= [ [633, 274, 0x69412F], [700, 375, 0xE97602], [812, 254, 0xFFFFFF] ]
; 전투 패배 LOSS 확인용 색조합
g_arrColorSetIsLoss				:= [ [87, 42, 0x69412F], [487, 169, 0xFFE63D], [823, 161, 0x7A4219] ]




;;; HOME 화면에서의 색조합

; Settings 창이 표시되었는지 여부 확인용
g_arrColorSetIsSettings				:= [ [1035, 113, 0x7F4121], [1084, 131, 0xFFEE44], [1068, 105, FFFFEE] ]
; Settings > NOTICE 창이 표시되었는지 여부 확인용
g_arrColorSetIsSettingsNotice		:= [ [100, 100, 0x8F4F29], [1210, 124, 0xA36335], [1270, 150, 0xFFFFFF] ]

g_ptCloseButtonSettings				:= [ 1083, 116 ] ; 설정창 닫기 버튼
g_ptCloseButtonSettingsNotice		:= [ 1245, 95 ] ; 공지사항 창 닫기 버튼



;;; Leonard's Lab > Crystal Lab 에서 사용할 색조합
g_arrColorSetIsCrystalLab			:= [ [940, 575, 0xAE0411], [764, 572, 0x810000], [1016, 142, 0x012A31] ] ; Crystal Lab인지 여부
g_arrColorSetIsLevelAscending		:= [ [413, 211, 0xA39362], [415, 205, 0xFFFFFD], [417, 212, 0x423316] ] ; 레인져 정렬 버튼(오름차순 확인용)
g_arrColorSetIsExtractCrystalYesNo	:= [ [463, 502, 0x33CCDD], [664, 502, 0x00DD44], [800, 549, 0x009922] ] ; 크리스탈 추출 시작 여부 묻는 창
g_arrColorSetIsExtractCrystalComplete	:= [ [540, 635, 0x07DA46], [650, 656, 0xFFFFFF], [720, 695, 0x009B20] ] ; 크리스탈 추출 완료 여부




;;; HOME에서 각 버튼 좌표
g_ptHomeGacha						:= [ 1030, 205 ] ; HOME에서 Gache Button 좌표
g_ptHomeSettings					:= [ 1130, 700 ] ; HOME에서 Settings Button 좌표
g_ptHomeSettingsClose				:= [ 1083, 116 ] ; HOME에서 Settings창 Close Button 좌표
g_ptHomeSettingsNotice				:= [ 440, 310 ] ; HOME > Settings창 NOTICE Button 좌표
g_ptHomeSettingsMovie				:= [ 440, 435 ] ; HOME > Settings창 MOVIE Button 좌표
g_ptHomeSettingsMyInfo				:= [ 440, 545 ] ; HOME > Settings창 MY INFO Button 좌표
g_ptHomeSettingsNoticeClose			:= [ 1230, 95 ] ; HOME > Settings > NOTICE창 Close Button 좌표



; Leonard's Lab 버튼 좌표
g_ptLabCrystalLab					:= [ 640, 240 ] ; Leonard's Lab > Crystal Lab
g_ptLabMaterialLab					:= [ 640, 425 ] ; Leonard's Lab > Material Lab
g_ptLabTrainingCenter				:= [ 640, 560 ] ; Leonard's Lab > Training Center
g_ptLabSecretLab					:= [ 640, 685 ] ; Leonard's Lab > Secret Lab

g_ptLabCrystalLabLevelOrder			:= [ 416, 212 ] ; Leonard's Lab > Crystal Lab > Level Order
g_ptLabCrystalLabRangerChecks		:= [ [500, 290], [500, 390], [500, 490], [500, 590] ] ; Leonard's Lab > Crystal Lab > Ranger Checker Buttons
g_ptLabCrystalLabExtractButton		:= [ 877, 563 ] ; Leonard's Lab > Crystal Lab > EXTRACT Button
g_ptLabCrystalLabExtractOkButton	:= [ 740, 520 ] ; Leonard's Lab > Crystal Lab > EXTRACT OK/Cancel > OK
g_ptLabCrystalLabExtractedOkButton	:= [ 640, 657 ] ; Leonard's Lab > Crystal Lab > Crystal Extracted OK Button



;;; 단축 버튼의 각 좌표
g_ptShortButton						:= [1230, 78]
g_ptSbHome							:= [1205, 170]
g_ptSbMyTeam						:= [1205, 300]
g_ptSbGacha							:= [1205, 430]
g_ptSbMission						:= [1205, 550]
g_ptSbGuild							:= [1080, 170]
g_ptSbGear							:= [1080, 300]
g_ptSbUpgrade						:= [1080, 430]
g_ptSbLaboratory					:= [1080, 555]
g_ptSbArena							:= [955, 170]
g_ptSbPvP							:= [955, 300]
g_ptSbGuildRaid						:= [955, 430]
g_ptSbMainStage						:= [830, 170]
g_ptSbSpecialStage					:= [830, 300]
g_ptSbEndless						:= [830, 430]



