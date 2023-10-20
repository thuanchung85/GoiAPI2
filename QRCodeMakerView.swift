//
//  File.swift
//  GoiAPI2
//
//  Created by SWEET HOME (^0^)!!! on 20/10/2023.
//
import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import SwiftUI

struct QRView: View {
    @State private var name = "CHung"
    @State private var walletAddress = "0x..."
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View{
        NavigationView{
            Form{
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                
                Image(generateQRCode(from: self.walletAddress))
                    .resizable()
                    .scaledToFit()
                    .frame(200,200)
                
                TextField("Wallet address", text: $walletAddress)
                    .textContentType(.walletAddress)
                    .font(.title)
            }
            .navigationTitle("Your code")
        }
    }
    
    
    func generateQRCode(from string:String)-> UIImage{
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage{
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}//end struct
