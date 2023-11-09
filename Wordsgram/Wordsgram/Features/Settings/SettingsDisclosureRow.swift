//
//  SettingsDisclousureRow.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/09.
//

import SwiftUI

struct SettingsDisclosureRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title).padding(.vertical, 11)
                Spacer()
                Text(value)
                
                Image(systemName: "chevron.right")
            }
            
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
        }
    }
}

//struct SettingsDisclosureRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsDisclosureRow(title: "Disclosure", value: "HELLO")
//            .padding()
//            .background(Color.background)
//            .inAllColorSchemes
//    }
//}

