//
//  GoodiesFeedVC.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-01.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

// https://code.google.com/archive/p/imageshackapi/wikis/ImageshackAPI.wiki

class GoodiesFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postDescField: CustomTextField!
    @IBOutlet weak var selectUploadImage: CustomImage!
    
    var imageSelected = false
    var posts = [Post]()
    
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 390
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.dataService.REF_FIREBASE_POSTS.queryOrderedByChild("timestamp").observeEventType(.Value, withBlock: {snapshot in
    
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot]{
                self.posts = []
                for snap in snapshots {
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let goodie = Post(postKey: key, dictionary: postDictionary)
                        self.posts.append(goodie)
                    }
                }
            }
            self.tableView.reloadData()
        })
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    // To Do: data validation to ensure we don't return a nil as we're using expecting with !
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print(post.postDescription)
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("GoodieCell") as? GoodieCell {
            
            // If a cell is off screen because a new one came in to make this call..
            cell.request?.cancel()
            
            var img: UIImage?
            
            if let url = post.imageUrl {
              img = GoodiesFeedVC.imageCache.objectForKey(url) as? UIImage
            }
            
            cell.configureCell(post, img: img)
            return cell
            
        } else {
            return GoodieCell()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let post = posts[indexPath.row]
        if post.imageUrl == nil {
            return 180
        }
        else{
            return tableView.estimatedRowHeight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        selectUploadImage.image = image
        imageSelected = true
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil )
    }
    
    @IBAction func makePost(sender: AnyObject) {
        if let descriptionText = postDescField.text where descriptionText != "" {
            if let img = selectUploadImage.image where imageSelected == true {
                let urlStr = "https://post.imageshack.us/upload_api.php"
                let url = NSURL(string: urlStr)!
                let imgData = UIImageJPEGRepresentation(img, 0.2)!
                let keyData = "138MOPUY666f44f167c26bb5ce3d2800cb0b25bf".dataUsingEncoding(NSUTF8StringEncoding)
                let keyJson = "json".dataUsingEncoding(NSUTF8StringEncoding)
                
                Alamofire.upload(.POST, url, multipartFormData: {multipartFormData in
                    
                    multipartFormData.appendBodyPart(data: imgData, name: "fileupload", fileName: "image", mimeType: "image/jpeg")
                    multipartFormData.appendBodyPart(data: keyData!, name: "key")
                    multipartFormData.appendBodyPart(data: keyJson!, name: "format")
                    
                    }) {encodingResult in
                        
                        switch encodingResult {
                        case .Success(let upload, _, _):
                           upload.responseJSON(completionHandler: { result in
                            print(encodingResult)
                            if let info = result.result.value as? Dictionary<String, AnyObject>  {
                                if let links = info["links"] as? Dictionary<String, AnyObject> {
                                    if let imgLink = links["image_link"] as? String {
                                        self.postToFirebase(imgLink)
                                    }
                                }
                            }
                           })
                        case .Failure(let error):
                            print(error)
                        }
                }
            } else {
                self.postToFirebase(nil)
            }
        }
    }
    
    func postToFirebase(imgUrl: String?){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let now = NSDate()
        let nowText = formatter.stringFromDate(now)
        
        var post: Dictionary<String, AnyObject> = [
            "description": postDescField.text!,
            "likes": 0,
            "timestamp": nowText
        ]
        
        if imgUrl != nil {
            post["imageurl"] = imgUrl!
        }
        
        let fireBasePost = DataService.dataService.REF_FIREBASE_POSTS.childByAutoId()
        fireBasePost.setValue(post)
        
         let fireBaseUserPost = DataService.dataService.REF_USER_CURRENT.childByAppendingPath("posts").childByAppendingPath(fireBasePost.key)
        fireBaseUserPost.setValue("true")
        
        postDescField.text = ""
        selectUploadImage.image = UIImage(named: "Camera")
        imageSelected = false
        tableView.reloadData()
    }
}
