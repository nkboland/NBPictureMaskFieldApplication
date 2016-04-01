//
//  ViewController.swift
//  NBPictureMaskField
//
//  Created by Nick Boland on 3/27/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let nbPictureMask = NBPictureMask()

  @IBOutlet weak var maskStatusLabel: UILabel!
  @IBOutlet weak var textStatusLabel: UILabel!
  @IBOutlet weak var autoFillSwitch: UISwitch!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func maskFieldEditingChanged(sender: AnyObject) {
    let textField = sender as! UITextField
    let mask = textField.text ?? ""
    let retVal = nbPictureMask.parseMask(mask)
    let errMsg = retVal.errMsg ?? "Mask is valid"
    maskStatusLabel.text = errMsg
  }

}

