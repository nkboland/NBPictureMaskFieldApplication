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

  func test_basic() {
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

  func test_literal() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "-"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("-");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("--");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "&-"
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("-A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("AA");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "-&"
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("-A");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("AA");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "&-&"
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-B");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A-BC");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "-&-"
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("-A-");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("---");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_grouping() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{#}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_groupingSeparator() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{R,G,B}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("R");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("G");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("RG");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("GB");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "{Red,Green,Blue}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("R");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Re");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Red");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Redd");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("G");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Gr");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Gree");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Green");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Greenn");   XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Blu");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Blue");     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Bluee");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_groupingSeparatorOptional() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{R[ed],G[reen],B[lue]}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("R");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Re");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Red");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Redd");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("G");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Gr");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Gree");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Green");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Greenn");   XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Blu");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Blue");     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Bluee");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
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

    pictureMask.mask = "*2#*2#"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_optional() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "[#]"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "#[#]"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "[#]#"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "[#]#[#]"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }

  func test_optionalNested() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "[[#]&-]###[&]"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123A");     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A-123");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A-123A");   XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A-123");   XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A-123A");  XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A-1234");  XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12-123A");  XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

}
