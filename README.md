# pingo

![Language](https://img.shields.io/badge/language-Swift%205-green.svg)

A wrapper of [fping](https://github.com/schweikert/fping) which is a high performance ping tool. More information about fping is available [here](https://fping.org/).

## Installation

### CocoaPods

add the following line to your Podfile:

``` 
pod "pingo"
```


## Usage

``` swift
import pingo

Pingo.ping(hosts: ["zoom.com", "cnn.com", "icloud.com"], progress: { (progress) in
    print(progress)
}) { (result) in
    print(result)
}
```

The `progress` is a float number between 0-1.

The `result` is a dictionary which key is host string, value is `PingoResult`.

Notice that FpingxResult is a struct defined as:

``` swift
public struct PingoResult {

    public let host: String

    /// number of sent
    public let xmt: Int

    /// number of received
    public let rcv: Int

    /// loss percentage (value from 0-100)
    public var loss: Int {
        return xmt > 0 ? (xmt - rcv) * 100 / xmt : 0
    }

    /// nil if rcv is 0
    public let avg: Int?

    /// nil if rcv is 0
    public let min: Int?

    /// nil if rcv is 0
    public let max: Int?
    
    public let jitt: Float?

}

```


## Credits of fping

Credits to https://github.com/jzau

Current maintainer: David Schweikert \<david@schweikert.ch\>

The original author: Roland Schemers (schemers@stanford.edu) Previous maintainer: RL "Bob" Morgan (morgan@stanford.edu) Initial IPv6 Support: Jeroen Massar (jeroen@unfix.org / jeroen@ipng.nl) Other contributors: see ChangeLog
