//
//  FavoritesView.swift
//  Spectra
//
//  Created by Konstantin Safronov on 18.10.2025.
//

import SwiftUI

struct FavoritesView: View {
  
  @EnvironmentObject var style: StyleService
  
  var body: some View {
    ZStack(alignment: .topLeading) {
      Color.background
        .ignoresSafeArea()
      VStack(alignment: .leading) {
        Text(LocalizedStrings.Favorites.title.localized)
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
    FavoritesView()
  }
}


