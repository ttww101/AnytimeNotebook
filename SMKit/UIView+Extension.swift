//
//  UIView+Extension.swift
//  SimpleMemo
//
//  Created by  李俊 on 2017/2/26.
//  Copyright © 2017年 Lijun. All rights reserved.
//

import UIKit

public extension UIView {

  var width: CGFloat {
    return frame.width
  }

  var height: CGFloat {
    return frame.height
  }

  var x: CGFloat {
    return frame.minX
  }

  var y: CGFloat {
    return frame.minY
  }

  var size: CGSize {
    return frame.size
  }
}
