<!-- #include file = "cryptSHA256.asp" -->
<% response.Charset = "utf-8"%>
<%
'/*
' * [상점 결제결과처리(DB) 페이지]
' *
' * 1) 위변조 방지를 위한 결과값 검증은 반드시 적용하셔야 합니다.
' * 2) 결제 성공결과 DB 처리페이지는 결제성공시 즉시 호출되며, 해당페이지 호출 실패시 가맹점관리자에서 설정한 전송횟수 및 전송주기에 따라 재전송됩니다.
' * 3) 결제결과 처리 파라미터는 상점 환경에 맞게 필요 대상만 선별 처리하시면 됩니다.   
' */

merchantKey 	= "" 							' 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
sResultCd 		= trim(request("resultCd")) 	' [ 예) 신용카드 경우  3001 : 결제성공]
sResultMsg 		= trim(request("resultMsg")) 	' 응답 메시지
sPayMethod 		= trim(request("payMethod")) 	' 결제 방법(CARD,BANK,VACNT,PHONE,CULTUREGIFT)
sTid	 		= trim(request("tid")) 			' 거래번호
sMid	 		= trim(request("mid")) 			' 상점 ID
sAppDtm			= trim(request("appDtm")) 		' 결제일시 (예 20210323163604)
sCcDtm			= trim(request("ccDtm")) 		' 취소일시 (예 20210323195004)
sAppNo			= trim(request("appNo")) 		' 승인번호
sOrdNo			= trim(request("ordNo")) 		' 주문번호
sGoodsNm 		= trim(request("goodsNm")) 	' 결제 상품명
sGoodsAmt		= trim(request("goodsAmt")) 			' 결제금액
sOrdNm 			= trim(request("ordNm")) 		' 구매자 
sCpNm 			= trim(request("cpNm")) 		' 제휴사명
sMbsUsrId	 	= trim(request("mbsUsrId")) 	' 가맹점 고객 ID
sCancelYN 		= trim(request("cancelYN")) 	' 결제 취소 여부 (승인:N, 취소:Y)
sAppCardCd 		= trim(request("appCardCd")) 	' 카드 발급사코드
sAcqCardCd 		= trim(request("acqCardCd")) 	' 카드 매입사코드
sQuota 			= trim(request("quota")) 		' 카드 할부기간.
sUsePointAmt	= trim(request("usePointAmt")) 	' 사용 카드 포인트
sCardType 		= trim(request("cardType")) 	' 카드타입 (0:신용, 1:체크)
sAuthType 		= trim(request("authType")) 	' 인증타입 (01:Keyin, 02:ISP, 03:MPI)
sCashCrctFlg 	= trim(request("cashCrctFlg")) 	' 현금영수증 발급여부 (0:미발급, 1:발급)
sVacntNo 		= trim(request("vacntNo")) 		' 가상계좌번호
sLmtDay 		= trim(request("lmtDay")) 		' 입금기한
sSocHpNo 		= trim(request("socHpNo")) 		' 결제 휴대폰 번호
sEdiDate	 	= trim(request("ediDate")) 		' 전문생성일시
sHashStr		= trim(request("mbsReserved")) 	' 상점정의 필드
sMbsReserved 	= trim(request("hashStr")) 		' 해쉬값

'/*
'*******************************************************
'* <해쉬암호화> (수정하지 마세요)
'* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
'*******************************************************
'*/

hashStrLocal = enc(sMid & sEdiDate & sGoodsAmt & merchantKey)  'local에서 Hash 생성

function enc(str)
	Set SHA = New CryptSHA256
	enc = SHA.SHA256(str)
end function



'*****************************************************************
'* <결제성공 DB 처리 >
'* 신용카드 결제 성공 (ResultCd : 3001, PayMethod : CARD)
'* 계좌이체 결제 성공 (ResultCd : 4000, PayMethod : BANK)
'* 가상계좌 입금 통보 (ResultCd : 4110, PayMethod : VACNT)
'* 상품권  결제 성공 (ResultCd : 0000, PayMethod : CULTUREGIFT)
'* 휴대폰 결제 성공 (ResultCd : A000, PayMethod : PHONE)

'* <취소성공건 DB 처리 >
'* 신용카드 취소성공	(ResultCd : 2001, PayMethod : CARD)
'* 계좌이체 취소성공 (ResultCd : 2001, PayMethod : BANK)
'* 가상계좌 결제 취소 성공 (ResultCd : 2211, PayMethod : VACNT)
'* 문화상품권 취소성공 (ResultCd : 0000, PayMethod : CULTUREGIFT)
'* 휴대폰 취소성공 (esultCd : A000, PayMethod : PHONE) 
'*****************************************************************

If hashStrLocal= sHashStr then
		' 해시값 검증이 성공이면 
	If (sResultCd="3001" AND sPayMethod="CARD" AND sCancelYN="N") then
			' 결제성공 결과 DB 연동
	Elseif (sResultCd="2001" AND sPayMethod="CARD" AND sCancelYN="Y") then
			' 취소성공 결과 DB 연동
    End if
Else
    ' 해쉬값이 검증이 실패이면
	Response.Write "비정상호출이거나 해쉬값이 위변조되었습니다."
End if
%>
