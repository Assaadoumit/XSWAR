//
//  DetailViewVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit

class DetailViewVC: UIViewController {

    @IBOutlet var lblTop : UILabel!
    @IBOutlet var imgCar : UIImageView!

    @IBOutlet var lblDesc : UILabel!
    @IBOutlet var lblSeller : UILabel!
    @IBOutlet var lblPrice : UILabel!

    var delearDic : DealerList!
    
    var selectedPart : PartsList!
    var selectedBrand : Brand!
    var selectedmodels : MakingYear!
    var selectedmakingYears : MakingYear!
    var selectedCategory : CategoryList!
    var selectedService : ServiceCatList!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblDesc.text = delearDic.DealerListDescription ?? ""
        self.lblSeller.text = delearDic.dealer?.name ?? ""
        self.lblPrice.text = "$ \(delearDic.price!) USD"

        self.imgCar.sd_setImage(with: URL.init(string: BASE_PATH.appending(delearDic.image ?? "")), placeholderImage: UIImage.init(named: "Logo"))
    }
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOrderClick(_ sender: UIButton)
    {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(signUpVC, animated: true)
        
        signUpVC.completion  = {(data) -> Void in

            self.navigationController?.popViewController(animated: true)

            let userSignUpData = try! UserSignUpData.init(data : data)
            
            if userSignUpData.success!
            {
                appDelegate.userSignUpData = userSignUpData
                
                let partsDic = ["brand_id" : String(self.selectedBrand.brandID ?? 0),
                                "dealer_id" : String(self.delearDic.dealerID ?? 0),
                                "part_id" : String(self.selectedPart.partID ?? 0),
                                "part_making_year" : self.selectedmakingYears.name ?? "",
                                "model" : self.selectedmodels.name ?? "",
                                "delivery_address" : appDelegate.userSignUpData.data!.deliveryAddress ?? ""]
                
                let URL_API = BASE_URL.appending(SEND_NEW_PARTS_REQUEST)
                
                APIParser.dataWithURL(url: URL_API, requestType:.TYPE_DELETE, bodyObject: partsDic, imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                    
                    print(response)
                    
                    let responseData = try! ResponseData.init(data : data)
                    
                    Constant.showAlert(title: "", message: "Your request was sent and we aim to find it and reply asap.لقد تم ارسال طلبك و نسعى لايجاده و الرد في اسرع وقت ممكن", btnTitle: "Ok")
                }
            }
        }
    }
}
