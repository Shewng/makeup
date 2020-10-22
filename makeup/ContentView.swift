//
//  ContentView.swift
//  makeup
//
//  Created by Shwong on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            InspoView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Inspo")
                }
            CameraView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("Camera")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
