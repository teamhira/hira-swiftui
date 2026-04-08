//
//  SadaqahSubuhView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

public struct SadaqahSubuhView: View {
    @Environment(\.appEnvironment) private var appEnv
    @State private var viewModel = SadaqahViewModel()
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header Image/Icon
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(colors.primary.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "sun.max.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(colors.primary)
                    }
                    
                    Text(appEnv.language.localizedString("sadaqah_type_subuh_title"))
                        .font(.title2.bold())
                        .foregroundColor(colors.foreground)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                
                // Description Section
                VStack(alignment: .leading, spacing: 12) {
                    Text(appEnv.language.localizedString("sadaqah_subuh_desc"))
                        .font(.body)
                        .foregroundColor(colors.foreground.opacity(0.7))
                        .lineSpacing(4)
                    
                    Text(appEnv.language.localizedString("sadaqah_subuh_commitment"))
                        .font(.subheadline.italic())
                        .foregroundColor(colors.primary)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                
                // Program Activation Toggle
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(appEnv.language.localizedString("sadaqah_subuh_toggle"))
                                .font(.headline.bold())
                                .foregroundColor(colors.foreground)
                            Text(appEnv.language.localizedString("sadaqah_subuh_notification"))
                                .font(.caption)
                                .foregroundColor(colors.foreground.opacity(0.4))
                        }
                        Spacer()
                        Toggle("", isOn: $viewModel.isSubuhProgramActive)
                            .tint(colors.primary)
                            .labelsHidden()
                    }
                    .padding(20)
                    .background(colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .hiraCleanCard(colors: colors, radius: 20)
                    
                    if viewModel.isSubuhProgramActive {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(appEnv.language.localizedString("sadaqah_subuh_guidance"))
                                .font(.caption.bold())
                                .foregroundColor(colors.primary)
                            
                            HStack {
                                Image(systemName: "book.pages.fill")
                                    .font(.caption2)
                                Text(appEnv.language.localizedString("sadaqah_subuh_kajian"))
                                    .font(.caption)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption2)
                            }
                            .foregroundColor(colors.foreground.opacity(0.6))
                            .padding(.top, 8)
                        }
                        .padding(20)
                        .background(colors.primary.opacity(0.05))
                        .cornerRadius(20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.spring(), value: viewModel.isSubuhProgramActive)
                .padding(.horizontal, 24)
                
                // Donate Button
                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "creditcard.fill")
                        Text(appEnv.language.localizedString("sadaqah_donate_gateway_btn"))
                    }
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(colors.primary)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(colors.background.ignoresSafeArea())
    }
}
