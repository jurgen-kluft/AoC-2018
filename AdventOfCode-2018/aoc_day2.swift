//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

func aoc_day2() -> Void {
 
    // ----------------------------------------------------------------------------------------------------------------------------
    // Day 2
    var ids: [String] = []
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day2.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            //print(line)
            ids.append(line)
        }
    }

    var total2s: Int = 0
    var total3s: Int = 0
    for id in ids {
        var ccountdb = [Character: Int32]()
        for c in id {
            if let ccount = ccountdb[c] {
                ccountdb[c] = ccount + 1
            } else {
                ccountdb[c] = 1
            }
        }
        var id2s : Int = 0
        var id3s : Int = 0
        for (_, cc) in ccountdb {
            if (cc == 2) {
                id2s += 1
            }
            if (cc == 3) {
                id3s += 1
            }
        }
        
        if id2s > 0 {
            total2s += 1
        }
        if id3s > 0 {
            total3s += 1
        }
    }

    print("Day 2 answer of part 1: ", total2s * total3s)

    var matchingid : String = "?"
    var idmatchdb = [String: Int]()
    var idindex : Int = 0

    search_matching_id: for id in ids {
        
        for n in 0...(id.count-1) {
            var shortenedid : String = id
            shortenedid.remove(at: String.Index(encodedOffset: n))
            print(id, " => ",shortenedid)
            if let shortened_idindex = idmatchdb[shortenedid] {
                if shortened_idindex != idindex {
                    // Here we already have an entry that is not part of the current id
                    matchingid = shortenedid
                    break search_matching_id
                }
            } else {
                idmatchdb[shortenedid] = idindex
            }
        }
        
        idindex += 1
    }

    print("Day 2 answer of part 2: ", matchingid)
    // wrong: ioenxmfkezbcjpdgwvraqhluz
    // 2nd try: iosnxmfkpabcjpdywvrtahluy

    // ----------------------------------------------------------------------------------------------------------------------------
}

