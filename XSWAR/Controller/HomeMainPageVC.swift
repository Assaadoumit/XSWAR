//
//  HomeMainPageVC.swift
//  XSWAR
//
//  Created by Jigar Kanani on 24/11/21.
//

import UIKit

class HomeMainPageVC: UIViewController {

    @IBOutlet weak var mainPageCollection: UICollectionView!
    
    var arrMainPage : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageCollection.register(UINib.init(nibName: "MaincarCell", bundle: nil), forCellWithReuseIdentifier: "MaincarCell")
        
        arrMainPage = [["name": "New Parts" , "arName": "قطع جديدة"] ,
                       ["name": "Used Parts", "arName": "قطع مستعملة"],
                       ["name": "oil", "arName": "زيوت"],["name": "Tyres", "arName": "إطارات"]
                       ,["name": "Car Services", "arName": "خدمة السيارة"],["name": "Special Request", "arName": "طلب خاص"]]
        
    }
    
    @IBAction func btnProfileClick(_ sender : UIButton)
    {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(signUpVC, animated: true)
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
    
}

extension HomeMainPageVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaincarCell", for: indexPath) as! MaincarCell
    
        let cellObject = arrMainPage[indexPath.row]
         
        cell.lblName.text = cellObject["name"] as? String ?? ""
        cell.lblArebic.text = cellObject["arName"] as? String ?? ""
        
        cell.lblName.adjustsFontSizeToFitWidth = true
        cell.lblName.minimumScaleFactor = 0.5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize.init(width: (collectionView.frame.width / 2 ), height: (collectionView.frame.width / 2 ))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let dashBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
            dashBoardVC.pathDic = arrMainPage[indexPath.row]
            self.navigationController?.pushViewController(dashBoardVC, animated: true)
            
        } else if indexPath.row == 1 {
            
            let dashBoardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
            dashBoardVC.pathDic = arrMainPage[indexPath.row]
            self.navigationController?.pushViewController(dashBoardVC, animated: true)
            
        } else if indexPath.row == 2 {
            
            let oilsVC = self.storyboard?.instantiateViewController(withIdentifier: "OilsVC") as! OilsVC
            self.navigationController?.pushViewController(oilsVC, animated: true)
            
        } else if indexPath.row == 3 {
            
            let tiersVc = self.storyboard?.instantiateViewController(withIdentifier: "TiersVc") as! TiersVc
            self.navigationController?.pushViewController(tiersVc, animated: true)
            
        } else if indexPath.row == 4 {
            
            let carPartVC = self.storyboard?.instantiateViewController(withIdentifier: "CarPartVC") as! CarPartVC
            carPartVC.isFromSettings = true
            self.navigationController?.pushViewController(carPartVC, animated: true)
            
        } else if indexPath.row == 5 {
            
            let sendRequestVC = self.storyboard?.instantiateViewController(withIdentifier: "SendRequestVC") as! SendRequestVC
            sendRequestVC.isfromservice = true
            self.navigationController?.pushViewController(sendRequestVC, animated: true)
        }
    }
}

