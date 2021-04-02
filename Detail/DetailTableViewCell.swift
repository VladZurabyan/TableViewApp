//
//  DetailTableViewCell.swift
//  Table
//
//  Created by ADMIN on 02/01/2020.
//  Copyright © 2020 ADMIN. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
