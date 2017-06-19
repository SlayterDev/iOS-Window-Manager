//
//  WindowManager.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import UIKit

class WindowManager: NSObject, WindowDelegate, TouchFilterDelegate {
    static let shared = WindowManager()
    
    lazy var windows = [BSWindow]()
    var focusedWindow: BSWindow?
    
    var desktop: DesktopViewController!
    
    func setup(withDesktop vc: DesktopViewController) {
        desktop = vc
        desktop.touchFilter.delegate = self
        windows.removeAll()
    }
    
    func createWindow(_ windowVC: WindowViewController) {
        let window = BSWindow(withTitle: windowVC.windowTitle).then {
            $0.delegate = self
            focusedWindow = $0
            
            desktop.view.addSubview($0)
            if let desiredOrigin = windowVC.desiredOrigin {
                $0.frame.origin = desiredOrigin
            } else {
                $0.center = desktop.view.center
            }
        }
        
        var childVC: UIViewController = windowVC
        if windowVC.wantsNavigationController {
            childVC = UINavigationController(rootViewController: windowVC)
        }
        
        windowVC.parentWindow = window
        window.childController = windowVC
        desktop.addChildViewController(childVC)
        window.contentView.addSubview(childVC.view)
        childVC.view.snp.makeConstraints { (make) in
            make.edges.equalTo(window.contentView)
        }
        windows.append(window)
        
        desktop.view.bringSubview(toFront: desktop.touchFilter)
    }
    
    // MARK: - Window Delegate
    
    func windowDidClose(window: BSWindow) {
        if let windowIndex = windows.index(of: window) {
            windows.remove(at: windowIndex)
        }
    }
    
    // MARK: - Touch Filter Delegate
    
    func getWindowList() -> [BSWindow] {
        return windows
    }
    
    func getFocusedWindow() -> BSWindow? {
        return focusedWindow
    }
    
    func focus(window: BSWindow) {
        desktop.view.bringSubview(toFront: window)
        desktop.view.bringSubview(toFront: desktop.touchFilter)
        focusedWindow = window
    }
}
