#
# Invalid Address Type Error
#
class InvalidAddressTypeError < StandardError
  def initialize(message = nil)
    message = 'Invalid Address Type: Address type must be int.' if message.nil?
    super(message)
  end
end

#
# Invalid Address Pointer Error
#
class InvalidAddressPointerError < StandardError
  def initialize(message = nil)
    message = 'Invalid Address Pointer: \
              Address is out of range on memory stack' if message.nil?
    super(message)
  end
end

#
# Invalid Instruction Type Error
#
class InvalidInstructionTypeError < StandardError
  def initialize(message = nil)
    message = 'Invalid Instruction Type: \
              Instruction must be String' if message.nil?
    super(message)
  end
end

#
# Stack Over Flow Error
#
class StackOverFlowError < StandardError
  def initialize(message = nil)
    message = 'Stack Over Flow Error: \
              data exists at the address \
              you try to push the value' if message.nil?
    super(message)
  end
end

#
# Empty Stack Error
#
class EmptyStackError < StandardError
  def initialize(message = nil)
    message = 'Empty Stack Error: \
              Stack is totally empty or popped value is nil' if message.nil?
    super(message)
  end
end
