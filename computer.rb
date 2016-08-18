require('./errors')
#
# Computer Class which simulates computer
#
class Computer
  # For Unit testing, only for reading instance variables
  attr_reader :memory_stack, :memory_stack_size, :program_counter,
              :stack_pointer
  def initialize(computer_memory_size)
    # Memory stack array of this computer
    @memory_stack = Array.new(computer_memory_size)
    # Memory stack size to reduce to call size method
    @memory_stack_size = computer_memory_size
    # Initial position of program counter is at the first of memory stack
    @program_counter = 0
    # Initial position of stack pointer is at the end of memory stack + 1
    @stack_pointer = @memory_stack_size
  end

  #
  # Public Methods
  #
  def set_address(address)
    # address arg must be Integer
    raise InvalidAddressTypeError.new unless address.is_a?(Integer)
    # address is inside memory stack range
    raise InvalidAddressPointerError.new \
      unless address >= 0 && address <= @memory_stack_size - 1
    # set the address to program counter
    @program_counter = address
    # return self for method chain
    self
  end

  def insert(instruction, operand = nil)
    # instruction arg must be String
    raise InvalidInstructionTypeError.new unless instruction.is_a?(String)
    # Assign Hash of instruction and operand into Memory stack
    @memory_stack[@program_counter] = { instruction: instruction,
                                        operand: operand }
    # Increment current program counter to next cell
    @program_counter += 1
    # return self for method chain
    self
  end

  def execute
    run
  end

  #
  # Private Methods
  #
  private

  def push(arg)
    # Raise Stack Over Flow Error
    # if the value of the cell at the current stack_pointer - 1
    # is not Nil
    raise StackOverFlowError.new unless @memory_stack[@stack_pointer - 1].nil?
    # Decrement stack_pointer address at first
    @stack_pointer -= 1
    # Assign the arg value to memory cell at the current stack pointer
    @memory_stack[@stack_pointer] = arg
    # Increment program counter because this is a direct instruction.
    @program_counter += 1
  end

  def pop
    # As this method is not direct instruction,
    # so this does not increment program counter

    # If stack_pointer and memory_stack_size are equal
    # This means stack_pointer is initial positon
    # and there is no stacked value in the memory yet.
    raise EmptyStackError.new if @stack_pointer == @memory_stack_size
    # Get the value from current stack pointer position of memory stack
    stack_value = @memory_stack[@stack_pointer]
    # raise empty stack error is the gotten value is nil
    raise EmptyStackError.new if stack_value.nil?
    # Assign nil to the memory stack cell at the current stack pointer
    @memory_stack[@stack_pointer] = nil
    # Increment stack pointer ==> shrink stack area
    @stack_pointer += 1
    # Return the popped value
    stack_value
  end

  def print
    puts(pop)
    # Increment program counter because this is direct instruction
    @program_counter += 1
  end

  def run
    # @ToDo: Need to implemented
  end
end
