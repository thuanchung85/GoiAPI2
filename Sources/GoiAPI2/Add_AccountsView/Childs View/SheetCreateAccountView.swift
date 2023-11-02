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
    @State var tempAddress:String = ""
    @State var isFirstResponder = false
    
    
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
                    Text("Wallet Name")
                        .font(.custom("Arial ", size: 15))
                        .padding(.top,15)
                        .padding(.horizontal,20)
                    //TextField("Enter your wallet name", text: self.$add_NewAccountName)
                    LegacyTextField(text: self.$add_NewAccountName, isFirstResponder: $isFirstResponder)
                        .frame(height: 60)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 4)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                        .padding([.horizontal], 20)
                    
                    Spacer()
                    
                    //nut add account
                    if(self.add_NewAccountName.isEmpty == false) && (self.tempAddress.isEmpty == false){
                        Button(action: {
                            print("Create Account")
                            //off this sheet
                            self.isShow_SheetEnterWalletName = false
                            //tạo account mới
                            let newAcc = Account_Type(nameWallet: self.add_NewAccountName,
                                                      addressWallet: self.tempAddress, pkey: "making...")
                            self.arr_Accounts.append(newAcc)
                            self.isFirstResponder = true
                            //xoa tên account vì đã tạo xong
                            self.add_NewAccountName = ""
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
        .onAppear(){
            DispatchQueue.main.async {
                self.tempAddress = makeEthereumAddressAccount()
                print("tempAddress make new: ",  self.tempAddress)
            }
           
        }
    }
    
}//end struct

//==hàm tạo nhanh 1 account ethereum==//
func makeEthereumAddressAccount() -> String
{
    do {
     let keystore = try EthereumKeystoreV3.init(password: "")
        return keystore?.addresses?.first?.address ?? "keystore error no data"
     } catch {
     print(error.localizedDescription)
     }
    return "error no data"
}


struct LegacyTextField: UIViewRepresentable {
    @Binding public var isFirstResponder: Bool
    @Binding public var text: String

    public var configuration = { (view: UITextField) in }

    public init(text: Binding<String>, isFirstResponder: Binding<Bool>, configuration: @escaping (UITextField) -> () = { _ in }) {
        self.configuration = configuration
        self._text = text
        self._isFirstResponder = isFirstResponder
    }

    public func makeUIView(context: Context) -> UITextField {
        let view = UITextField()
        view.addTarget(context.coordinator, action: #selector(Coordinator.textViewDidChange), for: .editingChanged)
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        switch isFirstResponder {
        case true: uiView.becomeFirstResponder()
        case false: uiView.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator($text, isFirstResponder: $isFirstResponder)
    }

    public class Coordinator: NSObject, UITextFieldDelegate {
        var text: Binding<String>
        var isFirstResponder: Binding<Bool>

        init(_ text: Binding<String>, isFirstResponder: Binding<Bool>) {
            self.text = text
            self.isFirstResponder = isFirstResponder
        }

        @objc public func textViewDidChange(_ textField: UITextField) {
            self.text.wrappedValue = textField.text ?? ""
        }

        public func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = true
        }

        public func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFirstResponder.wrappedValue = false
        }
    }
}
