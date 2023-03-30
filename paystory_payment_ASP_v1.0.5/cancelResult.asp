<!-- #include file = "cryptSHA256.asp" -->
<!-- #include virtual = "aspJSON.asp"-->
<% response.Charset = "utf-8"%>
<%
'/*
'****************************************************************************************
'* <취소요청 파라미터>
'* 취소시 전달하는 파라미터입니다.
'* 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
'* 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
'****************************************************************************************
'*/

	'ASP에서 MID 함수명과 중복되어 임시 변경
	mertId		= trim(request("mid"))			' 상점 ID
	tid 		= trim(request("tid")) 			' 거래 ID
	canAmt 		= trim(request("canAmt")) 		' 취소 금액
	partCanFlg 	= trim(request("partCanFlg")) 	' 부분취소여부
	canMsg		= "고객요청"					 ' 취소 사유
   'notiUrl	    = trim(request("notiUrl"))		' 취소 결과를 따로 통보 받고자 할 때 사용

	merchantKey	= ""							' 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)

'/*
'*******************************************************
'* <해쉬암호화> (수정하지 마세요)
'* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
'*******************************************************
'*/
	' 시스템 날짜(문자열 14자리, YYYYMMDDhhmmss ) 

	ediDate = Year(now) & right("0"&Month(now),2) & right("0"&Day(now),2) & right("0"& Hour(now),2) & right("0"&Minute(now),2) & right("0"&Second(now),2)   
	hashStr = enc(mertId & ediDate & canAmt & merchantKey)

	function enc(str)
		Set SHA = New CryptSHA256
		enc = SHA.SHA256(str)
	end function

'/*
'****************************************************************************************
'* <취소 요청>
'* 취소에 필요한 데이터 생성 후 server to server 통신을 통해 취소 처리 합니다.
'* 취소 사유(CanMsg) 와 같이 한글 텍스트가 필요한 파라미터는 encoding 처리가 필요합니다.
'****************************************************************************************
'*/
Dim requestData 
	requestData = "tid=" & tid & "&"
	requestData = requestData & "mid=" & mertId & "&"
	requestData = requestData & "canAmt=" & canAmt & "&"
	requestData = requestData &	"canMsg=" & canMsg & "&"
	requestData = requestData &	"partCanFlg=" & partCanFlg & "&"
	requestData = requestData &	"ediDate=" & ediDate & "&"
	requestData = requestData &	"refundNm=" & "홍길동" & "&"
	requestData = requestData &	"refundAccnt=" & "123456789" & "&"
	requestData = requestData &	"refundBankCd=" & "04" & "&"
	requestData = requestData &	"charSet=" & "utf-8" & "&"
   'requestData = requestData &	"notiUrl=" & notiUrl & "&"
	requestData = requestData &	"hashStr=" & hashStr

Dim httpRequest, receiveData

Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
httpRequest.Open "POST", "https://pg.minglepay.co.kr/payment.cancel", False
httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
httpRequest.Send requestData
receiveData = httpRequest.ResponseText

Set oJSON = New aspJSON
oJSON.loadJSON(receiveData)

%>
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
                                    <td class="tbl_td">[<%= oJSON.data("resultCd") %>]<%= oJSON.data("resultMsg") %></td>
                                </tr>                              
                                <tr>
                                    <th scope="row" class="tbl_th">결제수단</th>
                                </tr>
                                <tr>
                                    <td class="tbl_td"><%= oJSON.data("payMethod") %></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">금액</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><%= oJSON.data("goodsAmt") %></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">거래번호</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><%= oJSON.data("oTid") %></td>
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
