//
//  SettingsFeatureTests.swift
//  SpectraUnitTests
//
//  Created by Konstantin Safronov on 22.10.2025.
//

import XCTest
import ComposableArchitecture
@testable import Spectra

@MainActor
final class SettingsFeatureTests: XCTestCase {
  
  func testChangeTheme() async {
    let store = TestStore(
      initialState: SettingsFeature.State(appTheme: .dark),
      reducer: { SettingsFeature() }
    )
    await store.send(.setAppTheme(.system)) {
      $0.appTheme = .system
    }
    await store.send(.setAppTheme(.light)) {
      $0.appTheme = .light
    }
    await store.send(.setAppTheme(.dark)) {
      $0.appTheme = .dark
    }
  }
  
  func testToggleAuthorName() async {
    let store = TestStore(
      initialState: SettingsFeature.State(showAuthorName: false),
      reducer: { SettingsFeature() }
    )
    
    await store.send(.toggleShowAuthorName(true)) {
      $0.showAuthorName = true
    }
  }
  
  func testToggleDescription() async {
    let store = TestStore(
      initialState: SettingsFeature.State(showDescription: true),
      reducer: { SettingsFeature() }
    )
    
    await store.send(.toggleShowDescription(false)) {
      $0.showDescription = false
    }
  }
  
  func testToggleTechStyle() async {
    let store = TestStore(
      initialState: SettingsFeature.State(useTechnologyStyle: false),
      reducer: { SettingsFeature() }
    )
    
    await store.send(.toggleUseTechnologyStyle(true)) {
      $0.useTechnologyStyle = true
    }
  }
}
