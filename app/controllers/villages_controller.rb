class VillagesController < ApplicationController
    def index
        @villages = Village.all
    end
    def attack
        @village = Village.find(params[:id])
        @attack = Village.attack_start(@village)
    end
    def defend
        @village = Village.find(params[:id])
        @defend = Village.attack_result(@village)
    end
end
