//
//  Log.swift
//  PerfectScan
//
//  Created by Michael Wells on 4/10/23.
//

import Foundation

enum Log {
    static func debug(_ text: String) { print(text) }
    static func error(_ text: String) { print("ERROR: " + text) }
    static func warning(_ text: String) { print("WARNING: " + text) }
}
