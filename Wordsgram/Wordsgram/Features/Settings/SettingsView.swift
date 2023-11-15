//
//  HomeScreen.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/03.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SettingsList()
                Spacer()
                
                Button(
                    action: saveCount,
                    label: {
                        Text("App Groups Test Button")
                            .modifier(MainButton(color: Color.red))
                    }
                )
                
                Button(
                    action: authService.signOut,
                    label: {
                        Text("Sign Out")
                            .modifier(MainButton(color: Color.red))
                    }
                )
            }
            .padding(20)
            .navigationTitle("Settings")
        }
    }
    
    private func saveCount() {
        UserDefaultsHelper.persistRecords(1)
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SettingsList: View {
    var body: some View {
        VStack(spacing: 0) {
            ForEach(SettingsOption.allCases) { self[$0] }
        }
    }
}

private extension SettingsList {
    @ViewBuilder subscript(option: SettingsOption) -> some View {
        switch option {
        case .settings1:
            SettingsDisclosureRow(title: option.title, value: "")
        case .settings2:
            SettingsDisclosureRow(title: option.title, value: "")
        case .settings3:
            NavigationLink(destination: EmptyView()) {
                SettingsDisclosureRow(title: option.title, value: "")
            }
        case .libraries:
            NavigationLink(destination: EmptyView()) {
                SettingsDisclosureRow(title: option.title, value: "")
            }
        }
    }
}

#Preview {
    Group {
        SettingsView()
        SettingsView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
    }
}
