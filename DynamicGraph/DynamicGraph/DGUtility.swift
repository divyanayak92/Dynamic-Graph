//
//  DGUtility.swift
//  DynamicGraph
//
//  Created by Divya Nayak on 13/08/17.
//

import Cocoa

class DGUtility {
    
    static let X_OFFSET = 30
    static let GRAPH_LINE_OFFSET = 5
    
    static var scaleX : Double {
        set {
            UserDefaults.standard.set(newValue, forKey: "scaleX")
        }
        get {
            return UserDefaults.standard.object(forKey: "scaleX") as? Double ?? 10.0
        }
    }
    
    static func totalValues() -> Int {
        return abs(range().start) + abs(range().end) + 1
    }
    
    static func range() -> (start:Int,end:Int) {
        return (start:-100, end:100)
    }
    
}
