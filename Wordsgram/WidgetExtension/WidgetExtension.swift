//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Kane on 2023/11/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), count: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(
            date: Date(),
            count: UserDefaultsHelper.getRecordsCount())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        //    Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            if let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) {
                let entry = SimpleEntry(
                    date: entryDate,
                    count: UserDefaultsHelper.getRecordsCount())
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//}
struct SimpleEntry: TimelineEntry {
    var date: Date
    let count: Int
    //  let latest: String
}

struct WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
            //
            //            Text("Favorite Emoji:")
            //            Text(entry.configuration.favoriteEmoji)
            Text("Today Learned")
                .bold()
            
            Text("\(entry.count)")
        }
        .containerBackground(for: .widget) {
            Color.red
        }
    }
}

struct WidgetExtension: Widget {
    let kind: String = "WidgetExtension"
    
    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            WidgetExtensionEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    WidgetExtension()
} timeline: {
    //    SimpleEntry(date: .now, configuration: .smiley)
    //    SimpleEntry(date: .now, configuration: .starEyes)
    SimpleEntry(date: .now, count: 1)
    SimpleEntry(date: .now, count: 2)
}
