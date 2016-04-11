//==============================================================================
//  NBPictureMaskField.swift
//  NBPictureMaskField
//  GitHub: https://github.com/nkboland/NBPictureMaskField
//
//  Created by Nick Boland on 3/27/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//
//------------------------------------------------------------------------------
//
//  OVERVIEW
//  --------
//
//  See NBPictureMask for description of the mask.
//
//  Storyboard Attributes:
//
//    mask
//
//  Class Variables:
//
//    maskErrorMessage
//    maskTreeToString
//
//  Class Functions:
//
//    check()
//
//==============================================================================

import UIKit
import Foundation

class NBPictureMaskField: UITextField {
//------------------------------------------------------------------------------

  //--------------------
  // MARK: - Variables

  var maskErrMsg: String?
  var nbPictureMask : NBPictureMask!

  private var _enforceMask: Bool

  required init?(coder aDecoder: NSCoder) {
  //----------------------------------------------------------------------------
    nbPictureMask = NBPictureMask()
    _enforceMask = true
    super.init(coder: aDecoder)
  }

  deinit {
  //----------------------------------------------------------------------------
    removeObserver(self, forKeyPath: "text")
  }

  //--------------------
  // MARK: - Mask

  @IBInspectable var mask: String {
  //----------------------------------------------------------------------------
    get { return nbPictureMask.getMask() }
    set {
      let retVal = nbPictureMask.setMask(newValue)
      maskErrMsg = retVal.errMsg
    }
  }

  @IBInspectable var autoFill: Bool {
  //----------------------------------------------------------------------------
    get { return nbPictureMask.getAutoFill() }
    set { nbPictureMask.setAutoFill(newValue) }
  }

  var maskErrorMessage: String? {
  //----------------------------------------------------------------------------
  // Returns the error message for the current mask, otherwise nil.
    get { return maskErrMsg }
  }

  var maskTreeToString: String {
  //----------------------------------------------------------------------------
  // Returns the parsed mask tree as a string.
    get { return nbPictureMask.maskTreeToString() }
  }

  var enforceMask: Bool {
  //----------------------------------------------------------------------------
    get { return _enforceMask }
    set { _enforceMask = newValue }
  }

  func check(text: String) -> NBPictureMask.CheckResult {
  //----------------------------------------------------------------------------
    return nbPictureMask.check(text)
  }

  //--------------------
  // MARK: - Draw

  override func drawRect(rect: CGRect) {
  //----------------------------------------------------------------------------
  // This is used as a way to get an observer on "text".

    super.drawRect(rect)

    // This observer used on manual updating text property
    delegate = self
//    addObserver(self, forKeyPath: "text", options: [], context: nil)
  }

}

//--------------------
// MARK: - Observers

extension NBPictureMaskField {
//------------------------------------------------------------------------------

  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
  //----------------------------------------------------------------------------
    NSLog("OBSERVE VALUE FOR KEY PATH")
  }

}

//--------------------
// MARK: - UITextFieldDelegate

extension NBPictureMaskField: UITextFieldDelegate {
//------------------------------------------------------------------------------

  func textFieldDidBeginEditing(textField: UITextField) {
  //----------------------------------------------------------------------------

    NSLog("TextFieldDidBeginEdit text:\(textField.text)")

  }


  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
  //----------------------------------------------------------------------------


/*
UITextFieldTextDidChangeNotification

func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    let beginning = textField.beginningOfDocument
    let start = textField.positionFromPosition(beginning, offset:range.location)
    let end = textField.positionFromPosition(start!, offset:range.length)
    let textRange = textField.textRangeFromPosition(start!, toPosition:end!)
    let cursorOffset = textField.offsetFromPosition(beginning, toPosition:start!) + string.characters.count

// just used same text, use whatever you want :)
    textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)

    let newCursorPosition = textField.positionFromPosition(textField.beginningOfDocument, offset:cursorOffset)
    let newSelectedRange = textField.textRangeFromPosition(newCursorPosition!, toPosition:newCursorPosition!)
    textField.selectedTextRange = newSelectedRange

    return false
}

*/
  guard enforceMask else { return true }

  // Save positions
  let beginning = textField.beginningOfDocument
  let start = textField.positionFromPosition(beginning, offset:range.location)
//let end = textField.positionFromPosition(start!, offset:range.length)
//let textRange = textField.textRangeFromPosition(start!, toPosition:end!)
  var cursorOffset = textField.offsetFromPosition(beginning, toPosition:start!) + string.characters.count

  let checkResult = nbPictureMask.check(textField.text ?? "", shouldChangeCharactersInRange: range, replacementString: string)

  guard checkResult.status != .NotOk else { return false }

  textField.text = checkResult.text
  cursorOffset += checkResult.autoFillOffset
  let newCursorPosition = textField.positionFromPosition(textField.beginningOfDocument, offset:cursorOffset)
  let newSelectedRange = textField.textRangeFromPosition(newCursorPosition!, toPosition:newCursorPosition!)
  textField.selectedTextRange = newSelectedRange

  return false

/*

    let currentText = textField.text ?? ""

    NSLog("=======================")
    NSLog("TextField text:'\(currentText)' range:\(range) string:'\(string)'")

    let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
    NSLog("TextField prospectiveText:'\(prospectiveText)'")

    guard enforceMask else { return true }

    // Enforce the mask

    let retVal = nbPictureMask.check(prospectiveText)

    switch retVal.status {
    case .Ok,
         .OkSoFar :
      textField.text = retVal.text
      return false
    case .NotOk :
      return false
    }
*/

  }

}
