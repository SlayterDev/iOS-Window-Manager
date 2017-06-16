//
//  ViewController.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit

class ViewController: UIViewController {
    
    var windowCount = 0
    
    lazy var windows = [BSWindow]()
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addWindow(_ sender: UIButton) {
        windowCount += 1
        let _ = BSWindow(withTitle: "Window \(windowCount)").then {
            self.view.addSubview($0)
            $0.center = self.view.center
            
            self.addWebView(toWindow: $0)
        }
    }
    
    func addWebView(toWindow window: BSWindow) {
        let _ = UIWebView().then {
            $0.loadRequest(URLRequest(url: URL(string: "https://google.com")!))
            
            window.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.edges.equalTo(window.contentView)
            }
        }
    }
}

