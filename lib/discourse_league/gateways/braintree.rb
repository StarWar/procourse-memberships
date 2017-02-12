require_relative '../gateways'

module ActiveMerchant
  module Billing
    class BraintreeBlueGateway

      def subscribe(user_id, product, credit_card_or_vault_id, options = {})
        response = store(credit_card_or_vault_id, :billing_address => options[:billing_address])

        if response.success?
          league_gateway = DiscourseLeague::Gateways.new(:user_id => user_id, :product_id => product[:id], :token => response.params["credit_card_token"])
          league_gateway.store_token
          @braintree_gateway.subscription.create(:payment_method_token => response.params["credit_card_token"], :plan_id => product[:braintree_plan_id])
        else
          message_from_result(response)
        end

      end

    end
  end
end

module DiscourseLeague
  class Gateways
    class Braintree

      def initialize(options = {})
        @options = options
      end

      def active_merchant
        gateway = ActiveMerchant::Billing::BraintreeGateway.new(
          :merchant_id => SiteSetting.league_braintree_merchant_id,
          :public_key => SiteSetting.league_braintree_public_key,
          :private_key => SiteSetting.league_braintree_private_key
        )
      end

    end
  end
end