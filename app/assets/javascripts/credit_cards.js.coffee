# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Order
  constructor: (@form) ->

  setupForm: ->
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

    $(@form).submit =>
      $('input[type=submit]').attr('disabled', true)
      if $('#card_number').length
        this.processCard()
        false
      else
        true
  
  processCard: ->
    card =
      number: $('#card_number').val()
      cvc: $('#card_code').val()
      expMonth: $('#card_month').val()
      expYear: $('#card_year').val()
    Stripe.createToken(card, @handleStripeResponse.bind(this))
  
  handleStripeResponse: (status, response) ->
    if status == 200
      $('#credit_card_stripe_card_token').val(response.id)
      $(@form)[0].submit()
    else
      $('#stripe_error').text(response.error.message)
      $('input[type=submit]').attr('disabled', false)

window.Order = Order