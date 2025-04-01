require 'active_merchant'

# Use Bogus Gateway for testing (no real transactions)
GATEWAY = ActiveMerchant::Billing::BogusGateway.new
