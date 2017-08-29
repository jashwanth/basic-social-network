//
//  RoundBtn.swift
//  basic-social-network
//
//  Created by jashwanth reddy gangula on 8/20/17.
//  Copyright © 2017 jashwanth reddy gangula. All rights reserved.
//

import UIKit

class RoundBtn: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: SHADOW_GREY).cgColor
        layer.shadowOpacity = 0.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
      layer.cornerRadius = self.frame.width / 2
        
    }

}
