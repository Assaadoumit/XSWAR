//
//  DashBoardVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit
import SDWebImage
import DropDown
import CoreLocation

class MyDDCell: DropDownCell {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var lblCode: UILabel!

    @IBOutlet weak var lblNumber: UILabel!

}

class CarCell : UICollectionViewCell
{
    @IBOutlet var imgCarIcon : UIImageView!
    @IBOutlet var lblDetails : UILabel!

    @IBOutlet var imgWidthConst : NSLayoutConstraint!

}

class DashBoardVC: UIViewController {

    @IBOutlet var collCars : UICollectionView!
    @IBOutlet var searchCar : UISearchBar!

    @IBOutlet var v1 : UIView!
    @IBOutlet var v2 : UIView!

    //POPUP VIEW
    @IBOutlet var viewPopUp : UIView!
    @IBOutlet var imgCarIcon : UIImageView!
    @IBOutlet var txtModelName : UITextField!
    @IBOutlet var txtModelManufacture : UITextField!
    @IBOutlet var segOldNew : UISegmentedControl!

    var brandList : [Brand] = []
    var tempBrandList : [Brand] = []

    var modelsList : [MakingYear] = []
    var makingYearsList : [MakingYear] = []
    var pathDic : [String:Any] = [:]

    var selectedBrand : Brand!
    var selectedmodels : MakingYear!
    var selectedmakingYears : MakingYear!
    let locationManager = CLLocationManager()
    var modelsDropDown = DropDown()
    var makingYearsDropDown = DropDown()
    var partType = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer!.delegate = nil

        partType = "Used"
        
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.red
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 16.0)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.white
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().setupCornerRadius(8)
        DropDown.startListeningToKeyboard()
        

        let URL_API = BASE_URL.appending(API_BRANDLIST)
        let task = URLSession.shared.brandListDataTask(with: URL.init(string: URL_API)!) { brandListData, response, error in
            if let brandListData = brandListData {
                
                DispatchQueue.main.async {
                    if brandListData.success!
                    {
                        self.brandList = brandListData.brands!
                        self.tempBrandList = brandListData.brands!
                        
                        self.collCars.reloadData()
                    }
                }
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startMonitoringVisits()
        self.locationManager.allowsBackgroundLocationUpdates = false
        self.locationManager.pausesLocationUpdatesAutomatically = true
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            
            self.locationManager.startUpdatingLocation()
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
                
        self.v1.cornerRadiuss = 8.0
        self.v1.clipsToBounds = true
        self.v1.addShadow(offset: CGSize.init(width: 2.0, height: 2.0), color: .darkGray, radius: 4.0, opacity: 0.4)
        
        self.v2.cornerRadiuss = 8.0
        self.v2.clipsToBounds = true
        self.v2.addShadow(offset: CGSize.init(width: 2.0, height: 2.0), color: .darkGray, radius: 4.0, opacity: 0.4)
    }
    
    
    @IBAction func btnProfileClick(_ sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func btnNotificationClick(_ sender : UIButton)
    {
        if appDelegate.userSignUpData == nil
        {
            let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            self.navigationController?.pushViewController(signUpVC, animated: true)
            
            signUpVC.completion  = { (data) -> Void in
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        else
        {
            let notificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
            notificationVC.isFromDashboard = true
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    
    @IBAction func btnSettingClick(_ sender : UIButton)
    {
        let carPartVC = self.storyboard?.instantiateViewController(withIdentifier: "CarPartVC") as! CarPartVC
        carPartVC.isFromSettings = true
        self.navigationController?.pushViewController(carPartVC, animated: true)
    }
}

//MARK:- CLLocationManagerDelegate
extension DashBoardVC : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        appDelegate.currentLocation = locValue
        
    }
}

extension DashBoardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return tempBrandList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarCell", for: indexPath) as! CarCell
    
        let dic = tempBrandList[indexPath.row]
        
        cell.imgCarIcon.sd_setImage(with: URL.init(string: BASE_PATH.appending(dic.image ?? "")))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: (collectionView.frame.width / 3) - 7.5 , height: (collectionView.frame.width / 3) - 7.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.txtModelName.text = "Model"
        self.txtModelManufacture.text = "Year Of Making"
        
        imgCarIcon.sd_setImage(with: URL.init(string: BASE_PATH.appending(tempBrandList[indexPath.row].image ?? "")))
        
        self.selectedBrand = tempBrandList[indexPath.row]
        self.view.endEditing(true)
        
        let URL_API = BASE_URL.appending("\(GET_MODEL_DETAILS)brand_id=\(self.selectedBrand.brandID!)")
        let task = URLSession.shared.brandListDataTask(with: URL.init(string: URL_API)!) { brandListData, response, error in
            if let brandListData = brandListData {
                
                DispatchQueue.main.async {
                    if brandListData.success!
                    {
                        
                        self.viewPopUp.isHidden = false
                        
                        self.modelsList =  brandListData.models!
                        self.makingYearsList = brandListData.makingYears!
                        self.collCars.reloadData()
                        
                    } else {
                        
                        self.showAlertWithTitle(alertTitle: "", msg: brandListData.message ?? "No Data Found!")
                        
                    }
                }
            }
        }
        task.resume()
    }
    
    @IBAction func btnCloseClick(_ sender : UIButton)
    {
        self.viewPopUp.isHidden = true
    }
    
    @IBAction func segmentIndexChange(_ sender : UISegmentedControl)
    {
        if sender.selectedSegmentIndex == 0
        {
            partType = "New"
        }
        else
        {
            partType = "Used"
        }
    }
    
    @IBAction func btnProceedClick(_ sender : UIButton)
    {
        if selectedmodels == nil || selectedBrand == nil || selectedmakingYears == nil
        {
            self.showAlertWithTitle(alertTitle: "", msg: "Please select all the details.")
            return
        }
        self.viewPopUp.isHidden = true

//        if segOldNew.selectedSegmentIndex == 0
//        {
//            let sendRequestVC = self.storyboard?.instantiateViewController(withIdentifier: "SendRequestVC") as! SendRequestVC
//            sendRequestVC.selectedmodels = selectedmodels
//            sendRequestVC.selectedBrand = selectedBrand
//            sendRequestVC.selectedmakingYears = selectedmakingYears
//            sendRequestVC.partType = self.partType
//            self.navigationController?.pushViewController(sendRequestVC, animated: true)
//        }
//        else
//        {
            let carPartVC = self.storyboard?.instantiateViewController(withIdentifier: "CarPartVC") as! CarPartVC
            carPartVC.selectedmodels = selectedmodels
            carPartVC.selectedBrand = selectedBrand
            carPartVC.selectedmakingYears = selectedmakingYears
            carPartVC.pathDic = pathDic
            
            self.navigationController?.pushViewController(carPartVC, animated: true)
        }
//    }
}

extension DashBoardVC : UITextFieldDelegate, UISearchBarDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.txtModelName
        {
            textField.resignFirstResponder()
            let y = ((txtModelName.superview?.frame.origin.y)! + (txtModelName.superview?.superview?.superview!.frame.origin.y)! )

            modelsDropDown.direction = .bottom
            modelsDropDown.bottomOffset = CGPoint(x: 56, y: y + 60)
            modelsDropDown.width = SCREEN_WIDTH - 112
            modelsDropDown.anchorView = view
            modelsDropDown.dataSource = self.modelsList.filter({$0.name != nil}).map({$0.name!})
            modelsDropDown.cellNib = UINib(nibName: "MyDDCell", bundle: nil)
            modelsDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
               guard let cell = cell as? MyDDCell else { return }
                
                let object = self.modelsList[index]
                cell.lblNumber.text = object.name
            }
            modelsDropDown.dismissMode = .onTap
            modelsDropDown.show()
            modelsDropDown.selectionAction = { [weak self] (index, item) in
                
                let object = self!.modelsList[index]
                
                self!.selectedmodels = self!.modelsList[index]

                self!.txtModelName.text = object.name
            }
        }
        else
        {
            textField.resignFirstResponder()
            
            let y = ((txtModelManufacture.superview?.frame.origin.y)! + (txtModelManufacture.superview?.superview?.superview!.frame.origin.y)! )
            makingYearsDropDown.direction = .bottom
            makingYearsDropDown.bottomOffset = CGPoint(x: 56, y: y + 60)
            makingYearsDropDown.width = SCREEN_WIDTH - 112
            makingYearsDropDown.anchorView = view
            makingYearsDropDown.dataSource = self.makingYearsList.filter({$0.name != nil}).map({$0.name!})
            makingYearsDropDown.cellNib = UINib(nibName: "MyDDCell", bundle: nil)
            makingYearsDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
               guard let cell = cell as? MyDDCell else { return }
                
                let object = self.makingYearsList[index]
                cell.lblNumber.text = object.name
            }
            makingYearsDropDown.dismissMode = .onTap
            makingYearsDropDown.show()
            makingYearsDropDown.selectionAction = { [weak self] (index, item) in
                let object = self!.makingYearsList[index]
                self!.selectedmakingYears = self!.makingYearsList[index]
                self!.txtModelManufacture.text = object.name
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text == ""
        {
            tempBrandList = brandList
            self.collCars.reloadData()
        }
        else
        {
            self.tempBrandList = self.brandList.filter({($0.name?.contains(searchBar.text!))!}).map({$0})
            self.collCars.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        tempBrandList = brandList
        self.collCars.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""
        {
            tempBrandList = brandList
            self.collCars.reloadData()
        }
        else
        {
            self.tempBrandList = self.brandList.filter({($0.name?.contains(searchText))!}).map({$0})
            self.collCars.reloadData()
        }
    }
}
