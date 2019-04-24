//
//  MemoCollectionViewController.swift
//  Memo
//
//  Created by  李俊 on 15/8/8.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class NoteCollectionViewController: UICollectionViewController {

  let myMargin: CGFloat = 10
  var myItemWidth: CGFloat = 0
  let myFlowLayout = UICollectionViewFlowLayout()
  var myTotalLie: Int = 0

  init() {
    super.init(collectionViewLayout: myFlowLayout)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.alwaysBounceVertical = true
    myTotalLie = totalCorBystatusBarOrientation()
    myItemWidth = (collectionView!.bounds.width - CGFloat(myTotalLie + 1) * myMargin) / CGFloat(myTotalLie)
    setFlowLayout()
    NotificationCenter.default.addObserver(self, selector: #selector(statusBarToOrientationChange(_:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    layoutCollcetionCell()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

    fileprivate func setFlowLayout(type: String="") {
    myFlowLayout.minimumInteritemSpacing = myMargin
    myFlowLayout.minimumLineSpacing = myMargin
    myFlowLayout.sectionInset = UIEdgeInsets(top: myMargin, left: myMargin, bottom: myMargin, right: myMargin)
    myFlowLayout.itemSize = CGSize(width: myItemWidth, height: myItemWidth)
  }

  // MARK: - 计算列数,监听屏幕旋转,布局
    fileprivate func totalCorBystatusBarOrientation(size: Int = 5) -> Int {
    let model = UIDevice.current.model
    let orientation = UIApplication.shared.statusBarOrientation

    switch orientation {
    case .landscapeLeft, .landscapeRight:
      if model == "iPhone Simulator" || model == "iPhone" || model == "iPod touch"{
        return 3
      } else {
        return 4
      }
    case .portrait, .portraitUpsideDown:
      if model == "iPhone Simulator" || model == "iPhone" || model == "iPod touch"{
        return 2
      } else {
        return 3
      }
    default: return 2
    }
  }

    fileprivate func layoutCollcetionCell(width: CGFloat = 30, height:CGFloat = 60) {
    myTotalLie = totalCorBystatusBarOrientation()
    myItemWidth = (collectionView!.bounds.width - CGFloat(myTotalLie + 1) * myMargin) / CGFloat(myTotalLie)
    myFlowLayout.itemSize = CGSize(width: myItemWidth, height: myItemWidth)
  }

  // MARK: 监听屏幕旋转
  @objc private func statusBarToOrientationChange(_ notification: Notification) {
    layoutCollcetionCell()
  }

}
