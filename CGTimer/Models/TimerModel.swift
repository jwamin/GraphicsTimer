//
//  TimerModel.swift
//  CGTimer
//
//  Created by Joss Manger on 8/13/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import Foundation

class TimerModel: TimerProtocol {
  
  static let timerMax:TimeInterval = 60 * 1 // 1 Mins
  
  var timer:Timer?
  weak var parent:TimerViewModel?
  
  var duration:TimeInterval = 60 * 0.5 { // 30 secs (default)
    didSet{
      parent?.reset()
    }
  }
  
  public private(set) var remaining:TimeInterval?
  private var endDate:Date?
  var pausedAt:Date?
  
  var isRunning:Bool{
    return timer?.isValid ?? false
  }
  
  var isPaused:Bool{
    return pausedAt != nil && !timer!.isValid
  }
  
  public func setDuration(duration:Double){
    //do some additional checks here maybe?
    self.duration = duration
  }
  
  func startResume(){
    
    if let _ = pausedAt, let remaining = remaining{
      endDate = pausedAt!.addingTimeInterval(remaining) //
      pausedAt = nil
    } else {
      endDate = Date().addingTimeInterval(duration)
    }
 
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
  
  /// Generates a normalised decimal for use by the graphical system 0.5 indicates halfway through the timer duration
  func getFraction()->Double{
    
    let totalFraction = duration / TimerModel.timerMax
    let divisor = remaining ?? 1
    let innerFraction = divisor / duration
    
    return innerFraction * totalFraction
    
  }
  
  /// Update the parent with new data when the tiemr fires
  /// - Parameter timer: timer instance passed in by firing of timer
  private func update(_ timer:Timer)->Void{
    remaining = endDate!.timeIntervalSince(Date())
    
    if remaining! <= 0{
      //timer is ended, call reset
      parent?.update(remaining: 0)
      stopReset()
      return
    }
    
    parent?.update(remaining: remaining!)
  }
  

  
  
}
