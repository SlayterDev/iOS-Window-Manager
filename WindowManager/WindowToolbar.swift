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

class WindowToolbar: UIView {
    
    static let defaultToolbarHeight: CGFloat = 40
    
    var previousFrame: CGRect?
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
            $0.backgroundColor = .red
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
            $0.backgroundColor = .yellow
            $0.layer.cornerRadius = StandardSizes.toolbarButtonWidth / 2
            
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.equalTo(closeBtn.snp.right).offset(btnSpacing)
                make.centerY.equalTo(closeBtn)
                make.width.height.equalTo(StandardSizes.toolbarButtonWidth)
            }
        }
        
        let _ = UIButton().then {
            $0.backgroundColor = .green
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeWindow() {
        superview?.removeFromSuperview()
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
