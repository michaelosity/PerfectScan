//
//  Barcode.swift
//  PerfectScan
//
//  Created by Michael Wells on 4/10/23.
//

import Foundation
import UIKit

struct Barcode: Identifiable, Equatable {
    
    enum BarcodeType: String, Codable {
        case invalid
        case code39
        case code128
        case upca
        case ean128
        case datamatrix
    }
    
    let text: String
    let type: BarcodeType
    let bounds: CGRect
    
    var id: String {
        type.rawValue + ":" + text
    }
    
    init?(text: String?, type: BarcodeType, bounds: CGRect) {
        guard let text else { return nil }
        
        self.text = text
        self.type = type
        self.bounds = bounds
    }
    
    
    var description: String {
        "\(text) (\(type.rawValue)) (\(bounds))"
    }
    
}
