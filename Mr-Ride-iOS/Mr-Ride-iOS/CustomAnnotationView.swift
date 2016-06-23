//
//  CustomAnnotationView.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 6/23/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotationView: MKAnnotationView {
    
    func setCustomImage(originImage: UIImage){
        self.frame.size.height = originImage.size.height * 2
        self.frame.size.width = originImage.size.width * 2
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mrCharcoalGreyColor().CGColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.frame, cornerRadius: self.frame.size.height / 2).CGPath
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius =  self.frame.size.height / 2
//        self.clipsToBounds = true
        
        let imageView = UIImageView.init(image: originImage)
        imageView.center = self.center
        
        self.addSubview(imageView)
        
    }
    
}