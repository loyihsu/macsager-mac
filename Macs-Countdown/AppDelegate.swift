//
//  AppDelegate.swift
//  Macs-Countdown
//
//  Created by Loyi on 2019/7/8.
//  Copyright © 2019 Loyiworks. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    //MARK: - Initialize
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // Tags
    let expectedDays = Double(expect)
    var languagePos  = languageIndex.firstIndex(of: currentLanguage)!
    
    // Flags
    var titleAppear = timeAppearDefaults
    var targetDay: Date?
    
    // Some other configurable parts (tags) are in the `configuration.swift` file
    
    // MARK: - Dafaults
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusItem.title = ""
        
        // Setup the status bar image
        if let button = statusItem.button {
            let statusbarImage = NSImage(named: NSImage.Name("StatusBarButtonImage"))
            button.image = statusbarImage
        }
        
        // Create date from components
        let dateComponents = DateComponents.init(
            calendar: nil, timeZone: TimeZone.init(abbreviation: "GMT\(timezoneGMT)"), era: nil,
            year: dsgntDay[0], month: dsgntDay[1], day: dsgntDay[2], hour: dsgntDay[3], minute: dsgntDay[4], second: dsgntDay[5],
            nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil,
            weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        )
        targetDay = Calendar.current.date(from: dateComponents)
        
        constructMenu()
        
        // Setup a timer to keep it updated
        _ = Timer.scheduledTimer(
            timeInterval: 0.5, target: self, selector: #selector(self.update),
            userInfo: nil, repeats: true
        )
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    //MARK: - Main functions
    
    /// Construct the menu bar on click menu
    func constructMenu() {
        var menu = NSMenu()
        
        let quitItem = menuItemSetup(quitLOCA[languagePos], #selector(NSApplication.terminate(_:)), "", nil)
        let years    = menuItemSetup(deviceName, nil, "", 50)
        let equi     = menuItemSetup(itEqLOCA[languagePos], nil, "", 60)
        let dop      = menuItemSetup(dopLOCA[languagePos], nil, "", nil);
        let hid      = menuItemSetup(noNumLOCA[languagePos], #selector(self.hideDays), "", 10)
        
        addSeveralMenuItemToMenu(&menu, [quitItem, .separator(), years, equi, .separator(), dop, .separator(), hid])
        
        self.statusItem.menu = menu
    }
    
    /// Switch the hide days option on and off
    @objc func hideDays() {
        titleAppear = (statusItem.menu?.item(withTag: 10)?.state == .on) ? true : false
        statusItem.menu?.item(withTag: 10)?.state = (titleAppear == true) ? .off : .on
    }
    
    /// Update on each cycle
    @objc func update() {
        let time = ((targetDay?.timeIntervalSinceNow)!/86400).abs()
        
        statusItem.title = (titleAppear == true) ? " \(String(Int(time)))" : ""
        
        let percentage = (Double(Int(time))/expectedDays) * 100
        
        var leftdays = time
        
        let year:  Int = Int(leftdays / 365.25)
        leftdays       = Double(Int(leftdays) - Int(Double(year) * 365.25))
        let month: Int = Int(leftdays/30.44)
        leftdays       = Double(Int(leftdays) - Int(Double(month) * 30.44))
        
        let year_str  = (year == 1)     ? oneYearLOCA[languagePos]  : (year >= 2)     ? "\(year)\(severalYearsLOCA[languagePos])"         : ""
        let month_str = (month == 1)    ? oneMonthLOCA[languagePos] : (month >= 2)    ? "\(month)\(severalMonthsLOCA[languagePos])"       : ""
        var day_str   = (leftdays == 1) ? oneDayLOCA[languagePos]    : (leftdays >= 2) ? "\(Int(leftdays))\(severalDaysLOCA[languagePos])"  : brandNewLOCA[languagePos]
        if !(month_str == "" && year_str == "") { day_str = "\(andLOCA[languagePos])\(day_str)" }
        
        setItemTitleAt(tag: 50, title: "\(deviceName): \(String(Int(time))) (\(percentage.format(f: ".2"))%)")
        setItemTitleAt(tag: 60, title: "\(itsLOCA[languagePos])\(year_str)\(month_str)\(day_str)")
    }
    
    // MARK: - Make Life Easier
    
    func setItemTitleAt(tag: Int, title: String) {
        statusItem.menu?.item(withTag: tag)?.title = title
    }
    
    func addSeveralMenuItemToMenu(_ myMenu: inout NSMenu, _ items: [NSMenuItem]) {
        for i in items {
            myMenu.addItem(i)
        }
    }
    
    func menuItemSetup(_ title: String, _ action: Selector?, _ keyeq: String, _ tag: Int?) -> NSMenuItem {
        let output = NSMenuItem.init(title: title, action: action, keyEquivalent: keyeq)
        if let t = tag { output.tag = t }
        return output
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    
    func abs() -> Double {
        return (self < 0) ? self * -1 : self
    }
}

func dateFormatterForDSGNT() -> String {
    let year   = "\(dsgntDay[0])"
    let month  = (dsgntDay[1] < 10) ? "0\(dsgntDay[1])" : "\(dsgntDay[1])"
    let day    = (dsgntDay[2] < 10) ? "0\(dsgntDay[2])" : "\(dsgntDay[2])"
    return "\(year)-\(month)-\(day)"
}