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

        func is_free() -> Bool {
            return m_idx == -1 && m_age == -1
        }

        mutating func kill() {
            m_idx = -2
            m_age = -2
        }

        func is_dead() -> Bool {
            return m_idx == -2 && m_age == -2
        }

        // We cannot extend onto a cell if it is already taken or if it is dead.
        // When we call this and the cell has been taken and the age is that same
        // then this cell should be killed.
        mutating func take(idx: Int, age: Int) -> Bool {
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
            let i = c.y * m_map_w + c.x
            m_map[i].m_idx = c.idx
            m_map[i].m_age = 0
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
        let cell_idx  = y * m_map_w + x
        let coord_idx = m_map[cell_idx].m_idx

        // Checking in relation to the origin, see which direction
        // we should extend into.

        // 1
        //                                     e
        // o-----x, this can extend into o-----xe
        //                                     e
        // 2
        //                                       e
        //    +---x, this can extend into o-----xe
        // o--+
        // 3
        // o--+
        //    +---x, this can extend into o-----xe
        //                                       e

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
        if x == 0 {
            dir = dir & ~Left
        } else if x == (m_map_w - 1) {
            dir = dir & ~Right
        }
        if y == 0 {
            dir = dir & ~Up
        } else if y == (m_map_h - 1) {
            dir = dir & ~Down
        }
        return dir
    }
    
    func ExtendCell(x: Int, y: Int, idx: Int, age: Int) -> Bool {
        let dir = DetermineDirectionsToExtendCell(x: x, y: y)
        if (dir & Left) == Left {
            let i  = y * m_map_w + x
            m_map.take()
        }
        if (dir & Right) == Right {
            
        }
        if (dir & Up) == Up {
            
        }
        if (dir & Down) == Down {
            
        }
        
        return false
    }

    func ShouldExtendCell(x: Int, y: Int, age: current_age) -> Bool {
        let i  = y * m_map_w + x
        return m_map[i].m_age == current_age)
    }

    func ComputeAreas() -> Void {
        
        // Extend each coordinate until we reach the point where none can be extended anymore
        var extending : Bool = true
        var current_age : Int = 0
        while extending {
            extending = false
            
            // Go over every grid-cell and process cells that have the @current_age and extend
            // them in the correct directions and age them by 1.
            for x in 0...(m_map_w - 1) {
                for y in 0...(m_map_h - 1) {
                    let i  = y * m_map_w + x
                    if ShouldExtendCell(x: x, y: y, age: current_age) {
                        if ExtendCell(x: x, y: y, age: current_age) {
                            extending = true
                        }
                    }
                }
            }

            current_age += 1
        }

    }

    func DetermineSizeOfLargestArea() -> Int {
        var areasizes : [Int] = []
        for _ in m_coords {
            areasizes.append(0)
        }

        for x in 0...(m_map_w - 1) {
            for y in 0...(m_map_h - 1) {
                let i  = y * m_map_w + x
                if !m_map[i].is_dead() && !m_map[i].is_free() {
                    areasizes[m_map[i].m_idx] += 1
                }
            }
        }

        // Reset counts for those area ids that are infinite
        for x in 0...(m_map_w - 1) {
            let i  = x
            areasizes[m_map[i].m_idx] = 0
        }
        for x in 0...(m_map_w - 1) {
            let i  = (m_map_h - 1) * m_map_w + x
            areasizes[m_map[i].m_idx] = 0
        }
        for y in 0...(m_map_h - 1) {
            let i  = y * m_map_w
            areasizes[m_map[i].m_idx] = 0
        }
        for y in 0...(m_map_h - 1) {
            let i  = y * m_map_w + (m_map_w - 1)
            areasizes[m_map[i].m_idx] = 0
        }

        var largest_area_size : Int = Int.min
        for areasize in areasizes {
            if areasize > largest_area_size {
                largest_area_size = areasize
            }
        }

        return largest_area_size
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
            if Sscan(format: "%I,~%I", line: line, arg0: &coordX, arg1: &coordY) {
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
