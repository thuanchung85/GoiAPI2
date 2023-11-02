import SwiftUI
import UniformTypeIdentifiers
import Foundation

//cấu trúc của account dành cho add account view list
struct Account_Type: Identifiable, Hashable
{
    var id = UUID()
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
            
            //list view các account
            ScrollView
            {
                HStack{
                    Text("Orther Network")
                        .font(.custom("Arial", size: 20))
                        .padding(.leading,15)
                    Spacer()
                }
                //list of orther network
                ForEach(self.arr_Accounts, id: \.self)
                { i in //section data
                    
                    HStack{
                        Text(i.nameWallet)
                            .font(.custom("Arial Bold", size: 14))
                            .padding(12)
                        Text(i.addressWallet)
                            .font(.custom("Arial", size: 12))
                            .padding(12)
                        Spacer()
                    }
                    .onTapGesture(perform: {
                        print(i.addressWallet)
                        print(i.nameWallet)
                    })
                    .padding(.horizontal,15)
                   
                    
                    
                }
                
            }//end scroll
            
            
        }//end Vstack
        //khi xuat hien thi khởi tạo core account
        .onAppear(){
            //tạo core account, account đầu tiên trong ví
            let accountCore = Account_Type(nameWallet: self.CoreAccount_WalletName,
                                           addressWallet: self.CoreAccount_addressWallet,
                                           pkey: self.CoreAccount_pkey)
            //gắn core account vào array
            arr_Accounts.append(accountCore)
        }
        
    }//end body
    
}//end struct
