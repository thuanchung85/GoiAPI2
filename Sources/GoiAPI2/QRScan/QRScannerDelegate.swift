//
//  File.swift
//
//
//  Created by SWEET HOME (^0^)!!! on 27/10/2023.
//

import Foundation
import SwiftUI
import AVKit

class QRScannerDelegate:NSObject,ObservableObject, AVCaptureMetadataOutputObjectsDelegate{
    @Published var scannerCode:String = ""
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection)
    {
        
        
            if let metaObject = metadataObjects.first{
                guard let readableObject = metaObject as? AVMetadataMachineReadableCodeObject else {return}
                guard let scannedCodeOutPut = readableObject.stringValue else {return}
                scannerCode = scannedCodeOutPut
                
            }
        
    
    }
    
    
    
}//end class
