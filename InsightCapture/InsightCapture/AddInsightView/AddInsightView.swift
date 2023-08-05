//
//  AddInsightView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI
import UniformTypeIdentifiers

struct AddInsightView: View {
    
    @ObservedObject var viewModel: AddInsightViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var isTitleFieldIsFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack{
                    VStack {
                        ZStack {
                            
                            HStack {
                                switch(viewModel.sourceType) {
                                case .url:
                                    ZStack {
                                        if !viewModel.isSourceContentLoaded {
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
                                        } else {
                                            ZStack(alignment: .bottomTrailing) {
                                                URLSourceView(image: viewModel.sourceImage!,
                                                              urlTitle: viewModel.sourceTitle,
                                                              urlString: viewModel.sourceUrl)
                                                .disabled(true)
                                                
                                                Button {
                                                    viewModel.isSourceContentLoaded = false
                                                    viewModel.sourceUrl = ""
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                }
                                                .foregroundColor(.black)
                                                .padding(.all, 8)
                                            }
                                        }
                                    }
                                    .padding(12)
                                    .background {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color(uiColor: UIColor(hex: "#F2F2F2")!))
                                    }
                                case .image:
                                    if !viewModel.isSourceContentLoaded {
                                        Button {
                                            viewModel.isImagePickerPresented.toggle()
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
                                    } else {
                                        ZStack(alignment: .bottomTrailing) {
                                            Image(uiImage: viewModel.sourceImage!)
                                                .resizable()
                                                .scaledToFill()
                                                .cornerRadius(18, corners: .allCorners)
                                                .frame(height: 96)
                                                .clipped()
                                            
                                            Button {
                                                viewModel.isSourceContentLoaded = false
                                                viewModel.sourceImage = nil
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                            }
                                            .foregroundColor(.black)
                                            .padding(.all, 8)
                                        }
                                    }
                                default :
                                    Text("Default")
                                }
                            }
                            
                            
                        }
                        .padding(.horizontal, 16)
                        //                        .padding(.top, 8)
                        
                        VStack (spacing: 4) {
                            TextField("", text: $viewModel.inputTitle)
                                .placeholder(when: viewModel.inputTitle.isEmpty) {
                                    Text("제목")
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
                                        Text("내용")
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
                   content: { ImagePicker(image: $viewModel.selectedImage)
                    .onDisappear {
                        viewModel.loadImage()
                    }
            })
        }
    }
}
