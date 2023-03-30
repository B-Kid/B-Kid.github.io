<?php
header("Content-Type:text/html; charset=utf-8;");

/*
****************************************************************************************
* <취소요청 파라미터>
* 취소시 전달하는 파라미터입니다.
* 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
* 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
****************************************************************************************
*/

$mid 			= $_POST["mid"];            // 상점 아이디
$tid 			= $_POST["tid"];            // 거래 ID
$canAmt 		= $_POST["canAmt"];         // 취소 금액
$partCanFlg 	= $_POST["partCanFlg"];     // 부분취소여부

$canMsg			= "고객요청";                // 취소 사유
$merchantKey	= "";                       // 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
//$refundNm       = $_POST["refundNm"];       // 환불 계좌주 명
//$refundAccnt    = $_POST["refundAccnt"];    // 환불 계좌 번호
//$refundBankCd   = $_POST["refundBankCd"];   // 환불 계좌 은행 코드
//$notiUrl 		  = $_POST["notiUrl"];        // 취소 결과를 따로 통보 받고자 할때 사용

/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/
$ediDate 		= date("YmdHis");				// 전문 생성일시
$hashStr 		= bin2hex(hash('sha256', $mid.$ediDate.$canAmt.$merchantKey, true));// Hash 값

/*
****************************************************************************************
* <취소 요청>
* 취소에 필요한 데이터 생성 후 server to server 통신을 통해 취소 처리 합니다.
* 취소 사유(CancelMsg) 와 같이 한글 텍스트가 필요한 파라미터는 encoding 처리가 필요합니다.
****************************************************************************************
*/
$requestData = "tid=".$tid."&";
$requestData .= "mid=".$mid."&";
$requestData .= "canAmt=".$canAmt."&";
$requestData .= "canMsg=".$canMsg."&";
$requestData .= "partCanFlg=".$partCanFlg."&";
$requestData .= "ediDate=".$ediDate."&";
$requestData .= "charSet="."utf-8"."&";
//$requestData .= "refundNm=".$refundNm."&";
//$requestData .= "refundAccnt=".$refundAccnt."&";
//$requestData .= "refundBankCd=".$refundBankCd."&";
//$requestData .= "notiUrl=".$notiUrl."&";
$requestData .= "hashStr=".$hashStr;
	
$ch = curl_init();                                                          // curl 초기화

curl_setopt($ch, CURLOPT_URL, "https://pg.minglepay.co.kr/payment.cancel"); // url 지정하기
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
* <취소 결과 파라미터 정의>
* 샘플페이지에서는 취소 결과 파라미터 중 일부만 예시되어 있으며, 
* 추가적으로 사용하실 파라미터는 연동메뉴얼을 참고하세요.
****************************************************************************************
*/

$sResultCode	= $receiveData["resultCd"]; 	// 결과코드
$sResultMsg 	= $receiveData["resultMsg"]; 	// 결과메시지
$sPayMethod 	= $receiveData["payMethod"]; 	// 결제수단
$sGoodsAmt 		= $receiveData["goodsAmt"]; 	// 취소금액
$sTid 			= $receiveData["oTid"]; 		// 거래ID

?>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
<title>CANCEL RESULT</title>
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
                    <td colspan="3"><p style="margin:10px 0 10px; text-align:center; font-size:34px; color:#2a323c; font-family:'Malgun Gothic','맑은 고딕',sans-serif;">취소 결과</p></td>
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
                                    <td class="tbl_td"><?=$sAmt?></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">거래아이디</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><?=$sTid?></td>
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