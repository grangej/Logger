#Logger

Logger is a extendable logging platform supporting various severity levels. 

###About

Logger is a consists of the main class Logger and one or more outputs. It also understands the concept 
batch sending and can flush outputs that support batching. 

Definining new logger outputs is easy to do, just comply to the protocol LoggerOutput, and optionally BatchLoggerOutput.

###Requirements

Requires Swift 4.0, and is targeting iOS 10+
