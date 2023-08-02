//
//  AddInsightView.swift
//  InsightCapture
//
//  Created by Park Sungmin on 2023/03/28.
//

import SwiftUI

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
                                TextField("", text: $viewModel.sourceUrl)
                                    .placeholder(when: viewModel.sourceUrl.isEmpty) {
                                        Text("URL을 붙여넣어주세요.")
                                            .foregroundColor(.gray)
                                        
                                    }
                                Button {
                                    print("Button Tapped")
                                } label: {
                                    Image(systemName: "doc.on.clipboard")
                                }
                                .foregroundColor(.black)
                            }
                            .padding(12)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(uiColor: UIColor(hex: "#F2F2F2")!))
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        
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
                        .padding(.horizontal, 16)
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
                        print("Press Save Button")
                    } label: {
                        Text("저장")
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}
