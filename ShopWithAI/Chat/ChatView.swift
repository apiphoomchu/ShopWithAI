//
//  ChatView.swift
//  ShopWithAI
//
//  Created by Apiphoom Chuenchompoo on 26/10/2567 BE.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(productName: String) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(productName: productName))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            Divider()
            
            VStack(spacing: 8) {
                if !viewModel.messages.isEmpty {
                    HStack {
                        Text("Session-based chat - Messages won't be saved")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                
                HStack(spacing: 12) {
                    TextField("Ask about this product...", text: $viewModel.newMessage)
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.isLoading)
                    
                    Button {
                        Task {
                            await viewModel.sendMessage()
                        }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(viewModel.isLoading || viewModel.newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                    }
                    .disabled(viewModel.isLoading || viewModel.newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .shadow(radius: 2)
        }
        .navigationTitle("AI Shopping Assistant")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil)) {
            Button("OK") {
                viewModel.error = nil
            }
        } message: {
            if let error = viewModel.error {
                Text(error)
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(message.isUser ? Color.blue : Color(.systemGray6))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(20)
                
                Text(message.isUser ? "You" : "AI Assistant")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
            }
            
            if !message.isUser { Spacer() }
        }
    }
}
