//
//  TimerProtocols.swift
//  CGTimer
//
//  Created by Joss Manger on 8/18/19.
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
