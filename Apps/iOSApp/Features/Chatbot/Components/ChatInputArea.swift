//
//  ChatInputArea.swift
//  Hira
//
//  Created by Ryuk on 25/04/26.
//

import SwiftUI

struct ChatInputArea: View {
    @Binding var text: String
    let colors: ThemeModel
    let onSend: () -> Void
    @Environment(\.appEnvironment) private var appEnv
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(colors.foreground.opacity(0.1))
            
            HStack(spacing: 12) {
                // Command Menu Suggestion
                Button(action: { text = "/" }) {
                    Image(systemName: "command")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(colors.primary)
                        .frame(width: 44, height: 44)
                        .background(colors.primary.opacity(0.1))
                        .clipShape(Circle())
                }
                
                TextField(appEnv.language.localizedString("chatbot_input_placeholder"), text: $text)
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .background(colors.foreground.opacity(0.04))
                    .cornerRadius(25)
                    .font(TextStyle.body)
                    .onSubmit(onSend)
                
                Button(action: onSend) {
                    ZStack {
                        Circle()
                            .fill(text.isEmpty ? colors.foreground.opacity(0.1) : colors.primary)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(colors.background)
            
            // Command Hint
            if text.isEmpty {
                Text(appEnv.language.localizedString("chatbot_command_hint"))
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.foreground.opacity(0.3))
                    .padding(.bottom, 8)
            }
        }
    }
}
