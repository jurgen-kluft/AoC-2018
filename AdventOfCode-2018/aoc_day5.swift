//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

struct Unit {
    var prev : Int
    var next : Int
    var type : Int16
    var charge : Int8
}

class Polymer {
    var m_polymer : [Unit] = []

    func Init(string: String) {
        // Add a dummy head and tail unit to the polymer to not have to deal with empty prev/next
        m_polymer.append(Unit(prev: 0, next: 0, type : 0, charge : 0))
        for (_, c) in string.enumerated() {
            m_polymer.append(Unit(prev: 0, next: 0, type : CharacterToType(c: c), charge: CharacterToCharge(c: c)))
        }
        m_polymer.append(Unit(prev: 0, next: 0, type : 0, charge : 0))
        
        Reset()
    }
    
    func React() -> Void {
        var still_reacting : Bool = true
        while still_reacting {
            still_reacting = false
            var this : Int = 0
            while this < (m_polymer.count - 1) {
                let next : Int = m_polymer[this].next
                if m_polymer[this].charge != m_polymer[next].charge && m_polymer[this].type == m_polymer[next].type {
                    // React by removing both from the polymer
                    still_reacting = true
                    let prev : Int = m_polymer[this].prev
                    let nextnext : Int = m_polymer[next].next
                    m_polymer[prev].next = nextnext;
                    m_polymer[nextnext].prev = prev
                    this = prev
                } else {
                    this = m_polymer[this].next
                }
            }
        }
    }
    
    func Remove(type: Int16) {
        var this : Int = m_polymer[0].next
        while this < (m_polymer.count - 1) {
            if m_polymer[this].type == type {
                // Remove this unit from the list
                let prev = m_polymer[this].prev
                let next = m_polymer[this].next
                m_polymer[prev].next = next
                m_polymer[next].prev = prev
                this = next
            } else {
                this = m_polymer[this].next
            }
        }
    }
    
    func Reset() {
        for (this, _) in m_polymer.enumerated() {
            m_polymer[this].next = this + 1
            m_polymer[this].prev = this - 1
        }
    }
    
    func Length() -> Int {
        var length : Int = 0
        var this : Int = 0
        while this < m_polymer.count {
            this = m_polymer[this].next
            length += 1
        }
        return length - 2
    }
}

func aoc_day5() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 5, part 1")
    
    var polymerStr : String = ""
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day5.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            polymerStr = polymerStr + line
        }
    }
    
    let polymer : Polymer = Polymer()
    polymer.Init(string: polymerStr)
    polymer.React()
    
    // Don't forget to subtract the fake head and tail
    print("    answer of part 1: ", polymer.Length())
    print("")

    var minimumLength : Int = polymer.Length()
    for c in "abcdefghijklmnopqrstuvwxyz" {
        polymer.Reset()
        polymer.Remove(type: CharacterToType(c: c))
        polymer.React()
        let length = polymer.Length()
        if length < minimumLength {
            minimumLength = length
        }
    }
    
    print("    answer of part 2: ", minimumLength)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}



func CharacterToType(c: Character) -> Int16 {
    let base : Int16 = 100
    switch c {
    case "a": return base + 0
    case "b": return base + 1
    case "c": return base + 2
    case "d": return base + 3
    case "e": return base + 4
    case "f": return base + 5
    case "g": return base + 6
    case "h": return base + 7
    case "i": return base + 8
    case "j": return base + 9
    case "k": return base + 10
    case "l": return base + 11
    case "m": return base + 12
    case "n": return base + 13
    case "o": return base + 14
    case "p": return base + 15
    case "q": return base + 16
    case "r": return base + 17
    case "s": return base + 18
    case "t": return base + 19
    case "u": return base + 20
    case "v": return base + 21
    case "w": return base + 22
    case "x": return base + 23
    case "y": return base + 24
    case "z": return base + 25
        
    case "A": return base + 0
    case "B": return base + 1
    case "C": return base + 2
    case "D": return base + 3
    case "E": return base + 4
    case "F": return base + 5
    case "G": return base + 6
    case "H": return base + 7
    case "I": return base + 8
    case "J": return base + 9
    case "K": return base + 10
    case "L": return base + 11
    case "M": return base + 12
    case "N": return base + 13
    case "O": return base + 14
    case "P": return base + 15
    case "Q": return base + 16
    case "R": return base + 17
    case "S": return base + 18
    case "T": return base + 19
    case "U": return base + 20
    case "V": return base + 21
    case "W": return base + 22
    case "X": return base + 23
    case "Y": return base + 24
    case "Z": return base + 25
    default: return -1
    }
}

func CharacterToCharge(c: Character) -> Int8 {
    switch c {
    case "a"..."z": return -1
    case "A"..."Z": return 1
    default: return 0
    }
}

