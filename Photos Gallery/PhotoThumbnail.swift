//
//  PhotoThumbnail.swift
//  Photos Gallery
//
//  Created by hekai on 17/3/5.
//  Copyright © 2017年 hekai. All rights reserved.
//

import UIKit

class PhotoThumbnail: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setThumbnailImage(thumbnailImage: UIImage){
       self.imageView.image = thumbnailImage
    }
    
}
