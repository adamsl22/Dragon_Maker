class Raid < ApplicationRecord
    has_many :raid_pairings
    has_many :dragons, through: :raid_pairings
    belongs_to :village

    @@notifications = []

    def hunger
        self.dragons.sum(:hunger)
    end

    def danger_value
        outnumbered_ratio = self.village.knights.to_f / self.raid_pairings.count.to_f
        danger = outnumbered_ratio + 5.00 * self.village.slayers.to_f
        danger_value = danger / self.dice_roll.to_f
    end

    def knights_killed
        new_knights = self.village.knights * 0.4 * self.danger_value
        if new_knights.round > self.village.knights
            new_knights = self.village.knights
        end
        knights_killed = self.village.knights - new_knights.round
        self.village.update(knights: new_knights.round)
        #UI.announce("Your dragons killed #{knights_killed} knights in the raid!", "green")
        @@notifications << "Your dragons killed #{knights_killed} knights in the raid!"
        GameData.increase_score_by(knights_killed)
    end

    def slayers_killed
        if self.village.slayers > 0
            new_slayers = self.village.slayers * 0.4 * self.danger_value
            if new_slayers.round > self.village.slayers
                new_slayers = self.village.slayers
            end
            slayers_killed = self.village.slayers - new_slayers.round
            self.village.update(slayers: new_slayers.round)
            #UI.announce("Your dragons killed #{slayers_killed} slayers in the raid!", "green")
            @@notifications << "Your dragons killed #{slayers_killed} slayers in the raid!"
            points = 5 * slayers_killed
            GameData.increase_score_by(points)
        end
    end

    def victims
        victims = 0
        if self.dragons.count > 0
            if self.danger_value > 1
                massacre = self.hunger / self.danger_value
                victims = massacre.round
                self.dragons.each do |dragon|
                    own_vic = dragon.hunger / self.danger_value
                    new_hunger = dragon.hunger - own_vic.round
                    dragon.update(hunger: new_hunger)
                end
            else
                victims = self.hunger
                self.dragons.update(hunger: 0)
            end
            new_pop = self.village.population - victims
            self.village.update(population: new_pop)
            #UI.soft_announce("Your dragons consumed #{victims} people.", "green")
            @@notifications << "Your dragons consumed #{victims} people."
        end
        if self.village.population < 1
            #UI.soft_announce("#{self.village.name} was destroyed!", "blue")
            @@notifications << "#{self.village.name} was destroyed!"
            self.village.destroy
        elsif self.village.knights == 0
            self.village.update(knights: 1)
            #UI.soft_announce("A knight has appeared in #{self.village.name} to defend the \npeople from further attacks.", "red")
            @@notifications << "A knight has appeared in #{self.village.name} to defend the people from further attacks."
        end
    end

    def dragons_killed_or_injured
        healthy_dragons = self.dragons
        death_chance = (self.danger_value - 5) * 0.2
        deaths = self.raid_pairings.count * death_chance
        dragons_killed = deaths.round
        if dragons_killed > self.raid_pairings.count
            dragons_killed = self.raid_pairings.count
        end
        dragons_killed.times do
            dead_dragon = healthy_dragons.sample
            #UI.announce("#{dead_dragon.name} died during the raid!", "red")
            @@notifications << "#{dead_dragon.name} died during the raid!"
            Dragon.kill_dragon(dead_dragon)
            healthy_dragons.delete(dead_dragon)
        end
        if dragons_killed < self.raid_pairings.count
            injure_chance = (self.danger_value - 3.5) * 0.65
            injuries = self.raid_pairings.count * injure_chance
            dragons_injured = injuries.round
            dragons_injured.times do
                injured_dragon = healthy_dragons.sample
                if injured_dragon
                    Dragon.injure_dragon(injured_dragon)
                    #UI.announce("#{injured_dragon.name} was injured in the raid!", "red")
                    @@notifications << "#{injured_dragon.name} was injured in the raid!"
                    healthy_dragons.delete(injured_dragon)
                end
            end
        end
    end

    def locate_egg
        egg_dice = [*1..20]
        if self.dragons.count > 0
            if Dragon.all.count < 4
                if egg_dice.sample == 16 || egg_dice.sample == 17 || egg_dice.sample == 18 || egg_dice.sample == 19 || egg_dice.sample == 20
                    GameData.find_egg
                    #UI.announce("Your dragons located a dragon egg!", "green")
                    @@notifications << "Your dragons located a dragon egg!"
                end
            elsif Dragon.all.count > 3 && Dragon.all.count < 7
                if egg_dice.sample == 19 || egg_dice.sample == 20
                    GameData.find_egg
                    #UI.announce("Your dragons located a dragon egg!", "green")
                    @@notifications << "Your dragons located a dragon egg!"
                end
            else
                if egg_dice.sample == 20
                    GameData.find_egg
                    #UI.announce("Your dragons located a dragon egg!", "green")
                    @@notifications << "Your dragons located a dragon egg!"
                end
            end
        end
    end

    def result
        @@notifications.clear
        if self.danger_value > 0.00
            self.knights_killed
            self.slayers_killed
            self.dragons_killed_or_injured
            self.locate_egg
        end
        self.victims
        self.dragons.each do |dragon|
            if dragon.health == "Healthy"
                dragon.update(health: "Tired")
            end
        end
        return @@notifications
    end
end
