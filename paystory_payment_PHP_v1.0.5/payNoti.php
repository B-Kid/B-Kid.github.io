<?php
header("Content-Type:text/html; charset=utf-8;");
/*
 * [상점 결제결과처리(DB) 페이지]
 *
 * 1) 위변조 방지를 위한 결과값 검증은 반드시 적용하셔야 합니다.
 *
 */

$sResultCd 		= $_POST["resultCd"];		// 결과코드
$sResultMsg 	= $_POST["resultMsg"];		// 응답 메시지
$sPayMethod 	= $_POST["payMethod"];		// 결제 방법(CARD,BANK,VACNT,PHONE)
$sTid	 		= $_POST["tid"];			// 거래번호
$sMid	 		= $_POST["mid"];			// 상점 ID
$sAppDtm		= $_POST["appDtm"];			// 결제일시 (예 20210323163604)
$sCcDtm			= $_POST["ccDtm"];			// 취소일시 (예 20210323195004)
$sAppNo			= $_POST["appNo"];			// 승인번호
$sOrdNo			= $_POST["ordNo"];			// 주문번호
$sGoodsNm 	= $_POST["goodsNm"];		// 결제 상품명
$sGoodsAmt		= $_POST["goodsAmt"];			// 결제금액
$sOrdNm 		= $_POST["ordNm"];			// 구매자 
$sCpNm 			= $_POST["cpNm"];			// 제휴사명
$sCancelYN 		= $_POST["cancelYN"];		// 결제 취소 여부 (승인:N, 취소:Y)
$sAppCardCd 	= $_POST["appCardCd"];		// 카드 발급사코드
$sMbsUsrId	 	= $_POST["mbsUsrId"];		// 가맹점 고객 ID
$sAcqCardCd 	= $_POST["acqCardCd"];		// 카드 매입사코드
$sQuota 		= $_POST["quota"];			// 카드 할부기간.
$sUsePointAmt 	= $_POST["usePointAmt"];	// 사용 카드 포인트
$sCardType 		= $_POST["cardType"];		// 카드타입 (0:신용, 1:체크)
$sAuthType 		= $_POST["authType"];		// 인증타입 (01:Keyin, 02:ISP, 03:MPI)
$sCashCrctFlg 	= $_POST["cashCrctFlg"];	// 현금영수증 발급여부 0:발급안함, 1:발급
$sVacntNo 		= $_POST["vacntNo"];		// 가상계좌번호
$sLmtDay 		= $_POST["lmtDay"];			// 입금기한
$sSocHpNo 		= $_POST["socHpNo"];		// 결제 휴대폰 번호 (휴대폰 결제시에만 리턴)
$sEdiDate	 	= $_POST["ediDate"];		// 전문생성일시
$sHashStr		= $_POST["hashStr"];		// 해쉬값
$sMbsReserved 	= $_POST["mbsReserved"];	// 상점정의 필드
$merchantKey	= "";	                	// 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)

/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/

$hashStrLocal 		= bin2hex(hash('sha256', $sMid.$sEdiDate.$sAmt.$merchantKey, true));// Hash 값



/*
*******************************************************
* <결제 성공건 체크 및 DB연동 부분>
* 신용카드 결제 성공 (ResultCd = "3001", PayMethod = "CARD")
* 계좌이체 결제 성공 (ResultCd = "4000", PayMethod = "BANK")
* 가상계좌 입금 통보 (ResultCd = "4110", PayMethod = "VACNT")
* 상품권 결제 성공 (ResultCd ="0000", PayMethod = "CULTUREGIFT")
* 휴대폰 결제 성공 (ResultCd = "A000", PayMethod = "PHONE")

* <취소성공건 DB 처리 >
* 신용카드 취소성공	(ResultCd : 2001, PayMethod : CARD)
* 계좌이체 취소성공 (ResultCd : 2001, PayMethod : BANK)
* 가상계좌 결제 취소 성공 (ResultCd : 2211, PayMethod : VACNT)
* 문화상품권 취소성공 (ResultCd : 0000, PayMethod : CULTUREGIFT)
* 휴대폰 취소성공 (esultCd : A000, PayMethod : PHONE) 
*******************************************************
*/

if ($sHashStr == $hashStrLocal){
	if (($sResultCd == "3001") && ($sPayMethod == "CARD") && ($sCancelYN == "N")){
	
		// 결제성공 결과 처리 

	} else if (($sResultCd == "2001") && ($sPayMethod == "CARD") && ($sCancelYN == "Y")){
		// 취소 성공 결과 처리 
	}		
} else {
	// 결제결과 위변조 오류 처리
}
?>