//
//  GradeCell.swift
//  XSWAR
//
//  Created by Jigar Kanani on 01/12/21.
//

import UIKit

class GradeCell: UITableViewCell {

    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var btnSize: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
