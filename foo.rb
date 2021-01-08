require './validation'

class Foo

  include Validation

  attr_accessor :id
  attr_accessor :name
  attr_accessor :age

  validate :id, presence: true, type: Integer
  validate :name, format: /\w+/
  validate :age, type: Integer

  def initialize(id:, name:, age:)
    @id = id
    @name = name
    @age = age
  end
end
