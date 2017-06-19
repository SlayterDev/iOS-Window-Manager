//
//  WindowViewController.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import UIKit

protocol WindowControllerDelegate {
    var windowTitle: String { get }
}

class WindowViewController: UIViewController, WindowControllerDelegate {
    
    var windowTitle: String {
        get {
            return "Text Editor"
        }
    }
    
    weak var parentWindow: BSWindow?
    
    var wantsNavigationController = false
    
    var minimumWindowSize: CGSize = StandardSizes.minimumWindowSize
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestWindowSizeChange(newSize: CGSize) {
        guard let window = parentWindow else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            window.frame.size = newSize
        })
    }

}
