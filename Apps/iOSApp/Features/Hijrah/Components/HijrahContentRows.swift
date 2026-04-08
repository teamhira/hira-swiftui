//
//  HijrahContentRows.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

struct ContentBlockRow: View {
    let block: ContentBlock
    let colors: ThemeModel
    
    var body: some View {
        switch block.type {
        case .heading:
            Text(block.value)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(colors.foreground)
        case .body:
            Text(block.value)
                .font(.body)
                .foregroundColor(colors.foreground.opacity(0.8))
                .lineSpacing(6)
        case .arabic:
            Text(block.value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .foregroundColor(colors.foreground)
        case .translation:
            Text(block.value)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .italic()
                .foregroundColor(colors.foreground.opacity(0.6))
                .padding(.top, -10)
        case .image:
            AsyncImage(url: URL(string: block.value)) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Rectangle().fill(colors.foreground.opacity(0.05))
                    .aspectRatio(16/9, contentMode: .fit)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
        case .highlight:
            Text(block.value)
                .font(.body.bold())
                .foregroundColor(colors.primary)
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(colors.primary.opacity(0.1))
                .cornerRadius(16)
        }
    }
}

struct ReferenceRow: View {
    let ref: MissionReference
    let colors: ThemeModel
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(colors.primary.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: ref.icon)
                    .foregroundColor(colors.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ref.title)
                    .font(.subheadline.bold())
                    .foregroundColor(colors.foreground)
                Text(ref.type.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(16)
        .background(colors.foreground.opacity(0.04))
        .cornerRadius(16)
    }
}
