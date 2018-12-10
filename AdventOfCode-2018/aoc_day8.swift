//
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class LicenseFile {
   
    var m_numbers : [Int] = []

    class Node {
        var Offset : Int = -1
        var Children : [Node] = []
        var Metadata : [Int] = []

        func CreateChildren(count: Int) {
            for _ in 1...count {
                var child : Node = Node()
                Children.append(child)
            }
        }
        func CreateMetadata(size: Int) {
            for _ in 1...size {
                Metadata.append(0)
            }
        }
    }

    var m_tree : Node = Node()

    func Add(number: Int) {
        m_numbers.append(number)
    }

    func Build() {
        // Keep track of the current position in the number array
        var cursor : Int = 0
        
        // Root node
        m_tree = Node()

        // Start the tree at the root
        var stack : Stack<Node> = ()
        stack.push(m_tree)
        while stack.count > 0 {
            var node = stack.top()
            stack.pop()

            // The cursor in the numbers array is our offset
            if node.Offset == -1 {
                node.Offset = cursor
                stack.push(node)    // We want to still get our meta-data
                var childcount = m_numbers[node.Offset]
                var metadatasize = m_numbers[node.Offset + 1]
                node.CreateChildren(count: childcount)
                node.CreateMetadata(size: metadatasize)

                // Skip the header, move the cursor
                // Cursor is now at our first child or if no children at our meta-data
                cursor += 2

                // Push the children on the stack (reversed order for clarity)
                for child in node.Children.reversed() {
                    stack.push(child)
                }

            } else {
                // We have come back up the tree, so now the 
                // cursor is pointing at our meta-data. That 
                // is if we should have any.
                if node.Metadata.count > 0 {
                    for i in 0...(node.Metadata.count-1) {
                        node.Metadata[i] = m_numbers[cursor + i]
                    }
                    cursor += node.Metadata.count
                }

                // Cursor is at the start of a header again, a new node?
                // Only if we haven't exhausted all the numbers.
                if cursor >= m_numbers.count {
                    break
                }
            }
        }
    }
    
    func SumOfMetadata() -> Int {
        var sum_of_metadata : Int = 0
        
        // Start the tree at the root
        var stack : Stack<Node> = ()
        stack.push(m_tree)
        
        while stack.count > 0 {
            // Get a node from the stack
            var node = stack.top()
            stack.pop()

            // Push all children
            for child in node.Children {
                stack.push(child)
            }

            // Sum the meta data
            for meta in node.Metadata {
                sum_of_metadata += meta
            }
        }

        return sum_of_metadata
    }
}

func aoc_day8() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 8")
    
    var license : LicenseFile = LicenseFile()
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day8.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            let numstrs = line.split(separator: " ")
            for numstr in numstrs {
                num = Int(numstr) ?? -1
                license.Add(num)
            }
        }
    }
    
    license.Build()
    
    print("    answer of part 1: ", license.SumOfMetadata())
    print("")

    
    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

