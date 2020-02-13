class Dragon < ApplicationRecord
    has_many :raid_pairings
    has_many :raids, through: :raid_pairings

    validates :name, presence: {message: "error: The dragon must have a name"}

    @@spnotes = []
    @@p1notes = []
    @@p2notes = []
    def self.cgd
        Dragon.all.select {|dragon| dragon.game_id == 0}
    end
    def self.p1d
        Dragon.all.select {|dragon| dragon.game_id == 1}
    end
    def self.p2d
        Dragon.all.select {|dragon| dragon.game_id == 2}
    end
    def self.mpd
        Dragon.all.select {|dragon| dragon.game_id == 1 || dragon.game_id == 2}
    end

    def self.add_hunger(player)
        dragons = Dragon.all.select {|dragon| dragon.game_id == player}
        # if player == 0
        #     notifications = @@spnotes
        # elsif player == 1
        #     notifications = @@p1notes
        # elsif player == 2
        #     notifications = @@p2notes
        # end
        notifications = []
        dragons.each do |dragon|
            new_hunger = dragon.hunger + 1
            dragon.update(hunger: new_hunger)
            if dragon.hunger == 8
                #notifications << UI.announce("#{dragon.name} is getting restless.", "red")
                notifications << "#{dragon.name} is getting restless."
            elsif dragon.hunger == 9
                #notifications << UI.announce("#{dragon.name} is very hungry.", "red")
                notifications << "#{dragon.name} is very hungry."
            elsif dragon.hunger == 10
                #notifications << UI.announce("#{dragon.name} has abandoned you in search of food.", "red")
                notifications << "#{dragon.name} has abandoned you in search of food."
                dragon.destroy
            end
        end
        return notifications
    end

    def self.recovery(mode)
        if mode == "sp"
            dragons = self.cgd
        elsif mode == "vs"
            dragons = self.mpd
        end
        #dragons.each do |dragon|
        Dragon.all.each do |dragon|
            if dragon.health == "Hurt"
                dragon.update(health: "Injured")
            elsif dragon.health == "Injured"
                dragon.update(health: "Recovering")
            elsif dragon.health == "Recovering"
                dragon.update(health: "Resting")
            elsif dragon.health == "Resting"
                dragon.update(health: "Healthy")
            elsif dragon.health == "Tired"
                dragon.update(health: "Resting")
            end
        end
    end

    def self.list_dragons
    final_output = ""
        if Dragon.all.count == 0
            final_output = "\n                You do not have any dragons. \n      ".blue
        else
            Dragon.all.each do |dragon|
                final_output = final_output + "___________________________________________________________\n   Name: #{dragon.name}  |  Wing Span: #{dragon.wing_span}  |  Hunger: #{dragon.hunger}  \n   Color: #{dragon.color}     |  Pattern: #{dragon.pattern}  |  Health: #{dragon.health} \n ___________________________________________________________ \n  "
            end
        end
    final_output
    end

    def self.available_dragons(player)
        healthy_dragons = Dragon.all.select do |dragon|
            dragon.health == "Healthy" && dragon.game_id == player
        end
        if healthy_dragons.length == 0
            return nil
        else
            return healthy_dragons
        end
    end

    def self.kill_dragon(dragon)
        dragon.update(health: "Dead")
        dragon.destroy
    end

    def self.injure_dragon(dragon)
        dragon.update(health: "Hurt")
    end

end
