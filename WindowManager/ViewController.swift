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
        
        let _ = UIButton().then {
            $0.backgroundColor = Colors.toolbarGrey
            $0.layer.cornerRadius = 10
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("New Window", for: .normal)
            $0.addTarget(self, action: #selector(addWindow(_:)), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(45)
                make.width.equalTo(150)
                make.top.left.equalTo(self.view).offset(16)
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

    func addWindow(_ sender: UIButton) {
        windowCount += 1
        let _ = BSWindow(withTitle: "Window \(windowCount)").then {
            $0.delegate = self
            
            self.view.insertSubview($0, belowSubview: touchFilter)
            $0.center = self.view.center
            
            self.addWebView(toWindow: $0)
            self.windows.append($0)
            self.focusedWindow = $0
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

