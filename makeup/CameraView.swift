//
//  CameraView.swift
//  makeup
//
//  Created by William Zhou on 2020-10-21.
//  Copyright © 2020 Shwong. All rights reserved.
//

import SwiftUI

struct CameraView: View {
    var body: some View {
        HStack(spacing: 70){
            Button(action: {
                print("Camera Was Tapped")
            }) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 70.0))
                    .foregroundColor(.gray)
                    .offset(y: -35)
            }
            
            Button(action: {
                print("Upload Was Tapped")
            }) {
                Image(systemName: "camera.circle")
                    .font(.system(size: 70.0))
                    .foregroundColor(.gray)
                    
            }
            
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
