//
//  ViewController.swift
//  CGTimer
//
//  Created by Joss Manger on 8/12/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

  var timerModel:TimerModel!
  
  var timerView:TimerView!
  var constraints = [NSLayoutConstraint]()
  
  override var preferredStatusBarStyle: UIStatusBarStyle{
    return UIStatusBarStyle.lightContent
  }
  
  override func loadView() {
    timerView = TimerView(frame: .zero)
    self.view = timerView
    timerView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    bindConstaints()
    //self.preferredStatusBarStyle = .light
    timerView.backgroundColor = Constants.Colors.background
    
    timerModel.startResume()
    //Thread.sleep(until: Date().addingTimeInterval(5))
    
    
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
      timerModel.stopReset()
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
      let fraction = Double(timerView.absoluteRadius / (self.view.frame.width / 2))
      print(fraction)
      timerModel.duration =  fraction * TimerModel.timerMax
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    timerView.toggleFill(true)
    if let first = touches.first, let location = intersects(touch: first) {
      
      timerModel.startResume()
    }
    
  }

  override func viewDidLayoutSubviews() {
    if timerView.position == .zero{
      timerView.position = timerView.center
    }
    
  }
  
}

extension TimerViewController : TimerModelDelegate{
  
  func timerUpdated(timerString: String) {
    timerView.setTimerLabel(str: timerString)
  }
  
}
