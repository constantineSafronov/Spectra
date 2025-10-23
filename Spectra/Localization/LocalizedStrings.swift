//
//  String+Localized.swift
//  Spectra
//
//  Created by Konstantin Safronov on 22.10.2025.
//

import Foundation

enum LocalizedStrings {
    
  enum Common: String {
    case fetching = "common.fetching"
    case save = "common.save"
    case ok = "common.ok"
    case error = "common.error"
    case favorite = "common.favorite"
    case savePhotoMessage = "common.savePhotoMessage"
    case savingPhotoFailureMessage = "common.savingPhotoFailureMessage"
   
    var localized: String {
      NSLocalizedString(rawValue, bundle: .main, comment: "")
    }
    
  }
  
  enum Search: String {
    case searchBarPlaceholder = "search.searchBarPlaceholder"
   
    var localized: String {
      NSLocalizedString(rawValue, bundle: .main, comment: "")
    }
    
  }
  
  enum Settings: String {
    case title = "settings.title"
    case darkMode = "settings.darkMode"
    case lightMode = "settings.lightMode"
    case systemMode = "settings.systemMode"
    case themeSectionTitle = "settings.themeSection.title"
    case themePickerTitle = "settings.themePicker.title"
    case themePickerDescription = "settings.themePicker.description"
    case appStyleSectionTitle = "settings.appStyleSection.title"
    case authorNameSwitchTitle = "settings.authorNameSwitch.title"
    case authorNameSwitchDescription = "settings.authorNameSwitch.description"
    case descriptionSwitchTitle = "settings.descriptionSwitch.title"
    case descriptionSwitchDescription = "settings.descriptionSwitch.description"
    case techSwitchTitle = "settings.techSwitch.title"
    case techSwitchDescription = "settings.techSwitch.description"
    
    var localized: String {
      NSLocalizedString(rawValue, bundle: .main, comment: "")
    }
    
  }
  
}
