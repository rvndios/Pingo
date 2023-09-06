//
//  Pingo.swift
//  iPing
//
//  Created by Aravind on 06/09/23.
//

import Foundation
/// ping result
public struct PingoResult: Codable {

    public let host: String

    /// number of sent
    public let xmt: Int

    /// number of received
    public let rcv: Int

    /// loss percentage (value from 0-100)
    public var loss: Int {
        return xmt > 0 ? (xmt - rcv) * 100 / xmt : 0
    }

    /// nil if rcv is 0
    public let avg: Int?

    /// nil if rcv is 0
    public let min: Int?

    /// nil if rcv is 0
    public let max: Int?
    
    public let jitt: Float?

}

// Use notification for a workaround
// since A C function pointer cannot be formed from a local function that captures context
private func progressCCallback(progress: Float) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fpingxProgress"), object: nil, userInfo: ["progress": progress])
}

public class Pingo {

    /// Send ping with completion block.
    ///
    /// - Parameters:
    ///   - hosts: hosts
    ///   - backoff: default 1.5
    ///   - count: number of ping send per host
    ///   - completion: results dictionary, the key is host string, the value is FpingxResult struct

    public static func ping(hosts: [String], backoff: Float = 1.5, count: Int = 1,
                            progress: ((_ progress: (Float)) -> Void)? = nil,
                            completion: @escaping (_ results: [String: PingoResult]) -> Void) {

        let argv:[String?] = ["", "-c\(count)", "-B\(backoff)", "-q"] + hosts + [nil]
        var cargs = argv.map { $0.flatMap { UnsafeMutablePointer<Int8>(strdup($0)) } }

        let observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "fpingxProgress"), object: nil, queue: OperationQueue()) { (notification) in
            if let p = notification.userInfo!["progress"] as? Float {
                progress?(p > 1 ? 1 : p)
            }
        }

        DispatchQueue.global(qos: .background).async {
            let resultsArrarPtr = fping(Int32(argv.count), &cargs, progressCCallback)!
            var hostPtr = resultsArrarPtr.pointee

            var results: [String: PingoResult] = [:]
            while (hostPtr != nil) {
                let h = hostPtr!.pointee
                let host = String(cString: h.host)
                let result = PingoResult(host: host, xmt: Int(h.num_sent), rcv: Int(h.num_recv), avg: h.num_recv > 0 ? Int(h.total_time / h.num_recv / 100) : nil, min: h.num_recv > 0 ? Int(h.min_reply / 100) : nil, max: h.num_recv > 0 ? Int(h.max_reply / 100) : nil, jitt: (h.jitter / Float(count) ))
                results[host] = result
                let freeNode = hostPtr
                hostPtr = hostPtr?.pointee.ev_next
                free(UnsafeMutableRawPointer(freeNode))
            }

            free(UnsafeMutablePointer(resultsArrarPtr))
            completion(results)
            NotificationCenter.default.removeObserver(observer)
            for ptr in cargs { free(UnsafeMutablePointer(ptr)) }
        }

    }
}
