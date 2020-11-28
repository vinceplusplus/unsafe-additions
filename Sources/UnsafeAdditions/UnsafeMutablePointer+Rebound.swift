public extension UnsafeMutablePointer {
  func withReboundUnsafePointer<T, R>(to type: T.Type, _ body: (UnsafePointer<T>) throws -> R) rethrows -> R {
    try body(UnsafeRawPointer(self).assumingMemoryBound(to: type))
  }
  
  func withReboundUnsafeMutablePointer<T, R>(to type: T.Type, _ body: (UnsafeMutablePointer<T>) throws -> R) rethrows -> R {
    try body(UnsafeMutableRawPointer(self).assumingMemoryBound(to: type))
  }
}

