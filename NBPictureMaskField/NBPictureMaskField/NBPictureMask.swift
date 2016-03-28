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
//  Mask -  This defines what the field will accept. Groups can be created
//          inside { }. These letters indicate the following format:
//
//            d = digits 0..9
//            D = anything other than 0..9
//            a = a..z, A..Z
//            W = anything other than a..z, A..Z
//            . = anything (default)
//
//            Examples
//            {dddd}-{DDDD}-{WaWa}-{aaaa}   would allow 0123-AbCd-0a2b-XxYy
//
//  Template -  This is used to fill in the mask for displaying.
//
//==============================================================================

import Foundation

class NBPictureMask {
//------------------------------------------------------------------------------

  //--------------------
  // MARK: - Constants

  struct kMask {
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
    static let separator      : Character = ","
  }

  //--------------------
  // MARK: - Types

  enum NodeType {
  //----------------------------------------------------------------------------
  // A node must be one of these types.

    case
      Unknown,
      Repeat,                                 //  *  Repeat any number of times - Example: *& or *3#
      Optional,                               //  [  Optional sequence of characters - Example: [abc]
      OptionalEnd,                            //  ]  Ends sequence of optional
      Grouping,                               //  {  Grouping - Example: {R,G,B} or {R[ed],G[reen],B[lue]}
      GroupingEnd,                            //  }  Ends sequence of group
      Digit,                                  //  #  Any digit 0..9
      Letter,                                 //  ?  Any letter a..z or A..Z
      LetterToUpper,                          //  &  Any letter a..z or A..Z converted to uppercase
      LetterToLower,                          //  ~  Any letter a..z or A..Z converted to lowercase
      AnyChar,                                //  @  Any character
      AnyCharToUpper,                         //  !  Any character converted to uppercase
      Escape,                                 //  ;  Escape such that next character is to be used literally
      Literal                                 //     Literal character
  }

  struct Node {
  //----------------------------------------------------------------------------

    var type : NodeType = .Unknown            // Node type indicates how it should be handled
    var repCount : Int = 0                    // Repetion count
    var literal : Character = " "             // Literal character
    var nodes : [Node] = [Node]()             // Child nodes (branches)
   }

  enum MatchStatus {
  //----------------------------------------------------------------------------

    case
      NotGood,                                // The check has failed
      OkSoFar,                                // The check is ok so far
      Match                                   // It matches
  }

  typealias CheckResult = (index: Int, status: MatchStatus, errMsg: String?)

  //--------------------
  // MARK: - Variables

  var localMask = String()
  var text = String()

  var treeRoot = [Node]()             // Primary parsed tree


  var mask: String {
  //----------------------------------------------------------------------------
    get { return localMask }
    set {
      localMask = newValue
      parseMask(localMask)
      printMaskTree()
    }
  }

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

  private func parseMask(mask: String) {
  //----------------------------------------------------------------------------
  // Parse the mask and create the tree root.

    parseMask( Array(mask.characters), treeRoot: &treeRoot )
  }

  private func parseMask(mask: [Character], inout treeRoot: [Node]) {
  //----------------------------------------------------------------------------
  // Parse the mask and create the tree root.

    treeRoot = [Node]()
    var i = 0
    while i < mask.count {
      let retVal = parseMask(mask, index: i, tree: &treeRoot)
      i = retVal.index
      if let errMsg = retVal.errMsg {
        NSLog("PARSING ERROR: Index(\(i)) Message: \(errMsg)")
      }
    }
    NSLog("PARSING DONE")
  }

  private func parseMask(mask: [Character], index: Int, inout tree: [Node]) -> (index: Int, errMsg: String?) {
  //----------------------------------------------------------------------------
  // This parses a picture mask. It takes the following inputs:
  //
  //    mask    Mask being parsed
  //    index   Index into the mask currently being examined
  //    tree    Array of nodes to be built upon
  //
  // It returns the following:
  //
  //    index   Next index into the mask that should be examined
  //    errMsg  nil if everything is ok otherwise an isOk    True

    var i = index

    // Nothing to parse
    guard i < mask.count else {
      return ( i, nil )
    }

    // Create a node that will be added to the tree

    var n = Node()

    // Look at the current character to see what type it is

    var c = mask[i]
    var t = NodeType.Unknown

    switch c {
    case kMask.digit          : t = .Digit
    case kMask.letter         : t = .Letter
    case kMask.letterToUpper  : t = .LetterToUpper
    case kMask.letterToLower  : t = .LetterToLower
    case kMask.anyChar        : t = .AnyChar
    case kMask.anyCharToUpper : t = .AnyCharToUpper
    case kMask.escape         : t = .Escape
    case kMask.repetition     : t = .Repeat
    case kMask.optional       : t = .Optional
    case kMask.optionalEnd    : t = .OptionalEnd
    case kMask.grouping       : t = .Grouping
    case kMask.groupingEnd    : t = .GroupingEnd
    default                   : t = .Literal
    }

    // Escape takes the next character as a literal

    if t == .Escape {
      i += 1
      guard i < mask.count else {
        return ( i, "Escape character '\(kMask.escape)' does not have any characters following it." )
      }
      c = mask[i]
      t = .Literal
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
      tree.append(n)
      return (i+1, nil)

    //--------------------

    case .Literal :

      n.type = .Literal
      n.literal = c
      tree.append(n)
      return (i+1, nil)

    //--------------------
    // Repeat *# or *2# or *2[#]

    case .Repeat :

      var numStr = ""

      repeat {

        i += 1
        guard i < mask.count else {
          return ( i, "Repetition property '\(kMask.repetition)\(numStr)' does not have any characters following it." )
        }

        c = mask[i]

        if NBPictureMask.isDigit(c) {
          numStr += String(c)
        }

      } while NBPictureMask.isDigit(c)

      let retVal = parseMask(mask, index: i, tree: &n.nodes)
      i = retVal.index
      if retVal.errMsg != nil { return retVal }

      n.type = .Repeat
      n.literal = "*"
      n.repCount = Int( numStr ) ?? 0
      tree.append(n)
      return (i, nil)

    //--------------------
    // Optional [] or [#] or [#,?] or [R,G,B]

    case .Optional :

      i += 1

      repeat {
        let retVal = parseMask(mask, index: i, tree: &n.nodes)
        i = retVal.index
        guard i < mask.count else {
          return ( i, "Optional property '\(kMask.optional)' does not have the closing '\(kMask.optionalEnd)' character." )
        }

        // Group seperator saves and restarts

        if mask[i] == kMask.separator {
          n.type = .Optional
          n.literal = kMask.optional
          tree.append(n)
          n.nodes = [Node]()
          i += 1
          continue
        }
      } while mask[i] != kMask.optionalEnd

      n.type = .Optional
      n.literal = kMask.optional
      tree.append(n)
      return (i+1, nil)

    //--------------------
    // Grouping {} or {#} or {#,?} or {R,G,B}

    case .Grouping :

      i += 1

      repeat {
        let retVal = parseMask(mask, index: i, tree: &n.nodes)
        i = retVal.index
        guard i < mask.count else {
          return ( i, "Grouping property '\(kMask.grouping)' does not have the closing '\(kMask.groupingEnd)' character." )
        }

        // Group seperator saves and restarts

        if mask[i] == kMask.separator {
          n.type = .Grouping
          n.literal = kMask.grouping
          tree.append(n)
          n.nodes = [Node]()
          i += 1
          continue
        }
      } while mask[i] != kMask.groupingEnd

      n.type = .Grouping
      n.literal = kMask.grouping
      tree.append(n)
      return (i+1, nil)

    //--------------------

    default :

      return (i+1, "Not sure why we got here.")

    }
  }

  private func printMaskTree() {
  //----------------------------------------------------------------------------
  // Prints the mask tree structure for debugging purposes.

    printMaskTree(0, tree: treeRoot)
  }

  private func printMaskTree(index: Int, tree: [Node]) {
  //----------------------------------------------------------------------------
  // Prints the mask tree structure for debugging purposes.

    var pad = ""
    for _ in 0..<index { pad += "  " }

    var n = 0
    while n < tree.count {
      let t = tree[n]
      NSLog("\(pad)\(t.literal) \(t.type)")

      switch t.type {
      case .Repeat, .Optional, .Grouping :
        printMaskTree(1, tree: t.nodes)
      default :
        break
      }

      n += 1
    }
  }

  func check(text: String) -> CheckResult {
  //----------------------------------------------------------------------------
  // Check the text against the mask.

    let tc = text.characters
    NSLog("CHECK Mask: '\(mask)' Text: '\(String(tc))'")
    let retVal = NBPictureMask.check(Array(tc), index: 0, tree: treeRoot)

    switch retVal.status {
    case .NotGood :
      NSLog("BAD  Mask: '\(mask)' Text: '\(String(tc))' Index: \(retVal.index) Message: \(retVal.errMsg)")
      return (index: retVal.index, status: .NotGood, errMsg: retVal.errMsg)
    case .OkSoFar :
      NSLog("BAD SO FAR Mask: '\(mask)' Text: '\(String(tc))' Index: \(retVal.index) Message: \(retVal.errMsg)")
      return (index: retVal.index, status: .NotGood, errMsg: retVal.errMsg)
    case .Match :
      NSLog("GOOD Mask: '\(mask)' Text: '\(String(tc))'")
      return (index: retVal.index, status: .Match, errMsg: nil)
    }
  }

  class func check(text: [Character], index: Int, tree: [Node]) -> CheckResult {
  //----------------------------------------------------------------------------
  // This checks the text against the picture mask (tree). It takes the following inputs:
  //
  //    text    Text being checked
  //    index   Index into the mask currently being examined
  //    tree    Array of nodes representing the mask
  //
  // It returns the following:
  //
  //    index   Next index into the text that should be examined
  //    isOk    If check is currently ok otherwise false
  //    errMsg  nil if everything is ok otherwise an isOk    True

    var i = index
    var n = 0
    while i < text.count && n < tree.count {


      //--------------------

      switch tree[n].type {

      //--------------------

      case .Digit :

        if isDigit( text[i] ) {
          i += 1
          n += 1
          continue
        } else {
          return( i, .NotGood, "No match")
        }

      //--------------------

      case .Letter :

        if isLetter( text[i] ) {
          i += 1
          n += 1
          continue
        } else {
          return( i, .NotGood, "No match")
        }

      //--------------------

      case .LetterToUpper :

        if isLetter( text[i] ) {
          i += 1
          n += 1
          continue
        } else {
          return( i, .NotGood, "No match")
        }

      //--------------------

      case .LetterToLower :

        if isLetter( text[i] ) {
          i += 1
          n += 1
          continue
        } else {
          return( i, .NotGood, "No match")
        }

      //--------------------

      case .AnyChar :

        i += 1
        n += 1
        continue

      //--------------------

      case .AnyCharToUpper :

        i += 1
        n += 1
        continue

      //--------------------

      case .Literal :

        if text[i] == tree[n].literal {
          i += 1
          n += 1
          continue
        } else {
          return( i, .NotGood, "No match")
        }

      //--------------------

      case .Repeat :

        var retVal : CheckResult
        var cnt = 0
        repeat {

          retVal = check(text, index: i, tree: tree[n].nodes)
          NSLog("Repeat \(retVal)")

          switch retVal.status {

          // If everything matched then go with that
          case .Match :
            // Only return if number of repetitions can be anthing
            if tree[n].repCount == 0 {
              return( retVal.index, retVal.status, retVal.errMsg)
            }
            i = retVal.index

          // If index advanced then something matched up to that point
          case .OkSoFar :
            i = retVal.index

          case .NotGood :
            return( retVal.index, retVal.status, retVal.errMsg)
          }

          cnt += 1

        } while cnt < tree[n].repCount || tree[n].repCount == 0

        // If we make it to the end then result is most recent outcome
        if retVal.status == .NotGood {
          return( retVal.index, retVal.status, retVal.errMsg)
        }

        n += 1
        continue

      //--------------------

      case .Optional :

        let retVal = check(text, index: i, tree: tree[n].nodes)
        NSLog("Optional: \(retVal)")

        switch retVal.status {

        // If everything matched then go with that
        case .Match :

          return( retVal.index, retVal.status, retVal.errMsg)

        // If index advanced then something matched up to that point
        case .OkSoFar :

          i = retVal.index

        case .NotGood :
          return( retVal.index, retVal.status, retVal.errMsg)
        }

        // If we make it to the end then result is most recent outcome
        if retVal.status == .NotGood {
          return( retVal.index, retVal.status, retVal.errMsg)
        }

        n += 1
        continue

      //--------------------

      case .Grouping :

        var retVal : CheckResult

        for node in tree[n].nodes {

// NOTE - I need to create a function that checks "node" and subtrees

          retVal = check(text, index: i, tree: node.nodes)
          NSLog("Group: \(retVal)")

          switch retVal.status {

          // If everything matched then go with that
          case .Match :

            return( retVal.index, retVal.status, retVal.errMsg)

          // If index advanced then something matched up to that point
          case .OkSoFar :

            i = retVal.index

          case .NotGood :
            return( retVal.index, retVal.status, retVal.errMsg)
          }

        }

/*
        // If we make it to the end then result is most recent outcome
        if retVal.status == .NotGood {
          return( retVal.index, retVal.status, retVal.errMsg)
        }
*/

        n += 1
        continue

      //--------------------

      default :

        i += 1
        n += 1
        continue
      }
    }

    //--------------------
    // Finished with text but there is mask remaining.
    // This might be ok if it is completely optional

    while i == text.count && n < tree.count {

      switch tree[n].type {
      case .Optional :

        n += 1

      default :

        return( i, .NotGood, "No match")

      }
    }

    //--------------------
    // Final determination

    if i == text.count && n == tree.count {
      return( i, .Match, nil)
    } else if i < text.count && n == tree.count {
      return( i, .OkSoFar, nil)
    } else {
      return( i, .NotGood, "No match")
    }
  }

}