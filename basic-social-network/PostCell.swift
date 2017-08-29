//
//  PostCell.swift
//  basic-social-network
//
//  Created by jashwanth reddy gangula on 8/22/17.
//  Copyright © 2017 jashwanth reddy gangula. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class PostCell: UITableViewCell {

    @IBOutlet weak var profileImg: CircleView!
    
    @IBOutlet weak var usernameLbl: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var caption: UITextView!
    
    @IBOutlet weak var likesLbl: UILabel!

    @IBOutlet weak var likeImg: CircleView!
    
    var post: Post!
    var likesref: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage?) {
        
      self.post = post
      likesref = DataService.ds.REF_USER_CURRENT.child("likes").child(self.post.postKey)
      self.caption.text = post.caption
      self.likesLbl.text = "\(post.likes)"
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 20*1024*1024, completion: { (data, error) in
                if error != nil {
                    print("God unable to download the image from FIR Storage")
                } else {
                    print("God image download is successful")
                    if let imageData = data {
                        if let img = UIImage(data: imageData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
            
        }
   
        likesref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
              self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likesref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesref.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesref.removeValue()
            }
        })
    }
}
