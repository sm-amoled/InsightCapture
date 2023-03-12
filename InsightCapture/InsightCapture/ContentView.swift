//
//  ContentView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/07.
//

import SwiftUI

struct ContentView: View {
    @State private var showAddModal = false
    var body: some View {
        VStack {
            Button {
                showAddModal.toggle()
            } label: {
                Text("Add Insight")
            }

        }
        .padding()
        .sheet(isPresented: $showAddModal) {
            AddLogView(showAddModal: $showAddModal)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
