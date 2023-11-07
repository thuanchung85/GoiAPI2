//
//  File.swift
//  
//
//  Created by SWEET HOME (^0^)!!! on 07/11/2023.
//
import Foundation
import SwiftUI
import AVKit

public struct QR_ResultView: View {
    
    @Binding var qrResultString:String
    @Binding var isShow_ScanQRcodeView:Bool
    //===BODY==//
    public var body: some View {
        VStack{
            Text("This is result of QR code")
                .foregroundColor(Color.black)
                .font(.custom("Arial Bold", size: 20))
                .padding(15)
            Text(qrResultString)
                .frame(height: 60)
                .foregroundColor(Color.black)
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.horizontal], 4)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                .padding([.horizontal], 20)
            Spacer()
            //nut save account
            Button(action: {
               print("Save this wallet address")
                isShow_ScanQRcodeView = false
            }) {
                HStack{
                    Image(systemName: "square.and.pencil")
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                    Text("Save this wallet address")
                        .foregroundColor(Color.white)
                        .font(.custom("Arial", size: 20))
                        .padding(.horizontal,5)
                }
                .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                .background(Color.green)
                .cornerRadius(10)
                .padding(.horizontal,20)
            }.padding(15)
        }
        
    }//end body
}//end struct
