import AppKit
import UserNotifications

final class ClipboardMonitor {
    private(set) var history: [OTPCode] = []
    private var timer: Timer?
    private var lastChangeCount = NSPasteboard.general.changeCount

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { [weak self] _ in
            self?.check()
        }
    }

    func stop() { timer?.invalidate(); timer = nil }

    func copyToClipboard(_ code: String) {
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(code, forType: .string)
        lastChangeCount = pb.changeCount
    }

    func clearAll() {
        history.removeAll()
    }

    private func check() {
        let pb = NSPasteboard.general
        guard pb.changeCount != lastChangeCount else { return }
        lastChangeCount = pb.changeCount
        guard let text = pb.string(forType: .string), !text.isEmpty else { return }
        guard let otp = OTPDetector.detect(in: text) else { return }
        guard history.first?.code != otp.code else { return }

        history.insert(otp, at: 0)
        if history.count > 20 { history.removeLast() }
        notify(otp)
    }

    private func notify(_ otp: OTPCode) {
        let c = UNMutableNotificationContent()
        c.title = otp.code
        c.subtitle = "\(otp.source) · 已捕获，点击复制"
        c.sound = .default
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: otp.id.uuidString, content: c, trigger: nil)
        )
    }
}
