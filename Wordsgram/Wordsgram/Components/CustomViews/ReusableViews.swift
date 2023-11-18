//
//  ReusableViews.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/08.
//

import SwiftUI

struct HeaderView: View {
    var title = "Title"
    var subtitle = "Subtitle"
    var desc = "Use this to..."
    
    init(_ title: String, subtitle: String, desc: String) {
        self.title = title
        self.subtitle = subtitle
        self.desc = desc
    }
    
    var body: some View {
        VStack(spacing: 15) {
            if !title.isEmpty {
                Text(title)
                    .font(.largeTitle)
            }
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .foregroundStyle(.gray)
            }
                
            if !desc.isEmpty {
                DescView(desc)
            }
        }
    }
}

struct DescView: View {
    var desc = "Use this to..."
    
    init(_ desc: String) {
        self.desc = desc
    }
    
    var body: some View {
        Text(desc)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gold)
            .foregroundStyle(.white)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView("Title", subtitle: "Subtitle", desc: "What does what")
            .previewLayout(.sizeThatFits)
    }
}

