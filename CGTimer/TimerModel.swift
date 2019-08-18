//
//  TimerModel.swift
//  CGTimer
//
//  Created by Joss Manger on 8/13/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import Foundation

protocol TimerModelDelegate{
  
  func timerUpdated(timerString:String,updateFraction:Double?)
  
}


class TimerModel {
  
    static let timerMax:TimeInterval = 60 * 1 // 15 Mins
  
  var timer:Timer?
  var duration:TimeInterval = 60 * 0.5 { // 2 mins (default)
    didSet{
      delegate?.timerUpdated(timerString: TimerModel.stringFromTimeInterval(interval: duration),updateFraction: nil)
    }
  }
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
  
  private func getFraction()->Double{
    
    let totalFraction = duration / TimerModel.timerMax
    let divisor = remaining ?? 1
    let innerFraction = divisor / duration
    
    return innerFraction * totalFraction
    
  }
  
  private func update(_ timer:Timer)->Void{
    remaining = endDate!.timeIntervalSince(Date())
    let str = TimerModel.stringFromTimeInterval(interval: remaining!)
    delegate?.timerUpdated(timerString: str,updateFraction: getFraction())
  }
  

  
  
}


//create View Model
