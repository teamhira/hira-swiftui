//
//  HijriEventRow.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct HijriEventRow: View {
    let event: UmmahIslamicEvent
    let colors: ThemeModel
    @Environment(\.appEnvironment) private var appEnv
    
    @State private var isAdded: Bool = false
    @State private var showConfirm: Bool = false
    @State private var showPermissionAlert: Bool = false
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(colors.primary.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                VStack(spacing: 0) {
                    Text(event.hijriDate.split(separator: " ").first ?? "")
                        .font(.system(size: 16, weight: .black))
                        .foregroundColor(colors.primary)
                    Text(appEnv.language.localizedString("calendar_hijri_abbr"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(colors.primary.opacity(0.6))
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title)
                    .font(TextStyle.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(colors.foreground)
                
                Text(event.description)
                    .font(TextStyle.caption)
                    .foregroundColor(colors.foreground.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                Button(action: { 
                    if !isAdded {
                        showConfirm = true 
                    }
                }) {
                    Image(systemName: isAdded ? "calendar.badge.check" : "calendar.badge.plus")
                        .font(.system(size: 16))
                        .foregroundColor(isAdded ? Color.green : colors.primary)
                }
                .buttonStyle(.plain)
                .disabled(isAdded)
                
                Text(event.gregorianDate)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(colors.foreground.opacity(0.4))
            }
        }
        .padding(AppSpacing.md)
        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
        .onAppear {
            checkExistence()
        }
        .alert(appEnv.language.localizedString("calendar_add_confirm_title"), isPresented: $showConfirm) {
            Button(appEnv.language.localizedString("common_cancel"), role: .cancel) { }
            Button(appEnv.language.localizedString("common_add")) {
                addToCalendar()
            }
        } message: {
            Text(appEnv.language.localizedString("calendar_add_confirm_message", arguments: [event.title]))
        }
        .alert(appEnv.language.localizedString("calendar_permission_denied_title"), isPresented: $showPermissionAlert) {
            Button(appEnv.language.localizedString("common_close"), role: .cancel) { }
            Button(appEnv.language.localizedString("background_refresh_alert_settings")) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text(appEnv.language.localizedString("calendar_permission_denied_message"))
        }
    }
    
    private func checkExistence() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: event.gregorianDate) else { return }
        
        Task {
            let exists = await SystemCalendarService.shared.checkEventExists(title: event.title, date: date)
            await MainActor.run {
                self.isAdded = exists
            }
        }
    }
    
    private func addToCalendar() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: event.gregorianDate) else { return }
        
        Task {
            let result = await SystemCalendarService.shared.addEvent(
                title: event.title,
                description: event.description,
                date: date
            )
            
            await MainActor.run {
                switch result {
                case .success:
                    self.isAdded = true
                    print("Successfully added to calendar")
                case .failure(let error):
                    if (error as NSError).code == 403 {
                        self.showPermissionAlert = true
                    }
                    print("Error adding to calendar: \(error)")
                }
            }
        }
    }
}


