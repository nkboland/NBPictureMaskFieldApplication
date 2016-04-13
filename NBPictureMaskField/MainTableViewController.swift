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
/*
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SimulatorConfigTVC.dismissKeyboard))
    view.addGestureRecognizer(tap)

    updateView(wasEdited: false)
    updateView()
*/
  }

  override func didReceiveMemoryWarning() {
  //----------------------------------------------------------------------------
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  //----------------------------------------------------------------------------

  }

}
