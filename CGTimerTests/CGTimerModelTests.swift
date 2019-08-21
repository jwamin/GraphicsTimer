//
//  CGTimerTests.swift
//  CGTimerTests
//
//  Created by Joss Manger on 8/15/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import XCTest
@testable import CGTimer


class TimerModelTests: XCTestCase {
  
  var model:TimerModel!
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    model = TimerModel()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    model.timer?.invalidate()
    model = nil
  }
  
  func testTimerStarts(){
    model.setDuration(duration: 100)
    model.startResume()
    XCTAssert(model.timer!.isValid)
  }
  
  func testTimerRestarts(){
    
    model.setDuration(duration: 100)
    Thread.sleep(until: Date().advanced(by: 1))
    model.stopReset()
    model.startResume()
    XCTAssert(model.timer!.isValid)
    
  }
  
  func testTimerPauses(){
    model.startResume()
    let expections = XCTestExpectation(description: "wait for time")
    let waiter = XCTWaiter.wait(for: [expections], timeout: 0.3)
    if waiter == XCTWaiter.Result.timedOut{
      model.pause()
      XCTAssert(model.isPaused)
      model.startResume()
      Thread.sleep(until: Date().advanced(by: 1))
      XCTAssert(!model.isPaused, "model.isPaused \(model.isPaused)")
    } else {
      XCTFail()
    }
    
  }
  
  func testTimerDurationSet(){
    model.setDuration(duration: 100)
    XCTAssert(model.duration == 100)
  }
  
  func testTimerStopsandInvalidates(){
    
    model.startResume()
    XCTAssert(model.timer!.isValid)
    model.stopReset()
    XCTAssert(!model.timer!.isValid)
    
  }
  
  //    func testPerformanceExample() {
  //        // This is an example of a performance test case.
  //        self.measure {
  //            // Put the code you want to measure the time of here.
  //        }
  //    }
  
}

