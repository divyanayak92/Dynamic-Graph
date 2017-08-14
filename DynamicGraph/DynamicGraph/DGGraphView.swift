//
//  DGGraphView.swift
//  DynamicGraph
//
//  Created by Divya Nayak on 13/08/17.
//

import Cocoa

class DGGraphView: NSView {
    
    fileprivate var cachedPoints = [CGPoint(x:0, y:0)]
    fileprivate var currentPoints : Array<CGPoint> = []
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawYGridLines()
        drawXGridLines()
        drawYAxis()
        drawXAxis()
        drawCurrentPoints()
        drawYAxisText()
        drawXAxisText()
    }
    
    func update(time:Double, withValue value:Int) {
        var graphValue:Int!
        if value == 0 {
            graphValue = abs(DGUtility.range().start) + 1
        } else {
            graphValue = value + DGUtility.range().end
        }
        updateCachedPoint(atTimeInterval: time, withValue: graphValue)
        self.setNeedsDisplay(frame)
    }
    
}

private extension DGGraphView {
    
    func updateCachedPoint(atTimeInterval time:Double, withValue value:Int) {
        let point = CGPoint(x:time, y:Double(value))
        cachedPoints.append(point)
    }
    
    func drawYGridLines() {
        for i in 0..<Int(frame.size.height) {
            if i % DGUtility.GRAPH_LINE_OFFSET == 0 {
                let yAxis = NSBezierPath()
                yAxis.move(to: CGPoint(x:visibleRect.origin.x + CGFloat(DGUtility.X_OFFSET), y:CGFloat(i)))
                let xpoint = CGPoint(x:frame.size.width, y:CGFloat(i))
                yAxis.line(to:xpoint)
                NSColor.lightGray.setStroke()
                yAxis.lineWidth = 1
                yAxis.stroke()
            }
        }
    }
    
    func drawXGridLines() {
        for i in 0..<Int(frame.size.width) {
            if i % DGUtility.GRAPH_LINE_OFFSET == 0 {
                let xAxis = NSBezierPath()
                xAxis.move(to: CGPoint(x:visibleRect.origin.x + CGFloat(DGUtility.X_OFFSET) + CGFloat(i), y:0))
                let xpoint = CGPoint(x:visibleRect.origin.x + CGFloat(DGUtility.X_OFFSET) + CGFloat(i), y:frame.size.height)
                xAxis.line(to:xpoint)
                NSColor.lightGray.setStroke()
                xAxis.lineWidth = 1
                xAxis.stroke()
            }
        }
    }
    
    func drawYAxis() {
        let yAxis = NSBezierPath()
        yAxis.move(to: CGPoint(x :visibleRect.origin.x + CGFloat(DGUtility.X_OFFSET), y:0))
        let ypoint = CGPoint(x:visibleRect.origin.x + CGFloat(DGUtility.X_OFFSET), y:frame.size.height)
        yAxis.line(to: ypoint)
        NSColor.black.setStroke()
        yAxis.lineWidth = 2
        yAxis.stroke()
    }
    
    func drawXAxis() {
        let xAxis = NSBezierPath()
        xAxis.move(to: CGPoint(x:visibleRect.origin.x, y:frame.size.height/2))
        let ypoint = CGPoint(x:visibleRect.origin.x + visibleRect.size.width, y:frame.size.height/2)
        xAxis.line(to: ypoint)
        NSColor.black.setStroke()
        xAxis.lineWidth = 2
        xAxis.stroke()
    }
    
    func drawCurrentPoints() {
        let drawRect = CGRect(x:visibleRect.origin.x + CGFloat(DGUtility.X_OFFSET),y:0,width:visibleRect.size.width, height:frame.size.height)
        let path = NSBezierPath()
        currentPoints.removeAll()
        
        let scaledPoints = cachedPoints.map { CGPoint(x:$0.x * CGFloat(DGUtility.scaleX) + CGFloat(DGUtility.X_OFFSET), y:$0.y * frame.size.height/CGFloat(DGUtility.totalValues()))
        }
            
        currentPoints = scaledPoints.filter {
            drawRect.contains($0)
        }
        
        if drawRect.origin.x > CGFloat(DGUtility.X_OFFSET) {
            guard let point = currentPoints.first else {
                return
            }
            path.move(to: point)
        } else {
            path.move(to: CGPoint(x:CGFloat(DGUtility.X_OFFSET), y:frame.size.height/2))
        }
        
        for point in currentPoints {
            path.line(to: point)
            path.lineWidth = 2.0
        }
        NSColor.red.setStroke()
        path.stroke()
    }
    
    func drawYAxisText() {
        for i in 0...(DGUtility.totalValues()) {
            if i == 0 {
                drawText(text: String(DGUtility.range().start), at: CGPoint(x:visibleRect.origin.x, y:-5))
            } else if i == (Int(abs(DGUtility.range().start)) + 1) {
                drawText(text:String(0), at:CGPoint(x:visibleRect.origin.x, y: CGFloat(i) * frame.size.height/CGFloat(DGUtility.totalValues()) - 10))
            } else if i == (DGUtility.totalValues()) {
                drawText(text: String(DGUtility.range().end), at:CGPoint(x:visibleRect.origin.x,y: CGFloat(i) * frame.size.height/CGFloat(DGUtility.totalValues()) - 10.0))
            } else {
                let value = i - (Int(abs(DGUtility.range().start)) + 1)
                if value % 10 == 0 {
                    drawText(text:String(value), at:CGPoint(x:visibleRect.origin.x, y:CGFloat(i) * frame.size.height/CGFloat(DGUtility.totalValues()) - 10))
                }
            }
        }
    }
    
    func drawXAxisText() {
        var originX = Int(visibleRect.origin.x)
        let scaleX = Int(DGUtility.scaleX)
        let reminder = originX % scaleX
        originX = originX - reminder
        var  xValue = DGUtility.X_OFFSET
        var i = 0
        while (xValue <= originX + Int(visibleRect.size.width)) {
            if (i % 10 == 0 && xValue >= Int(visibleRect.origin.x) + DGUtility.X_OFFSET) {
                drawText(text: String(i), at: CGPoint(x:CGFloat(xValue), y:frame.size.height/2))
            }
            i += 1;
            xValue += scaleX;
        }
    }
    
    func drawText(text:String, at point:CGPoint) {
        let textRect = CGRect(x:point.x, y:point.y, width:30, height:15)
        let dictionary = [NSFontAttributeName:NSFont(name:"Helvetica-Bold",size:12), NSForegroundColorAttributeName: NSColor.black]
        text.draw(in:textRect, withAttributes:dictionary)
    }
    
}
