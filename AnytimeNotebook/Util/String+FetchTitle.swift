//
//  String+FetchTitle.swift
//  Memo
//
//  Created by  李俊 on 15/8/7.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import Foundation

extension String {

  func fetchTitle() -> String {
    var title: String
    let range = self.range(of: "\n")
    if range != nil {
      title = self.substring(to: range!.lowerBound)
      if title.characters.count > 0 {
        return title
      }
    }

    let text: NSString = self as NSString
    if text.length > 15 {
      title = text.substring(to: 15)
    } else {
      title = self
    }
    return title
  }

}
