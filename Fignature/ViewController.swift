//
//  ViewController.swift
//  Fignature
//
//  Created by Mikhail Pchelnikov on 19/08/14.
//  Copyright (c) 2014 Mikhail Pchelnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let brush: CGFloat = 1.5
    
    var canvasView: SmoothSignatureView!
    
    //var lastPoint: CGPoint!
    var red: CGFloat!
    var green: CGFloat!
    var blue: CGFloat!
    var lastClickedButton: UIView!
    //var path: UIBezierPath!
    
    //Controls
    var imageCanvasView: UIImageView!
    var blackButton: UIButton!
    var blueButton: UIButton!
    var redButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        red = 0.0/255.0
        green = 0.0/255.0
        blue = 0.0/255.0
        
//        createNewPath()
//        
//        var pan = UIPanGestureRecognizer(target: self, action: "pan:")
//        pan.maximumNumberOfTouches = 1
//        pan.minimumNumberOfTouches = 1
//        view.addGestureRecognizer(pan)
//        
//        makeLayout()
        
        //view = SmoothSignatureView(frame: view.bounds)

        makeLayout()
    }
    
//    func createNewPath() {
//        path = UIBezierPath()
//        path.lineWidth = brush
//    }
    
    func makeLayout() {
        view.backgroundColor = UIColor.whiteColor()
        
        canvasView = SmoothSignatureView(frame: view.bounds)
        view.addSubview(canvasView)
        
        //Canvas image
        imageCanvasView = UIImageView()
        
        imageCanvasView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageCanvasView.contentMode = .ScaleToFill
        //imageCanvasView.backgroundColor = UIColor.grayColor()
        
        view.addSubview(imageCanvasView)
        
        //Reset button
        let buttonReset = UIButton.buttonWithType(.System) as UIButton
        
        buttonReset.setTranslatesAutoresizingMaskIntoConstraints(false)
        //buttonReset.frame = CGRectMake(16, 20, 40, 30)
        buttonReset.titleLabel.font = UIFont.systemFontOfSize(17)
        buttonReset.setTitle("Reset", forState: .Normal)
        buttonReset.addTarget(self, action: "reset:", forControlEvents: .TouchUpInside)
        buttonReset.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        view.addSubview(buttonReset)
        
        //Save button
        let buttonSave = UIButton.buttonWithType(.System) as UIButton
        
        buttonSave.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonSave.titleLabel.font = UIFont.systemFontOfSize(17)
        buttonSave.setTitle("Save", forState: .Normal)
        buttonSave.addTarget(self, action: "save:", forControlEvents: .TouchUpInside)
        buttonSave.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        view.addSubview(buttonSave)
        
        //Black button
        blackButton = UIButton.buttonWithType(.System) as UIButton
        
        blackButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        blackButton.backgroundColor = UIColor.blackColor()
        blackButton.addTarget(self, action: "colorSelected:", forControlEvents: .TouchUpInside)
        blackButton.layer.cornerRadius = 15
        blackButton.layer.masksToBounds = true
        doBorderButton(blackButton)
        
        view.addSubview(blackButton)
        
        //Blue button
        blueButton = UIButton.buttonWithType(.System) as UIButton
        
        blueButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        blueButton.backgroundColor = UIColor.blueColor()
        blueButton.addTarget(self, action: "colorSelected:", forControlEvents: .TouchUpInside)
        blueButton.layer.cornerRadius = 15
        blueButton.layer.masksToBounds = true
        
        view.addSubview(blueButton)
        
        //Red button
        redButton = UIButton.buttonWithType(.System) as UIButton
        
        redButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        redButton.backgroundColor = UIColor.redColor()
        redButton.addTarget(self, action: "colorSelected:", forControlEvents: .TouchUpInside)
        redButton.layer.cornerRadius = 15
        redButton.layer.masksToBounds = true
        
        view.addSubview(redButton)
        
        //Canvas constraints
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0))
        
        //Reset button constraints
        view.addConstraint(NSLayoutConstraint(item: buttonReset, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: buttonReset, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 5))
        
        //Save button constraints
        view.addConstraint(NSLayoutConstraint(item: buttonSave, attribute: .Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: .Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: buttonSave, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -5))
        
        //Black button contraints
        view.addConstraint(NSLayoutConstraint(item: blackButton, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 5))
        view.addConstraint(NSLayoutConstraint(item: blackButton, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: -10))
        
        //Blue button constraints
        view.addConstraint(NSLayoutConstraint(item: blueButton, attribute: .Leading, relatedBy: .Equal, toItem: blackButton, attribute: .Trailing, multiplier: 1.0, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: blueButton, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: -10))
        
        //Red button constraints
        view.addConstraint(NSLayoutConstraint(item: redButton, attribute: .Leading, relatedBy: .Equal, toItem: blueButton, attribute: .Trailing, multiplier: 1.0, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: redButton, attribute: .Bottom, relatedBy: .Equal, toItem: bottomLayoutGuide, attribute: .Top, multiplier: 1.0, constant: -10))
        
        //Draw a line
        let lineView: UIView = UIView()
        
        lineView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineView.backgroundColor = UIColor.blackColor()
        view.addSubview(lineView)
        
        view.addConstraint(NSLayoutConstraint(item:lineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 2))
        view.addConstraint(NSLayoutConstraint(item: lineView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: lineView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: (view.bounds.height / 3.0) * -1))
        view.addConstraint(NSLayoutConstraint(item: lineView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -30))
    }
    
    override func supportedInterfaceOrientations() -> Int {
        //return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        return Int(UIInterfaceOrientationMask.Portrait.toRaw())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reset(sender: UIButton) {
        self.imageCanvasView.image = nil
        //createNewPath()
    }
    
    func save(sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(self.imageCanvasView.bounds.size, false, 0.0)
        self.imageCanvasView.image?.drawInRect(CGRectMake(0, 0, self.imageCanvasView.frame.size.width, self.imageCanvasView.frame.size.height))
        var saveImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(saveImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        if error != nil {
            UIAlertView(title: "Error", message: "Image could not be saved.Please try again", delegate: self, cancelButtonTitle: "Close").show()
        } else {
            UIAlertView(title: "Succes", message: "Image has been saved to your Camera Roll successfully", delegate: self, cancelButtonTitle: "Close").show()
        }
    }
    
    func colorSelected(sender: UIButton) {
        switch sender {
        case blackButton:
            red = 0.0/255.0
            green = 0.0/255.0
            blue = 0.0/255.0
            doBorderButton(blackButton)
        case blueButton:
            red = 0.0/255.0
            green = 0.0/255.0
            blue = 255.0/255.0
            doBorderButton(blueButton)
        case redButton:
            red = 255.0/255.0
            green = 0.0/255.0
            blue = 0.0/255.0
            doBorderButton(redButton)
        default:
            red = 0.0/255.0
            green = 0.0/255.0
            blue = 0.0/255.0
            doBorderButton(blackButton)
        }
        
        //createNewPath()
    }
    
    func doBorderButton(button: UIButton) {
        if lastClickedButton != nil && lastClickedButton != button {
            lastClickedButton.layer.borderWidth = 2.0
            lastClickedButton.layer.borderColor = UIColor.clearColor().CGColor
        }
        
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.grayColor().CGColor
        
        lastClickedButton = button
    }
    
//    func pan(pan: UIGestureRecognizer) {
//        var currentPoint = pan.locationInView(view)
//        
//        if pan.state == UIGestureRecognizerState.Began {
//            
//            path.moveToPoint(currentPoint)
//            
//            lastPoint = currentPoint
//            
//        } else if pan.state == UIGestureRecognizerState.Changed {
//            
//            var midPoint = midpoint(p0: lastPoint, p1: currentPoint)
//            
//            path.addQuadCurveToPoint(midPoint, controlPoint: lastPoint)
//            
//            UIGraphicsBeginImageContext(view.bounds.size)
//            
//            imageCanvasView.image?.drawInRect(CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
//            UIColor(red: red, green: green, blue: blue, alpha: 1.0).setStroke()
//            path.stroke()
//            imageCanvasView.image = UIGraphicsGetImageFromCurrentImageContext()
//            
//            UIGraphicsEndImageContext()
//            
//            lastPoint = currentPoint
//        }
//        
//        view.setNeedsDisplay()
//    }
//    
//    func midpoint(#p0: CGPoint, p1: CGPoint) -> CGPoint {
//        return CGPoint(x: (p0.x + p1.x) / 2.0, y: (p0.y + p1.y) / 2.0)
//            
//    }
    
}

