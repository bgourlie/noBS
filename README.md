[![Build Status](https://travis-ci.org/bgourlie/noBS.svg?branch=master)](https://travis-ci.org/bgourlie/noBS)

# noBS Exercise Logger

### What is it?

noBS Exercise Logger is my attempt at creating a simple and useful tool for logging workouts using modern web technologies, some of which are still developing standards.  As such, it is currently only supported in Chrome, with the expectation that other browsers will be supported as they implement the standards on which noBS is built.

The latest version is continuosly deployed to http://www.nobs.io provided the build is passing. 

### Development Philosophy

Unlike many web applications that make reasonable attempts to support as many browsers as possible, no such efforts will be made developing noBS.  As of this writing, I feel pretty strongly about this, even going as far as to not polyfill missing functionality in non-Chrome browsers.

The motivation behind this is to allow myself (and anyone who contributes) to focus on writing clean and straightforward code without the burden of worrying about non-standard or differing browser implementations.  So long as noBS is built on standard technologies, browser support should catch up.

The following is a list of technologies used in noBS that are currently limiting browser support:

- [Shadow DOM](http://caniuse.com/#search=shadowdom)
- [IndexedDB](http://caniuse.com/#feat=indexeddb)
