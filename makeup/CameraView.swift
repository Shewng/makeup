//
//  CameraView.swift
//  makeup
//
//  Created by William Zhou on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI


var steps: [String] = ["Picture", "Video"]
var frameIndex = 0;

//helper to print for debugging
//https://stackoverflow.com/questions/56517813/how-to-print-to-xcode-console-in-swiftui
extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct CameraView: View {
    
    
    @ObservedObject var model = Model()
    @State private var isShowingImagePicker = false
    @State private var showCamera = false
    @State var condition = 1
    
    @State private var bareFaceImage = UIImage()
    
    var colors: [Color] = [.blue, .green, .red, .orange]
    
    func addFrame() {
        let id = model.frames.count + 1
        let image = UIImage()
        model.frames.append(Frame(id: id, name: "Frame\(id)", image: image))
    }
       
    
    
    var body: some View {
        
        VStack() {
            /*
             HStack(alignment: .center, spacing: 30) {
             ForEach(steps.indices) { x in
             Image(uiImage: self.bareFaceImage)
             .resizable()
             .scaledToFill()
             .frame(width:270, height: 300)
             .border(Color.black, width: 1)
             .clipped()
             .padding()
             }
             */
            
            HStack(alignment: .center, spacing: 30) {
                
                Print(type(of: model.frames))
            
                ForEach(model.frames, id: \.self) { x in
                    Image(uiImage: x.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width:270, height: 300)
                        .border(Color.black, width: 1)
                        .clipped()
                        .padding();

                }
                self.Print(model.frames[0].name)
                
                
                
            }.modifier(ScrollingHStackModifier(items: model.frames.count, itemWidth: 270, itemSpacing: 60))
            
            
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
                .sheet(isPresented: $isShowingImagePicker, content: {
                    ImagePickerView(isPresented: self.$isShowingImagePicker, selectedImage: self.$model.frames[frameIndex].image, flag: self.$condition)
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
                .sheet(isPresented: $showCamera, content: {
                    ImagePickerView(isPresented: self.$showCamera, selectedImage: self.$bareFaceImage, flag: self.$condition)
                })
                
                Button(action: {
                    print("Add was tapped")
                    self.addFrame()
                    
                    
                }) {
                    Image(systemName: "pencil.tip.crop.circle.badge.plus")
                        .font(.system(size: 40.0))
                        .foregroundColor(.gray)
                }
                
                
            }
        }
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    
    
    
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage
    @Binding var flag: Int
    
    var sourceType1: UIImagePickerController.SourceType = .photoLibrary
    var sourceType2: UIImagePickerController.SourceType = .camera
    
    func makeUIViewController(context:
        UIViewControllerRepresentableContext<ImagePickerView>) ->
        UIViewController {
            
            
            let controller = UIImagePickerController()
            if(flag == 1){
                controller.sourceType = sourceType1
            }
            else{
                controller.sourceType = sourceType2
                
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
            Frame(id: 2, name: "Frame2", image: b2),
        ]
    }
    
}
