//
//  StandardOptions.swift
//  WindowManager
//
//  Created by bslayter on 6/16/17.
//
//

import UIKit
import BSColorUtils

struct Colors {
    static let toolbarGrey = UIColor.with(hex: "#EFEFEF")
    static let toolbarDarkGrey = UIColor.with(hex: "#AFAFAF")
    
    static let closeBtnRed = UIColor.with(hex: "#FB4847")
    static let hideBtnYellow = UIColor.with(hex: "#FBD325")
    static let maxBtnGreen = UIColor.with(hex: "#2AC733")
}

struct StandardSizes {
    static let toolbarButtonWidth: CGFloat = 19
    
    static let defaultWindowSize: CGSize = CGSize(width: 320, height: 480)
    static let minimumWindowSize: CGSize = CGSize(width: 200, height: 80)
}
