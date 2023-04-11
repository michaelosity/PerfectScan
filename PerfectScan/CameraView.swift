//
//  CameraView.swift
//  PerfectScan
//
//  Created by Michael Wells on 4/10/23.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @StateObject var viewModel: CameraViewModel = CameraViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Spacer()
                    
//                    Rectangle()
//                        .position(x: 0, y: 0)
//                        .frame(width: 100, height: 100)
//                        .border(Color.red, width: 2)
//                        .zIndex(1)
                    
                    VideoPreview(viewModel: viewModel)
                        .onAppear {
                            viewModel.configure()
                        }
                        .zIndex(0)
                    
                    Spacer()
                }
            }
        }
        .alert(isPresented: $viewModel.shouldShowAlert, content: {
            Alert(
                title: Text(viewModel.error.title),
                message: Text(viewModel.error.message),
                dismissButton: .default(
                    Text(
                        viewModel.error.primaryButtonTitle),
                    action: {
                        viewModel.error.primaryAction?()
                    }
                )
            )
        })
    }
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
