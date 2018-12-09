//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

enum EventType {
    case Begins
    case Sleep
    case Awake
}
struct GuardEvent
{
    var year : Int
    var month : Int
    var day : Int
    var hour : Int
    var minute : Int
    var type : EventType
    var ID : Int
}

func print(guardevent: GuardEvent) {
    print("Guard", guardevent.ID, guardevent.type, "at", guardevent.year, "-", guardevent.month, "-", guardevent.day, "/", guardevent.hour, ":", guardevent.minute)
}

func aoc_day4() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 4, part 1")
    
    var events : [GuardEvent] = []
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day4.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {

            // Input Examples:
            // [1518-10-03 00:47] falls asleep
            // [1518-07-26 23:50] Guard #487 begins shift
            // [1518-06-22 00:48] wakes up

            var Year : Any = Int(0)
            var Month : Any? = Int(0)
            var Day : Any? = Int(0)
            var Hour : Any? = Int(0)
            var Minute : Any? = Int(0)
            var Descr : Any? = String("")
            if Sscan(format: "[%I-%I-%I~%I:%I]~%S", line: line, arg0: &Year, arg1: &Month, arg2: &Day, arg3: &Hour, arg4: &Minute, arg5: &Descr) {
                var event = GuardEvent(year: Year as! Int, month: Month as! Int, day: Day as! Int, hour: Hour as! Int, minute: Minute as! Int, type: EventType.Begins, ID: 0)
                if (Descr as! String) == "falls asleep" {
                    event.type = EventType.Sleep
                } else if (Descr as! String) == "wakes up" {
                    event.type = EventType.Awake
                } else {
                    var ID : Any = Int(0)
                    if Sscan(format: "Guard~#%I~begins~shift", line: Descr as! String, arg0: &ID) {
                        event.type = EventType.Begins
                        event.ID = ID as! Int
                    }
                }
                print(guardevent: event)
                events.append(event)
            }
        }
    }


    print("    answer of part 1: ", 0)
    print("")


    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

