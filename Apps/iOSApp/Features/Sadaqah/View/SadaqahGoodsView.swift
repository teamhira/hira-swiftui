//
//  SadaqahGoodsView.swift
//  Hira
//
//  Created by Ryuk on 05/04/26.
//

import SwiftUI

public struct SadaqahGoodsView: View {
    @Environment(\.appEnvironment) private var appEnv
    private var colors: ThemeModel { appEnv.theme.current }
    
    public init() {}
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                // Header Banner
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(colors.primary.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "box.truck.fill")
                            .font(.largeTitle.bold())
                            .foregroundColor(colors.primary)
                    }
                    
                    Text(appEnv.language.localizedString("sadaqah_type_physical_title"))
                        .font(.title2.bold())
                        .foregroundColor(colors.foreground)
                        .padding(.top, 4)
                    
                    Text(appEnv.language.localizedString("sadaqah_type_physical_desc"))
                        .font(.subheadline)
                        .foregroundColor(colors.foreground.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                .padding(.horizontal, 24)
                
                // Guidelines Accordion Section
                VStack(alignment: .leading, spacing: 16) {
                    Text(appEnv.language.localizedString("sadaqah_logistics_accordion_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                        .padding(.horizontal, 24)
                    
                    VStack(spacing: 8) {
                        CategoryAccordion(title: appEnv.language.localizedString("sadaqah_logistics_food_title"), 
                                         icon: "fork.knife", 
                                         doText: appEnv.language.localizedString("sadaqah_logistics_food_do"), 
                                         dontText: appEnv.language.localizedString("sadaqah_logistics_food_dont"), 
                                         colors: colors, appEnv: appEnv)
                        
                        CategoryAccordion(title: appEnv.language.localizedString("sadaqah_logistics_textile_title"), 
                                         icon: "tshirt.fill", 
                                         doText: appEnv.language.localizedString("sadaqah_logistics_textile_do"), 
                                         dontText: appEnv.language.localizedString("sadaqah_logistics_textile_dont"), 
                                         colors: colors, appEnv: appEnv)
                        
                        CategoryAccordion(title: appEnv.language.localizedString("sadaqah_logistics_items_title"), 
                                         icon: "shippingbox.fill", 
                                         doText: appEnv.language.localizedString("sadaqah_logistics_items_do"), 
                                         dontText: appEnv.language.localizedString("sadaqah_logistics_items_dont"), 
                                         colors: colors, appEnv: appEnv)
                    }
                    .padding(.horizontal, 24)
                }
                
                // Delivery Steps Section
                VStack(alignment: .leading, spacing: 20) {
                    Text(appEnv.language.localizedString("sadaqah_goods_warehouse_title"))
                        .font(.headline.bold())
                        .foregroundColor(colors.foreground)
                        .padding(.horizontal, 24)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        StepCard(number: 1, textKey: "sadaqah_goods_delivery_step1", colors: colors, appEnv: appEnv)
                        StepCard(number: 2, textKey: "sadaqah_goods_delivery_step2", colors: colors, appEnv: appEnv)
                        StepCard(number: 3, textKey: "sadaqah_goods_delivery_step3", colors: colors, appEnv: appEnv)
                    }
                    .padding(.horizontal, 24)
                }
                
                // Warehouse Address Card
                VStack(alignment: .leading, spacing: 12) {
                    Text(appEnv.language.localizedString("sadaqah_goods_warehouse_address"))
                        .font(.caption.bold())
                        .foregroundColor(colors.primary)
                    
                    Text("TeamHira Logistics Warehouse\nJl. Hijrah Utama No. 45, Kebayoran Baru\nJakarta Selatan, 12160")
                        .font(.system(.subheadline, design: .monospaced))
                        .foregroundColor(colors.foreground.opacity(0.8))
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(colors.background)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .hiraCleanCard(colors: colors, radius: 20)
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(colors.background.ignoresSafeArea())
    }
}

private struct CategoryAccordion: View {
    let title: String
    let icon: String
    let doText: String
    let dontText: String
    let colors: ThemeModel
    let appEnv: AppEnvironment
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            Button(action: { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { isExpanded.toggle() } }) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.headline)
                        .foregroundColor(colors.primary)
                        .frame(width: 32)
                    
                    Text(title)
                        .font(.subheadline.bold())
                        .foregroundColor(colors.foreground)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(colors.foreground.opacity(0.2))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(isExpanded ? colors.primary.opacity(0.04) : colors.background)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appEnv.language.localizedString("common_do_label"))
                            .font(.caption2.bold())
                            .foregroundColor(.green)
                        Text(doText)
                            .font(.caption)
                            .foregroundColor(colors.foreground.opacity(0.7))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appEnv.language.localizedString("common_dont_label"))
                            .font(.caption2.bold())
                            .foregroundColor(.red)
                        Text(dontText)
                            .font(.caption)
                            .foregroundColor(colors.foreground.opacity(0.7))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .hiraCleanCard(colors: colors, radius: 20)
    }
}

private struct StepCard: View {
    let number: Int
    let textKey: String
    let colors: ThemeModel
    let appEnv: AppEnvironment
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.headline.bold())
                .foregroundColor(colors.primary)
                .frame(width: 32, height: 32)
                .background(colors.primary.opacity(0.1))
                .clipShape(Circle())
            
            Text(appEnv.language.localizedString(textKey))
                .font(.subheadline)
                .foregroundColor(colors.foreground.opacity(0.7))
                .lineSpacing(4)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .hiraCleanCard(colors: colors, radius: 20)
    }
}
