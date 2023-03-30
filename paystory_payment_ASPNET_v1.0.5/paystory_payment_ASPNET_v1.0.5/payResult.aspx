<%@ Page Language="C#" AutoEventWireup="true" CodeFile="payResult.aspx.cs" Inherits="payResult" %>

<!DOCTYPE html>
<html>
<head runat="server">
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
                                            <th><span>[ResultCode]ResultMsg</span></th>
                                            <td align="left">[<%=Res_resultCd %>][<%= Res_resultMsg %>]</td>
                                        </tr>
                                        <tr>
                                            <th>결제수단</th>
                                            <td align="left"><%= Res_payMethod %> </td>
                                        </tr>
                                        <tr>
                                            <th>가맹점 ID</th>
                                            <td align="left"><%= Res_mid %> </td>
                                        </tr>
                                        <tr>
                                            <th>결제 금액</th>
                                            <td align="left"><%= Res_amt %> </td>
                                        </tr>
                                        <tr>
                                            <th>결제사명</th>
                                            <td align="left"><%= Res_cpNm %> </td>
                                        </tr>
                                        <tr>
                                            <th>거래아이디</th>
                                            <td align="left"><%= Res_tid %> </td>
                                        </tr>
                                        <tr>
                                            <th>결제일시</th>
                                            <td align="left"><%= Res_appDtm %> </td>
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