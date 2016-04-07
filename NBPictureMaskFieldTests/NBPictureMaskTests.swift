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

  func test_mask_errors() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError

    maskVal = pictureMask.setMask("");      XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("{");     XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("}");     XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("[");     XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("]");     XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("[}");    XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("{]");    XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("{}");    XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("[]");    XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("{,}");   XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("{#,}");  XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("{,#}");  XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("[,]");   XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("[#,]");  XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("[,#]");  XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("*");     XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("*1");    XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask(";");     XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
    maskVal = pictureMask.setMask("#;");    XCTAssert(maskVal.errMsg != nil,   maskVal.errMsg ?? "")
  }

  func test_basic() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("")
    XCTAssert(maskVal.errMsg != nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("##")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("#?")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

  }

  func test_literal() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("-")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("-");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("--");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("&-")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("-A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("AA");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("-&")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("-A");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("AA");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("&-&")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-B");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A-BC");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("-&-")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A-");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("-A-");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("---");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_grouping() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{#}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("#{#}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("{#}#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("{#}#{#}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_grouping_group() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{R,G,B}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("R");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("G");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("B");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("RG");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("GB");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("{Red,Green,Blue}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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

  func test_grouping_special() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{#, ,.,;,,;;,:,;[,;],(,)}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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

  func test_grouping_optional() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{R[ed],G[reen],B[lue]}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("*2#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("#*2#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("*2##")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("*2#*2#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("[#]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("#[#]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("[#]#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("[#]#[#]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_optional_nested() {
  //----------------------------------------------------------------------------

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("[[#]&-]###[&]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("[[#]&-]###[&]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#*#")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("-123");     XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("ABC");      XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_examples_us_dates() {
  //----------------------------------------------------------------------------
  // US Dates

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#[#]/#[#]/##[##]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#[#]:#[#]:#[#] {AM,PM};, #[#]/#[#]/#[#]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1:1:1 AM, 1/1/01");       XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("01:11:11 PM, 1/1/01");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("01:11:11 AM, 01/01/01");  XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("01:11:11 XM, 01/01/01");  XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_examples_nmber_three_digits_or_less() {
  //----------------------------------------------------------------------------
  // Timestamp

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("#[#][#]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
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
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("&*?")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1");       XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("Abc");      XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }

  func test_examples_us_phone_number_optional_area_code() {
  //----------------------------------------------------------------------------
  // US phone number with optional area code

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{*3{#}-*4{#},{(*3{#}) ,*3{#}-}*3{#}-*4{#}}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("000-1234");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("000-111-2222");     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("(000) 111-2222");   XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }

  func test_examples_zip_optional_4() {
  //----------------------------------------------------------------------------
  // US zip code with optional +4

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*5{#}[-*4#]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1234");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("12345-123");    XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345-1234");   XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }

  func test_examples_capitalized_words() {
  //----------------------------------------------------------------------------
  // Capitalized words

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*[&[*?]*[{#, ,.,;,,;;,:,;[,;],(,)}]]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("Hi");                     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A B");                    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Hi There.");              XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Hi. How Are You. (Ok)");  XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("Hi. How Are You? (Ok)");  XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
  }

  func test_examples_International_test() {
  //----------------------------------------------------------------------------
  // International test

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("*[&[*?]*[{é,#, ,.,;,,;;,:,;[,;],(,)}]]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("Hi");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_us_phone_number_required_area_code() {
  //----------------------------------------------------------------------------
  // US phone number with required area code

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{(*3{#}) ,*3{#}-, }*3{#}-*4{#}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("333-888-9999");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_color_list_with_automatic_fill() {
  //----------------------------------------------------------------------------
  // Color list with automatic fill in

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{Red,Gr{ay,een},B{l{ack,ue},rown},White,Yellow}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("Blue");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_yes_no() {
  //----------------------------------------------------------------------------
  // Yes or no

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{Yes,No}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("Yes");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_floating_point() {
  //----------------------------------------------------------------------------
  // Floating point number

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{#[#][#][.*#]}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("0.0");          XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123.0");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("123.45678");    XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123..45678");   XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask( "{#[#][#]{{;,###*[;,###]},*#}[.*#]}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1,234");        XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("12345");        XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("1,234.5");      XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("1,234,567.89"); XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check(".0");           XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check(".01");          XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check(".012");         XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1,234E2");      XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("1,234E+20");    XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("1,234E-30");    XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")

    maskVal = pictureMask.setMask("{{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]],({{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]),[-]{{#[#][#]{{;,###*[;,###]},*#}[.*#]},.#*#}[E[[+,-]#[#][#]]]}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("1,234");        XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
    retVal = pictureMask.check("1,234.0");      XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
//    retVal = pictureMask.check("1,234.0E01");      XCTAssert(retVal.status == .Match, retVal.errMsg ?? "")
  }

  func test_examples_icd_9_or_10() {
  //----------------------------------------------------------------------------
  // ICD-9 or -10

    let pictureMask = NBPictureMask()
    var maskVal: NBPictureMask.MaskError
    var retVal: NBPictureMask.CheckResult

    maskVal = pictureMask.setMask("{X{X},Z{Z},{#,&}#{#,&}.[#,&][#,&][#,&][#,&]}")
    XCTAssert(maskVal.errMsg == nil, maskVal.errMsg ?? "")
    retVal = pictureMask.check("X");            XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("XX");           XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("ZZ");           XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123.");         XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123.1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("123.A");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("A1B.1");        XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
    retVal = pictureMask.check("1A3.1");        XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("1234");         XCTAssert(retVal.status == .NotGood, retVal.errMsg ?? "")
    retVal = pictureMask.check("A1B.A1B2");     XCTAssert(retVal.status == .Match,   retVal.errMsg ?? "")
  }
}
