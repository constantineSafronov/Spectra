//
//  SettingsFeature.swift
//  Spectra
//
//  Created by Konstantin Safronov on 22.10.2025.
//

import ComposableArchitecture
import Foundation

// MARK: - User Defaults keys

enum AppStorageKeys {
  static let appTheme = "appTheme"
  static let showAuthorName = "showAuthorName"
  static let showPhotoDescription = "showPhotoDescription"
  static let useTechnologyStyle = "useTechNologyStyle"
}

// MARK: - Theme options

enum AppTheme: String, CaseIterable {
  case light, dark, system
  
  var description: String {
    switch self {
    case .light: return LocalizedStrings.Settings.lightMode.localized
    case .dark: return LocalizedStrings.Settings.darkMode.localized
    case .system: return LocalizedStrings.Settings.systemMode.localized
    }
  }
}

@Reducer
struct SettingsFeature {
  struct State: Equatable {
    var appTheme = AppTheme(
      rawValue: UserDefaults.standard.string(forKey: AppStorageKeys.appTheme) ?? AppTheme.dark.rawValue
    ) ?? .dark
    var showAuthorName: Bool = UserDefaults.standard.bool(forKey: AppStorageKeys.showAuthorName)
    var showDescription: Bool = UserDefaults.standard.bool(forKey: AppStorageKeys.showPhotoDescription)
    var useTechnologyStyle: Bool = UserDefaults.standard.bool(forKey: AppStorageKeys.useTechnologyStyle)
  }
  
  enum Action {
    case setAppTheme(AppTheme)
    case toggleShowAuthorName(Bool)
    case toggleShowDescription(Bool)
    case toggleUseTechnologyStyle(Bool)
  }
  
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .setAppTheme(theme):
        state.appTheme = theme
        UserDefaults.standard.set(theme.rawValue, forKey: AppStorageKeys.appTheme)
        return .none
        
      case let .toggleShowAuthorName(value):
        state.showAuthorName = value
        UserDefaults.standard.set(value, forKey: AppStorageKeys.showAuthorName)
        return .none
        
      case let .toggleShowDescription(value):
        state.showDescription = value
        UserDefaults.standard.set(value, forKey: AppStorageKeys.showPhotoDescription)
        return .none
        
      case let .toggleUseTechnologyStyle(value):
        state.useTechnologyStyle = value
        UserDefaults.standard.set(value, forKey: AppStorageKeys.useTechnologyStyle)
        return .none
      }
    }
  }
}
