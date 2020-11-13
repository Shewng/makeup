//
//  InspoView.swift
//  makeup
//
//  Created by William Zhou on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI

struct InspoView: View {
    
    
    @Binding var tabSelection: Int
    //@State var mainPicture: UIImage // make this binding later?
    
    @State var postArray = []
    //ForEach(self.model.frames, id: \.self) { x in
    //    //make a class that has a description box, frame and other things
    //    Image(uiImage: x.image)
    //        .resizable()
    //        .scaledToFill()
    //        .frame(width:270, height: 300)
    //        .border(Color.black, width: 1)
    //        .clipped()
    //        .padding();
    //
    //}
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack () {
                    Text("Inspo page!")
                }
            }
            .navigationBarTitle("Allure", displayMode: .large)
            
        }
    }
}

struct InspoView_Previews: PreviewProvider {
    static var previews: some View {
        InspPreviewWrapper();
        //InspoView(tabSelection: .constant(false))
    }
}

struct InspPreviewWrapper: View {
    @State(initialValue: 1) var code: Int
    
    var body: some View {
        InspoView(tabSelection: $code)
    }
}

class Post: ObservableObject {
    var pictures: [UIImage]
    var instructions: [String]
    var description: String
    
    init(pictures: [UIImage], instructions: [String], description: String) {
        self.pictures = pictures
        self.instructions = instructions
        self.description = description
    }
}

class PostList: ObservableObject {
    @Published var posts: [Post] = []
}
