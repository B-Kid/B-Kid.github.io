<?php
header("Content-Type:text/html; charset=utf-8;");
/*
*******************************************************
* <결제요청 파라미터>
* 결제시 Form 에 보내는 결제요청 파라미터입니다.
*******************************************************
*/

$merchantKey 	= "";				             // 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
$merchantID 	= ""; 				             // 상점아이디
$goodsNm 		= "테스트상품"; 				  // 결제상품명
$goodsAmt 		= "1004"; 						 // 결제상품금액	
$ordNm 			= "홍길동"; 					 // 구매자명
$ordTel 		= "01012345678"; 				 // 구매자연락처
$ordEmail 		= "test@minglepay.co.kr";		 // 구매자메일주소
$ordNo 			= ""; 							 // 상품주문번호	
$returnUrl 		= "http://test.com/payResult.php"; 	// 인증결과 리턴페이지(모바일 결제시 필수)

/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/
$ediDate 		= date("YmdHis");				// 전문 생성일시
$hashStr 		= bin2hex(hash('sha256', $merchantID.$ediDate.$goodsAmt.$merchantKey, true));// Hash 값
?>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
<title>결제 요청</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://pg.minglepay.co.kr/js/pgAsistant.js"></script>
</head>
<body>
<script type="text/javascript">

function doPaySubmit(){
	// 결제창 호출 함수
	SendPay(document.payInit);  
}
// 결제창 return 함수(pay_result_submit 이름 변경 불가능)
function pay_result_submit(){
	payResultSubmit()
}
// 결제창 종료 함수(pay_result_close 이름 변경 불가능)
function pay_result_close(){
	alert('결제를 취소하였습니다.');
}
</script>
<div style="text-align:center;">
<div id="sampleInput" class="paypop_con" style="padding:20px 15px 35px 15px;display: inline-block;float: inherit;">
<p class="square_tit mt0" style="text-align:left;"><strong>결제정보</strong></p>
<form name="payInit" method="post" id="payInit" action="<?=$returnUrl?>">
	<table class="tbl_sty02">
		<tr>
			<td>결제수단</td>
			<td align="left">
				<select name="payMethod">
					<option value="" selected="selected">전체</option>
					<option value="CARD">신용카드</option>
					<option value="BANK">계좌이체</option>
					<option value="VACNT">가상계좌</option>
					<option value="PHONE">휴대폰</option>
					<option value="CULTUREGIFT">문화상품권</option>
				</select> 
			</td>
		</tr>
		<tr>
			<td>상점 ID</td>
			<td><input type="text" name="mid" value="<?=$merchantID?>"></td>
		</tr>
		<tr>
			<td>상품명</td>
			<td><input type="text" name="goodsNm" value="<?=$goodsNm?>"></td>
		</tr>
		<tr>
			<td>주문번호</td>
			<td><input type="text" name="ordNo" value="<?=$merchantID.$ediDate?>"></td>
		</tr>
		<tr>
			<td>결제금액</td>
			<td><input type="text" name="goodsAmt" value="<?=$goodsAmt?>"></td>
		</tr>
		<tr>
			<td>구매자명</td>
			<td><input type="text" name="ordNm" value="<?=$ordNm?>"></td>
		</tr>
		<tr>
			<td>구매자연락처</td>
			<td><input type="text" name="ordTel" value="<?=$ordTel?>"></td>
		</tr>
		<tr>
			<td>구매자이메일</td>
			<td><input type="text" name="ordEmail" value="<?=$ordEmail?>"></td>
		</tr>
	</table>
	<!-- 옵션 --> 
	<input type="hidden" name="userIp"	value="127.0.0.1">
		
	<input type="hidden" name="mbsUsrId" value="user1234">
	<input type="hidden" name="mbsReserved" value="상점정의 필드입니다"><!-- 상점 예약필드 -->
	<input type="hidden" name="returnUrl" value="https://상점도메인/payResult.php"><!-- 모바일 환경에서 결과페이지 호출시 필수 -->
	<input type="hidden" name="language" value="KOR">
	<!-- <input type="hidden" name="goodsSplAmt" value="0"> -->
	<!-- <input type="hidden" name="goodsVat" value="0"> -->
	<!-- <input type="hidden" name="goodsSvsAmt" value="0"> -->
	<!-- <input type="hidden" name="notiUrl" value="https://상점도메인/payNoti.php">--><!-- 결제결과를 따로 통보 받고자 할 때 사용 (가상계좌 사용시 필수)-->
	
	<input type="hidden" name="appMode" value="1">
	
	<!-- 변경 불가능 -->
	<input type="hidden" name="ediDate" value="<?=$ediDate?>"><!-- 전문 생성일시 -->
	<input type="hidden" name="hashStr" value="<?=$hashStr?>"><!-- 해쉬값 -->
	<input type="hidden" name="trxCd"	value="0"><!-- 에스크로  적용 여부 -->

</form>	
	<a href="#;" id="payBtn" class="btn_sty01 bg01" style="margin:15px;" onClick="doPaySubmit();">결제하기</a>
	</div>
</div>
<div id="mask"></div>
<div class="window">
	<div class="cont">
		<iframe id="pay_frame" name="pay_frame" width="100%" height="500" marginwidth="0" marginheight="0" frameborder="no" scrolling="yes"></iframe>
	</div>
</div>
</body>
</html>