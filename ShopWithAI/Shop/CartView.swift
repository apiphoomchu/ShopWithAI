//
//  CartView.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var shopViewModel: ShopViewModel
    
    var body: some View {
        List {
            ForEach(shopViewModel.cartItems) { item in
                CartItemRow(item: item)
                    .swipeActions {
                        Button(role: .destructive) {
                            shopViewModel.removeFromCart(item: item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            
            if !shopViewModel.cartItems.isEmpty {
                Section {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("$\(shopViewModel.total, specifier: "%.2f")")
                            .font(.headline)
                    }
                    
                    NavigationLink(destination: CheckoutView()) {
                        Text("Proceed to Checkout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .navigationTitle("Cart")
        .overlay {
            if shopViewModel.cartItems.isEmpty {
                ContentUnavailableView(
                    "Empty Cart",
                    systemImage: "cart",
                    description: Text("Start shopping to add items to your cart")
                )
            }
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    
    var body: some View {
        HStack {
            Image(systemName: item.product.category.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(item.product.name)
                    .font(.headline)
                Text("$\(item.product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("Qty: \(item.quantity)")
                .font(.subheadline)
        }
    }
}

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingConfirmation = false
    
    var body: some View {
        Form {
            Section("Shipping Information") {
                TextField("Name", text: .constant(""))
                TextField("Address", text: .constant(""))
                TextField("City", text: .constant(""))
                TextField("Postal Code", text: .constant(""))
            }
            
            Section("Payment Information") {
                TextField("Card Number", text: .constant(""))
                TextField("Expiry Date", text: .constant(""))
                TextField("CVV", text: .constant(""))
            }
            
            Button("Place Order") {
                isShowingConfirmation = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Checkout")
        .alert("Order Confirmed", isPresented: $isShowingConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Thank you for your purchase!")
        }
    }
}
