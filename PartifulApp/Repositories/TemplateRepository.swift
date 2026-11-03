import Foundation

public final class TemplateRepository {
    public static let shared = TemplateRepository()
    
    public let templates: [Template]
    
    public init() {
        self.templates = Self.generatePresetTemplates()
    }
    
    public func getTemplates(for category: TemplateCategory) -> [Template] {
        if category == .all {
            return templates
        }
        return templates.filter { $0.category == category }
    }
    
    public func getTemplate(by id: String) -> Template? {
        return templates.first { $0.id == id }
    }
    
    private static func generatePresetTemplates() -> [Template] {
        return [
            // 1. Birthday
            Template(
                id: "tpl_birthday_neon",
                name: "Neon Glow Birthday",
                category: .birthday,
                cardDesign: CardDesign(
                    title: "Neon Birthday Bash",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#0D0221",
                    backgroundGradientHexes: ["#0F051D", "#2E0249", "#570A57"],
                    backgroundGradientAngle: 45,
                    layers: [
                        CanvasLayer(
                            name: "Badge",
                            type: .text,
                            x: 0, y: -450, width: 600, height: 60,
                            textData: TextLayerData(text: "✨ YOU ARE INVITED ✨", fontSize: 22, fontColorHex: "#FBBF24", isBold: true, letterSpacing: 4)
                        ),
                        CanvasLayer(
                            name: "Main Title",
                            type: .text,
                            x: 0, y: -300, width: 850, height: 220,
                            textData: TextLayerData(text: "HAPPY\nBIRTHDAY", fontSize: 80, fontColorHex: "#FF007F", isBold: true, strokeWidth: 2, strokeColorHex: "#A855F7", shadowRadius: 15, shadowColorHex: "#EC489980")
                        ),
                        CanvasLayer(
                            name: "Host Name",
                            type: .text,
                            x: 0, y: -80, width: 700, height: 70,
                            textData: TextLayerData(text: "CELEBRATING SARAH'S 25TH", fontSize: 26, fontColorHex: "#FFFFFF", isBold: true, letterSpacing: 2)
                        ),
                        CanvasLayer(
                            name: "Date & Time",
                            type: .text,
                            x: 0, y: 150, width: 750, height: 90,
                            textData: TextLayerData(text: "SATURDAY, NOV 21 • 8:00 PM", fontSize: 28, fontColorHex: "#00F0FF", isBold: true, letterSpacing: 2)
                        ),
                        CanvasLayer(
                            name: "Location",
                            type: .text,
                            x: 0, y: 280, width: 750, height: 80,
                            textData: TextLayerData(text: "THE VELVET ROOFTOP LOUNGE\n124 Skyline Drive, District 1", fontSize: 22, fontColorHex: "#E2E8F0", isBold: false)
                        ),
                        CanvasLayer(
                            name: "Cake Sticker",
                            type: .sticker,
                            x: 0, y: 460, width: 140, height: 140,
                            stickerData: StickerLayerData(symbolOrName: "birthday.cake.fill", category: "Birthday", tintColorHex: "#FFD166", glowRadius: 10, glowColorHex: "#F59E0B")
                        )
                    ],
                    eventInfo: PartyEvent(
                        title: "Sarah's 25th Birthday Bash",
                        eventDescription: "Join us for rooftop cocktails, neon dancing and birthday cake!",
                        location: "The Velvet Rooftop Lounge, District 1"
                    )
                ),
                previewColorHex: "#FF007F",
                tags: ["neon", "glow", "party", "cake"]
            ),
            
            // 2. Wedding
            Template(
                id: "tpl_wedding_elegance",
                name: "Rose Gold Wedding",
                category: .wedding,
                cardDesign: CardDesign(
                    title: "Forever Together",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#1A0914",
                    backgroundGradientHexes: ["#1F0E1C", "#381831", "#150713"],
                    backgroundGradientAngle: 90,
                    layers: [
                        CanvasLayer(
                            name: "Header",
                            type: .text,
                            x: 0, y: -420, width: 700, height: 60,
                            textData: TextLayerData(text: "TOGETHER WITH THEIR FAMILIES", fontSize: 20, fontColorHex: "#E5C3A6", isBold: false, letterSpacing: 3)
                        ),
                        CanvasLayer(
                            name: "Couple Names",
                            type: .text,
                            x: 0, y: -260, width: 850, height: 180,
                            textData: TextLayerData(text: "Emily & Alexander", fontSize: 68, fontColorHex: "#FFFFFF", isBold: true, shadowRadius: 10, shadowColorHex: "#E5C3A680")
                        ),
                        CanvasLayer(
                            name: "Tagline",
                            type: .text,
                            x: 0, y: -110, width: 700, height: 60,
                            textData: TextLayerData(text: "REQUEST THE PLEASURE OF YOUR COMPANY", fontSize: 18, fontColorHex: "#E5C3A6", isBold: false, letterSpacing: 2)
                        ),
                        CanvasLayer(
                            name: "Date",
                            type: .text,
                            x: 0, y: 120, width: 750, height: 80,
                            textData: TextLayerData(text: "SUNDAY, DECEMBER 14, 2026\nAT 5:00 IN THE AFTERNOON", fontSize: 24, fontColorHex: "#FFFFFF", isBold: true, letterSpacing: 1)
                        ),
                        CanvasLayer(
                            name: "Venue",
                            type: .text,
                            x: 0, y: 280, width: 750, height: 80,
                            textData: TextLayerData(text: "THE GRAND BOTANICAL PALACE\nGarden Terrace & Ballroom", fontSize: 22, fontColorHex: "#D1D5DB", isBold: false)
                        ),
                        CanvasLayer(
                            name: "Rings Sticker",
                            type: .sticker,
                            x: 0, y: 440, width: 120, height: 120,
                            stickerData: StickerLayerData(symbolOrName: "heart.circle.fill", category: "Wedding", tintColorHex: "#E5C3A6", glowRadius: 8, glowColorHex: "#E5C3A6")
                        )
                    ],
                    eventInfo: PartyEvent(
                        title: "Emily & Alexander's Wedding Celebration",
                        eventDescription: "A celebration of love and happiness at The Grand Botanical Palace.",
                        location: "The Grand Botanical Palace"
                    )
                ),
                previewColorHex: "#E5C3A6",
                tags: ["wedding", "elegant", "floral", "romantic"]
            ),
            
            // 3. Graduation
            Template(
                id: "tpl_graduation_star",
                name: "Class of 2026 Celebration",
                category: .graduation,
                cardDesign: CardDesign(
                    title: "Graduation Gala",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#0B132B",
                    backgroundGradientHexes: ["#0B132B", "#1C2541", "#3A506B"],
                    backgroundGradientAngle: 60,
                    layers: [
                        CanvasLayer(
                            name: "Cap Sticker",
                            type: .sticker,
                            x: 0, y: -450, width: 140, height: 140,
                            stickerData: StickerLayerData(symbolOrName: "graduationcap.fill", category: "Graduation", tintColorHex: "#FBBF24", glowRadius: 12, glowColorHex: "#F59E0B")
                        ),
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -280, width: 850, height: 180,
                            textData: TextLayerData(text: "CLASS OF 2026\nGRADUATION", fontSize: 72, fontColorHex: "#FBBF24", isBold: true, shadowRadius: 12, shadowColorHex: "#000000")
                        ),
                        CanvasLayer(
                            name: "Honoree",
                            type: .text,
                            x: 0, y: -90, width: 750, height: 60,
                            textData: TextLayerData(text: "HONORING MICHAEL JOHNSON", fontSize: 26, fontColorHex: "#FFFFFF", isBold: true, letterSpacing: 2)
                        ),
                        CanvasLayer(
                            name: "Date & Time",
                            type: .text,
                            x: 0, y: 140, width: 750, height: 80,
                            textData: TextLayerData(text: "FRIDAY, JUNE 18 • 6:30 PM", fontSize: 28, fontColorHex: "#60A5FA", isBold: true)
                        ),
                        CanvasLayer(
                            name: "Location",
                            type: .text,
                            x: 0, y: 280, width: 750, height: 80,
                            textData: TextLayerData(text: "THE HARBOR CLUB HOUSE\nDinner, Drinks & Live DJ", fontSize: 22, fontColorHex: "#E2E8F0", isBold: false)
                        )
                    ]
                ),
                previewColorHex: "#FBBF24",
                tags: ["graduation", "school", "stars", "gold"]
            ),
            
            // 4. Halloween
            Template(
                id: "tpl_halloween_spooky",
                name: "Spooky Haunted Soirée",
                category: .halloween,
                cardDesign: CardDesign(
                    title: "Haunted Halloween Night",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#0A0101",
                    backgroundGradientHexes: ["#160000", "#370617", "#03071E"],
                    backgroundGradientAngle: 120,
                    layers: [
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -340, width: 850, height: 220,
                            textData: TextLayerData(text: "HALLOWEEN\nCOSTUME PARTY", fontSize: 74, fontColorHex: "#FF5400", isBold: true, strokeWidth: 2, strokeColorHex: "#9D0208", shadowRadius: 18, shadowColorHex: "#FF540080")
                        ),
                        CanvasLayer(
                            name: "Subtext",
                            type: .text,
                            x: 0, y: -120, width: 750, height: 60,
                            textData: TextLayerData(text: "COME IF YOU DARE • PRIZES FOR BEST COSTUMES", fontSize: 22, fontColorHex: "#FFD60A", isBold: true, letterSpacing: 2)
                        ),
                        CanvasLayer(
                            name: "Time",
                            type: .text,
                            x: 0, y: 120, width: 750, height: 80,
                            textData: TextLayerData(text: "OCTOBER 31ST • 9:00 PM TILL MIDNIGHT", fontSize: 26, fontColorHex: "#F72585", isBold: true)
                        ),
                        CanvasLayer(
                            name: "Sticker",
                            type: .sticker,
                            x: 0, y: 380, width: 140, height: 140,
                            stickerData: StickerLayerData(symbolOrName: "moon.stars.fill", category: "Halloween", tintColorHex: "#FF9E00", glowRadius: 15, glowColorHex: "#FF5400")
                        )
                    ]
                ),
                previewColorHex: "#FF5400",
                tags: ["halloween", "spooky", "costume", "pumpkin"]
            ),
            
            // 5. Christmas
            Template(
                id: "tpl_christmas_wonderland",
                name: "Winter Wonderland Party",
                category: .christmas,
                cardDesign: CardDesign(
                    title: "Christmas Cheer",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#061A14",
                    backgroundGradientHexes: ["#0A2E20", "#1E4D2B", "#05160E"],
                    backgroundGradientAngle: 45,
                    layers: [
                        CanvasLayer(
                            name: "Snowflake",
                            type: .sticker,
                            x: 0, y: -450, width: 120, height: 120,
                            stickerData: StickerLayerData(symbolOrName: "snowflake", category: "Holiday", tintColorHex: "#A7F3D0", glowRadius: 10, glowColorHex: "#34D399")
                        ),
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -280, width: 850, height: 180,
                            textData: TextLayerData(text: "HOLIDAY\nCHEER & BEER", fontSize: 72, fontColorHex: "#EF4444", isBold: true, strokeWidth: 1, strokeColorHex: "#FFFFFF", shadowRadius: 10, shadowColorHex: "#EF444480")
                        ),
                        CanvasLayer(
                            name: "Details",
                            type: .text,
                            x: 0, y: 150, width: 750, height: 90,
                            textData: TextLayerData(text: "DECEMBER 24 • 7:00 PM\nUGLY SWEATERS MANDATORY!", fontSize: 26, fontColorHex: "#FEF3C7", isBold: true)
                        )
                    ]
                ),
                previewColorHex: "#EF4444",
                tags: ["christmas", "winter", "holiday", "santa"]
            ),
            
            // 6. New Year
            Template(
                id: "tpl_new_year_countdown",
                name: "Midnight Countdown 2027",
                category: .newYear,
                cardDesign: CardDesign(
                    title: "NYE Countdown Gala",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#080708",
                    backgroundGradientHexes: ["#1A181B", "#372549", "#000000"],
                    backgroundGradientAngle: 90,
                    layers: [
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -300, width: 850, height: 200,
                            textData: TextLayerData(text: "NEW YEAR'S EVE\nCOUNTDOWN", fontSize: 72, fontColorHex: "#FACC15", isBold: true, shadowRadius: 15, shadowColorHex: "#FACC1580")
                        ),
                        CanvasLayer(
                            name: "Fireworks",
                            type: .sticker,
                            x: 0, y: -50, width: 140, height: 140,
                            stickerData: StickerLayerData(symbolOrName: "sparkles", category: "NewYear", tintColorHex: "#FACC15", glowRadius: 12, glowColorHex: "#FACC15")
                        ),
                        CanvasLayer(
                            name: "Time",
                            type: .text,
                            x: 0, y: 180, width: 750, height: 90,
                            textData: TextLayerData(text: "DEC 31 • DOORS OPEN 9 PM\nCHAMPAGNE TOAST AT MIDNIGHT", fontSize: 26, fontColorHex: "#FFFFFF", isBold: true)
                        )
                    ]
                ),
                previewColorHex: "#FACC15",
                tags: ["newyear", "fireworks", "champagne", "countdown"]
            ),
            
            // 7. Music
            Template(
                id: "tpl_music_rave",
                name: "Cyberpunk EDM Rave",
                category: .music,
                cardDesign: CardDesign(
                    title: "Electric Pulse Festival",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#050517",
                    backgroundGradientHexes: ["#0B032D", "#1C0F4F", "#030219"],
                    backgroundGradientAngle: 45,
                    layers: [
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -300, width: 850, height: 200,
                            textData: TextLayerData(text: "ELECTRIC\nPULSE", fontSize: 86, fontColorHex: "#00F5D4", isBold: true, strokeWidth: 2, strokeColorHex: "#7B2CBF", shadowRadius: 20, shadowColorHex: "#00F5D4")
                        ),
                        CanvasLayer(
                            name: "Genre",
                            type: .text,
                            x: 0, y: -100, width: 700, height: 60,
                            textData: TextLayerData(text: "HOUSE • TECHNO • BASS", fontSize: 24, fontColorHex: "#F72585", isBold: true, letterSpacing: 4)
                        ),
                        CanvasLayer(
                            name: "Music Icon",
                            type: .sticker,
                            x: 0, y: 100, width: 130, height: 130,
                            stickerData: StickerLayerData(symbolOrName: "music.note.house.fill", category: "Music", tintColorHex: "#00F5D4", glowRadius: 15, glowColorHex: "#00F5D4")
                        )
                    ]
                ),
                previewColorHex: "#00F5D4",
                tags: ["music", "edm", "rave", "festival"]
            ),
            
            // 8. Outdoor
            Template(
                id: "tpl_outdoor_bbq",
                name: "Sunset Pool & BBQ Party",
                category: .outdoor,
                cardDesign: CardDesign(
                    title: "Sunset Backyard BBQ",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#1C0A00",
                    backgroundGradientHexes: ["#3D1300", "#7C2D12", "#EA580C"],
                    backgroundGradientAngle: 180,
                    layers: [
                        CanvasLayer(
                            name: "Sun Sticker",
                            type: .sticker,
                            x: 0, y: -450, width: 140, height: 140,
                            stickerData: StickerLayerData(symbolOrName: "sun.max.fill", category: "Outdoor", tintColorHex: "#FDE047", glowRadius: 14, glowColorHex: "#F97316")
                        ),
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -270, width: 850, height: 180,
                            textData: TextLayerData(text: "SUNSET BBQ &\nPOOL PARTY", fontSize: 72, fontColorHex: "#FFFFFF", isBold: true, shadowRadius: 10, shadowColorHex: "#000000")
                        ),
                        CanvasLayer(
                            name: "Details",
                            type: .text,
                            x: 0, y: 150, width: 750, height: 90,
                            textData: TextLayerData(text: "THIS SATURDAY • 3:00 PM UNTIL DUSK\nBRING YOUR SWIMSUIT & GOOD ENERGY", fontSize: 24, fontColorHex: "#FEF08A", isBold: true)
                        )
                    ]
                ),
                previewColorHex: "#EA580C",
                tags: ["outdoor", "bbq", "pool", "summer"]
            ),
            
            // 9. Friends
            Template(
                id: "tpl_friends_brunch",
                name: "Chill Weekend Gathering",
                category: .friends,
                cardDesign: CardDesign(
                    title: "Weekend Friends Meetup",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#131515",
                    backgroundGradientHexes: ["#1E2222", "#2B2D42", "#131515"],
                    backgroundGradientAngle: 45,
                    layers: [
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -260, width: 850, height: 180,
                            textData: TextLayerData(text: "BRUNCH, PIZZA\n& BOARD GAMES", fontSize: 68, fontColorHex: "#FFD166", isBold: true)
                        ),
                        CanvasLayer(
                            name: "Subtext",
                            type: .text,
                            x: 0, y: 100, width: 750, height: 90,
                            textData: TextLayerData(text: "SUNDAY 11:30 AM • JANE'S LIVING ROOM\nJUST CHILLING & CATCHING UP", fontSize: 24, fontColorHex: "#E2E8F0", isBold: false)
                        )
                    ]
                ),
                previewColorHex: "#FFD166",
                tags: ["friends", "brunch", "chill", "games"]
            ),
            
            // 10. Grand Opening
            Template(
                id: "tpl_grand_opening",
                name: "Grand Opening Gala",
                category: .grandOpening,
                cardDesign: CardDesign(
                    title: "Grand Opening VIP",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#140005",
                    backgroundGradientHexes: ["#2B000B", "#5C0018", "#140005"],
                    backgroundGradientAngle: 90,
                    layers: [
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -300, width: 850, height: 200,
                            textData: TextLayerData(text: "GRAND\nOPENING", fontSize: 84, fontColorHex: "#FFD700", isBold: true, shadowRadius: 15, shadowColorHex: "#FFD70080")
                        ),
                        CanvasLayer(
                            name: "Info",
                            type: .text,
                            x: 0, y: 120, width: 750, height: 90,
                            textData: TextLayerData(text: "RIBBON CUTTING & CHAMPAGNE GALA\nNOVEMBER 28 • 6:00 PM", fontSize: 26, fontColorHex: "#FFFFFF", isBold: true)
                        )
                    ]
                ),
                previewColorHex: "#FFD700",
                tags: ["opening", "business", "gala", "luxury"]
            ),
            
            // 11. Private Party
            Template(
                id: "tpl_private_speakeasy",
                name: "Secret VIP Speakeasy",
                category: .privateParty,
                cardDesign: CardDesign(
                    title: "Midnight Speakeasy",
                    canvasWidth: 1080,
                    canvasHeight: 1920,
                    backgroundColorHex: "#09090B",
                    backgroundGradientHexes: ["#18181B", "#27272A", "#09090B"],
                    backgroundGradientAngle: 135,
                    layers: [
                        CanvasLayer(
                            name: "Badge",
                            type: .text,
                            x: 0, y: -450, width: 700, height: 60,
                            textData: TextLayerData(text: "🔒 STRICTLY CONFIDENTIAL & PRIVATE", fontSize: 20, fontColorHex: "#A1A1AA", isBold: true, letterSpacing: 3)
                        ),
                        CanvasLayer(
                            name: "Title",
                            type: .text,
                            x: 0, y: -280, width: 850, height: 180,
                            textData: TextLayerData(text: "THE SECRET\nSOIRÉE", fontSize: 76, fontColorHex: "#FAFAFA", isBold: true, shadowRadius: 12, shadowColorHex: "#71717A")
                        ),
                        CanvasLayer(
                            name: "Password Note",
                            type: .text,
                            x: 0, y: 150, width: 750, height: 90,
                            textData: TextLayerData(text: "LOCATION DISCLOSED 2 HOURS PRIOR\nPASSWORD REQUIRED AT THE DOOR", fontSize: 22, fontColorHex: "#E4E4E7", isBold: false)
                        )
                    ]
                ),
                previewColorHex: "#A1A1AA",
                tags: ["private", "vip", "secret", "exclusive"]
            )
        ]
    }
}
