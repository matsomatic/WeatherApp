//
//  View+DismissKeyboard.swift
//  WeatherApp
//
//  Created by Mats Trovik on 30/03/2024.
//

import SwiftUI
import UIKit

extension View {
  func dismissKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
