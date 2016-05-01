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

  // MARK: - Types

  typealias ValidateClosure = (sender: AnyObject, text: String, status: NBPictureMask.Status ) -> (Bool)
  typealias ChangedClosure = (sender: AnyObject, text: String, status: NBPictureMask.Status ) -> ()

  // MARK: - Variables

  var maskErrMsg: String?

  var validate: ValidateClosure?
  var changed: ChangedClosure?

  private var nbPictureMask : NBPictureMask!
  private var isEditing: Bool
  private var _enforceMask: Bool

  required init?(coder aDecoder: NSCoder) {
  //----------------------------------------------------------------------------
    nbPictureMask = NBPictureMask()
    _enforceMask = true
    isEditing = false
    super.init(coder: aDecoder)
  }

  deinit {
  //----------------------------------------------------------------------------
    //removeObserver(self, forKeyPath: "text")          // DO I NEED THIS???
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

  @IBInspectable var enforceMask: Bool {
  //----------------------------------------------------------------------------
    get { return _enforceMask }
    set { _enforceMask = newValue }
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

  override var text: String? {
  //----------------------------------------------------------------------------
  // Property observer so closures can be called if user sets text property
  // directly (typically during initialization).

    didSet {
      guard !isEditing else { return }

      let checkResult = nbPictureMask.check(text ?? "")

      // User does not have a choice at this point in time
      validate?(sender: self, text: checkResult.text, status: checkResult.status)
      changed?(sender: self, text: checkResult.text, status: checkResult.status)

      NSLog("OVERRIDE TEXT DIDSET \(text)")
    }
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
    //addObserver(self, forKeyPath: "text", options: [], context: nil)    // DO I NEED THIS??
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
    isEditing = true
  }

  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
  //----------------------------------------------------------------------------

    // Save positions
    let beginning = textField.beginningOfDocument
    let start = textField.positionFromPosition(beginning, offset:range.location)
    //let end = textField.positionFromPosition(start!, offset:range.length)
    //let textRange = textField.textRangeFromPosition(start!, toPosition:end!)
    var cursorOffset = textField.offsetFromPosition(beginning, toPosition:start!) + string.characters.count

    let checkResult = nbPictureMask.check(textField.text ?? "", shouldChangeCharactersInRange: range, replacementString: string)

    // User may disallow changes
    if let validate = validate {
      if !validate(sender: self, text: checkResult.text, status: checkResult.status) { return false }
    }

    // Check if mask is enforced
    if enforceMask {
      if checkResult.status == .NotOk { return false }
    }

    // Update text field
    textField.text = checkResult.text
    cursorOffset += checkResult.autoFillOffset
    let newCursorPosition = textField.positionFromPosition(textField.beginningOfDocument, offset:cursorOffset)
    let newSelectedRange = textField.textRangeFromPosition(newCursorPosition!, toPosition:newCursorPosition!)
    textField.selectedTextRange = newSelectedRange

    changed?(sender: self, text: checkResult.text, status: checkResult.status)
    return false
  }

  func textFieldDidEndEditing(textField: UITextField) {
  //----------------------------------------------------------------------------
    isEditing = false
  }

}
