//
//  Dock.swift
//  WindowManager
//
//  Created by bslayter on 6/19/17.
//
//

import UIKit

class Dock: UIView {

    lazy var dockItems = [DockItem]()
    
    let standardOffset: CGFloat = 30
    let standardItemSize: CGFloat = 100
    
    func getItemFrame(forIndex index: Int) -> CGRect {
        return CGRect(x: CGFloat(index) * standardItemSize + standardOffset, y: frame.origin.y,
                      width: standardItemSize, height: standardItemSize)
    }
    
    func moveWindowToDock(window: BSWindow) {
        let itemFrame = getItemFrame(forIndex: dockItems.count)
        let dockItem = DockItem(withWindow: window)
        
        UIView.animate(withDuration: 0.25, animations: {
            window.frame = itemFrame
        }, completion: { _ in
            window.removeFromSuperview()
            self.addDockItem(dockItem)
        })
    }
    
    func addDockItem(_ dockItem: DockItem) {
        dockItem.imageView = UIImageView(image: dockItem.windowThumbnail).then {
            self.addSubview($0)
            $0.contentMode = .scaleAspectFit
            $0.tag = self.dockItems.count
            
            let tapGesture = UITapGestureRecognizer()
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            tapGesture.addTarget(self, action: #selector(restoreDockItem(_:)))
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGesture)
        }
        dockItems.append(dockItem)
        makeDockItemConstraints()
    }
    
    func makeDockItemConstraints() {
        for (i, obj) in dockItems.enumerated() {
            obj.imageView?.snp.makeConstraints { (make) in
                if i > 0 {
                    make.left.equalTo(dockItems[i - 1].imageView!.snp.right).offset(standardOffset)
                } else {
                    make.left.equalTo(self).offset(standardOffset)
                }
                make.bottom.equalTo(self)
                make.height.width.equalTo(standardItemSize)
            }
        }
    }
    
    func removeDockItem(_ dockItem: DockItem) {
        if let index = dockItems.index(of: dockItem) {
            dockItems.remove(at: index)
            dockItem.imageView?.removeFromSuperview()
            makeDockItemConstraints()
        }
    }
    
    func restoreDockItem(_ tapGesture: UITapGestureRecognizer) {
        guard let index = tapGesture.view?.tag else { return }
        
        
    }
}
