//
//  OrderItemTableViewCell.swift
//  Speech
//
//  Created by Henrik Engelbrink on 17.01.18.
//  Copyright © 2018 Google. All rights reserved.
//

import UIKit

class OrderItemTableViewCell: UITableViewCell {

    @IBOutlet weak var orderSizeLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setOrder(order:Any) {
        
    }

}
