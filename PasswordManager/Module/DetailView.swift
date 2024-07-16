//
//  DetailView.swift
//  PasswordManager
//
//  Created by GWL on 14/07/24.
//

import SwiftUI

struct AccountDetailsView: View {
    @Binding var showAccountDetails: Bool
    @State var entry: DataModel
    @State private var updatedPassword: String = ""
    @State var showPassword: Bool = false
    var didClose: (
        _ isPasswordEdit: Bool,
        _ isDeleted: Bool,
        _ details: DataModel
    ) -> Void
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 46, height: 4)
                HStack {
                    Text("Account Details")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor.AppColor.blueColor))
                    Spacer()
                }.padding(.bottom, 10)
                VStack(alignment: .leading) {
                    Text("Account Type")
                        .font(.caption2)
                        .foregroundColor(Color.gray.opacity(0.8))
                    Text(entry.accountName)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    Text("Username/ Email")
                        .font(.caption2)
                        .foregroundColor(Color.gray.opacity(0.8))
                    Text(entry.username)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    Text("Password")
                        .font(.caption2)
                        .foregroundColor(Color.gray.opacity(0.8))
                    HStack {
                        if showPassword {
                            TextField("Password", text: $entry.password)
                                .fontWeight(.bold)
                        } else {
                            SecureField("Password", text: $entry.password)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                                .foregroundColor(Color(UIColor.AppColor.greyTextColor))
                                .frame(width: 14, height: 13)
                                .padding(.trailing, 16)
                        }
                    }
                }.padding(.bottom, 30)
                HStack {
                    Button(action: {
                        // Action to edit account
                        withAnimation {
                            print(entry)
                            didClose(true, false, entry)
                            showAccountDetails = false
                        }
                    }) {
                        Text("Edit")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(entry.password.isEmpty ? .gray : Color.black)
                            .cornerRadius(20)
                    }.disabled(entry.password.isEmpty)
                    Button(action: {
                        // Action to delete account
                        withAnimation {
                            didClose(false, true, entry)
                            showAccountDetails = false
                        }
                    }) {
                        Text("Delete")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color(UIColor.AppColor.redColor))
                            .cornerRadius(20)
                    }
                }
                .padding(.bottom, 20)
            }
            .padding()
            .background(Color(UIColor.AppColor.bgColor))
            .cornerRadius(17)
            .shadow(radius: 20)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.black.opacity(0.4))
    }
}
