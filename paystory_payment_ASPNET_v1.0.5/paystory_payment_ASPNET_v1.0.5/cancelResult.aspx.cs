using System;
using System.Security.Cryptography;
using System.Text;
using System.Net;
using System.IO;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;


public partial class cancelResult : System.Web.UI.Page{
    protected string Ref_resultCd;
    protected string Ref_resultMsg;
    protected string Ref_tid;
    protected string Ref_payMethod;
    protected string Ref_goodsAmt;

 

    protected string mid;
    protected string tid;
    protected string canAmt;
    protected string partCanFlg;
    protected string refundBankCd;
    protected string refundAccnt;
    protected string merchantKey;
    protected string refundNm;
    protected string notiUrl;
    protected string canMsg;
    protected string ediDate;
    protected string hashStr;



    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            resultData();
        }
    }

    protected void resultData()
    {
        /*
        ****************************************************************************************
        * <취소요청 파라미터>
        * 취소시 전달하는 파라미터입니다.
        * 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
        * 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
        ****************************************************************************************
        */
        merchantKey         = "";                                           // 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
        mid                 = Request.Params["mid"];                        // 상점 ID
        tid                 = Request.Params["tid"];                        // 거래 ID
        canAmt              = Request.Params["canAmt"];                     // 취소 금액
        partCanFlg          = Request.Params["partCanFlg"];                 // 부분취소여부
        refundBankCd        = Request.Params["refundBankCd"];               // 환불은행 코드
        refundAccnt         = Request.Params["refundAccnt"];                // 환불계좌
        refundNm            = Request.Params["refundNm"];                   // 환불 계좌주명
        //notiUrl           = "http://상점도메인/cancelNoti.aspx";          // 취소 결과를 따로 통보 받고자 할 때 사용
        canMsg              = "고객 요청";                                  // 취소 사유


        /*
        *******************************************************
        * <해쉬암호화> (수정하지 마세요)
        * SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
        *******************************************************
        */
        ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);        // 전문 생성일시
        hashStr = stringToSHA256(mid + ediDate + canAmt + merchantKey);     // Hash 값

        
      
        var postData = "mid=" + mid;
        postData += "&tid=" + tid;
        postData += "&canAmt=" + canAmt;
        postData += "&partCanFlg=" + partCanFlg;
        postData += "&refundBankCd=" + refundBankCd;
        postData += "&refundAccnt=" + refundAccnt;
        postData += "&refundNm=" + refundNm;
        postData += "&notiUrl=" + notiUrl; 
        postData += "&canMsg=" + canMsg;
        postData += "&ediDate=" + ediDate;
        postData += "&hashStr=" + Uri.EscapeDataString(hashStr);

        
        /*
        ****************************************************************************************
        * <취소 요청>
        * 취소에 필요한 데이터 생성 후 server to server 통신을 통해 취소 처리 합니다.
        * 취소 사유(CancelMsg) 와 같이 한글 텍스트가 필요한 파라미터는 encoding 처리가 필요합니다.
        ****************************************************************************************
        */

        ServicePointManager.Expect100Continue = true;
        ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
        var result = apiRequest("https://pg.minglepay.co.kr/payment.cancel", postData);
        
        var queryStr = streamEncode(result);

        JObject response = JObject.Parse(queryStr);

        

		
        /*
        ****************************************************************************************
        * <취소 결과 파라미터 정의>
        * 샘플페이지에서는 취소 결과 파라미터 중 일부만 예시되어 있으며, 
        * 추가적으로 사용하실 파라미터는 연동메뉴얼을 참고하세요.
        ****************************************************************************************
        */
        Ref_resultCd   = response["resultCd"].ToString();
        Ref_resultMsg  = response["resultMsg"].ToString();
        Ref_tid        = response["tid"].ToString();
        Ref_payMethod  = response["payMethod"].ToString();
        Ref_amt        = response["amt"].ToString();

    }

    public String stringToSHA256(String plain)
    {
        SHA256Managed SHA256 = new SHA256Managed();
        String getHashString = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(plain))).ToLower();
        return getHashString.Replace("-", "");
    }

    public HttpWebResponse apiRequest(String url, String postData)
    {
        var request = (HttpWebRequest)WebRequest.Create(url);

        System.Text.Encoding euckr = System.Text.Encoding.GetEncoding("utf-8");
        var data = euckr.GetBytes(postData);

        request.Method = "POST";
        request.ContentType = "application/x-www-form-urlencoded";
        request.ContentLength = data.Length;

        using (var stream = request.GetRequestStream())
        {
            stream.Write(data, 0, data.Length);
        }

        var result = (HttpWebResponse)request.GetResponse();
        return result;
    }

    public String streamEncode(HttpWebResponse result)
    {
        Stream ReceiveStream = result.GetResponseStream();
        Encoding encode = System.Text.Encoding.GetEncoding("utf-8");

        StreamReader sr = new StreamReader(ReceiveStream, encode);

        Char[] read = new Char[8096];
        int count = sr.Read(read, 0, 8096);
        Char[] chTemp = new Char[count];
        for (int i = 0; i < count; ++i)
            chTemp[i] = read[i];

        Byte[] buffer = encode.GetBytes(chTemp);
        String strOut = encode.GetString(buffer);

        return strOut;
    }
}