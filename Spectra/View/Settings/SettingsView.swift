//
//  SettingsView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI

// MARK: - User Defaults keys

enum AppStorageKeys {
  static let appTheme = "showAuappThemethorName"
  static let showAuthorName = "showAuthorName"
  static let showPhotoDescription = "showPhotoDescription"
  static let useTechnologyStyle = "useTechNologyStyle"
}

struct SettingsView: View {
  
  @AppStorage(AppStorageKeys.appTheme) private var appTheme: AppTheme = .dark
  @AppStorage(AppStorageKeys.showAuthorName) private var showAuthorName: Bool = true
  @AppStorage(AppStorageKeys.showPhotoDescription) private var showDescription: Bool = true
  @AppStorage(AppStorageKeys.useTechnologyStyle) private var useTechnologyStyle: Bool = false
  @EnvironmentObject var style: StyleService
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        Text("Settings")
          .foregroundColor(.text)
          .font(style.largeTitleFont)
          .padding(.top, 20.0)
          .padding(.leading, 20.0)
        Form {
          Section(header: Text("Theme").font(style.titleFont)) {
            Picker("App Theme", selection: $appTheme) {
              ForEach(AppTheme.allCases, id: \.self) { theme in
                Text(theme.description)
                  .font(.custom("Technology-Regular", size: 16))
                  .tag(theme)
              }
            }
            .tint(.accessory)
            Text("Select the appearance of the app: light or dark mode.")
              .font(style.descriptionFont)
              .foregroundColor(.secondary)
          }
          
          Section {
            Toggle(isOn: $showAuthorName) {
              VStack(alignment: .leading) {
                Text("Show author name")
                  .font(style.titleFont)
                Text("Display the author's name.")
                  .font(style.descriptionFont)
                  .foregroundColor(.secondary)
              }
            }
          }
          
          Section {
            Toggle(isOn: $showDescription) {
              VStack(alignment: .leading) {
                Text("Show photo description")
                  .font(style.titleFont)
                Text("Display the description of the photo if available.")
                  .font(style.descriptionFont)
                  .foregroundColor(.secondary)
              }
            }
          }
          
          Section {
            Toggle(isOn: $useTechnologyStyle) {
              VStack(alignment: .leading) {
                Text("Use technology style")
                  .font(style.titleFont)
                Text("Display descriptions in tech style.")
                  .font(style.descriptionFont)
                  .foregroundColor(.secondary)
              }
            }
          }
        }
      }
    }
  }
  
}

// MARK: - Theme enum

enum AppTheme: String, CaseIterable {
  case light, dark, system
  
  var description: String {
    switch self {
    case .light: return "Light"
    case .dark: return "Dark"
    case .system: return "System"
    }
  }
  
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
  
}
