//
//  BlockerView.swift
//  WebsiteBlocker
//
//  Created by Vivek Patel on 09/05/25.
//

import SwiftUI
import NetworkExtension

struct BlockerView: View {
    
    @State var blockDomainArr: [String] = []
    @State private var enteredDomain: String = ""
    @State private var showAddDomainAlert: Bool = false
    @State private var isPermissionGranted: Bool = false // To check wether user give permission or not
    
    init() {
//        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            
            Color.green
            
            VStack {
                
                Text("Website Blocker")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding(.top, 5)
                
                if !blockDomainArr.isEmpty {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(blockDomainArr, id: \.self) { item in
                                    listView(title: item)
                                        .padding(.horizontal)
                                }.onDelete { indexSet in
                                    deleteDomain(at: indexSet)
                                }
                            }.padding(.bottom, 80)
                                .padding(.top , 10)
                        }
                        .scrollBounceBehavior(.basedOnSize)
                    Spacer()
                   
                        
                }else {
                    Spacer()
                    
                    Text("Add Website Domain")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                
            }
            
            floatingButton(showAddDomainAlert: $showAddDomainAlert , isPermissionGranted: $isPermissionGranted)
            
            if showAddDomainAlert {
                addDomainAlert(domainName: $enteredDomain, showAddDomainAlert: $showAddDomainAlert, addBtnCompletionHandler: {
                    self.addDomain(enteredDomain)
                    blockDomainArr = SharedData.getBlockedDomains()
                })
            }
        }
        .onAppear {
            blockDomainArr = SharedData.getBlockedDomains()
            askPermission()
        }

        .background(Color.red)
    }
    
    // Function Add new Website Domain it
    func addDomain(_ domain: String) {
        
        guard !domain.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        var current = SharedData.getBlockedDomains()
        if !current.contains(where: { $0.lowercased() == domain.lowercased() }) {
            current.append(domain)
            SharedData.saveBlockedDomains(current)
            enteredDomain = ""
            showAddDomainAlert = false
        }
    }
    
    // Function for delet ean Exitind Domain
    func deleteDomain(at offsets: IndexSet) {
        for index in offsets {
            let domain = blockDomainArr[index]
            SharedData.removeBlockedDomain(domain) // Remove domain from persistent storage
        }
        blockDomainArr.remove(atOffsets: offsets) // Update the UI list
    }
    
    func askPermission() {
        let sharedManager = NetworkFilterManager.shared
        sharedManager.checkNetworkPrefences { isSuccess in
            isPermissionGranted = isSuccess
        }
    }

}



@ViewBuilder
func listView(title: String) -> some View {
    VStack(alignment: .leading) {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .multilineTextAlignment(.leading)
            .lineLimit(2, reservesSpace: false)
            .padding(.vertical, 12)
            .padding(.horizontal , 5)
           
    } .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(8)
    
}


@ViewBuilder
func addDomainAlert(domainName : Binding<String> , showAddDomainAlert : Binding<Bool> , addBtnCompletionHandler: @escaping () -> ()) -> some View {
    

    ZStack {
        
        Color.black.opacity(0.25)
            .ignoresSafeArea(.all)
            .onTapGesture {
                    showAddDomainAlert.wrappedValue.toggle()
                
            }
        
        VStack(spacing: 10) {
            Text("Enter Website Name")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
            
            TextField("Enter domain", text: domainName)
                .font(.system(.headline, weight: .regular))
                .padding(.horizontal , 15)
                .padding(.vertical , 15)
                .foregroundStyle(.black)
                .background(.gray.opacity(0.28))
                .clipShape(.rect(cornerRadius: 8))
                .padding(.horizontal, 10)
            
            
            Button {
                print("Added")
                addBtnCompletionHandler()
            } label: {
                ZStack(alignment: .center) {
                    Text("Add")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal , 22)
                        .padding(.vertical, 8)
                        .background(.gray.opacity(0.8))
                        .foregroundStyle(.black)
                        .clipShape(.rect(cornerRadius: 8))
                }.padding(.bottom, 12)
            }
        }
        .background(.ultraThickMaterial)
        .padding(.horizontal)
        
           
    }.shadow(radius: 5)
}

@ViewBuilder
func floatingButton(showAddDomainAlert : Binding<Bool> , isPermissionGranted : Binding<Bool>) -> some View {
    HStack {
        Spacer()
        VStack {
            Spacer()
            Button {
                if isPermissionGranted.wrappedValue {
                    withAnimation(.spring(dampingFraction: 0.7)) {
                        showAddDomainAlert.wrappedValue.toggle()
                    }
                } else {
                    let sharedManager = NetworkFilterManager.shared
                    sharedManager.checkNetworkPrefences { isSuccess in
                        isPermissionGranted.wrappedValue = isSuccess
                    }
                }
               
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .scaledToFit()
                    .tint(.white)
                    .padding(20)
                    .background(Color.brown)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            .padding(.bottom, 10)
            .padding(.trailing, 12)
        }
    }
}

#Preview {
    BlockerView()
}
