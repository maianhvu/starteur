// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
  var number_fields_count = 5;

  for (i = 1; i <= number_fields_count; i++) {
    formControl(number_fields_count, i);
  }
});

var formControl = function (number_fields_count, number_field_num){
  $(("#number_field_"+number_field_num)).on("input", function(){
    setPrice(number_field_num);
  });

  var getPrice = function (){
    var price = parseFloat($(("#unit_price_"+number_field_num)).html());
    var quantity = parseInt($(("#number_field_"+number_field_num)).val());

    if (price && quantity){
        return price * quantity;
    }
  };

  var setPrice = function(){
    var test_total = parseFloat(getPrice());
    $(("#total_price_"+number_field_num)).html(test_total);

    var price = parseFloat($(("#unit_price_"+number_field_num)).html());
    var quantity = parseInt($(("#number_field_"+number_field_num)).val());

    if($("#total_quantity").html() == "" && $("#subtotal").html() == ""){
      $("#total_quantity").html(quantity);
      $("#subtotal").html(price);
    }

    var total_quantity = 0;
    var total_price = 0.0;

    for (i = 1; i <= number_fields_count; i++){
        total_quantity += parseInt($(("#number_field_"+i)).val());
        current_price = parseFloat($(("#total_price_"+i)).html());
        if (!isNaN(current_price)){
          total_price += current_price;
        }
    }

    $("#total_quantity").html(total_quantity);
    $("#subtotal").html(total_price);
    total_quantity = 0;
    total_price = 0.0;
  };
};