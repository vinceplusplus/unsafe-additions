public struct UnsafeRebindableMutablePointer {
  private let pointer: UnsafeMutableRawPointer

  public init(_ pointer: UnsafeMutableRawPointer) {
    self.pointer = pointer
  }
  
  public func rebound<T>() -> UnsafeMutablePointer<T> {
    pointer.assumingMemoryBound(to: T.self)
  }
}

