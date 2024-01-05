//
//  ContentView.swift
//  MobiliseTask
//
//  Created by Bakare Waris on 05/01/2024.
//

import SwiftUI

struct PaymentDetails {
    var cardholderName: String = ""
    var cardNumber: String = ""
    var expiryDate: String = ""
    var cvc: String = ""
}


struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PaymentInputView()) {
                    Text("Enter Your Payment Details")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding()
            .navigationTitle("Payment App")
        }
    }
    
}


struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(Color.white)
            .cornerRadius(8)
            .border(Color.black.opacity(0.5), width: 1)
    }
}



struct PaymentInputView: View {
    @State private var paymentDetails = PaymentDetails()
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Cardholder Name")
                           .font(.headline)
                           .foregroundColor(.white)
                           .padding(.bottom, 1)

            TextField("Enter Cardholder Name", text: $paymentDetails.cardholderName)
                .modifier(CustomTextFieldStyle())
            
            Text("Card Number")
                           .font(.headline)
                           .foregroundColor(.white)
                           .padding(.bottom, 1)

            
            TextField("Card Number", text: Binding(
                get: { self.cardNumber },
                set: {
                    let filtered = $0.filter { "0123456789".contains($0) }
                    if filtered.count <= 16 {
                        self.cardNumber = filtered.enumerated().map {
                            $0 > 0 && $0 % 4 == 0 ? [" ", $1] : [$1]
                        }.joined().map(String.init).joined()
                    }
                }
            ))
            .onChange(of: paymentDetails.cardNumber) { newValue in
                if newValue.count > 16 {
                    paymentDetails.cardNumber = String(newValue.prefix(16))
                }
            }
            .modifier(CustomTextFieldStyle())
            
            Text("Expiry Date")
                           .font(.headline)
                           .foregroundColor(.white)
                           .padding(.bottom, 1)

            
            TextField("Expiry Date", text: Binding(
                get: { self.expiryDate },
                set: {
                    let filtered = $0.filter { "0123456789".contains($0) }
                    let formatted = formatExpiryDate(filtered)
                    self.expiryDate = formatted
                }
            ))
            .modifier(CustomTextFieldStyle())
            
            Text("CVV")
                           .font(.headline)
                           .foregroundColor(.white)
                           .padding(.bottom, 1)
            SecureField("CVC", text: Binding(
                get: { self.paymentDetails.cvc },
                set: {
                    let filtered = $0.filter { "0123456789".contains($0) }
                    if filtered.count <= 3 {
                        self.paymentDetails.cvc = filtered
                    }
                }
            ))
            .modifier(CustomTextFieldStyle())

            Button("Submit Payment") {
                showAlert = true
            }
            .frame(width: 150, height: 40)
            .background(Color.white)
            .cornerRadius(8)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Thank You!"), message: Text("Card Details Submitted"), dismissButton: .default(Text("OK")))
            }
            
        }
        .padding()
        .background(Color.black)
        .navigationTitle("Card Details")
    }
    
    private func formatExpiryDate(_ input: String) -> String {
        var formatted = input
        if formatted.count > 2 {
            formatted.insert("/", at: formatted.index(formatted.startIndex, offsetBy: 2))
        }
        if formatted.count > 5 {
            formatted = String(formatted.prefix(5))
        }
        return formatted
    }
}


