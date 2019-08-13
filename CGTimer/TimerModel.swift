//
//  TimerModel.swift
//  CGTimer
//
//  Created by Joss Manger on 8/13/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import Foundation

protocol TimerModelDelegate{
  
  func timerUpdated(timerString:String)
  
}


class TimerModel {
  
  var timer:Timer?
  var duration:TimeInterval = 60 * 2 // 2 mins (default)
  public private(set) var remaining:TimeInterval?
  private var endDate:Date?
  var pausedAt:Date?
  
  var delegate:TimerModelDelegate?
  
  var dateFormatter = DateComponentsFormatter()
  
  init(){
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
  
  public func setDuration(duration:Double){
    
  }
  
  func startResume(){
    
    if let paused = pausedAt, let remaining = remaining{
      endDate = pausedAt?.addingTimeInterval(remaining) //
      pausedAt = nil
    } else {
      endDate = Date().addingTimeInterval(duration)
    }
    print("hello from timer")
    timer = Timer(timeInterval: 0, repeats: true, block: self.update(_:))
    
    RunLoop.main.add(timer!, forMode: .default)
    
  }
  
  func stopReset(){
    timer?.invalidate()
    endDate = nil
    pausedAt = nil
    remaining = nil
  }
  
  func pause(){
    timer?.invalidate()
    endDate = nil
    pausedAt = Date()
  }
  
  private func update(_ timer:Timer)->Void{
    remaining = endDate!.timeIntervalSince(Date())
    let str = TimerModel.stringFromTimeInterval(interval: remaining!)
    delegate?.timerUpdated(timerString: str)
  }
  
  static let timerMax = 60 * 15 // 15 Mins
  
  
}