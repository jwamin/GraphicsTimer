//
//  TImerViewController+TimerDelegate.swift
//  CGTimer
//
//  Created by Joss Manger on 8/21/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

extension TimerViewController : TimerModelDelegate{
  
  func timerUpdated(timerString: String, updateFraction: Double?) {
    timerView.setTimerLabel(str: timerString)
    if let updateFraction = updateFraction{
      timerView.updateCircle(decimal: updateFraction)
    }
  }
  
}
