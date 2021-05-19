//
//  Debouncer.swift
//  Github Users
//
//  Created by Budi Darmawan on 15/05/21.
//

import Foundation

public class Debouncer: NSObject {
    public var callback: (() -> Void)
    public var delay: Double
    public weak var timer: Timer?
    private var canceled: Bool = false
 
    public init(delay: Double, callback: @escaping (() -> Void)) {
        self.delay = delay
        self.callback = callback
    }
    
    public func cancel() {
        canceled = true
    }
 
    public func call() {
        timer?.invalidate()
        canceled = false
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }
 
    @objc func fireNow() {
        if !canceled {
            self.callback()
        }
    }
}
