<%@ Page Language="VB"  AutoEventWireup="true" CodeFile="payForm.aspx.vb" Inherits="payForm"%>

<!DOCTYPE html>
<html>
<head runat="server">
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
<title>결제 요청</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://pg.minglepay.co.kr/js/pgAsistant.js"></script>
</head>
<body>
<script type="text/javascript">
// 결제창 호출 함수
function doPaySubmit(){
	SendPay(document.payInit);  
}
// 결제창 return 함수(pay_result_submit 이름 변경 불가능)
function pay_result_submit(){
	payResultSubmit();
}
// 결제창 종료 함수(pay_result_close 이름 변경 불가능)
function pay_result_close(){
	alert('결제를 취소하였습니다.');
}
</script>
<div style="text-align:center;">
<div id="sampleInput" class="paypop_con" style="padding:20px 15px 35px 15px;display: inline-block;float: inherit;">
<p class="square_tit mt0" style="text-align:center;"><strong>결제정보</strong></p>
<form name="payInit" method="post" id="payInit" action="./payResult.aspx">
	<table class="tbl_sty02">
		<tr>
			<td align="right">결제수단</td>
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
			<th align="right"> 상점 ID  *</th>
			<td><input type="text" name="mid" value="<%=merchantID%>"></td>
		</tr>
		<tr>
			<th align="right">상품명  *</th>
			<td><input type="text" name="goodsNm" value="<%=goodsNm%>"></td>
		</tr>
		<tr>
			<th align="right">주문번호  *</th>
			<td><input type="text" name="ordNo" value="<%=ordNo%>"></td>
		</tr>
		<tr>
			<th align="right">결제금액 *</th>
			<td><input type="text" name="goodsAmt" value="<%=goodsAmt%>"></td>
		</tr>
		<tr>
			<th align="right">구매자명 *</th>
			<td><input type="text" name="ordNm" value="<%=ordNm%>"></td>
		</tr>
		<tr>
			<th align="right">구매자연락처</th>
			<td><input type="text" name="ordTel" value="<%=ordTel%>"></td>
		</tr>
		<tr>
			<th align="right">구매자이메일</th>
			<td><input type="text" name="ordEmail" value="<%=ordEmail%>"></td>
		</tr>
		
		<tr>
			<th align="right">고객 ID</th>
			<td><input type="text" name="mbsUsrId" value="user1234"></td>
		</tr>
		<tr>
			<th align="right">returnURL  *</th>
			<td><input type="text" name="returnUrl" value="<%=returnUrl%>"></td>
		</tr>
	</table>
	<!-- 옵션 --> 
	<input type="hidden" name="userIp"	value="127.0.0.1">
	<input type="hidden" name="mbsReserved" value="상점정의 필드입니다"><!-- 상점 예약필드 -->
	<input type="hidden" name="language" value="KOR">
	<!-- <input type="hidden" name="goodsSplAmt" value="0"> -->
	<!-- <input type="hidden" name="goodsVat" value="0"> -->
	<!-- <input type="hidden" name="goodsSvsAmt" value="0"> -->
	<!--  <input type="hidden" name="notiURL" value="https://test.com/payNoti.jsp"> --> <!-- 결제 결과를 따로 통보 받고자 할때 사용 (가상계좌 사용시 필수)-->

	
	<!-- 변경 불가능 -->
	<input type="hidden" name="ediDate" value="<%=ediDate%>"><!-- 전문 생성일시 -->
	<input type="hidden" name="hashStr" value="<%=hashStr%>"><!-- 해쉬값 -->
	<input type="hidden" name="trxCd"	value="0"> 

</form>	
	<a href="#;" id="payBtn" class="btn_sty01 bg01" style="margin:15px;" onClick="doPaySubmit();">결제하기</a>
	</div>
</div>
<div id="mask"></div>
<div class="window">
	<div class="cont">
		<iframe id="pay_frame" name="pay_frame" width="100" height="500" marginwidth="0" marginheight="0" frameborder="no" scrolling="yes"></iframe>
	</div>
</div>
</body>
</html>