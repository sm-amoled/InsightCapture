//
//  AddLogView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/07.
//

import SwiftUI
import LinkPresentation

struct AddLogView: View {
    
    @State private var urlString = "https://yuja-kong.tistory.com/202"
    @State private var url: URL?
    
    @State private var isUrlValid = false
    @State private var showUrlPreview = false
    
    @State private var image: Image?
    @State private var title = ""
    @State private var description = ""
    @State private var imageUrl = ""
    
    @State private var log = ""
    
    @Binding var showAddModal: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading,spacing: 8){
                HStack {
                    Text("URL")
                        .font(.callout)
                        .bold()
                        .padding(.leading, 8)
                    
                    Spacer()
                    
                    Button {
                        isUrlValid ? showUrlPreview.toggle() : nil
                    } label: {
                        Label("", systemImage: showUrlPreview ? "chevron.up" : "chevron.down")
                            .foregroundColor(isUrlValid ? .accentColor : .gray)
                    }

                }
                
                TextField("URL을 입력하세요", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    
                if(isUrlValid && showUrlPreview) {
                    URLPreview(previewURL: url!, togglePreview: .constant(true))
                        .aspectRatio(contentMode: .fit)
                }
                
                Text("My Insight")
                    .font(.callout)
                    .bold()
                    .padding(.leading, 8)
                

                TextField("인사이트를 기록하세요", text: $log, axis: .vertical)
                    .lineLimit(8, reservesSpace: true)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle(Text("Add Insight"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.showAddModal.toggle()
                    }) {
                        Text("Cancel").bold()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.showAddModal.toggle()
                    }) {
                        Text("Save").bold()
                    }
                }
            })
        }
        .onChange(of: urlString) { newValue in
            url = URL(string: urlString)
            isUrlValid = verifyUrl(urlString: urlString)
            showUrlPreview = isUrlValid ? true : false
        }
        
    }
    
//    func fetchData(from url: String) {
//        guard let url = URL(string: url) else { return }
//
//        let provider = LPMetadataProvider()
//        provider.startFetchingMetadata(for: url) { metaData, error in
//            if let error = error { return }
//            guard let data = metaData else { return }
//
//            print("DEBUG : ", data.self)
//
//            title = data.title ?? ""
//        }
//    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}

struct URLPreview : UIViewRepresentable {
    var previewURL:URL
    //Add binding
    @Binding var togglePreview: Bool
    
    func makeUIView(context: Context) -> LPLinkView {
        let view = LPLinkView(url: previewURL)
        
        let provider = LPMetadataProvider()
        
        provider.startFetchingMetadata(for: previewURL) { (metadata, error) in
            if let md = metadata {
                DispatchQueue.main.async {
                    view.metadata = md
                    view.sizeToFit()
                    
                    let s = String(describing: md.description)
                    print("DEBUG : Desc : ", s)
                    
                    self.togglePreview.toggle()
                }
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: LPLinkView, context: UIViewRepresentableContext<URLPreview>) {
    }
}

struct AddLogView_Previews: PreviewProvider {
    static var previews: some View {
        AddLogView(showAddModal: .constant(false))
    }
}
