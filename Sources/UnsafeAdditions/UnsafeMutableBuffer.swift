public final class UnsafeMutableBuffer<T> {
  public let pointer: UnsafeMutablePointer<T>
  public let bufferPointer: UnsafeMutableBufferPointer<T>
  
  private init(pointer: UnsafeMutablePointer<T>, bufferPointer: UnsafeMutableBufferPointer<T>) {
    self.pointer = pointer
    self.bufferPointer = bufferPointer
  }
  
  deinit {
    pointer.deallocate()
  }
  
  public static func allocate(capacity: Int, repeating repeatedValue: T?) -> Self {
    let pointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
    let bufferPointer = UnsafeMutableBufferPointer(start: pointer, count: capacity)
    if let repeatedValue = repeatedValue {
      bufferPointer.initialize(repeating: repeatedValue)
    }
    return .init(pointer: pointer, bufferPointer: bufferPointer)
  }
}

