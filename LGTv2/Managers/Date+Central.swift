import Foundation

public extension TimeZone {
    static let central: TimeZone = TimeZone(identifier: "America/Chicago")!
}

public extension Calendar {
    static var central: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .central
        return cal
    }()
}

public extension DateFormatter {
    static func central(style: DateFormatter.Style = .medium,
                        timeStyle: DateFormatter.Style = .short) -> DateFormatter {
        let df = DateFormatter()
        df.timeZone = .central
        df.dateStyle = style
        df.timeStyle = timeStyle
        return df
    }
}
