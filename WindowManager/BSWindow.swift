//
//  BSWindow.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit

func distance(a: CGPoint, b: CGPoint) -> CGPoint {
    let xDist = a.x - b.x
    let yDist = a.y - b.y
    return CGPoint(x: xDist, y: yDist)
}

class BSWindow: UIView {
    
    private var toolbar: WindowToolbar!
    
    private var isDragging = false
    private var touchOffset: CGPoint = .zero
    
    private(set) var contentView: UIView!
    
    convenience init(withTitle title: String?, windowSize: CGSize = StandardSizes.defaultWindowSize) {
        self.init(frame: CGRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height))
        
        toolbar?.title = title
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.25
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        toolbar = WindowToolbar().then {
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.left.top.width.equalTo(self)
                make.height.equalTo(WindowToolbar.defaultToolbarHeight)
            }
        }
        
        contentView = UIView().then {
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.top.equalTo(toolbar.snp.bottom)
                make.left.right.bottom.equalTo(self)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: superview)
        let toolbarRect = convert(toolbar.frame, to: superview)
        
        if toolbarRect.contains(point) {
            isDragging = true
            touchOffset = distance(a: center, b: point)
            superview?.bringSubview(toFront: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: superview)
        
        if isDragging {
            center = CGPoint(x: point.x + touchOffset.x, y: point.y + touchOffset.y)
            frame.origin.y = max(frame.origin.y, 0)
            frame.origin.y = min(superview!.frame.height - WindowToolbar.defaultToolbarHeight, frame.origin.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
    }

}
