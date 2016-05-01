//
//  MainDesignTableViewController.swift
//  NBPictureMaskField
//
//  Created by Nick Boland on 4/12/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//

import UIKit

class MainDesignTableViewController: UITableViewController, UITextFieldDelegate {
//------------------------------------------------------------------------------

  @IBOutlet weak var maskStatusLabel: UILabel!
  @IBOutlet weak var maskTextField: UITextField!
  @IBOutlet weak var inputStatusLabel: UILabel!
  @IBOutlet weak var inputTextField: NBPictureMaskField!
  @IBOutlet weak var autoFillSwitch: UISwitch!
  @IBOutlet weak var enforceMaskSwitch: UISwitch!
  @IBOutlet weak var maskTreeLabel: UILabel!

  override func viewDidLoad() {
  //----------------------------------------------------------------------------
    super.viewDidLoad()

    // Configure table to automatically resize its rows in conjunction with tableView(_:heightForRowAtIndexPath:indexPath)
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension

    // Dismiss keyboard when tapping outside text field
    let tap = UITapGestureRecognizer(target: self, action: #selector(MainDesignTableViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)

    // We need to update things when field is edited
    maskTextField.delegate = self

    inputTextField.changed = inputTextFieldChanged

    // Load defaults
    loadDefaults(self)

    // Update any changes
    maskFieldEditingChanged(maskTextField)
  }

  override func didReceiveMemoryWarning() {
  //----------------------------------------------------------------------------
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
  //----------------------------------------------------------------------------
    return UITableViewAutomaticDimension
  }

  func loadDefaults(sender: AnyObject) {
  //----------------------------------------------------------------------------
    let defaults = NSUserDefaults.standardUserDefaults()
    maskTextField.text = defaults.stringForKey("maskTextField")
    autoFillSwitch.on = defaults.boolForKey("autoFillSwitch")
    enforceMaskSwitch.on = defaults.boolForKey("enforceMaskSwitch")

    inputTextField.mask = maskTextField.text ?? ""
    inputTextField.autoFill = autoFillSwitch.on
    inputTextField.enforceMask = enforceMaskSwitch.on

    inputTextField.text = defaults.stringForKey("inputTextField")
  }

  func saveDefaults(sender: AnyObject) {
  //----------------------------------------------------------------------------
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(maskTextField.text, forKey: "maskTextField")
    defaults.setBool(autoFillSwitch.on, forKey: "autoFillSwitch")
    defaults.setBool(enforceMaskSwitch.on, forKey: "enforceMaskSwitch")
    defaults.setObject(inputTextField.text, forKey: "inputTextField")
  }

  @IBAction func switchValueChanged(sender: AnyObject) {
  //----------------------------------------------------------------------------
    inputTextField.autoFill = autoFillSwitch.on
    inputTextField.enforceMask = enforceMaskSwitch.on
    saveDefaults(sender)
  }

  @IBAction func maskButtonAction(sender: AnyObject) {
  //----------------------------------------------------------------------------
    let button = sender as! UIButton
    inputTextField.text = ""
    maskTextField.text = button.titleLabel?.text
    maskFieldEditingChanged(maskTextField)
  }


  @IBAction func maskFieldEditingChanged(sender: AnyObject) {
  //----------------------------------------------------------------------------
  // Update things when the mask changes.

    let textField = sender as! UITextField
    let mask = textField.text ?? ""

    inputTextField.mask = mask
    let errMsg = inputTextField.maskErrMsg

    maskStatusLabel.text = errMsg ?? "Mask ok"
    maskTreeLabel.text = inputTextField.maskTreeToString

    tableView.reloadData()

    saveDefaults(sender)
  }

  func inputTextFieldChanged(sender: AnyObject, text: String, status: NBPictureMask.Status) {
  //----------------------------------------------------------------------------
  // Update things when the text changes.

    // Highlight the edit field background color
    if let textField = sender as? UITextField {
      switch (text, status) {
      case ("",    _):    textField.backgroundColor = UIColor.clearColor()
      case (_, .Ok):      textField.backgroundColor = UIColor.clearColor()
      case (_, .OkSoFar): textField.backgroundColor = UIColor.yellowColor()
      case (_, .NotOk):   textField.backgroundColor = UIColor.redColor()
      }
    }

    // Update the input status label
    if let pictureMaskField = sender as? NBPictureMaskField {
      let checkVal = pictureMaskField.check(text)
      switch (text, status) {
      case ("",    _):    inputStatusLabel.text = "No input"
      case (_, .Ok):      inputStatusLabel.text = "Ok"
      case (_, .OkSoFar): inputStatusLabel.text = "Ok so far"
      case (_, .NotOk):   inputStatusLabel.text = "Error: \(checkVal.errMsg ?? "")"
      }
    }

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
