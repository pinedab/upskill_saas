/* global $, Stripe */ 
// Document ready
$(document).on('turbolinks:load', function(){
    var theForm = $('#pro-form');
    var submitBtn = $('#form-signup-btn');
    // Set Stripe public key
    Stripe.setPublishableKey( $('meta[name=["stripe-key"]').attr('content') );

    // When user clicks form submit btn
    submitBtn.click(function(e){
        // Prevent default submission behovior
        e.preventDefault();
        submitBtn.val("Processing").prop('disabled', true);
        // Collect credit card fields 
        var ccNum = $('#card-number').val(),
            cvcNum = $('#card_code').val(),
            expMonth = $('#card_month').val(),
            expYear = $('#card_year').val();
            
        //Use Stripe Js library to check for card errors
        var error = false;
        
        //Validate card number
       if (!Stripe.card.validateCardNumber(ccNum)) {
            error = true;
            alert("Invalid Credit Card Number! Please try again.");
       }
        //Validate CVC number
       if (!Stripe.card.validateCVC(cvcNum)) {
            error = true;
            alert("Invalid CVC Number! Please try again.");
       }
         //Validate exp date
       if (!Stripe.card.validateExpiry(expMonth, expYear)) {
            error = true;
            alert("Invalid Experation Date! Please try again.");
       }
        
        if(error){
            // If there are card errors, don't send Stripe
            submitBtn.prop('disabled', false).val("Sign Up");
            
        } else {
            // Send the card info to Stripe
            Stripe.createToken({
                number: ccNum,
                cvc: cvcNum,
                exp_month: expMonth,
                exp_year: expYear
            }, stripeResponseHandler);
        }
         
       return false;
    });

    // Stripe will return a card token
    function stripeResponseHandler(status, response){
        var token = response.id;
    
        // Inject card token as hidden field to form
        theForm.append( $('<input type="hidden" name="user[stripe_card_token]">').val(token) );
        
        // Submit form to our Rails app
        theForm.get(0).submit();
    }
});
