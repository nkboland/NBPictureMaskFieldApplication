//
//  MainTableViewController.swift
//  NBPictureMaskField
//
//  Created by Nick Boland on 4/12/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
//------------------------------------------------------------------------------

  //--------------------
  // MARK: - Overrides

  override func viewDidLoad() {
  //----------------------------------------------------------------------------
    super.viewDidLoad()

    // Dismiss keyboard when tapping outside text field
    let tap = UITapGestureRecognizer(target: self, action: #selector(MainTableViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)

/*
    updateView(wasEdited: false)
    updateView()
*/
  }

  //--------------------
  // MARK: - Navigation

/*
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  //----------------------------------------------------------------------------
NSLog("Segue")
  }
*/

  override func didReceiveMemoryWarning() {
  //----------------------------------------------------------------------------
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func dismissKeyboard() {
  //----------------------------------------------------------------------------
    view.endEditing(true)
  }

}
