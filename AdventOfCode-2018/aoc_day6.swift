//
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class CoordinateMap {
    
    struct Coordinate {
        var x : Int = 0
        var y : Int = 0
        var idx : Int = 0
    }

    struct GridCell {
        var m_age : Int = -1
        var m_idx : Int = -1
        func is_free() {
            return m_idx == -1 && m_age == -1
        }
        func kill() {
            m_idx = -2
            m_age = -2
        }
        func is_dead() {
            return m_idx == -2 && m_age == -2
        }

        // We cannot extend onto a cell if it is already taken or if it is dead.
        // When we call this and the cell has been taken and the age is that same
        // then this cell should be killed.
        func take(idx: Int, age: Int) -> Bool {
            if is_dead() {
                return false
            }
            if is_free() {
                m_age = age
                m_idx = idx
                return true
            }
            if age == m_age {
                kill()
            }
            return false
        }
    }
    
    var m_coords : [Coordinate] = []
    var m_map_w : Int = 0
    var m_map_h : Int = 0
    var m_map : [GridCell] = []
    
    func AddCoord(x: Int, y: Int) {
        m_coords.append(Coordinate(x: x, y: y, idx: m_coords.count))
    }

    func Build() -> Void {
        var maximum_x : Int = Int.min
        var maximum_y : Int = Int.min
        for c in m_coords {
            if c.x > maximum_x {
                maximum_x = c.x
            }
            if c.y > maximum_y {
                maximum_y = c.y
            }
        }

        m_map_w = maximum_x
        m_map_h = maximum_y

        // Create grid using maximum-x and maximum-y and initialize each cell to its default 
        m_map = [GridCell]()
        for _ in 1...(m_map_w * m_map_h) {
            m_map.append(GridCell())
        }

        // Reset the grid and apply coordinates
        Reset()
    }

    func Reset() -> Void {
        // Reset every grid-cell of the map
        for i in 0...(m_map_w * m_map_h - 1) {
            m_map[i] = GridCell()
        }

        // Write existing coordinates onto the map
        for c in m_coords {
            let i : Int = c.y * m_mapw + c.x
            m_map[i].idx = c.idx
            m_map[i].age = 0
        }
    }

    //   0,0
    //    +------------------------  +X
    //    |
    //    |
    //    |      ^
    //    |      | UP
    //    |
    //    |
    //    |
    //  +Y

    let Up : Int = 1
    let Down : Int = 2
    let Left : Int = 4
    let Right : Int = 8

    func DetermineDirectionsToExtendCell(x: Int, y: Int) -> Int {
        let cell_idx  = y * m_mapw + x
        let coord_idx = m_map[cell_idx].idx

        var dir : Int = 0
        if x == m_coords[coord_idx].x {
            if y < m_coords[coord_idx].y {
                dir = Up | Left | Right
            } else if y > m_coords[coord_idx].y {
                dir = Down | Left | Right
            } else {
                dir = Up | Down | Left | Right
            }
        } else if x < m_coords[coord_idx].x {
            if y < m_coords[coord_idx].y {
                dir = Up | Left
            } else if y > m_coords[coord_idx].y {
                dir = Down | Left
            } else {
                dir = Up | Down | Left
            }
        } else if x > m_coords[coord_idx].x {
            if y < m_coords[coord_idx].y {
                dir = Up | Right
            } else if y > m_coords[coord_idx].y {
                dir = Down | Right
            } else {
                dir = Up | Down | Right
            }
        }
        
        // Based on the incoming x/y, dir and map width and height see
        // if we need to clip the direction so that we don't move out
        // of the map.

    }

    func ComputeAreas() -> Void {
        
        // Extend each coordinate until we reach the point where none can be extended anymore
        var extending : Bool = true
        var current_age : Int = 0
        while extending {
            extending = false
            
            // Go over every grid-cell and process cells that have the @current_age and extend
            // them in the correct directions and age them by 1.

            

            age += 1
        }

    }

    func DetermineSizeOfLargestArea() -> Int {

        return 0
    }
}

func aoc_day6() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 6")

    let coordmap : CoordinateMap = CoordinateMap()

    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day6.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {

            var coordX : Any = Int(0)
            var coordY : Any? = Int(0)
            // 
            // Example Input: 
            // 108, 324
            // 
            if Sscan(format: "%I,~%I", line: statement, arg0: &coordX, arg1: &coordY) {
                coordmap.AddCoord(x: coordX as! Int, y: coordY as! Int)
            }
        }
    }
    coordmap.Build()
    coordmap.ComputeAreas()

    let sizeOfLargestArea : Int = coordmap.DetermineSizeOfLargestArea()
    
    print("    answer of part 1: ", sizeOfLargestArea)
    print("")

    
    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

