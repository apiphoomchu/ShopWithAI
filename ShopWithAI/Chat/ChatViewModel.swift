//
//  ChatViewModel.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var newMessage: String = ""
    @Published var isLoading = false
    @Published var error: String?
    
    private let chatService = ChatService()
    private let productName: String
    
    init(productName: String) {
        self.productName = productName
        messages.append(ChatMessage(
            text: "Hi! I'm your shopping assistant for the \(productName). How can I help you today?",
            isUser: false
        ))
    }
    
    func sendMessage() async {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(text: newMessage, isUser: true)
        let userMessageText = newMessage
        messages.append(userMessage)
        newMessage = ""
        
        isLoading = true
        do {
            let response = try await chatService.generateResponse(
                for: productName,
                message: userMessageText
            )
            
            let aiMessage = ChatMessage(text: response, isUser: false)
            messages.append(aiMessage)
        } catch {
            self.error = "Failed to get response: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
