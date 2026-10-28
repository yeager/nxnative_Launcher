import Foundation

public enum TargetPlatform: String, CaseIterable, Identifiable {
    case macApp = "mac-app"
    case ios = "ios"
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .macApp:
            return L10n.string("Mac App (.app)")
        case .ios:
            return L10n.string("iOS / iPadOS (.ipa)")
        }
    }
    
    public var iconName: String {
        switch self {
        case .macApp:
            return "macbook.gen2"
        case .ios:
            return "iphone.gen3"
        }
    }
    
    public var subtitle: String {
        switch self {
        case .macApp:
            return L10n.string("Double-clickable native macOS app for Apple Silicon.")
        case .ios:
            return L10n.string("Sideloadable IPA package for iPhone 15 Pro and iPad.")
        }
    }
}
