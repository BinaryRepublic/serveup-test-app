//
//  ResultTableViewCell.swift
//  Speech
//
//  Created by Henrik Engelbrink on 13.01.18.
//  Copyright © 2018 Google. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    @IBOutlet weak var speechTextLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setData(confidence:Float, text:String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.speechTextLabel.attributedText = attrString
        
        let formattedConfidence = String(format:"%.2f",confidence * 100)
        self.confidenceLabel.text = "\(formattedConfidence) %"
        if(confidence >= 0.85) {
            self.confidenceLabel.textColor = UIColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0)
        }
        else if(confidence < 0.85 && confidence > 0.5) {
            self.confidenceLabel.textColor = UIColor(red: 249.0/255.0, green: 191.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        }
        else {
            self.confidenceLabel.textColor = UIColor(red: 240.0/255.0, green: 52.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        }
    }

}
