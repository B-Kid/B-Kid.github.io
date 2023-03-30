Imports System
Imports System.Security.Cryptography
Imports System.Text
Imports System.Net
Imports System.IO
Imports Newtonsoft.Json
Imports Newtonsoft.Json.Linq

Public Class cancelResult
    Inherits System.Web.UI.Page

    Protected Ref_resultCd As String
    Protected Ref_resultMsg As String
    Protected Ref_tid As String
    Protected Ref_payMethod As String
    Protected Ref_amt As String
    Protected mid As String
    Protected tid As String
    Protected canAmt As String
    Protected partCanFlg As String
    Protected refundBankCd As String
    Protected refundAccnt As String
    Protected merchantKey As String
    Protected refundNm As String
    Protected notiUrl As String
    Protected canMsg As String
    Protected ediDate As String
    Protected hashStr As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        If Not Page.IsPostBack Then
            resultData()
        End If
    End Sub

    Protected Sub resultData()
        merchantKey = ""
        mid = Request.Params("mid")
        tid = Request.Params("tid")
        canAmt = Request.Params("canAmt")
        partCanFlg = Request.Params("partCanFlg")
        refundBankCd = Request.Params("refundBankCd")
        refundAccnt = Request.Params("refundAccnt")
        refundNm = Request.Params("refundNm")
        canMsg = "고객 요청"
        ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now)
        hashStr = stringToSHA256(mid & ediDate & canAmt & merchantKey)
        Dim postData = "mid=" & mid
        postData += "&tid=" & tid
        postData += "&canAmt=" & canAmt
        postData += "&partCanFlg=" & partCanFlg
        postData += "&refundBankCd=" & refundBankCd
        postData += "&refundAccnt=" & refundAccnt
        postData += "&refundNm=" & refundNm
        postData += "&notiUrl=" & notiUrl
        postData += "&canMsg=" & canMsg
        postData += "&ediDate=" & ediDate
        postData += "&hashStr=" & Uri.EscapeDataString(hashStr)
        ServicePointManager.Expect100Continue = True
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12
        Dim result = apiRequest("https://pg.minglepay.co.kr/payment.cancel", postData)
        Dim queryStr = streamEncode(result)
        Dim response As JObject = JObject.Parse(queryStr)
        Ref_resultCd = response("resultCd").ToString()
        Ref_resultMsg = response("resultMsg").ToString()
        Ref_tid = response("tid").ToString()
        Ref_payMethod = response("payMethod").ToString()
        Ref_amt = response("goodsAmt").ToString()
    End Sub

    Public Function stringToSHA256(ByVal plain As String) As String
        Dim SHA256 As SHA256Managed = New SHA256Managed()
        Dim getHashString As String = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(plain))).ToLower()
        Return getHashString.Replace("-", "")
    End Function

    Public Function apiRequest(ByVal url As String, ByVal postData As String) As HttpWebResponse
        Dim request = CType(WebRequest.Create(url), HttpWebRequest)
        Dim euckr As System.Text.Encoding = System.Text.Encoding.GetEncoding("utf-8")
        Dim data = euckr.GetBytes(postData)
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