//
//  TextEditViewController.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import UIKit

class TextEditViewController: WindowViewController {
    
    var textView: UITextView!
    
    var smallSize: CGSize = CGSize(width: 275, height: 300)
    
    override var windowTitle: String {
        get {
            return "Text Editor"
        }
    }
    
    override var wantsNavigationController: Bool {
        get {
            return true
        }
        set {
            
        }
    }
    
    override var minimumWindowSize: CGSize {
        get {
            return smallSize
        }
        set {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = UITextView().then {
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.edges.equalTo(self.view)
            }
        }
        
        let smallBtn = UIBarButtonItem(title: "s", style: .plain, target: self, action: #selector(changeWindowSize(_:))).then {
            $0.tag = 0
        }
        let lrgBtn = UIBarButtonItem(title: "L", style: .plain, target: self, action: #selector(changeWindowSize(_:))).then {
            $0.tag = 1
        }
        
        self.navigationItem.leftBarButtonItems = [smallBtn, lrgBtn]
        
        textView.becomeFirstResponder()
        
        navigationController?.navigationBar.barTintColor = Colors.maxBtnGreen
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeWindowSize(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            requestWindowSizeChange(newSize: smallSize)
        } else {
            requestWindowSizeChange(newSize: StandardSizes.defaultWindowSize)
        }
    }
    
}
