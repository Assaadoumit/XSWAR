//
//  CarPartVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit
import DropDown

class CarPartVC: UIViewController {

    @IBOutlet var collCarsPart : UICollectionView!
    
    @IBOutlet var lblTopName : UILabel!
    @IBOutlet var v1 : UIView!

    var catList : [CategoryList] = []
    var serviceCatList : [ServiceCatList] = []
    var locationList : [Area] = []
    var pathDic : [String:Any] = [:]
    var catId : Int = 0

    var selectedService : ServiceCatList!
    var selectedLocation : Area!

    var selectedBrand : Brand!
    var selectedmodels : MakingYear!
    var selectedmakingYears : MakingYear!
    var partType = String()
    
    //POPUP VIEW
    @IBOutlet var viewPopUp : UIView!
    @IBOutlet var txtLocationName : UITextField!
    
    var isFromSettings = Bool()
    var locationDropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        if isFromSettings
        {
            lblTopName.text = "SERVICES"
            
            DropDown.appearance().textColor = UIColor.black
            DropDown.appearance().selectedTextColor = UIColor.red
            DropDown.appearance().textFont = UIFont.systemFont(ofSize: 16.0)
            DropDown.appearance().backgroundColor = UIColor.white
            DropDown.appearance().selectionBackgroundColor = UIColor.white
            DropDown.appearance().cellHeight = 40
            DropDown.appearance().setupCornerRadius(8)
            DropDown.startListeningToKeyboard()
            
            let URL_API = BASE_URL.appending(API_SERVICE_CATEGORY)
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_GET, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                
                let categoryData = try! ServiceCategoryData.init(data: data)
                
                if categoryData.success!
                {
                    self.serviceCatList = categoryData.data!
                    self.locationList = categoryData.areas!
                    self.collCarsPart.reloadData()
                }
                else
                {
                    self.showAlertWithTitle(alertTitle: "", msg: categoryData.message ?? "")
                }
            }
        }
        else
        {
            let URL_API = BASE_URL.appending(API_CATEGORY)
            APIParser.dataWithURL(url: "\(URL_API)?part_type=\((pathDic["name"] as? String ?? "").replacingOccurrences(of: "Parts", with: ""))", requestType:.TYPE_GET, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                
                let categoryData = try! CategoryListData.init(data: data)
                
                if categoryData.success!
                {
                    self.catList = categoryData.data!
                    self.collCarsPart.reloadData()
                }
                else
                {
                    self.showAlertWithTitle(alertTitle: "", msg: categoryData.message ?? "")
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
                        
        self.v1.cornerRadiuss = 8.0
        self.v1.clipsToBounds = true
        self.v1.addShadow(offset: CGSize.init(width: 2.0, height: 2.0), color: .darkGray, radius: 4.0, opacity: 0.4)
    }
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnProceedClick(_ sender: UIButton)
    {
        self.viewPopUp.isHidden = true
        
        let carPartVC = self.storyboard?.instantiateViewController(withIdentifier: "CarPartVC2") as! CarPartVC2
        carPartVC.isFromSettings = true
        carPartVC.selectedService = selectedService
        carPartVC.selectedLocation = selectedLocation
        self.navigationController?.pushViewController(carPartVC, animated: true)
    }
}


extension CarPartVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if isFromSettings
        {
            return self.serviceCatList.count
        }
        else
        {
            return self.catList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarCell", for: indexPath) as! CarCell
        
        if isFromSettings
        {
            let dic = self.serviceCatList[indexPath.row]
            
            cell.imgCarIcon.sd_setImage(with: URL.init(string: BASE_PATH.appending(dic.image ?? "").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!), placeholderImage: UIImage.init(named: "Logo"))
            cell.imgWidthConst.constant = (collectionView.frame.width / 3) - 7.5
            cell.lblDetails.text = String.init(format: "%@\n%@", dic.name ?? "", dic.nameAr ?? "")
        }
        else
        {
            let dic = self.catList[indexPath.row]
            
            cell.imgCarIcon.sd_setImage(with: URL.init(string: BASE_PATH.appending(dic.image ?? "").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!), placeholderImage: UIImage.init(named: "Logo"))
            
            cell.imgWidthConst.constant = (collectionView.frame.width / 3) - 7.5
            
            cell.lblDetails.text = String.init(format: "%@\n%@", dic.name ?? "", dic.nameAr ?? "")
 
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: (collectionView.frame.width / 3) - 7.5 , height: (collectionView.frame.width / 3) + 62)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.isFromSettings
        {
            self.selectedService = serviceCatList[indexPath.row]
            self.view.endEditing(true)
            //            self.viewPopUp.isHidden = false
            
            self.viewPopUp.isHidden = true
            
            let carPartVC = self.storyboard?.instantiateViewController(withIdentifier: "CarPartVC2") as! CarPartVC2
            carPartVC.isFromSettings = true
            carPartVC.selectedService = selectedService
            carPartVC.selectedLocation = selectedLocation
            self.navigationController?.pushViewController(carPartVC, animated: true)
            
        }
        else
        {
            let dic = self.catList[indexPath.row]
            catId = Int(dic.categoryID ?? 0)
            
            if  "\((pathDic["name"] as? String ?? "").replacingOccurrences(of: "Parts", with: "").replacingOccurrences(of: " ", with: ""))" == "New" {
                
                let carPartVC2 = self.storyboard?.instantiateViewController(withIdentifier: "CarPartVC2") as! CarPartVC2
                carPartVC2.selectedmodels = selectedmodels
                carPartVC2.selectedBrand = selectedBrand
                carPartVC2.selectedmakingYears = selectedmakingYears
                carPartVC2.selectedCategory = self.catList[indexPath.row]
                carPartVC2.pathDic = self.pathDic
                self.navigationController?.pushViewController(carPartVC2, animated: true)
                
            } else {
                
                let sendRequestVC = self.storyboard?.instantiateViewController(withIdentifier: "SendRequestVC") as! SendRequestVC
                sendRequestVC.selectedmodels = selectedmodels
                sendRequestVC.selectedBrand = selectedBrand
                sendRequestVC.selectedmakingYears = selectedmakingYears
                sendRequestVC.selectedCategory = self.catList[indexPath.row]
                sendRequestVC.pathDic = self.pathDic
                sendRequestVC.isfromservice = false
                sendRequestVC.catID = catId                
                self.navigationController?.pushViewController(sendRequestVC, animated: true)
                
            }
            
        }
    }
    
    @IBAction func btnCloseClick(_ sender : UIButton)
    {
        self.viewPopUp.isHidden = true
    }
}


extension CarPartVC : UITextFieldDelegate, UISearchBarDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtLocationName
        {
            textField.resignFirstResponder()
            let y = ((txtLocationName.superview?.frame.origin.y)! + (txtLocationName.superview?.superview?.superview!.frame.origin.y)! )

            locationDropDown.direction = .bottom
            locationDropDown.bottomOffset = CGPoint(x: 56, y: y + 60)
            locationDropDown.width = SCREEN_WIDTH - 112
            locationDropDown.anchorView = view
            locationDropDown.dataSource = self.locationList.filter({$0.area != nil}).map({$0.area!})
            
            locationDropDown.cellNib = UINib(nibName: "MyDDCell", bundle: nil)
            
            locationDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
               guard let cell = cell as? MyDDCell else { return }
                
                let object = self.locationList[index]
                cell.lblNumber.text = object.area
            }
            locationDropDown.dismissMode = .onTap
            locationDropDown.show()
            locationDropDown.selectionAction = { [weak self] (index, item) in

                let object = self!.locationList[index]

                self!.selectedLocation = self!.locationList[index]

                self!.txtLocationName.text = object.area
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
