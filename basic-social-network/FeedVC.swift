//
//  FeedVC.swift
//  basic-social-network
//
//  Created by jashwanth reddy gangula on 8/21/17.
//  Copyright © 2017 jashwanth reddy gangula. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = false
    
    @IBOutlet weak var captionField: UITextField!
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
          print("Caption must be entered")
          return
        }
        guard let img = imageAdded.image, imageSelected == true else {
            print("Image must be added")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Unable to upload pics to firebase storage")
                } else {
                    print("Successfully uploaded pics to firebase storage")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                      self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": captionField.text as AnyObject,
        "imageUrl": imgUrl as AnyObject,
        "likes": 0 as AnyObject]
      let firebasepost = DataService.ds.REF_POSTS.childByAutoId()
        firebasepost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdded.image = UIImage(named: "add-image")
        
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageAdded: UIImageView!
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdded.image = image
            imageSelected = true
        } else {
            print("God valid image is not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("ID removed from key chain \(keychainResult)")
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        DataService.ds.REF_POSTS.observe(.value,
                                         with: { (snapshot) in
          //  print(snapshot.value!)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                  print("SNAP: \(snap)")
                    if let post = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: post)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        print("HAHA: \(post.caption)")
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
                return cell
            } else {
               cell.configureCell(post: post, img: nil)
               return cell
            }
        } else {
            return PostCell()
        }
        //return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
       // return PostCell()
    }
}
