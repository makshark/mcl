// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require moment
//= require moment/ru
//= require bootstrap-datetimepicker
//= require bootstrap-select
//= require TimeCircles
//= require_self
// require_tree ./main_scripts
$(function () {
    $('#datetimepicker1').datetimepicker();
});

$( document ).ready(function() {
    $("#DateCountdown").TimeCircles({
        "animation": "smooth",
        "bg_width": 1.2,
        "fg_width": 0.09333333333333334,
        "circle_bg_color": "#60686F",
        "time": {
            "Days": {
                "text": "Days",
                "color": "#FFCC66",
                "show": false
            },
            "Hours": {
                "text": "Hours",
                "color": "#99CCFF",
                "show": false
            },
            "Minutes": {
                "text": "Minutes",
                "color": "#BBFFBB",
                "show": false
            },
            "Seconds": {
                "text": "Seconds",
                "color": "#ea3939",
                "show": true
            }
        }
    });

    //Default settings for bootstrap select
    $("#playerNickName1, #playerNickName2, #playerNickName3, #playerNickName4, #playerNickName5," +
    "#playerNickName6, #playerNickName7, #playerNickName8, #playerNickName9, #playerNickName10").selectpicker({
        size: 4,
        language: 'RU'
    });




    //Best player table
    $( "#bestPlayerTable1, #bestPlayerTable2, #bestPlayerTable3, #bestPlayerTable4, #bestPlayerTable5," +
    " #bestPlayerTable6, #bestPlayerTable7, #bestPlayerTable8, #bestPlayerTable9, #bestPlayerTable10" ).click(function() {
        $.each(["#bestPlayerTable1, #bestPlayerTable2, #bestPlayerTable3, #bestPlayerTable4, #bestPlayerTable5," +
        " #bestPlayerTable6, #bestPlayerTable7, #bestPlayerTable8, #bestPlayerTable9, #bestPlayerTable10"], function(index, value) {
        $(value).html('');
        });

        $(this).append("<span class='glyphicon glyphicon-user' aria-hidden='true'></span>");
    });
   //Best player leading
    $( "#bestPlayerLeading1, #bestPlayerLeading2, #bestPlayerLeading3, #bestPlayerLeading4, #bestPlayerLeading5," +
    " #bestPlayerLeading6, #bestPlayerLeading7, #bestPlayerLeading8, #bestPlayerLeading9, #bestPlayerLeading10" ).click(function() {
        $.each(["#bestPlayerLeading1, #bestPlayerLeading2, #bestPlayerLeading3, #bestPlayerLeading4, #bestPlayerLeading5," +
        " #bestPlayerLeading6, #bestPlayerLeading7, #bestPlayerLeading8, #bestPlayerLeading9, #bestPlayerLeading10"], function(index, value) {
            $(value).html('');
        });

        $(this).append("<span class='glyphicon glyphicon-user' aria-hidden='true'></span>");
    });
// Killed first
    $( "#killedFirst1, #killedFirst2, #killedFirst3, #killedFirst4, #killedFirst5," +
    " #killedFirst6, #killedFirst7, #killedFirst8, #killedFirst9, #killedFirst10" ).click(function() {
        $.each(["#killedFirst1, #killedFirst2, #killedFirst3, #killedFirst4, #killedFirst5," +
        " #killedFirst6, #killedFirst7, #killedFirst8, #killedFirst9, #killedFirst10"], function(index, value) {
            $(value).html('');
            $(value).parent().css('background-color', '');
        });
        $(this).append("<span class='glyphicon glyphicon-remove' aria-hidden='true'></span>");
        var bestMove = prompt("Введите через пробел 3 числа лучшего хода", "");
        if (bestMove === '') {
            $(this).append('(нету ЛХ)');
        } else {
            $(this).append('(' + bestMove + ')');
        }
        $(this).parent().css('background-color', '#F08080');
    });


//    TODO: обязательно вынести это в отдельные модули
    $.post( "/list_of_players", function( data ) {
        console.log(data);
        $.each(data, function(index, value){
            console.log('Проход' + index);
            $("#playerNickName1, #playerNickName2, #playerNickName3, #playerNickName4, #playerNickName5," +
            "#playerNickName6, #playerNickName7, #playerNickName8, #playerNickName9, #playerNickName10").append(new Option(value, value));
        });
        //Needed to fast refresh body of options
        $("#playerNickName1, #playerNickName2, #playerNickName3, #playerNickName4, #playerNickName5," +
        "#playerNickName6, #playerNickName7, #playerNickName8, #playerNickName9, #playerNickName10").selectpicker('refresh');

    });
});