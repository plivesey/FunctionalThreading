//
//  FunctionalThreadingTests.swift
//  FunctionalThreadingTests
//
//  Created by Peter Livesey on 9/9/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import UIKit
import XCTest


class FunctionalThreadingTests: XCTestCase {
  
  func testBasicUseCase() {
    let expected = 19
    let expectation = expectationWithDescription("Should have verified the expectation")
    let verifyExpected = expected --> expectation --> verifyAnswer
    
    // let's do one task on the background thread and then call verify answer on the main thread
    6 --> 13 ^-> addInts |-> verifyExpected
    
    waitForExpectationsWithTimeout(10) { error in
      if error != nil {
        XCTFail("\(error)")
      }
    }
  }
  
  func testEverythingAsync() {
    let expected = 641
    let expectation = expectationWithDescription("Should have verified the expectation")
    let verifyExpected = expected --> expectation --> verifyAnswer
    
    // Take two parameters and do a bunch of stuff to them on a background thread. Then, go back to the main thread and verify.
    6 --> "4" ^-> (toString ||| appendZero) --> append --> forceToInt --> addOne |-> verifyExpected
    
    waitForExpectationsWithTimeout(10) { error in
      if error != nil {
        XCTFail("\(error)")
      }
    }
  }
  
  func testEverythingSync() {
    let expected = 641
    let verifyExpected = expected --> verifyAnswer
    
    // Take two parameters and do a bunch of stuff to them. Do everything on the same thread.
    6 --> "4" --> (toString ||| appendZero) --> append --> forceToInt --> addOne --> verifyExpected
  }
  
  func testTripleCombine() {
    let expected = 6
    let verifyExpected = expected --> verifyAnswer
    
    1 --> "2" --> 3 --> ( addOne ||| forceToInt ||| minusOne ) --> addAll --> verifyExpected
  }
  
  //////////////////
  // Helpers
  //////////////////
  
  func addOne(x: Int) -> Int {
    return x + 1
  }
  
  func minusOne(x: Int) -> Int {
    return x - 1
  }
  
  func appendZero(string: String) -> String {
    return string + "0"
  }
  
  func append(initial: String, x: String) -> String {
    return initial + x
  }
  
  func addAll(x: Int, y: Int, z: Int) -> Int {
    return x + y + z
  }
  
  func addInts(x: Int, y: Int) -> Int {
    return x + y
  }
  
  func forceToInt(string: String) -> Int {
    return string.toInt()!
  }
  
  func toString(x: Int) -> String {
    return String(x)
  }
  
  func verifyAnswer(actual: Int, expected: Int, expectation: XCTestExpectation) {
    XCTAssertEqual(actual, expected, "The values should be equal")
    println("About to fulfill")
    expectation.fulfill()
  }
  
  func verifyAnswer(actual: Int, expected: Int) {
    XCTAssertEqual(actual, expected, "The values should be equal")
  }
}
