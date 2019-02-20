require_relative './spec_helper'

module Specs
  class A
    def initialize(b:)
      @b = b
    end
  end

  class B; end

  class Container
    include RInjector::Container
    
    def build
      register :a, A
      register :b, B
    end
  end
end

RSpec.describe RInjector::Container do
  let(:container) { Specs::Container.new }
  
  context '#resolve' do
    subject { container.resolve name }

    context 'name: :a' do
      let(:name) { :a }

      it 'is an instance of A' do
        expect(subject).to be_an_instance_of Specs::A 
      end

      it 'contains an instance of B' do
        expect(subject.instance_variable_get(:@b))
          .to be_an_instance_of Specs::B
      end
    end
    
    context 'name: :b' do
      let(:name) { :b }

      it 'is an instance of B' do
        expect(subject).to be_an_instance_of Specs::B 
      end
    end
  end
end
