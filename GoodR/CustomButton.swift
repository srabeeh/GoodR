//
//  CustomButton.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-02-26.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: 180, green: 25, blue: 25, alpha: 0.5).CGColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 15.0
        layer.shadowOffset = CGSizeMake(0.0, 5.0)
    }
}
