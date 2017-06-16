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
    
    weak var delegate: WindowDelegate?
    
    private var toolbar: WindowToolbar!
    private var dragView: DragView!
    
    private var isDragging = false
    private(set) var isResizing = false
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
            $0.parentWindow = self
            
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
        
        dragView = DragView(image: UIImage(named: "DragHandle")).then {
            $0.parentWindow = self
            
            self.addSubview($0)
            $0.snp.makeConstraints { (make) in
                make.bottom.right.equalTo(self)
                make.height.width.equalTo(27)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bringSubview(toFront: dragView)
    }
    
    // MARK: - Move Window
    
    func handleMoveWindowBegan(touchLocation: CGPoint) {
        isDragging = true
        touchOffset = distance(a: center, b: touchLocation)
        superview?.bringSubview(toFront: self)
    }
    
    func handleMoveWindow(touchLocation: CGPoint) {
        center = CGPoint(x: touchLocation.x + touchOffset.x, y: touchLocation.y + touchOffset.y)
        frame.origin.y = max(frame.origin.y, 0)
        frame.origin.y = min(superview!.frame.height - WindowToolbar.defaultToolbarHeight, frame.origin.y)
    }
    
    // MARK: - Resize Window
    
    func handleResizeWindowBegan(touchLocation: CGPoint) {
        isResizing = true
        touchOffset = distance(a: center, b: touchLocation)
//        superview?.bringSubview(toFront: self)
    }
    
    func handleResizeWindow(touchLocation: CGPoint) {
        var newSize = CGSize(width: touchLocation.x, height: touchLocation.y)
        newSize.width = max(newSize.width, 200)
        newSize.height = max(newSize.height, WindowToolbar.defaultToolbarHeight * 2)
        frame.size = newSize
    }
    
    // MARK: - Touch Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        superview?.bringSubview(toFront: self)
        
        let point = touches.first!.location(in: superview)
        let toolbarRect = convert(toolbar.frame, to: superview)
        let dragHandleRect = convert(dragView.frame, to: superview)
        
        if toolbarRect.contains(point) {
            handleMoveWindowBegan(touchLocation: point)
        } else if dragHandleRect.contains(point) {
            handleResizeWindowBegan(touchLocation: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: superview)
        
        if isDragging {
            handleMoveWindow(touchLocation: point)
        } else if isResizing {
            handleResizeWindow(touchLocation: touches.first!.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
        isResizing = false
    }

}
