//
//  InspoView.swift
//  makeup
//
//  Created by William Zhou on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI

struct InspoView: View {
    
    @ObservedObject var postList = PostList()
    
    @Binding var tabSelection: Int
    
    let posts: [Post] = []
    
    @State var postArray = []
    //@Binding var postArray: [Post1]
    
    var body: some View {
        NavigationView {
            List {
                ScrollView(.vertical) {
                    VStack () {
                        NavigationLink(destination: CameraView(tabSelection: $tabSelection, postArray: $postArray)) {
                            Text("Somehow add this feature to images.")
                        }
                        
                    }
                }

                ForEach(postArray, id: (\.id as AnyObject)) { post in
                    PostView(post: post as! Post)
                }
                
                
                //ForEach(postArray, id: (\.id as AnyObject)) { post in
                //  PostView(post1: post as! Post1)
                
                //ForEach(posts, id: \.id) { post in
                //    PostView(post: post)
                //}
                
            }
            .navigationBarTitle(Text("Allure"))
            
        }
        
    }
}

struct PostView: View {
    
    let post: Post
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("This will be images afterwards! Need to add extra text here just to test spacing/padding problems").lineLimit(nil).padding(.leading, 16).padding(.trailing, 32)
            Text("Passing variables into title: " + post.title)
            Text("Passing variables in: " + post.desc)
            Text("Passing variables in: id = " + String(post.id))
        }.padding(.leading, -20)
    }
}


struct InspoView_Previews: PreviewProvider {
    static var previews: some View {
        InspPreviewWrapper();
    }
}

struct InspPreviewWrapper: View {
    @State(initialValue: 1) var code: Int
    
    var body: some View {
        InspoView(tabSelection: $code)
    }
}

//struct Post {
//    let id: Int
//    let title, description: String
//}


class Post: NSObject {
    
    var id: Int
    var firstPic: UIImage
    var lastPic: UIImage
    var instructions: [String]
    var title: String
    var desc: String

    init(id: Int, firstPic: UIImage, lastPic: UIImage, instructions: [String], title: String, desc: String) {
        self.id = id
        self.firstPic = firstPic
        self.lastPic = lastPic
        self.instructions = instructions
        self.title = title
        self.desc = desc
    }
}

class PostList: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        posts = []
    }
}
