<!DOCTYPE html>
<%response.Charset = "utf-8"%>
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
<p class="square_tit mt0" style="text-align:left;"><strong>결제 취소 정보</strong></p>
<form name="payCancel" method="post" action="./cancelResult.asp">
	<table class="tbl_sty02">
		<tr>
			<td>MID *</td>
			<td><input type="text" name="mid" value=""></td>
		</tr>
		<tr>
			<td>TID *</td>
			<td><input type="text" name="tid" value=""></td>
		</tr>
		<tr>
			<td>취소금액 *</td>
			<td><input type="text" name="canAmt" value=""></td>
		</tr>
		<tr>
			<td>부분취소 여부 *</td>
			<td>
				<select id="partCanFlg" name="partCanFlg">
					<option value="0">전체 취소</option>
					<option value="1">부분 취소</option>
				</select>				
			</td>
		</tr>

	</table>
	<!-- <input type="hidden" name="refundBankCd"> -->
	<!-- <input type="hidden" name="refundAccnt"> -->
	<!-- <input type="hidden" name="refundNm"> -->
	
	<!-- <input type="hidden" name="goodsSplAmt"> -->
	<!-- <input type="hidden" name="goodsVat"> -->
	<!-- <input type="hidden" name="goodsSvsAmt"> -->
	<!-- <input type="hidden" name="notiUrl" value="https://상점도메인/cancelNoti.asp">--> <!--취소 결과를 따로 통보 받고자 할때 사용-->

</form>		

	<a href="#;" id=cancelBtn class="btn_sty01 bg01" style="margin:15px;" onClick="doCancel();">취소하기</a>
	</div>
</div>
</body>
</html>