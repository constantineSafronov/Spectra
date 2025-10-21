//
//  CategoryPicker.swift
//  Spectra
//
//  Created by Konstantin Safronov on 17.10.2025.
//

import SwiftUI
import UIKit

struct CategoryPicker: View {
  
  @Binding var selectedCategory: Category
  @EnvironmentObject var style: StyleService
  @AppStorage(AppStorageKeys.useTechnologyStyle) private var useTechnologyStyle: Bool = false
  
  var body: some View {
    ZStack {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16.0) {
          ForEach(Category.allCases, id: \.self) { category in
            Button {
              self.selectedCategory = category
            } label: {
              buttonLabelForCategory(category)
            }
          }
        }
      }
    }
    .frame(height: 30.0)
  }
  
  private func buttonLabelForCategory(_ category: Category) -> some View {
    ZStack {
      if category == selectedCategory {
        Color.accessory
          .cornerRadius(6.0)
        Text(category.rawValue)
          .foregroundColor(.invertedAccessory)
          .font(style.pickerItemFont)
          .padding(.all, 8.0)
          .padding(.top, useTechnologyStyle ? 3.0 : 0.0)
      } else {
        Color.accessory
          .cornerRadius(6.0)
        Color.invertedAccessory
          .cornerRadius(6.0)
          .padding(.all, 2.0)
        Text(category.rawValue)
          .foregroundColor(.text)
          .font(style.pickerItemFont)
          .padding(.all, 8.0)
          .padding(.top, useTechnologyStyle ? 3.0 : 0.0)
      }
    }
  }
  
}

#Preview {
  FeedView(model: FeedModel())
}
