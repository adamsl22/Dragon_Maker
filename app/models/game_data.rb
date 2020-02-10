class GameData < ApplicationRecord
    def self.current_game
        GameData.find_by(id: 1)
    end
    def self.high_score
        GameData.find_by(id: 2)
    end
    def self.eggs
        self.current_game.eggs
    end
    def self.hatch_egg
        new_eggs = self.eggs - 1
        self.current_game.update(eggs: new_eggs)
    end
    def self.vs_hatch_egg(vsn)
        game = GameData.find_by(mpi: vsn)
        new_eggs = game.eggs - 1
        game.update(eggs: new_eggs)
    end
    def self.find_egg
        new_eggs = self.eggs + 1
        self.current_game.update(eggs: new_eggs)
    end
    def self.vs_find_egg(vsn)
        game = GameData.find_by(mpi: vsn)
        new_eggs = game.eggs + 1
        game.update(eggs: new_eggs)
    end
    def self.turn
        self.current_game.turn
    end
    def self.check_for_loss
        if Dragon.all.count == 0 && self.eggs == 0
            return true
        end
    end
    def self.check_vswin
        p1 = GameData.find_by(mpi: 1)
        p2 = GameData.find_by(mpi: 2)
        if p1.score > p1.tp || p2.score > p2.tp
            if p1.score > p2.score
                UI.announce("#{p1.player_name} Wins!!", "blue")
                #exit
            elsif p2.score > p1.score
                UI.announce("#{p2.player_name} Wins!!", "blue")
                #exit
            else
                UI.announce("The game has ended in a tie! Well played all around!", "red")
                #exit
            end
        end
    end
    def self.increment_turn
        turn = self.turn
        Dragon.recovery("sp")
        new_turn = self.turn + 1
        self.current_game.update(turn: new_turn)
    end
    def self.vs_increment_turn
        game = GameData.find_by(mpi: 1)
        turn = game.turn
        Village.vs_attack(turn)
        self.check_for_loss
        self.check_vswin
        Village.clearnotes
        Village.population_growth("vs", turn)
        Village.knights("vs", turn)
        Village.slayers("vs", turn)
        Village.new_village("vs", turn)
        Dragon.add_hunger(1)
        Dragon.add_hunger(2)
        Dragon.recovery("vs")
        new_turn = turn + 1
        game.update(turn: new_turn)
        p2 = GameData.find_by(mpi: 2)
        p2.update(turn: new_turn)
    end
    def self.score
        self.current_game.score
    end
    def self.update_name(new_name)
        self.current_game.update(player_name: new_name)
    end
    def self.player_name
        self.current_game.player_name
    end
    def self.increase_score_by(num)
        new_score = self.score + num
        self.current_game.update(score: new_score)
        if self.current_game.score > self.high_score.score
            self.high_score.update(player_name: self.player_name, turn: self.turn, eggs: self.eggs, score: self.score)
        end
    end
    def self.set_vsplayer(vsn, name, tp)
        vsplayer = GameData.find_by(mpi: vsn)
        if !vsplayer
            vsplayer = GameData.create(player_name: name, turn: 1, eggs: 3, score: 0, mpi: vsn, tp: tp)
        else
            vsplayer.update(player_name: name, turn: 1, eggs: 3, score: 0, mpi: vsn, tp: tp)
        end
    end
end
