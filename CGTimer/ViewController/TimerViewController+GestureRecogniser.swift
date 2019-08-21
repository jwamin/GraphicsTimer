//
//  TimerViewController+GestureRecogniser.swift
//  CGTimer
//
//  Created by Joss Manger on 8/21/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

extension TimerViewController : UIGestureRecognizerDelegate{
  
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    switch gestureRecognizer{
    case is UITapGestureRecognizer:
      print("is tap gesture recogniser")
      return intersects(touch: gestureRecognizer.location(in: timerView)) == nil
    default:
      return false
    }
  }
  
  @objc func handleTap(_ sender:UITapGestureRecognizer){
    print("tap handled")
    
    let tapInCircleRect = timerView.circleRect.contains(sender.location(in: timerView))
    print(tapInCircleRect)
    
    if tapInCircleRect{
      if timerViewModel.isPaused{
        timerViewModel.startResume()
      } else {
        timerViewModel.pause()
      }
      
      timerView.setPaused(timerViewModel.isPaused)
    }
    
  }
  
  @objc
  func handlePan(_ sender:UIPanGestureRecognizer){
    switch sender.state {
    case .began:
      
      if let _ = intersects(touch: sender.location(in: timerView)) {
        print("valid began")
        timerViewModel.stopReset()
        timerView.displayLink.isPaused = false
        timerView.clearRawRadius()
        timerView.toggleFill(false)
      }
      
    case .changed:
      if let location = intersects(touch: sender.location(in: timerView)) {
        
        self.timerView.position = location
        let fraction = Double(timerView.absoluteRadius / (self.view.frame.width / 2))
        //print(fraction,location)
        timerViewModel.setDuration(duration: fraction * TimerModel.timerMax)
      }
    case .ended:
      
      if let _ = intersects(touch: sender.location(in: timerView)) {
        timerView.displayLink.isPaused = false
        print("valid ended")
        timerViewModel.startResume()
        timerView.setPaused(false)
        timerView.toggleFill(true)
      }
    default:
      print("nothing")
    }
  }
  
}
