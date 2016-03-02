//
//  CustomImage.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-02.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit

class CustomImage: UIImageView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 1.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }

}
