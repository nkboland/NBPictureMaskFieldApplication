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

    pictureMask.mask = "#{#}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "{#}#"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "{#}#{#}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_groupingGroup() {
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

  func test_groupingSpecial() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "{#,}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "{,#}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "{#, ,.,;,,;;,:,;[,;],(,),}"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check(" ");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check(".");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check(",");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check(";");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check(":");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("[");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("]");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("(");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check(")");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
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
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
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
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    pictureMask.mask = "[#]#[#]"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
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

  func test_common() {
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

  func test_examples_unisgned_int() {
  //----------------------------------------------------------------------------
  // Unsigned integer

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "#*#"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("-123");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("ABC");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_examples_us_dates() {
  //----------------------------------------------------------------------------
  // US Dates

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "#[#]/#[#]/##[##]"
    retVal = pictureMask.check("1/1/01");     XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("01/1/01");    XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("1/01/01");    XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("1/1/2001");   XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("01/01/2001"); XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_timestamp() {
  //----------------------------------------------------------------------------
  // Timestamp

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "#[#]:#[#]:#[#] {AM,PM};, #[#]/#[#]/#[#]"
    retVal = pictureMask.check("1:1:1 AM, 1/1/01");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("01:11:11 PM, 1/1/01");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("01:11:11 AM, 01/01/01");  XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("01:11:11 XM, 01/01/01");  XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_examples_nmber_three_digits_or_less() {
  //----------------------------------------------------------------------------
  // Timestamp

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "#[#][#]"
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12A1");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_examples_first_letter_capitalized() {
  //----------------------------------------------------------------------------
  // First letter capitalized

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "&*?"
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Abc");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }

  func test_examples_us_phone_number_optional_area_code() {
  //----------------------------------------------------------------------------
  // US phone number with optional area code

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{*3{#}-*4{#},{(*3{#}) ,*3{#}-}*3{#}-*4{#}}"
    retVal = pictureMask.check("000-1234");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("000-111-2222");     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("(000) 111-2222");   XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }

  func test_examples_zip_optional_4() {
  //----------------------------------------------------------------------------
  // US zip code with optional +4

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "*5{#}[-*4#]"
    retVal = pictureMask.check("1234");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("12345-123");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345-1234");   XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }

  func test_examples_capitalized_words() {
  //----------------------------------------------------------------------------
  // Capitalized words

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "*[&[*?]]"
    retVal = pictureMask.check("Hi");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")

    pictureMask.mask = "*[&[*?]*[ ]]"
    retVal = pictureMask.check("Hi");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")

    pictureMask.mask = "*[&[*?]*[{#, ,.,;,,;;,:,;[,;],(,),}]]"
    retVal = pictureMask.check("Hi");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_International_test() {
  //----------------------------------------------------------------------------
  // International test

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "*[&[*?]*[{é,#, ,.,;,,;;,:,;[,;],(,),}]]"
    retVal = pictureMask.check("Hi");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_us_phone_number_required_area_code() {
  //----------------------------------------------------------------------------
  // US phone number with required area code

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{(*3{#}) ,*3{#}-, }*3{#}-*4{#}"
    retVal = pictureMask.check("333-888-9999");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_color_list_with_automatic_fill() {
  //----------------------------------------------------------------------------
  // Color list with automatic fill in

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{Red,Gr{ay,een},B{l{ack,ue},rown},White,Yellow}"
    retVal = pictureMask.check("Blue");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_yes_no() {
  //----------------------------------------------------------------------------
  // Yes or no

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{Yes,No}"
    retVal = pictureMask.check("Yes");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_floating_point() {
  //----------------------------------------------------------------------------
  // Floating point number

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]],({{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]),[-]{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]}"

    pictureMask.mask = "{{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]],({{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]),[-]{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]}"
    retVal = pictureMask.check("-0.01");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_international_floating_point() {
  //----------------------------------------------------------------------------
  // International floating point number

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]],({{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]),[-]{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]}"
    retVal = pictureMask.check("-0.01");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_icd_9_or_10() {
  //----------------------------------------------------------------------------
  // ICD-9 or -10

    let pictureMask = NBPictureMask()

    var retVal : NBPictureMask.CheckResult

    pictureMask.mask = "{X{X},Z{Z},{#,&}#{#,&}.[#,&][#,&][#,&][#,&]}"
    retVal = pictureMask.check("ZZ000.0000");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }
}
