//
//  HalalScannerView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

/// Mode for the scanner view.
public enum HalalScannerMode {
    case barcode
    case capture
}

/// A flexible scanner and capture view for the Halal Finder feature.
public struct HalalScannerView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appEnvironment) private var appEnv
    @Bindable var viewModel: HalalViewModel
    public let mode: HalalScannerMode
    
    // UI State
    @State private var showResultSheet: Bool = false
    
    // MARK: - Computed Properties
    private var colors: ThemeModel { appEnv.theme.current }
    
    // MARK: - Body
    public var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Live Camera Preview
                if viewModel.capturedImage == nil {
                    CameraPreview(viewModel: viewModel)
                        .ignoresSafeArea()
                } else {
                    if let capturedImage = viewModel.capturedImage {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .ignoresSafeArea()
                    }
                }
                
                // MARK: - Inverse Masking Layer (Darkens outside viewfinder)
                Color.black.opacity(0.5).ignoresSafeArea()
                    .reverseMask {
                        RoundedRectangle(cornerRadius: 32)
                            .frame(width: 280, height: 280)
                    }
                
                // MARK: - Viewfinder Brackets & Animation
                ZStack {
                    // Corner Brackets
                    VStack {
                        HStack { bracketCorner; Spacer(); bracketCorner.rotationEffect(.degrees(90)) }
                        Spacer()
                        HStack { bracketCorner.rotationEffect(.degrees(-90)); Spacer(); bracketCorner.rotationEffect(.degrees(180)) }
                    }
                    .frame(width: 290, height: 290)
                    
                    // Scanning Bar (Barcode Mode)
                    if mode == .barcode && viewModel.capturedImage == nil {
                        scanningBar
                    }
                }
                .frame(width: 280, height: 280)
                
                // MARK: - UI Overlays (Error & Results)
                if let error = viewModel.searchErrorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.headline)
                        
                        Button(action: { viewModel.resetCapture() }) {
                            Text("Try Again")
                                .font(.subheadline.bold())
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(colors.primary)
                                .foregroundColor(.white)
                                .cornerRadius(24)
                        }
                    }
                    .padding(32)
                    .background(Color.black.opacity(0.85))
                    .cornerRadius(32)
                    .padding(32)
                }
                
                // MARK: - Action Controls
                VStack {
                    Spacer()
                    if mode == .capture {
                        captureActionControls
                    } else {
                        Text("Hold camera steady over barcode")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(20)
                    }
                }
                .padding(.bottom, 60)
            }
            .navigationTitle(mode == .barcode ? "Scan Barcode" : "Identify Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.white)
                    }
                }
            }
            .onAppear { 
                viewModel.resetCapture()
                withAnimation { viewModel.isScanning = true }
            }
            .sheet(item: $viewModel.foundFoodProduct) { food in
                NavigationStack {
                    HalalFoodDetailView(food: food)
                }
            }
        }
    }
    
    // MARK: - Specialized Components
    
    private var bracketCorner: some View {
        ZStack(alignment: .topLeading) {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 30))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 30, y: 0))
            }
            .stroke(colors.primary, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
        }
        .frame(width: 30, height: 30)
    }
    
    private var scanningBar: some View {
        GeometryReader { geo in
            ZStack {
                // Main Glow
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [colors.primary.opacity(0), colors.primary, colors.primary.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .blur(radius: 2)
                
                // Bright Core
                Rectangle()
                    .fill(Color.white)
                    .frame(height: 1)
                    .shadow(color: colors.primary, radius: 4, x: 0, y: 0)
            }
            .offset(y: viewModel.isScanning ? geo.size.height : 0)
            .animation(
                .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                value: viewModel.isScanning
            )
        }
    }
    
    private var captureActionControls: some View {
        Group {
            if viewModel.isSearchingFood {
                HStack(spacing: 12) {
                    ProgressView()
                        .tint(.white)
                    Text("Analyzing...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(Color.black.opacity(0.8))
                .cornerRadius(40)
            } else {
                Button(action: {
                    if viewModel.capturedImage == nil {
                        viewModel.capturedImage = UIImage(systemName: "camera.fill") // Placeholder capture
                    } else {
                        viewModel.searchCapturedProduct()
                    }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: viewModel.capturedImage == nil ? "camera.circle.fill" : "sparkles")
                            .font(.system(size: 80))
                        Text(viewModel.capturedImage == nil ? "Capture" : "Find Halal")
                            .font(.caption.bold())
                    }
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - Extension for Inverse Masking
extension View {
    func reverseMask<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        self.mask {
            ZStack {
                Rectangle()
                content()
                    .blendMode(.destinationOut)
            }
        }
    }
}
