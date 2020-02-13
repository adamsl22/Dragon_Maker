class Village < ApplicationRecord
    has_many :raids

    @@spv = []
    @@mpv = []
    @@notifications = []

    def self.nomads(mode)
        if mode == "sp"
            nomads = Village.create(name: "Nomads", population: 30, knights: 0, slayers: 0, game_id: 1)
            @@spv << nomads
        elsif mode == "vs"
            nomads = Village.create(name: "Nomads", population: 30, knights: 0, slayers: 0, game_id: 2)
            @@mpv << nomads
        end
    end

    def self.population_growth(mode, turn)
        new_pop = 0
        if mode == "sp"
            group = @@spv
        elsif mode == "vs"
            group = @@mpv
        end
        #group.each do |village|
        Village.all.each do |village|
            if village.name == "Nomads" || village.population > 100
                if village.population > 24 && turn < 100
                    new_pop = village.population + 0.03 * village.population
                elsif village.population < 25 && turn < 100
                    new_pop = village.population + 0.30 * village.population
                elsif village.name == "Nomads"
                    new_pop = village.population
                else
                    new_pop = village.population + 0.01 * village.population
                end
            else
                if village.population < 25
                    if turn < 50
                        new_pop = village.population + 0.30 * village.population
                    elsif turn > 49 && turn < 100
                        new_pop = village.population + 0.40 * village.population
                    else
                        new_pop = village.population + 0.50 * village.population
                    end
                else
                    if turn < 50
                        new_pop = village.population + 0.03 * village.population
                    elsif turn > 49 && turn < 100
                        new_pop = village.population + 0.06 * village.population
                    elsif turn > 99 && turn < 300
                        new_pop = village.population + 0.09 * village.population
                    else
                        new_pop = village.population + 0.12 * village.population
                    end
                end
            end
            village.update(population: new_pop.round)
        end
    end

    def self.most_populous_village(mode)
        # if mode == "sp"
        #     @@spv.max_by do |village|
        #         village.population
        #     end
        # elsif mode == "vs"
        #     @@mpv.max_by do |village|
        #         village.population
        #     end
        # end
        Village.all.max_by do |village|
            village.population
        end
    end

    def self.new_village(mode, turn)
        if mode == "sp"
            group = @@spv
            id = 1
        elsif mode == "vs"
            group = @@mpv
            id = 2
        end
        if turn == 3
            #nomads = group.find_by(name: "Nomads")
            nomads = Village.find_by(name: "Nomads")
            nomad_pop = nomads.population - 15
            nomads.update(population: nomad_pop)
            first_village = Village.create(name: "Primeton", population: 15, knights: 0, slayers: 0, game_id: id)
            group << first_village
            #@@notifications << UI.soft_announce("The people have founded the village of Primeton.", "blue")
            @@notifications << "The people have founded the village of Primeton."
        end
        village_dice = [1,2,3,4,5]
        population_dice = [10,11,12,13,14,15,16,17,18,19,20]
        settlers = population_dice.sample
        vowels = ["a","e","i","o","u","y"]
        consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","z"]
        name_array = [consonants.sample, vowels.sample, consonants.sample, consonants.sample, vowels.sample, consonants.sample, vowels.sample]
        name = name_array.join
        #if turn > 5 && self.most_populous_village(mode).population > 25 && village_dice.sample == 3 && group.count < 15
        if turn > 5 && self.most_populous_village(mode).population > 25 && village_dice.sample == 3 && Village.all.count < 15
            home_pop = self.most_populous_village(mode).population - settlers
            self.most_populous_village(mode).update(population: home_pop)
            new_village = Village.create(name: name.capitalize, population: settlers, knights: 0, slayers: 0, game_id: id)
            group << new_village
            #@@notifications << UI.soft_announce("The people have founded the village of #{new_village.name}.", "blue")
            @@notifications << "The people have founded the village of #{new_village.name}."
        end
    end

    def self.knights(mode, turn)
        knights_dice = [1,2,3,4,5]
        if mode == "sp"
            group = @@spv
        elsif mode == "vs"
            group = @@mpv
        end
        #group.each do |village|
        Village.all.each do |village|
            if village.knights > 0
                new_knight = village.knights + 1
                second_knight = village.knights + 2
                third_knight = village.knights + 3
                if village.name == "Nomads" || village.knights > 70
                    if turn % 10 == 0
                        village.update(knights: new_knight)
                    end
                else
                    if turn < 50
                        if village.knights < 15
                            village.update(knights: second_knight)
                        elsif knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: new_knight)
                        end
                    elsif turn > 49 && turn < 100
                        if village.knights < 20
                            village.update(knights: third_knight)
                        else
                            village.update(knights: new_knight)
                        end
                    elsif turn > 99 && turn < 200
                        if village.knights < 25
                            village.update(knights: third_knight)
                        elsif knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: second_knight)
                        else
                            village.update(knights: new_knight)
                        end
                    elsif turn > 199 && turn < 300
                        if village.knights < 25
                            village.update(knights: third_knight)
                        else
                            village.update(knights: second_knight)
                        end
                    elsif turn > 299 && turn < 400
                        if village.knights < 25 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: third_knight)
                        else
                            village.update(knights: second_knight)
                        end
                    else
                        if village.knights < 25 || knights_dice.sample == 2 || knights_dice.sample == 3 || knights_dice.sample == 4 || knights_dice.sample == 5
                            village.update(knights: third_knight)
                        else
                            village.update(knights: second_knight)
                        end
                    end
                end
            end
        end
        #unraided_villages = group.select {|village| village.knights == 0}
        unraided_villages = Village.all.select {|village| village.knights == 0}
        if turn % 5 == 0 && unraided_villages.count > 0
            if turn > 49 && unraided_villages.count > 1
                unraided_villages.each {|village| village.update(knights: 1)}
                #@@notifications << UI.soft_announce("Fear of your dragons is spreading. More villages are beginning to train knights.", "red")
                @@notifications << "Fear of your dragons is spreading. More villages are beginning to train knights."
            else
                news_recipient = unraided_villages.sample
                news_recipient.update(knights: 1)
                #@@notifications << UI.soft_announce("News of your dragon raids has spread to #{news_recipient.name}.\n The village has begun training knights in fear of your \nattacks.", "red")
                @@notifications << "News of your dragon raids has spread to #{news_recipient.name}. The village has begun training knights in fear of your attacks."
            end
        end
    end

    def self.new_slayer(mode)
        # if mode == "sp"
        #     slayer_home = @@spv.sample
        # elsif mode == "vs"
        #     slayer_home = @@mpv.sample
        # end
        slayer_home = Village.all.sample
        new_slayers = slayer_home.slayers + 1
        slayer_home.update(slayers: new_slayers)
        #@@notifications << UI.soft_announce("Another slayer has emerged among the people.", "red")
        @@notifications << "Another slayer has emerged among the people."
    end

    def self.slayers(mode, turn)
        slayers_dice = [1,2,3,4,5]
        if turn == 20
            # if mode == "sp"
            #     slayer_home = @@spv.sample
            # elsif mode == "vs"
            #     slayer_home = @@mpv.sample
            # end
            slayer_home = Village.all.sample
            new_slayers = slayer_home.slayers + 1
            slayer_home.update(slayers: new_slayers)
            #@@notifications << UI.soft_announce("The people are learning how to better kill dragons. A\nslayer has emerged who poses a grave threat!", "red")
            @@notifications << "The people are learning how to better kill dragons. A slayer has emerged who poses a grave threat!"
        elsif turn == 30 || turn == 40
            self.new_slayer(mode)
        elsif turn > 49 && turn < 100
            if slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer(mode)
            end
        elsif turn > 99 && turn < 200
            if slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer(mode)
            end
        elsif turn > 199 && turn < 300
            if slayers_dice.sample == 2 || slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer(mode)
            end
        elsif turn > 299 && turn < 400
            if slayers_dice.sample == 2 || slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer(mode)
            end
            if slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer(mode)
            end
        elsif turn > 399
            self.new_slayer(mode)
            if slayers_dice.sample == 3 || slayers_dice.sample == 4 || slayers_dice.sample == 5
                self.new_slayer(mode)
            end
        end
    end

    def self.list_villages
    final_output = ""
        if self.all.count == 0
            final_output = "\n                You do not have any villages. \n      ".blue
        else
            self.all.each do |village|
                final_output = final_output + "___________________________________________________________\n   Name: #{village.name}    |   Population: #{village.population}  |   Knights: #{village.knights} | Slayers: #{village.slayers} \n ___________________________________________________________ \n  "
            end
        end
    final_output
    end

    def self.attack(turn)
        attack_dice = [1,2,3,4,5,6]
        attack_chance = attack_dice.sample
        attacking_village = Village.all.sample
        if attacking_village.knights > 25 && turn > 55 && attack_chance == 6
            return attacking_village
        else
            return false
        end
    end
    def self.attacking_knights(turn)
        if turn < 100
            attacking_knights = 10
        elsif turn > 99 && turn < 200
            attacking_knights = 15
        else
            attacking_knights = 20
        end
    end
    def self.attacking_slayers(village, turn)
        if turn < 100
            attacking_slayers = 1
        elsif turn > 99 && turn < 200 && village.slayers > 1
            attacking_slayers = 2
        else
            attacking_slayers = village.slayers
        end
    end
    def self.attack_start(attacking_village)
        turn = GameData.current_game.turn
        notifications = []
        #UI.announce("Knights from #{attacking_village.name} are attacking!", "red")
        notifications << "Knights from #{attacking_village.name} are attacking!"
        attacking_knights = self.attacking_knights(turn)
        #UI.announce("#{attacking_knights} knights approach your dragons.", "red")
        notifications << "#{attacking_knights} knights approach your dragons."
        if attacking_village.slayers > 0
            attacking_slayers = self.attacking_slayers(attacking_village, turn)
            #UI.announce("They are accompanied by #{attacking_slayers} slayers.", "red")
            notifications << "They are accompanied by #{attacking_slayers} slayers."
        end
        return notifications
    end
    def self.attack_result(attacking_village)
        turn = GameData.current_game.turn
        attacking_knights = self.attacking_knights(turn)
        if attacking_village.slayers > 0
            attacking_slayers = self.attacking_slayers(attacking_village, turn)
        end
        attack_dice = [1,2,3,4,5,6]
        attack_roll = attack_dice.sample
        your_roll = attack_dice.sample
        notifications = []
        #Rolls
        # if attack_roll < 3
        #     UI.announce("The attackers roll a #{attack_roll}.", "green")
        # elsif attack_roll > 4
        #     UI.announce("The attackers roll a #{attack_roll}.", "red")
        # else
        #     UI.announce("The attackers roll a #{attack_roll}.", "blue")
        # end
        notifications << "The attackers roll a #{attack_roll}."
        # if your_roll < 3
        #     UI.announce("You roll a #{your_roll}.", "red")
        # elsif your_roll > 4
        #     UI.announce("You roll a #{your_roll}.", "green")
        # else
        #     UI.announce("You roll a #{your_roll}.", "blue")
        # end
        notifications << "You roll a #{your_roll}."
        #DV
        defending_dragons = Dragon.all.count
        outnumbered_ratio = attacking_knights.to_f / defending_dragons.to_f
        danger = outnumbered_ratio + 5.00 * attacking_slayers.to_f
        roll_difference = attack_roll.to_f - your_roll.to_f
        danger_value = danger + roll_difference
        if danger_value < 0.00
            #UI.announce("Your dragons destroyed all attackers!", "green")
            notifications << "Your dragons destroyed all attackers!"
            new_knights = attacking_village.knights - attacking_knights
            attacking_village.update(knights: new_knights)
            if attacking_slayers
                new_slayers = attacking_village.slayers - attacking_slayers
                attacking_village.update(slayers: new_slayers)
            end
        else
            #Knights
            dead_knights = attacking_knights.to_f - danger_value / 2.00
            knights_killed = dead_knights.round
            if knights_killed < 0
                knights_killed = 0
            end
            new_knights = attacking_village.knights - knights_killed
            attacking_village.update(knights: new_knights)
            #UI.announce("Your dragons killed #{knights_killed} attacking knights!", "green")
            notifications << "Your dragons killed #{knights_killed} attacking knights!"
            GameData.increase_score_by(knights_killed)
            #Slayers
            if attacking_slayers
                slayer_hardiness = 6.25 + roll_difference
                dead_slayers = attacking_slayers.to_f / slayer_hardiness
                slayers_killed = dead_slayers.round
                new_slayers = attacking_village.slayers - slayers_killed
                attacking_village.update(slayers: new_slayers)
                #UI.announce("Your dragons killed #{slayers_killed} attacking slayers!", "green")
                notifications << "Your dragons killed #{slayers_killed} attacking slayers!"
                points = 5 * slayers_killed
                GameData.increase_score_by(points)
            end
            #Dragon Deaths
            if roll_difference > 1
                death_chance = (danger_value - 5) / 20.00
            else
                death_chance = 0
            end
            deaths = defending_dragons * death_chance
            dragons_killed = deaths.round
            if dragons_killed > defending_dragons
                dragons_killed = defending_dragons
            end
            dragons_killed.times do
                dead_dragon = Dragon.all.sample
                #UI.announce("#{dead_dragon.name} was killed in the attack!", "red")
                notifications << "#{dead_dragon.name} was killed in the attack!"
                Dragon.kill_dragon(dead_dragon)
            end
            #Dragon Injuries
            if dragons_killed < defending_dragons && roll_difference > 0
                injure_chance = (danger_value - 3.5) / 10.00
                injuries = defending_dragons * injure_chance
                dragons_injured = injuries.round
                if dragons_injured > (defending_dragons - dragons_killed)
                    dragons_injued = defending_dragons - dragons_killed
                end
                dragons_injured.times do
                    injured_dragon = Dragon.all.sample
                    if injured_dragon.health != "Hurt"
                        #UI.announce("#{injured_dragon.name} was injured in the attack!", "red")
                        notifications << "#{injured_dragon.name} was injured in the attack!"
                        Dragon.injure_dragon(injured_dragon)
                    end
                end
            end
        end
        return notifications
    end

    def self.spv
        @@spv
    end
    def self.mpv
        @@mpv
    end
    def self.notifications(turn)
        @@notifications.clear
        Village.population_growth("sp", turn)
        Village.knights("sp", turn)
        Village.slayers("sp", turn)
        Village.new_village("sp", turn)
        return @@notifications
    end
end
