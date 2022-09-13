//
//  OliCell.swift
//  XSWAR
//
//  Created by Jigar Kanani on 01/12/21.
//

import UIKit

class OliCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOlisQuantity: UILabel!
    @IBOutlet weak var lblOlisDes: UILabel!
    @IBOutlet weak var imgOlis: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
