# 宝宝喝奶小账本 · 安卓工程（云端一键打包 APK）

这个工程把网页版「宝宝喝奶小账本」封装成原生安卓 App（WebView 壳 + 本地资源，完全离线、无需联网、不申请网络权限）。

- 应用内数据保存在手机本地存储中
- 「家庭共享」扫码同步使用摄像头（需授权），也可不用摄像头、直接粘贴同步码
- 「导出备份 CSV」会写入手机「下载」目录（Android 10+）；Android 8/9 写入应用私有目录 `Android/data/com.teleagent.milktracker/files/备份/`

---

## 方式一：GitHub Actions 云端打包（不需要电脑装开发环境，推荐）

### 1. 建一个 GitHub 仓库

打开 https://github.com/new ，仓库名随意（例如 `milk-tracker-app`），选 **Private** 或 Public 均可，**不要**勾选任何初始化文件。

### 2. 把本目录全部文件传上去（两种方式，任选一种）

**方式 A（推荐，不用碰隐藏文件夹）**

1. 仓库主页点 **Add file → Upload files**，把本文件夹 `apk-project` **里面**的内容拖进去（不要拖文件夹本身，否则会多套一层目录，Actions 就找不到流水线了）：`app/` 文件夹、`settings.gradle`、`build.gradle`、`gradle.properties`、`README.md`、`sync-web.sh`、`build-apk.yml` 一起拖。
2. 下方填一句提交说明，点绿色 **Commit changes**。
3. 再上传流水线文件：仓库主页点 **Add file → Create new file**，在文件名框里输入
   `.github/workflows/build-apk.yml` （输入 `/` 会自动变成一层层文件夹，别手动打字建文件夹）
   下方编辑框里粘贴本工程根目录 `build-apk.yml` 的全部内容 → 点 **Commit changes**。

**方式 B（一次拖完，需要显示隐藏文件）**

在本机的文件管理器里打开 `apk-project` 文件夹，按 `Ctrl+H` 显示隐藏文件（确认能看到 `.github` 文件夹），
然后 `Ctrl+A` 全选所有内容（不要选中文件夹本身，进到文件夹里全选）→ 拖进仓库 **Add file → Upload files** 区域 → Commit changes。

> 校验：上传完成后，仓库首页应该能直接看到 `app`、`.github`、`build.gradle` 等条目。
> 点进 `.github/workflows/build-apk.yml` 能看到完整内容，才说明放对了位置。

命令行方式（本机是 UOS，装过 git 就行）：

```bash
cd apk-project
git init
git add .
git commit -m "init"
git branch -M main
git remote add origin https://github.com/<你的用户名>/milk-tracker-app.git
git push -u origin main
```

### 3. 等待自动打包

推送/上传后，打开仓库的 **Actions** 标签页，会看到 `Build APK` 正在运行（约 3~5 分钟）。
跑完后点进这次运行，页面底部 **Artifacts** 里下载 `milk-tracker-apk.zip`，解压得到 `app-debug.apk`。

### 4. 安装到手机

把 `app-debug.apk` 用微信/QQ 发到手机，点击安装（首次需在系统设置里允许“安装未知来源应用”）。

---

## 方式二：本地 Android Studio 打包

在有 Windows/macOS 电脑的情况下：用 Android Studio 打开本目录 → 等待 Gradle 同步 → 菜单 **Build → Build App Bundle(s) / APK(s) → Build APK(s)** → 在 `app/build/outputs/apk/debug/` 拿到 APK。

> 注意：当前这台 UOS（ARM64）电脑无法本地编译 APK —— 安卓构建工具链（aapt2 等）没有 Linux ARM64 版本，所以请用方式一。

---

## 修改网页后如何更新 App

1. 修改上一级目录的 `milk-tracker.html`
2. 在本目录执行：`sh sync-web.sh`（或手动把 `milk-tracker.html` 复制为 `app/src/main/assets/index.html`）
3. 重新提交到 GitHub，Actions 会自动打出新的 APK

## 关于签名

当前打包的是 **debug 签名** 的 APK，自己安装使用完全没问题；
如果以后要发到应用商店，需要生成正式签名（jks），在 `app/build.gradle` 里配置 `signingConfigs` 并改用 `assembleRelease`，需要时再补。

## 常见问题

- **扫码时提示打不开摄像头**：第一次使用需在弹窗里允许摄像头权限；也可以改用「粘贴同步码」导入，不依赖摄像头。
- **卸载 App 数据会丢吗**：会。请定期在「设置 → 导出备份 CSV」备份，或与家人互扫同步码留存。
- **同步码安全吗**：同步码只包含喂奶记录和宝宝体重/小名，完全在双方手机之间传递，不经过任何服务器。

> AI生成
