//
//  SmoothSignatureView.swift
//  Fignature
//
//  Created by Mikhail Pchelnikov on 26.08.14.
//  Copyright (c) 2014 Mikhail Pchelnikov. All rights reserved.
//

import UIKit

class SmoothSignatureView: UIView {

    let fudgeFactor: Float = 0.2
    let lower: Float = 0.01
    let upper: Float = 3.0
    
    var incrementalImage: UIImage!
    var points = [CGPoint](count: 5, repeatedValue: CGPoint(x: 0, y: 0))
    var counter: Int = 0
    var pointsBuffer = [CGPoint](count: 100, repeatedValue: CGPoint(x: 0, y: 0))
    var bufIdx: Int = 0
    var drawingQueue: dispatch_queue_t!
    var isFirstTouchPoint: Bool = false
    var lastSegmentOfPrev: LineSegment!
    
    struct LineSegment {
        var firstPoint: CGPoint
        var secondPoint: CGPoint
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        multipleTouchEnabled = false
        
        drawingQueue = dispatch_queue_create("drawingQueue", nil)
        
        var pan = UIPanGestureRecognizer(target: self, action: "pan:")
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        addGestureRecognizer(pan)
        
        var tap = UITapGestureRecognizer(target: self, action: "eraseDrawing:")
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func eraseDrawing(tap: UITapGestureRecognizer) {
        incrementalImage = nil
        setNeedsDisplay()
    }
    
    func pan(pan: UIGestureRecognizer) {
        switch pan.state {
        case .Began:
            counter = 0
            bufIdx = 0
            
            points[0] = pan.locationInView(self)
            
            isFirstTouchPoint = true
        case .Changed:
            var p: CGPoint = pan.locationInView(self)
            
            ++counter
            points[counter] = p
            
            if counter == 4 {
                points[3] = CGPointMake((points[2].x + points[4].x)/2.0, (points[2].y + points[4].y)/2.0)
                
                for var i = 0; i < 4; ++i {
                    pointsBuffer[bufIdx + i] = points[i]
                }
                
                bufIdx += 4
                
                var bounds: CGRect = self.bounds
                
                dispatch_async(drawingQueue, {
                    var offsetPath = UIBezierPath()
                    
                    if self.bufIdx == 0 {
                        return
                    }
                    
                    var ls = [LineSegment](count: 4, repeatedValue: LineSegment(firstPoint: CGPoint(x: 0, y: 0), secondPoint: CGPoint(x: 0, y: 0)))
                    
                    for var i = 0; i < self.bufIdx; i+=4 {
                        if self.isFirstTouchPoint {
                            ls[0] = LineSegment(firstPoint: self.pointsBuffer[0], secondPoint: self.pointsBuffer[0])
                            offsetPath.moveToPoint(ls[0].firstPoint)
                            self.isFirstTouchPoint = false
                        } else {
                            ls[0] = self.lastSegmentOfPrev
                        }
                        
                        var fraction1: Float = self.fudgeFactor / self.clamp(self.len_sq(self.pointsBuffer[i], p2: self.pointsBuffer[i+1]), lower: self.lower, higher: self.upper)
                        var fraction2: Float = self.fudgeFactor / self.clamp(self.len_sq(self.pointsBuffer[i+1], p2: self.pointsBuffer[i+2]), lower: self.lower, higher: self.upper)
                        var fraction3: Float = self.fudgeFactor / self.clamp(self.len_sq(self.pointsBuffer[i+2], p2: self.pointsBuffer[i+3]), lower: self.lower, higher: self.upper)
                        
                        ls[1] = self.lineSegmentPerpendicular(LineSegment(firstPoint: self.pointsBuffer[i], secondPoint: self.pointsBuffer[i+1]), fraction: fraction1)
                        ls[2] = self.lineSegmentPerpendicular(LineSegment(firstPoint: self.pointsBuffer[i+1], secondPoint: self.pointsBuffer[i+2]), fraction: fraction2)
                        ls[3] = self.lineSegmentPerpendicular(LineSegment(firstPoint: self.pointsBuffer[i+2], secondPoint: self.pointsBuffer[i+3]), fraction: fraction3)
                        
                        offsetPath.moveToPoint(ls[0].firstPoint)
                        offsetPath.addCurveToPoint(ls[3].firstPoint, controlPoint1: ls[1].firstPoint, controlPoint2: ls[2].firstPoint)
                        offsetPath.addLineToPoint(ls[3].secondPoint)
                        offsetPath.addCurveToPoint(ls[0].secondPoint, controlPoint1: ls[2].secondPoint, controlPoint2: ls[1].secondPoint)
                        offsetPath.closePath()
                        
                        self.lastSegmentOfPrev = ls[3]
                    }
                    
                    UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
                    
                    if !(self.incrementalImage != nil) {
                        var rectpath: UIBezierPath = UIBezierPath(rect: self.bounds)
                        UIColor.whiteColor().setFill()
                        rectpath.fill()
                    }
                    
                    self.incrementalImage?.drawAtPoint(CGPointZero)
                    UIColor.blackColor().setStroke()
                    UIColor.blackColor().setFill()
                    offsetPath.stroke()
                    offsetPath.fill()
                    
                    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    offsetPath.removeAllPoints()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.bufIdx = 0
                        self.setNeedsDisplay()
                    })
                })
                points[0] = points[3]
                points[1] = points[4]
                counter = 1
            }
        case .Ended:
            setNeedsDisplay()
        case .Cancelled:
            setNeedsDisplay()
        default:
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect)
    {        
        incrementalImage?.drawInRect(rect)
    }
    
    func clamp(value: Float, lower: Float, higher: Float) -> Float {
        if value < lower {
            return lower
        }
        if value > higher {
            return higher
        }
        return value
    }
    
    func len_sq(p1: CGPoint, p2: CGPoint) -> Float {
        var dx: Float = Float(p2.x) - Float(p1.x)
        var dy: Float = Float(p2.y) - Float(p1.y)
        
        return dx * dx + dy * dy
    }
    
    func lineSegmentPerpendicular(pp: LineSegment, fraction: Float) -> LineSegment {
        var x0: CGFloat = pp.firstPoint.x
        var y0: CGFloat = pp.firstPoint.y
        var x1: CGFloat = pp.secondPoint.x
        var y1: CGFloat = pp.secondPoint.y
        
        var dx, dy: CGFloat!
        
        dx = x1 - x0
        dy = y1 - y0
        
        var xa, ya, xb, yb: CGFloat!
        
        xa = x1 + CGFloat(fraction)/2 * dy
        ya = y1 - CGFloat(fraction)/2 * dx
        xb = x1 - CGFloat(fraction)/2 * dy
        yb = y1 + CGFloat(fraction)/2 * dx
        
        return LineSegment(firstPoint: CGPoint(x: xa, y: ya), secondPoint: CGPoint(x: xb, y: yb))
    }

}
