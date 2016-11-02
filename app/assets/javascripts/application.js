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
    var admin;
    $.post('/admin_or_not', function (result) {
        admin = result;

        if (admin === true) {
            //Best player table
            $("#bestPlayerTable1, #bestPlayerTable2, #bestPlayerTable3, #bestPlayerTable4, #bestPlayerTable5," +
                " #bestPlayerTable6, #bestPlayerTable7, #bestPlayerTable8, #bestPlayerTable9, #bestPlayerTable10").click(function (event) {
                var element = $(event.target).html();
                if (element === '') {
                    $.each(["#bestPlayerTable1, #bestPlayerTable2, #bestPlayerTable3, #bestPlayerTable4, #bestPlayerTable5," +
                    " #bestPlayerTable6, #bestPlayerTable7, #bestPlayerTable8, #bestPlayerTable9, #bestPlayerTable10"], function (index, value) {
                        $(value).html('');
                    });
                    $(this).append("<span id='best_player_table_id' class='glyphicon glyphicon-user' aria-hidden='true'></span>");

                } else {
                    $.each(["#bestPlayerTable1, #bestPlayerTable2, #bestPlayerTable3, #bestPlayerTable4, #bestPlayerTable5," +
                    " #bestPlayerTable6, #bestPlayerTable7, #bestPlayerTable8, #bestPlayerTable9, #bestPlayerTable10"], function (index, value) {
                        $(value).html('');
                    });
                }
            });
            //Best player leading
            $("#bestPlayerLeading1, #bestPlayerLeading2, #bestPlayerLeading3, #bestPlayerLeading4, #bestPlayerLeading5," +
                " #bestPlayerLeading6, #bestPlayerLeading7, #bestPlayerLeading8, #bestPlayerLeading9, #bestPlayerLeading10").click(function (event) {
                var element = $(event.target).html();
                if (element === '') {
                    $.each(["#bestPlayerLeading1, #bestPlayerLeading2, #bestPlayerLeading3, #bestPlayerLeading4, #bestPlayerLeading5," +
                    " #bestPlayerLeading6, #bestPlayerLeading7, #bestPlayerLeading8, #bestPlayerLeading9, #bestPlayerLeading10"], function (index, value) {
                        $(value).html('');
                    });
                    $(this).append("<span id='best_player_leading_id' class='glyphicon glyphicon-user' aria-hidden='true'></span>");
                } else {
                    $.each(["#bestPlayerLeading1, #bestPlayerLeading2, #bestPlayerLeading3, #bestPlayerLeading4, #bestPlayerLeading5," +
                    " #bestPlayerLeading6, #bestPlayerLeading7, #bestPlayerLeading8, #bestPlayerLeading9, #bestPlayerLeading10"], function (index, value) {
                        $(value).html('');
                    });
                }
            });

            //Best player leading1
            $("#bestPlayerLeading11, #bestPlayerLeading12, #bestPlayerLeading13, #bestPlayerLeading14, #bestPlayerLeading15," +
                " #bestPlayerLeading16, #bestPlayerLeading17, #bestPlayerLeading18, #bestPlayerLeading19, #bestPlayerLeading110").click(function (event) {
                var element = $(event.target).html();
                if (element === '') {
                    $.each(["#bestPlayerLeading11, #bestPlayerLeading12, #bestPlayerLeading13, #bestPlayerLeading14, #bestPlayerLeading15," +
                    " #bestPlayerLeading16, #bestPlayerLeading17, #bestPlayerLeading18, #bestPlayerLeading19, #bestPlayerLeading110"], function (index, value) {
                        $(value).html('');
                    });
                    $(this).append("<span id='best_player_leading1_id' class='glyphicon glyphicon-user' aria-hidden='true'></span>");
                } else {
                    $.each(["#bestPlayerLeading11, #bestPlayerLeading12, #bestPlayerLeading13, #bestPlayerLeading14, #bestPlayerLeading15," +
                    " #bestPlayerLeading16, #bestPlayerLeading17, #bestPlayerLeading18, #bestPlayerLeading19, #bestPlayerLeading110"], function (index, value) {
                        $(value).html('');
                    });
                }
            });


            //Best player leading2
            $("#bestPlayerLeading21, #bestPlayerLeading22, #bestPlayerLeading23, #bestPlayerLeading24, #bestPlayerLeading25," +
                " #bestPlayerLeading26, #bestPlayerLeading27, #bestPlayerLeading28, #bestPlayerLeading29, #bestPlayerLeading210").click(function (event) {
                var element = $(event.target).html();
                if (element === '') {
                    $.each(["#bestPlayerLeading21, #bestPlayerLeading22, #bestPlayerLeading23, #bestPlayerLeading24, #bestPlayerLeading25," +
                    " #bestPlayerLeading26, #bestPlayerLeading27, #bestPlayerLeading28, #bestPlayerLeading29, #bestPlayerLeading210"], function (index, value) {
                        $(value).html('');
                    });
                    $(this).append("<span id='best_player_leading2_id' class='glyphicon glyphicon-user' aria-hidden='true'></span>");
                } else {
                    $.each(["#bestPlayerLeading21, #bestPlayerLeading22, #bestPlayerLeading23, #bestPlayerLeading24, #bestPlayerLeading25," +
                    " #bestPlayerLeading26, #bestPlayerLeading27, #bestPlayerLeading28, #bestPlayerLeading29, #bestPlayerLeading210"], function (index, value) {
                        $(value).html('');
                    });
                }
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

        }
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
        var game_number = $('#gameNumber').val();
        var mini_tournament_id = $('#miniTournamentId').val();
        var big_tournament_tour_id = $('#bigTournamentId').val();
        var game_id = $('#gameId').val();
        var best_game_move = [];
        var game_players = [];
        var comment = $('#comment').val();
        var date = $('#date').val();
        var leading_id = $('#leading_id').val();
        var victory = $('#victory').val();
        var killed_first_id_position = $('#killed_first_id').parent().attr('id');
        var best_player_table_id_position = $('#best_player_table_id').parent().attr('id');
        var best_player_leading_id_position = $('#best_player_leading_id').parent().attr('id');
        var best_player_leading1_id_position = $('#best_player_leading1_id').parent().attr('id');
        var best_player_leading2_id_position = $('#best_player_leading2_id').parent().attr('id');
        var students_league = $("#studentsLeague").is(':checked');

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

        if (best_player_leading1_id_position != undefined) {
            best_player_leading1_id_position = best_player_leading1_id_position.replace('bestPlayerLeading1', '');
            var best_player_leading1_id = $('#playerNickName' + best_player_leading1_id_position).val();
        }

        if (best_player_leading2_id_position != undefined) {
            best_player_leading2_id_position = best_player_leading2_id_position.replace('bestPlayerLeading2', '');
            var best_player_leading2_id = $('#playerNickName' + best_player_leading2_id_position).val();
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
            player['table_number'] = i;
            player['player_id'] = $('#playerNickName' + i).val();
            player['role'] = $('#role' + i).val();
            player['remark'] = $('#remark' + i).val();
            player['penalty_amount'] = $('#penaltyAmount' + i).val();
            game_players.push(player);
        }
        if (check_players_roles(game_players)) {
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
                    best_player_leading1_id: best_player_leading1_id,
                    best_player_leading2_id: best_player_leading2_id,
                    best_game_move: best_game_move,
                    mini_tournament_id: mini_tournament_id,
                    big_tournament_tour_id: big_tournament_tour_id,
                    game_id: game_id,
                    number: game_number,
                    students_league: students_league
                },
                dataType: 'json'
            }).done(function (response) {
                alert("Вы успешно обработали игру");
                window.location = response.link;
            });
        } else {
            alert ('Вы ошиблись при заполнении ролей, проверьте еще раз роли');
        }
    });
    // если не админ и смотрит игру - то не может редактировать
    $.post('/admin_or_not', function (result) {
        if (result === false && window.location.href.indexOf("/show_game/") > -1) {
            $('.form-control').attr('disabled', true);
            $("[id*='bestPlayerTable']").removeClass('pointer');
            $("[id*='bestPlayerLeading']").removeClass('pointer');
            $("[id*='bestPlayerLeading1']").removeClass('pointer');
            $("[id*='bestPlayerLeading2']").removeClass('pointer');
            $("[id*='killedFirst']").removeClass('pointer');
        }
    });
});
function check_players_roles(players) {
   var roles = { citizen: 6, mafia: 2, don: 1, sheriff: 1 };
    $.each(players, function(index, value) {
       roles[value['role']] = roles[value['role']] - 1;
    });
    if (roles['citizen'] === 0 && roles['mafia'] === 0 && roles['don'] === 0 && roles['sheriff'] === 0){
        return true;
    } else {
        return false;
    }
}
//TODO: после добавление игры обновлять страницу и перекидывать на страницу с самой игрой (уже готовым результатом)