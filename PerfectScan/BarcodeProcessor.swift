//
//  BarcodeProcessor.swift
//  PerfectScan
//
//  Created by Michael Wells on 4/10/23.
//

import Foundation
import AVFoundation
import SwiftUI

protocol BarcodeProcessorDelegate: AnyObject {
    func foundBarcodes(_ barcodes: [Barcode])
}

class BarcodeProcessor: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    
    var delegate: BarcodeProcessorDelegate? = nil
    
    func metadataOutput(
        _: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from _: AVCaptureConnection
    ) {
        let objects = metadataObjects
            .compactMap { $0 as? AVMetadataMachineReadableCodeObject }
            .filter { $0.stringValue != nil }

        guard !objects.isEmpty else { return }

        let barcodes: [Barcode] = objects
            .compactMap {
                switch $0.type {
                case AVMetadataObject.ObjectType.code128:
                    return Barcode(text: $0.stringValue, type: .code128, bounds: $0.bounds)
                case AVMetadataObject.ObjectType.dataMatrix:
                    return Barcode(text: $0.stringValue, type: .datamatrix, bounds: $0.bounds)
                case AVMetadataObject.ObjectType.ean13:
                    // EAN13 is the same as UPCA so we remap it here
                    return Barcode(text: $0.stringValue, type: .upca, bounds: $0.bounds)
                default:
                    return nil
                }
            }
        
         Log.debug(barcodes.map(\.description).joined(separator: ", "))
        
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.foundBarcodes(barcodes)
        }
    }
    
}
