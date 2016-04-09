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
  @IBOutlet weak var enforceMaskSwitch: UISwitch!
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

    // Load defaults
    loadDefaults(self)

    // Update any changes
    maskFieldEditingChanged(maskTextField)
    textFieldEditingChanged(inputTextField)
  }

  override func didReceiveMemoryWarning() {
  //----------------------------------------------------------------------------
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func loadDefaults(sender: AnyObject) {
  //----------------------------------------------------------------------------
    let defaults = NSUserDefaults.standardUserDefaults()
    enforceMaskSwitch.on = defaults.boolForKey("enforceMaskSwitch")
    autoFillSwitch.on = defaults.boolForKey("autoFillSwitch")
    maskTextField.text = defaults.stringForKey("maskTextField")
    inputTextField.text = defaults.stringForKey("inputTextField")

    inputTextField.enforceMask = enforceMaskSwitch.on
  }

  @IBAction func saveDefaults(sender: AnyObject) {
  //----------------------------------------------------------------------------
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(enforceMaskSwitch.on, forKey: "enforceMaskSwitch")
    defaults.setBool(autoFillSwitch.on, forKey: "autoFillSwitch")
    defaults.setObject(maskTextField.text, forKey: "maskTextField")
    defaults.setObject(inputTextField.text, forKey: "inputTextField")

    inputTextField.enforceMask = enforceMaskSwitch.on
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

    saveDefaults(sender)
  }

  @IBAction func textFieldEditingChanged(sender: AnyObject) {
  //----------------------------------------------------------------------------
  // Update things when the text changes.

    let retVal = inputTextField.check(inputTextField.text ?? "")

    let str : String

    switch retVal.status {
    case .NotOk :     str = "Error: \(retVal.errMsg ?? "")"
    case .OkSoFar :   str = "Ok so far"
    case .Ok :        str = "Ok"
    }

    inputStatusLabel.text = str

    saveDefaults(sender)
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