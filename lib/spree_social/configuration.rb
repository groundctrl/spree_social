module SpreeSocial
  class Configuration
    attr_accessor :find_authentication_method

    def initialize
      @find_authentication_method = lambda do
        Spree::AuthenticationMethod.find_by!(environment: ::Rails.env)
      end
    end
  end
end
