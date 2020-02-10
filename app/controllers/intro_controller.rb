class IntroController < ApplicationController

    def start
        # Dragon.all.each do |dragon|
        #     if Dragon.cgd.include?(dragon)
        #         dragon.destroy
        #     end
        # end
        Dragon.delete_all
        RaidPairing.delete_all
        Raid.delete_all
        # Village.all.each do |village|
        #     if Village.spv.include?(village)
        #         village.destroy
        #     end
        # end
        Village.delete_all
        GameData.current_game.update(player_name: "empty name", turn: 1, eggs: 3, score: 0)
        Village.nomads("sp")
    end

    def onea
        @current_game = GameData.current_game
    end
    def oneb
        @current_game = GameData.current_game
    end
    def cg_update
        @current_game = GameData.current_game
        @current_game.update(player_name: cg_update_params(:player_name)[:player_name])
        redirect_to "/intro/second"
    end

    def second
        @current_game = GameData.current_game
    end
    def twoa
    end
    def twob
    end
    def threea
    end
    def threeb
    end
    def foura
    end
    def fourb
    end
    

    private
    def cg_update_params(*args)
        params.require(:game_data).permit(*args)
    end
end
