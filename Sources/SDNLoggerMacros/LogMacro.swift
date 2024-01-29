import Foundation
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum LogMacroError: Error {
    case missingLevel
    case missingMessage
    case missingLabel
    
}

struct ParsedArguments {
    var message: SwiftSyntax.ExprSyntax
    var level: SwiftSyntax.ExprSyntax?
    var metadata: SwiftSyntax.ExprSyntax?
    var source: SwiftSyntax.ExprSyntax?
    var category: SwiftSyntax.ExprSyntax?
}

func parseArguments(argumentList: SwiftSyntax.LabeledExprListSyntax) throws -> ParsedArguments {

    let startIndex = argumentList.startIndex
    let message = argumentList[startIndex].expression

    var parsedArgs = ParsedArguments(message: message, level: nil)

    for argument in argumentList.dropFirst(1) {
        
        guard let label = argument.label?.text else { throw LogMacroError.missingLabel }

        switch label {
        case "metadata":
            parsedArgs.metadata = argument.expression
        case "source":
            parsedArgs.source = argument.expression
        case "category":
            parsedArgs.category = argument.expression
        case "level":
            parsedArgs.level = argument.expression
        default:
            break
        }
    }

    return parsedArgs
}


func optionalArgumentsString(from parsedArguments: ParsedArguments) -> String {
    var optionalArgsString = ""

    if let metadata = parsedArguments.metadata {
        optionalArgsString += ", metadata: \(metadata)"
    }
    if let source = parsedArguments.source {
        optionalArgsString += ", source: \(source)"
    }
    if let category = parsedArguments.category {
        optionalArgsString += ", source: \(category).categoryKey"
    }

    return optionalArgsString
}

public struct LogMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        guard let level = parsedArguments.level else { throw LogMacroError.missingLevel }
        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().log(level: \(level), \(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

public struct DebugMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().debug(\(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

public struct TraceMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().trace(\(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

public struct InfoMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().info(\(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

public struct WarningMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().warning(\(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

public struct ErrorMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().error(\(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

public struct CriticalMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().critical(\(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

public struct ErrorLogWithErrorMacro: ExpressionMacro, Sendable {
    public static func expansion(of node: some SwiftSyntax.FreestandingMacroExpansionSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> SwiftSyntax.ExprSyntax {
        
        
        let parsedArguments = try parseArguments(argumentList: node.argumentList)

        // Construct the log call in parts to avoid complexity
        var logCall = "Logger().error(error: \(parsedArguments.message)"
        
        logCall += optionalArgumentsString(from: parsedArguments)

        logCall += ")"
        
        return ExprSyntax(stringLiteral: logCall)
    }
}

@main
struct SDNLoggerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        LogMacro.self,
        DebugMacro.self,
        TraceMacro.self,
        InfoMacro.self,
        WarningMacro.self,
        ErrorMacro.self,
        CriticalMacro.self,
        ErrorLogWithErrorMacro.self,
    ]
}
