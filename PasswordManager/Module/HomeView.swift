//
//  HomeView.swift
//  PasswordManager
//
//  Created by GWL on 14/07/24.
//

import SwiftUI

struct HomeView: View {
    @State private var passwords: [DataModel] = [] // Fetch from the database
    @State private var showingAddPassword = false
    @State private var showAccountDetails = false
    @State private var accountDetails: DataModel?
    @State private var showingAlert = false
    func maskString(_ input: String) -> String {
        return String(repeating: "*", count: input.count)
    }
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    Text("Password Manager")
                        .font(.title)
                        .bold()
                    Spacer()
                }.padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    .padding(.top, 20)
                Rectangle()
                    .foregroundColor(Color(UIColor.AppColor.greyColor))
                    .frame(height: 1.5)
                    .padding(.bottom, 15)
                List(passwords) { accountDetails in
                    VStack {
                        HStack {
                            Text(accountDetails.accountName)
                                .font(.headline)
                                .bold().padding(.bottom, 6)
                            Text(maskString(accountDetails.password))
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }.padding(.horizontal, 10)
                    }
                    .onTapGesture {
                        withAnimation {
                            self.accountDetails = accountDetails
                            self.showAccountDetails = true
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 66)
                    .background(Color(UIColor.white))
                    .cornerRadius(50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 0.7)
                    )
                    .modifier(RemoveSeparatorModifier())
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(EdgeInsets(
                        top: .zero,
                        leading: 0,
                        bottom: 20,
                        trailing: 0
                    )))
                    .background(.clear)
                }.listStyle(PlainListStyle())
                    .padding(.horizontal, 14)
                    .background(.clear)
            } .background(Color(UIColor.systemGroupedBackground))
            Button {
                withAnimation {
                    self.showingAddPassword = true
                }
            } label: {
                Image(.plusIcon)
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 25)
            }
            // Overlay Add Account View
            if showingAddPassword {
                AddAccountView(showAddAccount: $showingAddPassword, didClose: { isPasswordSaved in
                    if isPasswordSaved {
                        self.passwords = CoreDataManager.shared.fetchPasswords()
                    }
                }).transition(.move(edge: .bottom))
            }
            if showAccountDetails {
                AccountDetailsView(
                    showAccountDetails: $showAccountDetails,
                    entry: accountDetails ?? DataModel(id: UUID(), accountName: "", username: "", password: "" ), didClose: { isUpdate, isDelete, details in
                        if isUpdate {
                            CoreDataManager.shared.updatePassword(
                                id: details.id,
                                accountName: details.accountName,
                                username: details.username,
                                password: details.password
                            )
                            self.passwords = CoreDataManager.shared.fetchPasswords()
                        }
                        if isDelete {
                            self.accountDetails = details
                            showingAlert = true
                        }
                    }
                ).transition(.move(edge: .bottom))
            }
        }
      //  .onDelete(perform: deletePassword)
        .onAppear {
            self.passwords = CoreDataManager.shared.fetchPasswords()
        }
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Delete Password"),
                message: Text("Are you sure you want to delete this password?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let passwordToDelete = self.accountDetails {
                        CoreDataManager.shared.deletePassword(id: passwordToDelete.id)
                        self.passwords = CoreDataManager.shared.fetchPasswords()
                        showingAlert = false
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onTapGesture {
      // showingAddPassword = false
//            showAccountDetails = false
        }
    }
}
