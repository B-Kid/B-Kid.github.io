<!-- #include file = "cryptSHA256.asp" -->
<!-- #include virtual = "aspJSON.asp"-->
<% response.Charset = "utf-8"%>
<%
'/*
'****************************************************************************************
'* <인증 결과 파라미터>
'****************************************************************************************
'*/
resultCode 	= trim(request("resultCode")) 	' 인증결과 : 0000(성공)
resultMsg 	= trim(request("resultMsg")) 	' 인증결과 메시지
tid 		= trim(request("tid")) 			' 거래 ID
payMethod 	= trim(request("payMethod")) 	' 결제수단
ediDate 	= trim(request("ediDate")) 		' 결제 일시
mertId 		= trim(request("mid")) 			' 상점 아이디
goodsAmt 	= trim(request("goodsAmt")) 	' 결제 금액
reqReserved = trim(request("reqReserved")) 	' 상점 예약필드
signData	= trim(request("signData"))		' 인증결과 암호화 데이터 (최종 승인요청시 전달함)
merchantKey = ""							' 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)

'/*
'*******************************************************
'* <해쉬암호화> (수정하지 마세요)
'* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
'*******************************************************
'*/
 
hashStr = enc(mertId & ediDate & goodsAmt & merchantKey)

function enc(str)
	Set SHA = New CryptSHA256
	enc = SHA.SHA256(str)
end function

'/*
'****************************************************************************************
'* <인증 결과 성공시 승인 진행>
'****************************************************************************************
'*/

If resultCode = "0000" Then
	Dim requestData 
		requestData = "tid=" & tid & "&"
		requestData = requestData & "mid=" & mertId & "&"
		requestData = requestData & "goodsAmt=" & goodsAmt & "&"
		requestData = requestData &	"ediDate=" & ediDate & "&"
		requestData = requestData &	"charSet=" & "utf-8" & "&"
		requestData = requestData &	"hashStr=" & hashStr & "&"
		requestData = requestData &	"signData=" & signData

Response.Write requestData & "<br>"

	Dim httpRequest, receiveData

	Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
	httpRequest.Open "POST", "https://pg.minglepay.co.kr/payment.do", False
	httpRequest.SetRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	httpRequest.Send requestData
	receiveData = httpRequest.ResponseText

	Set oJSON = New aspJSON
	oJSON.loadJSON(receiveData) 

	If oJSON.data("quota")= "00" Then 
		quota = "일시불"
	Else 
		quota = oJSON.data("quota") + "개월"
	End If
Else
	 '실패처리

End if
	
%>
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
                                    <th scope="row" class="tbl_th">거래아이디</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><%= oJSON.data("tid") %></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">구매자명</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><%= oJSON.data("ordNm") %>&nbsp;</td>
                                </tr>
                                <tr>
									<th scope="row" class="tbl_th">상품명</th>
							      </tr>
                                <tr>
									<td class="tbl_td"><%= oJSON.data("goodsName") %></td>
								</tr>
								<tr>
									<th scope="row" class="tbl_th">제휴사 명</th>
								 </tr>
                                <tr>
									<td class="tbl_td"><%= oJSON.data("cpNm") %></td>
								</tr>
								<tr>
									<th scope="row" class="tbl_th">할부개월</th>
									 </tr>
                                <tr>
									<td class="tbl_td"><%= quota %></td>
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
