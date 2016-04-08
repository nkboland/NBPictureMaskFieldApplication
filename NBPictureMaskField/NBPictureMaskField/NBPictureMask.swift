//==============================================================================
//  NBPictureMask.swift
//  NBPictureMaskField
//  GitHub: https://github.com/nkboland/NBPictureMaskField
//
//  Created by Nick Boland on 3/27/16.
//  Copyright © 2016 Nick Boland. All rights reserved.
//
//------------------------------------------------------------------------------
//
//  OVERVIEW
//  --------
//
//  This is allows a person to specify what may be entered in a text field.
//
//  The "mask" uses the following special characters:
//
//    #     Any digit 0..9
//    ?     Any letter a..z or A..Z
//    &     Any letter a..z or A..Z which is automatically converted to uppercase
//    ~     Any letter a..z or A..Z which is automatically converted to lowercase
//    @     Any character
//    !     Any character which is automatically converted to uppercase
//    ;     The next character is taken literally
//    *     Repeat the specified number of times
//    {a,b} Grouping operation
//    [a,b] Optional sequence of characters
//
//  Note - The mask is matched left to right. You must be careful to avoid
//         situations where one element is completely contained in another.
//
//  Grouping {a,b}
//  --------------
//
//  Each group is examined left to right. The first group that matches
//  will be used. Two or more groups are separated with a comma.
//
//  Optional [a,b]
//  --------------
//
//  This is similar to the grouping operation but the characters are not
//  required. Two or more optional items are separated with a comma.
//
//  Repeat *
//  --------
//
//  The symbol following the repeat character is optionally repeated
//  any number of times. If a numeric value is specified then it must
//  match that exact number of times.
//
//  Examples
//  --------
//
//  #                 One digit
//  ##                Two digits
//  *5#               Five digits
//  #*#               One digit followed by any number of other digits
//  #&                Single digit followed by single character converted to uppercase
//  #[#]              One or two digits
//  #*4[#]            One to five digits
//  {#,&}             Digit or character converted to uppercase
//  #####[-####]      Zipcode with optional plus four
//  [+,-]#*#[.*#]     1, +1, +1., -1.0, 123.456
//
//  TO DO
//  -----
//
//  1. Auto fill implementation.
//  2. Text checking error message.
//  3. Capitalization and text replacement.
//
//==============================================================================

import Foundation

class NBPictureMask {
//------------------------------------------------------------------------------

  //--------------------
  // MARK: - Public

  typealias MaskResult = (index: Int, errMsg: String?)
  //--------------------
  // This is returned when setting the mask.

  enum CheckStatus {
  //--------------------
  // These are the different outcomes that may result when checking text.
    case
      NotOk,                                  // The check has failed
      OkSoFar,                                // The check is ok so far
      Ok                                      // The check is ok
  }

  typealias CheckResult = (index: Int, status: CheckStatus, errMsg: String?)
  //--------------------
  // This is returned when checking the text.

  //--------------------
  // MARK: - Constants

  private struct kMask {
    static let digit          : Character = "#"
    static let letter         : Character = "?"
    static let letterToUpper  : Character = "&"
    static let letterToLower  : Character = "~"
    static let anyChar        : Character = "@"
    static let anyCharToUpper : Character = "!"
    static let escape         : Character = ";"
    static let repetition     : Character = "*"
    static let optional       : Character = "["
    static let optionalEnd    : Character = "]"
    static let grouping       : Character = "{"
    static let groupingEnd    : Character = "}"
    static let group          : Character = ","
  }

  //--------------------
  // MARK: - Types

  private enum NodeType {
  //--------------------
  // A node must be one of these types.

    case
      Root,                                   //     Root node
      Digit,                                  //  #  Any digit 0..9
      Letter,                                 //  ?  Any letter a..z or A..Z
      LetterToUpper,                          //  &  Any letter a..z or A..Z converted to uppercase
      LetterToLower,                          //  ~  Any letter a..z or A..Z converted to lowercase
      AnyChar,                                //  @  Any character
      AnyCharToUpper,                         //  !  Any character converted to uppercase
      Literal,                                //  ;  Literal character
      Repeat,                                 //  *  Repeat any number of times - Example: *& or *3#
      Optional,                               //  [  Optional sequence of characters - Example: [abc]
      OptionalEnd,                            //  ]  Optional end
      Grouping,                               //  {  Grouping - Example: {R,G,B} or {R[ed],G[reen],B[lue]}
      GroupingEnd,                            //  }  Grouping end
      Group                                   //  ,  Group - Example: {Group1,Group2}
  }

  private struct Node {
  //--------------------

    var type    : NodeType = .Root            // Node type indicates how it should be handled
    var value   : Int = 0                     // Repeat (count)
    var literal : Character = " "             // Literal character
    var str     : String = ""                 // Mask represented by this node used for debugging
    var nodes   : [Node] = [Node]()           // Child nodes (branches)
   }

  //--------------------
  // MARK: - Variables

  private var mask = [Character]()            // Input mask
  private var text = [Character]()            // Input text

  private var rootNode = Node()               // Mask root node

  //--------------------
  // MARK: - Helper Methods

  class func isDigit( c : Character ) -> Bool {
  //----------------------------------------------------------------------------
  // Returns true if characer is 0..9 otherwise false.

    switch c {
    case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" : return true
    default : return false
    }
  }

  class func isLetter( c : Character ) -> Bool {
  //----------------------------------------------------------------------------
  // Returns true if characer is A..Z, a..z otherwise false.

    switch c {
    case "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z": return true
    case "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z": return true
    default : return false
    }
  }

  class func isLower( c : Character ) -> Bool {
  //----------------------------------------------------------------------------
  // Returns true if characer is a..z otherwise false.

    switch c {
    case "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z": return true
    default : return false
    }
  }

  class func isUpper( c : Character ) -> Bool {
  //----------------------------------------------------------------------------
  // Returns true if characer is A..Z, a..z otherwise false.

    switch c {
    case "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z": return true
    default : return false
    }
  }

  class func lastDot( s : String ) -> String {
  //----------------------------------------------------------------------------
  // Returns last element of a string separated by dots (period).
    return s.componentsSeparatedByString(".").last ?? "unknown"
  }

  func getMask() -> String {
  //----------------------------------------------------------------------------
    return String(mask)
  }

  func setMask(mask: String) -> MaskResult {
  //----------------------------------------------------------------------------
    rootNode = Node()
    self.mask = Array(mask.characters)
    return parseMask(&rootNode )
  }

  private func parseMask(inout node: Node) -> MaskResult {
  //----------------------------------------------------------------------------
  // Parse the mask and create the tree root.

    var i = 0
    while i < mask.count {
      let retVal = parseMask(i, node: &node)
      i = retVal.index
      if retVal.errMsg != nil { return retVal }
    }
    if node.nodes.count == 0 { return(0, "No mask") }
    return (0, nil)
  }

  private func parseMask(index: Int, inout node: Node) -> MaskResult {
  //----------------------------------------------------------------------------
  // This parses the current picture mask.
  //
  //  Gobal Inputs:
  //    mask    Mask being parsed
  //
  //  Parameter Inputs:
  //    index   Index into the mask currently being examined
  //    node    Array of nodes to be built upon
  //
  // Returns:
  //    index   Next index into the mask that should be examined
  //    errMsg  nil if everything is ok otherwise an isOk    True

    var i = index

    // Nothing to parse
    guard i < mask.count else {
      return (i, nil )
    }

    // Create a node that will be added to the tree

    var n = Node()

    // Look at the current character to see what type it is

    var t : NodeType

    var c = mask[i]
    n.str.append(c)

    // Escape takes the next character as a literal

    if c == kMask.escape {

      i += 1
      guard i < mask.count else {
        return (i, "Escape is last character")
      }
      c = mask[i]
      n.str.append(c)
      t = .Literal

    } else {

      switch c {
      case kMask.digit          : t = .Digit
      case kMask.letter         : t = .Letter
      case kMask.letterToUpper  : t = .LetterToUpper
      case kMask.letterToLower  : t = .LetterToLower
      case kMask.anyChar        : t = .AnyChar
      case kMask.anyCharToUpper : t = .AnyCharToUpper
      case kMask.repetition     : t = .Repeat
      case kMask.optional       : t = .Optional
      case kMask.optionalEnd    : t = .OptionalEnd
      case kMask.grouping       : t = .Grouping
      case kMask.groupingEnd    : t = .GroupingEnd
      case kMask.group          : t = .Group
      default                   : t = .Literal
      }

    }

    //--------------------

    switch t {

    //--------------------

    case .Digit,
         .Letter,
         .LetterToUpper,
         .LetterToLower,
         .AnyChar,
         .AnyCharToUpper :

      n.type = t
      n.literal = c
      node.nodes.append(n)
      return (i+1, nil)

    //--------------------

    case .Literal :

      n.type = .Literal
      n.literal = c
      node.nodes.append(n)
      return (i+1, nil)

    //--------------------

    case .Root :

      return (i+1, nil)       // Should never happen

    //--------------------
    // Repeat *# or *2# or *2[#]

    case .Repeat :

      var numStr = ""

      repeat {

        i += 1
        guard i < mask.count else {
          return (i, "Repetition is last character")
        }

        c = mask[i]
        n.str.append(c)

        if NBPictureMask.isDigit(c) {
          numStr += String(c)
        }

      } while NBPictureMask.isDigit(c)

      n.str = String(n.str.characters.dropLast())

      let retVal = parseMask(i, node: &n)
      i = retVal.index

      guard retVal.errMsg == nil else { return(retVal) }

      n.type = .Repeat
      n.literal = "*"
      n.value = Int( numStr ) ?? 0
      node.nodes.append(n)
      return (i, nil)

    //--------------------
    // Grouping {} or {#} or {#,?} or {R,G,B}

    case .Grouping :

      n.type = .Grouping
      n.literal = kMask.grouping

      let i1 = i

      repeat {

        i += 1

        var g = Node()

        let i2 = i

        repeat {

          g.type = .Group
          g.literal = kMask.group

          let retVal = parseMask(i, node: &g)
          i = retVal.index

          guard i < mask.count else { return(i, "Grouping is missing '\(kMask.groupingEnd)'") }
          guard g.nodes.count > 0 else { return(i, "Group missing elements") }
          guard retVal.errMsg == nil else { return(retVal) }

        } while mask[i] != kMask.group && mask[i] != kMask.groupingEnd

        for x in i2 ..< i {
          g.str.append(mask[x])
        }

        n.nodes.append(g)

      } while mask[i] == kMask.group

      for x in i1+1 ... i {
        n.str.append(mask[x])
      }

      node.nodes.append(n)
      return (i+1, nil)

    //--------------------
    // Optional [] or [#] or [#,?] or [R,G,B]

    case .Optional :

      n.type = .Optional
      n.literal = kMask.optional

      let i1 = i

      repeat {

        i += 1

        let i2 = i

        var g = Node()

        repeat {

          g.type = .Group
          g.literal = kMask.group

          let retVal = parseMask(i, node: &g)
          i = retVal.index

          guard i < mask.count else { return(i, "Optional is missing '\(kMask.optionalEnd)'") }
          guard g.nodes.count > 0 else { return(i, "Optional missing elements") }
          guard retVal.errMsg == nil else { return(retVal) }

        } while mask[i] != kMask.group && mask[i] != kMask.optionalEnd
        
        for x in i2 ..< i {
          g.str.append(mask[x])
        }

        n.nodes.append(g)

      } while mask[i] == kMask.group

      for x in i1+1 ... i {
        n.str.append(mask[x])
      }

      node.nodes.append(n)
      return (i+1, nil)

    //--------------------
    // Group with no body {} or {#,}

    case .GroupingEnd :

      return (i, "Grouping is missing '\(kMask.grouping)'")

    //--------------------
    // Group with no body {,#} or [,#]

    case .Group :

      return (i, "Group '\(kMask.group)' is incomplete")

    //--------------------
    // Optional with no body [] or [#,]

    case .OptionalEnd :

      return (i, "Optional is missing '\(kMask.optional)'")
    }

  }

  func maskTreeToString() -> String {
  //----------------------------------------------------------------------------
  // Prints the mask tree structure for debugging purposes.

    var lines = [String]()

    lines.append("MASK TREE '\(mask)'")
    NBPictureMask.printMaskTree(&lines, index: 0, node: rootNode)
    lines.append("MASK TREE FINISHED")

    return lines.joinWithSeparator("\n")
  }

  private class func printMaskTree(inout lines: [String], index: Int, node: Node) {
  //----------------------------------------------------------------------------
  // Prints the mask tree structure for debugging purposes.

    var pad = ""
    for _ in 0..<index { pad += "  " }

    for n in node.nodes {
      switch n.type {
      case .Digit,
           .Letter,
           .LetterToUpper,
           .LetterToLower,
           .AnyChar,
           .AnyCharToUpper,
           .Literal :
        lines.append("\(pad)\(NBPictureMask.lastDot(String(n.type))) '\(n.str)'")
      case .Root :
        break
      case .Repeat :
        lines.append("\(pad)\(NBPictureMask.lastDot(String(n.type))) '\(n.str)'")
        printMaskTree(&lines, index: index+1, node: n)
      case .Grouping,
           .GroupingEnd,
           .Optional,
           .OptionalEnd,
           .Group :
        lines.append("\(pad)\(NBPictureMask.lastDot(String(n.type))) '\(n.str)'")
        printMaskTree(&lines, index: index+1, node: n)
      }
    }
  }

  func check(text: String) -> CheckResult {
  //----------------------------------------------------------------------------
  // Check the text against the mask.

    self.text = Array(text.characters)
    return check(0, node: rootNode)
  }

  private func check(index: Int, node: Node) -> CheckResult {
  //----------------------------------------------------------------------------
  // This checks the current text against the current mask (tree).
  //
  //  Gobal Inputs:
  //    mask    Mask being parsed
  //    text    Text being analyzed
  //
  //  Parameter Inputs:
  //    index   Index into the text currently being examined
  //    node    Node in mask to be used for checking the text at index
  //
  //  Global Outputs:
  //    newtext Text with mask changes applied
  //
  // Returns:
  //    index   Next index into the text that should be examined
  //    status  Ok, OkSoFar, or NotOk
  //    errMsg  nil if everything is ok otherwise an isOk    True

    //NSLog("CHECK \(NBPictureMask.lastDot(String(node.type))) - \(index) \(node.str)")

    var i = index

    //--------------------

    switch node.type {

    //--------------------

    case .Digit :

      guard i < text.count else { return(i, .OkSoFar, nil) }

      if NBPictureMask.isDigit( text[i] ) {
        return(i+1, .Ok, nil)
      } else {
        return(i, .NotOk, "Not a digit")
      }

    //--------------------

    case .Letter :

      guard i < text.count else { return(i, .OkSoFar, nil) }

      if NBPictureMask.isLetter( text[i] ) {
        return(i+1, .Ok, nil)
      } else {
        return(i, .NotOk, "Not a letter")
      }

    //--------------------

    case .LetterToUpper :

      guard i < text.count else { return(i, .OkSoFar, nil) }

      if NBPictureMask.isLetter( text[i] ) {
        return(i+1, .Ok, nil)
      } else {
        return(i, .NotOk, "Not a letter")
      }

    //--------------------

    case .LetterToLower :

      guard i < text.count else { return(i, .OkSoFar, nil) }

      if NBPictureMask.isLetter( text[i] ) {
        return(i+1, .Ok, nil)
      } else {
        return(i, .NotOk, "Not a letter")
      }

    //--------------------

    case .AnyChar :

      guard i < text.count else { return(i, .OkSoFar, nil) }

      return(i+1, .Ok, nil)

    //--------------------

    case .AnyCharToUpper :

      guard i < text.count else { return(i, .OkSoFar, nil) }

      return(i+1, .Ok, nil)

    //--------------------

    case .Literal :

      guard i < text.count else { return(i, .OkSoFar, nil) }

      if text[i] == node.literal {
        return(i+1, .Ok, nil)
      } else {
        return(i, .NotOk, "Not ok")
      }

    //--------------------
    // Root node
    // Example: # or ## or #[#] or {#,&}

    case .Root :

      for n in 0 ..< node.nodes.count {
        let retVal = check(i, node: node.nodes[n])
        i = retVal.index
        switch retVal.status {
        case .Ok :          break;            // Continue while everything is ok
        case .OkSoFar :     return retVal     // No more text
        case .NotOk :       return retVal     // Problem
        }
      }

      // No more mask
      if i == text.count  { return(i, .Ok, nil) }           // Mask and text match
      else                { return(i, .NotOk, "Not ok") }   // More text than mask

    //--------------------
    // Repeat *# or *2# or *2[#]

    case .Repeat :

      var loopCount = node.value

      while loopCount >= 0 {

        let startIndex = i

        // No more input
        if i == text.count {
          if loopCount == 0 { return(i, .Ok, nil) }    // Repeat Oked to the end of the input OR no count specified
          else              { return(i, .OkSoFar, nil) }
        }

        for n in 0 ..< node.nodes.count {
          let retVal = check(i, node: node.nodes[n])
          //NSLog("  repeat \(NBPictureMask.lastDot(String(retVal.status))) - \(i) \(node.str)")
          i = retVal.index
          switch retVal.status {
          case .Ok :        break;                  // Continue while everything is ok
          case .OkSoFar :   return retVal           // No more text
          case .NotOk :     if loopCount == 0 { break }   // No count specified so it doesn't have to match
                            return retVal           // Problem
          }
        }

        // No more mask

        // Repeat did not advance and this can only happen if everything was optional
        if i == startIndex { return(i, .Ok, nil) }

        if loopCount == 0 { continue }              // Special case repeats until end of text
        loopCount -= 1
        if loopCount == 0 { break }
      }

      // No more loops

      return(i, .Ok, nil)                           // Mask and text up to this point match

    //--------------------
    // Grouping {} or {#} or {#,?} or {R,G,B}
    // Check all groupings from the same text positon.
    // The first Ok wins.

    case .Grouping :

      var retValOkSoFar : CheckResult?

      for n in 0 ..< node.nodes.count {
        let retVal = check(i, node: node.nodes[n])
        //NSLog("  grouping \(NBPictureMask.lastDot(String(retVal.status))) - \(i) \(node.str)")
        switch retVal.status {
        case .Ok :          return retVal           // Match first ok group
        case .OkSoFar :     retValOkSoFar = retVal  // This is ok but see if something better
        case .NotOk :       break                   // Try next group
        }
      }

      // No more mask
      if retValOkSoFar != nil { return retValOkSoFar! }   // This is better than nothing
      return(i, .NotOk, "Not ok")                         // More text than mask

    //--------------------

    case .GroupingEnd :

      return( i, .NotOk, "Should never occur")

    //--------------------
    // Group inside grouping or optional
    // Example: # or ## or A#

    case .Group :

      for n in 0 ..< node.nodes.count {
        let retVal = check(i, node: node.nodes[n])
        //NSLog("  group \(NBPictureMask.lastDot(String(retVal.status))) - \(i) \(node.str)")
        i = retVal.index
        switch retVal.status {
        case .Ok :          break;            // Continue while everything is ok
        case .OkSoFar :     return retVal     // No more text
        case .NotOk :       return retVal     // Problem
        }
      }

      // No more mask
      return(i, .Ok, nil)                     // Mask and text up to this point match

    //--------------------
    // Optional [] or [#] or [#,?] or [R,G,B]
    // Return on the first ok

    case .Optional :

      guard i < text.count else { return(i, .Ok, nil) }     // Optional not needed if no text

      var retValOkSoFar : CheckResult?

      for n in 0 ..< node.nodes.count {
        let retVal = check(i, node: node.nodes[n])
        //NSLog("  optional \(NBPictureMask.lastDot(String(retVal.status))) - \(i) \(node.str)")
        switch retVal.status {
        case .Ok :          return retVal           // Match first ok group
        case .OkSoFar :     retValOkSoFar = retVal  // This is ok but see if something better
        case .NotOk :       break                   // Try next group
        }
      }

      // No more mask
      if retValOkSoFar != nil { return retValOkSoFar! }   // This is better than nothing
      return(i, .Ok, nil)                                 // Does not have to match

    //--------------------

    case .OptionalEnd :

      return(i, .NotOk, "Should never occur")

    }

  }

}