import SwiftUI
import UniformTypeIdentifiers
import Foundation
import web3swift
import Web3Core


public struct SheetRecoverAccountFromPkey: View {
    
    @Binding var add_NewAccountName:String
    @Binding var isShow_SheetRecoverAccountFromPkey:Bool
    @Binding var arr_Accounts:[Account_Type]
    
    @State var pKEY:String = ""
    
    //nut quit khi làm xong account
    @State var isOk_Back:Bool = false
    
    //disable không cho nhập tên khi đang chạy tạo account mới
    @State var isDisableEnterTextEditer = false
    
    
    @State var tempAddress:String = "0x........"
    @State var tempSign:String = ""
    
    //===INIT==//
    public init(add_NewAccountName:Binding<String>,isShow_SheetRecoverAccountFromPkey:Binding<Bool>, arr_Accounts:Binding<[Account_Type]>)  {
        self._add_NewAccountName = add_NewAccountName
        self._isShow_SheetRecoverAccountFromPkey = isShow_SheetRecoverAccountFromPkey
        self._arr_Accounts = arr_Accounts
    }
    
    //===BODY===//
    public var body: some View {
        VStack(alignment: .center){
            HStack{
                Spacer()
                Text("Recovery your wallet")
                    .foregroundColor(Color.red)
                    .font(.custom("Arial Bold", size: 20))
                    .padding(.top,15)
                    .scaledToFit()
                    .minimumScaleFactor(0.02)
                Spacer()
            }
            HStack{
                VStack(alignment: .leading){
                    Text("Wallet Address")
                        .font(.custom("Arial Bold", size: 15))
                        .padding(.top,5)
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
                    
                    if(self.isOk_Back == false){
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
                    }
                    else{
                        if(self.isDisableEnterTextEditer == true){
                            Text("Congratulations, your wallet has been recovered.")
                                .font(.custom("Arial Bold", size: 15))
                                .foregroundColor(Color.green)
                                .padding(.top,15)
                                .padding(.horizontal,20)
                        }
                    }
                   
                    
                    
                    //nut Recover account
                    if(self.add_NewAccountName.isEmpty == false){
                        if(self.isDisableEnterTextEditer == false){
                            Button(action: {
                                print("Recover")
                                self.tempAddress = "Recovering your wallet, please wait..."
                                DispatchQueue.global(qos:.userInteractive).async {
                                    importAccount(by: self.pKEY, name: self.add_NewAccountName, password: "",completionHandler: { arr in
                                        print(arr)
                                        print("private key OK -> make address")
                                        self.tempAddress = arr.first ?? "..."
                                        self.tempSign = arr.last ?? "..."
                                        self.isDisableEnterTextEditer = true
                                        self.isOk_Back = true
                                        
                                        if (arr.count == 3)
                                        {
                                            //tạo account mới
                                            let newAcc = Account_Type(nameWallet: self.add_NewAccountName,
                                                                      addressWallet: self.tempAddress, pkey: self.pKEY,
                                                                      signatureForBackEnd: self.tempSign)
                                            self.arr_Accounts.append(newAcc)
                                            
                                            
                                            //save vào user default số lượng account phụ
                                            UserDefaults.standard.set("\(self.arr_Accounts.count - 1)", forKey: "\(self.arr_Accounts.first!.addressWallet)_SoLuongAccountPhu")
                                            //save vào user default thông tin account phụ
                                            let k = "\(self.arr_Accounts.first!.addressWallet)_AccountPhu\(self.arr_Accounts.count - 1)"
                                            print(k)
                                            UserDefaults.standard.set("\(newAcc.nameWallet)+|@|+\(newAcc.addressWallet)+|@|+\(newAcc.pkey)", forKey: k)
                                            
                                            let rs = UserDefaults.standard.string(forKey: k)
                                            print(rs as Any)
                                        }else{
                                            print("private key NOT OK -> ERROR")
                                            self.tempAddress = "Cannot recover your wallet, please check your key..."
                                            isDisableEnterTextEditer = false
                                        }
                                    })
                                    
                                   
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
public func importAccount(by privateKey: String, name: String, password:String, completionHandler : @escaping  ([String]) -> Void)
{
    let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if let dataKey = Data.fromHex(formattedKey)
    {
        do{
             let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password)
            
            
            let address = keystore?.addresses?.first?.address
            
            
            let keyData = try JSONEncoder().encode(keystore!.keystoreParams)
            print("keyData get back by PrivateKey: ", keyData)
            let privateKey = String(data: keyData, encoding: . utf8)!
            
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
                
                completionHandler( [address!, privateKey, strSignature])
               
            }
            
        }
        catch{
            print(error.localizedDescription)
           
        }
    }
    else { completionHandler( ["error cannot get dataKey or EthereumKeystoreV3 by this privateKey"] )}
   
   
}
