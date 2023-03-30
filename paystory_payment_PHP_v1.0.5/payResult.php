<?php
header("Content-Type:text/html; charset=utf-8;");
/*
****************************************************************************************
* <인증 결과 파라미터>
****************************************************************************************
*/

$resultCode 	= $_POST["resultCode"];         // 인증결과 : 0000(성공)
$resultMsg 		= $_POST["resultMsg"]; 	        // 인증결과 메시지
$tid 			= $_POST["tid"]; 		        // 거래 ID
$payMethod 		= $_POST["payMethod"]; 	        // 결제수단
$ediDate 		= $_POST["ediDate"]; 	        // 결제 일시
$mid 			= $_POST["mid"]; 		        // 상점 아이디
$goodsAmt 		= $_POST["goodsAmt"]; 	        // 결제 금액
$reqReserved 	= $_POST["mbsReserved"];        // 상점 예약필드
$signData		= $_POST["signData"];	        // 암호화 데이터
$merchantKey	= "";                           // 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)

$hashStr 		= bin2hex(hash('sha256', $mid.$ediDate.$goodsAmt.$merchantKey, true));// Hash 값

/*
****************************************************************************************
* <승인 결과 파라미터 정의>
* 샘플페이지에서는 승인 결과 파라미터 중 일부만 예시되어 있으며, 
* 추가적으로 사용하실 파라미터는 연동메뉴얼을 참고하세요.
****************************************************************************************
*/

/*
****************************************************************************************
* <인증 결과 성공시 승인 진행>
****************************************************************************************
*/

if($resultCode == "0000") {
	
	/*
	****************************************************************************************
	* <승인 요청 >
	****************************************************************************************
	*/
	$requestData = "tid=".$tid."&";
	$requestData .= "mid=".$mid."&";
	$requestData .= "goodsAmt=".$goodsAmt."&";
	$requestData .= "ediDate=".$ediDate."&";
	$requestData .= "charSet="."utf-8"."&";
	$requestData .= "hashStr=".$hashStr."&";
	$requestData .= "signData=".$signData;
	
    $ch = curl_init();                                                          // curl 초기화
	curl_setopt($ch, CURLOPT_URL, "https://pg.minglepay.co.kr/payment.do");     // url 지정하기
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);              				// 요청결과를 문자열로 반환
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);               				// connection timeout : 30초
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);                 			// 원격 서버의 인증서가 유효한지 검사 여부
	curl_setopt($ch, CURLOPT_POST, true);                               		// POST 전송 여부
	curl_setopt($ch, CURLOPT_POSTFIELDS, $requestData);      					// POST DATA
    $response = curl_exec($ch);
	$receiveData = json_decode($response, true);
	curl_close ($ch);

	/*
	****************************************************************************************
	* <결제 결과 파라미터>
	****************************************************************************************
	*/
	$sResultCode	= $receiveData["resultCd"]; 	// 결과코드
	$sResultMsg 	= $receiveData["resultMsg"]; 	// 결과메시지
	$sPayMethod 	= $receiveData["payMethod"]; 	// 결제수단
	$sGoodsAmt		= $receiveData["goodsAmt"]; 			// 결제금액
	$sTid 			= $receiveData["tid"]; 			// 거래ID
	$sName			= $receiveData["ordNm"];		// 구매자 명
	$sGoodsNm		= $receiveData["goodsNm"];	// 상품명
	$sCpNm		    = $receiveData["cpNm"];			// 제휴사 명
	$sHashString	= $receiveData["hashString"];	// 해쉬값
	$sQuota			= $receiveData["quota"];		// 할부개월
	
} else {
	// 실패처리
	echo "승인요청이 실패하였습니다";
}

?>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
<title>PAY RESULT</title>
<style>
.pop_wrap {background:rgba(0, 0, 0, 0.4);}
.tbl_th{box-sizing:border-box; line-height:40px; padding:0px 10px 0px 10px; text-align:left; width:160px; background:#e9eaeb; border-top:1px solid #2a323c; border-bottom:1px solid #d4d6d8; font-size:15px; font-weight:normal; color:#333; font-family:'Malgun Gothic','맑은 고딕',sans-serif;}
.tbl_td{box-sizing:border-box; line-height:40px; padding:0px 10px 0px 10px; text-align:left; border-top:1px solid #2a323c; border-bottom:1px solid #d4d6d8; font-size:15px; font-weight:bold; color:#333; font-family:'Malgun Gothic','맑은 고딕',sans-serif;}
</style>
</head>
<body>
<div style="width: 100%; text-align: center;">
    <div id="sampleInput" style="display: inline-block; padding:0 10px; margin:0 auto;">
        <table style="border-spacing:0;">
            <tbody>
                <tr>
                    <td colspan="3"><p style="margin:10px 0 10px; text-align:center; font-size:34px; color:#2a323c; font-family:'Malgun Gothic','맑은 고딕',sans-serif;">결제 결과</p></td>
                </tr>                		
                <tr>
                    <td colspan="3">
                        <table style="border-collapse:collapse; width:100%">
                            <tbody>
                                <tr>
                                    <th scope="row" class="tbl_th">결과 내용</th>
                                </tr>
                                <tr>
                                    <td class="tbl_td">[<?=$sResultCode?>]<?=$sResultMsg?></td>
                                </tr>                              
                                <tr>
                                    <th scope="row" class="tbl_th">결제수단</th>
                                </tr>
                                <tr>
                                    <td class="tbl_td"><?=$sPayMethod?></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">금액</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><?=$sGoodsAmt?></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">거래아이디</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><?=$sTid?></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">구매자명</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><?=$sName?>&nbsp;</td>
                                </tr>
                                <tr>
									<th scope="row" class="tbl_th">상품명</th>
							      </tr>
                                <tr>
									<td class="tbl_td"><?=$sGoodsNm?></td>
								</tr>
								<tr>
									<th scope="row" class="tbl_th">제휴사 명</th>
								 </tr>
                                <tr>
									<td class="tbl_td"><?=$sCpNm?></td>
								</tr>
								<tr>
									<th scope="row" class="tbl_th">할부개월</th>
									 </tr>
                                <tr>
									<td class="tbl_td"><?=$sQuota?></td>
								</tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>