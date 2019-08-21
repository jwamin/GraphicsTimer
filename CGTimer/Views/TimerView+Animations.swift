//
//  TimerView+Animations.swift
//  CGTimer
//
//  Created by Joss Manger on 8/21/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

//MARK: Animations
extension TimerView {
  
  func makeFillAnimation(paused:Bool)->(CGPath,CAAnimation){
    
      let animation = CABasicAnimation(keyPath: "path")
      animation.fromValue = fillCircle.path
      let center = CGPoint(x: -diameter/2, y: -diameter/2)
      let rect = (paused) ? CGRect(origin: center, size: CGSize(width: diameter, height: diameter)) : .zero
      let bpath = UIBezierPath(ovalIn: rect)
      
      animation.toValue = bpath.cgPath
      animation.duration = 1.5
      animation.isRemovedOnCompletion = false
      animation.fillMode = .forwards
      
    return (bpath.cgPath,animation)
    
  }
  
}
