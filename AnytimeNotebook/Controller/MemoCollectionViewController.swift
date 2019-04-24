//
//  MemoCollectionViewController.swift
//  Memo
//
//  Created by  李俊 on 15/8/8.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit

class MemoCollectionViewController: UICollectionViewController {

  let margin: CGFloat = 10
  var itemWidth: CGFloat = 0
  let flowLayout = UICollectionViewFlowLayout()
  var totalLie: Int = 0

  init() {
    super.init(collectionViewLayout: flowLayout)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.alwaysBounceVertical = true
    totalLie = totalCorBystatusBarOrientation()
    itemWidth = (collectionView!.bounds.width - CGFloat(totalLie + 1) * margin) / CGFloat(totalLie)
    setFlowLayout()
    NotificationCenter.default.addObserver(self, selector: #selector(statusBarOrientationChange(_:)), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    layoutCollcetionCell()
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  fileprivate func setFlowLayout() {
    flowLayout.minimumInteritemSpacing = margin
    flowLayout.minimumLineSpacing = margin
    flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
  }

  // MARK: - 计算列数,监听屏幕旋转,布局
  fileprivate func totalCorBystatusBarOrientation() -> Int {
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

  fileprivate func layoutCollcetionCell() {
    totalLie = totalCorBystatusBarOrientation()
    itemWidth = (collectionView!.bounds.width - CGFloat(totalLie + 1) * margin) / CGFloat(totalLie)
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
  }

  // MARK: 监听屏幕旋转
  @objc private func statusBarOrientationChange(_ notification: Notification) {
    layoutCollcetionCell()
  }

}
