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
    
    override var keyCommands: [UIKeyCommand]? {
        return [UIKeyCommand(input: UIKeyInputLeftArrow, modifierFlags: .alternate, action: #selector(snapLeft)),
                UIKeyCommand(input: UIKeyInputRightArrow, modifierFlags: .alternate, action: #selector(snapRight)),
                UIKeyCommand(input: "w", modifierFlags: .alternate, action: #selector(closeFocusedWindow)),
                UIKeyCommand(input: "\t", modifierFlags: .alternate, action: #selector(cycleWindows))]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.with(hex: "#272822")
        
        let noteBtn = UIButton().then {
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
        
        let _ = UIButton().then {
            $0.backgroundColor = Colors.toolbarGrey
            $0.layer.cornerRadius = 10
            $0.setTitleColor(.black, for: .normal)
            $0.setTitle("Todo List", for: .normal)
            $0.addTarget(self, action: #selector(openTodoList), for: .touchUpInside)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.height.equalTo(45)
                make.width.equalTo(150)
                make.top.equalTo(noteBtn)
                make.left.equalTo(noteBtn.snp.right).offset(10)
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
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func newNoteWindow() {
        let noteVC = TextEditViewController()
        WindowManager.shared.createWindow(noteVC)
    }
    
    func openTodoList() {
        let todoVC = TodoListViewController()
        WindowManager.shared.createWindow(todoVC)
    }
    
    func snapLeft() {
        WindowManager.shared.snapLeft()
    }
    
    func snapRight() {
        WindowManager.shared.snapRight()
    }
    
    func closeFocusedWindow() {
        WindowManager.shared.closeFocusedWindow()
    }
    
    func cycleWindows() {
        WindowManager.shared.cycleWindows()
    }
}

