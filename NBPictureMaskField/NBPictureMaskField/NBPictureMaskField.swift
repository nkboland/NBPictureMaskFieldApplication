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

//--------------------
// MARK: - NBPictureMaskField

class NBPictureMaskField: UITextField {
//------------------------------------------------------------------------------

  //--------------------
  // Saved properties

  var localMask: String!

  required init?(coder aDecoder: NSCoder) {
  //----------------------------------------------------------------------------
    super.init(coder: aDecoder)
//    self.maskObject = [NBPictureMaskFieldBlock]()
    //    fatalError("init(coder:) has not been implemented")
  }

  deinit {
  //----------------------------------------------------------------------------
    removeObserver(self, forKeyPath: "text")
  }

  //--------------------
  // MARK: - Displaying mask

  @IBInspectable var mask: String {
  //----------------------------------------------------------------------------
    get { return localMask }
    set { localMask = newValue }
  }

  //--------------------
  // MARK: - Draw

  override func drawRect(rect: CGRect) {
  //----------------------------------------------------------------------------
  // This is used as a way to get an observer on "text".

    super.drawRect(rect)

    // This observer used on manual updatind text property
    delegate = self
    addObserver(self, forKeyPath: "text", options: [], context: nil)
  }

}

//--------------------
// MARK: - Observers

extension NBPictureMaskField {
//------------------------------------------------------------------------------

  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
  //----------------------------------------------------------------------------

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
    return true;
  }

}
