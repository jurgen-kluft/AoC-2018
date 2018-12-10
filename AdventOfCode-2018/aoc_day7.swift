//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class Graph {
    
    class Node {
        var name : String = "?"
        var out : [Edge] = []
    }
    
    class Edge {
        var Src : Node = nil
        var Dst : Node = nil
    }

    var m_nodes : [Node] = []
    var m_char_to_value : [Character : Int] = [:]

    func AddRule(first: Character, after: Character) {

    }
    
    
    func Init() {
        for (i, l) in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated() {
            m_letter_to_value[l] = i
        }
    }
    
    func Play() -> Int {
        return 0
    }
}

func aoc_day7() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 7")
    
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day7.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            // Step P must be finished before step O can begin.
            var stepFirst : Any? = String("")
            var stepAfter : Any? = String("")
            if Sscan(format: "Step~%W~must~be~finished~before~step~%W~can~begin", line: statement, arg0: &stepFirst, arg1: &stepAfter) {
                
            }
        }
    }
    
    print("    answer of part 1: ", 0)
    print("")

    
    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

