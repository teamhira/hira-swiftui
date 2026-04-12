//
//  HijrahMocks.swift
//  Hira
//
//  Created by Ryuk on 08/04/26.
//

import Foundation

public struct HijrahMockData {
    
    // MARK: - Achievements
    public static let achievements: [Achievement] = [
        Achievement(id: 1, icon: "door.left.hand.open", title: "Langkah Pertama", description: "Memulai perjalanan", category: "starter", xp: 10, types: [.mualaf, .hijrah], order: 1),
        Achievement(id: 2, icon: "heart.fill", title: "Niat Baik", description: "Menyelesaikan onboarding", category: "starter", xp: 10, types: [.mualaf, .hijrah], order: 2),
        Achievement(id: 3, icon: "calendar.day.timeline.left", title: "Hari Pertama", description: "Menyelesaikan Day 1", category: "starter", xp: 15, types: [.mualaf, .hijrah], order: 3),
        Achievement(id: 4, icon: "person.2.fill", title: "Tidak Sendiri", description: "Login 2 hari berturut", category: "starter", xp: 10, types: [.mualaf, .hijrah], order: 4),
        Achievement(id: 5, icon: "sparkles", title: "Berani Mulai", description: "Kembali di hari ke-2", category: "starter", xp: 10, types: [.mualaf, .hijrah], order: 5),
        Achievement(id: 6, icon: "checklist", title: "Komitmen Awal", description: "Menyelesaikan 3 hari", category: "starter", xp: 15, types: [.mualaf, .hijrah], order: 6),
        Achievement(id: 7, icon: "chart.line.uptrend.xyaxis", title: "Awal yang Baik", description: "Menyelesaikan 5 hari", category: "starter", xp: 20, types: [.mualaf, .hijrah], order: 7),
        Achievement(id: 8, icon: "flame.fill", title: "Konsisten Awal", description: "7 hari streak", category: "starter", xp: 25, types: [.mualaf, .hijrah], order: 8),
        Achievement(id: 21, icon: "sparkle", title: "Takbir Pertama", description: "Shalat pertama", category: "shalat", xp: 15, types: [.mualaf], order: 21),
        Achievement(id: 22, icon: "book.fill", title: "Belajar Shalat", description: "Menyelesaikan tutorial shalat", category: "shalat", xp: 20, types: [.mualaf], order: 22),
        Achievement(id: 24, icon: "clock.badge.checkmark", title: "Satu Waktu", description: "Shalat 1 waktu tepat", category: "shalat", xp: 10, types: [.mualaf, .hijrah], order: 24)
    ]
    
    // MARK: - Suggestions
    public static let suggestions: [Suggestion] = [
        Suggestion(
            key: "s_daily_dzikir",
            title: "Dzikir & Relaksasi Hati",
            description: "Panduan zikir harian untuk menjaga ketenangan jiwa di tengah aktivitas.",
            icon: "leaf.fill",
            targetJourneys: [.mualaf, .hijrah, .better],
            modules: [
                SuggestionModule(
                    title: "Pentingnya Mengingat Allah",
                    description: "Hati akan menjadi tenang hanya dengan mengingat-Nya.",
                    content: [
                        ContentBlock(type: .heading, value: "Ketenangan Jiwa"),
                        ContentBlock(type: .body, value: "Dalam Al-Quran disebutkan bahwa hanya dengan mengingat Allah hati menjadi tenteram. Dzikir bukan sekadar ucapan lisan."),
                        ContentBlock(type: .highlight, value: "Ingatlah Aku, maka Aku akan mengingatmu.")
                    ]
                )
            ]
        ),
        Suggestion(
            key: "s_halal_guide",
            title: "Gaya Hidup Halal",
            description: "Belajar membedakan yang haq dan yang bathil dalam konsumsi sehari-hari.",
            icon: "checkmark.shield.fill",
            targetJourneys: [.mualaf, .hijrah],
            modules: [
                SuggestionModule(
                    title: "Mengenal Halal & Thayyib",
                    content: [
                        ContentBlock(type: .heading, value: "Bukan Sekadar Tidak Babi"),
                        ContentBlock(type: .body, value: "Halal mencakup cara perolehan dan zatnya. Thayyib berarti baik dan bergizi bagi tubuh.")
                    ]
                )
            ]
        )
    ]
    
    // MARK: - Mualaf Missions
    public static let mualafMissions: [Mission] = [
        Mission(
            key: "m_d1_1",
            title: "Mengenal Syahadat",
            description: "Memahami makna dua kalimat syahadat sebagai pintu masuk Islam.",
            type: .knowledge,
            content: [
                ContentBlock(type: .heading, value: "Pernyataan Tauhid"),
                ContentBlock(type: .arabic, value: "أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا رَسُولُ اللهِ"),
                ContentBlock(type: .translation, value: "Aku bersaksi bahwa tidak ada Tuhan selain Allah dan aku bersaksi bahwa Muhammad adalah utusan Allah.")
            ],
            expReward: 50,
            order: 1
        ),
        Mission(
            key: "m_d1_2",
            title: "Belajar Wudhu Dasar",
            description: "Tonton video tutorial cara bersuci sebelum mendirikan shalat.",
            type: .video,
            media: MissionMedia(url: "https://www.youtube.com/watch?v=tutorial_wudhu", isYoutube: true),
            expReward: 60,
            order: 2
        ),
        Mission(
            key: "m_d1_3",
            title: "Kuis: Rukun Islam",
            description: "Uji pengetahuan dasar tentang lima pilar Islam.",
            type: .quiz,
            quiz: MissionQuiz(
                question: "Berapakah jumlah Rukun Islam?",
                options: [
                    QuizOption(text: "4 Perkara", isCorrect: false),
                    QuizOption(text: "5 Perkara", isCorrect: true),
                    QuizOption(text: "6 Perkara", isCorrect: false)
                ],
                explanation: "Rukun Islam ada 5: Syahadat, Shalat, Zakat, Puasa, dan Haji."
            ),
            expReward: 40,
            order: 3
        )
    ]
    
    // MARK: - Hijrah Missions
    public static let hijrahMissions: [Mission] = [
        Mission(
            key: "h_d1_1",
            title: "Aurat & Pakaian",
            description: "Memahami batasan aurat bagi laki-laki dan perempuan sebagai tanda ketaatan.",
            type: .knowledge,
            content: [
                ContentBlock(type: .heading, value: "Aurat Seorang Muslim"),
                ContentBlock(type: .body, value: "Menutup aurat bukan sekadar tren busana, melainkan perintah Allah SWT untuk menjaga kehormatan dan kesucian diri.")
            ],
            references: [MissionReference(title: "Adab Berpakaian", icon: "tshirt.fill", targetId: "adab_pakaian_guide", type: .guide)],
            expReward: 45,
            order: 1
        ),
        Mission(
            key: "h_d1_2",
            title: "Fokus: Tadabbur Alfatiha",
            description: "Luangkan waktu sejenak untuk benar-benar merenungkan makna Al-Fatiha dalam ketenangan.",
            type: .timer,
            timer: MissionTimer(targetSeconds: 180, label: "Meresapi Alfatiha (3 Menit)"),
            expReward: 70,
            order: 2
        ),
        Mission(
            key: "h_d1_3",
            title: "Dzikir Istighfar 100x",
            description: "Mohon ampunan Allah untuk kejernihan hati.",
            type: .tasbih,
            targetCount: 100,
            expReward: 50,
            order: 3
        ),
        Mission(
            key: "h_d1_4",
            title: "Bimbingan: Meninggalkan Maksiat",
            description: "Tontonlah video nasehat singkat tentang hijrah dari kebiasaan buruk.",
            type: .video,
            media: MissionMedia(url: "https://www.youtube.com/watch?v=hijrah1", isYoutube: true),
            expReward: 60,
            order: 4
        ),
        Mission(
            key: "h_d1_5",
            title: "Langkah Nyata: Bersihkan Lingkungan",
            description: "Hapus aplikasi atau sembunyikan pemicu yang sering membuatmu lalai beribadah.",
            type: .simple,
            expReward: 40,
            order: 5
        ),
        Mission(
            key: "h_d1_6",
            title: "Kuis: Rukun Iman",
            description: "Uji pengetahuan Anda tentang 6 perkara yang harus diyakini.",
            type: .quiz,
            quiz: MissionQuiz(
                question: "Manakah yang merupakan rukun iman yang ke-5?",
                options: [
                    QuizOption(text: "Rasul Allah", isCorrect: false),
                    QuizOption(text: "Hari Akhir", isCorrect: true),
                    QuizOption(text: "Kitab Allah", isCorrect: false)
                ],
                explanation: "Rukun Iman ke-5 adalah iman kepada Hari Akhir/Hari Kiamat."
            ),
            expReward: 40,
            order: 6
        ),
        Mission(
            key: "h_d1_7",
            title: "Audio: Dzikir Pagi",
            description: "Dengarkan dan ikuti dzikir pagi untuk perlindungan diri seharian.",
            type: .audio,
            media: MissionMedia(url: "https://server.com/dzikir_pagi.mp3", isYoutube: false),
            expReward: 45,
            order: 7
        ),
        Mission(
            key: "h_d1_8",
            title: "Tabel Sunnah Rawatib",
            description: "Memahami waktu shalat sunnah yang mengiringi shalat fardu.",
            type: .knowledge,
            content: [
                ContentBlock(type: .heading, value: "Shalat Rawatib Mu'akkad"),
                ContentBlock(type: .body, value: "2 Rakaat sebelum Subuh\n4 Rakaat sebelum Dzuhur\n2 Rakaat sesudah Dzuhur\n2 Rakaat sesudah Maghrib\n2 Rakaat sesudah Isya")
            ],
            expReward: 35,
            order: 8
        ),
        Mission(
            key: "h_d1_9",
            title: "Praktik: Qabliyah Subuh",
            description: "Laksanakan shalat sunnah 2 rakaat yang lebih baik dari dunia dan seisinya.",
            type: .simple,
            expReward: 80,
            order: 9
        ),
        Mission(
            key: "h_d1_10",
            title: "Satu Menit Refleksi",
            description: "Hadirkan kehadiran hati sepenuhnya dan evaluasi perjalanan hijrahmu hari ini.",
            type: .timer,
            timer: MissionTimer(targetSeconds: 60, label: "Self-Reflection (1 Menit)"),
            expReward: 30,
            order: 10
        )
    ]
    
    // MARK: - Better Missions
    public static let betterMissions: [Mission] = [
        Mission(
            key: "b_d1_1",
            title: "Tadabbur Ar-Rahman",
            description: "Meresapi ayat-ayat penuh nikmat dari surat Sang Maha Pengasih.",
            type: .knowledge,
            content: [
                ContentBlock(type: .heading, value: "Nikmat Tuhan Mana Lagi?"),
                ContentBlock(type: .arabic, value: "فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ"),
                ContentBlock(type: .translation, value: "Maka nikmat Tuhan kamu yang manakah yang kamu dustakan?")
            ],
            references: [MissionReference(title: "Tafsir Ar-Rahman", icon: "book.and.wrench.fill", targetId: "tafsir_arrahman", type: .quran)],
            expReward: 70,
            order: 1
        ),
        Mission(
            key: "b_d1_2",
            title: "Audio: Nasehat Syekh",
            description: "Dengarkan audio nasehat hikmah tentang kelembutan hati.",
            type: .audio,
            media: MissionMedia(url: "https://server.com/murottal.mp3", isYoutube: false),
            expReward: 80,
            order: 2
        ),
        Mission(
            key: "b_d1_3",
            title: "Uji Ihsan & Muraqabah",
            description: "Uji pemahaman Anda tentang Ihsan.",
            type: .quiz,
            quiz: MissionQuiz(
                question: "Apakah pengertian Ihsan?",
                options: [
                    QuizOption(text: "Beribadah seolah-olah melihat Allah", isCorrect: true),
                    QuizOption(text: "Hanya sekadar shalat", isCorrect: false)
                ],
                explanation: "Ihsan adalah beribadah seolah-olah engkau melihat Allah SWT."
            ),
            expReward: 60,
            order: 3
        ),
        Mission(
            key: "b_d1_4",
            title: "Tahajjud 8 Rakaat",
            description: "Bangun di sepertiga malam terakhir untuk ibadah paling utama.",
            type: .simple,
            expReward: 100,
            order: 4
        ),
        Mission(
            key: "b_d1_5",
            title: "Fokus: Muraqabah Deep",
            description: "Hadirkan perasaan diawasi oleh Allah dalam keheningan total.",
            type: .timer,
            timer: MissionTimer(targetSeconds: 600, label: "Muraqabah (10 Menit)"),
            expReward: 120,
            order: 5
        ),
        Mission(
            key: "b_d1_6",
            title: "Video: Tafsir Al-Baqarah",
            description: "Tontonlah penjelasan mendalam tentang rukun iman dan perbuatan baik.",
            type: .video,
            media: MissionMedia(url: "https://www.youtube.com/watch?v=tafsir1", isYoutube: true),
            expReward: 80,
            order: 6
        ),
        Mission(
            key: "b_d1_7",
            title: "Zikir: Shalawat 1000x",
            description: "Mendoakan Nabi Muhammad SAW sebanyak seribu kali.",
            type: .tasbih,
            targetCount: 1000,
            expReward: 150,
            order: 7
        ),
        Mission(
            key: "b_d1_8",
            title: "Sedekah Sembunyi",
            description: "Berikan bantuan kepada orang lain tanpa diketahui siapa pun untuk menjaga ikhlas.",
            type: .simple,
            expReward: 90,
            order: 8
        ),
        Mission(
            key: "b_d1_9",
            title: "Atribut Asmaul Husna",
            description: "Mempelajari makna dan sifat-sifat Allah yang Maha Sempurna.",
            type: .knowledge,
            content: [
                ContentBlock(type: .heading, value: "Sifat Al-Lathif"),
                ContentBlock(type: .body, value: "Maha Lembut dan Maha Halus dalam memberikan hikmah kepada hamba-Nya.")
            ],
            expReward: 50,
            order: 9
        ),
        Mission(
            key: "b_d1_10",
            title: "Kuis: Sifat Dua Puluh",
            description: "Uji pengetahuan tentang sifat-sifat wajib bagi Allah SWT.",
            type: .quiz,
            quiz: MissionQuiz(
                question: "Manakah yang merupakan sifat mustahil bagi Allah?",
                options: [
                    QuizOption(text: "Al-Baqâ (Kekal)", isCorrect: false),
                    QuizOption(text: "Al-Fana (Rusak/Punah)", isCorrect: true),
                    QuizOption(text: "Al-Irâdah (Berkehendak)", isCorrect: false)
                ],
                explanation: "Al-Fana (Rusak) adalah sifat mustahil bagi Allah karena Allah Maha Kekal (Al-Baqâ)."
            ),
            expReward: 60,
            order: 10
        )
    ]
}
