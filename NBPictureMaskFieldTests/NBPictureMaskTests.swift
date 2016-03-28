//==============================================================================
//  NBPictureMaskTests.swift
//  NBPictureMaskField
//  GitHub: https://github.com/nkboland/NBPictureMaskField
//
//  Created by Nick Boland on 3/27/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//==============================================================================

import XCTest
@testable import NBPictureMaskField

class NBPictureMaskTests: XCTestCase {
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

  func test_basics() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = ""
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "#"
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "##"
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "#?"
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

  }

  func test_repetition() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "*#"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")

    pictureMask.mask = "*2#"
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "#*2#"
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "*2##"
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }
}
