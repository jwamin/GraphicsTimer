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
  let timerViewModel:TimerViewModel
  
  init() {
    
    timerModel = TimerModel()
    timerViewModel = TimerViewModel(timerModel: timerModel)
    timerViewModel.timerModel = timerModel
    timerModel.parent = timerViewModel
  }
  
  func createMainViewController() -> TimerViewController{
    
    let timerViewController = TimerViewController(nibName: nil, bundle: nil)
    timerViewController.timerViewModel = timerViewModel
    timerViewModel.delegate = timerViewController
    return timerViewController
  }
  
}
