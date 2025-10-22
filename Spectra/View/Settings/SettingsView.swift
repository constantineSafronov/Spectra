//
//  SettingsView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import ComposableArchitecture

// MARK: - User Defaults keys

enum AppStorageKeys {
  static let appTheme = "showAuappThemethorName"
  static let showAuthorName = "showAuthorName"
  static let showPhotoDescription = "showPhotoDescription"
  static let useTechnologyStyle = "useTechNologyStyle"
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

struct SettingsView: View {
  
  let store: StoreOf<SettingsFeature>
  @EnvironmentObject var style: StyleService
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        VStack(alignment: .leading) {
          Text("Settings")
            .foregroundColor(.text)
            .font(style.largeTitleFont)
            .padding(.top, 20)
            .padding(.leading, 20)
          
          Form {
            // MARK: Theme
            Section(header: Text("Theme").font(style.titleFont)) {
              Picker("App Theme", selection: viewStore.binding(
                get: \.appTheme,
                send: SettingsFeature.Action.setAppTheme
              )) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                  Text(theme.description)
                    .font(.custom("Technology-Regular", size: 16))
                    .tag(theme)
                }
              }
              .tint(.secondary)
              
              Text("Select the appearance of the app: light or dark mode.")
                .font(style.descriptionFont)
                .foregroundColor(.secondary)
            }
            
            // MARK: App Style
            Section(header: Text("App Style").font(style.titleFont)) {
              Toggle(isOn: viewStore.binding(
                get: \.showAuthorName,
                send: SettingsFeature.Action.toggleShowAuthorName
              )) {
                VStack(alignment: .leading) {
                  Text("Show author name")
                    .font(style.titleFont)
                  Text("Display the author's name.")
                    .font(style.descriptionFont)
                    .foregroundColor(.secondary)
                }
              }
              
              Toggle(isOn: viewStore.binding(
                get: \.showDescription,
                send: SettingsFeature.Action.toggleShowDescription
              )) {
                VStack(alignment: .leading) {
                  Text("Show photo description")
                    .font(style.titleFont)
                  Text("Display the description of the photo if available.")
                    .font(style.descriptionFont)
                    .foregroundColor(.secondary)
                }
              }
              
              Toggle(isOn: viewStore.binding(
                get: \.useTechnologyStyle,
                send: SettingsFeature.Action.toggleUseTechnologyStyle
              )) {
                VStack(alignment: .leading) {
                  Text("Use technology style")
                    .font(style.titleFont)
                  Text("Apply tech style through the whole app.")
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
  
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    let settingsStore = Store(
      initialState: SettingsFeature.State()
    ) {
      SettingsFeature()
    }
    
    SettingsView(store: settingsStore)
      .environmentObject(StyleService(store: settingsStore))
  }
  
}
