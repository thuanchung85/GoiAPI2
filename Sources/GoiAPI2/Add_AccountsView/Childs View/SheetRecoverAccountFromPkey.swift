import SwiftUI
import UniformTypeIdentifiers
import Foundation
import web3swift
import Web3Core


public struct SheetRecoverAccountFromPkey: View {
    
    @State var pKEY:String = ""
    
    //biến lưu lại địa chỉ account tạm, khi user ok thì sẽ dùng nó còn không ok thì bỏ
   
    
    //===INIT==//
    public init()  {
        
    }
    
    //===BODY===//
    public var body: some View {
        VStack(alignment: .center){
            HStack{
                Spacer()
                Text("Recovery your wallet")
                    .font(.custom("Arial Bold", size: 20))
                    .padding(.top,15)
                Spacer()
            }
            HStack{
                VStack(alignment: .leading){
                    Text("Private key")
                        .font(.custom("Arial Bold", size: 15))
                        .padding(.top,15)
                        .padding(.horizontal,20)
                   
                    TextField("Enter your private key", text: self.$pKEY)
                        .frame(height: 60)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 20)
                       
                    
                   
                    
                 
                }//end VStack
            }//end HStack
         }//end VStack
        
    }
    
}//end struct



