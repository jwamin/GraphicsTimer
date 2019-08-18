//
//  TimerModel.swift
//  CGTimer
//
//  Created by Joss Manger on 8/13/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import Foundation

protocol TimerProtocol{
  
  func startResume()
  func stopReset()
  func pause()
  
}

protocol TimerModelDelegate{
  
  func timerUpdated(timerString:String,updateFraction:Double?)
  
}


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
  
  func getFraction()->Double{
    
    let totalFraction = duration / TimerModel.timerMax
    let divisor = remaining ?? 1
    let innerFraction = divisor / duration
    
    return innerFraction * totalFraction
    
  }
  
  private func update(_ timer:Timer)->Void{
    remaining = endDate!.timeIntervalSince(Date())
    
    if remaining! <= 0{
      //timer is ended
      parent?.update(remaining: 0)
      stopReset()
      return
    }
    
    parent?.update(remaining: remaining!)
  }
  
  deinit {
    print("why am i being deallocated?")
  }
  
  
}
