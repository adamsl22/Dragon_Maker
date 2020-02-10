class DragonsController < ApplicationController
    def new
        @eggs = GameData.eggs
        @dragon = Dragon.new
        @errors = flash[:errors]
    end
    def index
        @dragons = Dragon.all
    end
    def create
        name = dragon_params(:name)[:name]
        wing_span = dragon_params(:wing_span)[:wing_span]
        color = dragon_params(:color)[:color]
        pattern = dragon_params(:pattern)[:pattern]
        @dragon = Dragon.new(name: name, wing_span: wing_span, color: color, pattern: pattern, hunger: 0, health: "Healthy", game_id: 0)
        if @dragon.valid?
            @dragon.save
            GameData.hatch_egg
            redirect_to notifications_path
        else
            flash[:errors] = @dragon.errors.full_messages
            redirect_to new_dragon_path
        end
    end
    private
    def dragon_params(*args)
        params.require(:dragon).permit(*args)
    end
end
