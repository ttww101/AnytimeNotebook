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
    var myTitle: String
    let myRange = self.range(of: "\n")
    if myRange != nil {
      myTitle = self.substring(to: myRange!.lowerBound)
      if myTitle.characters.count > 0 {
        return myTitle
      }
    }

    let text: NSString = self as NSString
    if text.length > 15 {
      myTitle = text.substring(to: 15)
    } else {
      myTitle = self
    }
    return myTitle
  }

}
