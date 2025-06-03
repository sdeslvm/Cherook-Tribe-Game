import Foundation
import SwiftUI

struct CherookHexColor {
    static func color(from hex: String) -> Color {
        let hexClean = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: hexClean).scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        return Color(red: r, green: g, blue: b)
    }
    static func uiColor(from hex: String) -> UIColor {
        let hexClean = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: hexClean).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

private let cherookGameURL = URL(string: "https://cherooktribeonline.top/get/")!

private func makeCherookGameLoader() -> CherookWebContentLoader {
    CherookWebContentLoader(url: cherookGameURL)
}

struct CherookView: View {
    var body: some View {
        ZStack {
            CherookHexColor.color(from: "#C3EFFF").ignoresSafeArea()
            CherookLaunchScreenView(viewModel: makeCherookGameLoader())
        }
    }
}

#Preview {
    CherookView()
}
