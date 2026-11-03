# Partiful Party Invite & Poster Maker - Native iOS

Ứng dụng Native iOS chuyên nghiệp thiết kế thiệp mời, poster tiệc với phong cách trẻ trung, hiện đại tương tự Partiful.

---

## 1. Công nghệ & Thư viện sử dụng
- **Ngôn ngữ:** Swift 5.9+ / Swift 6
- **Giao diện:** SwiftUI (Declarative UI, Dark mode velvet first)
- **Kiến trúc:** MVVM (Model - View - ViewModel) + Repository Pattern + Clean Architecture
- **Xử lý ảnh & Bộ lọc:** Core Graphics, Core Image (`CIFilter`, `CIColorControls`, `CIGaussianBlur`, `CIVignette`), `UIGraphicsImageRenderer`
- **Chọn ảnh:** `PhotosUI` (`PhotosPicker`, `PhotosPickerItem`)
- **Xuất PDF in ấn:** `PDFKit`, `UIGraphicsPDFRenderer`
- **Tích hợp Lịch & Lời nhắc:** `EventKit` (`EKEventStore`, `EKEvent`, `EKReminder`)
- **Chia sẻ:** `UIActivityViewController`, `ShareLink`
- **Lưu trữ cục bộ:** `FileManager` (Documents directory), JSON Codable serialization, `UserDefaults`
- **Quản lý phiên bản:** Swift Package Manager (SPM)

---

## 2. Cấu trúc thư mục (Folder Structure)

```
ios/
├── Package.swift                     # Khai báo Swift Package Manager
├── PartifulApp/
│   ├── App/
│   │   ├── PartifulApp.swift        # @main App entrypoint
│   │   └── ContentView.swift        # Quản lý luồng Splash -> Onboarding -> Home
│   ├── Core/
│   │   ├── DesignSystem/            # Hệ thống màu neon, typography, UI components
│   │   │   ├── ColorPalette.swift
│   │   │   ├── Typography.swift
│   │   │   └── Components/
│   │   │       ├── NeonButton.swift
│   │   │       └── GlassCard.swift
│   │   └── CanvasEngine/            # Trình dựng Canvas đa lớp, Memento Undo/Redo
│   │       ├── CanvasRenderer.swift
│   │       └── HistoryManager.swift
│   ├── Models/                      # Thực thể dữ liệu: Layer, CardDesign, Event, Template
│   │   ├── CanvasLayer.swift
│   │   ├── CardDesign.swift
│   │   ├── LayerType.swift
│   │   ├── PartyEvent.swift
│   │   ├── Template.swift
│   │   └── TemplateCategory.swift
│   ├── Services/                    # Core Services độc lập
│   │   ├── CalendarService.swift    # Tích hợp Apple Calendar & Reminders qua EventKit
│   │   ├── DraftStorageService.swift# Lưu trữ bản nháp & dự án offline
│   │   ├── ImageProcessorService.swift # Áp dụng bộ lọc CoreImage, lưu ảnh
│   │   └── PDFExportService.swift   # Xuất tài liệu PDF in ấn 300 DPI
│   ├── Repositories/
│   │   └── TemplateRepository.swift # 11 danh mục mẫu thiệp định sẵn
│   ├── Features/                    # 18 Màn hình chức năng
│   │   ├── Splash/                  # Màn hình Splash động
│   │   ├── Onboarding/              # 3 màn hình Onboarding
│   │   ├── Home/                    # Màn hình chính, danh mục, mẫu nổi bật
│   │   ├── Templates/               # Chi tiết mẫu thiệp
│   │   ├── Editor/                  # Trình chỉnh sửa thiệp đa lớp (Canvas, Text, Sticker, Filter, Layer)
│   │   ├── Preview/                 # Màn hình xem trước thiệp sạch
│   │   ├── Export/                  # Màn hình xuất PNG/JPG/PDF, chia sẻ
│   │   ├── Calendar/                # Màn hình nhập sự kiện & xác nhận lịch
│   │   ├── Projects/                # Quản lý các bản thiết kế đã lưu
│   │   └── Settings/                # Cài đặt ứng dụng
│   └── Resources/
│       └── Info.plist               # Khai báo quyền Lịch, Ảnh, Máy ảnh
└── PartifulAppTests/                # XCTest Unit Tests
    ├── CardDesignTests.swift
    └── HistoryManagerTests.swift
```

---

## 3. Hướng dẫn cài đặt & Chạy dự án (macOS & Xcode)

### Yêu cầu hệ thống:
- macOS Sonoma 14.0 trở lên.
- Xcode 15.0 trở lên.
- Thiết bị iOS 17.0+ hoặc iOS Simulator.

### Các bước mở và chạy dự án:
1. Mở thư mục `ios` bằng Xcode:
   ```bash
   cd ios
   open Package.swift
   ```
   *Hoặc trong Xcode: Chọn `File` -> `Open...` -> Chọn thư mục `ios`.*
2. Xcode sẽ tự động phân giải cấu trúc Package và nạp target `PartifulApp`.
3. Chọn thiết bị chạy (Ví dụ: `iPhone 15 Pro` hoặc `iPhone 16 Simulator`).
4. Nhấn `Cmd + R` để Build & Run.
5. Để chạy bộ kiểm thử Unit Tests: Nhấn `Cmd + U`.
