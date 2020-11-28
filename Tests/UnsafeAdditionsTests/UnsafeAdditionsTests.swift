import XCTest
@testable import UnsafeAdditions

final class UnsafeAdditionsTests: XCTestCase {
  func pretendToThrow() throws {}
  
  func testArrayWithUnsafePointer() {
    let array = [1, 2, 3, 4]
    array.withUnsafePointer { pointer in
      XCTAssertEqual(pointer[0], 1)
      XCTAssertEqual(pointer[1], 2)
    }
    do {
      try array.withUnsafePointer { pointer in
        try pretendToThrow()
        XCTAssertEqual(pointer[2], 3)
        XCTAssertEqual(pointer[3], 4)
      }
    } catch {
      assert(false, "shouldn't reach here")
    }
  }
  
  func testArrayWithUnsafeMutablePointer() {
    var array = [0, 0, 0, 0]
    array.withUnsafeMutablePointer { pointer in
      pointer[0] = 5
      pointer[1] = 6
    }
    XCTAssertEqual(array[0], 5)
    XCTAssertEqual(array[1], 6)
    
    do {
      try array.withUnsafeMutablePointer { pointer in
        try pretendToThrow()
        pointer[2] = 7
        pointer[3] = 8
      }
    } catch {
      assert(false, "shouldn't reach here")
    }
    XCTAssertEqual(array[2], 7)
    XCTAssertEqual(array[3], 8)
  }
  
  func testUnsafeBuffer() {
    let buffer = UnsafeBuffer.allocate(copying: [1, 2, 3, 4])
    XCTAssertEqual(buffer.pointer[0], 1)
    XCTAssertEqual(buffer.pointer[1], 2)
    XCTAssertEqual(buffer.pointer[2], 3)
    XCTAssertEqual(buffer.pointer[3], 4)
    XCTAssertEqual(buffer.pointer[0], buffer.bufferPointer[0])
    XCTAssertEqual(buffer.pointer[1], buffer.bufferPointer[1])
    XCTAssertEqual(buffer.pointer[2], buffer.bufferPointer[2])
    XCTAssertEqual(buffer.pointer[3], buffer.bufferPointer[3])
    if let bufferPointerBaseAddress = buffer.bufferPointer.baseAddress {
      XCTAssertEqual(buffer.pointer, bufferPointerBaseAddress)
    } else {
      assert(false, "shouldn't reach here")
    }
  }
  
  func testUnsafeMutableBuffer() {
    let buffer = UnsafeMutableBuffer.allocate(capacity: 4, repeating: 0)
    XCTAssertEqual(buffer.pointer[0], 0)
    XCTAssertEqual(buffer.pointer[1], 0)
    XCTAssertEqual(buffer.pointer[2], 0)
    XCTAssertEqual(buffer.pointer[3], 0)
    buffer.pointer[0] = 5
    buffer.pointer[1] = 6
    buffer.bufferPointer[2] = 7
    buffer.bufferPointer[3] = 8
    
    XCTAssertEqual(buffer.pointer[0], 5)
    XCTAssertEqual(buffer.pointer[1], 6)
    XCTAssertEqual(buffer.pointer[2], 7)
    XCTAssertEqual(buffer.pointer[3], 8)
    XCTAssertEqual(buffer.pointer[0], buffer.bufferPointer[0])
    XCTAssertEqual(buffer.pointer[1], buffer.bufferPointer[1])
    XCTAssertEqual(buffer.pointer[2], buffer.bufferPointer[2])
    XCTAssertEqual(buffer.pointer[3], buffer.bufferPointer[3])
    if let bufferPointerBaseAddress = buffer.bufferPointer.baseAddress {
      XCTAssertEqual(buffer.pointer, bufferPointerBaseAddress)
    } else {
      assert(false, "shouldn't reach here")
    }
  }
  
  func testRebindableWithUnsafePointer() {
    let array: [UInt32] = [0x12345678]
    array.withUnsafePointer { pointer in
      pointer.withUnsafeRebindablePointer { rebindablePointer in
        let uInt8Pointer: UnsafePointer<UInt8> = rebindablePointer.rebound()
        XCTAssertEqual(uInt8Pointer[0], 0x78)
        XCTAssertEqual(uInt8Pointer[1], 0x56)
        XCTAssertEqual(uInt8Pointer[2], 0x34)
        XCTAssertEqual(uInt8Pointer[3], 0x12)
      }
    }
  }
  
  func testRebindableWithUnsafeMutablePointer() {
    var array: [UInt32] = [0]
    array.withUnsafeMutablePointer { pointer in
      pointer.withUnsafeRebindableMutablePointer { rebindablePointer in
        let uInt8Pointer: UnsafeMutablePointer<UInt8> = rebindablePointer.rebound()
        uInt8Pointer[0] = 0xef
        uInt8Pointer[1] = 0xcd
        uInt8Pointer[2] = 0xab
        uInt8Pointer[3] = 0x90
      }
      pointer.withUnsafeRebindablePointer { rebindablePointer in
        let uInt8Pointer: UnsafePointer<UInt8> = rebindablePointer.rebound()
        XCTAssertEqual(uInt8Pointer[0], 0xef)
        XCTAssertEqual(uInt8Pointer[1], 0xcd)
        XCTAssertEqual(uInt8Pointer[2], 0xab)
        XCTAssertEqual(uInt8Pointer[3], 0x90)
      }
    }
    XCTAssertEqual(array[0], 0x90abcdef)
  }
  
  func testReboundUnsafePointer() {
    let array: [UInt32] = [0x90abcdef]
    array.withUnsafePointer { pointer in
      pointer.withReboundUnsafePointer(to: UInt8.self) { uInt8Pointer in
        XCTAssertEqual(uInt8Pointer[0], 0xef)
        XCTAssertEqual(uInt8Pointer[1], 0xcd)
        XCTAssertEqual(uInt8Pointer[2], 0xab)
        XCTAssertEqual(uInt8Pointer[3], 0x90)
      }
    }
  }
  
  func testReboundUnsafeMutablePointer() {
    var array: [UInt32] = [0]
    array.withUnsafeMutablePointer { pointer in
      pointer.withReboundUnsafeMutablePointer(to: UInt8.self) { uInt8Pointer in
        uInt8Pointer[0] = 0x78
        uInt8Pointer[1] = 0x56
        uInt8Pointer[2] = 0x34
        uInt8Pointer[3] = 0x12
      }
      pointer.withReboundUnsafePointer(to: UInt8.self) { uInt8Pointer in
        XCTAssertEqual(uInt8Pointer[0], 0x78)
        XCTAssertEqual(uInt8Pointer[1], 0x56)
        XCTAssertEqual(uInt8Pointer[2], 0x34)
        XCTAssertEqual(uInt8Pointer[3], 0x12)
      }
    }
    XCTAssertEqual(array[0], 0x12345678)
  }
  
  static var allTests = [
    ("testArrayWithUnsafePointer", testArrayWithUnsafePointer),
    ("testArrayWithUnsafeMutablePointer", testArrayWithUnsafeMutablePointer),
    ("testUnsafeBuffer", testUnsafeBuffer),
    ("testUnsafeMutableBuffer", testUnsafeMutableBuffer),
    ("testRebindableWithUnsafePointer", testRebindableWithUnsafePointer),
    ("testRebindableWithUnsafeMutablePointer", testRebindableWithUnsafeMutablePointer),
    ("testReboundUnsafePointer", testReboundUnsafePointer),
    ("testReboundUnsafeMutablePointer", testReboundUnsafeMutablePointer),
  ]
}

