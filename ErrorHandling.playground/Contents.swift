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
}