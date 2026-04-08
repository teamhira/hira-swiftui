//
//  CameraPreview.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI
import AVFoundation

/// A SwiftUI wrapper for the AVCaptureVideoPreviewLayer to show live camera feed.
public struct CameraPreview: UIViewRepresentable {
    @Bindable var viewModel: HalalViewModel
    
    public init(viewModel: HalalViewModel) {
        self.viewModel = viewModel
    }

    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        // Setup session in background
        DispatchQueue.global(qos: .userInitiated).async {
            let session = AVCaptureSession()
            session.beginConfiguration()
            
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input) else {
                return
            }
            
            session.addInput(input)
            session.commitConfiguration()
            session.startRunning()
            
            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = .resizeAspectFill
                // Layer frame will be updated via updateUIView
                view.layer.addSublayer(previewLayer)
            }
        }
        
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}
