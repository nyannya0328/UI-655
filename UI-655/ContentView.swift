//
//  ContentView.swift
//  UI-655
//
//  Created by nyannyan0328 on 2022/08/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
