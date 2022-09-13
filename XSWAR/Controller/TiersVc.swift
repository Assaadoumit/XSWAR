//
//  TiersVc.swift
//  XSWAR
//
//  Created by Jigar Kanani on 01/12/21.
//

import UIKit

class TiersVc: UIViewController {

    @IBOutlet weak var btnWidth: UIButton!
    @IBOutlet weak var btnDaimeters: UIButton!
    @IBOutlet weak var btnRatio: UIButton!
    @IBOutlet weak var tblTiers: UITableView!
    @IBOutlet weak var tblStatus: UITableView!
    @IBOutlet weak var StatusView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    var arrTiers : [[String:Any]] = []
    var arrwidth : [String] = []
    var arrRatio : [String] = []
    var arrDaiGrame : [String] = []
    var btnSelected : Int = 0
    var SelectediRatio : Int = -1
    var SelectediWidth : Int = -1
    var SelectediDaiGrame : Int = -1
    var storeWidth : String = ""
    var storeRatio : String = ""
    var storeDaigrame : String = ""
    var catId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblTiers.register(UINib.init(nibName: "OliCell", bundle: nil), forCellReuseIdentifier: "OliCell")
        tblTiers.tableFooterView = UIView()
        
        tblStatus.register(UINib.init(nibName: "GradeCell", bundle: nil), forCellReuseIdentifier: "GradeCell")
        tblStatus.tableFooterView = UIView()
        
        getTiers()
        getTireCat()
        
        tblTiers.reloadData()

    }
    
    //MARK:- Get Oil
    func getTiers() {
                    
            let apiURL = "\(BASE_URL)\(GET_TIRE)width=\(storeWidth)&ratio=\(storeRatio)&diameter=\(storeDaigrame)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_GET, ServiceName: GET_TIRE, bodyObject: [:], delegate: self, isShowProgress: true, isHideProgress: true)
       
    }
    
    //MARK:- Get grade
    func getTireCat() {
                    
            let apiURL = "\(BASE_URL)\(TIRE_CATAGORY)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_GET, ServiceName: TIRE_CATAGORY, bodyObject: [:], delegate: self, isShowProgress: true, isHideProgress: true)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.StatusView.isHidden = true
        self.view.endEditing(true)
       
    }
}

//MARK:- API Response
extension TiersVc: responseDelegate {
    
    func didFinishWithSuccess(ServiceName: String, Response: [String : Any]) {
        
        DispatchQueue.main.async {
            
            print(Response)
            
            if (Response["success"] as? String ?? "") == "1" || (Response["success"] as? Int ?? 0) == 1 {
                
                if ServiceName == GET_TIRE {
                    
                    self.arrTiers = Response["data"] as? [[String: Any]] ?? []
                    self.tblTiers.reloadData()
                    
                } else if ServiceName == TIRE_CATAGORY {
                    
                    self.SelectediRatio  = -1
                    self.SelectediWidth  = -1
                    self.SelectediDaiGrame = -1
                    
                    self.arrwidth = Response["widths"] as? [String] ?? []
                    self.arrRatio = Response["ratios"] as? [String] ?? []
                    self.arrDaiGrame = Response["diameters"] as? [String] ?? []
                    
                    self.tblStatus.reloadData()
                    
                }
                
            } else {
                
                if ServiceName == GET_TIRE {
                    
                    self.arrTiers =  []
                    self.tblTiers.reloadData()
                    
                } else if ServiceName == TIRE_CATAGORY {
                    
                    self.arrwidth =  []
                    self.arrRatio =  []
                    self.arrDaiGrame =  []
                    
                    self.tblStatus.reloadData()
                    
                }
            }
        }
    }
}

extension TiersVc : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblTiers {
            
            return arrTiers.count
            
        } else {
            
            if btnSelected == 0 {
                
                return arrwidth.count
                
            } else if btnSelected == 1 {
                
                return arrRatio.count

            } else {
                
                return arrDaiGrame.count
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblTiers {
            
            let cell = tblTiers.dequeueReusableCell(withIdentifier: "OliCell", for: indexPath) as! OliCell
            
            let cellObject = arrTiers[indexPath.row]
            
            cell.lblPrice.text = "$ \(cellObject["price"] as? Int ?? 0) USD"
            cell.lblOlisDes.text = cellObject["description"] as? String ?? ""
            cell.lblOlisQuantity.text = "\(cellObject["width"] as? String ?? "")/\(cellObject["ratio"] as? String ?? "")R \(cellObject["diameter"] as? String ?? "")"
            
            cell.imgOlis.sd_setImage(with: URL.init(string: "\(BASE_PATH)\(cellObject["image"] as? String ?? "")"))
            
            return cell
            
        } else {
            
            let cell = tblStatus.dequeueReusableCell(withIdentifier: "GradeCell", for: indexPath) as! GradeCell
            
            if btnSelected  == 0 {
                
                cell.lblSize.text = arrwidth[indexPath.row]
                
                if SelectediWidth == indexPath.row {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                } else {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button-1"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                }
                
            } else if btnSelected == 1 {
                
                cell.lblSize.text = arrRatio[indexPath.row]
                
                if SelectediRatio == indexPath.row {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                } else {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button-1"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                }
                
            } else {
                
                cell.lblSize.text = arrDaiGrame[indexPath.row]
                
                if SelectediDaiGrame == indexPath.row {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                } else {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button-1"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                }
                
            }
            
            cell.btnSize.tag = indexPath.item
            cell.btnSize.addTarget(self, action: #selector(self.selectTapped(_:)), for: .touchUpInside)
            
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == tblTiers {
            
            return 100
            
        } else {
            
            if btnSelected == 0 {
                
                return 50
                
            } else if btnSelected == 1 {
                
                return 50
                
            } else {
                
                return 50
            }
            
        }
        
    }
        
    @objc func selectTapped(_ sender: UIButton) {
        
        if btnSelected == 0 {
            
            self.SelectediWidth = sender.tag
            
            storeWidth = arrwidth[sender.tag]
            
            btnWidth.setTitle(storeWidth, for: .normal)
            
            self.tblStatus.reloadData()
            
        } else if btnSelected == 1 {
            
            self.SelectediRatio = sender.tag
            
            storeRatio = arrRatio[sender.tag]
            
            btnRatio.setTitle(storeRatio, for: .normal)
            
            self.tblStatus.reloadData()
            
        } else {
            
            self.SelectediDaiGrame = sender.tag
            
            storeDaigrame = arrDaiGrame[sender.tag]
            
            btnDaimeters.setTitle(storeDaigrame, for: .normal)
            
            self.tblStatus.reloadData()
        }
        
        getTiers()
        
        StatusView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblTiers {
            
            let orderVc = self.storyboard?.instantiateViewController(withIdentifier: "OrderVc") as! OrderVc
            orderVc.orderDic = arrTiers[indexPath.row]
            orderVc.isFromTire = true 
            self.navigationController?.pushViewController(orderVc, animated: true)
            
        } else {
            
            if btnSelected == 0 {
                
                self.SelectediWidth = indexPath.row
                self.tblStatus.reloadData()
                
            } else if btnSelected == 1 {
                
                self.SelectediRatio = indexPath.row
                self.tblStatus.reloadData()
                
            } else {
                
                self.SelectediDaiGrame = indexPath.row
                self.tblStatus.reloadData()
                
            }
        }
        
    }
    
    
}

//MARK:- Button Click
extension TiersVc {
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func allWidthTapped(_ sender: UIButton) {
        
        btnSelected = 0
        
        lblStatus.text = "WIDTH"

        if StatusView.isHidden {
            
            StatusView.isHidden = false
            
        } else {
            
            StatusView.isHidden = true
            
        }
        
        tblStatus.reloadData()
           
    }
    
    @IBAction func allRatioTapped(_ sender: UIButton) {
        
        btnSelected = 1

        lblStatus.text = "RATIO"

        if StatusView.isHidden {
            
            StatusView.isHidden = false
            
        } else {
            
            StatusView.isHidden = true
            
        }
        
        tblStatus.reloadData()

    }
    
    @IBAction func allDaimeterTapped(_ sender: UIButton) {
        
        btnSelected = 2
        
        lblStatus.text = "DIAMETERS"

        if StatusView.isHidden {
            
            StatusView.isHidden = false
            
        } else {
            
            StatusView.isHidden = true
            
        }
        
        tblStatus.reloadData()
    }
}


