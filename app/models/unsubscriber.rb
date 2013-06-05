class Unsubscriber
  def initialize(subscription)
    @subscription = subscription
  end

  def process
    Subscription.transaction do
      @subscription.deactivate
      stripe_user = Stripe::Customer.retrieve(@subscription.stripe_customer_id)
      stripe_user.cancel_subscription
      deliver_unsubscription_survey
    end
  end

  private

  def deliver_unsubscription_survey
    Mailer.unsubscription_survey(@subscription.user).deliver
  end
end
