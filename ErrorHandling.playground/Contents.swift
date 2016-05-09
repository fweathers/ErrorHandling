//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Felicia"

enum Token {
    case Number(Int)
    case Plus
}

class Lexer {
    enum Error: ErrorType {
        case InvalidCharacter(Character)
    }
    
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
    
    func getNumber() -> Int {
        var value = 0
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9" :
                // Another digit - add it into value
                let digitValue = Int(String(nextCharacter))!
                value = 10*value + digitValue
                advance()
                
            default:
                // A non-digit - go back to regular lexing
                return value
            }
        }
        return value
    }
    
    func lex() throws -> [Token] {
        var tokens = [Token]()
        
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9" :
                let value = getNumber()
                tokens.append(.Number(value))
            case "+" :
                tokens.append(.Plus)
                advance()
                
            case " " :

                advance()
            default :

            throw Error.InvalidCharacter(nextCharacter)
            }
        }
        
        return tokens
    }
}


func evaluate(input: String) {
    print("Evaluating: \(input)")
    let lexer = Lexer(input: input)
    let tokens = lexer.lex()
    print("Lexer output: \(tokens)")
}

evaluate("10 + 3 + 5")
evaluate("1 + 2 + abcdefg")