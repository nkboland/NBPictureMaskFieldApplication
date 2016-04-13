//
//  Design2TableViewController.swift
//  NBPictureMaskField
//
//  Created by Nick Boland on 4/12/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//

import UIKit

class Design2TableViewController: UITableViewController {

  @IBOutlet weak var maskTreeTableViewCell: UITableViewCell!
  @IBOutlet weak var maskTreeLabel: UILabel!

  override func viewDidLoad() {
  //----------------------------------------------------------------------------
    super.viewDidLoad()

    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 144.0

//    maskTreeLabel.text = "This\nIs\nA\nTest\nTo\nSee"

  }

  override func didReceiveMemoryWarning() {
  //----------------------------------------------------------------------------
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
}
