//
//  ViewController.swift
//  Fignature
//
//  Created by Mikhail Pchelnikov on 19/08/14.
//  Copyright (c) 2014 Mikhail Pchelnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var canvasView: SmoothSignatureView!
    var lastClickedButton: UIView!
    
    //Controls
    var blackButton: UIButton!
    var blueButton: UIButton!
    var redButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeLayout()
    }
    
    func makeLayout() {
        view.backgroundColor = UIColor.whiteColor()
        
        //Canvas view
        canvasView = SmoothSignatureView(frame: view.bounds)
        canvasView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        view.addSubview(canvasView)
        
        //Reset button
        let buttonReset = UIButton.buttonWithType(.System) as UIButton
        
        buttonReset.setTranslatesAutoresizingMaskIntoConstraints(false)
        //buttonReset.frame = CGRectMake(16, 20, 40, 30)
        buttonReset.titleLabel?.font = UIFont.systemFontOfSize(17)
        buttonReset.setTitle("Reset", forState: .Normal)
        buttonReset.addTarget(self, action: "reset:", forControlEvents: .TouchUpInside)
        buttonReset.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        view.addSubview(buttonReset)
        
        //Save button
        let buttonSave = UIButton.buttonWithType(.System) as UIButton
        
        buttonSave.setTranslatesAutoresizingMaskIntoConstraints(false)
        buttonSave.titleLabel?.font = UIFont.systemFontOfSize(17)
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
        
        //Draw a line
        let lineView: UIView = UIView()
        
        lineView.setTranslatesAutoresizingMaskIntoConstraints(false)
        lineView.backgroundColor = UIColor.blackColor()
        
        view.addSubview(lineView)
        
        //Canvas constraints
        view.addConstraint(NSLayoutConstraint(item: canvasView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: canvasView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: canvasView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: canvasView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0))
        
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
        
        //Line constraints
        view.addConstraint(NSLayoutConstraint(item:lineView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 1))
        view.addConstraint(NSLayoutConstraint(item: lineView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: lineView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: (view.bounds.size.height / 4.0) * -1))
        view.addConstraint(NSLayoutConstraint(item: lineView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: -30))
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.toRaw())
        //return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reset(sender: UIButton) {
        canvasView.eraseDrawing()
        canvasView.drawRect(canvasView.bounds)
    }
    
    func save(sender: UIButton) {
        canvasView.save()
    }
    
    func colorSelected(sender: UIButton) {
        switch sender {
        case blackButton:
            canvasView.signatureColor = UIColor.blackColor()
            doBorderButton(blackButton)
        case blueButton:
            canvasView.signatureColor = UIColor.blueColor()
            doBorderButton(blueButton)
        case redButton:
            canvasView.signatureColor = UIColor.redColor()
            doBorderButton(redButton)
        default:
            canvasView.signatureColor = UIColor.blackColor()
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

}

