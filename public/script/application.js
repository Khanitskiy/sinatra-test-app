$( document ).ready(function() {

    $('#get_result').on('click', function() {

        const give_quantity = $('#give_quantity').val();
        const give_currency = $('#give_currency :selected').text();
        const get_currency  = $('#get_currency :selected').text();

        $.ajax({
            url: "/calculate",
            data: {
                give_quantity: give_quantity,
                give_currency: give_currency,
                get_currency: get_currency
            }
        }).done(function(data) {
            $('#get_quantity').val(data.result)
        });
    });

    $('#refresh_date').on('click', function() {

        $.ajax({
            method: "PUT",
            url: "/update_date"
        }).done(function(data) {
            console.log(data)
            if(data.changed) {$('#date').text(data.date) }
        });
    });

    $('#change').on('click', function() {

        const give_quantity = $('#give_quantity').val();
        const get_quantity = $('#get_quantity').val();
        const give_currency = $('#give_currency :selected').text();
        const get_currency  = $('#get_currency :selected').text();

        $('#give_quantity').val(get_quantity);
        $('#get_quantity').val(give_quantity);

        $("#give_currency").val(get_currency);
        $("#get_currency").val(give_currency);
    });
});