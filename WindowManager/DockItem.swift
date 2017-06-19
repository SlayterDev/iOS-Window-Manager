//
//  DockItem.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import UIKit

class DockItem: NSObject {

    var window: BSWindow?
    var windowThumbnail: UIImage?
    var imageView: UIImageView?
    
    init(withWindow window: BSWindow) {
        self.window = window
        windowThumbnail = window.renderAsImage()
    }
    
}
