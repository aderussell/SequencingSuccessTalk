//
//  GameOfLifeExample.swift
//

import Foundation

extension Grid where Element == Int {
    func gameOfLife(alive: Int = 1, dead: Int = 0) -> Self {
        indices.reduce(into: Grid(width: width, height: height, initial: 0)) { newGrid, point in
            let count = self.border(center: point, wrapGrid: true).sum()
            newGrid[point] = dead
            if count == 3 {
                newGrid[point] = alive
            }
            if count == 2 && self[point] == alive {
                newGrid[point] = alive
            }
        }
    }
}

func runGameOfLifeExample() {
    var grid = Grid(width: 10, height: 10, initial: 0)
    grid[Point(x: 1, y: 1)] = 1
    grid[Point(x: 2, y: 1)] = 1
    grid[Point(x: 3, y: 1)] = 1
    
    grid[Point(x: 6, y: 6)] = 1
    grid[Point(x: 6, y: 7)] = 1
    grid[Point(x: 6, y: 8)] = 1
    grid[Point(x: 5, y: 8)] = 1
    grid[Point(x: 4, y: 7)] = 1
    
    
    for _ in 0..<20 {
        grid.print(value: { grid[$0] == 1 ? "X" : "." })
        grid = grid.gameOfLife()
        print("-----------------")
    }
}
