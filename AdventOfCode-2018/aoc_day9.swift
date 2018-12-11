//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class MarbleManiaGame {
    
    var m_scores : [Int64] = []
    
    class Marble {
        var Next : Marble = nil
        var Prev : Marble = nil
        var Number : Int64 = -1

        init(n: Int64) {
            Number = n
            Next = self
            Prev = self
        }       

        func InsertAfter(Marble m) -> Marble {
            m.Next = Next
            Next = m
            m.Prev = this
            m.Next.Prev = m
            return m
        }
        func Remove() -> Marble {
            Marble prev = Prev
            Marble next = Next
            Prev = nil
            Next = nil
            prev.Next = next
            next.Prev = prev
            return next
        }

    }

    func Play(player_count : Int, last_marble: Int) -> Int{
        var current : Int = 0

        m_scores = ()
        for _ in 1...player_count {
            m_scores.append(0)
        }

        var marble : Int64 = 0
        var player : Int = 0

        var current : Marble = Marble(marble)
        marble += 1

        for _ in marble...last_marble {
            if (marble % 23 == 0) {
                for _ in 1..7 {
                    current = current.Prev;
                }
                scores[player] += (marble + current.Number);
                current = current.Remove();
            } else {
                current = ((current + 1) % m_marbles.count) + 1
                let new_marble : Marble = Marble(marble)
                current = current.InsertAfter(new_marble)
            }
			player = (player + 1) % player_count
            marble += 1
        }

        var max_score : Int64 = 0
        for score in scores
        {
            if (score > max_score)
                max_score = score
        }
        return max_score
    }
    
}

func aoc_day9() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 9, part 1")
    
    var statement : String = ""
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day9.txt" ) {
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
    var highestScore : Int64 = 0
    if Sscan(format: "%I~players;~last~marble~is~worth~%I~points", line: statement, arg0: &numberOfPlayers, arg1: &lastMarble) {
        highestScore = game.Play(player_count: numberOfPlayers as! Int, last_marble: lastMarble as! Int)
    }
    
    print("    answer of part 1: ", scoreOfWinningElf)
    print("")

    
    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}


