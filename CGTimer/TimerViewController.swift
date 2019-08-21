//
//  ViewController.swift
//  CGTimer
//
//  Created by Joss Manger on 8/12/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
  
  var timerViewModel:TimerViewModel!
  
  var timerView:TimerView!
  var constraints = [NSLayoutConstraint]()
  
  var tapRecogniser:UITapGestureRecognizer!
  var panRecogniser:UIPanGestureRecognizer!
  
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
    
    timerViewModel.startResume()
    //Thread.sleep(until: Date().addingTimeInterval(5))
    
    tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    tapRecogniser.delegate = self
    timerView.addGestureRecognizer(tapRecogniser)
    
    panRecogniser = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    panRecogniser.minimumNumberOfTouches = 1
    panRecogniser.maximumNumberOfTouches = 1
    timerView.addGestureRecognizer(panRecogniser)
    
    
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
  
  
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    if let first = touches.first, let _ = intersects(touch: first.location(in: timerView)) {
//      print("valid began")
//      timerViewModel.stopReset()
//      timerView.displayLink.isPaused = false
//      timerView.clearRawRadius()
//      timerView.toggleFill(false)
//    }
//  }
  
  private func intersects(touch:CGPoint)->CGPoint?{
    if self.timerView.currentPosition.contains(touch){
      return touch
    }
    return nil
  }
  
//  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//    if let first = touches.first, let location = intersects(touch: first.location(in: timerView)) {
//      self.timerView.position = location
//      let fraction = Double(timerView.absoluteRadius / (self.view.frame.width / 2))
//      //print(fraction,location)
//      timerViewModel.setDuration(duration: fraction * TimerModel.timerMax)
//    }
//  }
  
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    timerView.toggleFill(true)
//    if let first = touches.first, let location = intersects(touch: first.location(in: timerView)) {
//      timerView.displayLink.isPaused = false
//      print("valid ended")
//      timerViewModel.startResume()
//    }
//
//  }
  
  override func viewDidLayoutSubviews() {
    if timerView.position == .zero{
      timerView.position = timerView.center
    }
    
  }
  
}

extension TimerViewController : TimerModelDelegate{
  
  func timerUpdated(timerString: String, updateFraction: Double?) {
    timerView.setTimerLabel(str: timerString)
    if let updateFraction = updateFraction{
      timerView.updateCircle(decimal: updateFraction)
    }
  }
}


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
      
      //if let location = intersects(touch: sender.location(in: timerView)) {
        timerView.displayLink.isPaused = false
        print("valid ended")
        timerViewModel.startResume()
        timerView.setPaused(false)
        timerView.toggleFill(true)
      //}
    default:
      print("nothing")
    }
  }
  
}
