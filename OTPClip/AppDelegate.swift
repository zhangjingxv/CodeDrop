import AppKit
import UserNotifications

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private let monitor = ClipboardMonitor()

    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) { _, _ in }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let btn = statusItem.button {
            btn.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: "OTPClip")
            btn.image?.isTemplate = true
        }

        statusItem.menu = buildMenu()
        statusItem.menu?.delegate = self
        monitor.start()
    }
}

// MARK: - Menu

extension AppDelegate: NSMenuDelegate {
    func menuNeedsUpdate(_ menu: NSMenu) {
        let rebuilt = buildMenu()
        menu.removeAllItems()
        for item in rebuilt.items { menu.addItem(item.copy() as! NSMenuItem) }
    }

    func buildMenu() -> NSMenu {
        let menu = NSMenu()

        // Header
        let header = NSMenuItem(title: "OTPClip", action: nil, keyEquivalent: "")
        header.isEnabled = false
        header.attributedTitle = NSAttributedString(
            string: "OTPClip",
            attributes: [
                .font: NSFont.systemFont(ofSize: 12, weight: .semibold),
                .foregroundColor: NSColor.secondaryLabelColor
            ]
        )
        menu.addItem(header)
        menu.addItem(.separator())

        // History
        let history = monitor.history
        if history.isEmpty {
            let empty = NSMenuItem(title: "等待验证码…", action: nil, keyEquivalent: "")
            empty.isEnabled = false
            empty.attributedTitle = NSAttributedString(
                string: "等待验证码…",
                attributes: [.foregroundColor: NSColor.tertiaryLabelColor,
                             .font: NSFont.systemFont(ofSize: 13)]
            )
            menu.addItem(empty)
        } else {
            for otp in history.prefix(8) {
                let item = CodeMenuItem(otp: otp)
                item.target = self
                item.action = #selector(copyCode(_:))
                menu.addItem(item)
            }
        }

        menu.addItem(.separator())

        if !history.isEmpty {
            let clear = NSMenuItem(title: "清除记录", action: #selector(clearAll), keyEquivalent: "")
            clear.target = self
            menu.addItem(clear)
            menu.addItem(.separator())
        }

        menu.addItem(NSMenuItem(title: "退出", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        return menu
    }

    @objc private func copyCode(_ sender: CodeMenuItem) {
        monitor.copyToClipboard(sender.otp.code)
        flashIcon()
    }

    @objc private func clearAll() {
        monitor.clearAll()
    }

    private func flashIcon() {
        guard let btn = statusItem.button else { return }
        btn.image = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
        btn.image?.isTemplate = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            btn.image = NSImage(systemSymbolName: "key.fill", accessibilityDescription: nil)
            btn.image?.isTemplate = true
        }
    }
}

// MARK: - Custom menu item

final class CodeMenuItem: NSMenuItem {
    let otp: OTPCode

    init(otp: OTPCode) {
        self.otp = otp
        super.init(title: "", action: nil, keyEquivalent: "")

        let code = NSMutableAttributedString(
            string: otp.code,
            attributes: [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 15, weight: .semibold),
                .foregroundColor: NSColor.labelColor
            ]
        )
        let meta = NSAttributedString(
            string: "   \(otp.source)  \(otp.timeAgo)",
            attributes: [
                .font: NSFont.systemFont(ofSize: 11),
                .foregroundColor: NSColor.secondaryLabelColor
            ]
        )
        code.append(meta)
        attributedTitle = code
    }

    required init(coder: NSCoder) { fatalError() }
}
