//
//  Font.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 5/23/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import Foundation

extension UIFont {
    class func mrTextStyleFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: size)
    }
    
    class func mrTextStyle8Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightBold)
    }
    
    class func mrTextStyle5Font(size: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica", size: size)
    }
    
    class func mrTextStyle9Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightRegular)
    }
    
    class func mrTextStyle3Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightBold)
    }
    
    class func mrTextStyle7Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightMedium)
    }
    
    class func mrTextStyle11Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightMedium)
    }
    
    class func mrTextStyle2Font(size: CGFloat) -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: size)
    }
    
    class func mrTextStyle10Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightMedium)
    }
    
    class func mrTextStyle6Font(size: CGFloat) -> UIFont? {
        return UIFont(name: "Helvetica", size: size)
    }
    
    class func mrTextStyle12Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightRegular)
    }
    
    class func mrTextStyle4Font(size: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(size, weight: UIFontWeightRegular)
    }
}