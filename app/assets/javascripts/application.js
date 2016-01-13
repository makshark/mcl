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

$(document).ready(function () {
    var best_move_game_numbers = [];
    //Initialize timer todo: move to another file, also - move all not my js to vendor folder
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
    //Reset timer when user click
    $('#DateCountdown').click(function () {
        $(this).TimeCircles().restart();
    });

    //Default settings for bootstrap select
    $("#playerNickName1, #playerNickName2, #playerNickName3, #playerNickName4, #playerNickName5," +
        "#playerNickName6, #playerNickName7, #playerNickName8, #playerNickName9, #playerNickName10").selectpicker({
        size: 4,
        language: 'RU'
    });


    //Best player table
    $("#bestPlayerTable1, #bestPlayerTable2, #bestPlayerTable3, #bestPlayerTable4, #bestPlayerTable5," +
        " #bestPlayerTable6, #bestPlayerTable7, #bestPlayerTable8, #bestPlayerTable9, #bestPlayerTable10").click(function () {
        $.each(["#bestPlayerTable1, #bestPlayerTable2, #bestPlayerTable3, #bestPlayerTable4, #bestPlayerTable5," +
        " #bestPlayerTable6, #bestPlayerTable7, #bestPlayerTable8, #bestPlayerTable9, #bestPlayerTable10"], function (index, value) {
            $(value).html('');
        });

        $(this).append("<span id='best_player_table_id' class='glyphicon glyphicon-user' aria-hidden='true'></span>");
    });
    //Best player leading
    $("#bestPlayerLeading1, #bestPlayerLeading2, #bestPlayerLeading3, #bestPlayerLeading4, #bestPlayerLeading5," +
        " #bestPlayerLeading6, #bestPlayerLeading7, #bestPlayerLeading8, #bestPlayerLeading9, #bestPlayerLeading10").click(function () {
        $.each(["#bestPlayerLeading1, #bestPlayerLeading2, #bestPlayerLeading3, #bestPlayerLeading4, #bestPlayerLeading5," +
        " #bestPlayerLeading6, #bestPlayerLeading7, #bestPlayerLeading8, #bestPlayerLeading9, #bestPlayerLeading10"], function (index, value) {
            $(value).html('');
        });

        $(this).append("<span id='best_player_leading_id' class='glyphicon glyphicon-user' aria-hidden='true'></span>");
    });
// Killed first
    $("#killedFirst1, #killedFirst2, #killedFirst3, #killedFirst4, #killedFirst5," +
        " #killedFirst6, #killedFirst7, #killedFirst8, #killedFirst9, #killedFirst10").click(function () {
        $.each(["#killedFirst1, #killedFirst2, #killedFirst3, #killedFirst4, #killedFirst5," +
        " #killedFirst6, #killedFirst7, #killedFirst8, #killedFirst9, #killedFirst10"], function (index, value) {
            $(value).html('');
            $(value).parent().css('background-color', '');
        });
        $(this).append("<span id='killed_first_id' class='glyphicon glyphicon-remove' aria-hidden='true'></span>");
        var bestMove = prompt("Введите через пробел 3 числа лучшего хода", "");
        if (bestMove === '') {
            $(this).append('(нету ЛХ)');
            best_move_game_numbers = [];
        } else {
            $(this).append('(' + bestMove + ')');
            best_move_game_numbers = bestMove.split(' ');
        }
        $(this).parent().css('background-color', '#F08080');
    });


//    TODO: обязательно вынести это в отдельные модули
    $.post("/list_of_players", function (data) {
        $.each(data, function (index, value) {
            $("#playerNickName1, #playerNickName2, #playerNickName3, #playerNickName4, #playerNickName5," +
                "#playerNickName6, #playerNickName7, #playerNickName8, #playerNickName9, #playerNickName10").append(new Option(value[1], value[0]));
        });
        //Needed to fast refresh body of options
        $("#playerNickName1, #playerNickName2, #playerNickName3, #playerNickName4, #playerNickName5," +
            "#playerNickName6, #playerNickName7, #playerNickName8, #playerNickName9, #playerNickName10").selectpicker('refresh');

    });
    //Get list of leadings
    $.post("/list_of_leadings", function (data) {
        $.each(data, function (index, value) {
            $("#leading_id").append(new Option(value[1], value[0]));
            $("#leading_id").selectpicker('refresh');
        })
    });

//    Create game
    $('#createGame').click(function () {
        var best_game_move = [];
        var game_players = [];
        var comment = $('#comment').val();
        var date = $('#date').val();
        var leading_id = $('#leading_id').val();
        var victory = $('#victory').val();
        var killed_first_id_position = $('#killed_first_id').parent().attr('id');
        var best_player_table_id_position = $('#best_player_table_id').parent().attr('id');
        var best_player_leading_id_position = $('#best_player_leading_id').parent().attr('id');

        if (killed_first_id_position != undefined) {
            killed_first_id_position = killed_first_id_position.replace('killedFirst', '');
            var killed_first_id = $('#playerNickName' + killed_first_id_position).val();
        }

        if (best_player_table_id_position != undefined) {
            best_player_table_id_position = best_player_table_id_position.replace('bestPlayerTable', '');
            var best_player_table_id = $('#playerNickName' + best_player_table_id_position).val();
        }

        if (best_player_leading_id_position != undefined) {
            best_player_leading_id_position = best_player_leading_id_position.replace('bestPlayerLeading', '');
            var best_player_leading_id = $('#playerNickName' + best_player_leading_id_position).val();
        }
        if (best_move_game_numbers > 3) {
            alert('Неправильный лучший ход');
            //TODO: так же дописать другие варианты-валидации, или поменять вообще этот попап
        } else {
            //Добавляем ID каждого игрока
            $.each(best_move_game_numbers, function (index, value) {
                best_game_move.push($('#playerNickName' + value).val());
            });
        }
        for (var i = 1; i <= 10; i++) {
            var player = {};
            player['table_number']  = i;
            player['player_id'] = $('#playerNickName' + i).val();
            player['role'] = $('#role' + i).val();
            player['remark'] = $('#remark' + i).val();
            game_players.push(player);
        }
        $.ajax({
            method: "POST",
            url: '/create_game',
            data: {
                victory: victory,
                date: date,
                leading_id: leading_id,
                killed_first_id: killed_first_id,
                comment: comment,
                game_players: game_players,
                best_player_table_id: best_player_table_id,
                best_player_leading_id: best_player_leading_id,
                best_game_move: best_game_move
            },
            dataType: 'json'
        });
    });
});

//TODO: после добавление игры обновлять страницу и перекидывать на страницу с самой игрой (уже готовым результатом)