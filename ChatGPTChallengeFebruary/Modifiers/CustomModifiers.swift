//
//  CustomModifiers.swift
//  ChatGPTChallengeFebruary
//
//  Created by Jakub Plachy on 04.02.2025.
//


import Foundation
import SwiftUI

        struct NavigationBarColorModifier: ViewModifier {
            func body(content: Content) -> some View {
                content
                    .foregroundStyle(.white)
            }
        }

        extension View {
            func navigationBarColorModifier() -> some View {
                self.modifier(NavigationBarColorModifier())
            }
        }

