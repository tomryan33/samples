    var date = new Date();
    date.setDate(date.getDate());

    $('.date').datepicker({
        'format': 'mm/dd/yyyy',
        'autoclose': true,
        'startDate': date
    });
    
    $("input").on("click", function(){
        this.setSelectionRange(0, this.value.length);
    });
    
    $(".register input").on("change", function(){
        totleUpdate();
    });
    
    function totleUpdate(){
        var dataTotal = Number($("#data_total").val()),
            itemsTotal = 0,
            ship = Number($("#total_shipping").val()),
            fees = Number($("#total_fees").val()),
            promo = Number($("#total_promo").val()),
            tax = Number($("#total_tax").val());
        
        for(var i=1; i<=dataTotal; i++){
            var itemPrice = Number($('#item' + i + '_price').val()),
                quantity = Number($('#item' + i + '_quantity').val());
            itemsTotal = itemsTotal + (itemPrice * quantity);
        }
        
        $("#sub_total_text").text(itemsTotal.toFixed(2));
        
        var Total = itemsTotal + ship + fees - promo + tax;
        
        $("#total_text").text(Total.toFixed(2));
        $("#total_btn").text(Total.toFixed(2));
        
        if(Total < .30){
            $(".total-text").removeClass("text-green");
            $(".total-text").addClass("text-red");
            $(".total-error").show();
        } else {
            $(".total-text").addClass("text-green");
            $(".total-text").removeClass("text-red");
            $(".total-error").hide();
        }
        
        Update_Month_Payments(Total);
    }
    
    $(".money").on("change", function(){
        var input = Number(this.value);
        $(this).val(input.toFixed(2));
    });
    
    $(".product-remove").on("click", function(){
        var inputID = $(this).attr("data-id");
        if(inputID == 1){
            $('#item' + inputID + '_date').attr('disabled', true);
            $('#item' + inputID + '_price').attr('disabled', true);
            $('#item' + inputID + '_quantity').attr('disabled', true);
            $('#item' + inputID + '_name').val('');
            $('#item' + inputID + '_other').val('');
            $('#item' + inputID + '_name_div').show();
            $('#item' + inputID + '_other_div').hide();
            $('#item' + inputID + '_date').val('');
            $('#item' + inputID + '_price').val('');
            $('#item' + inputID + '_quantity').val('');
            $('#item' + inputID + '_total_text').text('0.00');
            totleUpdate();
        } else {
            $('#item' + inputID + '_name').val('');
            $('#item' + inputID + '_other').val('');
            $('#item' + inputID + '_name_div').show();
            $('#item' + inputID + '_other_div').hide();
            $('#item' + inputID + '_date').val('');
            $('#item' + inputID + '_price').val('');
            $('#item' + inputID + '_quantity').val('');
            $('#item' + inputID + '_total_text').text('0.00');
            $('#row' + inputID).hide();
            totleUpdate();
        }
    });
    
    $(".product-item-other").on("blur", function(){
        var inputID = $(this).attr("data-id");
        if(this.value==''){
            $('#item' + inputID + '_name_div').show();
            $('#item' + inputID + '_other_div').hide();
            $('#item' + inputID + '_name').val('');
            $('#item' + inputID + '_date').attr('disabled', true);
            $('#item' + inputID + '_price').attr('disabled', true);
            $('#item' + inputID + '_quantity').attr('disabled', true);
            $('#item' + inputID + '_date').val('');
            $('#item' + inputID + '_price').val('');
            $('#item' + inputID + '_quantity').val('');
        }
    });
    
    // LINKED //
    $(".product-price").on("keyup", function(){
        var inputID = $(this).attr("data-id");
        
        // SET TOTAL
        var price = Number($('#item' + inputID + '_price').val());
        var quantity = Number($('#item' + inputID + '_quantity').val());
        var total = price * quantity;
        $('#item' + inputID + '_total_text').text(total.toFixed(2));
    });
    $(".product-quantity").on("change", function(){
        var inputID = $(this).attr("data-id");
        
        // SET TOTAL
        var price = Number($('#item' + inputID + '_price').val());
        var quantity = Number($('#item' + inputID + '_quantity').val());
        var total = price * quantity;
        $('#item' + inputID + '_total_text').text(total.toFixed(2));
    });
    // END LINK //
    
    $("#addItem").on("click", function(){
        var dataTotal = Number($("#data_total").val()) +1;
        $("#row" + dataTotal).show();
        if(dataTotal==25){
            $("#addItem").hide();
        } else {
            $("#data_total").val(dataTotal);
        }
    })
    
    $(".cards img").on("click", function(){
        $(".cards img").removeClass("active");
        $(this).addClass("active");
    });
    
    /*$('.single-payment').on("click", function(){
        $("#payment_type").fadeOut(100);
        $("#payment_single").delay(100).fadeIn(100);
        $("#pay_method").val("single");
    });*/
    
    $('.mult-payment').on("click", function(){
        $("#payment_single").fadeOut(100);
        $("#payment_type").fadeOut(100);
        $("#payment_type").fadeOut(100);
        $("#payment_mult").delay(100).fadeIn(100);
        var total = Number($("#total_text").text()),
            month_pay = (total / 6) + 25;
        $("#month_total_text").text(month_pay.toFixed(2));
        $("#month_total_btn").text(month_pay.toFixed(2));
        $(".monthly_pay_div").show();
        $(".month_fee_div").show();
        $("#pay_method").val("plan");
    });
    
    $('.payment-back-btn').on("click", function(){
        $("#payment_mult").fadeOut(100);
        $("#payment_single").delay(100).fadeIn(100);
        $("#payment_type").delay(100).fadeIn(100);
        
        // MONTHLY PAYMENT RESET
        document.querySelector('#range_text').value = 6;
        $("#month_payments").val(6);
        $(".total_months_text").text(6);
        $("#monthly_fee_add_text").text('150.00');
        $("#set_up_fee_amount").val('150.00');
        $("#month_fee_text").text('25.00');
        $(".total_months_minus1_text").text(5);
        $(".monthly_pay_div").hide();
        $(".month_fee_div").hide();
        $("#pay_method").val("single");
    });
    
    function outputUpdate(input) {
        document.querySelector('#range_text').value = input;
        $(".total_months_text").text(input);
        $(".total_months_minus1_text").text(input - 1);
        
        if(input > 1 && input < 6){
            if(document.getElementById("set_up_fee").value == "true"){
                var fee = 100/input;
            } else {
                var fee = 0;
            }
            $("#monthly_fee_add_text").text('100.00');
            $("#set_up_fee_amount").val('100.00');
            $("#month_fee_text").text(fee.toFixed(2));
        } else if(input == 6){
            if(document.getElementById("set_up_fee").value == "true"){
                var fee = 150/input;
            } else {
                var fee = 0;
            }
            $("#monthly_fee_add_text").text('150.00');
            $("#set_up_fee_amount").val('150.00');
            $("#month_fee_text").text(fee.toFixed(2));
        } else if(input > 6) {
            if(document.getElementById("set_up_fee").value == "true"){
                var fee = 200/input;
            } else {
                var fee = 0;
            }
            $("#monthly_fee_add_text").text('200.00');
            $("#set_up_fee_amount").val('200.00');
            $("#month_fee_text").text(fee.toFixed(2));
        }
        
        var total = Number($("#total_text").text()),
            month_pay = (total / input) + fee;
        $("#month_total_text").text(month_pay.toFixed(2));
        $("#month_total_btn").text(month_pay.toFixed(2));
    }
    
    $("#fee_remove_btn").click(function(){
        var set_up_fee = document.getElementById('set_up_fee');
        if(set_up_fee.value == 'true'){
            set_up_fee.value = 'false';
            $(".add-remove-btn").removeClass("text-red");
            $(".add-remove-btn").addClass("text-green");
            $(".add-remove-text").text("add");
            $("#month_fee_text").text('0.00');
            $("#set_up_fee_amount").val('0.00');
        } else {
            set_up_fee.value = 'true';
            $(".add-remove-btn").addClass("text-red");
            $(".add-remove-btn").removeClass("text-green");
            $(".add-remove-text").text("remove");
            var fee = Number($("#monthly_fee_add_text").text()),
                mo = Number($("#month_payments").val()),
                mo_fee = fee / mo;
            $("#month_fee_text").text(mo_fee.toFixed(2));
            $("#set_up_fee_amount").val($("#monthly_fee_add_text").text());
        }
        
        var total = Number($("#total_text").text());        
        Update_Month_Payments(total);
    });
    
    $(".fee-show").on("click", function(){
        $(".fee-show").toggleClass("fee-show-active");
        $(".fee-show").toggleClass("text-underline");
    });
    
    function Update_Month_Payments(total) {
        // Update Monthly Payments
        var months = Number($("#month_payments").val());
        if(document.getElementById("set_up_fee").value == "true"){
            var fee = Number($("#month_fee_text").text());
        } else {
            var fee = 0;
        }
        var month_pay = (total / months) + fee;
        $("#month_total_text").text(month_pay.toFixed(2));
        $("#month_total_btn").text(month_pay.toFixed(2));
    }
    
    // Validate
    $("input").on("change", function(){
        if(this.value !== ""){
            $(this).removeClass("input-error");
        }
    });
    $("select").on("change", function(){
        if(this.value !== ""){
            $(this).removeClass("input-error");
        }
    });
    
    // PROCESS PAYMENT
    $(document).ready(function(){
        $(".process-payment").click(function(){

            $(".process-overlay").show();
            $(".processing-show").show();
            $(".alert").hide();
            
            var errorCount = 0;
            
            if($("#item1_name").val().length === 0){
                $(".item1-name-error").show();
                $("#item1_name").addClass("input-error");
                errorCount++
            } else {
                $(".item1-name-error").hide();
                $("#item1_name").removeClass("input-error");
            }
            
            for(var i = 1; i<=25; i++){
                if($("#item" + i + "_name").val() !== ""){
                    var name = $("#item" + i + "_name");
                    if(name.val() == "Other"){
                        var name = $("#item" + i + "_other");
                    }
                    eval("var item" + i  + "=['" + name.val() + "', '" + $("#item" + i + "_date").val() + "', '" + $("#item" + i + "_price").val() + "', '" + $("#item" + i + "_quantity").val() + "', '" + $("#item" + i + "_total_text").text() + "']");
                    
                    // Valitdate price for each item
                    if($("#item" + i + "_price").val() == 0){
                        $(".item" + i + "-price-error").show();
                        $("#item" + i + "_price").addClass("input-error");
                        errorCount++
                    } else {
                        $(".item" + i + "-price-error").hide();
                        $("#item" + i + "_price").removeClass("input-error");
                    }
                    
                    // Validate queantity for each item
                    if($("#item" + i + "_quantity").val() < 1){
                        $(".item" + i + "-quantity-error").show();
                        $("#item" + i + "_quantity").addClass("input-error");
                        errorCount++
                    } else {
                        $(".item" + i + "-quantity-error").hide();
                        $("#item" + i + "_quantity").removeClass("input-error");
                    }
                } else {
                    eval("var item" + i  + "=''");
                }
            }
            
            var products = [item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18, item19, item20, item21, item22, item23, item24, item25];
            
            if(Number($("#total_text").text()) < .30){
                $(".total-error").show();
                errorCount++
            } else {
                $(".total-error").hide();
            }
            
            // Customer Information
            if($("#fName").val().length === 0){
                $(".fName-error").show();
                $("#fName").addClass("input-error");
                errorCount++
            } else {
                $(".fName-error").hide();
                $("#fName").removeClass("input-error");
            }
            if($("#lName").val().length === 0){
                $(".lName-error").show();
                $("#lName").addClass("input-error");
                errorCount++
            } else {
                $(".lName-error").hide();
                $("#lName").removeClass("input-error");
            }
            if($("#email").val().length === 0){
                $(".email-error").show();
                $("#email").addClass("input-error");
                errorCount++
            } else {
                $(".email-error").hide();
                $("#email").removeClass("input-error");
            }
            if($("#phone").val().length === 0){
                $(".phone-error").show();
                $("#phone").addClass("input-error");
                errorCount++
            } else {
                $(".phone-error").hide();
                $("#phone").removeClass("input-error");
            }
            /*if($("#address").val().length === 0){
                $(".address-error").show();
                $("#address").addClass("input-error");
                errorCount++
            } else {
                $(".address-error").hide();
                $("#address").removeClass("input-error");
            }
            if($("#city").val().length === 0){
                $(".city-error").show();
                $("#city").addClass("input-error");
                errorCount++
            } else {
                $(".city-error").hide();
                $("#city").removeClass("input-error");
            }
            if($("#state").val().length === 0){
                $(".state-error").show();
                $("#state").addClass("input-error");
                errorCount++
            } else {
                $(".state-error").hide();
                $("#state").removeClass("input-error");
            }
            if($("#zip").val().length === 0){
                $(".zip-error").show();
                $("#zip").addClass("input-error");
                errorCount++
            } else {
                $(".zip-error").hide();
                $("#zip").removeClass("input-error");
            }
            if($("#country").val().length === 0){
                $(".country-error").show();
                $("#country").addClass("input-error");
                errorCount++
            } else {
                $(".country-error").hide();
                $("#country").removeClass("input-error");
            }*/

            // Card Information
            if($("#card_type").val().length === 0){
                $(".card-type-error").show();
                errorCount++
            } else {
                $(".card-type-error").hide();
            }
            if($("#card_number").val().length === 0){
                $(".card-number-error").show();
                $("#card_number").addClass("input-error");
                errorCount++
            } else {
                $(".card-number-error").hide();
                $("#card_number").removeClass("input-error");
            }
            if($("#card_eMonth").val().length === 0){
                $(".exp-mth-error").show();
                $("#card_eMonth").addClass("input-error");
                errorCount++
            } else {
                $(".exp-mth-error").hide();
                $("#card_eMonth").removeClass("input-error");
            }
            if($("#card_eYear").val().length === 0){
                $(".exp-yr-error").show();
                $("#card_eYear").addClass("input-error");
                errorCount++
            } else {
                $(".exp-yr-error").hide();
                $("#card_eYear").removeClass("input-error");
            }
            if($("#card_cvv").val().length === 0){
                $(".cvv-error").show();
                $("#card_cvv").addClass("input-error");
                errorCount++
            } else {
                $(".cvv-error").hide();
                $("#card_cvv").removeClass("input-error");
            }
                    
            
            if(errorCount == 0){
                
                var total = Number($("#total_text").text());
                
                if(document.getElementById("pay_method").value == "plan"){
                    var total = Number($("#total_text").text()) + Number($("#set_up_fee_amount").val());
                }
            
                $.post("singlePay",
                {
                    // Item Information
                    products: products,

                    // Sub-total, Fees, and Total
                    subTotal: $("#sub_total_text").text(),
                    shipping: $("#total_shipping").val(),
                    fees: $("#total_fees").val(),
                    promo: $("#total_promo").val(),
                    tax: $("#total_tax").val(),
                    total: total,

                    // Payment Method
                    payPlan: document.getElementById("pay_method").value,

                    // Payment Plan
                    months: $("#month_payments").val(),
                    setUpFee: $("#set_up_fee").val(),
                    setUpFeeAmount: $("#month_fee_text").text(),
                    monthPayment: $("#month_total_text").text(),

                    // Customer Information
                    firstName: document.getElementById("fName").value,
                    lastName: document.getElementById("lName").value,
                    email: document.getElementById("email").value,
                    phone: document.getElementById("phone").value,
                    /*address: document.getElementById("address").value,
                    city: document.getElementById("city").value,
                    state: document.getElementById("state").value,
                    zip: document.getElementById("zip").value,
                    country: document.getElementById("country").value,
*/
                    // Card Information
                    cardType: document.getElementById("card_type").value,
                    cardNumber: document.getElementById("card_number").value,
                    expireMonth: document.getElementById("card_eMonth").value,
                    expireYear: document.getElementById("card_eYear").value,
                    cvv: document.getElementById("card_cvv").value
                },
                function(data,status){
                    if(data == "success" && status == "success"){
                        $(".processing-show").fadeOut(300);
                        $(".receipt-show").fadeIn(300);
                        $.post("/pages/data/sendemail",function(data,status){
                            if(data == "success" && status == "success"){
                                $(".receipt-show").fadeOut(300);
                                $(".process-overlay").fadeOut(300);
                                $(".success-overlay").fadeIn(300);
                                $(".success-show").fadeIn(300);
                                setTimeout(function(){
                                    location.reload();
                                }, 1500);
                            } else {
                                $(".receipt-show").fadeOut(300);
                                $(".process-overlay").fadeOut(300);
                                console.log(data + status);
                                alert("Transaction was successful, however the system failed to send a reciept.");
                                location.reload();
                            }
                        });
                    } else {
                        //alert(data + status);
                        console.log(data + status);
                        $(".processing-show").fadeOut(300);
                        $(".process-overlay").fadeOut(300);
                        $(".fail-overlay").fadeIn(300);
                        $(".fail-show").fadeIn(300);
                        setTimeout(function(){
                            $(".fail-overlay").fadeOut();
                            $(".fail-show").fadeOut();
                        }, 2000);
                    }
                });
            } else {
                if(errorCount == 1){
                    $(".errorCount").text("is an error");
                } else {
                    $(".errorCount").text("are " + errorCount + " errors");
                }
                $(".alert").show();
                $(".processing-show").hide();
                $(".process-overlay").hide();
            }
        });
    });