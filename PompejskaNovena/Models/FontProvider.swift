class FontProvider {
    static let shared = FontProvider()

    private let key = "PreferredTextSize"

    var currentSize: TextSize {
        get {
            let raw = UserDefaults.standard.string(forKey: key) ?? TextSize.medium.rawValue
            return TextSize(rawValue: raw) ?? .medium
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        }
    }

    func font(for style: UIFont.TextStyle = .body, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: currentSize.pointSize, weight: weight)
    }
}
