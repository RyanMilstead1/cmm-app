class ChargesController < ApplicationController
  def new
    authorize :charge
    @stripe_btn_data = {
      key: Rails.application.credentials.stripe[:publishable_key].to_s,
      description: "BigMoney Membership - #{current_user.username}",
      amount: amount
    }
  end

  def create
    authorize :charge
    create_stripe_customer_and_charge
    flash[:notice] = "Thanks for all the money, #{current_user.username}! Feel free to pay me again."
    current_user.premium!
    redirect_to wikis_path
    rescue Stripe::CardError => e
      flash[:alert] = e.message
      redirect_to new_charge_path
  end

  def destroy
    authorize :charge
    @user = User.find(params[:id])
    @user.standard!
    @user.wikis.each(&:confirm_private_valid)
    flash[:notice] = 'Downgraded account to standard'
    redirect_to wikis_path
  end

  private

  def create_stripe_customer_and_charge
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )
    Stripe::Charge.create(
      customer: customer.id,
      amount: amount,
      description: "BigMoney Membership - #{current_user.username}",
      currency: 'usd'
    )
  end

  def amount(terms = nil)
    case terms
    when :half_off
      750
    when :standard_sale
      1000
    else
      1500
    end
  end
end
