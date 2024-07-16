//
//  AddAccountView.swift
//  PasswordManager
//
//  Created by GWL on 14/07/24.
//

import SwiftUI

struct AddAccountView: View {
    @Binding var showAddAccount: Bool
    @State private var accountName: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State var showPassword: Bool = false
    var didClose: (
        _ isClosed: Bool
    ) -> Void
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 46, height: 4)
                    .padding(.bottom, 10)
                TextField("Account Name", text: $accountName)
                    .font(.caption)
                    .padding()
                    .frame(height: 44)
                    .background(Color(UIColor.white))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black.opacity(0.2), lineWidth: 0.6)
                    )
                TextField("Username/ Email", text: $username)
                    .font(.caption)
                    .padding()
                    .frame(height: 44)
                    .background(Color(UIColor.white))
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black.opacity(0.2), lineWidth: 0.6)
                    )
                HStack {
                    if showPassword {
                        TextField("Password", text: $password)
                            .font(.caption)
                            .padding()
                    } else {
                        SecureField("Password", text: $password)
                            .font(.caption)
                            .padding()
                    }
                    Spacer()
                        .background(Color(UIColor.white))
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(Color(UIColor.AppColor.greyTextColor))
                            .frame(width: 14, height: 13)
                            .padding(.trailing, 16)
                    }
                } 
                .frame(height: 44)
                .background(Color(UIColor.white))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(password.isEmpty ? Color.black.opacity(0.2) : color(
                            strength: PasswordStrengthEvaluator.evaluate(password: password)
                        ), lineWidth: 0.6)
                )
                Button {
                    // Action to add new account
                    withAnimation {
                        CoreDataManager.shared.savePassword(
                            accountName: accountName,
                            username: username,
                            password: password
                        )
                    }
                    showAddAccount = false
                    didClose(true)
                } label: {
                    Text("Add New Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(isEmptyField() ? .gray : Color.black)
                        .cornerRadius(20)
                }.disabled(isEmptyField())
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
    // Button Enable/Disable function
    func isEmptyField() -> Bool {
        if self.accountName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            self.username.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            self.password.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            color(
                strength: PasswordStrengthEvaluator.evaluate(password: password)
            ) != .green
        {
            return true
        }
        return false
    }
    private func color(strength: PasswordStrength) -> Color {
        switch strength {
        case .weak:
            return .red
        case .moderate:
            return .yellow
        case .strong:
            return .green
        }
    }
}
