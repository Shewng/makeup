//
//  ContentView.swift
//  makeup
//
//  Created by Shwong on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection: Int = 1
    
    var body: some View {
        TabView(selection: $tabSelection) {
            InspoView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Inspo")
                }
            .tag(1)
            CameraView(tabSelection: $tabSelection)
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Camera")
                }
            .tag(2)
        }.accentColor(.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
