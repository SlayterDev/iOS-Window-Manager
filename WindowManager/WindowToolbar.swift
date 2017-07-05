//
//  WindowToolbar.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit
import Then
import SnapKit

protocol WindowDelegate: class {
    func windowDidClose(window: BSWindow)
    func hideWindow(window: BSWindow)
}

class WindowToolbar: UIView, UIGestureRecognizerDelegate {
    
    static let defaultToolbarHeight: CGFloat = 40
    
    weak var parentWindow: BSWindow?
    
    private(set) var previousFrame: CGRect?
    var isMaximized = false
    
    private var windowTitleLabel: UILabel!
    var title: String? {
        didSet {
            windowTitleLabel?.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Colors.toolbarGrey
        
        let btnSpacing = 8
        let closeBtn = UIButton().then {
            $0.backgroundColor = Colors.closeBtnRed
            $0.layer.cornerRadius = StandardSizes.toolbarButtonWidth / 2
            $0.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
            
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(btnSpacing)
                make.centerY.equalTo(self)
                make.width.height.equalTo(StandardSizes.toolbarButtonWidth)
            }
        }
        
        let hideBtn = UIButton().then {
            $0.backgroundColor = Colors.hideBtnYellow
            $0.layer.cornerRadius = StandardSizes.toolbarButtonWidth / 2
            $0.addTarget(self, action: #selector(hideWindow), for: .touchUpInside)
            
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.equalTo(closeBtn.snp.right).offset(btnSpacing)
                make.centerY.equalTo(closeBtn)
                make.width.height.equalTo(StandardSizes.toolbarButtonWidth)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = Colors.maxBtnGreen
            $0.layer.cornerRadius = StandardSizes.toolbarButtonWidth / 2
            $0.addTarget(self, action: #selector(maximizeWindow), for: .touchUpInside)
            
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.equalTo(hideBtn.snp.right).offset(btnSpacing)
                make.centerY.equalTo(closeBtn)
                make.width.height.equalTo(StandardSizes.toolbarButtonWidth)
            }
        }
        
        windowTitleLabel = UILabel().then {
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.center.equalTo(self)
            }
        }
        
        let _ = UITapGestureRecognizer().then {
            $0.numberOfTapsRequired = 2
            $0.delegate = self
            $0.addTarget(self, action: #selector(maximizeWindow))
            self.addGestureRecognizer($0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is UIControl {
            return false
        }
        
        return true
    }
    
    func closeWindow() {
        guard let parent = parentWindow else { return }
        
        parent.delegate?.windowDidClose(window: parent)
        parent.removeChildController()
        
        let oldCenter = parent.center
        UIView.animate(withDuration: 0.15, animations: {
            parent.frame.size = .zero
            parent.center = oldCenter
        }, completion: { (_) in
            parent.removeFromSuperview()
        })
    }
    
    func hideWindow() {
        guard let parent = parentWindow else { return }
        
        previousFrame = parent.frame
        parent.delegate?.hideWindow(window: parent)
    }
    
    func restoreWindow() {
        isMaximized = false
        
        if let prevFrame = previousFrame {
            UIView.animate(withDuration: 0.5, animations: {
                self.superview?.frame = prevFrame
            })
        }
    }
    
    func maximizeWindow() {
        guard !isMaximized else {
            restoreWindow()
            return
        }
        
        guard let windowContainer = superview?.superview else { return }
        
        previousFrame = superview?.frame
        UIView.animate(withDuration: 0.5, animations: {
            self.superview?.frame = windowContainer.frame
        })
        isMaximized = true
    }

}
