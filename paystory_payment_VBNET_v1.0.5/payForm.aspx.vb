Imports System
Imports System.Security.Cryptography
Imports System.Text
Imports System.Web

Public Class payForm
    Inherits System.Web.UI.Page
    Protected goodsNm As String
    Protected goodsAmt As String
    Protected merchantID As String
    Protected ordNo As String
    Protected ordNm As String
    Protected ordTel As String
    Protected ordEmail As String
    Protected returnUrl As String
    Protected ediDate As String
    Protected merchantKey As String
    Protected notiURL As String
    Protected hashStr As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs)
        init()
    End Sub

    Public Sub init()
        merchantID = ""
        merchantKey = ""
        goodsNm = "테스트 상품"
        goodsAmt = "1004"
        ordNm = "홍길동"
        ordTel = "01012345678"
        ordEmail = "test@pay-story.co.kr"
        returnUrl = "https://merchantDomain.com/payResult.jsp"
        ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now)
        ordNo = merchantID & ediDate
        hashStr = stringToSHA256(merchantID & ediDate & goodsAmt & merchantKey)
    End Sub

    Public Function stringToSHA256(ByVal plain As String) As String
        Dim SHA256 As SHA256Managed = New SHA256Managed()
        Dim getHashString As String = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(plain))).ToLower()
        Return getHashString.Replace("-", "")
    End Function
End Class
