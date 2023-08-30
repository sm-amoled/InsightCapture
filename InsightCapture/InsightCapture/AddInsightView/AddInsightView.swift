//
//  AddInsightView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddInsightView: View {
    
    @StateObject var viewModel: AddInsightViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTitleFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    VStack {
                        HStack {
                            switch(viewModel.sourceType) {
                            case .url:
                                ZStack {
                                    if !viewModel.isSourceContentLoaded {
                                        HStack {
                                            TextField("", text: $viewModel.sourceUrl)
                                                .placeholder(when: viewModel.sourceUrl.isEmpty) {
                                                    Text("URL을 붙여넣어주세요.")
                                                        .foregroundColor(.gray)
                                                }
                                                .onChange(of: viewModel.sourceUrl) { newValue in
                                                    viewModel.checkUrlInput()
                                                }
                                            
                                            if viewModel.isFetchingData {
                                                ProgressView().frame(width: 16, height: 16)
                                            } else {
                                                Button {
                                                    if let read = UIPasteboard.general.string {
                                                        if !read.isEmpty {
                                                            viewModel.sourceUrl = read  // <-- here
                                                        } else {
                                                            print("복사된 텍스트가 없음")
                                                        }
                                                    }
                                                } label: {
                                                    Image(systemName: "doc.on.clipboard")
                                                }
                                                .foregroundColor(.black)
                                            }
                                        }
                                        .padding(12)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(uiColor: UIColor(hex: "#F2F2F2")!))
                                        }
                                    }
                                    else {
                                        ZStack(alignment: .bottomTrailing) {
                                            CardURLSourceView(image: viewModel.sourceImage!,
                                                              urlTitle: viewModel.sourceTitle,
                                                              urlString: viewModel.sourceUrl)
                                            
                                            Button {
                                                viewModel.isSourceContentLoaded = false
                                                viewModel.sourceUrl = ""
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                            }
                                            .foregroundColor(.black)
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 16)
                                        }
                                    }
                                }
                                
                            case .image:
                                if !viewModel.isSourceContentLoaded {
                                    Button {
                                        viewModel.tapImageLoadButton()
                                    } label : {
                                        HStack {
                                            Spacer()
                                            Text("사진을 선택해주세요")
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                            Image(uiImage: UIImage(systemName: "photo.on.rectangle.angled")!)
                                                .foregroundColor(.black)
                                        }
                                        .padding(12)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(uiColor: UIColor(hex: "#F2F2F2")!))
                                        }
                                    }
                                }
                                else {
                                    ZStack(alignment: .bottomTrailing) {
                                        Image(uiImage: viewModel.sourceImage!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: 96)
                                        
                                        Button {
                                            viewModel.isSourceContentLoaded = false
                                            viewModel.sourceImage = nil
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                        }
                                        .foregroundColor(.black)
                                        .padding(.all, 8)
                                    }
                                    .cornerRadius(18, corners: .allCorners)
                                    .clipped()
                                }
                                
                            case .quote:
                                HStack(alignment: .center) {
                                    TextField("", text: $viewModel.sourceQuote, axis: .vertical)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(4)
                                        .placeholder(when: viewModel.sourceQuote.isEmpty) {
                                            Text("인용구를 붙여넣어주세요.")
                                                .foregroundColor(.gray)
                                        }
                                    
                                    Button {
                                        if let read = UIPasteboard.general.string {
                                            if !read.isEmpty {
                                                viewModel.sourceQuote = read  // <-- here
                                            } else {
                                                print("복사된 텍스트가 없음")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "doc.on.clipboard")
                                    }
                                    .foregroundColor(.black)
                                }
                                .padding(12)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color(uiColor: UIColor(hex: "#F2F2F2")!))
                                }
                                
                            case .brain:
                                ZStack{}
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        VStack (spacing: 4) {
                            TextField("", text: $viewModel.inputTitle)
                                .placeholder(when: viewModel.inputTitle.isEmpty) {
                                    Text(viewModel.titlePlaceholderText)
                                        .font(Font.system(size: 15, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                                .font(Font.system(size: 15, weight: .medium))
                                .padding(.bottom, 4)
                            
                            Divider()
                            
                            
                            TextEditor(text: $viewModel.inputContent)
                                .scrollContentBackground(.hidden)
                                .offset(x: -5)
                                .placeholder(when: viewModel.inputContent.isEmpty) {
                                    VStack{
                                        Text(viewModel.contentPlaceholderText)
                                            .font(Font.system(size: 15, weight: .medium))
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .offset(y: 8)
                                }
                                .font(Font.system(size: 15, weight: .medium))
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .navigationTitle(Text("인사이트 남기기"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Press X Mark")
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.tapSaveButton()
                        dismiss()
                    } label: {
                        Text("저장")
                    }
                    .foregroundColor(.black)
                }
            }
            .sheet(isPresented: $viewModel.isImagePickerPresented,
                   content: {
                ImagePicker(image: $viewModel.selectedImage)
                    .onDisappear {
                        viewModel.loadImage()
                    }
            })
        }
    }
}
