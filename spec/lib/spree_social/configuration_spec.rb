RSpec.describe SpreeSocial::Configuration do
  subject(:configuration) { described_class.new }

  describe '#find_authentication_method' do
    it 'finds the first AuthenticationMethod belonging to the current Rails ' \
    'environment by default' do
      authentication_method = double(:authentication_method)
      rails_environment = 'some-environment'
      allow(Rails).to receive(:env).and_return(rails_environment)
      allow(Spree::AuthenticationMethod).
        to receive(:find_by!).
        with(environment: rails_environment).
        and_return(authentication_method)

      expect(configuration.find_authentication_method.call).
        to eq authentication_method
    end

    it 'is overridable' do
      authentication_method = double(:authentication_method)
      configuration.find_authentication_method = -> { authentication_method }

      expect(configuration.find_authentication_method.call).
        to eq authentication_method
    end
  end
end
