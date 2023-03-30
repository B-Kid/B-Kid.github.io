<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
<title>결제 취소 페이지</title>
</head>
<body>
<script type="text/javascript">
function doCancel(){
	document.payCancel.submit();
}
</script>
<div style="text-align:center;">
<div id="sampleInput" class="inputTbl_wrap paypop_con" style="display: inline-block;float: inherit;">
<p class="square_tit mt0" style="text-align:center;"><strong>결제 취소 정보</strong></p>
<form name="payCancel" method="post" action="./cancelResult.aspx">
	<table class="tbl_sty02">
		<tr>
			<th align="right">MID *</th>
			<td align="left"><input type="text" name="mid" value=""></td>
		</tr>
		<tr>
			<th align="right">TID *</th>
			<td align="left"><input type="text" name="tid" value=""></td>
		</tr>
		<tr>
			<th align="right">취소금액 *</th>
			<td align="left"><input type="text" name="canAmt" value=""></td>
		</tr>
		<tr>
			<th align="right">부분취소 여부 *</th>
			<td align="left">
				<select id="partCanFlg" name="partCanFlg">
					<option value="0">전체 취소</option>
					<option value="1">부분 취소</option>
				</select>				
			</td>
		</tr>
		<tr>
			<th align="right">환불은행</th>
			<td align="left">
				<select id="refundBankCd" name="refundBankCd">
					<option value="002">KDB산업</option>
					<option value="003">기업</option>
					<option value="004">국민</option>
					<option value="011">농협</option>
					<option value="020">우리</option>
					<option value="081">하나</option>
					<option value="088">신한</option>
					<option value="090">카카오뱅크</option>
				</select>				
			</td>
		</tr>
		<tr>
			<th align="right">환불계좌 </th>
			<td align="left"><input type="text" name="refundAccnt" value=""></td>
		</tr>
		<tr>
			<th align="right">환불계좌주 </th>
			<td align="left"><input type="text" name="refundNm" value="홍길동"></td>
		</tr>		
	</table>
</form>		

	<a href="#;" id=cancelBtn class="btn_sty01 bg01" style="margin:15px;" onClick="doCancel();">취소하기</a>
	</div>
</div>
</body>
</html>