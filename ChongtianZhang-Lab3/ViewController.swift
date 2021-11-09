//
//  ViewController.swift
//  ChongtianZhang-Lab3
//
//  Created by Chongtian Zhang on 10/4/21.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var currentColor:UIColor?
    var currentStroke:UIColor?
    var currentShape:Shape?
    var currentBack:UIColor?
    
    enum Shapes{
        case Circle
        case Rectangle
        case Triangle
    }
    
    enum Modes{
        case Draw
        case Move
        case Erase
        case DrawOut
        case Edit
    }
    
    var tempShapeName=Shapes.Circle
    var tempModeName=Modes.Draw
    @IBOutlet weak var Canvas: DrawingView!
    @IBOutlet weak var segmentShape: UISegmentedControl!
    @IBOutlet weak var segmentColor: UISegmentedControl!
    @IBOutlet weak var segmentMode: UISegmentedControl!
    @IBOutlet weak var segmentStroke: UISegmentedControl!
    @IBOutlet weak var Opacity: UISlider!
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {true}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        currentColor=UIColor.red
        currentStroke=UIColor.black
        currentBack=UIColor.clear
        Canvas.backgroundColor=currentBack
    }
    @IBAction func switchOpacaiy(_ sender: Any) {
        Canvas.alpha=CGFloat(Opacity.value)
    }
    @IBAction func switchBack(_ sender: Any) {
        if  currentBack==UIColor.clear{
            currentBack=UIColor.brown
            Canvas.backgroundColor=currentBack
        }
        else if currentBack==UIColor.brown{
            currentBack=UIColor.black
            Canvas.backgroundColor=currentBack
        }
        else if currentBack==UIColor.black{
            currentBack=UIColor.clear
            Canvas.backgroundColor=currentBack
        }
    }
    

    @IBAction func ZoomShape(_ sender: UIPinchGestureRecognizer) {
        if tempModeName==Modes.Move {
            guard let tempShape=Canvas.itemAtLocation(sender.location(in: Canvas)) as? Shape
            else{
                return
            }
            let tempSize=tempShape.getSize()*sender.scale
            tempShape.setSize(size: tempSize)
            tempShape.newPath()
            tempShape.path?.rotate(by: tempShape.angle)
            tempShape.draw()
            Canvas.setNeedsDisplay()
            sender.scale=1.0
        }
    }
    
    @IBAction func rotateShape(_ sender: UIRotationGestureRecognizer) {
        if tempModeName==Modes.Move{
            guard let tempShape=Canvas.itemAtLocation(sender.location(in: Canvas)) as? Shape
            else{
                return
            }
            tempShape.path?.rotate(by: sender.rotation)
            tempShape.draw()
            tempShape.angle+=sender.rotation
            Canvas.setNeedsDisplay()
            sender.rotation=0
        }
    }
    
    @IBAction func switchColor(_ sender: Any) {
        if (segmentColor.selectedSegmentIndex==0) {
            currentColor=UIColor.red
        }
        else if (segmentColor.selectedSegmentIndex==1){
            currentColor=UIColor.orange
        }
        else if (segmentColor.selectedSegmentIndex==2){
            currentColor=UIColor.blue
        }
        else if (segmentColor.selectedSegmentIndex==3){
            currentColor=UIColor.green
        }
        else if (segmentColor.selectedSegmentIndex==4){
            currentColor=UIColor.systemPurple
        }
    }
    
    @IBAction func switchStroke(_ sender: Any) {
        if (segmentStroke.selectedSegmentIndex==0){
            currentStroke=UIColor.black
        }
        else if (segmentStroke.selectedSegmentIndex==1){
            currentStroke=UIColor.yellow
        }
        else if (segmentStroke.selectedSegmentIndex==2){
            currentStroke=UIColor.systemPink
        }
        else if (segmentStroke.selectedSegmentIndex==3){
            currentStroke=UIColor.gray
        }
        else if (segmentStroke.selectedSegmentIndex==4){
            currentStroke=UIColor.clear
        }
    }
    
    
    @IBAction func switchShape(_ sender: Any) {
        if(segmentShape.selectedSegmentIndex==0){
            tempShapeName=Shapes.Circle
        }
        else if (segmentShape.selectedSegmentIndex==1) {
            tempShapeName=Shapes.Rectangle
        }
        else if (segmentShape.selectedSegmentIndex==2) {
            tempShapeName=Shapes.Triangle
        }
    }
    @IBAction func ClearAll(_ sender: Any) {
        Canvas.items=[]
    }
    
    @IBAction func switchMode(_ sender: Any) {
        if segmentMode.selectedSegmentIndex==0 {
            tempModeName=Modes.Draw
        }
        else if segmentMode.selectedSegmentIndex==1{
            tempModeName=Modes.Move
        }
        else if segmentMode.selectedSegmentIndex==2{
            tempModeName=Modes.Erase
        }
        else if segmentMode.selectedSegmentIndex==3{
            tempModeName=Modes.DrawOut
        }
        else if segmentMode.selectedSegmentIndex==4{
            tempModeName=Modes.Edit
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard touches.count==1, let touchPoint=(touches.first)?.location(in: view)
        else {
            return
        }

        if tempModeName==Modes.Draw {
            switch tempShapeName{
            case .Circle:
                currentShape = Circle(origin: touchPoint, color: currentColor!)
                
            case .Rectangle:
                currentShape = Rectangle(origin: touchPoint, color: currentColor!)
                
            case .Triangle:
                currentShape = Triangle(origin: touchPoint, color: currentColor!)
            }
            currentShape!.strokeColor=currentStroke!
            currentShape!.newPath()
            currentShape!.draw()
            Canvas.items.append(currentShape!)
        }
        
        else if tempModeName==Modes.DrawOut{
            switch tempShapeName{
            case .Circle:
                currentShape = OutlineCircle(origin: touchPoint, color: currentColor!)
                
            case .Rectangle:
                currentShape = OutlineRect(origin: touchPoint, color: currentColor!)
                
            case .Triangle:
                currentShape = OutlineTri(origin: touchPoint, color: currentColor!)
            }
            currentShape!.strokeColor=currentStroke!
            currentShape!.newPath()
            currentShape!.draw()
            Canvas.items.append(currentShape!)
        }

        else if tempModeName==Modes.Erase{
            if let indexRemove = Canvas.items.firstIndex(where: {$0 === Canvas.itemAtLocation(touchPoint)})
                {
                    Canvas.items.remove(at: indexRemove)
                }
        }
        
        else if tempModeName==Modes.Edit{
            guard let shapeEdit = Canvas.itemAtLocation(touchPoint) as? Shape else{
                return
            }
            shapeEdit.color=currentColor!
            shapeEdit.strokeColor=currentStroke!
            Canvas.setNeedsDisplay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count==1, let touchPoint=(touches.first)?.location(in: view)
        else {
            return
        }
        if tempModeName==Modes.Move{
            guard let tempShape=Canvas.itemAtLocation(touchPoint) as? Shape else {
                return
            }
            tempShape.center.x=touchPoint.x
            tempShape.center.y=touchPoint.y
            tempShape.newPath()
            tempShape.path?.rotate(by: tempShape.angle)
            tempShape.draw()
            Canvas.setNeedsDisplay()
        }
    }
}
