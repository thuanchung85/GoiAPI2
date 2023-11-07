//
//  File.swift
//
//
//  Created by SWEET HOME (^0^)!!! on 27/10/2023.
//

import Foundation
import SwiftUI
import AVKit

public struct QR_ScannerView_GetAnotherWalletAddress: View {
    
    @State  var session:AVCaptureSession = .init()
    @State var qrOutput:AVCaptureMetadataOutput = .init()
    
    @State var errorMessage: String = ""
    @State var showError:Bool = false
    
    @StateObject var qrOutputDelegate = QRScannerDelegate()
    
    @Binding var scannerCode:String
    
    @Binding var isShow_ScanQRcodeView:Bool
    
    @State var isShow_SheetSaveOtherAddressWallet:Bool = false
    
    //===INIT===//
    public init(scannerCode:Binding<String>, isShow_ScanQRcodeView: Binding<Bool>)  {
        self._scannerCode = scannerCode
        self._isShow_ScanQRcodeView = isShow_ScanQRcodeView
       
    }
    
    //===BODY==//
    public var body: some View {
        VStack(spacing: 8){
           
            Text("Place the QR code inside the area")
                .font(.title3)
                .foregroundColor(.black.opacity(0.8))
                .padding(.top,20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.gray)
            
            //scanner
            GeometryReader{
                let size = $0.size
                ZStack{
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                    
                    ForEach(0...4, id: \.self){ index in
                        let rotation = Double(index) * 90
                       
                        RoundedRectangle(cornerRadius: 2,style: .circular)
                            .trim(from: 0.61,to: 0.64)
                            .stroke(Color.green,style: StrokeStyle(lineWidth: 5,lineCap: .round,lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                    }
                }
                .frame(width: size.width,height: size.width)
               
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            }.padding(.horizontal,15)
            
            
            
            Spacer(minLength: 15)
            
            //nut next để user pass khỏi quá trình này
            Button {
                isShow_ScanQRcodeView = false
            } label: {
                Text("BACK")
                    .frame(width: 120)
                    .padding()
                    .foregroundColor(.white)
            }
            .background(Color.green)
            .cornerRadius(30)
            .padding(.bottom,10)
            
        }//end VStack
        .padding(15)
        .alert(isPresented: $showError) {
            Alert(title: Text("QR SCAN ERROR"))
        }
        .onChange(of: qrOutputDelegate.scannerCode) { newValue in
          print(newValue)
                self.scannerCode = newValue
                session.stopRunning()
            //gọi view show kêt quả ra
            self.isShow_SheetSaveOtherAddressWallet = true
            //truyền data ra ngoài và dismiss
            //self.isShow_ScanQRcodeView = false
          
            
        }
        .onAppear(perform:  checkCameraPermission)
       
        .sheet(isPresented: $isShow_SheetSaveOtherAddressWallet,
                content: {
            QR_ResultView(qrResultString: self.scannerCode ,isShow_ScanQRcodeView:$isShow_ScanQRcodeView)
           
         })//end sheet
    }//end body
    
    
    
    
    //====hàm check quyền truy câp camera====/
    func checkCameraPermission(){
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            //already authorized
            print("CAMERA already authorized")
            setupCamera()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    //access allowed
                    print("CAMERA access allowed")
                    setupCamera()
                } else {
                    //access denied
                    print("CAMERA access denied")
                }
            })
        }
    }
    
    //=======hàm chạy camera=========//
    func setupCamera(){
        do{
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                print("camare not found")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(self.qrOutput) else{
                print("camare session error")
                return
            }
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrOutputDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
           
        }
        catch{
            print("error when setup camera")
            return
        }
    }
    
}//end struct



