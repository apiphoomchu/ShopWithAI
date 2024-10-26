//
//  ContentView.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var shopViewModel = ShopViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                ProductListView()
            }
            .tabItem {
                Label("Shop", systemImage: "bag")
            }
            
            NavigationStack {
                CartView()
            }
            .tabItem {
                Label("Cart", systemImage: "cart")
            }
        }
        .environmentObject(shopViewModel)
        .overlay(alignment: .top) {
            if shopViewModel.showNotification {
                NotificationBanner(message: shopViewModel.notificationMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

struct ProductListView: View {
    @EnvironmentObject var shopViewModel: ShopViewModel
    
    var body: some View {
        List {
            ForEach(ProductCategory.allCases, id: \.self) { category in
                Section(category.rawValue) {
                    ForEach(shopViewModel.products.filter { $0.category == category }) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductRow(product: product)
                        }
                    }
                }
            }
        }
        .navigationTitle("Shop")
    }
}

struct ProductRow: View {
    let product: Product
    @EnvironmentObject var shopViewModel: ShopViewModel
    
    var body: some View {
        HStack {
            Image(systemName: product.category.systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("$\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if shopViewModel.isInCart(product: product) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}

struct ProductDetailView: View {
    @EnvironmentObject var shopViewModel: ShopViewModel
    let product: Product
    @State private var showingChat = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: product.category.systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.name)
                        .font(.title)
                    
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text(product.description)
                        .font(.body)
                        .padding(.top)
                }
                .padding()
                
                HStack(spacing: 12) {
                    Button(action: {
                        shopViewModel.addToCart(product: product)
                    }) {
                        HStack {
                            Text(shopViewModel.isInCart(product: product) ? "Add Another to Cart" : "Add to Cart")
                            if shopViewModel.isInCart(product: product) {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(shopViewModel.isInCart(product: product) ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        showingChat = true
                    }) {
                        Image(systemName: "message.circle.fill")
                            .font(.system(size: 24))
                            .frame(width: 50, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingChat) {
            NavigationStack {
                ChatView(productName: product.name)
            }
        }
    }
}

struct NotificationBanner: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.top, 50)
            .animation(.spring(), value: message)
    }
}
