using System;
using System.IO;
using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using Newtonsoft.Json.Linq;

public partial class payNoti : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            payNoti();
        }
    }

    /*
        *******************************************************
        * <해쉬암호화> (수정하지 마세요)
        * SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
        *******************************************************
        */
        protected String stringToSHA256(String plain)
    {
        SHA256Managed SHA256 = new SHA256Managed();
        String getHashString = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(plain))).ToLower();
        return getHashString.Replace("-", "");
    }
    
    protected void payNoti()
    {
         String merchantKey    = ""; 							 		// 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
         String sResultCd      = Request.Params["resultCd"];   		// 응답 코드
         String sResultMsg     = Request.Params["resultMsg"];  		// 응답 메시지
         String sPayMethod     = Request.Params["payMethod"];  		// 결제 방법(CARD,BANK,VACNT,PHONE,CULTUREGIFT)
         String sTid           = Request.Params["tid"];        		// 거래번호
         String sOtid          = Request.Params["oTid"];       		// 원 거래번호 (취소 noti시에만 전달)
         String sMid           = Request.Params["mid"];        		// 상점 ID
         String sAppDtm        = Request.Params["appDtm"];     		// 결제일시 (예 20210323163604)
         String sCcDtm         = Request.Params["ccDtm"];     		// 취소일시 (예 20210323195004)
         String sAppNo         = Request.Params["appNo"];      		// 승인번호
         String sOrdNo         = Request.Params["ordNo"];      		// 주문번호
         String sGoodsNm       = Request.Params["goodsNm"];  		// 결제 상품명
         String sGoodsAmt      = Request.Params["goodsAmt"];        		// 결제금액 or 취소금액
         String sOrdNm         = Request.Params["ordNm"];      		// 구매자 
         String sCpNm          = Request.Params["cpNm"];       		// 제휴사명
         String sCancelYN      = Request.Params["cancelYN"];   		// 결제 취소 여부 (승인:N, 취소:Y)
         String sAppCardCd     = Request.Params["appCardCd"];  		// 카드 발급사코드
         String sAcqCardCd     = Request.Params["acqCardCd"];  		// 카드 매입사코드
         String sQuota         = Request.Params["quota"];      		// 카드 할부기간.
         String sUsePointAmt   = Request.Params["usePointAmt"];		// 사용 카드 포인트
         String sCardType      = Request.Params["cardType"];   		// 카드타입 (0:신용, 1:체크)
         String sAuthType      = Request.Params["authType"];   		// 인증타입 (01:Keyin, 02:ISP, 03:MPI)
         String sCashCrctFlg   = Request.Params["cashCrctFlg"]; 	// 현금영수증 발급여부 (0:미발급, 1:발급)
         String sVacntNo       = Request.Params["vacntNo"];    		// 가상계좌번호
         String sLmtDay        = Request.Params["lmtDay"];     		// 입금기한
         String sSocHpNo       = Request.Params["socHpNo"];    		// 결제 휴대폰 번호
         String sEdiDate       = Request.Params["ediDate"];    		// 전문생성일시
         String sHashStr       = Request.Params["hashStr"];    		// 해쉬값
         String sMbsReserved   = Request.Params["mbsReserved"];		// 상점정의 필드

         String hashStrLocal   = stringToSHA256(sMid + sEdiDate + sGoodsAmt + merchantKey); 

        
        

        if(sHashStr.Equals(hashStrLocal)){

            if ("3001".Equals(sResultCd) && "CARD".Equals(sPayMethod) && "N".Equals(sCancelYN)){

                // 결제 성공 DB 처리
            } else if("2001".Equals(sResultCd) && "CARD".Equals(sPayMethod) && "Y".Equals(sCancelYN)){

                // 취소 성공 DB 처리
            }

        }
    
    }
}