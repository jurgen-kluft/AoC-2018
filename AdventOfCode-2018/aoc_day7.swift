//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class MarbleManiaGame {
    
    struct Marble {
        var next : Int = 0
        var prev : Int = 0
        var number : Int = 0
    }
    
    var Circle : [Marble] = []
    var Current : Int = 0
    
    func Init(player_count : Int, last_marble_value: Int) {
        
    }
    
    func Play() -> Int {
        return 0
    }
}

func aoc_day7() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 7")
    
    var statement : String = ""
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day7.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            statement = line
        }
    }
    
    let game : MarbleManiaGame = MarbleManiaGame()
    
    var numberOfPlayers : Any = Int(0)
    var lastMarbleValue : Any? = Int(0)
    if Sscan(format: "%I~players;~last~marble~is~worth~%I~points", line: statement, arg0: &numberOfPlayers, arg1: &lastMarbleValue) {
        game.Init(player_count: numberOfPlayers as! Int, last_marble_value: lastMarbleValue as! Int)
    }
    
    let scoreOfWinningElf : Int = game.Play()
    
    print("    answer of part 1: ", scoreOfWinningElf)
    print("")

    
    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

