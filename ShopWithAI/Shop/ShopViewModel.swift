//
//  ShopViewModel.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import SwiftUI

class ShopViewModel: ObservableObject {
    
    @Published var products: [Product] = [
        Product(name: "MacBook Pro",
               price: 1299.99,
               description: "14-inch MacBook Pro with M2 chip",
               imageUrl: "laptop",
               category: .electronics),
        Product(name: "AirPods Pro",
               price: 249.99,
               description: "Wireless earbuds with noise cancellation",
               imageUrl: "headphones",
               category: .electronics),
        Product(name: "Cotton T-Shirt",
               price: 29.99,
               description: "Premium cotton t-shirt",
               imageUrl: "tshirt",
               category: .clothing),
        Product(name: "Swift Programming",
               price: 49.99,
               description: "Learn Swift programming from scratch",
               imageUrl: "book",
               category: .books),
        Product(name: "Smart Watch",
               price: 399.99,
               description: "Advanced fitness tracking smartwatch",
               imageUrl: "watch",
               category: .accessories)
    ]
    
    @Published var cartItems: [CartItem] = []
    @Published var showNotification = false
    @Published var notificationMessage = ""
    
    var total: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    func isInCart(product: Product) -> Bool {
        cartItems.contains(where: { $0.product.id == product.id })
    }
    
    func addToCart(product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
            showNotification(message: "Added another \(product.name) to cart")
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
            showNotification(message: "Added \(product.name) to cart")
        }
    }
    
    func removeFromCart(item: CartItem) {
        cartItems.removeAll(where: { $0.id == item.id })
        showNotification(message: "Removed \(item.product.name) from cart")
    }
    
    private func showNotification(message: String) {
        notificationMessage = message
        showNotification = true
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.showNotification = false
            }
        }
    }
}
