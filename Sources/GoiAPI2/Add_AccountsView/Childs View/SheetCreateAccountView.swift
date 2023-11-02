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
    @State var tempAddress:String = "0x........"
    @State var tempPKEY:String = ""
    
    //nut quit khi làm xong account
    @State var isOk_Back:Bool = false
    
    //disable không cho nhập tên khi đang chạy tạo account mới
    @State var isDisableEnterTextEditer = false
    
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
                        .background((isDisableEnterTextEditer == false) ? Color.white : Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding([.horizontal], 20)
                        .disabled(isDisableEnterTextEditer)
                    
                    if(self.tempAddress.isEmpty == false) && (self.isOk_Back == true){
                        Text("Your wallet has been created.")
                            .font(.custom("Arial Bold", size: 20))
                            .padding(.top,15)
                            .padding(.horizontal,20)
                            .foregroundColor(Color.green)
                    }
                    Spacer()
                    
                    //nut create account
                    if(self.add_NewAccountName.isEmpty == false){
                        if(self.isDisableEnterTextEditer == false){
                            Button(action: {
                                print("Create Account")
                                self.tempAddress = "Making your new wallet, please wait..."
                                DispatchQueue.global(qos:.userInteractive).async {
                                    let d = makeEthereumAddressAccount(name: self.add_NewAccountName)
                                    self.tempAddress = d[0]
                                    self.tempPKEY = d[1]
                                    print("tempAddress make new: ",  self.tempAddress)
                                    //tạo account mới
                                    let newAcc = Account_Type(nameWallet: self.add_NewAccountName,
                                                              addressWallet: self.tempAddress, pkey: self.tempPKEY)
                                    self.arr_Accounts.append(newAcc)
                                    
                                    self.isOk_Back = true
                                }
                                //xoa tên account vì đã tạo xong
                                self.isDisableEnterTextEditer = true
                                
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
                    }
                    
                    //nut OK thoat
                    if(self.isOk_Back == true){
                        Button(action: {
                            self.isShow_SheetEnterWalletName = false
                            
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

//==hàm tạo nhanh 1 account ethereum==//
func makeEthereumAddressAccount(name :String) -> [String]
{
    
    do {
     let keystore = try EthereumKeystoreV3.init(password: "")
        let address = keystore?.addresses!.first!
        
        let pkey = try? keystore?.UNSAFE_getPrivateKeyData(password: "", account: address!).toHexString()
        let privateKey = "0x" + (pkey ?? "")
        print(pkey as Any)
        return [address!.address, privateKey]
     } catch {
     print(error.localizedDescription)
     }
    return ["error no data","error no data"]
}


