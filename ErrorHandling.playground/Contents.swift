//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, Felicia"

enum Token {
    case Number(Int)
    case Plus
    case Subtraction
}

class Lexer {
    enum Error: ErrorType {
        case InvalidCharacter(Character, String.CharacterView.Index)
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
            case "-" :
                tokens.append(.Subtraction)
                advance()
            case " " :
                advance()
            default :
            throw Error.InvalidCharacter(nextCharacter, position)
            }
        }
        
        return tokens
    }
}

class Parser {
    enum Error: ErrorType {
        case UnexpectedEndOfInput
        case InvalidToken(Token, Int)
    }
    
    let tokens: [Token]
    var position = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func getNextToken() -> Token? {
        guard position < tokens.count else {
            return nil
        }
        return tokens[position++]
    }
    
    func getNumber() throws -> Int {
        guard let token = getNextToken() else {
            throw Error.UnexpectedEndOfInput
        }
        
        switch token {
        case .Number(let value) :
            return value
        case .Plus :
            throw Error.InvalidToken(token, position)
        case .Subtraction :
            throw Error.InvalidToken(token, position)
        }
    }
    
    func parse() throws -> Int {
        // Require a number first
        var value = try getNumber()
        
        while let token = getNextToken() {
            switch token {
                
            // Getting a Plus after a Number is legal
            case .Plus :
                // After a plus, we must get another number
                let nextNumber = try getNumber()
                value += nextNumber
                
            // Getting Subtraction after a Number is legal
            case .Subtraction :
                // After a subtraction, we must get another number
                let nextNumber = try getNumber()
                value -= nextNumber
                
            // Getting a Number after a Number is not legal
            case .Number:
                throw Error.InvalidToken(token, position)
            }
        }
        return value
    }
}

func evaluate(input: String) {
    print("Evaluating: \(input)")
    let lexer = Lexer(input: input)
    
    do {
        let tokens = try lexer.lex()
        print("Lexer output: \(tokens)")
        
        let parser = Parser(tokens: tokens)
        let result = try parser.parse()
        print("Parser output: \(result)")
    } catch Lexer.Error.InvalidCharacter(let character, let index) {
        print("Input contained an invalid character at index \(index): \(character)")
    } catch Parser.Error.UnexpectedEndOfInput {
        print("Unexpected end of input during parsing")
    } catch Parser.Error.InvalidToken(let token, let index) {
        print("Invalid token during parsing at index \(index): \(token)")
    } catch {
        print("An error occured: \(error)")
    }
    
}

evaluate("10 + 3 + 5")
evaluate("10 + 5 - 3a - 1")
evaluate("1 + 3 - 7a + 8")
evaluate("10 + 3 3 + 7")


