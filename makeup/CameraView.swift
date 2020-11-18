//
//  CameraView.swift
//  makeup
//
//  Created by William Zhou on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI
import AVFoundation
import AVKit

var steps: [String] = ["Picture", "Video"]
var imageIndex = 0;
var frameLength = 2;
var videos: [URL] = []

//helper to print for debugging
//https://stackoverflow.com/questions/56517813/how-to-print-to-xcode-console-in-swiftui
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}




struct TextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        
        myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.10)
        
        return myTextView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    class Coordinator : NSObject, UITextViewDelegate {
        
        var parent: TextView
        
        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}


struct CameraView: View {
    
    @ObservedObject var model = Model() // list of pictures/videos
    @State private var bareFaceImage = UIImage()
    @State private var bareFaceImageFinal = UIImage()
    @State private var stateVideos:[URL] = []
    @State private var isShowingImagePicker = false
    @State private var showCamera = false
    @State private var showVideoCam = false
    @State var condition = 1
    @State var isDisabled = false
    @State var alert = false
    @State private var currentStep = 0
    @State var backgroundOffset: CGFloat = 0
    
    
    @State var name = ""
    
    @Binding var tabSelection: Int
    
    func addFrame() {
        let id = model.frames.count + 1
        let image = UIImage()
        model.frames.append(Frame(id: id, name: "Frame\(id)", image: image))
        frameLength = model.frames.count
        print("After URL ", self.stateVideos)
    }
    
    func addVid(b:URL){
        
        stateVideos.append(b)
    }
    
    
    func useProxy(_ proxy: GeometryProxy) -> some View {
        
        var screenWidth: CGFloat = 0
        let screenHeight: CGFloat = 150
        
        if (self.model.frames.count == 1) {
            screenWidth = proxy.size.width * 0.89
        } else {
            screenWidth = proxy.size.width * 0.89
        }
        
        return VStack(alignment: .leading) {
            
            Text("Description")
                .font(.callout).bold()
            TextView(text: self.$name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: screenWidth, height: screenHeight)
        }
    }
    
    
    
    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
                
                ScrollView(.vertical) {
                    VStack(alignment: .center) {
                        
                        Spacer()
                        
                        // Description box
                        self.useProxy(geometry)
                        
                        Text("Insert Post pictures")
                        
                        
                        // START OF FRAMES
                        
                        
                        //ScrollView(.horizontal, showsIndicators: true) {
                            HStack(alignment: .center, spacing: 8) {
                                
                                
                                /*
                                 ForEach(self.model.frames, id: \.self) { x in
                                 //make a class that has a description box, frame and other things
                                 Image(uiImage: x.image)
                                 .resizable()
                                 .scaledToFill()
                                 .frame(width:270, height: 300)
                                 .border(Color.black, width: 1)
                                 .clipped()
                                 .padding();
                                 }*/
                                
                                Image(uiImage: self.bareFaceImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:300, height: 300)
                                    .border(Color.black, width: 1)
                                    .clipped()
                                    .padding(20);
                                
                                ForEach(stateVideos, id: \.self) { vid in
                                    //make a class that has a description box, frame and other things
                                    player(setURL: vid)
                                        .scaledToFill()
                                        .frame(width:300, height: 300)
                                        .border(Color.black, width: 1)
                                        .clipped()
                                        .padding(20);
                                }
                                
                                Image(uiImage: self.bareFaceImageFinal)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:300, height: 300)
                                    .border(Color.black, width: 1)
                                    .clipped()
                                    .padding(20);
                                
                            }
                            .modifier(ScrollingHStackModifier(items: stateVideos.count + 2, itemWidth: 300, itemSpacing: 50, currentStep: $currentStep))
                        
                        
                        HStack() {
                            Text("Step " + String(currentStep))
                        }.padding(5)
                        //}

                        
                        
                        //.modifier(ScrollingHStackModifier(items: self.model.frames.count, itemWidth: 270, itemSpacing: 60))
                        // END OF FRAMES
                        
                        // START OF BUTTONS
                        HStack(spacing: 40) {
                            
                            Button(action: {
                                self.isShowingImagePicker.toggle()
                                self.condition = 1
                                print("Upload was tapped")
                                
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.gray)
                            }
                            
                            //need to add a index to see which photo to upload to
                            .sheet(isPresented: self.$isShowingImagePicker, content: {
                                
                                ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$bareFaceImage, selectedImageFinal: self.$bareFaceImageFinal, flag: self.$condition, stateVideos: self.$stateVideos)
                            })
                            
                            
                            Button(action: {
                                print("Camera Was Tapped")
                                self.condition = 2
                                self.showCamera.toggle()
                            }) {
                                Image(systemName: "camera.circle")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.gray)
                            }
                            .sheet(isPresented: self.$showCamera, content: {
                                ImagePickerView(isPresented: self.$showCamera, selectedImage: self.$bareFaceImage, selectedImageFinal: self.$bareFaceImageFinal, flag: self.$condition, stateVideos: self.$stateVideos)
                            })
                            
                            
                            Button(action: {
                                print("Video camera Was Tapped")
                                self.condition = 3
                                self.showVideoCam.toggle()
                                self.alert.toggle()
                            }) {
                                Image(systemName: "video.circle")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.gray)
                            }
                            .sheet(isPresented: self.$showVideoCam, content: {
                                ImagePickerView(isPresented: self.$showVideoCam, selectedImage: self.$bareFaceImage, selectedImageFinal: self.$bareFaceImageFinal, flag: self.$condition, stateVideos: self.$stateVideos)
                                
                            })
         
                            Button(action: {
                                print("Add was tapped")
                                print("State", stateVideos)
                                self.addFrame()
                                
                                
                            }) {
                                Image(systemName: "chevron.right.circle")
                                    .font(.system(size: 40.0))
                                    .foregroundColor(.gray)
                            }
                        }
                        //END OF BUTTONS
                        Spacer()
                        self.useProxy(geometry)
                        Spacer()
                        
                    }.frame(maxWidth: .infinity)
                } // end of scroll view
                
                //VStack {s
                //    NavigationLink(destination: InspoView()) {
                //        Text("hello world");
                //    }
                //    NavigationLink(destination: InspoView()) {
                //        Text("YOYOYOYOOYOY");
                //    }
                //    NavigationLink(destination: InspoView()) {
                //        Text("TESTING THIS NOW!");
                //    }
                //
                //}
                .navigationBarTitle("Add new post", displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        HStack {
                            Button(action: {
                                self.tabSelection = 1
                            }) {
                                Text("Finish")
                            }
                            //NavigationLink(destination: InspoView(tabSelection: //self.$tabSelection)) {
                            //    Text("GAAAAAAAAAAA");
                            //}
                        }
                )
            } // end of nav bar
        }
    }
    
}



struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    @Binding var selectedImageFinal: UIImage
    @Binding var flag: Int
    @Binding var stateVideos:[URL]
    
    var sourceType1: UIImagePickerController.SourceType = .savedPhotosAlbum
    var sourceType2: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context:
                                UIViewControllerRepresentableContext<ImagePickerView>) ->
    UIViewController {
        
        let controller = UIImagePickerController()
        if (flag == 1) {
            controller.sourceType = sourceType1
        }
        
        if (flag == 2) {
            controller.sourceType = sourceType2
        }
        //video case
        if (flag == 3) {
            //controller.sourceType = sourceType2
            controller.mediaTypes = ["public.movie"]
        }
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        
        let parent: ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            print("ImageIndex" , imageIndex)
            //need to find index of frame
            //if index is 0 we set the first frame's image
            if (imageIndex == 0) {
                if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                    self.parent.selectedImage = selectedImageFromPicker
                }
            }
            
            //if on last frame
            if (imageIndex == (frameLength - 1)) {
                if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                    self.parent.selectedImageFinal = selectedImageFromPicker
                }
            }
        
            if let videoURL = info[.mediaURL] as? URL {
                videos.append(videoURL)
                self.parent.stateVideos.append(videoURL)
            }
            
            self.parent.isPresented = false
        }
        
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
}

//struct DummyView: UIViewRepresentable {
//    akeUIView(context: UIViewRepresentableContext<DummyView>) -> UIButton {
//        let button = UIButton()
//    func m
//        button.setTitle("DUMMY", for: .normal)
//        button.backgroundColor = .white
//        return button
//    }
//
//    func updateUIView(_ uiView: DummyView.UIViewType, context: UIViewRepresentableContext<DummyView>) {
//    }
//}

struct player : UIViewControllerRepresentable, Hashable {
    
    var setURL:URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<player>) -> AVPlayerViewController {
        frameLength += 1
        let controller = AVPlayerViewController()
        controller.videoGravity = .resizeAspectFill
        let player1 = AVPlayer(url: setURL)
        controller.player = player1
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<player>) {
        
    }
}


class Frame: NSObject {
    var id: Int
    var name: String
    var image: UIImage
    
    init(id: Int, name: String, image: UIImage) {
        self.id = id
        self.name = name
        self.image = image
    }
}

class Model: ObservableObject {
    @Published var frames: [Frame] = []
    @State var b1 = UIImage()
    @State var b2 = UIImage()
    
    init() {
        frames = [
            Frame(id: 1, name: "Frame1", image: b1),
            //Frame(id: 2, name: "Frame2", image: b2),
        ]
    }
}



struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CamPreviewWrapper();
    }
}

struct CamPreviewWrapper: View {
    @State(initialValue: 1) var code: Int
    
    var body: some View {
        CameraView(tabSelection: $code)
    }
}

