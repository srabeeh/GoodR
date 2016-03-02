//
//  GoodieCell.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-01.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class GoodieCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var goodieImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef = Firebase()
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Note: will call "LikedTapped" function
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.userInteractionEnabled = true
        
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
        likeRef = DataService.dataService.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
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
        
        // *** Firebase -> If there is no data in .Value the response is NSNull
        // do not try any other null type
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let likeDoesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "Heart-1")
            } else {
                self.likeImage.image = UIImage(named: "HeartFull-1")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer){
        likeRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let doesNotExist = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "HeartFull-1")
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "Heart-1")
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
        })
    }
}

