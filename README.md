# CodeDrop

<p align="right"><a href="README.en.md">English</a></p>

自动捕获剪贴板中的验证码，住在 Mac 菜单栏里。

iPhone 收到短信或邮件验证码时，Apple 的 Universal Clipboard 会静默同步到 Mac。CodeDrop 在菜单栏里等候，一旦检测到验证码立即通知你，随时一键复制。

---

## 工作原理

```
iPhone 收到短信 / 邮件  →  手机上复制验证码
           ↓
Universal Clipboard 自动同步到 Mac（同一 Apple ID）
           ↓
CodeDrop 自动检测并捕获
           ↓
系统通知弹出 + 保存到菜单历史
           ↓
点击即复制 — 完成
```

无需伴侣 App，无需手动输入，无需浏览器插件。

---

## 功能

- **自动识别** — 支持 4–8 位数字验证码，兼容「验证码」「code」「OTP」等关键词格式
- **历史记录** — 保存最近 20 条，菜单中显示最新 8 条
- **一键复制** — 点击任意一条立即写入剪贴板
- **系统通知** — 捕获成功后即时弹出通知
- **纯菜单栏** — 不显示 Dock 图标，安静常驻后台

---

## 系统要求

- macOS 13 Ventura 及以上
- iPhone 与 Mac 登录同一 Apple ID
- 两台设备均开启 **Handoff**（系统设置 → 通用 → AirDrop 与 Handoff）

---

## 安装

```bash
git clone https://github.com/zhangjingxv/CodeDrop.git
cd CodeDrop
open OTPClip.xcodeproj
```

在 Xcode 中按 `⌘R` 编译运行即可。

---

## 项目结构

```
OTPClip/
├── OTPClipApp.swift       App 入口
├── AppDelegate.swift      菜单栏管理与菜单渲染
├── ClipboardMonitor.swift 剪贴板轮询与通知推送
└── OTPDetector.swift      正则验证码识别
```

---

## 许可证

MIT
