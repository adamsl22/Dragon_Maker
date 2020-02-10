class GameController < ApplicationController
    
    def welcome
        if GameData.all == []
            @current_game = GameData.create(player_name: "", turn: 0, eggs: 0, score: 0, mpi: 0, tp: 0)
            @high_score = GameData.create(player_name: "", turn: 0, eggs: 0, score: 0, mpi: 0, tp: 0)
        else
            @current_game = GameData.current_game
            @high_score = GameData.high_score
        end
    end

    def single_player
    end

    def vsmode
    end

    def menu
        @current_game = GameData.current_game
        @dragons = Dragon.all.select {|dragon| dragon.game_id == 0}
        @villages = Village.all.select {|village| village.game_id == 1}
    end
    def instructions
    end

    def under_construction
    end

    def vsdata
        player1_name = vsdata_params(:player_1_name)[:player_1_name]
        player2_name = vsdata_params(:player_2_name)[:player_2_name]
        tp = vsdata_params(:target_points)[:target_points].to_i
        @player1 = GameData.set_vsplayer(1, player1_name, tp)
        @player2 = GameData.set_vsplayer(2, player2_name, tp)
        Dragon.all.each do |dragon|
            if Dragon.mpd.include?(dragon)
                dragon.destroy
            end
        end
        RaidPairing.delete_all
        Raid.delete_all
        Village.all.each do |village|
            if Village.mpv.include?(village)
                village.destroy
            end
        end
        Village.nomads("vs")
        redirect_to "/game/vsmenu1"
    end

    def vsmenu1
        @notifications = []
        @notificaitons << Village.notifications
        @notifications << Dragon.notifcations
        @player1 = GameData.find_by(mpi: 1)
        @player2 = GameData.find_by(mpi: 2)
        @p1d = Dragon.p1d
        @p2d = Dragon.p2d
        @mpv = Village.mpv
    end
    def vsmenu2
        @notifications = []
        @notificaitons << Village.notifications
        @notifications << Dragon.notifcations
        @player1 = GameData.find_by(mpi: 1)
        @player2 = GameData.find_by(mpi: 2)
        @p1d = Dragon.p1d
        @p2d = Dragon.p2d
        @mpv = Village.mpv
    end
    def pass
    end
    def end_turn
        turn = GameData.current_game.turn
        @attacking_village = Village.attack(turn)
        if GameData.check_for_loss == true
            redirect_to loss_path
        elsif @attacking_village == false
            redirect_to notifications_path
        else
            redirect_to attack_path(@attacking_village)
        end
    end
    def notifications
        GameData.increment_turn
        @turn = GameData.current_game.turn
        @village_news = Village.notifications(@turn)
        @dragon_news = Dragon.add_hunger(0)
    end
    def loss
    end

    private
    def vsdata_params(*args)
        params.permit(*args)
    end
end
