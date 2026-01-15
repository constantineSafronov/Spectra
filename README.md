# Spectra 🌈

![SwiftUI](https://img.shields.io/badge/SwiftUI-Orange?style=flat-square&logo=swift) ![iOS](https://img.shields.io/badge/iOS-Blue?style=flat-square&logo=apple) ![TCA](https://img.shields.io/badge/TCA-Purple?style=flat-square) ![Combine](https://img.shields.io/badge/Combine-Red?style=flat-square) ![SwiftData](https://img.shields.io/badge/SwiftData-LightBlue?style=flat-square)

**Spectra** is a modern iOS photo browsing app built with **SwiftUI** and **The Composable Architecture (TCA)**. It leverages the **Unsplash API** to search and display stunning images with smooth, interactive transitions and a clean, testable architecture.

---

## ✨ Features

- 🔍 Search photos via Unsplash API  
- 🧱 **Masonry Grid Layout for dynamic, Pinterest-like photo feed**  
- 🔄 Smooth fullscreen transitions using `matchedGeometryEffect`  
- ❤️ Save photos to Favorites using SwiftData  
- 🎯 Built with **The Composable Architecture (TCA)** + Navigation + Combine  
- 🧪 Unit Tests included  
- 🎨 Customizable UI: toggle photo description & author, change app fonts  
- 🌐 Localization ready (currently English only)

---


## Technical Highlights ⚙️

- SwiftUI + TCA architecture  
- Navigation handled via TCA  
- Smooth animations and custom transitions
- Masonry Grid layout
- Combine for reactive state updates  
- Unit tests demonstrating testable state and actions  

### Architecture Diagram 🏗️

```text
[App] --> [Store] --> [View] --> [Actions/State]
```

This diagram shows the flow of state and actions through TCA, making the app highly testable and predictable.

---


## Requirements 📱

- iOS 16+  
- Xcode 15+  

---

## Unsplash API Setup 🔑

Before running the app, make sure to replace the placeholder with your own Unsplash API Client ID:

```swift
let unsplashClientID = "YOUR_UNSPLASH_CLIENT_ID"
```

You can get your client ID by creating an account and registering an application at [Unsplash Developers](https://unsplash.com/developers).

---

## Screenshots 🖼️

<table>
<tr>
  <td><img src="https://github.com/user-attachments/assets/ce60e32d-6129-4386-92ad-05814d72ce28" alt="Feed" width="226"/></td>
  <td><img src="https://github.com/user-attachments/assets/f97f8045-8468-47df-8cd5-d9f4fde794f1" alt="Full Screen" width="226"/></td>
  <td><img src="https://github.com/user-attachments/assets/e46b0085-3071-42dc-8774-204437525fb6" alt="Search" width="226"/></td>
  <td><img src="https://github.com/user-attachments/assets/ad10aef7-922d-4f7e-acd9-4edf32bb7e3e" alt="Favorites" width="226"/></td>
</tr>
</table>

---

## Installation 🚀

Clone the repo:

```bash
git clone https://github.com/constantineSafronov/spectra.git
cd spectra
```

Open `Spectra.xcodeproj` in Xcode and build for iOS Simulator or device.

---

## Testing ✅

Unit tests are included for key components:

```bash
Cmd + U
```

---

## License 📄

MIT License – feel free to explore, learn, and adapt!

