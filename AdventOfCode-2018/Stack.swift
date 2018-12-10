//
//  tokenizer.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class Stack<T> {
    var stack = Array<T>()

    func count()->Int{
        return stack.count
    }

    func clear() {
        stack = Array<T>();
    }

    func push(value: T){
        stack.append(value)
    }
    
    func pop() -> Void {
        if (stack.count > 0){
            stack.removeLast()
        }
    }
    
    func top()->T? {
        if stack.count == 0 {
            return nil
        }
        return stack[stack.endIndex-1]
    }
    
}

