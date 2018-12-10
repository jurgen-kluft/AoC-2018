//
//  day2.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class CodedMessage {

    struct Vector {
        var x : Int = 0
        var y : Int = 0
    }

    struct Particle {
        var position : Vector = Vector()
        var velocity : Vector = Vector()
    }
    var m_particles : [Particle] = []

    var m_sim_time : Int = 0
    var m_sim_data : [Particle] = []

    var m_minx : Int = Int.max
    var m_maxx : Int = Int.min
    var m_miny : Int = Int.max
    var m_maxy : Int = Int.min
    
    func Init() {
        
    }
    
    func AddParticle(px: Int, py: Int, vx: Int, vy: Int) {
        m_particles.append(Particle(position: Vector(x: px, y: py), velocity: Vector(x: vx, y: vy)))
    }

    func StartDecoder() {
        // Copy particles to simulation data
        m_sim_data = []
        for particle in m_particles {
            m_sim_data.append(particle)
        }
        m_sim_time = 0
    }
    
    func Decode() -> Bool {
        // Move particles
        m_sim_time += 1
        
        return true
    }
    
    func Print() {
        // Do we need to check if this makes any sense to plot?

        // Find min/max X and Y

        // Sleep
        sleep(1)
    }
    func Stop() {

    }
}

func aoc_day10() -> Void {
    // ----------------------------------------------------------------------------------------------------------------------------
    print("Advent of Code, day 10, part 1")
    
    let message : CodedMessage = CodedMessage()
    if let aStreamReader = StreamReader(path: "/Users/obnosis1/Xcode.Dev/AdventOfCode-2018/AdventOfCode-2018/Input/day10.txt" ) {
        defer {
            aStreamReader.close()
        }
        while let line = aStreamReader.nextLine() {
            var px : Any = Int(0)
            var py : Any? = Int(0)
            var vx : Any? = Int(0)
            var vy : Any? = Int(0)
            if Sscan(format: "position=<~%I,~%I>~velocity=<~%I,~%I>", line: line, arg0: &px, arg1: &py, arg2: &vx, arg3: &vy) {
                message.AddParticle(px: px as! Int, py: py as! Int, vx: vx as! Int, vy: vy as! Int)
            }
        }
    }
    
    message.StartDecoder()
    while message.Decode() {
        message.Print()
    }
    message.Stop()
    
    print("    answer of part 1: ", " ? ")
    print("")

    
    print("    answer of part 2: ", 0)
    print("")

    // ----------------------------------------------------------------------------------------------------------------------------
}

