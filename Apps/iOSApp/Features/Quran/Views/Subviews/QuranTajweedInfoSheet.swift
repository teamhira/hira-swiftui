//
//  QuranTajweedInfoSheet.swift
//  Hira
//
//  Created by Ryuk on 11/04/26.
//

import SwiftUI

public struct QuranTajweedInfoSheet: View {
    @Environment(\.appEnvironment) private var appEnv
    @Environment(\.dismiss) private var dismiss
    
    // Accordion state - keeping track of which section is expanded
    @State private var expandedRule: TajweedRenderer.TajweedRule? = nil
    
    private let rules: [TajweedRenderer.TajweedRule] = [
        .ham_wasl, .laam_shamsiyah, .madda_normal, .madda_permissible, 
        .madda_necessary, .madda_obligatory, .ghunnah, .ikhfa, 
        .ikhfa_shafawi, .idgham_with_ghunnah, .idgham_without_ghunnah, 
        .idgham_mutajanisayn, .idgham_mutaqaribayn, .idgham_shafawi, 
        .qalqalah, .iqlab
    ]
    
    public var body: some View {
        let colors = appEnv.theme.current
        
        NavigationStack {
            ZStack {
                colors.background.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        headerView
                        
                        VStack(spacing: 12) {
                            ForEach(rules, id: \.rawValue) { rule in
                                TajweedAccordionRow(
                                    rule: rule, 
                                    isExpanded: expandedRule == rule,
                                    colors: colors
                                ) {
                                    withAnimation(.spring()) {
                                        if expandedRule == rule {
                                            expandedRule = nil
                                        } else {
                                            expandedRule = rule
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Tajweed Rules")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(colors.foreground.opacity(0.6))
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        let colors = appEnv.theme.current
        return VStack(spacing: 12) {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 40))
                .foregroundColor(colors.primary)
            
            Text("Color Coded Tajweed")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(colors.foreground)
            
            Text("Learn the rules of Quran recitation through intuitive color coding.")
                .font(.system(size: 14))
                .foregroundColor(colors.foreground.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 20)
    }
}

struct TajweedAccordionRow: View {
    let rule: TajweedRenderer.TajweedRule
    let isExpanded: Bool
    let colors: ThemeModel
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: 16) {
                    Circle()
                        .fill(rule.color)
                        .frame(width: 12, height: 12)
                        .shadow(color: rule.color.opacity(0.3), radius: 2)
                    
                    Text(rule.displayName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(colors.foreground)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(colors.foreground.opacity(0.2))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(16)
                .background(colors.foreground.opacity(0.03))
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider().opacity(0.1)
                    
                    Text(rule.description)
                        .font(.system(size: 14))
                        .foregroundColor(colors.foreground.opacity(0.8))
                        .lineSpacing(4)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example:")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(colors.primary)
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(rule.exampleArabic)
                                .font(.custom("KFGQPC Uthman Taha Naskh", size: 30))
                                .foregroundColor(colors.foreground)
                                .multilineTextAlignment(.trailing)
                            
                            Text(rule.exampleLatin)
                                .font(.system(size: 13, weight: .medium, design: .serif))
                                .foregroundColor(colors.primary.opacity(0.6))
                                .italic()
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(16)
                        .background(colors.primary.opacity(0.05))
                        .cornerRadius(16)
                    }
                }
                .padding(16)
                .background(colors.foreground.opacity(0.01))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isExpanded ? colors.primary.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }
}

extension TajweedRenderer.TajweedRule {
    var displayName: String {
        switch self {
        case .ham_wasl: return "Hamzatul Wasl"
        case .laam_shamsiyah: return "Al-Laam Ash-Shamsiyah"
        case .madda_normal: return "Al-Madd At-Tabi'i"
        case .madda_permissible, .madda_permissable: return "Al-Madd Al-Ja'iz Al-Munfasil"
        case .madda_necessary: return "Al-Madd Al-Lazim"
        case .madda_obligatory: return "Al-Madd Al-Wajib Al-Muttasil"
        case .ghunnah: return "Al-Ghunnah"
        case .ikhfa: return "Al-Ikhfa Al-Haqiqi"
        case .ikhfa_shafawi: return "Al-Ikhfa Ash-Shafawi"
        case .idgham_with_ghunnah: return "Idgham Ma'al Ghunnah"
        case .idgham_without_ghunnah: return "Idgham Bila Ghunnah"
        case .idgham_mutajanisayn: return "Idgham Al-Mutajanisayn"
        case .idgham_mutaqaribayn: return "Idgham Al-Mutaqaribayn"
        case .idgham_shafawi: return "Idgham Ash-Shafawi (Mithlayn)"
        case .qalqalah: return "Al-Qalqalah"
        case .iqlab: return "Al-Iqlab"
        }
    }
    
    var description: String {
        switch self {
        case .ham_wasl:
            return "Hamzatul Wasl (Connecting Hamza) is a temporary Hamza found at the beginning of a word. It is only pronounced when you start your recitation from that word. If it occurs in the middle of connected speech, it is skipped entirely. In Mushaf, it is identified by a small 'Saad' (ص) over the Alif."
        case .laam_shamsiyah:
            return "The 'Laam' of the definite article (Al-) becomes silent when followed by one of the 14 Sun Letters (t, th, d, dh, r, z, s, sh, s, d, t, z, l, n). Instead of pronouncing the 'L', you emphasize the following letter with a Shaddah."
        case .madda_normal:
            return "The natural prolongation of a vowel (Alif, Waw, or Ya) for exactly two beats (counts). It occurs when a Madd letter is not followed by a Hamza or a Sukun."
        case .madda_permissible, .madda_permissable:
            return "This occurs when the Madd letter (Alif, Waw, or Ya) is at the end of one word and a Hamza appears at the beginning of the very next word. It can be elongated for 2, 4, or 5 beats (counts) depending on the recitation style."
        case .madda_necessary:
            return "The most powerful prolongation in Tajweed, requiring a full 6 beats (counts). It occurs when a Madd letter is followed by a permanent Sukun or a Shaddah within the same word."
        case .madda_obligatory:
            return "Mandatory prolongation for 4 or 5 beats (counts). It occurs when a Madd letter and a Hamza are found together within the same single word."
        case .ghunnah:
            return "A nasal sound produced entirely from the nasal cavity. It is an obligatory characteristic of the letters Noon (ن) and Meem (م) whenever they carry a Shaddah (ّ). The duration is held for 2 beats."
        case .ikhfa:
            return "A 'hiding' or 'shrouding' sound. It occurs when Noon Sakinah (نْ) or Tanween is followed by any of the 15 specific letters. The sound is pronounced halfway between a clear Noon and a complete merger, accompanied by a nasal Ghunnah for 2 beats."
        case .ikhfa_shafawi:
            return "Oral Hiding: When a Meem Sakinah (مْ) is followed immediately by the letter Ba (ب). The Meem sound is softened and 'hidden' with a 2-beat nasal Ghunnah."
        case .idgham_with_ghunnah:
            return "Merging with Nasalization: When Noon Sakinah (نْ) or Tanween is followed by one of the four letters in 'Yanmu' (ي , ن , م , و). The Noon sound merges completely into the following letter with a 2-beat nasal Ghunnah."
        case .idgham_without_ghunnah:
            return "Merging without Nasalization: When Noon Sakinah (نْ) or Tanween is followed by the letters Laam (ل) or Ra (ر). The Noon merges completely without any nasal sound."
        case .idgham_mutajanisayn:
            return "Homogeneous Merging: Occurs between two letters that share the same point of articulation (Makhraj) but differ in characteristics (like T and D, or TH and DH). The first letter merges into the second."
        case .idgham_mutaqaribayn:
            return "Approximate Merging: Occurs between two letters whose points of articulation or characteristics are very close to one another (like Q and K, or L and R)."
        case .idgham_shafawi:
            return "Oral Merging: Also known as Idgham Mithlayn. It occurs when a Meem Sakinah (مْ) is followed by another Meem. The two merge into one emphasized Meem with a 2-beat Ghunnah."
        case .qalqalah:
            return "The 'Echo' or 'Bouncing' sound. It occurs when one of the five letters of 'Qutub Jadin' (ق, ط, ب, ج, د) appears with a Sukun (ْ). The articulation point is released quickly to create a sharp, resonant echo."
        case .iqlab:
            return "Conversion: When a Noon Sakinah (نْ) or Tanween is followed by the letter Ba (ب). The Noon sound is converted into a Meem (م) sound, accompanied by a 2-beat Ghunnah."
        }
    }
    
    private func colored(_ text: String, target: String) -> AttributedString {
        var attr = AttributedString(text)
        if let range = attr.range(of: target) {
            attr[range].foregroundColor = self.color
        }
        return attr
    }
    
    var exampleArabic: AttributedString {
        switch self {
        case .ham_wasl: return colored("ٱهْدِنَا ٱلصِّرَٰطَ", target: "ٱهْدِنَا")
        case .laam_shamsiyah: return colored("وَٱلشَّمْسِ وَضُحَىٰهَا", target: "ٱلشَّمْسِ")
        case .madda_normal: return colored("قَالَ لَهُۥ صَاحِبُهُۥ", target: "قَالَ")
        case .madda_permissible, .madda_permissable: return colored("بِمَآ أُنزِلَ إِلَيْكَ", target: "بِمَآ")
        case .madda_necessary: return colored("وَلَا ٱلضَّآلِّينَ", target: "ٱلضَّآلِّينَ")
        case .madda_obligatory: return colored("إِذَا جَآءَ نَصْرُ ٱللَّهِ", target: "جَآءَ")
        case .ghunnah: return colored("مِنَ ٱلْجِنَّةِ وَٱلنَّاسِ", target: "ٱلْجِنَّةِ")
        case .ikhfa: return colored("مِن صَلْصَٰلٍ كَٱلْفَخَّارِ", target: "مِن صَلْصَٰلٍ")
        case .ikhfa_shafawi: return colored("تَرْمِيهِم بِحِجَارَةٍ", target: "تَرْمِيهِم بِ")
        case .idgham_with_ghunnah: return colored("مَن يَقُولُ ءَامَنَّا", target: "مَن يَقُولُ")
        case .idgham_without_ghunnah: return colored("مِّن رَّبِّهِمْ هُدًى", target: "مِّن رَّبِّهِمْ")
        case .idgham_mutajanisayn: return colored("قَالَت طَّآئِفَةٌ", target: "قَالَت طَّ")
        case .idgham_mutaqaribayn: return colored("أَلَمْ نَخْلُقكُّم", target: "نَخْلُقكُّم")
        case .idgham_shafawi: return colored("لَهُم مَّا يَشَآءُونَ", target: "لَهُم مَّا")
        case .qalqalah: return colored("قُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ", target: "ٱلْفَلَقِ")
        case .iqlab: return colored("مِنۢ بَعْدِ مَاجَآءَتْهُمُ", target: "مِنۢ بَعْدِ")
        }
    }
    
    var exampleLatin: String {
        switch self {
        case .ham_wasl: return "Ihdinaṣ-ṣirāṭ"
        case .laam_shamsiyah: return "Wash-shamsi wa duḥāhā"
        case .madda_normal: return "Qāla lahū ṣāḥibuhū"
        case .madda_permissible, .madda_permissable: return "Bimā unzila ilayk"
        case .madda_necessary: return "Waladh-ḍāllīn"
        case .madda_obligatory: return "Idhā jā'a naṣrullāh"
        case .ghunnah: return "Minal-jinnati wan-nās"
        case .ikhfa: return "Min ṣalṣālin kal-fakhkhār"
        case .ikhfa_shafawi: return "Tarmīhim bi-ḥijāratin"
        case .idgham_with_ghunnah: return "May-yaqūlu āmannā"
        case .idgham_without_ghunnah: return "Mir-rabbihim hudan"
        case .idgham_mutajanisayn: return "Qālat-ṭā'ifatun"
        case .idgham_mutaqaribayn: return "Alam nakhlukkum"
        case .idgham_shafawi: return "Lahum-mā yasha'ūn"
        case .qalqalah: return "Qul a'ūdhu birabbil-falaq"
        case .iqlab: return "Mim-ba'di mā jā'athum"
        }
    }
}
