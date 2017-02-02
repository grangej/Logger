#Logger


Logger is a extendable logging platform supporting various severity levels. 

###About

Logger is used to send logs to both console and remote / crash / collection frameworks. 

The framework consits of the main Logger enum and Extensions that add support for addtional reporters. 
The reports support the ability to inject frameworks that are not part of the logger platform to prevent any dependnices. Currently we still need to compile in addtional collectors.

*TODO: In the future this needs to made more generic*

###Documentation

Documentation is generated automaticly by [Jazzy](https://github.com/realm/jazzy)

[Logger Documentation](docs/index.html)

###Requirements

Requires Swift 2.3, currently but will move to Swift 3. At such point we will mark a verison that will be backwards compatible with Swift 2.3.