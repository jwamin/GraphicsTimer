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
  var timerCircle:CAShapeLayer!
  var fillCircle:CAShapeLayer!
  var fill = true
  
  var displayLink:CADisplayLink!
  
  //MARK: Animations
  
  var fillAnimation:(CAShapeLayer,CGFloat,CGPoint)->CAAnimation = { shape,radius,point in
    
    let animation = CABasicAnimation(keyPath: "path")
    animation.fromValue = shape.path
    let diameter = radius * 2
    let center = CGPoint(x: shape.bounds.midX, y: shape.bounds.midY)
    print(center,shape.anchorPoint)
    let rect = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
    let bpath = UIBezierPath(ovalIn: rect)
    
    animation.toValue = bpath.cgPath
    animation.duration = 1.5
    animation.isRemovedOnCompletion = false
    animation.fillMode = .forwards
    return animation
    
  }
  
  
  //MARK: Computed Properties
  var position:CGPoint = .zero{
    didSet{
      if (updateRadiusRaw == nil){
        updatePositionOfHandle()
      }
    }
  }
  
  var updateRadiusRaw:CGFloat? {
    didSet{
      if updateRadiusRaw == nil && oldValue != nil{
        print(oldValue!,self.center)
        let diameter = graphicalRadius * 2
        let rect = CGRect(origin: center, size: CGSize(width: diameter, height: diameter))
        fillCircle.frame = rect
        //fillCircle
        
        fillCircle.position = self.center
        let anim = fillAnimation(fillCircle,graphicalRadius,self.center)
        fillCircle.add(anim, forKey: "fillAnimation")
      }
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
    
    var working:CGFloat = 0
    
    if let updateRadius = updateRadiusRaw{
      working = updateRadius * (self.frame.width / 2)
    } else {
      working = absoluteRadius
    }
    
    let maxWidth = self.frame.width/2 - (Constants.Widths.main / 2)
    return min(maxWidth, CGFloat(working))//truncate
    
  }
  
  var currentPosition:CGRect{
    
    return self.convert(timerCircle.frame, to: self)
  }
  
  //MARK: Subviews
  
  private var timerLabel:UILabel!
  private var viewConstraints = [NSLayoutConstraint]()
  
  //MARK: Instance Methods
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    displayLink = CADisplayLink(target: self, selector: #selector(displayLinkUpdate))
    displayLink.add(to: RunLoop.main, forMode: .default)

    position = self.center

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc
  func displayLinkUpdate(){
    if !displayLink.isPaused{
      self.setNeedsDisplay()
    }
  }
  
  public func setTimerLabel(str:String){
    
    if let timerLabel = timerLabel{
      timerLabel.text = str
    }
  }
  
  public func updateCircle(decimal:Double){
    
    updateRadiusRaw = CGFloat(decimal)
  }
  
  private func updatePositionOfHandle(){
    CATransaction.begin()
    
    CATransaction.setDisableActions(true)
    timerCircle.position = position
    
    CATransaction.commit()
    
    setNeedsDisplay()
  }
  
  //MARK: Setup Subviews
  
  private func setupLabel(){
    if timerLabel == nil {
      timerLabel = UILabel()
      timerLabel.translatesAutoresizingMaskIntoConstraints = false
      timerLabel.textColor = UIColor.white
      timerLabel.numberOfLines = 1
      timerLabel.textAlignment = .left
      self.addSubview(timerLabel)
      timerLabel.isUserInteractionEnabled = false
      setTimerLabel(str: "00:00.000")
      timerLabel.sizeToFit()
    }
  }
  
  private func setupShapeLayers(){
    
    if timerCircle == nil && fillCircle == nil {
      
      timerCircle = CAShapeLayer()
      self.layer.addSublayer(timerCircle)
      
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
      timerCircle.zPosition = 1
      
      fillCircle = CAShapeLayer()
      self.layer.addSublayer(fillCircle)
      fillCircle.borderWidth = 1.0
      fillCircle.borderColor = UIColor.green.cgColor
      fillCircle.bounds = rect
      //fillCircle.anchorPoint = CGPoint(x: 0.5,y: 0.5)
      fillCircle.fillColor = Constants.Colors.foreground.cgColor
      fillCircle.position = self.center
      //fillCircle.backgroundColor = UIColor.white.cgColor
      fillCircle.path = path.cgPath
      fillCircle.zPosition = 0
      
    }
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
    
    if viewConstraints.isEmpty && timerLabel != nil{
      
      viewConstraints += [
        timerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        //timerLabel.leftAnchor.constraint(equalToSystemSpacingAfter: self.leftAnchor, multiplier: 1.0),
        //self.rightAnchor.constraint(equalToSystemSpacingAfter: timerLabel.rightAnchor, multiplier: 1.0),
        self.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: timerLabel.bottomAnchor, multiplier: 1.0)
      ]
      
      NSLayoutConstraint.activate(viewConstraints)
    }
    
    super.updateConstraints()
  }
  
  override func layoutSubviews() {
    
    setupShapeLayers()
    setupLabel()
    super.layoutSubviews()
  }
  
}
