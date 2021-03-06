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

  def test_call
    # At first clear up and create a computer again
    # Program counter should be 0
    @computer = Computer.new(100)
    # call private method must be called with Integer arg
    assert_raise(InvalidAddressTypeError) do
      @computer.send(:call, 'hoge')
    end
    # Execute call() private method with arg 55.
    @computer.send(:call, 55)
    # program counter should be 55
    assert_equal(55, @computer.program_counter)
  end

  def test_mult
    # At first clear up and create a computer again
    # Program counter should be 0
    @computer = Computer.new(100)
    @computer.send(:push, 'hoge')
    @computer.send(:push, 101)
    # Raise InvalidMultArgTypeError
    # because one of pushed stack value is not integer
    assert_raise(InvalidMultArgTypeError) do
      @computer.send(:mult)
    end
    # Clear and recreate computer again
    # Program counter sould be 0 again
    @computer = Computer.new(100)
    # Push the 2 Integer into the stack
    @computer.send(:push, 10)
    @computer.send(:push, 101)
    # Execute mult
    @computer.send(:mult)
    # Mult result should be at the end of memory stack(99)
    assert_equal(1010, @computer.memory_stack[99])
    assert_equal(nil, @computer.memory_stack[98])
    # Program counter should be 3 because of 3 direct instructions
    assert_equal(3, @computer.program_counter)
  end

  def test_ret
    # At first clear up and create a computer again
    # Program counter should be 0
    @computer = Computer.new(100)
    # Set the STOP instruction at the program counter 10
    @computer.set_address(10).insert('STOP')
    # Push the String into stack
    @computer.send(:push, 'hoge')
    assert_raise(InvalidAddressTypeError) do
      @computer.send(:ret)
    end
    # Push the next Integer value into stack
    @computer.send(:push, 10)
    # Execute ret private method
    @computer.send(:ret)
    # Current program counter should be 10
    assert_equal(10, @computer.program_counter)
    # Current instruction should be 'STOP'
    program_counter = @computer.program_counter
    assert_equal('STOP',
                 @computer.memory_stack[program_counter][:instruction])
  end

  def test_run
    # At first clear up and create a computer again
    # Program counter should be 0
    @computer = Computer.new(100)
    # Insert invalid instruction into program stack
    @computer.set_address(0).insert('PUSH', 10).insert('HOGE')
    @computer.set_address(0)
    assert_raise(UnknownInstructionError) do
      @computer.send(:run)
    end
    # Reset the computer
    @computer = Computer.new(100)
    # Insert function 3 instructions from program counter 50 => 50, 51, 52
    @computer.set_address(50).insert('MULT').insert('PRINT').insert('RET')
    # Insert main 7 instructions from program counter 0
    # => 0: PUSH, 1019
    # => 1: PRINT
    # => 2: PUSH, 6
    # => 3: PUSH, 102
    # => 4: PUSH, 10
    # => 5: CALL, 50
    # => 6: STOP
    @computer.set_address(0).insert('PUSH', 1019).insert('PRINT')
    @computer.insert('PUSH', 6)
    @computer.insert('PUSH', 102).insert('PUSH', 10).insert('CALL', 50)
    @computer.insert('STOP')
    @computer.set_address(0)
    @computer.send(:run) # This prints 1019 and 1020 on stdout
    # After program run, program counter should be 6
    assert_equal(6, @computer.program_counter)
    # After program run, all the stack values are popped
    # so the stack pointer should be 100
    assert_equal(100, @computer.stack_pointer)
  end
end
