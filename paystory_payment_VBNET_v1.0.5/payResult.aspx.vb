Imports System
Imports System.IO
Imports System.Net
Imports System.Security.Cryptography
Imports System.Text
Imports System.Web.UI
Imports Newtonsoft.Json.Linq

Public Class payResult
    Inherits System.Web.UI.Page

    Protected Res_resultCd As String
    Protected Res_resultMsg As String
    Protected Res_payMethod As String
    Protected Res_tid As String
    Protected Res_mid As String
    Protected Res_cpNm As String
    Protected Res_goodsAmt As String
    Protected Res_appDtm As String
    Protected resultCode As String
    Protected resultMsg As String
    Protected tid As String
    Protected PayMethod As String
    Protected mid As String
    Protected ordNo As String
    Protected goodsAmt As String
    Protected mbsReserved As String
    Protected signData As String
    Protected hashStr As String
    Protected ediDate As String
    Protected merchantKey As String
    Protected postData As String
    Protected result As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsPostBack Then
            resultData()
        End If
    End Sub

    Protected Sub resultData()
        merchantKey = ""
        resultCode = Request.Params("resultCode")
        resultMsg = Request.Params("resultMsg")
        tid = Request.Params("tid")
        PayMethod = Request.Params("PayMethod")
        mid = Request.Params("mid")
        goodsAmt = Request.Params("goodsAmt")
        mbsReserved = Request.Params("mbsReserved")
        signData = Request.Params("signData")
        ediDate = Request.Params("ediDate")
        hashStr = stringToSHA256(mid & ediDate & goodsAmt & merchantKey)
        Dim postData = "tid=" & tid
        postData += "&mid=" & Uri.EscapeDataString(mid)
        postData += "&ediDate=" & Uri.EscapeDataString(ediDate)
        postData += "&signData=" & Uri.EscapeDataString(signData)
        postData += "&goodsAmt=" & Uri.EscapeDataString(goodsAmt)
        postData += "&hashStr=" & hashStr

        If resultCode.Equals("0000") Then
            ServicePointManager.Expect100Continue = True
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12
            Dim result = apiRequest("https://pg.minglepay.co.kr/payment.do", postData)
            Dim queryStr = streamEncode(result)
            Dim response = JObject.Parse(queryStr)
            Res_resultCd = response("resultCd").ToString()
            Res_resultMsg = response("resultMsg").ToString()
            Res_payMethod = response("payMethod").ToString()
            Res_mid = response("mid").ToString()
            Res_amt = response("goodsAmt").ToString()
            Res_tid = response("tid").ToString()
            Res_fnNm = response("cpNm").ToString()
            Res_appDtm = response("appDtm").ToString()
        Else
            Res_resultCd = resultCode
            Res_resultMsg = resultMsg
        End If
    End Sub

    Public Function stringToSHA256(ByVal plain As String) As String
        Dim SHA256 As SHA256Managed = New SHA256Managed()
        Dim getHashString As String = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(plain))).ToLower()
        Return getHashString.Replace("-", "")
    End Function

    Public Function apiRequest(ByVal url As String, ByVal postData As String) As HttpWebResponse
        Dim request = CType(WebRequest.Create(url), HttpWebRequest)
        Dim utf8 As System.Text.Encoding = System.Text.Encoding.GetEncoding("utf-8")
        Dim data = utf8.GetBytes(postData)
        request.Method = "POST"
        request.ContentType = "application/x-www-form-urlencoded"
        request.ContentLength = data.Length

        Using stream = request.GetRequestStream()
            stream.Write(data, 0, data.Length)
        End Using

        Dim result = CType(request.GetResponse(), HttpWebResponse)
        Return result
    End Function

    Public Function streamEncode(ByVal result As HttpWebResponse) As String
        Dim ReceiveStream As Stream = result.GetResponseStream()
        Dim encode As Encoding = System.Text.Encoding.GetEncoding("utf-8")
        Dim sr As StreamReader = New StreamReader(ReceiveStream, encode)
        Dim read As Char() = New Char(8095) {}
        Dim count As Integer = sr.Read(read, 0, 8096)
        Dim chTemp As Char() = New Char(count - 1) {}

        For i As Integer = 0 To count - 1
            chTemp(i) = read(i)
        Next

        Dim buffer As Byte() = encode.GetBytes(chTemp)
        Dim strOut As String = encode.GetString(buffer)
        Return strOut
    End Function
End Class
