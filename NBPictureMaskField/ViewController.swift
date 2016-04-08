//
//  ViewController.swift
//  NBPictureMaskField
//
//  Created by Nick Boland on 3/27/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
//------------------------------------------------------------------------------

  @IBOutlet weak var maskStatusLabel: UILabel!
  @IBOutlet weak var maskTextField: UITextField!
  @IBOutlet weak var inputStatusLabel: UILabel!
  @IBOutlet weak var inputTextField: NBPictureMaskField!
  @IBOutlet weak var autoFillSwitch: UISwitch!
  @IBOutlet weak var maskTreeLabel: UILabel!

  override func viewDidLoad() {
  //----------------------------------------------------------------------------
    super.viewDidLoad()

    // Dismiss keyboard when tapping outside text field
    let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)

    // We need to update things when field is edited
    maskTextField.delegate = self

    // Reflect current input mask value
    maskTextField.text = inputTextField.mask
    maskFieldEditingChanged(maskTextField)
  }

  override func didReceiveMemoryWarning() {
  //----------------------------------------------------------------------------
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func maskFieldEditingChanged(sender: AnyObject) {
  //----------------------------------------------------------------------------
  // Update lots of things when the mask changes.

    let textField = sender as! UITextField
    let mask = textField.text ?? ""

    inputTextField.mask = mask
    let errMsg = inputTextField.maskErrMsg

    maskStatusLabel.text = errMsg ?? "Mask ok"
    maskTreeLabel.text = inputTextField.maskTreeToString
  }

  @IBAction func textFieldEditingChanged(sender: AnyObject) {
  //----------------------------------------------------------------------------
  // Update things when the text changes.

    let retVal = inputTextField.check(inputTextField.text ?? "")

    let str : String

    switch retVal.status {
    case .NotOk :     str = "Not ok"
    case .OkSoFar :   str = "Ok so far"
    case .Ok :        str = "Ok"
    }

    inputStatusLabel.text = "\(str) \(retVal.errMsg ?? "")"
  }

  func dismissKeyboard() {
  //----------------------------------------------------------------------------
    view.endEditing(true)
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
  //----------------------------------------------------------------------------
    dismissKeyboard()
    return false
  }
}