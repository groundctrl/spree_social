RSpec.describe SpreeSocial do
  context 'constants' do
    it { is_expected.to be_const_defined(:OAUTH_PROVIDERS) }

    it 'contain all providers' do
      oauth_providers = [
        %w(WonderfulUnion wonderful_union true),
      ]
      expect(described_class::OAUTH_PROVIDERS).to match_array oauth_providers
    end
  end

  describe '.configure' do
    it 'yields itself' do
      expect { |bloc| SpreeSocial.configure(&bloc) }.
        to yield_with_args(SpreeSocial)
    end
  end

  describe '.authorization' do
    context 'with authorization_proc' do
      it 'returns the response of #call' do
        response = double
        SpreeSocial.authorization_proc = -> { response }

        expect(SpreeSocial.authorization).to eq response
      end

      after do
        SpreeSocial.authorization_proc = nil
      end
    end

    context 'without authorization_proc' do
      it 'calls Spree::AuthenticationMethod.find_by!' do
        response = double
        allow(Spree::AuthenticationMethod).to receive(:find_by!) { response }

        expect(SpreeSocial.authorization).to eq response
        expect(Spree::AuthenticationMethod).to have_received(:find_by!).with(
          environment: ::Rails.env
        )
      end
    end
  end
end
