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
        puts "push %rbp"
        puts "mov %rsp, %rbp"
        visit_all function.instructions
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
        puts "mov #{resolve(parameter.source)}, %rdi"
      end

      def visit_call(call)
        preserve TEMPORARY_REGISTERS do
          puts "call #{call.label}"
        end

        puts "mov %rax, #{resolve(call.destination)}" unless call.destination.nil?
      end

      def visit_return(instruction)
        puts "mov #{resolve(instruction.source)}, %rax" unless instruction.source.nil?
        puts "leave"
        puts "ret"
      end

      def visit_new_object(instruction)
        puts "xor #{resolve(instruction.destination)}, #{resolve(instruction.destination)}"
      end

      private
        def insert_runtime_for(entrypoint:)
          puts Runtime.new.render(entrypoint: entrypoint)
        end


        TEMPORARY_REGISTERS = %w[ %r12 %r13 %r14 %r15 %rbx ]

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

        def preserve(registers)
          allocate registers.count * 8.bytes do
            save registers
            yield
            restore registers
          end
        end

        def allocate(size)
          align(size, 16.bytes).then do |size|
            puts "sub $#{size}, %rsp"
            yield
            puts "add $#{size}, %rsp"
          end
        end

        def save(registers)
          registers.each_with_index { |register, index| puts "mov #{register}, #{index * 8.bytes}(%rsp)" }
        end

        def restore(registers)
          registers.each_with_index { |register, index| puts "mov #{index * 8.bytes}(%rsp), #{register}" }
        end

        def align(size, alignment)
          size % alignment == 0 ? size : (size / alignment + 1) * alignment
        end
    end
  end
end
