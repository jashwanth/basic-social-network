//
//  CircleView.swift
//  basic-social-network
//
//  Created by jashwanth reddy gangula on 8/22/17.
//  Copyright © 2017 jashwanth reddy gangula. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
   /* override func awakeFromNib() {
      super.awakeFromNib()
      layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
      layer.shadowOpacity = 0.8
      layer.shadowRadius = 5.0
      layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        clipsToBounds = true
    }*/
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
    /*override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
    }*/

}
