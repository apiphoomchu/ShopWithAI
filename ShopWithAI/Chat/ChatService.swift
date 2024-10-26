//
//  ChatService.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import Foundation
import FirebaseVertexAI

class ChatService {
    private let vertex = VertexAI.vertexAI()
    private let model: GenerativeModel
    
    init() {
        self.model = vertex.generativeModel(modelName: "gemini-1.5-flash")
    }
    
    func generateResponse(for productName: String, message: String) async throws -> String {
        let prompt = """
        You are a knowledgeable shopping assistant helping a customer with the product: \(productName).
        
        Provide helpful, concise advice about this product based on the following customer message:
        \(message)
        
        Focus on:
        - Product features and benefits
        - Usage recommendations
        - Value for money
        - Potential alternatives if relevant
        
        Customer message: \(message)
        """
        
        let response = try await model.generateContent(prompt)
        return response.text ?? "I apologize, but I couldn't generate a response at the moment. Please try again."
    }
}
