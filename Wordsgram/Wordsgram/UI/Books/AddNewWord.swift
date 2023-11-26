//
//  AddNewWord.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import SwiftUI

struct AddNewWord: View {
  let book: Book
  @State private var word = NSMutableAttributedString(string: "")
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject private var coordinator: BookCoordinator
  @EnvironmentObject private var wordCoordinator: WordCoordinator
  
  var body: some View {
    NavigationView {
      ContentView(book: book)
        .navigationTitle("Add New Word")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            RedButton(title: "Close") {
              dismiss()
            }
          }
          
          ToolbarItem(placement: .topBarTrailing) {
            RedButton(title: "Save") {
              let word = NewWord(word: word.string)
              word.book = book
              do {
                try wordCoordinator.create(words: [word])
                book.words.append(word)
                //try coordinator.create(books: [book])
                try wordCoordinator.create(words: [word])
              } catch {
                print(error.localizedDescription)
              }
              
              dismiss()
            }
          }
        }
    }
  }
}



struct ContentView: View {
  let book: Book
  @EnvironmentObject private var wordCoordinator: WordCoordinator
  
  // MARK: Segment Value
  @State var alignmentValue: Int = 1
  // MARK: Text Value
  @State var text: String = ""
  var body: some View {
    
    VStack{
      // TagView or ScrollView
      //TagView(alignment: alignmentValue == 0 ? .leading : alignmentValue == 1 ? .center : .trailing, spacing: 10){
      ScrollView {
        ForEach(book.words) { word in
          // MARK: New Toggle API
          Text(word.word)
        }
      }
      .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6), value: alignmentValue)
      
      Spacer()
      
      HStack{
        TextField("Word", text: $text,axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .lineLimit(1)
        
        Button("Add"){
          withAnimation(.spring()){
            let word = NewWord(word: text)
            word.book = book
            text = ""
            do {
              try wordCoordinator.create(words: [word])
              book.words.append(word)
              //try coordinator.create(books: [book])
              try wordCoordinator.create(words: [word])
            } catch {
              print(error.localizedDescription)
            }
          }
        }
        .buttonStyle(.bordered)
        .buttonBorderShape(.roundedRectangle(radius: 4))
        .tint(.red)
        .disabled(text == "")
      }
    }
    //.shadow(color: .red, radius: 2)
    .padding(15)
  }
  
}

// MARK: Building Custom Layout With The New Layout API
struct TagView: Layout {
  var alignment: Alignment = .center
  var spacing: CGFloat = 10
  // New Xcode Will Type All Init By Default
  // Simply Type init
  init(alignment: Alignment, spacing: CGFloat) {
    self.alignment = alignment
    self.spacing = spacing
  }
  
  //  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
  //    // Returning Default Proposal Size
  //    return .init(width: proposal.width ?? 0, height: proposal.height ?? 0)
  //  }
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    // 初始尺寸
    var totalHeight: CGFloat = 0
    var currentWidth: CGFloat = 0
    var maxHeightInRow: CGFloat = 0
    
    for subview in subviews {
      let subviewSize = subview.sizeThatFits(proposal)
      if currentWidth + subviewSize.width > proposal.width ?? CGFloat.infinity {
        // 新的一行
        totalHeight += maxHeightInRow + spacing
        currentWidth = 0
        maxHeightInRow = 0
      }
      
      currentWidth += subviewSize.width + spacing
      maxHeightInRow = max(maxHeightInRow, subviewSize.height)
    }
    
    totalHeight += maxHeightInRow // 添加最后一行的高度
    return CGSize(width: proposal.width ?? 0, height: totalHeight)
  }
  
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    // MARK: Placing View
    // I'm Going to Build it in Two Ways
    // One is Simple Without Customisation
    // Another One With Customisation
    
    // Note Use Origin
    // Since Origin Will Start From Applied Padding From Parent View
    var origin = bounds.origin
    let maxWidth = bounds.width
    
    // MARK: Type 2
    var row: ([LayoutSubviews.Element],Double) = ([],0.0)
    var rows: [([LayoutSubviews.Element],Double)] = []
    
    for view in subviews{
      let viewSize = view.sizeThatFits(proposal)
      if (origin.x + viewSize.width + spacing) > maxWidth{
        // This Will Give How Much Space Remaining In a Row
        row.1 = (bounds.maxX - origin.x + bounds.minX + spacing)
        rows.append(row)
        row.0.removeAll()
        // Resetting Horizontal Axis
        origin.x = bounds.origin.x
        // Next View
        row.0.append(view)
        origin.x += (viewSize.width + spacing)
      }else{
        row.0.append(view)
        origin.x += (viewSize.width + spacing)
      }
    }
    
    // MARK: Exhaust Ones
    if !row.0.isEmpty{
      row.1 = (bounds.maxX - origin.x + bounds.minX + spacing)
      rows.append(row)
    }
    
    // MARK: Resetting Origin
    origin = bounds.origin
    
    for row in rows {
      // Resetting X Origin For New Row
      origin.x = (alignment == .leading ? bounds.minX : (alignment == .trailing ? row.1 : row.1 / 2))
      for view in row.0{
        let viewSize = view.sizeThatFits(proposal)
        view.place(at: origin, proposal: proposal)
        origin.x += (viewSize.width + spacing)
      }
      // Max Height In the Row
      let maxHeight = row.0.compactMap { view -> CGFloat? in
        return view.sizeThatFits(proposal).height
      }.max() ?? 0
      // Updating Vertical Origin
      origin.y += (maxHeight + spacing)
    }
  }
}
