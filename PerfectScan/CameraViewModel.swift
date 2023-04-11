//
//  CameraViewModel.swift
//  PerfectScan
//
//  Created by Michael Wells on 4/10/23.
//

import SwiftUI
import UIKit
import AVFoundation

final class CameraViewModel: ObservableObject, BarcodeProcessorDelegate {
    
    @Published var shouldShowAlert = false
    @Published var barcodes: [Barcode] = []
    
    func foundBarcodes(_ barcodes: [Barcode]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.barcodes = barcodes
        }
    }
    
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    private(set) var error: AppError = AppError()
    private var setupResult: SessionSetupResult = .success
    private(set) var captureSession = AVCaptureSession()

    private var processingQueue = DispatchQueue(label: "PerfectScan.CameraScanner")
    
    private var barcodeProcessor = BarcodeProcessor()

    func configure() {
        barcodeProcessor.delegate = self
        checkForPermissions()
        configureSession()
    }
    
    func checkForPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            break
        case .notDetermined:
            processingQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.processingQueue.resume()
            })
            
        default:
            setupResult = .notAuthorized
            DispatchQueue.main.async {
                self.error = AppError(
                    title: "Camera Access",
                    message: "PerfectScan doesn't have access to use your camera, please update your privacy settings.",
                    primaryButtonTitle: "Settings",
                    secondaryButtonTitle: nil,
                    primaryAction: {
                        UIApplication.shared.open(
                            URL(string: UIApplication.openSettingsURLString)!,
                            options: [:],
                            completionHandler: nil
                        )
                    },
                    secondaryAction: nil
                )
                self.shouldShowAlert = true
            }
        }
    }
    
    private func configureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back) else {
            Log.error("Could not create default capture device")
            return
        }
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            captureSession.addInput(videoInput)
            
            let barcodeOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(barcodeOutput)
            
            barcodeOutput.setMetadataObjectsDelegate(barcodeProcessor, queue: processingQueue)
            barcodeOutput.metadataObjectTypes = [.code128, .upce, .ean13]
        } catch let error {
            Log.error(error.localizedDescription)
        }
        
        processingQueue.async { [weak self] in
            guard let self else { return }
            self.captureSession.startRunning()
        }
    }
       
}
