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
        var index : Int = -1
        var input : [Edge] = []
        var output : [Edge] = []
    }

    class Edge {
        var Src : Node = nil
        var Dst : Node = nil
    }

    var m_nodes : [Node] = []
    var m_int_to_char : [String] = []
    var m_char_to_int : [String : Int] = [:]

    var m_starts : [Node] = []
    var m_visited : [Bool] = []
    var m_visit : [Node] = []

    func AddRule(first: String, after: String) {
        var src : Int = m_char_to_int[first]
        var dst : Int = m_char_to_int[after]
        srcNode = m_nodes[src]
        dstNode = m_nodes[dst]

        var edge : Edge = Edge(Src: srcNode, Dst: dstNode)
        srcNode.output.append(edge)
        dstNode.input.append(edge)
    }

    func Init() {
        for (i, l) in "ABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated() {
            m_char_to_int[String(l)] = i
            m_nodes.append(Node())
            m_visited.append(false)
        }
    }
    
    func Start() -> Bool {
        for node in m_nodes {
            if node.input.count == 0 {
                m_starts.append(node)
            }
        }

        // Sort the start nodes by 'index'
        m_starts.sort {
            return $0.index < $1.index
        }

        if m_starts.count > 0 {
            var node : Node = m_starts.first
            m_visit.append(node)
            m_visited[node.index] = true
            return true
        } else {
            return false
        }
    }

    func CanStep() -> Bool {
        return m_visit.count > 0
    }

    func Step() -> String {
        var node : Node : m_visit.removeFirst

        for edge in node.output {
            if m_visited[edge.Dst.index] == false {
                m_visit.append(edge.Dst)
                m_visited[edge.Dst.index] = true
            }
        }

        m_visit.sort {
            return $0.index < $1.index
        }

        var result : Character = m_int_to_char[node.index]
        return String(result)
    }
}

func aoc_day7() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 7")
    
    var graph : Graph = Graph()
    graph.Init()
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day7.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            // Step P must be finished before step O can begin.
            var stepFirst : Any? = String("")
            var stepAfter : Any? = String("")
            if Sscan(format: "Step~%W~must~be~finished~before~step~%W~can~begin", line: statement, arg0: &stepFirst, arg1: &stepAfter) {
                graph.AddRule(stepFirst as! String, stepAfter as! String)
            }
        }
    }

    if graph.Start() {
        var steps : String = ""
        while graph.CanStep() {
            var char = graph.Step()
            steps = steps + char
        }

        print("    answer of part 1: ", steps)
        print("")
    } else {
        print("    answer of part 1: ", "error, cannot find answer")
        print("")
    }
    

    
    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}
