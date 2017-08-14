//
//  DGMainViewController.swift
//  DynamicGraph
//
//  Created by Divya Nayak on 13/08/17.
//

import Cocoa

class DGMainViewController: NSViewController {
    
    fileprivate let timeInterval = 0.1
    fileprivate var timer : Timer!
    fileprivate var shouldScroll = true
    fileprivate var previousRect : CGRect!
    fileprivate var graphView : DGGraphView {
        return self.graphScrollView.documentView as! DGGraphView
    }
    fileprivate var timeElapsed = Double(0)
    
    @IBOutlet weak var graphScrollView: NSScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        addTimer()
        addGestureRecognisers()
        var frame = view.frame
        frame.origin = CGPoint.zero
        graphView.frame = frame
    }
}

private extension DGMainViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSViewBoundsDidChange, object: nil, queue: nil) { (notification) in
            self.boundsDidChangeTriggered()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSScrollViewWillStartLiveScroll, object: nil, queue: nil) { (notification) in
            self.scrollViewWillStartLiveScrollTriggered()
        }
    }
    
    func boundsDidChangeTriggered() {
        graphView.setNeedsDisplay(graphView.frame)
    }
    
    func scrollViewWillStartLiveScrollTriggered() {
        shouldScroll = false
    }
    
    func addTimer () {
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { (timer) in
            self.timeElapsed = self.timeElapsed + 1
            let rand = self.generaterandom(upperbound:DGUtility.totalValues(), lowerBound:0) - abs(DGUtility.range().start)
            self.graphView.update(time: self.timeElapsed, withValue: rand)
            if self.timeElapsed > 10 {
                self.graphView.frame = CGRect(x:0, y:0, width:self.graphView.frame.size.width + 100, height:self.graphView.frame.size.height);
            }
            self.scrollGraphView()
        })
    }
    
    func generaterandom(upperbound up:Int, lowerBound low:(Int)) -> Int {
        let rand = low + Int(arc4random()) %  (up - low)
        return rand
    }

    func scrollGraphView() {
        if shouldScroll == true {
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current().duration = 0.5
            let clip = self.graphScrollView.contentView
            let point = CGPoint(x:CGFloat(timeElapsed) * CGFloat(DGUtility.scaleX) + CGFloat(DGUtility.X_OFFSET) - graphView.visibleRect.size.width/2, y:graphView.visibleRect.size.height/2)
            clip.animator().setBoundsOrigin(point)
            self.graphScrollView.reflectScrolledClipView(self.graphScrollView.contentView)
            NSAnimationContext.endGrouping()
        }
    }
    
    func addGestureRecognisers() {
        let clickGesture = NSClickGestureRecognizer.init(target: self, action: #selector(didClick(click:)))
         clickGesture.numberOfClicksRequired = 2
        self.view.addGestureRecognizer(clickGesture)
    }
    
    @objc func didClick(click:NSClickGestureRecognizer) {
        shouldScroll = true
    }
    
}

