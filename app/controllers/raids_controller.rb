class RaidsController < ApplicationController
    def new
        RaidPairing.delete_all
        Raid.delete_all
        @raid = Raid.new
        @villages = Village.all
    end
    def create
        v_id = raid_params(:village_id)[:village_id]
        dice = [1,2,3,4,5,6]
        @raid = Raid.create(village_id: v_id, dice_roll: dice.sample, game_id: 0)
        redirect_to select_dragons_path(@raid.id)
    end
    def select_dragons
        @raid = Raid.find(params[:id])
        rpd = RaidPairing.all.map{|pairing| pairing.dragon}
        @dragons = []
        Dragon.all.each do |dragon|
            if dragon.health == "Healthy" && !rpd.include?(dragon)
                @dragons << dragon
            end
        end
    end
    def pairing
        @raid = Raid.find(params[:id])
        d_id = pairing_params(:dragon_id)[:dragon_id]
        RaidPairing.create(raid_id: @raid.id, dragon_id: d_id)
        redirect_to select_dragons_path(@raid.id)
    end
    def roll_dice
        @raid = Raid.find(params[:id])
    end
    def result
        @raid = Raid.find(params[:id])
    end
    private
    def raid_params(*args)
        params.require(:raid).permit(*args)
    end
    def pairing_params(*args)
        params.permit(*args)
    end
end
