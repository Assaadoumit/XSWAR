//
//  NewPartVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 05/02/21.
//

import UIKit

class NewPartVC: UIViewController {

    @IBOutlet var lblTop : UILabel!
    @IBOutlet var searchBar : UISearchBar!
    @IBOutlet var tblNewParts : UITableView!

    var partDic : PartsList!

    var delearList : [DealerList] = []
    var tempDelearList : [DealerList] = []

    var selectedBrand : Brand!
    var selectedmodels : MakingYear!
    var selectedmakingYears : MakingYear!
    var selectedCategory : CategoryList!
    var selectedService : ServiceCatList!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tblNewParts.tableFooterView = UIView()

        let backURL = "part_id=\(partDic.partID ?? 0)"

        let URL_API = BASE_URL.appending(API_GET_PART_DELEARS).appending(backURL)
        APIParser.dataWithURL(url: URL_API, requestType:.TYPE_GET, bodyObject: [:], imageObject: [], isShowProgress: true, isHideProgress: true) { (response, data) in
            
            print(response)
            
            let delearsData = try! DelearsData.init(data: data)
            
            if delearsData.success!
            {
                self.delearList = delearsData.data!
                self.tempDelearList = delearsData.data!

                self.tblNewParts.reloadData()
            }
            else
            {
                self.showAlertWithTitle(alertTitle: "", msg: delearsData.message ?? "")
            }
        }
    }
    
    @IBAction func btnBackClick(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewPartVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.tempDelearList.count
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
        
        let dic = tempDelearList[indexPath.row]
        
        cell.lblTitle.text = dic.dealer?.name
        cell.lblDescription.text = "$ \(dic.price!) USD"
        cell.imgIcon.sd_setImage(with: URL.init(string: BASE_PATH.appending(dic.image ?? "")))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewVC") as! DetailViewVC
        detailViewVC.delearDic = tempDelearList[indexPath.row]
        detailViewVC.selectedPart = partDic
        detailViewVC.selectedmodels = selectedmodels
        detailViewVC.selectedBrand = selectedBrand
        detailViewVC.selectedmakingYears = selectedmakingYears
        detailViewVC.selectedCategory = selectedCategory

        self.navigationController?.pushViewController(detailViewVC, animated: true)

    }
    
}


extension NewPartVC : UITextFieldDelegate, UISearchBarDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        if searchBar.text == ""
        {
            tempDelearList = delearList
            self.tblNewParts.reloadData()
        }
        else
        {
            self.tempDelearList = self.delearList.filter({($0.name?.contains(searchBar.text!))!}).map({$0})
            self.tblNewParts.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        tempDelearList = delearList
        self.tblNewParts.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""
        {
            tempDelearList = delearList
            self.tblNewParts.reloadData()
        }
        else
        {
            self.tempDelearList = self.delearList.filter({($0.name?.contains(searchText))!}).map({$0})
            self.tblNewParts.reloadData()
        }
    }
}
