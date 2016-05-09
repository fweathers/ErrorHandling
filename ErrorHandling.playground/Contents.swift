//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Felicia"

enum Token {
    case Number(Int)
    case Plus
}

class Lexer {
    let input: String.CharacterView
    var position: String.CharacterView.Index
    
    init(input: String) {
        self.input = input.characters
        self.position = self.input.startIndex
    }
    
    func peek() -> Character? {
        guard position < input.endIndex else {
            return nil
        }
        return input[position]
    }
    
    func advance() {
        assert(position < input.endIndex, "Cannot advance past the end!")
        position = position.successor()
    }
    
    func lex() throws -> [Token] {
        var tokens = [Token]()
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9" :
                // Start of a number - need to grab the rest
                
            case "+" :
                tokens.append(.Plus)
                advance()
                
            case " " :
                // Just advance to ignore spaces
                
            default :
                // Something unexpected - need to sen back an error
            }
        }
        
        return tokens
    }
}

