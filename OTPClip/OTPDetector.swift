import Foundation

struct OTPCode: Identifiable, Equatable {
    let id = UUID()
    let code: String
    let source: String
    let date: Date

    var timeAgo: String {
        let s = Int(-date.timeIntervalSinceNow)
        if s < 60  { return "刚刚" }
        if s < 3600 { return "\(s / 60)分钟前" }
        let f = DateFormatter(); f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}

enum OTPDetector {
    private static let patterns: [(NSRegularExpression, String)] = {
        let rules: [(String, String)] = [
            (#"(?:验证码|动态码|校验码)[^\d]{0,10}(\d{4,8})"#,        "验证码"),
            (#"(?i)(?:code|otp|pin|passcode)[^\d]{0,10}(\d{4,8})"#,  "Code"),
            (#"(\d{4,8})(?:[^\d]{0,10})(?:是你的|为您的|是您的)"#,     "验证码"),
            (#"(?<!\d)(\d{6})(?!\d)"#,                                "6位码"),
            (#"(?<!\d)(\d{4})(?!\d)"#,                                "4位码"),
        ]
        return rules.compactMap { pattern, label in
            (try? NSRegularExpression(pattern: pattern)).map { ($0, label) }
        }
    }()

    static func detect(in text: String) -> OTPCode? {
        let range = NSRange(text.startIndex..., in: text)
        for (regex, label) in patterns {
            guard let match = regex.firstMatch(in: text, range: range) else { continue }
            let captureRange = match.numberOfRanges > 1 ? match.range(at: 1) : match.range
            if let r = Range(captureRange, in: text) {
                let code = String(text[r])
                return OTPCode(code: code, source: label, date: Date())
            }
        }
        return nil
    }
}
