//
//  GoodiesFeedVC.swift
//  GoodR
//
//  Created by Sam Rabeeh on 2016-03-01.
//  Copyright © 2016 Sam Rabeeh - RCI. All rights reserved.
//

import UIKit
import Firebase

class GoodiesFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.dataService.REF_FIREBASE_POSTS.observeEventType(.Value, withBlock: {snapshot in
    
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
            cell.configureCell(post)
            return cell
        } else {
            return GoodieCell()
        }
    }
}
