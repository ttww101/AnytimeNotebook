//
//  MemoCell.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit
import SnapKit
import SMKit

private let deleteViewWidth: CGFloat = 60
private let UIPanGestureRecognizerStateKeyPath = "state"

class MemoCell: UICollectionViewCell {

  var didSelectedMemoAction: ((_ memo: Memo) -> Void)?
  var deleteMemoAction: ((_ memo: Memo) -> Void)?
  var memo: Memo? {
    didSet {
      contentLabel.text = memo?.text
    }
  }

  fileprivate var containingView: UICollectionView? {
    didSet {
      updateContainingView()
    }
  }
  fileprivate var hasCellShowDeleteBtn = false
  fileprivate var containingViewPangestureRecognize: UIPanGestureRecognizer?
  fileprivate let scrollView = UIScrollView()
  fileprivate let deleteView = DeleteView()
  fileprivate let contentLabel: MemoLabel = {
    let label = MemoLabel()
    label.backgroundColor = .white
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 15)
    label.verticalAlignment = .top
    label.textColor = SMColor.content
    label.sizeToFit()
    return label
  }()
  fileprivate var getsureRecognizer: UIGestureRecognizer?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setUI()
    NotificationCenter.default.addObserver(self, selector: #selector(hiddenDeleteButtonAnimated), name: SMNotification.MemoCellShouldHiddenDeleteBtn, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(receiveMemoCellDidShowDeleteBtnNotification), name: SMNotification.MemoCellDidShowDeleteBtn, object: nil)
  }

  override func didMoveToSuperview() {
    containingView = nil
    var view: UIView = self
    while let superview = view.superview {
      view = superview
      if let collectionView: UICollectionView = view as? UICollectionView {
        containingView = collectionView
        break
      }
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    scrollView.contentSize = CGSize(width: contentView.width + deleteViewWidth, height: contentView.height)
    deleteView.frame = CGRect(x: contentView.width, y: 0, width: deleteViewWidth, height: contentView.height)
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    removeObserver()
    NotificationCenter.default.removeObserver(self)
  }

  @objc fileprivate func topLabel() {
    if hasCellShowDeleteBtn {
      NotificationCenter.default.post(name: SMNotification.MemoCellShouldHiddenDeleteBtn, object: nil)
      hasCellShowDeleteBtn = false
      return
    }
    if let memo = memo {
      didSelectedMemoAction?(memo)
    }
  }

  @objc fileprivate func deleteMemo() {
    if let memo = memo {
      deleteMemoAction?(memo)
    }
  }

  @objc fileprivate func receiveMemoCellDidShowDeleteBtnNotification() {
    hasCellShowDeleteBtn = true
  }

  @objc fileprivate func hiddenDeleteButtonAnimated() {
    hiddenDeleteButton(withAnimated: true)
    hasCellShowDeleteBtn = false
  }

  override func prepareForReuse() {
    memo = nil
    hiddenDeleteButton(withAnimated: false)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == UIPanGestureRecognizerStateKeyPath &&
      containingViewPangestureRecognize == object as? UIPanGestureRecognizer {
      if containingViewPangestureRecognize?.state == .began {
        hiddenDeleteButton(withAnimated: true)
      }
    }
  }
}

// MARK: - UI
private extension MemoCell {

  func updateContainingView() {
    removeObserver()
    if let collecionView = containingView {
      containingViewPangestureRecognize = collecionView.panGestureRecognizer
      containingViewPangestureRecognize?.addObserver(self, forKeyPath: UIPanGestureRecognizerStateKeyPath, options: .new, context: nil)
    }
  }

  func removeObserver() {
    containingViewPangestureRecognize?.removeObserver(self, forKeyPath: UIPanGestureRecognizerStateKeyPath)
  }

  func setUI() {
    backgroundColor = UIColor.white
    scrollView.bounces = false
    scrollView.delegate = self
    scrollView.showsHorizontalScrollIndicator = false
    contentView.addSubview(scrollView)

    scrollView.snp.makeConstraints { (maker) in
      maker.top.left.bottom.right.equalToSuperview()
    }

    getsureRecognizer = UITapGestureRecognizer(target: self, action: #selector(topLabel))
    contentLabel.addGestureRecognizer(getsureRecognizer!)
    contentLabel.isUserInteractionEnabled = true
    scrollView.addSubview(contentLabel)
    contentLabel.snp.makeConstraints { (maker) in
      maker.top.equalTo(scrollView).offset(5)
      maker.left.equalTo(scrollView).offset(5)
      maker.bottom.equalTo(contentView).offset(-5)
      maker.right.lessThanOrEqualTo(contentView).offset(-5)
      maker.width.equalTo(contentView.width - 10)
    }

    deleteView.backgroundColor = SMColor.backgroundGray
    deleteView.deleteBtn.addTarget(self, action: #selector(deleteMemo), for: .touchUpInside)
    scrollView.addSubview(deleteView)

    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowOpacity = 0.2
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
  }
}

extension MemoCell: UIScrollViewDelegate {

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if hasCellShowDeleteBtn {
      NotificationCenter.default.post(name: SMNotification.MemoCellShouldHiddenDeleteBtn, object: nil)
      hasCellShowDeleteBtn = false
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.x >= deleteViewWidth {
      NotificationCenter.default.post(name: SMNotification.MemoCellDidShowDeleteBtn, object: nil)
    }
    if scrollView.isTracking {
      return
    }
    automateScroll(scrollView)
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if decelerate {
      return
    }
    automateScroll(scrollView)
  }

  func automateScroll(_ scrollView: UIScrollView) {
    let offsetX = scrollView.contentOffset.x
    let newX = offsetX < deleteViewWidth / 2 ? 0 : deleteViewWidth
    UIView.animate(withDuration: 0.1) {
      scrollView.contentOffset = CGPoint(x: newX, y: 0)
    }
  }

  func hiddenDeleteButton(withAnimated animated: Bool = true) {
    let duration: TimeInterval = animated ? 0.2 : 0
    UIView.animate(withDuration: duration) {
      self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
  }
}

// MARK: - DeleteView
private class DeleteView: UIView {

  let deleteBtn = UIButton(type: .custom)

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .gray
    let image = UIImage(named: "ic_trash")?.withRenderingMode(.alwaysTemplate)
    deleteBtn.setImage(image, for: .normal)
    deleteBtn.backgroundColor = SMColor.red
    deleteBtn.layer.masksToBounds = true
    deleteBtn.tintColor = SMColor.backgroundGray
    addSubview(deleteBtn)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate override func layoutSubviews() {
    super.layoutSubviews()
    let margin: CGFloat = 12
    let btnWidth = width - margin * 2
    let btnY = (height - btnWidth) / 2
    deleteBtn.frame = CGRect(x: margin, y: btnY, width: btnWidth, height: btnWidth)
    deleteBtn.layer.cornerRadius = deleteBtn.width / 2
  }

}
