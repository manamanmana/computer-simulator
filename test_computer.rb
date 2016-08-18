require('test/unit')
require('./computer')
require('./errors')

# Test Case for Computer Class
class TCComputer < Test::Unit::TestCase
  def setup
    @computer = Computer.new(100)
  end

  def test_initialize
    assert_equal(100, @computer.memory_stack.size)
    assert_equal(nil, @computer.memory_stack[0])
    assert_equal(nil, @computer.memory_stack[99])
    assert_equal(100, @computer.memory_stack_size)
    assert_equal(0, @computer.program_counter)
    assert_equal(100, @computer.stack_pointer)
  end

  def test_set_address
    # address must be Integer
    assert_raise(InvalidAddressTypeError) do
      @computer.set_address('address')
    end
    # Address must be range of 0..99
    assert_raise(InvalidAddressPointerError) do
      @computer.set_address(-1)
    end
    assert_raise(InvalidAddressPointerError) do
      @computer.set_address(1000)
    end
    # Return value of set_address is Computer instanse itself
    assert_same(@computer, @computer.set_address(1))
    # set_address method assign address to program counter
    @computer.set_address(3)
    assert_equal(3, @computer.program_counter)
  end

  def test_insert
    @computer.set_address(0)
    # Returned value of insert is Computer instance itself
    assert_same(@computer, @computer.insert('PRINT'))
    # Instruction type must be String
    assert_raise(InvalidInstructionTypeError) do
      @computer.insert(0)
    end
    # Inserted Instruction must be Hash
    @computer.set_address(0).insert('PUSH', 1009)
    assert_equal({ instruction: 'PUSH', operand: 1009 },
                 @computer.memory_stack[0])
    # Ensure program counter is incremented
    @computer.set_address(0).insert('PUSH', 1009)
    assert_equal(1, @computer.program_counter)
    @computer.insert('PRINT')
    assert_equal(2, @computer.program_counter)
  end

  def test_push
    # Test raise StackOverFlowError if the next memory stack cell has data
    @computer.set_address(99).insert('PRINT')
    assert_raise(StackOverFlowError) do
      @computer.send(:push, 1)
    end
    # Reset the error status
    @computer = Computer.new(100)
    # Test the decrement behaviour of stack pointer
    @computer.send(:push, 100)
    assert_equal(99, @computer.stack_pointer)
    # Test the push arg is correctly put on the current stack pointer
    assert_equal(100, @computer.memory_stack[99])
    # Test the program counter is incremented
    assert_equal(1, @computer.program_counter)
  end

  def test_pop
    # At first clear up and create a computer again
    @computer = Computer.new(100)
    # At the inital stack is all emoty,
    # so EmptyStackError is raised if pop is called
    assert_raise(EmptyStackError) do
      @computer.send(:pop)
    end
    # push the values
    @computer.send(:push, 100) # stack_pointer should be 99
    @computer.send(:push, 200) # stack_pointer should be 98
    # The first popped value mast be 200
    assert_equal(200, @computer.send(:pop))
    # Ensure popped memory stack area is nil
    assert_equal(nil, @computer.memory_stack[98])
    # Current stack pointer should be 99
    assert_equal(99, @computer.stack_pointer)
    # The second popped value mast be 100
    assert_equal(100, @computer.send(:pop))
    # Ensure popped memory stack area is nil
    assert_equal(nil, @computer.memory_stack[99])
    # Current stack pointer should be 99
    assert_equal(100, @computer.stack_pointer)
    # push the value again
    @computer.send(:push, nil)
    assert_raise(EmptyStackError) do
      @computer.send(:pop)
    end
  end

  def test_print
    # At first clear up and create a computer again
    # Program counter should be 0
    @computer = Computer.new(100)
    # Call push private method and put 1009 on the stack
    @computer.send(:push, 1009)
    @computer.send(:print) # Sould be output 1009 to stdout
    # Program counter should be 2 after 2 private instructions
    assert_equal(2, @computer.program_counter)
    # Stack pointer should be 100 after popped.
    assert_equal(100, @computer.stack_pointer)
    # The memory stack cell which is popped should be nil
    assert_equal(nil, @computer.memory_stack[99])
  end
end
