//
//  OthelloView.swift
//  SwiftOthello
//
//  Created by muratamuu on 2014/07/06.
//  Copyright (c) 2014年 muratamuu. All rights reserved.
//

import UIKit

let EMPTY = 0, BLACK_STONE = 1, WHITE_STONE = 2

//盤数
//計算用
let BOARD_X: CGFloat = 6
let BOARD_Y: CGFloat = 6
//カウント用
let BOARD_INTX = 6
let BOARD_INTY = 6

//6*6用
let initboard = [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,2,1,0,0,0],
    [0,0,0,1,2,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
];

//8*8用
//let initboard = [
//    [0,0,0,0,0,0,0,0,0,0],
//    [0,0,0,0,0,0,0,0,0,0],
//    [0,0,0,0,0,0,0,0,0,0],
//    [0,0,0,0,0,0,0,0,0,0],
//    [0,0,0,0,2,1,0,0,0,0],
//    [0,0,0,0,1,2,0,0,0,0],
//    [0,0,0,0,0,0,0,0,0,0],
//    [0,0,0,0,0,0,0,0,0,0],
//    [0,0,0,0,0,0,0,0,0,0],
//    [0,0,0,0,0,0,0,0,0,0],
//];

class OthelloView: UIView {

    var board:[[Int]] = []
    let white = UIColor.whiteColor().CGColor
    let black = UIColor.blackColor().CGColor
    let green = UIColor(red:0.6, green:1.0, blue:0.2, alpha:1.0).CGColor
    var side:CGFloat = 0.0
    var top:CGFloat = 0.0
    let left:CGFloat = 0
    let lbl:UILabel = UILabel()
    var isGameOver = false
    
    
    required init(coder aDecoder: NSCoder) {
        let appFrame = UIScreen.mainScreen().bounds
        side = appFrame.size.width / BOARD_X
        top = (appFrame.size.height - (side * BOARD_Y)) / 2
        board = initboard
        
        super.init(coder:aDecoder)!
        
        lbl.text = ""
        //lbl.frame = CGRectMake(10, top / 2, appFrame.size.width, top / 2)
        lbl.frame = CGRectMake(10, 10, appFrame.size.width, appFrame.size.height)
        
        addSubview(lbl)
    }

    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        CGContextSetLineWidth(context, 1.5)
        
        for y in 1...BOARD_INTY {
            for x in 1...BOARD_INTX {
                let rx = left + side * CGFloat(x-1)
                let ry = top + side * CGFloat(y-1)
                let rect = CGRectMake(rx, ry, side, side)
                CGContextSetFillColorWithColor(context, green)
                CGContextFillRect(context, rect)
                CGContextStrokeRect(context, rect)
                
                if board[y][x] == BLACK_STONE {
                    CGContextSetFillColorWithColor(context, black)
                    CGContextFillEllipseInRect(context, rect) // draw black stone
                } else if board[y][x] == WHITE_STONE {
                    CGContextSetFillColorWithColor(context, white)
                    CGContextFillEllipseInRect(context, rect) // draw white stone
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isGameOver {
            board = initboard
            updateGame()
            setNeedsDisplay()
            return
        }
        if let _ = FlipModel.canPlaced(board, stone: BLACK_STONE) { // player can put black stone.
            if let (x, y) = getPos(touches) {
                if let blackPlaces = FlipModel.flip(board, x: x, y: y, stone: BLACK_STONE) {
                    putStones(blackPlaces, stone: BLACK_STONE)
                    if let whitePlaces = FlipModel.cpuFlip(board, stone: WHITE_STONE) {
                        putStones(whitePlaces, stone: WHITE_STONE)
                    }
                }
            }
        } else {
            if let whitePlaces = FlipModel.cpuFlip(board, stone: WHITE_STONE) {
                putStones(whitePlaces, stone: WHITE_STONE)
            }
        }
        updateGame()
        setNeedsDisplay()
    }

    
    func getPos(touches: NSSet!) -> (Int, Int)? {
        //let touch = touches.anyObas!ct() as UITouch
        let touch = touches.anyObject() as! UITouch
        let point = touch.locationInView(self)
        for y in 1...BOARD_INTY {
            for x in 1...BOARD_INTX {
                let rx = left + side * CGFloat(x-1)
                let ry = top + side * CGFloat(y-1)
                let rect = CGRectMake(rx, ry, side, side)
                if CGRectContainsPoint(rect, point) {
                    return (x, y)
                }
            }
        }
        return nil
    }
    
    func putStones(places:[(Int, Int)], stone: Int) {
        for (x, y) in places {
            board[y][x] = stone
        }
    }
    
    func updateGame() {
        let (free, black, white) = FlipModel.calcStones(board)
        let canBlack = FlipModel.canPlaced(board, stone: BLACK_STONE)
        let canWhite = FlipModel.canPlaced(board, stone: WHITE_STONE)
        if free == 0 || (canBlack == nil && canWhite == nil) {
            lbl.text = "Game Over (Black:\(black) White:\(white))"
            isGameOver = true
        } else {
            lbl.text = ""
            isGameOver = false
        }
    }
}

