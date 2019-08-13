//
//  TimerView.swift
//  CGTimer
//
//  Created by Joss Manger on 8/12/19.
//  Copyright © 2019 Joss Manger. All rights reserved.
//

import UIKit

class TimerView : UIView{
  
  //MARK: Instance Variables
  var timerCircle:CAShapeLayer
  var fill = true
  
  //MARK: Computed Properties
  var position:CGPoint = .zero{
    didSet{
      
      CATransaction.begin()
      
      CATransaction.setDisableActions(true)
      timerCircle.position = position
      
      CATransaction.commit()
      
      setNeedsDisplay()
    }
  }
  
  //absolute radius ... used for calculating the... timers?
  var absoluteRadius:CGFloat{
    let center = self.center
    let radius = sqrt(pow(position.x - center.x,2) + pow(position.y - center.y,2))
    let maxWidth = self.frame.width/2
    return min(radius,maxWidth)
  }
  
  //radius for drawing
  var graphicalRadius:CGFloat{
    
    let working = absoluteRadius
    let maxWidth = self.frame.width/2 - (Constants.Widths.main / 2)
    return min(maxWidth, CGFloat(working))//truncate
    
  }
  
  var currentPosition:CGRect{
    
    return self.convert(timerCircle.frame, to: self)
  }
  
  //MARK: Subviews
  
  private var timerLabel:UILabel!
  private var viewConstraints = [NSLayoutConstraint]()
  
  override init(frame: CGRect) {
    timerCircle = CAShapeLayer()
    
    super.init(frame: frame)
    self.layer.addSublayer(timerCircle)
    position = self.center
    setupShapeLayer()
    setupLabel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLabel(){
    
    timerLabel = UILabel()
    timerLabel.translatesAutoresizingMaskIntoConstraints = false
    timerLabel.textColor = UIColor.white
    timerLabel.numberOfLines = 1
    timerLabel.textAlignment = .center
    self.addSubview(timerLabel)
    timerLabel.isUserInteractionEnabled = false
    setTimerLabel(str: "initialised")
  }
  
  public func setTimerLabel(str:String){
    timerLabel.text = str
    //timerLabel.sizeToFit()
  }
  
  private func setupShapeLayer(){
    let dimension = Constants.Dimensions.handleDimension
    let rect = CGRect(origin: .zero, size: CGSize(width: dimension, height: dimension))
    let path = UIBezierPath(ovalIn: rect)
    timerCircle.bounds = rect
    
    //timerCircle.position = self.center
    timerCircle.strokeColor = Constants.Colors.foreground.cgColor
    timerCircle.fillColor = (fill) ? UIColor.white.cgColor : UIColor.clear.cgColor
    timerCircle.lineWidth = Constants.Widths.main
    timerCircle.lineJoin = .round
    timerCircle.path = path.cgPath
  }
  
  func toggleFill(_ override:Bool? = nil){
    
    fill = (override != nil) ? override! : !fill
    print("toggle \(fill)")
    timerCircle.fillColor = (fill) ? UIColor.white.cgColor : UIColor.clear.cgColor
  }
  
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let context = UIGraphicsGetCurrentContext()
    context?.move(to: position)
    context?.setStrokeColor(UIColor.blue.cgColor)
    context?.setLineWidth(Constants.Widths.main)
    context?.beginPath()
    context?.addArc(center: self.center, radius: graphicalRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
    context?.strokePath()
    
  }
  
  override func updateConstraints() {
    
    if viewConstraints.isEmpty{
      
      viewConstraints += [
        timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        timerLabel.leftAnchor.constraint(equalToSystemSpacingAfter: self.leftAnchor, multiplier: 1.0),
        self.rightAnchor.constraint(equalToSystemSpacingAfter: timerLabel.rightAnchor, multiplier: 1.0),
        self.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: timerLabel.bottomAnchor, multiplier: 1.0)
      ]
      
      NSLayoutConstraint.activate(viewConstraints)
      
    }
    
    super.updateConstraints()
  }
  
//  override func layoutSubviews() {
//
//    //timerCircle.position = position
//
//
//  }
  
}
