import SwiftUI
import UniformTypeIdentifiers
import Foundation
import web3swift
import Web3Core


public struct SheetCreateAccountView: View {
    
    @Binding var add_NewAccountName:String
    @Binding var isShow_SheetEnterWalletName:Bool
    @Binding var arr_Accounts:[Account_Type]
    
    //biến lưu lại địa chỉ account tạm, khi user ok thì sẽ dùng nó còn không ok thì bỏ
    @State var tempAddress:String = "0x....Loading"
   
    //===INIT==//
    public init(add_NewAccountName:Binding<String>, isShow_SheetEnterWalletName:Binding<Bool>, arr_Accounts:Binding<[Account_Type]>)  {
        self._add_NewAccountName = add_NewAccountName
        self._isShow_SheetEnterWalletName = isShow_SheetEnterWalletName
        self._arr_Accounts = arr_Accounts
    }
    
    //===BODY===//
    public var body: some View {
        VStack(alignment: .center){
            HStack{
                Spacer()
                Text("Create New Wallet")
                    .font(.custom("Arial Bold", size: 20))
                    .padding(.top,15)
                Spacer()
            }
            HStack{
                VStack(alignment: .leading){
                    Text("Wallet Address")
                        .font(.custom("Arial ", size: 15))
                        .padding(.top,15)
                        .padding(.horizontal,20)
                    Text(tempAddress)
                        .font(.custom("Arial ", size: 15))
                        .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.top,15)
                        .padding(.horizontal,20)
                    Text("Wallet Name")
                        .font(.custom("Arial ", size: 15))
                        .padding(.top,15)
                        .padding(.horizontal,20)
                    TextField("Enter your wallet name", text: self.$add_NewAccountName)
                        .frame(height: 60)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 20)
                    
                    Spacer()
                    
                    //nut add account
                    if(self.add_NewAccountName.isEmpty == false){
                        Button(action: {
                            print("Create Account")
                            DispatchQueue.global(qos:.userInteractive).async {
                                self.tempAddress = makeEthereumAddressAccount(name: self.add_NewAccountName)
                                print("tempAddress make new: ",  self.tempAddress)
                                //tạo account mới
                                let newAcc = Account_Type(nameWallet: self.add_NewAccountName,
                                                          addressWallet: self.tempAddress, pkey: "making...")
                                self.arr_Accounts.append(newAcc)
                                //xoa tên account vì đã tạo xong
                                self.add_NewAccountName = ""
                            }
                            
                        }) {
                            HStack{
                                Text("Create")
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

//==hàm tạo nhanh 1 account ethereum==//
func makeEthereumAddressAccount(name :String) -> String
{
    
    do {
     let keystore = try EthereumKeystoreV3.init(password: "")
        let address = keystore?.addresses!.first!
        
        let pkey = try? keystore?.UNSAFE_getPrivateKeyData(password: "", account: address!).toHexString()
        print(pkey as Any)
        return address?.address ?? "keystore error no data"
     } catch {
     print(error.localizedDescription)
     }
    return "error no data"
}


