//
//  ViewController.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit
import WebKit

class DesktopViewController: UIViewController {
    
    var touchFilter: TouchFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.with(hex: "#272822")
        
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
                make.top.left.equalTo(self.view).offset(16)
            }
        }
        
        touchFilter = TouchFilter().then {
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
        
        WindowManager.shared.setup(withDesktop: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newNoteWindow() {
        let noteVC = TextEditViewController()
        WindowManager.shared.createWindow(noteVC)
    }
    
}

