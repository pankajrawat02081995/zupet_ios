//
//  UIFont.swift
//  Broker Portal
//
//  Created by Pankaj on 21/04/25.
//

import UIKit

public extension CGFloat {
    /// Automatically scales font size for iPad
    var autoScaledForDevice: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? self * 2 : self
    }
}

public extension UIFont {
    
    static func monroeRegular(_ size: CGFloat, isError: Bool = false) -> UIFont {
        MonroeFontStyle.regular.with(size: isError ? size : size.autoScaledForDevice)
    }
    
    static func monroeMedium(_ size: CGFloat, isError: Bool = false) -> UIFont {
        MonroeFontStyle.medium.with(size: isError ? size : size.autoScaledForDevice)
    }
    
    static func monroeBold(_ size: CGFloat, isError: Bool = false) -> UIFont {
        MonroeFontStyle.bold.with(size: isError ? size : size.autoScaledForDevice)
    }
    
    static func monroeSemiBold(_ size: CGFloat, isError: Bool = false) -> UIFont {
        MonroeFontStyle.semiBold.with(size: isError ? size : size.autoScaledForDevice)
    }

    static func monroeItalic(_ size: CGFloat, isError: Bool = false) -> UIFont {
        MonroeFontStyle.italic.with(size: isError ? size : size.autoScaledForDevice)
    }
}

private enum MonroeFontStyle: String{
    case regular = "Monroe-Regular"
    case medium = "Monroe-Medium"
    case bold = "Monroe-Bold"
    case semiBold = "Monroe-SemiBold"
    case italic = "Monroe-Italic"
    
    func with(size: CGFloat) -> UIFont {
        UIFont(name: rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
