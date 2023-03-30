using System;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using Newtonsoft.Json.Linq;

public partial class payResult : System.Web.UI.Page
{
    protected string Res_resultCd;
    protected string Res_resultMsg;
    protected string Res_payMethod;
    protected string Res_tid;
    protected string Res_mid;
    protected string Res_fnNm;
    protected string Res_amt;
    protected string Res_appDtm;



    /*
    ****************************************************************************************
    * <파라미터 정의>
    * 샘플페이지에서는 승인 결과 파라미터 중 일부만 예시되어 있으며, 
    * 추가적으로 사용하실 파라미터는 연동메뉴얼을 참고하세요.
    ****************************************************************************************
    */
    protected string resultCode;
    protected string resultMsg;
    protected string tid;
    protected string PayMethod;
    protected string mid;
    protected string ordNo;
    protected string goodsAmt;
    protected string mbsReserved;
    protected string signData;
    protected string hashStrata;
    protected string ediDate;
    protected string merchantKey;
    protected string postData;
    protected string result;




    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            resultData();
        }
    }

    /*
    ****************************************************************************************
    * <인증 결과 파라미터>
    ****************************************************************************************
    */
    protected void resultData()
    {
        merchantKey = "";
        resultCode = Request.Params["resultCode"];
        resultMsg = Request.Params["resultMsg"];
        tid = Request.Params["tid"];
        PayMethod = Request.Params["PayMethod"];
        mid = Request.Params["mid"];
        goodsAmt = Request.Params["goodsAmt"];
        mbsReserved = Request.Params["mbsReserved"];
        signData = Request.Params["signData"];
        ediDate = Request.Params["ediDate"];



        hashStrata = stringToSHA256(mid + ediDate + goodsAmt + merchantKey);


        var postData = "tid=" + tid;
        postData += "&mid=" + Uri.EscapeDataString(mid);
        postData += "&ediDate=" + Uri.EscapeDataString(ediDate);
        postData += "&signData=" + Uri.EscapeDataString(signData);
        postData += "&goodsAmt=" + Uri.EscapeDataString(goodsAmt); ;
        postData += "&hashStrata=" + hashStrata;

        /*
        ****************************************************************************************
        * <인증 결과 성공시 승인 진행>
        ****************************************************************************************
        */
        if (resultCode.Equals("0000")) // 인증 성공일때 승인요청
        {
            /*
	        ****************************************************************************************
	        * <승인 요청 >
	        ****************************************************************************************
	        */
            ServicePointManager.Expect100Continue = true;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;

            var result = apiRequest("https://pg.minglepay.co.kr/payment.do", postData);

            var queryStr = streamEncode(result);

            var response = JObject.Parse(queryStr);


            /*
	        ****************************************************************************************
	        * <결제 결과 파라미터>
	        ****************************************************************************************
	        */
            Res_resultCd = response["resultCd"].ToString();
            Res_resultMsg = response["resultMsg"].ToString();
            Res_payMethod = response["payMethod"].ToString();
            Res_mid = response["mid"].ToString();
            Res_goodsAmt = response["goodsAmt"].ToString();
            Res_tid = response["tid"].ToString();
            Res_cpNm = response["cpNm"].ToString();
            Res_appDtm = response["appDtm"].ToString();
        }
        else
        {


            //인증실패 시 처리 
            Res_resultCd = resultCode;
            Res_resultMsg = resultMsg;
        }

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

        System.Text.Encoding utf8 = System.Text.Encoding.GetEncoding("utf-8");
        var data = utf8.GetBytes(postData);

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