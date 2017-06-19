//
//  ViewController.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit
import WebKit

class ViewController: UIViewController, WindowDelegate, TouchFilterDelegate {
    
    var windowCount = 0
    
    lazy var windows = [BSWindow]()
    var focusedWindow: BSWindow?
    
    var touchFilter: TouchFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.with(hex: "#272822")
        
        let addButton = UIButton().then {
            $0.backgroundColor = Colors.toolbarGrey
            $0.layer.cornerRadius = 10
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("New Window", for: .normal)
            $0.addTarget(self, action: #selector(addWindow(_:viewController:)), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(45)
                make.width.equalTo(150)
                make.top.left.equalTo(self.view).offset(16)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = Colors.toolbarGrey
            $0.layer.cornerRadius = 10
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("New Note", for: .normal)
            $0.addTarget(self, action: #selector(newNoteWindow), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(45)
                make.width.equalTo(150)
                make.top.equalTo(addButton)
                make.left.equalTo(addButton.snp.right).offset(10)
            }
        }
        
        touchFilter = TouchFilter().then {
            $0.delegate = self
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newNoteWindow() {
        let noteVC = TextEditViewController()
        addWindow(nil, viewController: noteVC)
    }
    
    func addWindow(_ sender: UIButton?, viewController: WindowViewController?) {
        windowCount += 1
        let window = BSWindow(withTitle: "Window \(windowCount)").then {
            $0.delegate = self
            
            self.view.insertSubview($0, belowSubview: touchFilter)
            $0.center = self.view.center
            
            self.windows.append($0)
            self.focusedWindow = $0
        }
        
        if let vc = viewController {
            vc.parentWindow = window
            window.childController = vc
            var childVC: UIViewController = vc
            
            if vc.wantsNavigationController {
                childVC = UINavigationController(rootViewController: vc)
            }
            
            window.contentView.addSubview(childVC.view)
            self.addChildViewController(childVC)
            childVC.view.snp.makeConstraints { (make) in
                make.edges.equalTo(window.contentView)
            }
            window.windowTitle = vc.windowTitle
        }
    }
    
    func addWebView(toWindow window: BSWindow) {
        let _ = WKWebView().then {
            let _ = $0.load(URLRequest(url: URL(string: "https://youtube.com")!))
            $0.isUserInteractionEnabled = true
            
            window.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.edges.equalTo(window.contentView)
            }
        }
    }
    
    func windowDidClose(window: BSWindow) {
        if let index = windows.index(of: window) {
            windows.remove(at: index)
        }
    }
    
    // MARK: - Touch Filter delegate
    
    func getWindowList() -> [BSWindow] {
        return windows
    }
    
    func getFocusedWindow() -> BSWindow? {
        return focusedWindow
    }
    
    func focus(window: BSWindow) {
        self.view.bringSubview(toFront: window)
        self.view.bringSubview(toFront: touchFilter)
        focusedWindow = window
    }
}

