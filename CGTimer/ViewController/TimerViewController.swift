//
//  ViewController.swift
//  CGTimer
//
//  Created by Joss Manger on 8/12/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
  
  //MARK: Ivars
  
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
  
  func intersects(touch:CGPoint)->CGPoint?{
    if self.timerView.currentPosition.contains(touch){
      return touch
    }
    return nil
  }
  
  override func viewDidLayoutSubviews() {
    
    if timerView.position == .zero{
      timerView.position = timerView.center
    }
    
  }
  
}



