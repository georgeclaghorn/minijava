require "minijava/targets/amd64/runtime"
require "active_support/core_ext/numeric/bytes"

module MiniJava
  module AMD64
    class Generator < Visitor
      attr_reader :destination
      delegate :puts, :print, :flush, to: :@destination

      def initialize(destination)
        @destination = destination
      end

      def generate(functions, entrypoint)
        insert_runtime_for entrypoint: entrypoint
        visit_all functions
        flush
      end


      def visit_function(function)
        puts "\n#{function.name}:"

        enter TEMPORARY_REGISTERS.count * 8.bytes do
          preserve TEMPORARY_REGISTERS do
            move_parameters_to_temporary_registers_for function
            visit_all function.instructions
          end
        end

        puts "ret"
      end

      def visit_add(add)
        case add.destination
        when add.left
          puts "add #{resolve(add.right)}, #{resolve(add.left)}"
        when add.right
          puts "add #{resolve(add.left)}, #{resolve(add.right)}"
        else
          puts "mov #{resolve(add.left)}, #{resolve(add.destination)}"
          puts "add #{resolve(add.right)}, #{resolve(add.destination)}"
        end
      end

      def visit_subtract(subtract)
        case subtract.destination
        when subtract.left
          puts "sub #{resolve(subtract.right)}, #{resolve(subtract.left)}"
        when subtract.right
          puts "neg #{resolve(subtract.right)}"
          puts "add #{resolve(subtract.left)}, #{resolve(subtract.right)}"
        else
          puts "mov #{resolve(subtract.left)}, #{resolve(subtract.destination)}"
          puts "sub #{resolve(subtract.right)}, #{resolve(subtract.destination)}"
        end
      end

      def visit_multiply(multiply)
        case multiply.destination
        when multiply.left
          puts "mul #{resolve(multiply.right)}, #{resolve(multiply.left)}"
        when multiply.right
          puts "mul #{resolve(multiply.left)}, #{resolve(multiply.right)}"
        else
          puts "mov #{resolve(multiply.left)}, #{resolve(multiply.destination)}"
          puts "mul #{resolve(multiply.right)}, #{resolve(multiply.destination)}"
        end
      end

      def visit_copy(copy)
        puts "mov #{resolve(copy.source)}, #{resolve(copy.destination)}"
      end

      def visit_parameter(parameter)
        puts "mov #{resolve(parameter.source)}, #{next_parameter_register}"
      end

      def visit_call(call)
        puts "call #{call.label}"
        puts "mov %rax, #{resolve(call.destination)}" unless call.destination.nil?
        reset_parameter_registers
      end

      def visit_return(instruction)
        puts "mov #{resolve(instruction.source)}, %rax"
      end

      def visit_new_object(instruction)
        puts "xor #{resolve(instruction.destination)}, #{resolve(instruction.destination)}"
      end

      private
        PARAMETER_REGISTERS = %w[ %rdi %rsi %rdx %rcx %r8 %r9 ]
        TEMPORARY_REGISTERS = %w[ %r12 %r13 %r14 %r15 %rbx ]

        def insert_runtime_for(entrypoint:)
          puts Runtime.new.render(entrypoint: entrypoint)
        end


        def move_parameters_to_temporary_registers_for(function)
          function.parameters.times { |i| puts "mov #{PARAMETER_REGISTERS[i]}, #{TEMPORARY_REGISTERS[i]}" }
        end

        def resolve(operand)
          case operand
          when MiniJava::Protocode::TemporaryOperand
            TEMPORARY_REGISTERS[operand.number] || raise("Too many registers")
          when Integer
            "$#{operand}"
          else
            raise "Could not resolve operand #{operand.inspect}"
          end
        end

        def enter(size)
          puts "push %rbp"
          puts "mov %rsp, %rbp"
          puts "sub $#{align(size, 16.bytes)}, %rsp"
          yield
          puts "leave"
        end

        def preserve(registers, offset: 0)
          save registers, offset: offset
          yield
          restore registers, offset: offset
        end

        def save(registers, offset: 0)
          registers.each_with_index { |register, index| puts "mov #{register}, #{index * 8.bytes + offset}(%rsp)" }
        end

        def restore(registers, offset: 0)
          registers.each_with_index { |register, index| puts "mov #{index * 8.bytes + offset}(%rsp), #{register}" }
        end

        def align(size, alignment)
          ((size - 1) / alignment + 1) * alignment
        end


        def next_parameter_register
          parameter_registers.next
        end

        def reset_parameter_registers
          @parameter_registers = PARAMETER_REGISTERS.cycle(1)
        end

        def parameter_registers
          @parameter_registers || reset_parameter_registers
        end
    end
  end
end
