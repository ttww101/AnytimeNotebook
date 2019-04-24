//
//  SMExtension.swift
//  SimpleMemo
//
//  Created by  李俊 on 2017/2/26.
//  Copyright © 2017年 Lijun. All rights reserved.
//

import UIKit

// MARK: - Convenience methods for UIColor
public extension UIColor {

  /// Init color without divide 255.0
  ///
  /// - Parameters:
  ///   - r: (0 ~ 255) red
  ///   - g: (0 ~ 255) green
  ///   - b: (0 ~ 255) blue
  ///   - a: (0 ~ 1) alpha
  convenience init(r: Int, g: Int, b: Int, a: CGFloat) {
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: a)
  }

  /// Init color without divide 255.0
  ///
  /// - Parameters:
  ///   - r: (0 ~ 255) red
  ///   - g: (0 ~ 255) green
  ///   - b: (0 ~ 1) alpha
  convenience init(r: Int, g: Int, b: Int) {
    self.init(r: r, g: g, b: b, a: 1)
  }

  /// Init color with hex code and alpha
  ///
  /// - Parameters:
  ///   - rgbHexValue: hex code (eg. 0x00eeee)
  ///   - alpha: (0 ~ 1) alpha
  convenience init(hex rgbHexValue: Int, alpha: CGFloat) {
    self.init(r: (rgbHexValue & 0xFF0000) >> 16,
              g: (rgbHexValue & 0xFF00) >> 8,
              b: (rgbHexValue & 0xFF),
              a: alpha)
  }

  /// Init color with hex
  ///
  /// - Parameter rgbHexValue: hex code (eg. 0x00eeee)
  convenience init(hex rgbHexValue: Int) {
    self.init(hex: rgbHexValue, alpha: 1)
  }

}
