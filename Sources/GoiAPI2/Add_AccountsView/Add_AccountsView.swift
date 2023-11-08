import SwiftUI
import UniformTypeIdentifiers
import Foundation
import web3swift
import Web3Core

//cấu trúc của account dành cho add account view list
public struct Account_Type: Identifiable, Hashable
{
    public var id = UUID()
    var nameWallet:String
    var addressWallet: String
    var pkey:String
    var signatureForBackEnd:String
}

public struct Add_AccountsView: View {
    @Binding var isBack:Bool
    
    //đây là account chính của ví, khi khôi phục thì đây là account sẽ lấy lại được
    @State var CoreAccount_WalletName:String
    @State var CoreAccount_addressWallet:String
    @State var CoreAccount_pkey:String
    
    @State var arr_Accounts:[Account_Type] = []
    
    //show sheet add account
    @State var isShow_SheetEnterWalletName = false
    @State var add_NewAccountName = ""
    
    //khi user chọn account nào làm account active thì ta bắn thông tin đó ra ngoài
    @Binding var choose_WalletAddress:String
    @Binding var choose_WalletName:String
    @Binding var choose_WalletPkey:String
    @Binding var choose_WalletSignatureOfCoreAccount_ForBackEnd:String
    
    @State var currentChooseAccountIndex: Int = 0
    
    //biến show isShowSheet_QRCodeMakerView
    @State var isShowSheet_QRCodeMakerView = false
    
    //biến show sheet khôi phục account bằng PKEY
    @State var isShow_SheetRecoverAccountFromPkey = false
    
  
    
    //===INIT==//
    public init(isBack:Binding<Bool>, CoreAccount_WalletName: String,CoreAccount_addressWallet:String,CoreAccount_pkey:String,
                choose_WalletAddress:Binding<String>,choose_WalletName:Binding<String>,choose_WalletPkey:Binding<String>,
                choose_WalletSignatureOfCoreAccount_ForBackEnd:Binding<String>)  {
        self._isBack = isBack
        self.CoreAccount_WalletName = CoreAccount_WalletName
        self.CoreAccount_addressWallet = CoreAccount_addressWallet
        self.CoreAccount_pkey = CoreAccount_pkey
        self._choose_WalletAddress = choose_WalletAddress
        self._choose_WalletName = choose_WalletName
        self._choose_WalletPkey = choose_WalletPkey
        self._choose_WalletSignatureOfCoreAccount_ForBackEnd = choose_WalletSignatureOfCoreAccount_ForBackEnd
    }
    
    
    //===BODY===//
    public var body: some View {
        VStack(){
            //khu title và nut back
            HStack{
                ZStack{
                    //nut thoat khoi view này
                    HStack{
                        Button(action: {
                            self.isBack = false
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(Color.green)
                        }
                        Spacer()
                    }
                    
                    //tiêu đề
                    HStack{
                        Spacer()
                        Text("Choose wallet")
                            .font(.custom("Arial ", size: 20))
                            .padding(.top,10)
                        Spacer()
                    }
                }
            }
            .padding()
            
            //list view các account
            ScrollView
            {
                //Nút thêm account
                VStack{
                    //list of orther network
                    ForEach(Array(self.arr_Accounts.enumerated()), id: \.offset) { index, i in
                   
                    //ForEach(self.arr_Accounts, id: \.self)
                    //{ i in //section data
                        
                        HStack{
                            
                            ZStack(alignment: .top){
                                //dòng ở trên tên ví và nut detail
                                HStack(){
                                    //tên ví
                                    Text(i.nameWallet)
                                        .font(.custom("Arial Bold", size: 20))
                                        .padding(.horizontal,20)
                                        .scaledToFit()
                                        .minimumScaleFactor(0.01)
                                        
                                    Spacer()
                                    //nut detail
                                    Button(action: {
                                       print("show detail sheet isShowSheet_QRCodeMakerView")
                                        print("index là:", index)
                                        self.currentChooseAccountIndex = index
                                        print("currentChooseAccountIndex là:", self.currentChooseAccountIndex)
                                        self.isShowSheet_QRCodeMakerView = true
                                    }) {
                                        Text("Detail")
                                            .foregroundColor(Color.black)
                                            .font(.custom("Arial Bold", size: 15))
                                            .padding(.horizontal,20)
                                    }
                                }.padding(.top,3)
                                
                                //dòng dưới địa chỉ ví và private key
                                HStack{
                                    VStack(alignment: .leading){
                                        Text(short_WalletAddress(s: i.addressWallet))
                                            .font(.custom("Arial", size: 15))
                                            .padding(.horizontal,20)
                                        Text(i.pkey)
                                            .foregroundColor(Color.red)
                                            .font(.custom("Arial", size: 12))
                                            .padding(.horizontal,20)
                                            //.opacity(0.0)
                                        Text(i.signatureForBackEnd)
                                            .foregroundColor(Color.green)
                                            .font(.custom("Arial", size: 12))
                                            .padding(.horizontal,20)
                                    }
                                    Spacer()
                                }.padding(.top,30)
                            }//end VStack
                            
                        }
                        .frame(height: 120)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.5), .gray.opacity(0.2)]), startPoint: .top, endPoint: .bottom)
                            )
                        .cornerRadius(10)
                        .padding(.horizontal,15)
                        .onTapGesture(perform: {
                            print("CHỌN ACCOUNT NAY active:")
                            print(i.addressWallet)
                            self.choose_WalletAddress = i.addressWallet
                            print(i.nameWallet)
                            self.choose_WalletName = i.nameWallet
                            print(i.pkey)
                            self.choose_WalletPkey = i.pkey
                            self.currentChooseAccountIndex = index
                            print("currentChooseAccountIndex là:", self.currentChooseAccountIndex)
                            print(self.currentChooseAccountIndex)
                            //shut off this view
                            self.isBack = false
                        })
                        
                        
                        
                    }
                    
                    
                    //nut add account
                    Button(action: {
                       print("add Account")
                        self.add_NewAccountName = ""
                        self.isShow_SheetEnterWalletName = true
                    }) {
                        HStack{
                            Image(systemName: "plus.circle")
                                .renderingMode(.template)
                                .foregroundColor(Color.white)
                            Text("Add a wallet")
                                .foregroundColor(Color.white)
                                .font(.custom("Arial", size: 20))
                                .padding(.horizontal,5)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                    }
                   
                    
                    //nut Recovery account
                    Button(action: {
                       print("import Account")
                        self.add_NewAccountName = ""
                        isShow_SheetRecoverAccountFromPkey = true
                    }) {
                        HStack{
                            Image(systemName: "plus.circle")
                                .renderingMode(.template)
                                .foregroundColor(Color.white)
                            Text("Recovery wallet")
                                .foregroundColor(Color.white)
                                .font(.custom("Arial", size: 20))
                                .padding(.horizontal,5)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60 ,maxHeight: 60)
                        .background(Color.green)
                        .cornerRadius(10)
                        .padding(.horizontal,20)
                    }
                    
                }
            }//end scroll
            .frame(maxWidth: .infinity, maxHeight: .infinity)
           
            
        }//end Vstack
        //khi xuat hien thi khởi tạo core account
        .onAppear(){
            //tạo core account, account đầu tiên trong ví
            let pkey_saved = keychain_read_ForPkey(service: "PoolsWallet_\(self.CoreAccount_addressWallet)_PKey", account: self.CoreAccount_addressWallet)
            let stringPkey = String(decoding: pkey_saved ?? Data(), as: UTF8.self)
            self.CoreAccount_pkey = stringPkey
            
            let sig = UserDefaults.standard.string(forKey: "signatureOfAccount<->\(self.CoreAccount_addressWallet)") ?? "no found"
            let accountCore = Account_Type(nameWallet: self.CoreAccount_WalletName + " (Core Account)",
                                           addressWallet: self.CoreAccount_addressWallet,
                                           pkey: self.CoreAccount_pkey, signatureForBackEnd: sig)
            //gắn core account vào array
            arr_Accounts.append(accountCore)
            //kiểm tra user default coi có bao nhieu account phu gắn với Wallet address này
            let s = UserDefaults.standard.string(forKey: "\(self.arr_Accounts.first!.addressWallet)_SoLuongAccountPhu") ?? "0"
            print("so luong _AccountPhu cua: \(self.arr_Accounts.first!.addressWallet) : \(s )")
            
            //add them theo so luong s tra ra
            let chay = Int(s) ?? 0
            if(chay >= 1){
                for i in 1...chay {
                    let k = "\(self.arr_Accounts.first!.addressWallet)_AccountPhu\(i)"
                    print(k)
                    let returnString = UserDefaults.standard.string(forKey: k)
                    print("get user default account phu -> \(String(describing: returnString))")
                    if (returnString != nil)
                    {
                        let arrayOfParams = returnString!.components(separatedBy: "+|@|+")
                        print(arrayOfParams)
                        if(arrayOfParams.count == 3){
                            let sig = UserDefaults.standard.string(forKey: "signatureOfAccount<->\(arrayOfParams[1])") ?? "no found"
                            let newAcc = Account_Type(nameWallet: arrayOfParams.first!,
                                                      addressWallet: arrayOfParams[1], pkey: arrayOfParams.last!,
                                                      signatureForBackEnd: sig)
                            self.arr_Accounts.append(newAcc)
                        }
                    }
                }
            }
        }
        
        //show sheet người dùng nhập tên ví mới
        .sheet(isPresented: $isShow_SheetEnterWalletName,
                content: {
            SheetCreateAccountView(add_NewAccountName: self.$add_NewAccountName,
                                   isShow_SheetEnterWalletName: self.$isShow_SheetEnterWalletName,
                                   arr_Accounts: self.$arr_Accounts)
           
         })//end sheet
     
        //show sheet người dùng nhập Private Key khôi phục account củ
        .sheet(isPresented: $isShow_SheetRecoverAccountFromPkey,
                content: {
            SheetRecoverAccountFromPkey(add_NewAccountName: self.$add_NewAccountName,
                                        isShow_SheetRecoverAccountFromPkey: self.$isShow_SheetRecoverAccountFromPkey, arr_Accounts: self.$arr_Accounts)
           
         })//end sheet
        
        
        //sheet show mã QR của account khi user nhấp vào detail
        .sheet(isPresented: self.$isShowSheet_QRCodeMakerView,content: {
            
            QRCodeMakerView(width: 300, height: 300, accountInput: self.arr_Accounts, currentIndex: self.$currentChooseAccountIndex)
            .onAppear(){
                print("arr_Accounts: ",  self.arr_Accounts[self.currentChooseAccountIndex])
                print("self.currentChooseAccountIndex: \(self.currentChooseAccountIndex)")
            }
        })
    }//end body
    
}//end struct

///ham rút gọn đị chỉ ví thành 0x08...0000
func short_WalletAddress(s:String) -> String{
    if((s.isEmpty == false) && (s != "making...")){
        let Arr = Array(s)
        let substring = "\(Arr[0])\(Arr[1])\(Arr[2])\(Arr[3])...\(Arr[Arr.count-4])\(Arr[Arr.count-3])\(Arr[Arr.count-2])\(Arr[Arr.count-1])"
        return substring
    }
    else{
        return s
    }
}


public func keychain_read_ForPkey(service: String, account: String) -> Data? {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrService: service,
        kSecAttrAccount: account,
        kSecReturnData: true
    ] as CFDictionary
        
    var result: AnyObject?
    SecItemCopyMatching(query, &result)
    return result as? Data
}
