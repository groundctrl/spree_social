RSpec.describe SpreeSocial do
  context "constants" do
    it "contain all providers" do
      oauth_providers = [
        %w(WonderfulUnion wonderful_union true),
      ]
      expect(described_class::OAUTH_PROVIDERS).to match_array oauth_providers
    end
  end

  describe ".configure" do
    it "yields an instance of Spree::Configuration" do
      expect { |block| SpreeSocial.configure(&block) }.
        to yield_with_args(instance_of(SpreeSocial::Configuration))
    end
  end

  describe ".authorization" do
    it "returns the result of calling the find_authentication_method configuration setting" do
      fake_authentication_method = double(:authentication_method)
      find_authentication_method = -> { fake_authentication_method }
      allow(SpreeSocial.configuration).
        to receive(:find_authentication_method).
        and_return(find_authentication_method)

      expect(SpreeSocial.authorization).to eq fake_authentication_method
    end
  end

  describe ".options" do
    it "returns default setup options" do
      expect(SpreeSocial.options).to match(setup: true)
    end

    context "when WUN_GATEKEEPER_SITE_URL is in env" do
      it "returns setup with :client_options containing the given urls" do
        given_url = "http://a.com"

        ClimateControl.modify WUN_GATEKEEPER_SITE_URL: given_url do
          expect(SpreeSocial.options).to match(
            setup: true,
            client_options: {
              site: given_url,
              authorize_url: "#{given_url}/oauth/authorize",
              token_url: "#{given_url}/oauth/token"
            }
          )
        end
      end
    end
  end
end
