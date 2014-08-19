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
    
    @IBOutlet weak var canvas: UIImageView!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        red = 0.0/255.0
        green = 0.0/255.0
        blue = 0.0/255.0
        
        self.blackButton.layer.cornerRadius = self.blackButton.frame.size.width / 2
        self.blackButton.layer.masksToBounds = true
        doBorderButton(self.blackButton)
        
        self.blueButton.layer.cornerRadius = self.blueButton.frame.size.width / 2
        self.blueButton.clipsToBounds = true
        
        self.redButton.layer.cornerRadius = self.redButton.frame.size.width / 2
        self.redButton.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reset(sender: UIButton) {
        self.canvas.image = nil
    }
    
    @IBAction func save(sender: UIButton) {
        UIGraphicsBeginImageContextWithOptions(self.canvas.bounds.size, false, 0.0)
        self.canvas.image?.drawInRect(CGRectMake(0, 0, self.canvas.frame.size.width, self.canvas.frame.size.height))
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
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        var currentLocation = CGPointMake(0.0, 0.0)
        
        for touch: AnyObject in touches {
            currentLocation = touch.locationInView(self.view)
        }
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        var ctx :CGContextRef = UIGraphicsGetCurrentContext()
        
        self.canvas.image?.drawInRect(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextSetLineWidth(ctx, brush)
        CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0)
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y)
        CGContextStrokePath(ctx)
        self.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currentLocation
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        var currentLocation = CGPointMake(0.0, 0.0)
        
        for touch: AnyObject in touches {
            currentLocation = touch.locationInView(self.view)
        }
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        var ctx :CGContextRef = UIGraphicsGetCurrentContext()
        
        self.canvas.image?.drawInRect(CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        CGContextSetLineCap(ctx, kCGLineCapRound)
        CGContextSetLineWidth(ctx, brush)
        CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0)
        CGContextBeginPath(ctx)
        CGContextMoveToPoint(ctx, lastPoint.x, lastPoint.y)
        CGContextAddLineToPoint(ctx, currentLocation.x, currentLocation.y)
        CGContextStrokePath(ctx)
        self.canvas.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currentLocation
    }

}

