require "test_helper"

class MiniJava::TypeCheckVisitorTest < MiniTest::Test
  def test_simple_assignment_to_class_name
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            NumberPicker = 1;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: NumberPicker", error.message
  end

  def test_simple_assignment_to_method_name
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            pick = 1;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: pick", error.message
  end

  def test_simple_assignment_from_class_name
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            number = NumberPicker;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: NumberPicker", error.message
  end

  def test_simple_assignment_from_method_name
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;
            number = pick;
            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: pick", error.message
  end

  def test_array_element_assignment_from_class_name
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          int[] numbers;

          public int pick() {
            numbers = new int[1];
            numbers[0] = NumberPicker;
            return numbers[0];
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: NumberPicker", error.message
  end

  def test_array_element_assignment_from_method_name
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          int[] numbers;

          public int pick() {
            numbers = new int[1];
            numbers[0] = pick;
            return numbers[0];
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: pick", error.message
  end

  def test_less_than_with_class_name_on_left
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (NumberPicker < 0)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: NumberPicker", error.message
  end

  def test_less_than_with_class_name_on_right
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (0 < NumberPicker)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: NumberPicker", error.message
  end

  def test_less_than_with_method_name_on_left
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (pick < 0)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: pick", error.message
  end

  def test_less_than_with_method_name_on_right
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick());
          }
        }

        class NumberPicker {
          public int pick() {
            int number;

            if (0 < pick)
              number = 0;
            else
              number = 1;

            return number;
          }
        }
      JAVA
    end

    assert_equal "Cannot find variable: pick", error.message
  end

  def test_calling_a_method_on_a_primitive
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick(3));
          }
        }

        class NumberPicker {
          public int pick(int bar) {
            return bar.baz();
          }
        }
      JAVA
    end

    assert_equal "Attempt to call non-method baz", error.message
  end

  def test_calling_a_method_on_a_primitive
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new NumberPicker().pick(3));
          }
        }

        class NumberPicker {
          public int pick(int bar) {
            return bar.baz();
          }
        }
      JAVA
    end

    assert_equal "Attempt to call non-method baz", error.message
  end

  def test_calling_an_undefined_method
    error = assert_raises(MiniJava::NameError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          public int bar() {
            return 3;
          }
        }
      JAVA
    end

    assert_equal "Attempt to call undefined method baz", error.message
  end

  def test_binary_arithmetic_operation_with_non_integer_operand_on_left
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (bar < 3)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int, got boolean", error.message
  end

  def test_binary_arithmetic_operation_with_non_integer_operand_on_right
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (3 < bar)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int, got boolean", error.message
  end

  def test_logical_and_with_non_boolean_operand_on_left
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (3 && bar)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  def test_logical_and_with_non_boolean_operand_on_right
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().baz());
          }
        }

        class Foo {
          boolean bar;

          public int baz() {
            int glorp;
            bar = !bar;

            if (bar && 3)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  def test_logical_not_with_int_variable_operand
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int glorp;

            if (!glorp)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  def test_logical_not_with_int_literal_operand
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int glorp;

            if (!3)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  def test_logical_not_with_object_operand
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int glorp;

            if (!new Foo())
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got Foo", error.message
  end

  def test_logical_not_with_object_variable_operand
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            Foo baz;
            int glorp;

            if (!baz)
              glorp = 3;
            else
              glorp = 1;

            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got Foo", error.message
  end

  def test_print_statement_with_non_integer_parameter
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(true);
          }
        }
      JAVA
    end

    assert_equal "Call to System.out.println does not match its signature", error.message
  end

  def test_array_subscript_with_boolean_variable_as_array
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          boolean baz;

          public int bar() {
            int glorp;
            glorp = baz[0];
            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int[], got boolean", error.message
  end

  def test_array_subscript_with_integer_literal_as_array
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int glorp;
            glorp = 300[0];
            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int[], got int", error.message
  end

  def test_array_subscript_with_true_literal_as_index
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          int[] baz;

          public int bar() {
            int glorp;
            glorp = baz[true];
            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int, got boolean", error.message
  end

  def test_array_subscript_with_boolean_variable_as_index
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          int[] baz;

          public int bar() {
            int glorp;
            boolean quux;
            glorp = baz[quux];
            return glorp;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int, got boolean", error.message
  end

  def test_array_length_with_integer_variable_as_array
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int baz;
            return baz.length;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int[], got int", error.message
  end

  def test_array_length_with_true_literal_as_array
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(true.length);
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int[], got boolean", error.message
  end

  def test_assigning_a_boolean_literal_to_an_int_variable
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int baz;
            baz = true;
            return baz;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected int, got boolean", error.message
  end

  def test_assigning_an_integer_variable_to_a_boolean_variable
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int baz;
            boolean glorp;
            glorp = baz;
            return baz;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  def test_if_statement_with_integer_literal_as_condition
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int baz;

            if (3)
              baz = 3;
            else
              baz = 2;

            return baz;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  def test_if_statement_with_integer_variable_as_condition
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int baz;
            int glorp;

            if (glorp)
              baz = 3;
            else
              baz = 2;

            return baz;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  def test_while_statement_with_integer_variable_as_condition
    error = assert_raises(MiniJava::TypeError) do
      check <<~JAVA
        class HelloWorld {
          public static void main(String[] args) {
            System.out.println(new Foo().bar());
          }
        }

        class Foo {
          public int bar() {
            int baz;
            int glorp;

            while (glorp)
              baz = baz + 1;

            return baz;
          }
        }
      JAVA
    end

    assert_equal "Incompatible types: expected boolean, got int", error.message
  end

  private
    def check(source)
      program = MiniJava::Parser.program_from(source)
      scope = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::TypeCheckVisitor.check(program, scope)
    end
end
