//
//  ContentView.swift
//  moody
//
//  Created by 김두리 on 2021/06/18.
//

import SwiftUI
import CoreData

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            Home()
                .navigationBarTitle("Filter")
                .preferredColorScheme(.dark)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
