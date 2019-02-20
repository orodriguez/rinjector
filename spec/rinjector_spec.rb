require_relative './spec_helper'

module MyApp
  module Users
    module Create
      class Handler
        attr_reader :users
        def initialize(users:)
          @users = users
        end

        def call(request)
          @users << request
        end
      end
    end

    class Repository
      def initialize
        @users = []
      end

      def <<(user)
        @users << user
      end

      def to_a
        @users
      end
    end
  end
end

module MyApp
  class Container
    include RInjector::Container
    
    def build
      register :create_user, MyApp::Users::Create::Handler
      register :users, MyApp::Users::Repository
    end
  end
end

RSpec.describe RInjector::Container do
  let(:container) { MyApp::Container.new }
  let(:create_user) { container.resolve :create_user }
  
  before { create_user.call username: 'chuck', password: '1234' }

  subject { create_user.users.to_a }

  it 'resolves create_user' do
    expect(subject).to eql([
      { username: 'chuck', password: '1234' }
    ])
  end
end
