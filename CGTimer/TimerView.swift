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
  
  var radius:CGFloat{
    
    let center = self.center
    let working = sqrt(pow(position.x - center.x,2) + pow(position.y - center.y,2))
    
    return min(self.frame.width/2, CGFloat(working))//truncate
  }
  
  var currentPosition:CGRect{
    
    return self.convert(timerCircle.frame, to: self)
  }
  
  override init(frame: CGRect) {
    timerCircle = CAShapeLayer()
    
    super.init(frame: frame)
    self.layer.addSublayer(timerCircle)
    position = self.center
    setupShapeLayer()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupShapeLayer(){
    let rect = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
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
    context?.addArc(center: self.center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
    context?.strokePath()
    
  }
  
  override func layoutSubviews() {
    
    //timerCircle.position = position
    
    
  }
  
}
