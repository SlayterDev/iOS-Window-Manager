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
    
    var windowTitle: String? {
        didSet {
            toolbar?.title = windowTitle
        }
    }
    
    weak var delegate: WindowDelegate?
    weak var childController: WindowViewController?
    
    private(set) var toolbar: WindowToolbar!
    private var dragView: DragView!
    
    private var isDragging = false
    var isResizing = false
    private var touchOffset: CGPoint = .zero
    
    private(set) var contentView: UIView!
    
    convenience init(withTitle title: String?, windowSize: CGSize = StandardSizes.defaultWindowSize) {
        self.init(frame: CGRect(x: 0, y: 0, width: windowSize.width, height: windowSize.height))
        
        windowTitle = title
        toolbar.title = title
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
    
    func removeChildController() {
        guard let childController = childController else { return }
        
        if let nav = childController.navigationController {
            nav.removeFromParentViewController()
        } else {
            childController.removeFromParentViewController()
        }
    }
    
    func focusWindow() {
        toolbar.backgroundColor = Colors.toolbarGrey
    }
    
    func unfocusWindow() {
        toolbar.backgroundColor = Colors.toolbarDarkGrey
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
        
        let maxFramePoint = convert(CGPoint(x: frame.size.width, y: frame.size.height), to: superview)
        
        touchOffset = distance(a: maxFramePoint, b: touchLocation)
    }
    
    func handleResizeWindow(touchLocation: CGPoint) {
        var minSize = StandardSizes.minimumWindowSize
        
        if let windowController = childController {
            minSize = windowController.minimumWindowSize
        }
        
        var newSize = CGSize(width: touchLocation.x + touchOffset.x, height: touchLocation.y + touchOffset.y)
        newSize.width = max(newSize.width, minSize.width)
        newSize.height = max(newSize.height, minSize.height)
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
