//
//  SurahInfoSheet.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI
import WebKit

struct SurahInfoSheet: View {
    let surah: Surah
    let info: SurahInfo?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var webViewHeight: CGFloat = 800
    @State private var isWebViewLoaded = false
    
    var body: some View {
        let colors = appEnv.theme.current
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        // MARK: - Sub-Header (Quick Info)
                        HStack(spacing: 12) {
                            badgeView(text: surah.revelationPlace.capitalized, icon: "mappin.and.ellipse", colors: colors)
                            badgeView(text: "\(surah.versesCount) Verses", icon: "text.alignleft", colors: colors)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        .padding(.bottom, 24)
                        
                        Divider()
                            .background(colors.primary.opacity(0.1))
                            .padding(.horizontal, 24)
                        
                        // MARK: - Content Section
                        if let info = info {
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Athmospheric Context & Theme")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(colors.primary)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 24)
                                
                                ZStack {
                                    HTMLContentView(
                                        html: info.text ?? "", 
                                        height: $webViewHeight, 
                                        isLoaded: $isWebViewLoaded
                                    )
                                    .frame(height: webViewHeight)
                                    .padding(.horizontal, 16)
                                    .opacity(isWebViewLoaded ? 1 : 0)
                                    
                                    if !isWebViewLoaded {
                                        contentSkeleton(colors: colors)
                                            .padding(.horizontal, 24)
                                    }
                                }
                                
                                if let source = info.source {
                                    HStack {
                                        Spacer()
                                        Text("Source: \(source)")
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(colors.foreground.opacity(0.3))
                                            .italic()
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.top, 20)
                                }
                            }
                            .padding(.bottom, 60)
                        } else {
                            contentSkeleton(colors: colors)
                                .padding(24)
                        }
                    }
                }
            }
            .navigationTitle(surah.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .fontWeight(.semibold)
                        .foregroundColor(colors.primary)
                }
            }
        }
    }
    
    private func badgeView(text: String, icon: String, colors: ThemeModel) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .bold))
            Text(text)
                .font(.system(size: 12, weight: .bold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(colors.primary.opacity(0.08))
        .foregroundColor(colors.primary)
        .clipShape(Capsule())
    }
    
    @ViewBuilder
    private func contentSkeleton(colors: ThemeModel) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(0..<8) { _ in
                VStack(alignment: .leading, spacing: 8) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(colors.foreground.opacity(0.04))
                        .frame(maxWidth: .infinity)
                        .frame(height: 14)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(colors.foreground.opacity(0.03))
                        .frame(width: CGFloat.random(in: 200...300), height: 14)
                }
            }
        }
        .redacted(reason: .placeholder)
    }
}

// MARK: - HTML Content Wrapper with Auto-Height & Ready Signal
struct HTMLContentView: UIViewRepresentable {
    let html: String
    @Binding var height: CGFloat
    @Binding var isLoaded: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let header = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'>
            <style>
                :root { color-scheme: light dark; }
                body { 
                    font-family: -apple-system, system-ui, sans-serif; 
                    font-size: 17px; 
                    line-height: 1.8; 
                    color: #1a1a1a;
                    background-color: transparent !important;
                    padding: 0;
                    margin: 0;
                }
                p { margin-bottom: 24px; text-align: justify; }
                @media (prefers-color-scheme: dark) {
                    body { color: #e1e1e1; }
                }
            </style>
        </head>
        <body>
            <div id="content_wrapper">\(html)</div>
        </body>
        </html>
        """
        uiView.loadHTMLString(header, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: HTMLContentView
        init(_ parent: HTMLContentView) { self.parent = parent }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                webView.evaluateJavaScript("document.getElementById('content_wrapper').offsetHeight") { (result, error) in
                    if let height = result as? CGFloat {
                        withAnimation(.spring()) {
                            self.parent.height = height + 40
                            self.parent.isLoaded = true
                        }
                    }
                }
            }
        }
    }
}


