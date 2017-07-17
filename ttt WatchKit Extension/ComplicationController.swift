//
//  ComplicationController.swift
//  ttt WatchKit Extension
//
//  Created by shinichi yamaguchi on 2017/07/12.
//  Copyright © 2017 shinichi yamaguchi. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
        
    }
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication,
                                                withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {
        // Extensionデリゲートからコンプリケーションデータを取得。
        var entry : CLKComplicationTimelineEntry?
        let now = NSDate()
        
        // テンプレートおよびタイムラインエントリを生成。
        if complication.family == .modularSmall {
            let textTemplate = CLKComplicationTemplateModularSmallSimpleText()
            textTemplate.textProvider = CLKSimpleTextProvider(text: "Test")
            // エントリの生成。
            entry = CLKComplicationTimelineEntry(date: now as Date, complicationTemplate: textTemplate)
        }
        else {
            // ... 他のコンプリケーションファミリーのエントリを設定。
        }
        
        // タイムラインエントリをClockKitに返却。
        handler(entry)
    }
    
}
