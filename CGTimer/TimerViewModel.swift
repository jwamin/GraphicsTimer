//
//  TimerViewModel.swift
//  CGTimer
//
//  Created by Joss Manger on 8/18/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import Foundation

class TimerViewModel {
  
  //MARK: Instance Variables
  var timerModel:TimerModel!
  var delegate:TimerModelDelegate?
  var dateFormatter = DateComponentsFormatter()
  
  //MARK: Init / Deinit
  init(timerModel:TimerModel){
    
    self.timerModel = timerModel
    timerModel.parent = self
    dateFormatter.calendar = Calendar.current
    dateFormatter.allowedUnits = [NSCalendar.Unit.minute, NSCalendar.Unit.second]
  }
  
  deinit {
    print("this is the vm being deinitialised")
  }
  
  //MARK: View Update Functions
  
  /// Update view with data from model
  /// - Parameter remaining: decimal indicating the remaining time of the current duration (between 1.0 and 0.0)
  func update(remaining:TimeInterval){
    
    let str = TimerViewModel.stringFromTimeInterval(interval: remaining)
    delegate?.timerUpdated(timerString: str,updateFraction: timerModel.getFraction())
  }
  
  /// Called when the handle is dropped and the timer resets
  func reset(){
    
    delegate?.timerUpdated(timerString: TimerViewModel.stringFromTimeInterval(interval: timerModel.duration),updateFraction: nil)
  }

  
  //MARK: Static Functions
  
  /// Produces formatted string for label in format mm:ss:SSS
  /// - Parameter interval: remaining time for the timer to run
  static func stringFromTimeInterval(interval: TimeInterval) -> String {
    
    let ti = NSInteger(interval)
    
    let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
    
    let seconds = ti % 60
    let minutes = (ti / 60) % 60
    //let hours = (ti / 3600)
    
    return String(format: "%0.2d:%0.2d.%0.3d",minutes,seconds,ms)
  }
  
}


extension TimerViewModel : TimerProtocol {
  
  func startResume() {
    timerModel.startResume()
  }
  
  func stopReset() {
    timerModel.stopReset()
  }
  
  func pause() {
    timerModel.pause()
  }
  
  func setDuration(duration:TimeInterval){
    timerModel.duration = duration
  }
  
}
