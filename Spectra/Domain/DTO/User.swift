//
//  User.swift
//  Spectra
//
//  Created by Konstantin Safronov on 08.01.2026.
//

import Foundation

struct User: Codable, Equatable, Hashable {
  let id: String
  let name: String
  let username: String
}
