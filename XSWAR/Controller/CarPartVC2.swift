//
//  CarPartVC2.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class CarParts : UITableViewCell
{
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblDescription : UILabel!
    @IBOutlet var lblDescriptionARB : UILabel!

    @IBOutlet var imgIcon : UIImageView!

}

class CarPartVC2: UIViewController {

    @IBOutlet var tblParts : UITableView!
    @IBOutlet var searchCar : UISearchBar!
    @IBOutlet var mainMapVIew : UIView!
    @IBOutlet var lblTitle : UILabel!
    
    var selectedBrand : Brand!
    var selectedmodels : MakingYear!
    var selectedmakingYears : MakingYear!
    var selectedCategory : CategoryList!
    var partsList : [PartsList] = []
    var tempPartsList : [PartsList] = []
    let locationManager = CLLocationManager()
    var partType = String()
    var isFromSettings = Bool()
    var selectedService : ServiceCatList!
    var selectedLocation : Area!
    var garrageList : [GarrageList] = []
    var tempGarrageList : [GarrageList] = []
    var mapView = GMSMapView()
    var currentMarkerIndex: Int = -1
    var lastMarkerIndex: Int = -1
    var pathDic : [String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        tblParts.tableFooterView = UIView()
                
        if isFromSettings
        {
            
            lblTitle.text = "Services"
            
            self.mainMapVIew.isHidden = false
            
            let backURL = "service_category_id=\(self.selectedService.serviceCategoryID ?? 0)&longitude=\(appDelegate.currentLocation.longitude)&latitude=\(appDelegate.currentLocation.latitude)"
            
            let URL_API = BASE_URL.appending(API_GET_GARRAGES_LIST).appending(backURL)
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_GET, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: false) { (response, data) in
                
                let garrageData = try! GarrageData.init(data: data)
                
                if garrageData.success!
                {
                    self.garrageList = garrageData.data!
                    self.tempGarrageList = garrageData.data!

                    self.mapView.clear()
                    
                    for i in 0..<self.garrageList.count {
                        
                        let dic = self.garrageList[i]
                                                
                        let currentPIN = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dic.latitude ?? "0") ?? 0.0, longitude: Double(dic.longitude ?? "0") ?? 0.0))
                        currentPIN.icon = UIImage.init(named: "ic_car")
                        currentPIN.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
                        currentPIN.userData = dic
                        currentPIN.map = self.mapView
                        
                    }
                    
                    self.mainMapVIew.isHidden = false
//                    self.tblParts.reloadData()
                }
                else
                {
                    self.showAlertWithTitle(alertTitle: "", msg: garrageData.message ?? "")
                    ProcessLoader.hide()
                    
                }
            }
        }
        else
        {
            let backURL = "brand_id=\(selectedBrand.brandID ?? 0)&model=\(selectedmodels.name ?? "0")&making_year=\(selectedmakingYears.name ?? "0")&category_id=\(selectedCategory.categoryID ?? 0)&part_type=\((pathDic["name"] as? String ?? "").replacingOccurrences(of: "Parts", with: ""))"
            
            let URL_API = BASE_URL.appending(API_GET_PARTS).appending(backURL)
            APIParser.dataWithURL(url: URL_API, requestType:.TYPE_GET, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
                
                let partsData = try! PartsData.init(data: data)
                
                if partsData.success!
                {
                    self.partsList = partsData.data!
                    self.tempPartsList = partsData.data!

                    self.tblParts.reloadData()
                    self.mainMapVIew.isHidden = true
                }
                else
                {
                    self.showAlertWithTitle(alertTitle: "", msg: partsData.message ?? "")
                }
            }
        }
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
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CarPartVC2 : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isFromSettings
        {
            return self.tempGarrageList.count
        }
        else
        {
            return self.tempPartsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarParts", for: indexPath) as! CarParts
        
//        cell.layer.shadowOffset = CGSize.init(width: 3.0, height: 3.0)
//        cell.layer.shadowColor = UIColor.lightGray.cgColor
//        cell.layer.shadowRadius = 3.0
//        cell.layer.shadowOpacity = 0.6
//        cell.clipsToBounds = false
//        cell.layer.zPosition = 10
        
        if isFromSettings
        {
            let dic = tempGarrageList[indexPath.row]
            
            cell.lblTitle.text = dic.name
            cell.lblDescription.text = dic.phoneNumber ?? ""
            cell.lblDescriptionARB.textAlignment = .left
            cell.lblDescriptionARB.text = dic.services ?? ""
        }
        else
        {
            let dic = tempPartsList[indexPath.row]
            
            cell.lblTitle.text = dic.name
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromSettings
        {
            let dic = tempGarrageList[indexPath.row]
            TEZFunc().callToNumberPrompt(phone: dic.phoneNumber ?? "")
        }
        else
        {
            let newPartVC = self.storyboard?.instantiateViewController(withIdentifier: "NewPartVC") as! NewPartVC
            newPartVC.partDic = tempPartsList[indexPath.row]
            newPartVC.selectedmodels = selectedmodels
            newPartVC.selectedBrand = selectedBrand
            newPartVC.selectedmakingYears = selectedmakingYears
            newPartVC.selectedCategory = selectedCategory
            self.navigationController?.pushViewController(newPartVC, animated: true)
        }
    }
    
}

//MARK:- CLLocationManagerDelegate, GMSMapViewDelegate
extension CarPartVC2 : CLLocationManagerDelegate, GMSMapViewDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.mapView.clear()
        
        appDelegate.currentLocation = locValue
        self.setUpCameraAndMap()
        
    }
    
    func setUpCameraAndMap() {
        
        GMSPlacesClient().currentPlace(callback: { (placeLikelihoods, error) -> Void in
            
            if error != nil {
                
            }
            
            if let placeLikelihood = placeLikelihoods?.likelihoods.first {
                                
                let camera = GMSCameraPosition.camera(withLatitude: appDelegate.currentLocation.latitude, longitude: appDelegate.currentLocation.longitude, zoom: 17.0)
                self.mapView = GMSMapView.map(withFrame: self.mainMapVIew.bounds, camera: camera)
                self.mapView.clipsToBounds = true
                self.mapView.delegate = self
                self.mapView.mapType = .terrain
                self.mapView.tintColor = .red
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.mainMapVIew.addSubview(self.mapView)
                
                self.locationManager.stopUpdatingLocation()
                self.locationManager.delegate = nil
                
                
                for i in 0..<self.garrageList.count {
                    
                    let dic = self.garrageList[i]
                    
                    let currentPIN = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dic.latitude ?? "0") ?? 0.0, longitude: Double(dic.longitude ?? "0") ?? 0.0))
                    currentPIN.icon = UIImage.init(named: "ic_car")
                    currentPIN.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
                    currentPIN.userData = dic
                    currentPIN.map = self.mapView
                    self.mapView.selectedMarker = currentPIN
                }
            }
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
                
        self.mapView.clear()
        
        let index = self.garrageList.indexOfObject(object: marker.userData as! GarrageList)
        
        for i in 0..<self.garrageList.count {
            
            let dic = self.garrageList[i]
            
            let currentPIN = GMSMarker(position: CLLocationCoordinate2D(latitude: Double(dic.latitude ?? "0") ?? 0.0, longitude: Double(dic.longitude ?? "0") ?? 0.0))
            currentPIN.icon = UIImage.init(named: "ic_car")
            currentPIN.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
            currentPIN.userData = dic
            currentPIN.map = self.mapView
            
            if index == i {
                
                currentPIN.title = (marker.userData as! GarrageList).name ?? ""
                if currentMarkerIndex != -1 {
                    
                    self.lastMarkerIndex = self.currentMarkerIndex
                    
                }
                
                self.currentMarkerIndex = index
                                
                self.mapView.selectedMarker = currentPIN
                
            }
        }
        
        if lastMarkerIndex == currentMarkerIndex {
            
            currentMarkerIndex = -1
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                
                UIApplication.shared.openURL(NSURL(string:
                                                    "comgooglemaps://?saddr=&daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")! as URL)
                
            } else {
                
                self.showAlertWithTitle(alertTitle: "", msg: "Can't use com.google.maps://")
                
            }
        }
        
        return true
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        
        ProcessLoader.hide()
        
    }
}

extension CarPartVC2 : UITextFieldDelegate, UISearchBarDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text == ""
        {
            if isFromSettings
            {
                tempGarrageList = garrageList
            }
            else
            {
                tempPartsList = partsList
            }
            self.tblParts.reloadData()
        }
        else
        {
            if isFromSettings
            {
                tempGarrageList = self.garrageList.filter({($0.name?.contains(searchBar.text!))! || ($0.services?.contains(searchBar.text!))! || ($0.phoneNumber?.contains(searchBar.text!))!}).map({$0})
            }
            else
            {
                tempPartsList = self.partsList.filter({($0.name?.contains(searchBar.text!))!}).map({$0})
            }
            self.tblParts.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        if isFromSettings
        {
            tempGarrageList = garrageList
        }
        else
        {
            tempPartsList = partsList
        }
        self.tblParts.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""
        {
            if isFromSettings
            {
                tempGarrageList = garrageList
            }
            else
            {
                tempPartsList = partsList
            }
            self.tblParts.reloadData()
        }
        else
        {
            if isFromSettings
            {
                tempGarrageList = self.garrageList.filter({($0.name?.contains(searchBar.text!))! || ($0.services?.contains(searchBar.text!))! || ($0.phoneNumber?.contains(searchBar.text!))!}).map({$0})
            }
            else
            {
                tempPartsList = self.partsList.filter({($0.name?.contains(searchBar.text!))!}).map({$0})
            }
            self.tblParts.reloadData()
        }
    }
}

