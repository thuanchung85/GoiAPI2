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

public struct QRView: View {
    @State public var name = "CHung"
    @State public var walletAddress = "0x..."
    @State public var width:CGFloat
    @State public var heigth:CGFloat
    
    public init(width:Int,heigth:Int,name:String,walletAddress:String)
    {
        self.width = CGFloat(width)
        self.heigth = CGFloat(heigth)
        self.name = name
        self.walletAddress = walletAddress
    }
    
    public let context = CIContext()
    public let filter = CIFilter.qrCodeGenerator()
    
    public var body: some View{
        NavigationView{
         
            VStack() {
                Text(name)
                    .font(.title)
                
                Image(uiImage: generateQRCode(from: self.walletAddress))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: self.width, height: self.heigth)
                
                Text("Wallet address: " + walletAddress)
                    .font(.title)
            }
           
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
