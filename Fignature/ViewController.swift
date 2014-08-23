//
//  ViewController.swift
//  Fignature
//
//  Created by Mikhail Pchelnikov on 19/08/14.
//  Copyright (c) 2014 Mikhail Pchelnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let brush: CGFloat = 1.0
    
    var lastPoint: CGPoint!
    var red: CGFloat!
    var green: CGFloat!
    var blue: CGFloat!
    var lastClickedButton: UIView!
    
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
        
        makeLayout()
    }
    
    func makeLayout() {
        view.backgroundColor = UIColor.whiteColor()
        
        //Canvas image
        imageCanvasView = UIImageView()
        
        imageCanvasView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageCanvasView.contentMode = UIViewContentMode.ScaleToFill
        //imageCanvasView.backgroundColor = UIColor.grayColor()
        
        view.addSubview(imageCanvasView)
        
        //Reset button
        let buttonReset = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
        buttonReset.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonReset.frame = CGRectMake(16, 20, 40, 30)
        buttonReset.setTitle("Reset", forState: UIControlState.Normal)
        buttonReset.addTarget(self, action: Selector("reset:"), forControlEvents: UIControlEvents.TouchUpInside)
        buttonReset.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        view.addSubview(buttonReset)
        
        //Save button
        let buttonSave = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
        buttonSave.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonSave.setTitle("Save", forState: UIControlState.Normal)
        buttonSave.addTarget(self, action: Selector("save:"), forControlEvents: UIControlEvents.TouchUpInside)
        buttonSave.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        view.addSubview(buttonSave)
        
        //Black button
        blackButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
        blackButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        blackButton.frame = CGRectMake(0, 0, 40, 40)
        blackButton.backgroundColor = UIColor.blackColor()
        blackButton.addTarget(self, action: Selector("colorSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
        blackButton.tag = 0
        blackButton.layer.cornerRadius = 15
        blackButton.layer.masksToBounds = true
        doBorderButton(blackButton)
        
        view.addSubview(blackButton)
        
        //Blue button
        blueButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
        blueButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        blueButton.frame = CGRectMake(0, 0, 40, 40)
        blueButton.backgroundColor = UIColor.blueColor()
        blueButton.addTarget(self, action: Selector("colorSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
        blueButton.tag = 1
        blueButton.layer.cornerRadius = 15
        blueButton.layer.masksToBounds = true
        
        view.addSubview(blueButton)
        
        //Red button
        redButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        
        redButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        redButton.frame = CGRectMake(0, 0, 40, 40)
        redButton.backgroundColor = UIColor.redColor()
        redButton.addTarget(self, action: Selector("colorSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
        redButton.tag = 2
        redButton.layer.cornerRadius = 15
        redButton.layer.masksToBounds = true
        
        view.addSubview(redButton)
        
        //Canvas constraints
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: imageCanvasView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        //Reset button constraints
        view.addConstraint(NSLayoutConstraint(item: buttonReset, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: buttonReset, attribute: NSLayoutAttribute.Leading, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 5))
        
        //Save button constraints
        view.addConstraint(NSLayoutConstraint(item: buttonSave, attribute: NSLayoutAttribute.Top, relatedBy: .Equal, toItem: topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: buttonSave, attribute: NSLayoutAttribute.Trailing, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -5))
        
        //Black button contraints
        view.addConstraint(NSLayoutConstraint(item: blackButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 5))
        view.addConstraint(NSLayoutConstraint(item: blackButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -10))
        
        //Blue button constraints
        view.addConstraint(NSLayoutConstraint(item: blueButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: blackButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: blueButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -10))
        
        //Red button constraints
        view.addConstraint(NSLayoutConstraint(item: redButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: blueButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: redButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bottomLayoutGuide, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: -10))
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(sender: UIButton) {
        self.imageCanvasView.image = nil
    }
    
    @IBAction func save(sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(self.imageCanvasView.bounds.size, false, 0.0)
        self.imageCanvasView.image?.drawInRect(CGRectMake(0, 0, self.imageCanvasView.frame.size.width, self.imageCanvasView.frame.size.height))
        var saveImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(saveImage, self, Selector("image:didFinishSavingWithError:contextInfo:"), nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        if error != nil {
            UIAlertView(title: "Error", message: "Image could not be saved.Please try again", delegate: self, cancelButtonTitle: "Close").show()
        } else {
            UIAlertView(title: "Succes", message: "Image has been saved to your Camera Roll successfully", delegate: self, cancelButtonTitle: "Close").show()
        }
    }
    
    @IBAction func colorSelected(sender: UIButton) {
        switch sender.tag {
        case 0:
            red = 0.0/255.0
            green = 0.0/255.0
            blue = 0.0/255.0
            doBorderButton(blackButton)
        case 1:
            red = 0.0/255.0
            green = 0.0/255.0
            blue = 255.0/255.0
            doBorderButton(blueButton)
        case 2:
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
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            lastPoint = touch.locationInView(view)
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var currentLocation = CGPointMake(0.0, 0.0)
        
        for touch: AnyObject in touches {
            currentLocation = touch.locationInView(view)
        }
        
        UIGraphicsBeginImageContext(view.bounds.size)
        
        var ctx :CGContextRef = UIGraphicsGetCurrentContext()
        
        self.imageCanvasView.image?.drawInRect(CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextSetLineWidth(ctx, brush)
        CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0)
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y)
        CGContextStrokePath(ctx)
        self.imageCanvasView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currentLocation
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        var currentLocation = CGPointMake(0.0, 0.0)
        
        for touch: AnyObject in touches {
            currentLocation = touch.locationInView(view)
        }
        
        UIGraphicsBeginImageContext(view.bounds.size)
        
        var ctx :CGContextRef = UIGraphicsGetCurrentContext()
        
        self.imageCanvasView.image?.drawInRect(CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height))
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextSetLineWidth(ctx, brush)
        CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0)
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y)
        CGContextStrokePath(ctx)
        self.imageCanvasView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currentLocation
    }

}

