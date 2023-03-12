//
//  ContentView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/07.
//

import SwiftUI

struct ContentView: View {
    @State private var showAddModal = false
    @State private var showImagePicker = false
    
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            Button {
                showAddModal.toggle()
            } label: {
                Text("Add Insight")
                    .frame(height: 50)
            }
            
            Button {
                showImagePicker.toggle()
            } label: {
                Text("Add Image")
                    .frame(height: 50)
            }
            
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: 100, height: 100)
            }
        }
        .padding()
        .sheet(isPresented: $showAddModal) {
            AddLogView(showAddModal: $showAddModal)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $image)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
