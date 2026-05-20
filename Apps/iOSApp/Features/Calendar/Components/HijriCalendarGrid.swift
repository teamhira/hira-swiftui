//
//  HijriCalendarGrid.swift
//  Hira
//
//  Created by Ryuk on 24/04/26.
//

import SwiftUI

struct HijriCalendarGrid: View {
    let days: [HijriCalendarDay]
    let colors: ThemeModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            // Week Header
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
            }
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(days) { day in
                    CalendarDayCell(day: day, colors: colors)
                }
            }
        }
        .padding(AppSpacing.sm)

        .background(colors.card)
        .cornerRadius(20)
        .shadow(color: AppShadow.xs.color, radius: AppShadow.xs.radius, x: AppShadow.xs.x, y: AppShadow.xs.y)
    }
}

struct CalendarDayCell: View {
    let day: HijriCalendarDay
    let colors: ThemeModel
    
    var body: some View {
        VStack(spacing: 2) {
            if day.hijriDay > 0 {
                ZStack {
                    if day.isToday {
                        Circle()
                            .fill(colors.primary)
                            .frame(width: 32, height: 32)
                    } else if day.event != nil {
                        Circle()
                            .fill(colors.primary.opacity(0.1))
                            .frame(width: 32, height: 32)
                    }
                    
                    Text("\(day.hijriDay)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(day.isToday ? .white : (day.event != nil ? colors.primary : colors.foreground))
                }
                
                if let gDate = day.gregorianDate {
                    Text("\(Calendar.current.component(.day, from: gDate))")
                        .font(.system(size: 9))
                        .foregroundColor(colors.foreground.opacity(0.4))
                }
            } else {
                Text("")
                    .frame(height: 40)
            }
        }
        .frame(height: 44)
    }
}
