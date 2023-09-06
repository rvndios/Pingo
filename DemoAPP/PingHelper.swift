//
//  PingHelper.swift
//  DemoAPP
//
//  Created by Aravind on 06/09/23.
//

import Foundation
import pingo
/// ping result
public struct PngResult: Codable {
    public let host: String
    public let xmt: Int
    public let rcv: Int
    public var loss: Int {
        return xmt > 0 ? (xmt - rcv) * 100 / xmt : 0
    }
    public let avg: Float?
    public let min: Int?
    public let max: Int?
    public let jitt: Float?
}

// Use notification for a workaround
// since A C function pointer cannot be formed from a local function that captures context
private func progressCCallback(progress: Float) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fpingxProgress"), object: nil, userInfo: ["progress": progress])
}

public class Pinger {
    /// Send ping with completion block.
    ///
    /// - Parameters:
    ///   - hosts: hosts
    ///   - backoff: default 1.5
    ///   - count: number of ping send per host
    ///   - completion: results dictionary, the key is host string, the value is PngResult struct

    public static func ping(hosts: [String], backoff: Float = 1.5, count: Int = 1,
                            progress: ((_ progress: (Float)) -> Void)? = nil,
                            completion: @escaping (_ results: [String: PngResult]) -> Void) {

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

            var results: [String: PngResult] = [:]
            while (hostPtr != nil) {
                let h = hostPtr!.pointee
                let host = String(cString: h.host)
                let result = PngResult(host: host, xmt: Int(h.num_sent), rcv: Int(h.num_recv), avg: h.num_recv > 0 ? Float(h.total_time / h.num_recv / 100) : nil, min: h.num_recv > 0 ? Int(h.min_reply / 100) : nil, max: h.num_recv > 0 ? Int(h.max_reply / 100) : nil, jitt: (h.jitter / Float(count)))
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

