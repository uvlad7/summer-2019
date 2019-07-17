# rubocop:disable all
# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/neo')

CONST = 'top level'

# class AboutConstants
class AboutConstants < Neo::Koan
  CONST = 'nested'

  def test_nested_constants_may_also_be_referenced_with_relative_paths
    assert_equal 'nested', CONST
  end

  def test_top_level_constants_are_referenced_by_double_colons
    assert_equal 'top level', ::CONST
  end

  def test_nested_constants_are_referenced_by_their_complete_path
    assert_equal 'nested', AboutConstants::CONST
    assert_equal 'nested', ::AboutConstants::CONST
  end

  # ------------------------------------------------------------------
  # class about Animal
  class Animal
    LEGS = 4
    def legs_in_animal
      LEGS
    end
    # class about NestedAnimals
    class NestedAnimal
      def legs_in_nested_animal
        LEGS
      end
    end
  end

  def test_nested_classes_inherit_constants_from_enclosing_classes
    assert_equal 4, Animal::NestedAnimal.new.legs_in_nested_animal
  end

  # ------------------------legs_in_reptile-----------------------------
  # class about Reptile < Animal
  class Reptile < Animal
    def legs_in_reptile
      LEGS
    end
  end

  def test_subclasses_inherit_constants_from_parent_classes
    assert_equal 4, Reptile.new.legs_in_reptile
  end

  # ------------------------------------------------------------------
  # class about MyAnimals
  class MyAnimals
    LEGS = 2
    # class about Bird < Animal
    class Bird < Animal
      def legs_in_bird
        LEGS
      end
    end
  end

  def test_who_wins_with_both_nested_and_inherited_constants
    assert_equal 2, MyAnimals::Bird.new.legs_in_bird
  end

  # QUESTION: Which has precedence: The constant in the lexical scope,
  # or the constant from the inheritance hierarchy?

  # ------------------------------------------------------------------

  # Class myanimals
  class MyAnimals::Oyster < Animal
    def legs_in_oyster
      LEGS
    end
  end
  def test_who_wins_with_explicit_scoping_on_class_definition
    assert_equal 4, MyAnimals::Oyster.new.legs_in_oyster
  end

  # QUESTION: Now which has precedence: The constant in the lexical
  # scope, or the constant from the inheritance hierarchy?  Why is it
  # different than the previous answer?
end
