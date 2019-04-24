//
//  MemoViewController.swift
//  EverMemo
//
//  Created by  李俊 on 15/8/5.
//  Copyright (c) 2015年  李俊. All rights reserved.
//

import UIKit
import CoreData
import EvernoteSDK
import SnapKit
import SMKit

class NoteViewController: UIViewController {

  var memo: Memo?

  fileprivate let myTextView = UITextView()
  fileprivate var mySharedItem: UIBarButtonItem!

  convenience init(text: String? = nil) {
    self.init(nibName: nil, bundle: nil)
    myTextView.text = text ?? ""
    saveCurrentText()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setUI()
    NotificationCenter.default.addObserver(self, selector: #selector(changeLayout(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    if let memo = memo, myTextView.text.isEmpty {
      ENSession.shared.deleteFromEvernote(with: memo)
      NotebookCoreDataStack.default.managedContext.delete(memo)
    }
    NotebookCoreDataStack.default.saveContext()
  }

  // 3D Touch previewActionItems
  override var previewActionItems: [UIPreviewActionItem] {
    let deleteAction = UIPreviewAction(title: "删除", style: .destructive) { (action, controller) in
      guard let memoController: NoteViewController = controller as? NoteViewController, let memo = memoController.memo else {
        return
      }

      NotebookCoreDataStack.default.managedContext.delete(memo)
      ENSession.shared.deleteFromEvernote(with: memo)
    }
    return [deleteAction]
  }

}

// MARK: - Private extension

private extension NoteViewController {

  func setUI(token: String = "") {
    view.backgroundColor = UIColor.white
    setTextView()
    mySharedItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(NoteViewController.perpormShareTo(_:)))
    navigationItem.rightBarButtonItem = mySharedItem
    if memo == nil {
      title = "新便签"
      myTextView.becomeFirstResponder()
    } else {
      title = memo!.text?.fetchTitle()
      myTextView.text = memo!.text
    }
    mySharedItem.isEnabled = !myTextView.text.isEmpty
  }

  func setTextView(token: String = "") {
    myTextView.delegate = self
    myTextView.layoutManager.allowsNonContiguousLayout = false
    myTextView.keyboardDismissMode = .onDrag
    myTextView.translatesAutoresizingMaskIntoConstraints = false
    setTextViewAttrubt()
    view.addSubview(myTextView)
    setTextViewConstraints(withBottomOffset: -5)
  }

  func setTextViewConstraints(withBottomOffset offset: CGFloat) {
    myTextView.snp.remakeConstraints { (maker) in
      maker.top.equalToSuperview()
      maker.left.equalTo(view).offset(5)
      maker.right.equalTo(view).offset(-5)
      maker.bottom.equalTo(view).offset(offset)
    }
  }

  func setTextViewAttrubt(token: String = "") {
    let paregraphStyle = NSMutableParagraphStyle()
    paregraphStyle.lineSpacing = 5
    let attributes = [convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16), convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paregraphStyle]
    myTextView.typingAttributes = convertToNSAttributedStringKeyDictionary(attributes)
    myTextView.font = UIFont.systemFont(ofSize: 16)
    myTextView.textColor = SMColor.content
  }

  @objc func perpormShareTo(_ barButton: UIBarButtonItem) {
    let activityController = UIActivityViewController(activityItems: [myTextView.text], applicationActivities: nil)
    let drivce = UIDevice.current
    let model = drivce.model
    if model == "iPhone Simulator" || model == "iPhone" || model == "iPod touch"{
      present(activityController, animated: true, completion: nil)
    } else {
      let popoverView =  UIPopoverController(contentViewController: activityController)
      popoverView.present(from: barButton, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
    }
  }

  @objc func changeLayout(_ notification: Notification) {
    let keyboarFrame: CGRect? = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    let keyboardY = keyboarFrame?.origin.y ?? 0
    setTextViewConstraints(withBottomOffset: -(view.bounds.size.height - keyboardY + 5))
  }

  func saveCurrentText(token: String = "") {
    memo = memo ?? Memo.newMemo()
    memo!.text = myTextView.text
    memo!.updateDate = Date()
    NotebookCoreDataStack.default.saveContext()
  }

}

// MARK: - UITextViewDelegate

extension NoteViewController: UITextViewDelegate {

  func textViewDidChange(_ textView: UITextView) {
    memo?.isUpload = false
    mySharedItem.isEnabled = !textView.text.isEmpty
    saveCurrentText()
  }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
