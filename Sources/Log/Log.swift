//
//  Log.swift
//  Log
//
//  Created by Bernardo Breder on 08/12/16.
//
//

import Foundation

#if SWIFT_PACKAGE
    import FileSystem
    import AtomicValue
    import Date
    import Optional
#endif

open class Log {
    
    let file: File
    
    let lock: Lock = Lock()
    
    let bufferCount: Int
    
    var array: [Data] = []
    
    public init(file: File, bufferCount: Int) {
        self.file = file
        self.bufferCount = bufferCount
    }
    
    public func info(_ text: String) {
        append("[info]: \(text)\r\n")
    }
    
    public func warning(_ text: String) {
        append("[warning]: \(text)\r\n")
    }
    
    public func error(_ text: String) {
        append("[error]: \(text)\r\n")
    }
    
    internal func append(_ text: String) {
        let time = DayTime()
        let timeStr = time.format(date: .short, time: .medium).orElse({"?"})
        let threadName = Thread.current.description
        var item = "[" + timeStr + "][" + threadName + "]" + text
        guard let data = item.data(using: .utf8) else { return }
        lock.lock()
        defer { lock.unlock() }
        array.append(data)
        if array.count >= bufferCount {
            var count = 0
            for item in array {
                count += item.count
            }
            var all = Data(capacity: count)
            for item in array {
                all = all + item
            }
            array.removeAll(keepingCapacity: false)
            _ = try? file.append(data: all)
        }
    }
    
}
