//
//  TimerViewModel.swift
//  CGTimer
//
//  Created by Joss Manger on 8/18/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import Foundation

class TimerViewModel: TimerProtocol {
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
  
  var timerModel:TimerModel!
  var delegate:TimerModelDelegate?
  
  var dateFormatter = DateComponentsFormatter()
  
  init(timerModel:TimerModel){
    self.timerModel = timerModel
    dateFormatter.calendar = Calendar.current
    dateFormatter.allowedUnits = [NSCalendar.Unit.minute, NSCalendar.Unit.second]
  }
  
  static func stringFromTimeInterval(interval: TimeInterval) -> String {
    
    let ti = NSInteger(interval)
    
    let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
    
    let seconds = ti % 60
    let minutes = (ti / 60) % 60
    //let hours = (ti / 3600)
    
    return String(format: "%0.2d:%0.2d.%0.3d",minutes,seconds,ms)
  }
  
  func reset(){
    
    delegate?.timerUpdated(timerString: TimerViewModel.stringFromTimeInterval(interval: timerModel.duration),updateFraction: nil)
    
  }
  
  func update(remaining:TimeInterval){
    
    let str = TimerViewModel.stringFromTimeInterval(interval: remaining)
    
    delegate?.timerUpdated(timerString: str,updateFraction: timerModel.getFraction())
  }
  
  deinit {
    print("this is the vm being deinitialised")
  }
  
}
