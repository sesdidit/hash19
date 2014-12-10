require 'spec_helper'

describe 'Containers' do

  class Testable
    include Hash19
  end

  class SuperHeroes < Testable
    contains :super_heroes
    inject at: '$', using: :weapon_id, reference: :id, trigger: lambda { |ids| Weapon.find_all ids }
  end

  class SuperHero < Testable
    attributes :name, :power, :weapon_id
    has_one :weapon, using: :weapon_id, trigger: lambda { |id| Weapon.find id }
  end

  class Weapon < Testable
    attributes :name, :id

    def self.find(id)
      case id
        when 1
          {'name' => 'jarvis', 'id' => 1}
        when 2
          {'name' => 'hammer', 'id' => 2}
        when 3
          {'name' => 'hands', 'id' => 3}
      end

    end
  end

  context 'contains directive' do
    xit 'should comprise of collection of specified object' do
      super_heroes = SuperHeroes.new([{name: 'iron man', power: 'none', weapon_id: 1},
                                      {name: 'thor', power: 'class 100', weapon_id: 2},
                                      {name: 'hulk', power: 'bulk', weapon_id: 3}])

      expect(super_heroes.to_h).to eq([{'name' => 'iron man', 'power' => 'none', 'weapon' => {'name' => 'jarvis', 'id' => 1}},
                                       {'name' => 'thor', 'power' => 'class 100', 'weapon' => {'name' => 'hammer', 'id' => 2}},
                                       {'name' => 'hulk', 'power' => 'bulk', 'weapon' => {'name' => 'hands', 'id' => 3}}])
    end
  end

end