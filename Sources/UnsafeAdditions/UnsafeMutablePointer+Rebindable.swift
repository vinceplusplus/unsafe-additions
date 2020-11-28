public extension UnsafeMutablePointer {
  func withUnsafeRebindablePointer<R>(_ body: (UnsafeRebindablePointer) throws -> R) rethrows -> R {
    try body(.init(UnsafeRawPointer(self)))
  }
  
  func withUnsafeRebindableMutablePointer<R>(_ body: (UnsafeRebindableMutablePointer) throws -> R) rethrows -> R {
    try body(.init(UnsafeMutableRawPointer(self)))
  }
}

