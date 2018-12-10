//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

enum EventType {
    case Began_His_Shift
    case Fell_A_Sleep
    case Woke_Up
}
struct GuardEvent
{
    var year : Int
    var month : Int
    var day : Int
    var hour : Int
    var minute : Int
    var type : EventType
    var id : Int
    var index : Int
}

func print(guardevent: GuardEvent) {
    print("Guard", guardevent.id, "with index", guardevent.index, guardevent.type, "at", guardevent.year, "-", guardevent.month, "-", guardevent.day, "/", guardevent.hour, ":", guardevent.minute)
}

func SortGuardEvent(e1: GuardEvent, e2: GuardEvent) -> Bool {
    if (e1.year <= e2.year) {
        if (e1.month <= e2.month) {
            if (e1.day <= e2.day) {
                if (e1.hour <= e2.hour) {
                    if (e1.minute < e2.minute) {
                        return true
                    }
                }
            }
        }
    }
    return false
}

func aoc_day4() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 4")
    
    var guardevents : [GuardEvent] = []
    var asleep : [Int] = []
    var asleep_merged : [[Int]] = []
    var guardIndexToId : [Int] = []
    var globalGuardIndex : Int = 0
    var guardIdToIndexDb : [Int : Int] = [:]
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
                var guardevent = GuardEvent(year: Year as! Int, month: Month as! Int, day: Day as! Int, hour: Hour as! Int, minute: Minute as! Int, type: EventType.Began_His_Shift, id: -1, index: -1)
                if (Descr as! String) == "falls asleep" {
                    guardevent.type = EventType.Fell_A_Sleep
                } else if (Descr as! String) == "wakes up" {
                    guardevent.type = EventType.Woke_Up
                } else {
                    var id : Any = Int(0)
                    if Sscan(format: "Guard~#%I~begins~shift", line: Descr as! String, arg0: &id) {
                        guardevent.type = EventType.Began_His_Shift
                        guardevent.id = id as! Int
                        
                        // Give this guard a global index, first check if we already have seen this 'id'.
                        // If we have seen this guard before, give him his previous handed out index.
                        if let guardIndex = guardIdToIndexDb[guardevent.id] {
                            guardevent.index = guardIndex
                        } else {
                            guardevent.index = asleep.count
                            guardIdToIndexDb[guardevent.id] = guardevent.index
                            guardIndexToId.append(guardevent.id)
                            asleep.append(0)
                            asleep_merged.append( [Int](repeating: 0, count: 60) )
                        }
                    }
                }
                guardevents.append(guardevent)
            }
        }
    }
    
    // Sort guard events by time
    guardevents.sort {
        if ($0.year < $1.year) {
            return true
        } else if $0.year == $1.year {
            if ($0.month < $1.month) {
                return true
            } else if ($0.month == $1.month) {
                if ($0.day < $1.day) {
                    return true
                } else if ($0.day == $1.day) {
                    if ($0.hour < $1.hour) {
                        return true
                    } else if ($0.hour == $1.hour) {
                        if ($0.minute <= $1.minute) {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }

    // So here we have a correct time line and we now can create [0:00 to 0:59] collapsed hour view for every guard
    var guardId : Int = 0
    var guardIndex : Int = 0
    for i in 0...(guardevents.count - 1) {
        if guardevents[i].id != -1 {
            guardId = guardevents[i].id
            guardIndex = guardevents[i].index
        } else {
            guardevents[i].id = guardId
            guardevents[i].index = guardIndex
        }
        // print(guardevent: guardevents[i])
    }
    
    // Collect the amount of time a guard is asleep
    var asleep_at_minute : Int = 0
    for i in 0...(guardevents.count - 1) {
        if guardevents[i].type == EventType.Fell_A_Sleep {
            asleep_at_minute = guardevents[i].minute
        } else if guardevents[i].type == EventType.Woke_Up {
            let awoke_at_minute = guardevents[i].minute
            let guard_index = guardevents[i].index
            for m in asleep_at_minute...(awoke_at_minute-1) {
                asleep_merged[guard_index][m] += 1
            }
            asleep[guard_index] += awoke_at_minute - asleep_at_minute
        }
    }

    var asleep_the_most : Int = 0
    for i in 0...(asleep.count - 1) {
        if asleep[i] > asleep[asleep_the_most] {
            asleep_the_most = i
        }
    }
    
    var max_times : Int = 0
    var which_minute : Int = 0
    for (index, times)  in asleep_merged[asleep_the_most].enumerated() {
        if times > max_times {
            max_times = times
            which_minute = index
        }
    }

    print("    answer of part 1: ", "guard:", asleep_the_most, "sleeps", asleep[asleep_the_most], "minutes", "=>", guardIndexToId[asleep_the_most] * which_minute)
    print("")

    var minute_with_highest_sleep_count : Int = 0
    var minute_highest_sleep_count : Int = -1
    var guard_with_minute_that_has_highest_sleep_count : Int = -1
    for (guardindex, onguardhour) in asleep_merged.enumerated() {
        for minute in 0...59 {
            if onguardhour[minute] > minute_highest_sleep_count {
               minute_highest_sleep_count = onguardhour[minute]
               minute_with_highest_sleep_count = minute
                guard_with_minute_that_has_highest_sleep_count = guardIndexToId[guardindex]
            }
        }
    }

    
    print("    answer of part 2: ", guard_with_minute_that_has_highest_sleep_count * minute_with_highest_sleep_count)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

