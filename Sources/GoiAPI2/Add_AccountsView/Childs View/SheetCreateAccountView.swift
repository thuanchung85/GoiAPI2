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
    @State var tempSig:String = ""
    
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
                                   makeEthereumAddressAccount(name: self.add_NewAccountName, completionHandler: { arr in
                                        self.tempAddress = arr[0]
                                        self.tempPKEY = arr[1]
                                        self.tempSig = arr[2]
                                       print("tempAddress make new: ",  self.tempAddress)
                                       print("tempPKEY make new: ",  self.tempPKEY)
                                       print("tempSig make new: ",  self.tempSig)
                                       
                                       //tạo account mới
                                       let newAcc = Account_Type(nameWallet: self.add_NewAccountName,
                                                                 addressWallet: self.tempAddress, pkey: self.tempPKEY,
                                                                 signatureForBackEnd: tempSig)
                                       self.arr_Accounts.append(newAcc)
                                       
                                       self.isOk_Back = true
                                       
                                       
                                        
                                       
                                       //save vào user default số lượng account phụ
                                       UserDefaults.standard.set("\(self.arr_Accounts.count - 1)", forKey: "\(self.arr_Accounts.first!.addressWallet)_SoLuongAccountPhu")
                                       //save vào user default thông tin account phụ
                                       let k = "\(self.arr_Accounts.first!.addressWallet)_AccountPhu\(self.arr_Accounts.count - 1)"
                                       print(k)
                                       UserDefaults.standard.set("\(newAcc.nameWallet)+|@|+\(newAcc.addressWallet)+|@|+\(newAcc.pkey)+|@|+\(newAcc.signatureForBackEnd)", forKey: k)
                                       
                                       let rs = UserDefaults.standard.string(forKey: k)
                                       print(rs as Any)
                                        
                                    })
                                    
                                   
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
func makeEthereumAddressAccount(name :String, completionHandler : @escaping  ([String]) -> Void)
{
    
    do {
     let keystore = try EthereumKeystoreV3.init(password: "")
        let address = keystore?.addresses!.first!
        
        let pkey = try? keystore?.UNSAFE_getPrivateKeyData(password: "", account: address!).toHexString()
        let privateKey = "0x" + (pkey ?? "")
        print(pkey as Any)
        //tạo signature của "wallet address nay"
        guard let SIGNATURE_HASH = Bundle.main.object(forInfoDictionaryKey: "SignatureHash") as? String else {
            fatalError("SignatureHash must not be empty in plist")
        }
        print(SIGNATURE_HASH)
        let msgStr = SIGNATURE_HASH
        let data_msgStr = msgStr.data(using: .utf8)
        
        let pKey = privateKey
        let formattedKey = pKey.trimmingCharacters(in: .whitespacesAndNewlines)
         let dataKey = Data.fromHex(formattedKey)
        
      
        let keystoreManager = KeystoreManager([keystore!])
        Task{
            let web3Rinkeby = try! await Web3.InfuraRinkebyWeb3()
            web3Rinkeby.addKeystoreManager(keystoreManager)
            let signMsg = try! web3Rinkeby.wallet.signPersonalMessage(data_msgStr!,
                                                                      account:  keystoreManager.addresses![0],
                                                                      password: "");
            let strSignature = signMsg.base64EncodedString()
            print("strSignature: ",strSignature);
            
            
            completionHandler( [address!.address, privateKey, strSignature])
        }
     } catch {
     print(error.localizedDescription)
     }
   
}


