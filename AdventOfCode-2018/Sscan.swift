//
//  Sscan.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/9.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation


func toDecimal(character: Character) -> Int {
    switch character {
    case "0": return 0
    case "1": return 1
    case "2": return 2
    case "3": return 3
    case "4": return 4
    case "5": return 5
    case "6": return 6
    case "7": return 7
    case "8": return 8
    case "9": return 9
    default: return 0
    }
}

func isDecimal(character: Character) -> Bool {
    switch character
    {
    case "0"..."9": return true
    default: return false
    }
}

func isHexadecimal(character: Character) -> Bool {
    switch character
    {
    case "0"..."9": return true
    case "a"..."f": return true
    case "A"..."F": return true
    default: return false
    }
}

func toHexadecimal(character: Character) -> Int {
    switch character {
    case "0": return 0
    case "1": return 1
    case "2": return 2
    case "3": return 3
    case "4": return 4
    case "5": return 5
    case "6": return 6
    case "7": return 7
    case "8": return 8
    case "9": return 9
    case "a","A": return 10
    case "b","B": return 11
    case "c","C": return 12
    case "d","D": return 13
    case "e","E": return 14
    case "f","F": return 15
    default: return -1
    }
}

func isFloat(character: Character) -> Bool {
    switch character
    {
    case "0"..."9": return true
    default: return false
    }
}

func toFloat(character: Character) -> Float64 {
    switch character {
    case "0": return 0.0
    case "1": return 1.0
    case "2": return 2.0
    case "3": return 3.0
    case "4": return 4.0
    case "5": return 5.0
    case "6": return 6.0
    case "7": return 7.0
    case "8": return 8.0
    case "9": return 9.0
    default: return 0.0
    }
}


func Sscan(format: String, line: String, arg0: inout Any, arg1: inout Any?, arg2: inout Any?, arg3: inout Any?, arg4: inout Any?, arg5: inout Any?) -> Bool {
    var argi : Int = 0
    var input : String = line
    var eat_whitespace : Bool = false
    var p: Character = " "
    for c in format {
        if c == "~" {
            // Eat up white-space until we encounter the next character
            eat_whitespace = true
        } else if c == "%" {
            
        } else if p == "%" {
            
            if c == "I" || c == "H" || c == "F" || c == "B" || c == "S" {
                while eat_whitespace {
                    var ic = input.first
                    if ic == " " || ic == "\t" {
                        ic = input.removeFirst()
                    } else {
                        eat_whitespace = false
                        break
                    }
                }
            }
            
            var arg : Any
            if c == "I" {
                // Read a number (100, 4096, 32768)
                var decimal : Int = 0
                var negative : Bool = false
                while input.first != nil {
                    let d = input.first ?? " "
                    if isDecimal(character: d) {
                        decimal = (decimal * 10) + toDecimal(character: d)
                        input.removeFirst()
                    } else if d == "-" {
                        negative = !negative
                    } else if d == "+" {
                        // NOP
                    } else {
                        break
                    }
                }
                arg = negative ? -decimal : decimal
            } else if c == "H" {
                // Read a hexadecimal value
                var hexadecimal : Int = 0
                while input.first != nil {
                    let hd = input.first ?? " "
                    if isHexadecimal(character: hd) {
                        hexadecimal = (hexadecimal * 16) + toHexadecimal(character: hd)
                        input.removeFirst()
                    } else {
                        break
                    }
                }
                arg = hexadecimal
            } else if c == "F" {
                // Read a float value (3.1415, 12.34e-56)
                var floatstr : String = ""
                var negative : Bool = false
                while input.first != nil {
                    let f = input.first ?? " "
                    if isFloat(character: f) {
                        floatstr.append(f)
                        input.removeFirst()
                    } else if f == "-" {
                        negative = !negative
                    } else if f == "+" {
                        // NOP
                    } else {
                        break
                    }
                }
                let value : Double = Double(floatstr) ?? 0.0
                arg = negative ? -value : value
            } else if c == "B" {
                // Read a bool value (Yes,No,True,False,On,Off)
                var bool : Bool
                var n : Int = 3
                if input.hasPrefix("true") || input.hasPrefix("True") || input.hasPrefix("TRUE") {
                    bool = true
                    n = 4
                } else if input.hasPrefix("false") || input.hasPrefix("False") || input.hasPrefix("FALSE") {
                    bool = false
                    n = 5
                } else if input.hasPrefix("yes") || input.hasPrefix("Yes") || input.hasPrefix("YES") {
                    bool = true
                    n = 3
                } else if input.hasPrefix("no") || input.hasPrefix("No") || input.hasPrefix("NO") {
                    bool = false
                    n = 2
                } else if input.hasPrefix("on") || input.hasPrefix("On") || input.hasPrefix("ON") {
                    bool = true
                    n = 2
                } else if input.hasPrefix("off") || input.hasPrefix("Off") || input.hasPrefix("OFF") {
                    bool = false
                    n = 3
                } else {
                    bool = false
                }
                for _ in 1...n {
                    input.removeFirst()
                }
                arg = bool
            } else if c == "S" {
                // Read a sentence ("is falling asleep.", "has to do some work.")
                var sentence : String = ""
                while input.first != nil {
                    let f = input.first ?? "."
                    if f != "." && f != "!" && f != "?" {
                        sentence.append(f)
                        input.removeFirst()
                    } else {
                        break
                    }
                }
                arg = sentence
            } else if c == "W" {
                // Read a word (House,Car,Work)
                var word : String = ""
                while input.first != nil {
                    let f = input.first ?? " "
                    if f != " " && f != ":" && f != "+" && f != "-" && f != "|" {
                        word.append(f)
                        input.removeFirst()
                    } else {
                        break
                    }
                }
                arg = word
            } else {
                return false
            }
            switch argi {
            case 0: arg0 = arg
            case 1: arg1 = arg
            case 2: arg2 = arg
            case 3: arg3 = arg
            case 4: arg4 = arg
            case 5: arg5 = arg
            default: return false
            }
            argi += 1
        } else {
            // Read characters from @line using the current @eat_whitespace, @until_character or
            // read a type indicated by @type_to_parse
            var ic = input.removeFirst()
            if eat_whitespace {
                while ic == " " || ic == "\t" {
                    ic = input.removeFirst()
                }
                eat_whitespace = false
            }
            // Read a character from @line and from @format, they should match
            if c != ic {
                return false
            }
        }
        
        p = c
    }
    
    return true
}

func Sscan(format: String, line: String, arg0: inout Any, arg1: inout Any?, arg2: inout Any?, arg3: inout Any?, arg4: inout Any?) -> Bool {
    var arg5: Any? = nil
    return Sscan(format: format, line: line, arg0: &arg0, arg1: &arg1, arg2: &arg2, arg3: &arg3, arg4: &arg4, arg5: &arg5)
}

func Sscan(format: String, line: String, arg0: inout Any, arg1: inout Any?, arg2: inout Any?, arg3: inout Any?) -> Bool {
    var arg4: Any? = nil
    var arg5: Any? = nil
    return Sscan(format: format, line: line, arg0: &arg0, arg1: &arg1, arg2: &arg2, arg3: &arg3, arg4: &arg4, arg5: &arg5)
}

func Sscan(format: String, line: String, arg0: inout Any, arg1: inout Any?, arg2: inout Any?) -> Bool {
    var arg3: Any? = nil
    var arg4: Any? = nil
    var arg5: Any? = nil
    return Sscan(format: format, line: line, arg0: &arg0, arg1: &arg1, arg2: &arg2, arg3: &arg3, arg4: &arg4, arg5: &arg5)
}

func Sscan(format: String, line: String, arg0: inout Any, arg1: inout Any?) -> Bool {
    var arg2: Any? = nil
    var arg3: Any? = nil
    var arg4: Any? = nil
    var arg5: Any? = nil
    return Sscan(format: format, line: line, arg0: &arg0, arg1: &arg1, arg2: &arg2, arg3: &arg3, arg4: &arg4, arg5: &arg5)
}

func Sscan(format: String, line: String, arg0: inout Any) -> Bool {
    var arg1: Any? = nil
    var arg2: Any? = nil
    var arg3: Any? = nil
    var arg4: Any? = nil
    var arg5: Any? = nil
    return Sscan(format: format, line: line, arg0: &arg0, arg1: &arg1, arg2: &arg2, arg3: &arg3, arg4: &arg4, arg5: &arg5)
}
