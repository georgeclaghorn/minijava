require "test_helper"

class MiniJava::AMD64::CompilationTest < MiniTest::Test
  def test_hello
    expected = fixture_file("amd64/hello.s").read
    actual = compile(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(5 + 4);
        }
      }
    JAVA

    assert_equal expected, actual
  end

  def test_function
    expected = fixture_file("amd64/function.s").read
    actual = compile(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          return 9;
        }
      }
    JAVA

    assert_equal expected, actual
  end

  private
    def compile(source)
      program   = MiniJava::Parser.program_from(source)
      scope     = MiniJava::ScopeVisitor.scope_for(program)
      protocode = MiniJava::ProtocodeVisitor.protocode_for(program, scope)

      StringIO.new
        .tap { |destination| MiniJava::AMD64::Generator.new(destination).generate(protocode, "HelloWorld.main") }
        .then do |destination|
          destination.rewind
          destination.read
        end
    end
end
