using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;



public partial class payForm : System.Web.UI.Page{
    protected String goodsNm;
    protected String goodsAmt;
    protected String merchantID;
    protected String ordNo;
    protected String ordNm;
    protected String ordTel;
    protected String ordEmail;
    protected String returnUrl;    
    protected String ediDate;
    protected String merchantKey;
    protected String notiURL;
    protected String hashStr;

    protected void Page_Load(object sender, EventArgs e){
        init(); 
    }

    /********************************************************** 
    * <결제요청 파라미터>
    * 결제시 Form 에 보내는 결제요청 파라미터입니다.
    * 샘플페이지에서는 기본(필수) 파라미터만 예시되어 있으며, 
    * 추가 가능한 옵션 파라미터는 연동메뉴얼을 참고하세요.
    **********************************************************/
    public void init(){
        
        merchantID 		= "";									                                // 상점ID
        merchantKey  	= "";		                                                            // 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
        goodsNm 		= "테스트 상품";                                                         // 결제상품명
        goodsAmt 		= "1004";                                                               // 결제상품금액	
        ordNm 			= "홍길동";                                                             // 구매자명
        ordTel 			= "01012345678";                                                        // 구매자연락처
        ordEmail 		= "test@pay-story.co.kr";                                               // 구매자메일주소
        returnUrl 		= "https://merchantDomain.com/payResult.jsp";                                    // 결과리턴페이지(모바일 결제시 필수)
        //notiURL         = "https://merchantDomain.com/payNoti.jsp";                                    // 결제 결과를 따로 통보 받고자 할때 사용
        ediDate = String.Format("{0:yyyyMMddHHmmss}", DateTime.Now);                            // 전문요청일자
        ordNo 			= merchantID+ediDate;                                                   // 주문번호 (유니크한 값 세팅 필요)	
        hashStr         = stringToSHA256(merchantID + ediDate + goodsAmt + merchantKey);        // Hash 값
    }

        /*
        *******************************************************
        * <해쉬암호화> (수정하지 마세요)
        * SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
        *******************************************************
        */
    public String stringToSHA256(String plain){
        SHA256Managed SHA256 = new SHA256Managed();
        String getHashString = BitConverter.ToString(SHA256.ComputeHash(Encoding.UTF8.GetBytes(plain))).ToLower();
        return getHashString.Replace("-", "");
    }
}
