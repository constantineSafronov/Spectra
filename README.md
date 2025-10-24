# Spectra 🌈

**Spectra** is a modern iOS photo browsing app built with **SwiftUI** and **The Composable Architecture (TCA)**. It leverages the **Unsplash API** to search and display stunning images with smooth, interactive transitions and a clean, testable architecture.

---

## Features ✨

- **Search photos** via Unsplash API  
- **Full-screen photo view** with custom transitions using `matchedGeometryEffect`  
- **Favorites** powered by **SwiftData**  
- **Customizable UI**: fonts, optional photo description, and author name  
- **Localization-ready** (currently English)  
- **Unit tests** for core business logic  
- **Clean architecture** with **TCA** + **Combine** for predictable state management  

---

## Technical Highlights ⚙️

- SwiftUI + TCA architecture  
- Navigation handled via TCA  
- Smooth animations and custom transitions  
- Combine for reactive state updates  
- Unit tests demonstrating testable state and actions  
- Modular, clean, and scalable code  

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
  <td><img src="https://github.com/user-attachments/assets/6efe444c-1448-4579-8938-ba0eeaf581aa" alt="Feed" width="226"/></td>
  <td><img src="https://github.com/user-attachments/assets/e0e39070-bb6b-4d14-96f9-bd5d04872caf" alt="Full Screen" width="226"/></td>
  <td><img src="https://github.com/user-attachments/assets/47fed776-9f57-45e0-bde8-70eba1dc9519" alt="Search" width="226"/></td>
  <td><img src="https://github.com/user-attachments/assets/67e329bf-469c-41c8-9f9d-7e3f46beff05" alt="Favorites" width="226"/></td>
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

