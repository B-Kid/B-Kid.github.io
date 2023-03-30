<!-- #include file = "cryptSHA256.asp" -->
<!-- #include virtual = "aspJSON.asp"-->
<% response.Charset = "utf-8"%>
<%

mertId 		= ""			' 상점 아이디
merchantKey = ""		    ' 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
'/*
'*******************************************************
'* <해쉬암호화> (수정하지 마세요)
'* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
'*******************************************************
'*/

hashStr = enc(mertId & merchantKey)    ' Hash 값

	function enc(str)
		Set SHA = New CryptSHA256
		enc = SHA.SHA256(str)
	end function
%>

<!DOCTYPE html>
<html lang="kr">
<head>
    <meta charset="UTF-8">
    <title>영수증 조회 페이지</title>
</head>
<body>
<form name="receiptForm" id="receiptForm" method="post">
    <table class="tbl_sty02">
        <tr>
            <td>영수증 구분</td>
            <td>
                <select name="receiptType" id="receiptType">
                    <option value="general">거래명세서</option>
                    <option value="cash" selected>현금영수증</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>상점아이디</td>
    		<td><input type="text" name="mid" id="mid" value="<%=mertId%>"></td>
        </tr>
        <tr>
            <td>tid</td>
            <td><input type="text" name="tid" id="tid"></td>
        </tr>
        	<input type="hidden" name="hashStr" id="hashStr" value="<%=hashStr%>">
    </table>
    
   <button type="button" id="selectBtn">조회</button>
</form>
 <script type="text/javascript" src="https://mms.minglepay.co.kr/js/receipt.js"></script>
</body>
</html>
