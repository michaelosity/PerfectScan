//
//  VideoPreview.swift
//  PerfectScan
//
//  Created by Michael Wells on 4/10/23.
//

import SwiftUI
import AVFoundation

struct VideoPreview: UIViewRepresentable {
    
    class VideoPreviewView: UIView {
        
        override class var layerClass: AnyClass {
             AVCaptureVideoPreviewLayer.self
        }
        
        var videoLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
        
    }
    
    @ObservedObject var viewModel: CameraViewModel
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        view.backgroundColor = .black
        view.videoLayer.cornerRadius = 0
        view.videoLayer.session = viewModel.captureSession
        view.videoLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
    }
    
}
