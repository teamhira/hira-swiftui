//
//  SurahListView.swift
//  Hira
//
//  Created by Ryuk on 02/04/26.
//

import SwiftUI

public struct SurahListView: View {
    public init() {}
    
    public var body: some View {
        List(Surah.previewList) { surah in
            NavigationLink(value: AppRoute.surahDetail(surah)) {
                HStack {
                    Text("\(surah.number)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 30)
                    
                    Text(surah.name)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(surah.nameArabic)
                        .font(.title3)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SurahListView()
    }
}
