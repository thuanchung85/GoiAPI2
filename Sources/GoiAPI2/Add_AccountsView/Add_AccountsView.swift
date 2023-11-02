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
    @State var CoreAccount:Account_Type
    
    @State var arr_AccountsPhu:[Account_Type] = []
    
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
                ForEach(self.arr_AccountsPhu, id: \.self)
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
        
        
    }//end body
    
}//end struct
