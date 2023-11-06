import SwiftUI
import UniformTypeIdentifiers
import Foundation
import web3swift
import Web3Core


public struct SheetRecoverAccountFromPkey: View {
    
    @Binding var add_NewAccountName:String
    @Binding var isShow_SheetRecoverAccountFromPkey:Bool
    
    @State var pKEY:String = ""
    
    //nut quit khi làm xong account
    @State var isOk_Back:Bool = false
    
    //disable không cho nhập tên khi đang chạy tạo account mới
    @State var isDisableEnterTextEditer = false
    
    
    @State var tempAddress:String = "0x........"
    
    //===INIT==//
    public init(add_NewAccountName:Binding<String>,isShow_SheetRecoverAccountFromPkey:Binding<Bool>)  {
        self._add_NewAccountName = add_NewAccountName
        self._isShow_SheetRecoverAccountFromPkey = isShow_SheetRecoverAccountFromPkey
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
                    Text("Wallet Address")
                        .font(.custom("Arial Bold", size: 15))
                        .padding(.top,15)
                        .padding(.horizontal,20)
                    Text(tempAddress)
                        .multilineTextAlignment(.leading)
                        .font(.custom("Arial ", size: 15))
                        .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.top,15)
                        .padding(.horizontal,20)
                    
                    Text("Wallet Name")
                        .font(.custom("Arial Bold", size: 15))
                        .padding(.top,15)
                        .padding(.horizontal,20)
                    TextField("Enter your wallet name", text: self.$add_NewAccountName)
                        .frame(height: 60)
                        .foregroundColor((isDisableEnterTextEditer == false) ? Color.black : Color.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 20)
                        .disabled(isDisableEnterTextEditer)
                    
                    Text("Private key")
                        .font(.custom("Arial Bold", size: 15))
                        .padding(.top,15)
                        .padding(.horizontal,20)
                   
                    TextField("Enter your private key", text: self.$pKEY)
                        .frame(height: 60)
                        .foregroundColor((isDisableEnterTextEditer == false) ? Color.black : Color.gray)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 20)
                        .disabled(isDisableEnterTextEditer)
                    
                   
                    
                    
                    //nut Recover account
                    if(self.add_NewAccountName.isEmpty == false){
                        if(self.isDisableEnterTextEditer == false){
                            Button(action: {
                                print("Recover")
                                self.tempAddress = "Recovering your wallet, please wait..."
                                DispatchQueue.global(qos:.userInteractive).async {
                                    let d = importAccount(by: self.pKEY, name: self.add_NewAccountName, password: "")
                                    print(d)
                                    if (d.count == 2)
                                    {
                                        print("private key OK -> make address")
                                        self.tempAddress = d.first ?? "..."
                                        
                                    }else{
                                        print("private key NOT OK -> ERROR")
                                        self.tempAddress = "Cannot recover your wallet, please check your key..."
                                    }
                                }
                                //xoa tên account vì đã tạo xong
                                self.isDisableEnterTextEditer = true
                                
                            }) {
                                HStack{
                                    Text("Recover wallet")
                                        .foregroundColor(Color.white)
                                        .font(.custom("Arial", size: 20))
                                        .padding(.horizontal,5)
                                }
                                .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                                .background(Color.green)
                                .cornerRadius(10)
                                .padding(.horizontal,20)
                                .padding(.bottom,50)
                            }
                        }
                    }
                    Spacer()
                    
                    //nut OK thoat
                    if(self.isOk_Back == true){
                        Button(action: {
                            self.isShow_SheetRecoverAccountFromPkey = false
                            
                        }) {
                            HStack{
                                Text("OK")
                                    .foregroundColor(Color.white)
                                    .font(.custom("Arial", size: 20))
                                    .padding(.horizontal,5)
                            }
                            .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal,20)
                            .padding(.bottom,50)
                        }
                    }
                   
                    
                 
                }//end VStack
            }//end HStack
         }//end VStack
        
    }
    
}//end struct



//===hàm import account===//
public func importAccount(by privateKey: String, name: String, password:String)  -> [String] {
    let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard let dataKey = Data.fromHex(formattedKey)
    else { return ["error cannot get dataKey or EthereumKeystoreV3 by this privateKey"] }
    do{
        guard let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password)
        else{   return ["error cannot get dataKey or EthereumKeystoreV3 by this privateKey"]}
        
        guard let address = keystore.addresses?.first?.address
        else { return ["error cannot address by this privateKey"] }
        
        let keyData = try JSONEncoder().encode(keystore.keystoreParams)
        print("keyData get back by PrivateKey: ", keyData)
        let s = String(data: keyData, encoding: . utf8)!
        return [address, s]
    }
    catch{
        return ["error cannot get dataKey or EthereumKeystoreV3 by this privateKey"]
    }
    
}
