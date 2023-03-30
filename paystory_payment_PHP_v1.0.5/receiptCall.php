<?php
header("Content-Type:text/html; charset=utf-8;");

$merchantKey	= "";  // 상점키
$mid			= ""; // 상점 ID

/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/
$hashStr 	= bin2hex(hash('sha256', $mid.$merchantKey, true));// Hash 값
?>

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
    		<td><input type="text" name="mid" id="mid" value="<?=$mid?>"></td>
        </tr>
        <tr>
            <td>tid</td>
            <td><input type="text" name="tid" id="tid"></td>
        </tr>
        	<input type="hidden" name="hashStr" id="hashStr" value="<?=$hashStr?>">
    </table>
    
   <button type="button" id="selectBtn">조회</button>
</form>
 <script type="text/javascript" src="https://mms.minglepay.co.kr/js/receipt.js"></script>
</body>
</html>