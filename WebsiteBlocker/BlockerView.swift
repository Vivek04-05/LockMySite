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
    
    @FocusState private var isDomainFieldFocused: Bool

    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack {
                
                Text("Block List")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.label))
                    .frame(maxWidth: .infinity,alignment: .bottom)
                    .frame(height: 50)
                    .background(Color(.systemGray5).opacity(0.6))
                    .clipShape(.rect(cornerRadius: 0))
                
                   
                    
                
                if !blockDomainArr.isEmpty {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVStack(alignment: .leading, spacing: 12) {
                                ForEach(blockDomainArr.indices, id: \.self) { index in
                                    
                                    listView(title: blockDomainArr[index]){
                                        deleteDomain(at: index)
                                    }
                                        .padding(.horizontal)
                                }
                            }.padding(.bottom, 80)
                                .padding(.top , 10)
                        }
//                        .scrollBounceBehavior(.basedOnSize)
                    Spacer()
                   
                        
                }else {
                    Spacer()
                    
                    VStack(spacing: 8) {
                            Text("Your Block List is Empty!")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.label))
                                .multilineTextAlignment(.center)
                            
                            Text("Add a Website to Start Focusing.")
                                .font(.subheadline)
                                .foregroundStyle(Color(.secondaryLabel))
                                .multilineTextAlignment(.center)
                        }
                    
                    Spacer()
                }
                
            }
            
            floatingButton(showAddDomainAlert: $showAddDomainAlert , isPermissionGranted: $isPermissionGranted)
            
            if showAddDomainAlert {
                addDomainAlert(domainName: $enteredDomain, showAddDomainAlert: $showAddDomainAlert, isDomainFieldFocused : $isDomainFieldFocused , addBtnCompletionHandler: {
                    self.addDomain(enteredDomain)
                    blockDomainArr = SharedData.getBlockedDomains()
                })
            }
        }
        .onAppear {
            blockDomainArr = SharedData.getBlockedDomains()
            askPermission()
        }
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
    func deleteDomain(at index: Int) {
            let domain = blockDomainArr[index]
            SharedData.removeBlockedDomain(domain) // Remove domain from persistent storage
        blockDomainArr.remove(at: index) // Update the UI list
    }
    
    func askPermission() {
        let sharedManager = NetworkFilterManager.shared
        sharedManager.checkNetworkPrefences { isSuccess in
            isPermissionGranted = isSuccess
        }
    }

}



@ViewBuilder
func listView(title: String, onDelete : @escaping () -> Void) -> some View {
    ZStack(alignment: .topTrailing) {
           VStack(alignment: .leading) {
               Text(title)
                   .font(.headline)
                   .fontWeight(.semibold)
                   .multilineTextAlignment(.leading)
                   .padding(.vertical, 12)
                   .padding(.horizontal , 10)
           }
           .frame(maxWidth: .infinity, alignment: .leading)
           .background(Color.white)
           .cornerRadius(10)
           .shadow(radius: 2)

           Button(action: {
               onDelete()
           }) {
               Image(systemName: "xmark.circle.fill")
                   .resizable()
                   .frame(width: 15, height: 15)
                   .foregroundColor(.gray)
                  
           }
           .offset(x: 5, y: -5)
       }
        
    
}


@ViewBuilder
func addDomainAlert(domainName : Binding<String> , showAddDomainAlert : Binding<Bool> ,isDomainFieldFocused : FocusState<Bool>.Binding, addBtnCompletionHandler: @escaping () -> ()) -> some View {
    

    ZStack {
        
        Color.black.opacity(0.3)
            .ignoresSafeArea()
            .onTapGesture {
                    showAddDomainAlert.wrappedValue.toggle()
                
            }
        
        VStack(spacing: 12) {
            Text("Enter Website Name")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color(.label))
                .padding(.top, 12)
            
            TextField("Enter domain", text: domainName)
//                .font(.system(.headline, weight: .regular))
                .padding(.horizontal , 15)
                .padding(.vertical , 15)
                .foregroundStyle(Color(.label))
                .background(Color(.systemGray5))
                .clipShape(.rect(cornerRadius: 10))
                .padding(.horizontal, 10)
                .focused(isDomainFieldFocused)
            
            
            Button {
                addBtnCompletionHandler()
            } label: {
                ZStack(alignment: .center) {
                    Text("Add")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal , 22)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.8))
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 10))
                }.padding(.bottom, 12)
            }
        }
        .background(.ultraThickMaterial)
        .clipShape(.rect(cornerRadius: 15))
        .padding(.horizontal, 20)
        .shadow(radius: 5)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()){
            isDomainFieldFocused.wrappedValue = true
        }
        }
        
           
    }
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
                    .foregroundStyle(.white)
                    .scaledToFit()
                    .tint(.white)
                    .padding(20)
                    .background(Color.blue.opacity(0.7))
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
