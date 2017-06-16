//
//  TouchFilter.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit

protocol TouchFilterDelegate: class {
    func getWindowList() -> [BSWindow]
    func getFocusedWindow() -> BSWindow?
    func focus(window: BSWindow)
}

class TouchFilter: UIView {
    
    weak var delegate: TouchFilterDelegate?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let windowList = delegate?.getWindowList() else { return false }
        guard let focusedWindow = delegate?.getFocusedWindow() else { return false }
        
        for window in windowList {
            if window.frame.contains(point) && window != focusedWindow && !focusedWindow.frame.contains(point) {
                delegate?.focus(window: window)
                return true
            }
        }
        
        return false
    }

}
