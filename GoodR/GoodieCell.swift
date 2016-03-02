//
//  GoodieCell.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-01.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit

class GoodieCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var goodieImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func drawRect(rect: CGRect) {
        // Get a complete circle
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        goodieImage.clipsToBounds = true
    }
    
    func configureCell(post: Post){
        self.post = post
        self.likesLabel.text = "\(post.likes)"
        self.descriptionText.text = "\(post.postDescription)"
        
        
    }

}
