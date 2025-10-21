//
//  StyleService.swift
//  Spectra
//
//  Created by Konstantin Safronov on 21.10.2025.
//

import SwiftUI
import Combine

final class StyleService: ObservableObject {
  
  @AppStorage(AppStorageKeys.useTechnologyStyle) private var useTechnologyStyle: Bool = false
  
  private var cancellables: Set<AnyCancellable> = []
  
  var titleFont: Font {
    return useTechnologyStyle ? Font.custom("Technology-Bold", size: 20) : Font.subheadline.bold()
  }
  
  var descriptionFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Regular", size: 16) : Font.footnote
  }
  
  var controlsFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 18) : Font.headline
  }
  
  var largeTitleFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 36) : .largeTitle.bold()
  }
  
  var searchBarFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 20) : Font.subheadline.bold()
  }
  
  var pickerItemFont: Font {
    useTechnologyStyle ? Font.custom("Technology-Bold", size: 15) : Font.subheadline.bold()
  }
  
//  private func applyAppearance(isTech: Bool) {
//    setTitleAppearance(isDefault: !isTech)
//    setTabBarAppearance(isDefault: !isTech)
//    
//    DispatchQueue.main.async {
//      UIApplication.shared.connectedScenes
//        .compactMap { $0 as? UIWindowScene }
//        .flatMap { $0.windows }
//        .forEach { window in
//          print("reload")
//          window.rootViewController?.view.setNeedsLayout()
//          window.rootViewController?.view.layoutIfNeeded()
//        }
//    }
//  }
//  
//  private func setTitleAppearance(isDefault: Bool = false) {
//      let appearance = UINavigationBarAppearance()
//      print("setTitleAppearance \(isDefault)")
//      if isDefault {
//          appearance.configureWithDefaultBackground()
//      } else {
//          appearance.largeTitleTextAttributes = [
//              .font: UIFont(name: "Technology-Bold", size: 36)!
//          ]
//      }
//      UINavigationBar.appearance().standardAppearance = appearance
//      UINavigationBar.appearance().scrollEdgeAppearance = appearance
//  }
//  
//  private func setTabBarAppearance(isDefault: Bool = false) {
//    print("setTabBarAppearance \(isDefault)")
//    if isDefault {
//      let appearance = UITabBarAppearance()
//      appearance.configureWithDefaultBackground()
//      UITabBar.appearance().standardAppearance = appearance
//    } else {
//      let appearance = UITabBarAppearance()
//      appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
//        .font: UIFont(name: "Technology-Bold", size: 12)!
//      ]
//      appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
//        .font: UIFont(name: "Technology-Bold", size: 12)!
//      ]
//      
//      UITabBar.appearance().standardAppearance = appearance
//    }
//  }
  
}


