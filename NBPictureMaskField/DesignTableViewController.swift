//
//  DesignTableViewController.swift
//  NBPictureMaskField
//
//  Created by Nick Boland on 4/12/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//

//  {{{09,04,06,11}/{0{1,2,3,4,5,6,7,8,9},1#,2#,30}},{{01,03,05,07,08,10,12}/{0{1,2,3,4,5,6,7,8,9},1#,2#,30,31}},{02/{0{1,2,3,4,5,6,7,8,9},1#,20,21,22,23,24,25,26,27,28,29}}}/{19,20}##

import UIKit

class DesignTableViewController: UITableViewController, UITextFieldDelegate {
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

    // Configure table to automatically resize its rows in conjunction with tableView(_:heightForRowAtIndexPath:indexPath)
    tableView.estimatedRowHeight = 68.0
    tableView.rowHeight = UITableViewAutomaticDimension

    // Dismiss keyboard when tapping outside text field
    let tap = UITapGestureRecognizer(target: self, action: #selector(DesignTableViewController.dismissKeyboard))
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

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
  //----------------------------------------------------------------------------
    return UITableViewAutomaticDimension
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
    inputTextField.autoFill = autoFillSwitch.on
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
  // Update lots of things when the mask changes.

    let textField = sender as! UITextField
    let mask = textField.text ?? ""

    inputTextField.mask = mask
    let errMsg = inputTextField.maskErrMsg

    maskStatusLabel.text = errMsg ?? "Mask ok"
    maskTreeLabel.text = inputTextField.maskTreeToString

    tableView.reloadData()

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
