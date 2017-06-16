//
//  DragView.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit

class DragView: UIImageView {
    
    weak var parentWindow: BSWindow?
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: superview?.superview)
        parentWindow?.handleResizeWindowBegan(touchLocation: point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: superview)
        
        if let parentWindow = parentWindow, parentWindow.isResizing {
            parentWindow.handleResizeWindow(touchLocation: point)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        parentWindow?.isResizing = false
    }

}
