//
//  CGTimerViewModelTests.swift
//  CGTimerTests
//
//  Created by Joss Manger on 8/18/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import XCTest
@testable import CGTimer

class CGTimerViewModelTests: XCTestCase {

  var viewModel:TimerViewModel!
  var timerModel:TimerModel!
  
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      timerModel = TimerModel()
      viewModel = TimerViewModel(timerModel: timerModel)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      timerModel = nil
      viewModel = nil
    }

    func testRemainingString() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      let testString = "00:14.550"
      let testInterval:TimeInterval = TimeInterval(floatLiteral: 14.55)
      print(TimerViewModel.stringFromTimeInterval(interval: testInterval),testString)
      XCTAssert(TimerViewModel.stringFromTimeInterval(interval: testInterval) == testString)
      
    }



}
