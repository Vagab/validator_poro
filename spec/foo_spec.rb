require './foo'

RSpec.describe Foo do
  describe '#validate' do
    context 'validations pass' do
      let(:foo) { Foo.new(id: 1, name: 'A', age: 10) }
      it 'is expected to pass' do
        expect(foo.valid?).to eq true
      end
      it 'is expected to raise ValidationError' do
        expect{ foo.validate! }.not_to raise_error
      end
    end
    context 'name validation fails' do
      let(:foo) { Foo.new(id: 1, name: nil, age: 10) }
      it 'is expected to not pass' do
        expect(foo.valid?).to eq false
      end
      it 'is expected to raise ValidationError' do
        expect{ foo.validate! }.to raise_error(an_instance_of(ValidationError).and having_attributes(message: 'Validation failed on name'))
      end
    end
    context 'age validation fails' do
      let(:foo) { Foo.new(id: 1, name: 'A', age: nil) }
      it 'is expected to not pass' do
        expect(foo.valid?).to eq false
      end
      it 'is expected to raise ValidationError' do
        expect{ foo.validate! }.to raise_error(an_instance_of(ValidationError).and having_attributes(message: 'Validation failed on age'))
      end
    end
    context 'id validation fails' do
      context 'id is not Integer' do
        let(:foo) { Foo.new(id: 'yolo', name: 'A', age: 10) }
        it 'is expected to not pass' do
          expect(foo.valid?).to eq false
        end
        it 'is expected to raise ValidationError' do
          expect{ foo.validate! }.to raise_error(an_instance_of(ValidationError).and having_attributes(message: 'Validation failed on id'))
        end
      end
      context 'id is not present' do
        let(:foo) { Foo.new(id: nil, name: 'A', age: 10) }
        it 'is expected to not pass' do
          expect(foo.valid?).to eq false
        end
        it 'is expected to raise ValidationError' do
          expect{ foo.validate! }.to raise_error(an_instance_of(ValidationError).and having_attributes(message: 'Validation failed on id'))
        end
      end
    end
  end
end
