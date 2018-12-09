//
//  tokenizer.swift
//  AdventOfCode-2018
//
//  Created by Jurgen Kluft on 2018/12/8.
//  Copyright © 2018 Jurgen Kluft. All rights reserved.
//

import Foundation

class Token{
    let name:String
    var characters:String = ""
    
    init(name:String){
        self.name = name
    }
    
    init(name:String, withCharacters:String){
        self.name = name
        self.characters = withCharacters
    }
    
    func description()->String{
        return "\(name) '\(characters)'"
    }
    
    class ErrorToken : Token{
        let problem : String
        init(forCharacter:UnicodeScalar,problemDescription:String){
            problem = problemDescription
            super.init(name: "Error", withCharacters: "\(forCharacter)")
        }
        
        override func description() -> String {
            return super.description()+" - "+problem
        }
    }
}

protocol Tokenizing{
    //Returns true if the supplied character can be tokenized by the implementing class
    func canTokenize(character:UnicodeScalar) -> Bool
    //Only called if the implementation returned true for canTokenize
    func tokenFor(character:UnicodeScalar) -> Token
}

class NewContextToken : Token{
    let newContext : TokenizerState
    init(newContext:TokenizerState){
        self.newContext = newContext
        super.init(name: "NewContextToken")
    }
}

class TokenizerState : Tokenizing{
    var tokenizers = Array<Tokenizing>()
    var tokens = Array<Token>()
    
    
    //Fetches the correct tokenizer for the given character
    func tokenizerFor(character : UnicodeScalar) -> Tokenizing? {
        for tokenizer in tokenizers{
            if tokenizer.canTokenize(character: character){
                return tokenizer
            }
        }
        return nil
    }
    
    //Determines if a token can be created by asking all
    //the tokenizers it has if they can create a token for the character
    func canTokenize(character:UnicodeScalar) -> Bool{
        return tokenizerFor(character: character) != nil
    }
    
    //Returns the correct token
    func tokenFor(character:UnicodeScalar) -> Token{
        if let tokenizer = tokenizerFor(character: character){
            //If it is a state, create a new context token for it
            if tokenizer is TokenizerState{
                return NewContextToken(newContext: tokenizer as! TokenizerState)
            } else {
                return tokenizer.tokenFor(character: character)
            }
        }
        
        return Token.ErrorToken(forCharacter: character, problemDescription: "Failed to create token")
    }
    
    //Add a token to the stored state
    func append(token:Token) {
        tokens.append(token)
    }
    
    //Return all the tokens in the stored state, this
    //is the point to over-ride in a sub-class if you wish
    //to consolidate multiple tokens into one
    func flushTokens() -> Array<Token>? {
        let oldTokens = tokens
        tokens = Array<Token>()
        return oldTokens
    }
}


class Tokenizer : TokenizerState{
    var stateStack = Stack<TokenizerState>()
    
    //Entry point for tokenization of a string, returning an
    //array of tokens
    func tokenize(string:String) -> Array<Token>{
        stateStack = Stack<TokenizerState>()
        stateStack.push(value: self)
        
        for character in string.unicodeScalars{
            tokenize(character: character)
            if stateStack.isEmpty(){
                return tokens
            }
        }
        
        fullyUnwind()
        
        return tokens
    }
    
    
    //Removes the current state from the stack, passing
    //its tokens to the next state on the stack
    func unwindState(){
        let state = stateStack.top()!
        stateStack.pop()
        
        if let newState = stateStack.top(){
            //If there is a new state, pass the tokens on to the state
            if let currentStateTokens = state.flushTokens(){
                for token in currentStateTokens{
                    newState.append(token: token)
                }
            }
        } else {
            //otherwise add them to mine
            if let currentStateTokens = state.flushTokens(){
                tokens.append(contentsOf: currentStateTokens)
            }
        }
        
    }
    
    //If we hit an error, unwind all the way
    func fullyUnwind(){
        while !stateStack.isEmpty(){
            unwindState()
        }
    }
    
    func tokenize(character:UnicodeScalar){
        if let state = stateStack.top(){
            if state.canTokenize(character: character){
                let token = state.tokenFor(character: character)
                
                if let newContextToken = token as? NewContextToken{
                    stateStack.push(value: newContextToken.newContext)
                    tokenize(character: character)
                } else {
                    state.append(token: token)
                }
            } else {
                unwindState()
                tokenize(character: character)
            }
        } else {
            //If there's no state, we have fully unwound and could not tokenize
            append(token: Token.ErrorToken(forCharacter: character, problemDescription: "Unrecognized character"))
        }
    }
}

class Stack<T>{
    var stack = Array<T>()
    
    func push(value: T){
        stack.append(value)
    }
    
    func pop() -> Void {
        if (stack.count > 0){
            stack.removeLast()
        }
    }
    
    func isEmpty()->Bool{
        return depth() == 0
    }
    
    func depth()->Int{
        return stack.count
    }
    
    func top()->T?{
        if stack.count == 0 {
            return nil
        }
        return stack[stack.endIndex-1]
    }
    
    func popAll(){
        stack = Array<T>();
    }
}

class CharacterTokenizer : Tokenizing{
    let matchedCharacters : String
    
    init(character : Character, tokenName : String){
        matchedCharacters = "\(character)"
    }
    
    init(allCharacters:String, tokenName : String){
        matchedCharacters = allCharacters
    }
    
    func canTokenize(character: UnicodeScalar) -> Bool {
        for matches in matchedCharacters.unicodeScalars{
            if matches == character {
                return true;
            }
        }
        
        return false
    }
    
    func tokenFor(character: UnicodeScalar) -> Token {
        return CharacterToken(character: character)
    }
    
    class CharacterToken : Token{
        init(character:UnicodeScalar){
            super.init(name: "Character", withCharacters: "\(character)")
        }
    }
}

let digitTokenizer = CharacterTokenizer(allCharacters: "0123456789",tokenName: "digit")
let whiteSpaceTokenizer = CharacterTokenizer(allCharacters: " \t", tokenName: "whitespace") //You'll probably want to add /n and /r
let englishLetterTokenizer = CharacterTokenizer(allCharacters: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", tokenName: "letter")

class CharacterSequenceTokenGenerator : TokenizerState{
    //Flushes the token stream, and creates a string with all
    //of the token stream charactes in
    func consolidateCharacters() -> String {
        var string = ""
        
        if let allTokens = super.flushTokens(){
            for token in allTokens{
                string += token.characters
            }
            return string
        } else {
            return ""
        }
    }
    
}

//One for English letters
class WordTokenGenerator : CharacterSequenceTokenGenerator{
    override init(){
        super.init()
        tokenizers = [englishLetterTokenizer]
    }
    
    override func flushTokens() -> Array<Token>? {
        let wordString = consolidateCharacters()
        return [Token(name: "Word", withCharacters: wordString)]
    }
    
}

//One for Integers
class IntegerTokenGenerator : CharacterSequenceTokenGenerator{
    override init(){
        super.init()
        tokenizers = [digitTokenizer]
    }
    
    override func flushTokens() -> Array<Token>? {
        let integerString = consolidateCharacters()
        return [IntegerToken(number: integerString)]
    }
    
    
    class IntegerToken : Token{
        let intValue : Int
        init(number : String){
            intValue = Int(number)!
            super.init(name: "Integer", withCharacters: number)
        }
    }
}

//One for white space
class WhiteSpaceTokenGenerator : CharacterSequenceTokenGenerator{
    override init(){
        super.init()
        tokenizers = [whiteSpaceTokenizer]
    }
    
    override func flushTokens() -> Array<Token>? {
        let spaceString = consolidateCharacters()
        return [Token(name:"Whitespace", withCharacters:spaceString)]
    }
}

