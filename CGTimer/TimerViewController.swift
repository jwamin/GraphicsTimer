//
//  ViewController.swift
//  CGTimer
//
//  Created by Joss Manger on 8/12/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

  var timerView:TimerView!
  var constraints = [NSLayoutConstraint]()
  
  override func loadView() {
    timerView = TimerView(frame: .zero)
    self.view = timerView
    timerView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    bindConstaints()
    timerView.backgroundColor = Constants.Colors.background
  }
  
  func bindConstaints(){
    
    if constraints.isEmpty{
      
      constraints += [
        timerView.topAnchor.constraint(equalTo: self.view.topAnchor),
        timerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
        self.view.rightAnchor.constraint(equalTo: timerView.rightAnchor),
        self.view.bottomAnchor.constraint(equalTo: timerView.bottomAnchor)
      ]
      
      NSLayoutConstraint.activate(constraints)
      
    }
    
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let first = touches.first, let _ = intersects(touch: first) {
      timerView.toggleFill(false)
    }
  }
  
  private func intersects(touch:UITouch)->CGPoint?{
    let firstLocation = touch.location(in: timerView)
    if self.timerView.currentPosition.contains(firstLocation){
      return firstLocation
    }
    return nil
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let first = touches.first, let location = intersects(touch: first) {
      self.timerView.position = location
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    timerView.toggleFill(true)
  }

  override func viewDidLayoutSubviews() {
    if timerView.position == .zero{
      timerView.position = timerView.center
    }
    
  }
  
}
