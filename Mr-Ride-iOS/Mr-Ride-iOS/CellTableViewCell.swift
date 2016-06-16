//
//  CellTableViewCell.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/25/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var dot: UIView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dot.layer.cornerRadius = dot.frame.size.width / 2
        dot.clipsToBounds = true
        dot.hidden = true
        
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.mrTextStyle7Font(24)
        label.textColor = UIColor.mrWhite50Color()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            dot.hidden = false
            label.textColor = UIColor.whiteColor()
        } else {
            dot.hidden = true
            label.textColor = UIColor.mrWhite50Color()
        }
    }

}
