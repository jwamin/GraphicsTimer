//
//  FeatureBuilder.swift
//  CGTimer
//
//  Created by Joss Manger on 8/12/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import Foundation

class FeatureBuilder{
  
  let timerModel:TimerModel
  
  init() {
    timerModel = TimerModel()
  }
  
  func createMainViewController() -> TimerViewController{
    
    let timerViewController = TimerViewController(nibName: nil, bundle: nil)
    timerViewController.timerModel = timerModel
    timerModel.delegate = timerViewController
    return timerViewController
  }
  
}
