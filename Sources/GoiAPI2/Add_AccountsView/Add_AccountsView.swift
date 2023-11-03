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
    
    //===INIT==//
    public init(isBack:Binding<Bool>, CoreAccount_WalletName: String,CoreAccount_addressWallet:String,CoreAccount_pkey:String)  {
        self._isBack = isBack
        self.CoreAccount_WalletName = CoreAccount_WalletName
        self.CoreAccount_addressWallet = CoreAccount_addressWallet
        self.CoreAccount_pkey = CoreAccount_pkey
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
                    ForEach(self.arr_Accounts, id: \.self)
                    { i in //section data
                        
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
                                       print("show detail sheet")
                                        
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
                                    }
                                    Spacer()
                                }.padding(.top,30)
                            }//end VStack
                            
                        }
                        .onTapGesture(perform: {
                            print(i.addressWallet)
                            print(i.nameWallet)
                            print(i.pkey)
                        })
                        .frame(height: 120)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal,15)
                       
                        
                        
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
                   
                    
                    //nut import account
                    Button(action: {
                       print("import Account")
                        
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
            let accountCore = Account_Type(nameWallet: self.CoreAccount_WalletName + " (Core Account)",
                                           addressWallet: self.CoreAccount_addressWallet,
                                           pkey: self.CoreAccount_pkey)
            //gắn core account vào array
            arr_Accounts.append(accountCore)
            //kiểm tra user default coi có bao nhieu account phu gắn với Wallet address này
            let s = UserDefaults.standard.string(forKey: "\(self.arr_Accounts.first!.addressWallet)_AccountPhu")
            print("so luong _AccountPhu cua: \(self.arr_Accounts.first!.addressWallet) : \(s ?? "chua co")")
            
            //add them theo so luong s tra ra
            let chay = Int(s!) ?? 0
            for _ in 1...chay {
                print("play")
            }
        }
        
        //show sheet người dùng nhập tên ví mới
        .sheet(isPresented: $isShow_SheetEnterWalletName,
                content: {
            SheetCreateAccountView(add_NewAccountName: self.$add_NewAccountName,
                                   isShow_SheetEnterWalletName: self.$isShow_SheetEnterWalletName,
                                   arr_Accounts: self.$arr_Accounts)
           
         })//end sheet
     
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
