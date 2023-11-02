//
//  File.swift
//
//
//  Created by SWEET HOME (^0^)!!! on 27/10/2023.
//

import Foundation
import SwiftUI
import AVKit

struct CameraView: UIViewRepresentable {
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    var frameSize:CGSize
    
    @Binding var session: AVCaptureSession
    
    func makeUIView(context: Context) ->  UIView {
        let view = UIViewType(frame: CGRect(origin: .zero,
                                            size: frameSize))
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: frameSize)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        return view
    }
}
