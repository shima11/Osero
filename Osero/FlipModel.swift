//
//  FlipModel.swift
//  Osero
//
//  Created by shima jinsei on 2016/02/25.
//  Copyright © 2016年 Jinsei Shima. All rights reserved.
//

import Foundation


class FlipModel {
    
    class func flip(board:[[Int]], x:Int, y:Int, stone:Int) -> [(Int, Int)]? {
        if board[y][x] != EMPTY { return nil }
        var result:[(Int, Int)] = []
        result += flipLine(board, x: x, y: y, stone: stone, dx: 1, dy: 0)
        result += flipLine(board, x: x, y: y, stone: stone,dx: -1, dy: 0)
        result += flipLine(board, x: x, y: y, stone: stone, dx: 0, dy: 1)
        result += flipLine(board, x: x, y: y, stone: stone, dx: 0,dy: -1)
        result += flipLine(board, x: x, y: y, stone: stone, dx: 1, dy: 1)
        result += flipLine(board, x: x, y: y, stone: stone,dx: -1,dy: -1)
        result += flipLine(board, x: x, y: y, stone: stone, dx: 1,dy: -1)
        result += flipLine(board, x: x, y: y, stone: stone,dx: -1, dy: 1)
        if result.count > 0 {
            result += [(x, y)]
            return result
        } else {
            return nil
        }
    }
    
    class func flipLine(board:[[Int]], x:Int, y:Int, stone:Int, dx:Int, dy:Int) -> [(Int, Int)] {
        var flipLoop: (Int, Int) -> [(Int, Int)]? = { _ in nil }
        flipLoop = { (x: Int, y: Int) -> [(Int, Int)]? in
            if board[y][x] == EMPTY {
                return nil
            } else if board[y][x] == stone {
                return []
            } else if var result = flipLoop(x+dx, y+dy) {
                result += [(x, y)]
                return result
            }
            return nil
        }
        if let result = flipLoop(x+dx, y+dy) {
            return result
        }
        return []
    }
    
    class func canPlaced(board:[[Int]], stone: Int) -> [(Int, Int)]? {
        var result:[(Int, Int)] = []
        for y in 1...BOARD_INTY {
            for x in 1...BOARD_INTX {
                if let _ = flip(board, x: x, y: y, stone: stone) {
                    result += [(x, y)]
                }
            }
        }
        if result.isEmpty {
            return nil
        } else {
            return result
        }
    }
    
    class func cpuFlip(board:[[Int]], stone: Int) -> [(Int, Int)]? {
        if let places = canPlaced(board, stone: stone) {
            let (x, y) = places[ Int(arc4random()) % places.count ]
            return flip(board, x: x, y: y, stone: stone)
        }
        return nil
    }
    
    class func calcStones(board:[[Int]]) -> (free:Int, black:Int, white:Int) {
        var free = 0, white = 0, black = 0
        for y in 1...BOARD_INTY {
            for x in 1...BOARD_INTX {
                switch board[y][x] {
                case BLACK_STONE: black++
                case WHITE_STONE: white++
                default: free++
                }
            }
        }
        return (free, black, white)
    }
}