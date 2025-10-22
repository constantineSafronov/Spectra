//
//  AppFeature.swift.swift
//  Spectra
//
//  Created by Konstantin Safronov on 22.10.2025.
//

import ComposableArchitecture

@Reducer
struct AppFeature {
  struct State: Equatable {
    var settings = SettingsFeature.State()
  }
  
  enum Action {
    case settings(SettingsFeature.Action)
  }
  
  var body: some Reducer<State, Action> {
    Scope(state: \.settings, action: \.settings) {
      SettingsFeature()
    }
    Reduce { state, action in
      switch action {
      case .settings:
        return .none
      }
    }
  }
  
  public init() {}
}

