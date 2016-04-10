//==============================================================================
//  NBPictureMaskTestAutoFill.swift
//  NBPictureMaskField
//
//  Created by Nick Boland on 4/10/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//
//  GitHub: https://github.com/nkboland/NBPictureMaskField
//
//  OVERVIEW
//  --------
//  Test the auto fill feature of text input.
//==============================================================================

import XCTest
@testable import NBPictureMaskField

class NBPictureMaskTestAutoFill: XCTestCase {
//------------------------------------------------------------------------------

  override func setUp() {
  //----------------------------------------------------------------------------
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
  //----------------------------------------------------------------------------
  // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func test_basic() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("(###) ###-####")
    XCTAssertNil(maskVal.errMsg)
    pictureMask.setAutoFill(true)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok);      XCTAssert(retVal.text == "(")
    retVal = pictureMask.check(" ");        XCTAssert(retVal.status == .Ok);      XCTAssert(retVal.text == "(")
  }

}