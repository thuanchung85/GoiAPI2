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
    
    @State var add_NewAccountName:String = ""
    //===BODY==//
    public var body: some View {
        VStack{
            Text("Add other wallet address")
                .foregroundColor(Color.black)
                .font(.custom("Arial Bold", size: 20))
                .padding(15)
            
            //nếu đia chỉ ví là ethereum
            if(self.qrResultString.count == 42){
                
                HStack(alignment: .center){
                        Image("Account")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 120, height: 120)
                }
                HStack{
                    Text("This is wallet address get from QR code")
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
                }
                HStack{
                    VStack(alignment: .leading){
                        Text("Wallet Name")
                            .font(.custom("Arial Bold", size: 15))
                            .padding(.top,15)
                            .padding(.horizontal,20)
                        TextField("Enter name for this wallet address", text: self.$add_NewAccountName)
                            .frame(height: 60)
                            .foregroundColor( Color.black)
                            .textFieldStyle(PlainTextFieldStyle())
                            .padding([.horizontal], 4)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                            .padding([.horizontal], 20)
                    }
                }
                    
                //nut save chỉ hiện khi nhập tên
                if( self.add_NewAccountName.isEmpty == false){
                    //nut save account
                    Button(action: {
                        print("Save this wallet address")
                        //kiểm tra số lượng các địa chỉ vi của người khác save trên máy
                        let s = UserDefaults.standard.string(forKey: "numberOfRecipientWallet") ?? "0"
                        let ss = (Int(s) ?? 0) + 1
                        //save wallet vao máy
                        UserDefaults.standard.set(String(ss), forKey: "numberOfRecipientWallet")
                        
                        let g = UserDefaults.standard.string(forKey: "numberOfRecipientWallet") ?? "0"
                        UserDefaults.standard.set("\(add_NewAccountName)+|Receiver@Wallet|+\(qrResultString)", forKey: "recipient\(g)")
                        
                        let r = UserDefaults.standard.string(forKey: "recipient\(g)") ?? "0"
                        print(r)
                        //dismiss
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
            }
            else{
                Text("This is NOT ETHEREUM wallet address!")
                    .foregroundColor(Color.red)
                    .font(.custom("Arial Bold", size: 15))
                    .padding(15)
                //nut save account
                Button(action: {
                    print("back this is not wallet address")
                    isShow_ScanQRcodeView = false
                }) {
                    HStack{
                        Text("Back")
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
            Spacer()
        }
        
    }//end body
}//end struct
