//
//  Log.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 01/05/21.
//

import Foundation
import os

struct Log {
    
    private static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss" /* "hh:mm:ssSSS"  "yyyy-MM-dd hh:mm:ssSSS" */
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    private static func emoj(fileName: String)-> String {
        let logEmojis = ["😀","😎","😱","😈","👺","👽","👾","🤖","🎃","👍","👁","🧠","🎒","🧤","🐶","🐱","🐭","🐹","🦊","🐻","🐨","🐵","🦄","🦋","🌈","🔥","💥","⭐️","🍉","🥝","🌽","🍔","🍿","🎹","🎁","❤️","🧡","💛","💚","💙","💜","🔔"]
        return logEmojis[abs(fileName.hashValue % logEmojis.count)]
    }
    
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    
    static private func writeLog(_ text: String = "", levelEmoj:String, object: Any, functionName: String, fileName: String, lineNumber: Int) {
        let className = (fileName as NSString).lastPathComponent
        print("\(text) \(dateFormatter.string(from: Date())) \(levelEmoj) \(emoj(fileName: fileName)) \(object) ✒︎\(functionName) →\(className) #\(lineNumber)")
        
    }
    
    static func info(_ text: String = "", _ object: Any = "", functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        if isLoggingEnabled {
            writeLog(text, levelEmoj: "🟢", object: object, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        }
    }
    
    static func warning(_ text: String = "", _ object: Any = "", functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        if isLoggingEnabled {
            writeLog(text, levelEmoj: "🟡", object: object, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        }
    }
    
    static func error(_ text: String = "", _ object: Any = "", functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        writeLog(text, levelEmoj: "🔴", object: object, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
}

