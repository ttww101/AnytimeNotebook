//
//  MemoLabel.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//  自定义UILabel, 实现文字据顶部显示

import UIKit

class MemoLabel: UILabel {

  /// 文字显示位置
  enum VerticalAlignment: Int {
    case top = 0
    case middle = 1 // default
    case bottom = 2
  }

  var verticalAlignment: VerticalAlignment? {
    didSet {
      setNeedsDisplay()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    verticalAlignment = .middle
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    switch verticalAlignment! {
    case .top:
      textRect.origin.y = bounds.origin.y
    case .bottom:
      textRect.origin.y = bounds.origin.y + bounds.height - textRect.height
    case .middle:
      textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0

    }
    return textRect
  }

  override func drawText(in rect: CGRect) {
    let actualRect = textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
    super.drawText(in: actualRect)
  }

}
