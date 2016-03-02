//
//  GoodieCell.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-01.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit
import Alamofire

class GoodieCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var goodieImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    
    var post: Post!
    var request: Request?
 
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
    
    func configureCell(post: Post, img: UIImage?){
        self.post = post
        self.likesLabel.text = "\(post.likes)"
        self.descriptionText.text = "\(post.postDescription)"
        
        if post.imageUrl != nil {
            if img != nil {
                self.goodieImage.image = img
            } else {
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
                    
                    if err == nil {
                        // To Do: error handle the let below
                        let img = UIImage(data: data!)!
                        self.goodieImage.image = img
                        GoodiesFeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                        
                    }
                })
            }
        } else {
            self.goodieImage.hidden = true
        }
    }

}
