//
//  CalculateModel.swift
//  MycalculatorSwift
//
//  Created by ilabadmin on 2/6/17.
//  Copyright © 2017 vodacom. All rights reserved.
//

import Foundation

func multiply(op1: Double, op2: Double) -> Double {
    return op1 * op2
}

func random() -> Double {
    return drand48()
}

class CalculatorModel {
    
    private var accumulator = 0.0
    private var memory: [String] = []
    private var lastOperation :LastOperation = .Clear
    
    private let dots: String = " ..."
    
    private let operations: Dictionary<String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt),
        "cos": Operation.UnaryOperation(cos),
        "sin": Operation.UnaryOperation(sin),
        "tan": Operation.UnaryOperation(tan),
        "log10": Operation.UnaryOperation(log10),
         "%" : Operation.UnaryOperation({ $0/100}),
        "×": Operation.BinaryOperation({ $0 * $1 }),
        "−": Operation.BinaryOperation({ $0 - $1 }),
        "÷": Operation.BinaryOperation({ $0 / $1 }),
        "+": Operation.BinaryOperation({ $0 + $1 }),
       "=": Operation.Equals,
        "c": Operation.Clear
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    private enum LastOperation {
        case Digit
        case Constant
        case UnaryOperation
        case BinaryOperation
        case Equals
        case Clear
    }
    
    func setOperand(operand: Double) {
        if lastOperation == .UnaryOperation {
            memory.removeAll()
        }
        
        accumulator = operand
        memory.append(String(operand))
        lastOperation = .Digit
    }
    
    func performOperand(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                memory.append(symbol)
                accumulator = value
                lastOperation = .Constant
            case .UnaryOperation(let function):
                wrapWithParens(symbol)
                accumulator = function(accumulator)
                lastOperation = .UnaryOperation
            case .BinaryOperation(let function):
                if lastOperation == .Equals {
                    memory.removeLast()
                }
                memory.append(symbol)
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                lastOperation = .BinaryOperation
            case .Equals:
                if lastOperation == .BinaryOperation {
                    memory.append(String(accumulator))
                }
                memory.append(symbol)
                executePendingBinaryOperation()
                lastOperation = .Equals
            case .Clear:
                clear()
                lastOperation = .Clear
            }
        }
    }
    
    var result: Double {
        get {
            return accumulator;
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    var description: String {
        get {
            if pending != nil {
                return memory.joinWithSeparator(" ") + dots
            }
            
            return memory.joinWithSeparator(" ")
        }
    }
    
    private func wrapWithParens(symbol: String) {
        if lastOperation == .Equals {
            memory.insert(")", atIndex: memory.count - 1)
            memory.insert(symbol, atIndex: 0)
            memory.insert("(", atIndex: 1)
        } else {
            memory.insert(symbol, atIndex: memory.count - 1)
            memory.insert("(", atIndex: memory.count - 1)
            memory.insert(")", atIndex: memory.count)
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private func clear() {
        accumulator = 0
        pending = nil
        memory.removeAll()
        lastOperation = .Clear
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
}