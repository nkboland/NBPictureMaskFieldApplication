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
//  Mask -  This defines what the field will accept. Groups can be created
//          inside { }. These letters indicate the following format:
//
//            d = digits 0..9
//            D = anything other than 0..9
//            a = a..z, A..Z
//            W = anything other than a..z, A..Z
//            . = anything (default)
//
//            Examples
//            {dddd}-{DDDD}-{WaWa}-{aaaa}   would allow 0123-AbCd-0a2b-XxYy
//
//  Template -  This is used to fill in the mask for displaying.
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

  required init?(coder aDecoder: NSCoder) {
  //----------------------------------------------------------------------------
    nbPictureMask = NBPictureMask()
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
    get {
      return nbPictureMask.getMask()
    }
    set {
      let retVal = nbPictureMask.setMask(newValue)
      maskErrMsg = retVal.errMsg
    }
  }

  var maskErrorMessage: String? {
  //----------------------------------------------------------------------------
  // Returns the error message for the current mask, otherwise nil.

    get {
      return maskErrMsg
    }
  }

  var maskTreeToString: String {
  //----------------------------------------------------------------------------
  // Returns the parsed mask tree as a string.

    get {
      return nbPictureMask.maskTreeToString()
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

    NSLog("TextField text:\(textField.text) range:\(range) string:\(string)")

    let currentText = textField.text ?? ""
    let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
    NSLog("TextField prospectiveText:\(prospectiveText)")

    return true
/*
    let retVal = nbPictureMask.check(prospectiveText)

    if retVal.status == .Match {
      return true
    } else {
      return false
    }
*/
  }

}
