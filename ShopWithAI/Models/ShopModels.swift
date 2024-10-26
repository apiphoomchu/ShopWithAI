//
//  Models.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import Foundation

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let description: String
    let imageUrl: String
    let category: ProductCategory
}

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}

enum ProductCategory: String, CaseIterable {
    case electronics = "Electronics"
    case clothing = "Clothing"
    case books = "Books"
    case accessories = "Accessories"
    
    var systemImage: String {
        switch self {
        case .electronics: return "laptopcomputer"
        case .clothing: return "tshirt"
        case .books: return "book"
        case .accessories: return "headphones"
        }
    }
}
