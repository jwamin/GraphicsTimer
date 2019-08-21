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
  
  //MARK: Property Observers
  
  var position:CGPoint = .zero{
    didSet{
      if (updateRadiusRaw == nil){
        updatePositionOfHandle()
      }
    }
  }
  
  //MARK: Computed Properties

  
  private var updateRadiusRaw:CGFloat?
  
  public func clearRawRadius(){
    updateRadiusRaw = nil
  }
  
  //absolute radius ... used for calculating the... timers?
  var absoluteRadius:CGFloat{
    let center = self.center
    let radius = sqrt(pow(position.x - center.x,2) + pow(position.y - center.y,2))
    let maxWidth = self.frame.width/2
    return min(radius,maxWidth)
  }
  
  //radius for drawing, subtracts half the line width so ensures the entire circle fits on screen
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
  
  var diameter:CGFloat{
    
    return graphicalRadius * 2
  }
  
  var origin:CGPoint{
    
    return CGPoint(x: center.x - (diameter/2), y: center.y - (diameter/2))
  }
  
  var currentPosition:CGRect{
    
    return self.convert(timerCircle.frame, to: self)
  }
  
  var circleRect:CGRect{
    let size = CGSize(width: diameter, height: diameter)
    let rect = CGRect(origin: origin, size: size)
    let middle = CGPoint(x: rect.midX, y: rect.midY)
    precondition(middle == self.center)
    return rect
  }
  
  //MARK: Subviews
  
  private var timerLabel:UILabel!
  private var viewConstraints = [NSLayoutConstraint]()
  
  //MARK: Instance Methods
  
  override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    //setup displaylink
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
  
  public func setPaused(_ paused:Bool){
    
    let (path,anim) = makeFillAnimation(paused:paused)
    CATransaction.begin()
    CATransaction.setCompletionBlock {
      self.fillCircle.path = path
    }
    fillCircle.add(anim, forKey: "fillAnimation")
    CATransaction.commit()
    
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
      
      //setup timer circle, the "handle", replace this when just grabbing the circle
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
      
      //setup fill circle, for pause animation
      let secontPath = UIBezierPath(ovalIn: .zero)
      fillCircle = CAShapeLayer()
      self.layer.addSublayer(fillCircle)
      fillCircle.borderWidth = 1.0
      fillCircle.borderColor = UIColor.green.cgColor
      fillCircle.bounds = .zero
      //fillCircle.anchorPoint = CGPoint(x: 1,y: 0.5)
      fillCircle.fillColor = Constants.Colors.foreground.cgColor
      fillCircle.position = self.center
      //fillCircle.backgroundColor = UIColor.white.cgColor
      fillCircle.path = secontPath.cgPath
      fillCircle.zPosition = 0
      
    }
  }
  
  func toggleFill(_ override:Bool? = nil){
    
    fill = (override != nil) ? override! : !fill
    print("toggle \(fill)")
    timerCircle.fillColor = (fill) ? UIColor.white.cgColor : UIColor.clear.cgColor
  }
  
  //MARK: UIView update / lifecycle
  
  override func layoutSubviews() {
    
    setupShapeLayers()
    setupLabel()
    super.layoutSubviews()
    
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
  
  //draw method
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    //draws the main circle, CADisplayLink calls setNeedsDisplay which calls draw method
    let context = UIGraphicsGetCurrentContext()
    context?.move(to: position)
    context?.setStrokeColor(UIColor.blue.cgColor)
    context?.setLineWidth(Constants.Widths.main)
    context?.beginPath()
    context?.addArc(center: self.center, radius: graphicalRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
    context?.strokePath()
    
  }

  
}
