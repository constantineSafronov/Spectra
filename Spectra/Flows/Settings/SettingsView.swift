//
//  SettingsView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
  
  let store: StoreOf<SettingsFeature>
  @EnvironmentObject var style: StyleService
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        VStack(alignment: .leading) {
          Text(LocalizedStrings.Settings.title.localized)
            .foregroundColor(.text)
            .font(style.largeTitleFont)
            .padding(.top, 20)
            .padding(.leading, 20)
          
          Form {
            // MARK: Theme
            Section(header: Text(LocalizedStrings.Settings.themeSectionTitle.localized)
              .font(style.titleFont)) {
                Picker(LocalizedStrings.Settings.themePickerTitle.localized, selection: viewStore.binding(
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
                
                Text(LocalizedStrings.Settings.themePickerDescription.localized)
                  .font(style.descriptionFont)
                  .foregroundColor(.secondary)
              }
            
            // MARK: App Style
            Section(header: Text(LocalizedStrings.Settings.appStyleSectionTitle.localized).font(style.titleFont)) {
              Toggle(isOn: viewStore.binding(
                get: \.showAuthorName,
                send: SettingsFeature.Action.toggleShowAuthorName
              )) {
                VStack(alignment: .leading) {
                  Text(LocalizedStrings.Settings.authorNameSwitchTitle.localized)
                    .font(style.titleFont)
                  Text(LocalizedStrings.Settings.authorNameSwitchDescription.localized)
                    .font(style.descriptionFont)
                    .foregroundColor(.secondary)
                }
              }
              
              Toggle(isOn: viewStore.binding(
                get: \.showDescription,
                send: SettingsFeature.Action.toggleShowDescription
              )) {
                VStack(alignment: .leading) {
                  Text(LocalizedStrings.Settings.descriptionSwitchTitle.localized)
                    .font(style.titleFont)
                  Text(LocalizedStrings.Settings.descriptionSwitchDescription.localized)
                    .font(style.descriptionFont)
                    .foregroundColor(.secondary)
                }
              }
              
              Toggle(isOn: viewStore.binding(
                get: \.useTechnologyStyle,
                send: SettingsFeature.Action.toggleUseTechnologyStyle
              )) {
                VStack(alignment: .leading) {
                  Text(LocalizedStrings.Settings.techSwitchTitle.localized)
                    .font(style.titleFont)
                  Text(LocalizedStrings.Settings.techSwitchDescription.localized)
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
