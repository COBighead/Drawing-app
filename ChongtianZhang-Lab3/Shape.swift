//
//  Shape.swift
//  CSE 438S Lab 3
//
//  Created by Michael Ginn on 5/31/21.
//

import UIKit

/**
 YOU SHOULD MODIFY THIS FILE.
 
 Feel free to implement it however you want, adding properties, methods, etc. Your different shapes might be subclasses of this class, or you could store information in this class about which type of shape it is. Remember that you are partially graded based on object-oriented design. You may ask TAs for an assessment of your implementation.
 */

/// A `DrawingItem` that draws some shape to the screen.
class Shape: DrawingItem {
    
    var center:CGPoint
    var color:UIColor
    var path:UIBezierPath?
    var angle:CGFloat
    var strokeColor:UIColor
    public required init(origin: CGPoint, color: UIColor){
        self.center=origin
        self.color=color
        self.angle=0
        self.strokeColor=UIColor.black
    }
    
    func draw() {
        fatalError("IMPLEMENT THIS")
    }
    
    func newPath(){}
    func getSize()->CGFloat{return 0}
    func setSize(size: CGFloat){}
    func contains(point: CGPoint) -> Bool {
        fatalError("IMPLEMENT THIS")
    }
}
extension UIBezierPath {
    func rotate(by angleRadians: CGFloat){
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: angleRadians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        self.apply(transform)
    }
}

class Rectangle:Shape{
    var side:CGFloat = 50.0
    
    override func getSize()->CGFloat {
        return self.side
    }
    override func setSize(size: CGFloat) {
        self.side=size
    }
    override func newPath(){
        path=UIBezierPath()
        path!.move(to: CGPoint(x: center.x-(side/2), y: center.y+(side/2)))
        path!.addLine(to: CGPoint(x: center.x+(side/2), y: center.y+(side/2)))
        path!.addLine(to: CGPoint(x: center.x+(side/2), y: center.y-(side/2)))
        path!.addLine(to: CGPoint(x: center.x-(side/2), y: center.y-(side/2)))
        path!.close()
    }
    
    override func draw() {
        color.setFill()
        path!.fill()
        strokeColor.setStroke()
        path?.stroke()
    }
    override func contains(point: CGPoint) -> Bool {
        return self.path!.contains(point)
    }
}

class OutlineRect:Rectangle{
    override func draw() {
        strokeColor.setStroke()
        path?.stroke()
    }
}

class Circle:Shape{
    var Radius:CGFloat = 25.0
    override func getSize() -> CGFloat {
        return self.Radius
    }
    override func setSize(size: CGFloat) {
        self.Radius=size
    }
    override func newPath(){
        path=UIBezierPath()
        path!.addArc(withCenter: center, radius: Radius, startAngle: 0, endAngle: CGFloat(Float.pi*2), clockwise: true)
    }
    override func draw() {
        color.setFill()
        path!.fill()
        strokeColor.setStroke()
        path?.stroke()
    }
    
    override func contains(point: CGPoint) -> Bool {
        return self.path!.contains(point)
    }
}

class OutlineCircle:Circle{
    override func draw() {
        strokeColor.setStroke()
        path?.stroke()
    }
}

class Triangle:Shape{
    var side:CGFloat = 50.0
    override func getSize() -> CGFloat {
        return self.side
    }
    override func setSize(size: CGFloat) {
        self.side=size
    }
    override func newPath() {
        path=UIBezierPath ()
        path!.move(to: CGPoint(x:center.x-(side/2), y:center.y+(sqrt(3)*side/6)))
        path!.addLine(to: CGPoint(x:center.x, y:center.y-(sqrt(3)*side/3)))
        path!.addLine(to: CGPoint(x:center.x+(side/2) ,y:center.y+(sqrt(3)*side/6)))
        path!.close()
    }
    override func draw() {
        color.setFill()
        path!.fill()
        strokeColor.setStroke()
        path?.stroke()
    }

    override func contains(point: CGPoint) -> Bool {
        return self.path!.contains(point)
    }
}

class OutlineTri:Triangle{
    override func draw() {
        strokeColor.setStroke()
        path?.stroke()
    }
}
