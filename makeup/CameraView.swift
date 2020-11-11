//
//  CameraView.swift
//  makeup
//
//  Created by William Zhou on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//
// YOURE A AAAAAAAALKJNSDBOIUWEBNFOINWFGIN ERFJN DRGNLKXREGD

import SwiftUI


var steps: [String] = ["Picture", "Video"]
var imageIndex = 0;
var frameLength = 2;
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
    
    
    @ObservedObject var model = Model()
    @State private var bareFaceImage = UIImage()
    @State private var isShowingImagePicker = false
    @State private var showCamera = false
    @State private var showVideoCam = false
    @State var condition = 1
    @State var isDisabled = false
    
    @State var name = ""
    
    //var screenWidth: CGFloat = 0
    //var screenHeight: CGFloat = 0
    var colors: [Color] = [.blue, .green, .red, .orange]
    
    
    func addFrame() {
        let id = model.frames.count + 1
        let image = UIImage()
        model.frames.append(Frame(id: id, name: "Frame\(id)", image: image))
        frameLength = model.frames.count
    }
    
    func useProxy(_ proxy: GeometryProxy) -> some View {
        
        var screenWidth: CGFloat = 0
        let screenHeight: CGFloat = 150
        
        if (self.model.frames.count == 1) {
            screenWidth = proxy.size.width * 0.89
        } else {
            screenWidth = proxy.size.width * 0.89// / CGFloat(self.model.frames.count)
        }
        
        return VStack(alignment: .leading) {
            Text("Description")
                .font(.callout).bold()
            TextView(text: self.$name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: screenWidth, height: screenHeight)
            
            //.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            
            NavigationView {
            
            ScrollView(.vertical) {
                VStack(alignment: .center) {
                    
                    // Description box
                    self.useProxy(geometry)
                    
                    Text("Insert Post pictures")
                    
                    // START OF FRAMES
                    HStack(alignment: .center, spacing: 30) {
                        self.Print(type(of: self.model.frames))
                        
                        ForEach(self.model.frames, id: \.self) { x in
                            //make a class that has a description box, frame and other things
                            Image(uiImage: x.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width:270, height: 300)
                                .border(Color.black, width: 1)
                                .clipped()
                                .padding();
                            
                        }
                        
                        self.Print(self.model.frames[0].name)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .modifier(ScrollingHStackModifier(items: self.model.frames.count, itemWidth: 270, itemSpacing: 60))
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
                                
                                ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$model.frames[imageIndex].image, flag: self.$condition)
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
                            ImagePickerView(isPresented: self.$showCamera, selectedImage: self.$model.frames[imageIndex].image, flag: self.$condition)
                        })
                        
                        
                        Button(action: {
                            print("Video camera Was Tapped")
                            self.condition = 3
                            self.showVideoCam.toggle()
                        }) {
                            Image(systemName: "video.circle")
                                .font(.system(size: 40.0))
                                .foregroundColor(.gray)
                        }
                        .sheet(isPresented: self.$showVideoCam, content: {
                            ImagePickerView(isPresented: self.$showVideoCam, selectedImage: self.$bareFaceImage, flag: self.$condition)
                        })
                        
                        
                        Button(action: {
                            print("Add was tapped")
                            self.addFrame()
                            
                            
                        }) {
                            Image(systemName: "chevron.right.circle")
                                .font(.system(size: 40.0))
                                .foregroundColor(.gray)
                        }
                    }
                    //END OF BUTTONS
                    
                    Spacer().frame(height: 50)
                }.frame(maxWidth: .infinity)
            } // end of scroll view
            } // end of nav ba
        }
    }
    
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    @Binding var flag: Int
    
    var sourceType1: UIImagePickerController.SourceType = .savedPhotosAlbum
    var sourceType2: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context:
        UIViewControllerRepresentableContext<ImagePickerView>) ->
        UIViewController {
            
            
            let controller = UIImagePickerController()
            if (flag == 1) {
                controller.sourceType = sourceType1
            } else if (flag == 2) {
                controller.sourceType = sourceType2
            }
            else {
                controller.sourceType = sourceType2
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
            if let selectedImageFromPicker = info[.originalImage] as? UIImage {
                print(selectedImageFromPicker)
                self.parent.selectedImage = selectedImageFromPicker
            }
            
            self.parent.isPresented = false
        }
        
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
}

struct DummyView: UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<DummyView>) -> UIButton {
        let button = UIButton()
        button.setTitle("DUMMY", for: .normal)
        button.backgroundColor = .white
        return button
    }
    
    func updateUIView(_ uiView: DummyView.UIViewType, context: UIViewRepresentableContext<DummyView>) {
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
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
