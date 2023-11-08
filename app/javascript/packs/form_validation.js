$(document).ready(function() {
    $("#exchange-form").validate({
      rules: {
        "base": {
          required: true
        },
        "target": {
          required: true
        },
        "amount": {
          required: true,
          number: true,
          min: 0.01 // Minimum amount value
        }
      },
      messages: {
         "base": {
          required: "Please select a base currency."
        },
        "target": {
          required: "Please select a target currency."
        },
        "amount": {
          required: "Please enter an amount.",
          number: "Please enter a valid amount.",
          min: "Please enter a valid amount."
        }
      },
      submitHandler: function(form) {
        // Handle form submission here (e.g., AJAX submission)
        form.submit();
      }
    });
    });