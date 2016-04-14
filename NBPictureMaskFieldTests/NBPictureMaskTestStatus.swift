//==============================================================================
//  NBPictureMaskTestStatus.swift
//  NBPictureMaskField
//  GitHub: https://github.com/nkboland/NBPictureMaskField
//
//  Created by Nick Boland on 3/27/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//
//  OVERVIEW
//  --------
//  Test the status returned when setting the mask and checking text.
//==============================================================================

import XCTest
@testable import NBPictureMaskField

class NBPictureMaskTestStatus: XCTestCase {
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

  func test_mask_errors() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult

    maskVal = pictureMask.setMask("");      XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{");     XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("}");     XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[");     XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("]");     XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[}");    XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{]");    XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{}");    XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[]");    XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask(",");     XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("#,&");   XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{,}");   XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{*}");   XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{[*]}"); XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{#,}");  XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("{,#}");  XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[,]");   XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[*]");   XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[{*}]"); XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[#,]");  XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("[,#]");  XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("*");     XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("*1");    XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("*{");    XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask(";");     XCTAssertNotNil(maskVal.errMsg)
    maskVal = pictureMask.setMask("#;");    XCTAssertNotNil(maskVal.errMsg)
  }

  func test_basic() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("")
    XCTAssertNotNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(";");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("*");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("{");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("}");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("[");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("]");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("##")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("#?")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)

  }

  func test_literal() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask(";#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("#");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("##");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask(";;")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(";");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check(";;");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask(";,")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(",");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check(",A");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask(";#;&")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("#");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("#&");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("&#");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask(";[;]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("[");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("[]");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("[[");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("[}");       XCTAssert(retVal.status == .NotOk)
  }

  func test_simple() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("-")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("-");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("--");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("&-")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("AA");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("-&")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("-A");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("AA");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("&-&")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A-B");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A-BC");     XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("-&-")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("-A-");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("---");      XCTAssert(retVal.status == .NotOk)
  }

  func test_grouping() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("#{#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("{#}#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("{#}#{#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("[+,-]#*#[.*#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("+1");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("+1.");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-1.0");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123.456");  XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("{*#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(",");        XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("{;,###,*#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(",");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(",1");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(",12");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(",123");     XCTAssert(retVal.status == .Ok)
  }

  func test_grouping_group() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{R,G,B}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("R");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("G");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("RG");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("GB");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("{Red,Green,Blue}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("R");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Re");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Red");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Redd");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("G");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Gr");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Gree");     XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Green");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Greenn");   XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Blu");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Blue");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Bluee");    XCTAssert(retVal.status == .NotOk)
}

  func test_grouping_special() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{#, ,.,;,,;;,:,;[,;],(,)}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(" ");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(".");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(",");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(";");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(":");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("[");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("]");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("(");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(")");        XCTAssert(retVal.status == .Ok)
  }

  func test_grouping_optional() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{R[ed],G[reen],B[lue]}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("R");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Re");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Red");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Redd");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("G");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Gr");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Gree");     XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Green");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Greenn");   XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Blu");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Blue");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Bluee");    XCTAssert(retVal.status == .NotOk)
  }

  func test_repetition() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("#*#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("*2#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("#*2#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("*2##")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("*2#*2#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("{*#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("#{*#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("*[&]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("AA");       XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("#{&,*#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1AB");      XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("{#*#}E#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1E0");      XCTAssert(retVal.status == .Ok)
  }

  func test_optional() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("[#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("#[#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("[#]#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("[#]#[#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("[;,###,*#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(",");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(",1");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(",12");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check(",123");     XCTAssert(retVal.status == .Ok)
  }

  func test_optional_nested() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("[[#]&-]###[&]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123A");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A-123");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A-123A");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A-123");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A-123A");  XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A-1234");  XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12-123A");  XCTAssert(retVal.status == .NotOk)
  }

  func test_common() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("[[#]&-]###[&]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123A");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A-123");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A-123A");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A-123");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A-123A");  XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A-1234");  XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12-123A");  XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_unisgned_int() {
  //----------------------------------------------------------------------------
  // Unsigned integer

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#*#")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-123");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("ABC");      XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_us_dates() {
  //----------------------------------------------------------------------------
  // US Dates

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#[#]/#[#]/##[##]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1/1/01");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("01/1/01");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1/01/01");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1/1/2001");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("01/01/2001"); XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("{{{09,04,06,11}/{0{1,2,3,4,5,6,7,8,9},1#,2#,30}},{{01,03,05,07,08,10,12}/{0{1,2,3,4,5,6,7,8,9},1#,2#,30,31}},{02/{0{1,2,3,4,5,6,7,8,9},1#,20,21,22,23,24,25,26,27,28,29}}}/{19,20}##")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1/1/01");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("01/1/01");    XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("1/01/01");    XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("01/01/01");   XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("1/1/2001");   XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("01/01/2001"); XCTAssert(retVal.status == .Ok)
  }

  func test_examples_timestamp() {
  //----------------------------------------------------------------------------
  // Timestamp

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#[#]:#[#]:#[#] {AM,PM};, #[#]/#[#]/#[#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");                       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");                      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1:");                     XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1:1:1 A");                XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1:1:1 AM, 1/1/");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1:1:1 AM, 1/1/01");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("01:11:11 PM, 1/1/01");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("01:11:11 AM, 01/01/01");  XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("01:11:11 XM, 01/01/01");  XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_nmber_three_digits_or_less() {
  //----------------------------------------------------------------------------
  // Timestamp

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#[#][#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12A1");     XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_first_letter_capitalized() {
  //----------------------------------------------------------------------------
  // First letter capitalized

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("&*?")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("Abc");      XCTAssert(retVal.status == .Ok)
  }

  func test_examples_zip_optional_4() {
  //----------------------------------------------------------------------------
  // US zip code with optional +4

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*5{#}[-*4#]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1234");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("12345");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123456");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("12345-123");    XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("12345-1234");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12345-12345");  XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_capitalized_words() {
  //----------------------------------------------------------------------------
  // Capitalized words

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*[&[*?]*[ ]]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("Hi");                     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A B");                    XCTAssert(retVal.status == .Ok)

    maskVal = pictureMask.setMask("*[&[*?]*[{#, ,.,;,,;;,:,;!,;[,;],(,)}]]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("Hi");                     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A B");                    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Hi There.");              XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Hi. How Are You. (Ok)");  XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Hi. How Are You? (Ok)");  XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_International_test() {
  //----------------------------------------------------------------------------
  // International test

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*[&[*?]*[{é,#, ,.,;,,;;,:,;[,;],(,)}]]")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("Hi");       XCTAssert(retVal.status == .Ok)
  }

  func test_examples_us_phone_number() {
  //----------------------------------------------------------------------------
  // US phone number

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{(*3{#}) ,*3{#}-}*3{#}-*4{#}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");                 XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");                XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("(");                XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-");             XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-456-789");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-456-7890");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("(123) 456-789");    XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("(123) 456-7890");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("(123)456-7890");    XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("(123) 456-78901");  XCTAssert(retVal.status == .NotOk)

    maskVal = pictureMask.setMask("{*3{#}-*4{#},{(*3{#}) ,*3{#}-}*3{#}-*4{#}}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");                 XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("1");                XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("(");                XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-");             XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-456");          XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-4567");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123-45678");        XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123-456-78");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-4567-8");       XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("123-456-789");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("123-456-7890");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("(123) ");           XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("(123) 456-");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("(123) 456-789");    XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("(123) 456-7890");   XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("(123)456-7890");    XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("(123) 456-78901");  XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_color_list_with_automatic_fill() {
  //----------------------------------------------------------------------------
  // Color list with automatic fill in

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{Red,Gr{ay,een},B{l{ack,ue},rown},White,Yellow}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Bl");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Bla");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Black");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Blu");      XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Blue");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Br");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Brown");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("Browny");   XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("Y");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Ylow");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("Yellow");   XCTAssert(retVal.status == .Ok)
  }

  func test_examples_yes_no() {
  //----------------------------------------------------------------------------
  // Yes or no

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{Yes,No}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Y");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Ye");       XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("Yes");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("YesA");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("N");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("No");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("NoA");      XCTAssert(retVal.status == .NotOk)
  }

  func test_examples_floating_point() {
  //----------------------------------------------------------------------------
  // Floating point number

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask(
                "{{{#[#][#][;,###*[;,###],*#][.*#]},.#*#}[E[[+,-]#[#][#]]],({{#[#][#][;,###*[;,###],*#][.*#]},.#*#}[E[[+,-]#[#][#]]]),[-]{{#[#][#][;,###*[;,###],*#][.*#]},.#*#}[E[[+,-]#[#][#]]]}")

    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("1");            XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12");           XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123");          XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12345");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1,234");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("12345");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1,234.5");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1,234,567.89"); XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("0.0");          XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("0..0");         XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("0.0.");         XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check(".0");           XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(".01");          XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check(".012");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1E0");          XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-1E0");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1E-0");         XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-1E-0");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-0E-0");        XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-0.E-0");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("-0.E-0.");      XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("1234E1");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234E+12");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1234E-123");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1,234E1");      XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1,234E+12");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1,234E-123");   XCTAssert(retVal.status == .Ok)
  }

  func test_examples_icd_9_or_10() {
  //----------------------------------------------------------------------------
  // ICD-9 or -10

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskResult
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{X{X},Z{Z},{#,&}#{#,&}.[#,&][#,&][#,&][#,&]}")
    XCTAssertNil(maskVal.errMsg)
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("X");        XCTAssert(retVal.status == .OkSoFar)
    retVal = pictureMask.check("XX");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("ZZ");       XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123.");     XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123.1");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("123.A");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("A1B.1");    XCTAssert(retVal.status == .Ok)
    retVal = pictureMask.check("1A3.1");    XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotOk)
    retVal = pictureMask.check("A1B.A1B2"); XCTAssert(retVal.status == .Ok)
  }
}
