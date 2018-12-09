//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

// Axis orientation:
//    0,    0 Origin is at the Top Left
// 1000, 1000 Corner is at the Bottom Right

struct Rectangle
{
    var X : Int = 0 // X,Y is the Top Left corner of the rectangle
    var Y : Int = 0
    var W : Int = 0 // W,H are the Width and Height of the triangle
    var H : Int = 0
}

struct ClaimOnFabricArea
{
    var ID : Int = 0
    var Rec : Rectangle
}


func aoc_day3() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 3, part 1")
    
    var claims: [ClaimOnFabricArea] = []
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day3.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            // Parse claim
            // Example: #123 @ 3,2: 5x4
            var ID : Any = Int(0)
            var X : Any? = Int(0)
            var Y : Any? = Int(0)
            var W : Any? = Int(0)
            var H : Any? = Int(0)
            if Sscan(format: "~#%I~@~%I,%I:~%Ix%I", line: line, arg0: &ID, arg1: &X, arg2: &Y, arg3: &W, arg4: &H) {
                // print("ID:", ID, "X:", X, "Y:", Y, "W:", W, "H:",  H)
                let claim = ClaimOnFabricArea(ID: ID as! Int, Rec: Rectangle(X: X as! Int, Y: Y as! Int, W: W as! Int, H: H as! Int))
                claims.append(claim)
            }
        }
    }

    // Create a 1000 x 1000 grid and start filling in all claims
    var fabric : [Int] = []
    var i : Int = 0
    while i < (1000 * 1000) {
        fabric.append(0)
        i += 1
    }
    print(fabric.count)
    
    for claim in claims {
        var x : Int = claim.Rec.X
        let xend : Int = x + claim.Rec.W
        while x < xend {
            var y : Int = claim.Rec.Y
            let yend : Int = y + claim.Rec.H
            while y < yend {
                fabric[(y*1000) + x] += 1
                y += 1
            }
            x += 1
        }
    }

    var squareInchesClaimedMoreThanTwoTimes : Int64 = 0
    i = 0
    while i < (1000 * 1000) {
        if fabric[i] >= 2 {
            squareInchesClaimedMoreThanTwoTimes += 1
        }
        i += 1
    }

    // wrong: 28156
    // wrong: 109786
    print("    answer of part 1: ", squareInchesClaimedMoreThanTwoTimes)
    print("")

    print("Advent of Code, day 3, part 2")

    var claimWithNoOverlap : Int = 0
    for claim in claims {
        claimWithNoOverlap = claim.ID
        var x : Int = claim.Rec.X
        let xend : Int = x + claim.Rec.W
        check_no_overlap: while x < xend {
            var y : Int = claim.Rec.Y
            let yend : Int = y + claim.Rec.H
            while y < yend {
                if fabric[y*1000 + x] != 1 {
                    claimWithNoOverlap = -1
                    break check_no_overlap
                }
                y += 1
            }
            x += 1
        }
        if claimWithNoOverlap != -1 {
            break
        }
    }

    print("    answer of part 2: ", claimWithNoOverlap)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

