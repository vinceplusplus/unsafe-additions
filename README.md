<p>
  <a href="https://github.com/vinceplusplus/unsafe-additions/actions?query=workflow%3Atest+event%3Apush">
    <img src="https://github.com/vinceplusplus/unsafe-additions/workflows/test/badge.svg?event=push">
  </a>
  <a href="https://codecov.io/gh/vinceplusplus/unsafe-additions">
    <img src="https://codecov.io/gh/vinceplusplus/unsafe-additions/branch/main/graph/badge.svg" />
  </a>
</p>

# UnsafeAdditions

`UnsafeAdditions` is a collection of additions to help manipulate unsafe pointers more easily in Swift 

Accessing pointer from array
```swift
let array = [1, 2]
array.withUnsafePointer { pointer in
  print(pointer[0]) // 1
  print(pointer[1]) // 2
}

var array = [0, 0]
array.withUnsafePointer { pointer in
  array2[0] = 3
  array2[1] = 4
}
```

Reference types to manage buffer life cycle
```swift
do {
  let buffer = UnsafeBuffer.allocate(copying: [1, 2])
  print(buffer.pointer[0]) // 1
  print(buffer.pointer[1]) // 2
  let buffer2 = buffer // internal memory is not copied because UnsafeBuffer is a class type
  let bufferPointer: UnsafeBufferPointer<Int> = buffer.bufferPointer
  // internal memory will be deallocated after exiting the scope
}

do {
  let buffer = UnsafeMutableBuffer.allocate(capacity: 2, repeating: 0)
  buffer.pointer[0] = 3
  buffer.pointer[1] = 4
  let bufferPointer: UnsafeMutableBufferPointer<Int> = buffer.bufferPointer
  // internal memory will be deallocated after exiting the scope
}
```

Rebind pointer to given type
```swift
let array: [UInt32] = [0x90abcdef]
array.withUnsafePointer { pointer in
  pointer.withReboundUnsafePointer(to: UInt8.self) { uInt8Pointer in
    print(uInt8Pointer[0]) // 0xef
    print(uInt8Pointer[1]) // 0xcd
    print(uInt8Pointer[2]) // 0xab
    print(uInt8Pointer[3]) // 0x90
  }
}

var array: [UInt32] = [0]
array.withUnsafeMutablePointer { pointer in
  pointer.withReboundUnsafeMutablePointer(to: UInt8.self) { uInt8Pointer in
    uInt8Pointer[0] = 0x78
    uInt8Pointer[1] = 0x56
    uInt8Pointer[2] = 0x34
    uInt8Pointer[3] = 0x12
  }
}
print(array[0]) // 0x12345678
```

Rebindable pointer to support late bind
```swift
let array: [UInt32] = [0x12345678]
array.withUnsafePointer { pointer in
  pointer.withUnsafeRebindablePointer { rebindablePointer in
    let uInt8Pointer: UnsafePointer<UInt8> = rebindablePointer.rebound()
    print(uInt8Pointer[0]) // 0x78
    print(uInt8Pointer[1]) // 0x56
    print(uInt8Pointer[2]) // 0x34
    print(uInt8Pointer[3]) // 0x12
  }
}

var array: [UInt32] = [0]
array.withUnsafeMutablePointer { pointer in
  pointer.withUnsafeRebindableMutablePointer { rebindablePointer in
    let uInt8Pointer: UnsafeMutablePointer<UInt8> = rebindablePointer.rebound()
    uInt8Pointer[0] = 0xef
    uInt8Pointer[1] = 0xcd
    uInt8Pointer[2] = 0xab
    uInt8Pointer[3] = 0x90
  }
}
print(array[0]) // 0x90abcdef
```

## Usage

### Installation

To install through Xcode, follow the [official guide](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) to add the following your Xcode project
```
https://github.com/vinceplusplus/unsafe-additions
```

To install through Swift Package Manager, add the following as package dependency and target dependency respectively
```
.package(url: "https://github.com/vinceplusplus/unsafe-additions", from: "1.0.0")
```
```
.product(name: "UnsafeAdditions", package: "unsafe-additions")
```

### Integration

Import module `UnsafeAdditions`

Use the provided additions in this package

