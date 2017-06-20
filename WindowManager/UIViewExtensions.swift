//
//  UIViewExtensions.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import UIKit

extension UIView {
    func renderAsImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return img
    }
}
