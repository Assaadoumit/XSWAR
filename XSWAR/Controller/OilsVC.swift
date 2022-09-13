//
//  OilsVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 01/12/21.
//

import UIKit

class OilsVC: UIViewController {

    @IBOutlet weak var btnAllSize: UIButton!
    @IBOutlet weak var btnAllGrade: UIButton!
    @IBOutlet weak var tblOlis: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblGrade: UITableView!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var btnAllType: UIButton!
    
    var arrOli : [[String:Any]] = []
    var arrGrade : [[String:Any]] = []
    var arrSize : [String] = []
    var arrType : [[String:Any]] = []
    var btnSelected : Int = 0
    var Selectedindex : Int = -1
    var selectedIndexSize : Int = -1
    var selectedIndexType : Int = -1
    var catId : String = ""
    var typeId : String = ""
    var selectedSize : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblOlis.register(UINib.init(nibName: "OliCell", bundle: nil), forCellReuseIdentifier: "OliCell")
        tblOlis.tableFooterView = UIView()
        
        tblGrade.register(UINib.init(nibName: "GradeCell", bundle: nil), forCellReuseIdentifier: "GradeCell")
        tblGrade.tableFooterView = UIView()

        getgrade()
        getolis()
        
        tblOlis.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.gradeView.isHidden = true
        self.view.endEditing(true)
       
    }
    
    //MARK:- Get grade
    func getgrade() {
        
        let apiURL = "\(BASE_URL)\(GET_OLICATEGORIES)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_GET, ServiceName: GET_OLICATEGORIES, bodyObject: [:], delegate: self, isShowProgress: true, isHideProgress: true)
        
    }
    
    //MARK:- Get Oil
    func getolis() {
        
        let apiURL = "\(BASE_URL)\(GET_OLIS)oil_category_id=\(catId)&size=\(selectedSize)&oil_type_id=\(typeId)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        WebParserWS.fetchDataWithURL(url: apiURL!, type: .TYPE_GET, ServiceName: GET_OLIS, bodyObject: [:], delegate: self, isShowProgress: true, isHideProgress: true)
        
    }
}

//MARK:- API Response
extension OilsVC: responseDelegate {
    
    func didFinishWithSuccess(ServiceName: String, Response: [String : Any]) {
        
        DispatchQueue.main.async {
            
            print(Response)
            
            if (Response["success"] as? String ?? "") == "1" || (Response["success"] as? Int ?? 0) == 1 {
                
                if ServiceName == GET_OLICATEGORIES {
                    
                    self.Selectedindex = -1
                    self.selectedIndexSize  = -1
                    self.selectedIndexType = -1
                    
                    let grade : [String:Any] = ["grade" : "All Grade",
                                                "oil_category_id" : ""]
                    
                    self.arrGrade = Response["grades"] as? [[String: Any]] ?? []
                    self.arrGrade.insert(grade, at: 0)
                                    
                    self.arrSize = Response["sizes"] as? [String] ?? []
                    self.arrSize.insert("All Size", at: 0)
                    
                    let types : [String:Any] = ["name" : "All Type",
                                                "oil_type_id" : ""]
                    
                    self.arrType = Response["types"] as? [[String: Any]] ?? []
                    self.arrType.insert(types, at: 0)
                                    
                    self.tblGrade.reloadData()
                    
                } else if ServiceName == GET_OLIS {
                    
                    self.arrOli = Response["data"] as? [[String: Any]] ?? []
                    self.tblOlis.reloadData()
                    
                }
                
            } else {
                
                if ServiceName == GET_OLICATEGORIES {
                    
                    self.arrGrade =  []
                    self.tblGrade.reloadData()
                    
                }else if ServiceName == GET_OLIS {
                    
                    self.arrOli =  []
                    self.tblOlis.reloadData()
                    
                }
            }
        }
    }
}

extension OilsVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblOlis {
            
            return arrOli.count
            
        } else {
            
            if btnSelected == 0 {
                
                return arrSize.count
                
            } else if btnSelected == 1  {
                
                return arrGrade.count
                
            } else {
                
                return arrType.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblOlis {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OliCell", for: indexPath) as! OliCell
            
            let cellObject = arrOli[indexPath.row]
            
            cell.lblPrice.text = "$ \(cellObject["price"] as? Int ?? 0) USD"
            cell.lblOlisDes.text = cellObject["name"] as? String ?? ""
            cell.lblOlisQuantity.text = "\(cellObject["size"] as? String ?? "")Ltr"
            
            cell.imgOlis.sd_setImage(with: URL.init(string: "\(BASE_PATH)\(cellObject["image"] as? String ?? "")"))
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeCell", for: indexPath) as! GradeCell
            
            if btnSelected  == 0 {
                
                cell.lblSize.text = arrSize[indexPath.row]
                
                if selectedIndexSize == indexPath.row {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                } else {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button-1"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                }
                
            } else if btnSelected == 1 {
                
                let cellObejct = arrGrade[indexPath.row]
                
                cell.lblSize.text = cellObejct["grade"] as? String ?? ""
                
                if Selectedindex == indexPath.row {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                } else {
                    
                    cell.btnSize.setImage(UIImage.init(named: "radio-on-button-1"), for: .normal)
                    cell.btnSize.tintColor = THEME_COLOR
                    
                }
                
            } else {
                
                let cellObejct = arrType[indexPath.row]
                
                cell.lblSize.text = cellObejct["name"] as? String ?? ""
                
                if Selectedindex == indexPath.row {
                    
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
        
        if tableView == tblOlis {
            
            return 100
            
        } else {
            
            if btnSelected == 0 {
                
                return 50
                
            } else {
                
                return 50
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblOlis {
            
            let orderVc = self.storyboard?.instantiateViewController(withIdentifier: "OrderVc") as! OrderVc
            orderVc.orderDic = arrOli[indexPath.row]
            orderVc.isFromOilOrder = true
            self.navigationController?.pushViewController(orderVc, animated: true)
            
        } else {
            
            if btnSelected == 0 {
                
                self.selectedIndexSize = indexPath.row
                self.tblGrade.reloadData()
                                
            } else if btnSelected == 1 {
                
                self.Selectedindex = indexPath.row
                self.tblGrade.reloadData()
                
            } else  {
                
                self.selectedIndexType = indexPath.row
                self.tblGrade.reloadData()
                
            }
        }
        
    }
    
    @objc func selectTapped(_ sender: UIButton) {
        
        if btnSelected == 0 {
            
            self.selectedIndexSize = sender.tag
            
            if sender.tag == 0 {
                
                selectedSize = ""
                btnAllSize.setTitle("All Size", for: .normal)
                
            } else {
                
                selectedSize = arrSize[sender.tag]
                btnAllSize.setTitle(selectedSize, for: .normal)
                
            }
            
            self.tblGrade.reloadData()
           
            
        } else  if btnSelected == 1 {
            
            self.Selectedindex = sender.tag
            
            let cellObejct = arrGrade[sender.tag]
            
            if sender.tag == 0  {
                
                catId = ""
                
            } else {
                
                catId = "\(cellObejct["oil_category_id"] as? Int ?? 0)"
            }
            
            btnAllGrade.setTitle(cellObejct["grade"] as? String ?? "", for: .normal)
            
            self.tblGrade.reloadData()
            
        } else  {
            
            self.selectedIndexType = sender.tag
            
            let cellObejct = arrType[sender.tag]
            
            if sender.tag == 0  {
                
                typeId = ""
                
            } else {
                
                typeId = "\(cellObejct["oil_type_id"] as? Int ?? 0)"
            }
            
            btnAllType.setTitle(cellObejct["name"] as? String ?? "", for: .normal)
            
            self.tblGrade.reloadData()
            
        }
        
        getolis()
        
        gradeView.isHidden = true
    }
}

//MARK:- Button Click
extension OilsVC {
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AllTypeTapped(_ sender: UIButton) {
        
        btnSelected = 2
        
        lblTitle.text = "TYPE"

        if gradeView.isHidden {
            
            gradeView.isHidden = false
            
        } else {
            
            gradeView.isHidden = true
            
        }
        
        tblGrade.reloadData()
           
    }
    
    @IBAction func AllGradeTapped(_ sender: UIButton) {
        
        btnSelected = 1
        
        lblTitle.text = "GRADE"

        if gradeView.isHidden {
            
            gradeView.isHidden = false
            
        } else {
            
            gradeView.isHidden = true
            
        }
        
        tblGrade.reloadData()
           
    }
    
    @IBAction func AllSizeTapped(_ sender: UIButton) {
        
        btnSelected = 0
        
        lblTitle.text = "SIZE(LITER)"
                
        if gradeView.isHidden {
            
            gradeView.isHidden = false
            
        } else {
            
            gradeView.isHidden = true
            
        }
        
        tblGrade.reloadData()

    }
}

