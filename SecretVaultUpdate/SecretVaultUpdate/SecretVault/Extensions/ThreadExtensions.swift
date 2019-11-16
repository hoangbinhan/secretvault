import Foundation

extension Thread {
    
    /// Execute task on main thread if needed.
    class func mainSync(_ task: @escaping () -> Void) {
        if Thread.current.isMainThread == true {
            task()
        } else {
            // Current is not main thread
            DispatchQueue.main.sync(execute: task)
        }
    }
    
    /// Execute task on global thread.
    class func globalSync(_ task: @escaping () -> Void) {
        DispatchQueue.global().sync(execute: task)
    }
    
    /// Execute task on main thread with delay time.
    class func mainAsyncAfter(delay: TimeInterval, _ task: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
    }
    
    /// Execute task on global thread with delay time.
    class func globalAsyncAfter(delay: TimeInterval, _ task: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: task)
    }
    
    /// Execute task on current thread with delay time.
    class func currentAsyncAfter(delay: TimeInterval, _ task: @escaping () -> Void) {
        if Thread.current.isMainThread == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
        } else {
            DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: task)
        }
    }
}
