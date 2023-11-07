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
import UniformTypeIdentifiers

public struct QRCodeMakerView: View {
    @Binding var currentIndex:Int
  var accountInput:[Account_Type]
    @State var isShowPrivateKey = false
    
     var width:CGFloat?
     var height:CGFloat?
    
    public init(width:CGFloat,  height:CGFloat, accountInput:[Account_Type], currentIndex:Binding<Int>) {
        self.accountInput = accountInput
        self.width = width
        self.height = height
        self._currentIndex = currentIndex
        
        print("arr_Accounts enter: ",  self.accountInput)
    }
    
    public var body: some View{
        NavigationView{
         
            VStack() {
                Text(self.accountInput[self.currentIndex].nameWallet )
                    .font(.title)
                
                Image(uiImage: generateQRCode(from: self.accountInput[self.currentIndex].addressWallet ))
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                Text("Wallet address: ")
                    .font(.title)
                Text(self.accountInput[self.currentIndex].addressWallet )
                    .font(.footnote)
                
               //nút copy address
                Button(action: {
                    print("Copy Button was tapped save to clipbroad")
                    UIPasteboard.general.setValue(self.accountInput[self.currentIndex].addressWallet ,forPasteboardType: UTType.plainText.identifier)
                }) {
                    HStack{
                        Text("Copy")
                            .foregroundColor(Color.white)
                            .font(.custom("Arial", size: 20))
                            .padding(.horizontal,5)
                    }
                    .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal,20)
                    
                }
                
                //nút show pkey
                Button(action: {
                    print("Export Private Key Button was tapped")
                    isShowPrivateKey.toggle()
                }) {
                    HStack{
                        Text("Export Private Key!!")
                            .foregroundColor(Color.white)
                            .font(.custom("Arial", size: 20))
                            .padding(.horizontal,5)
                    }
                    .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal,20)
                    
                }
                
                
                if(isShowPrivateKey == true){
                    Text("Your Private Key Code: ")
                        .font(.body)
                    Text(self.accountInput[self.currentIndex].pkey )
                        .font(.footnote)
                }
            }
           
        }
    }
    
    
    func generateQRCode(from string:String)-> UIImage{
         let context = CIContext()
         let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage{
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
}//end struct

