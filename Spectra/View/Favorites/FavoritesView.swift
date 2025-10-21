//
//  FavoritesView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 18.10.2025.
//

import SwiftUI

struct FavoritesView: View {
  
  private let model: FavoritesModel
  @EnvironmentObject var style: StyleService
  
  init(model: FavoritesModel) {
    self.model = model
  }
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background
        .ignoresSafeArea()
      VStack(alignment: .leading) {
        Text("Favorites")
          .foregroundColor(.text)
          .font(style.largeTitleFont)
          .padding(.top, 20.0)
          .padding(.leading, 20.0)
        SingleColumnGridView()
      }
    }
  }
  
}

// MARK: - Preview
struct FavoritesView_Previews: PreviewProvider {
  static var previews: some View {
    FavoritesView(model: FavoritesModel())
  }
}


