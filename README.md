**Build status**

master:
[![Build Status](https://travis-ci.org/grangej/Logger.svg?branch=master)](https://travis-ci.org/grangej/Logger)
dev:
[![Build Status](https://travis-ci.org/grangej/Loggersvg?branch=dev)](https://travis-ci.org/grangej/Logger)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/grangej/Logger/LICENSE)
# Logger

Logger is a extendable logging platform supporting various severity levels. 

### About

Logger is a consists of the main class Logger and one or more outputs. It also understands the concept 
batch sending and can flush outputs that support batching. 

Definining new logger outputs is easy to do, just comply to the protocol LoggerOutput, and optionally BatchLoggerOutput.

### Requirements

Requires Swift 4.0, and is targeting iOS 10+
