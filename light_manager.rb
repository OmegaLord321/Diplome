# frozen_string_literal: true

require_relative 'light_bulb'
require 'pry'

module Manager
  module LightManager
    CHANDELIER = 10
    NUMBER_OF_LAMP = CHANDELIER * 4

    LED_POWER = 10
    LED_VOLTAGE = 220

    FLOUR_POWER = 80
    FLOUR_VOLTAGE = 115

    class Chandelier
      attr_accessor :lamps, :all_power

      def initialize
        @all_power = 0
      end

      def input_power(time, _person)
        lamps.each { |lam| self.all_power += lam.power * time }
      end
    end

    class Fluorescents < Chandelier
      def initialize
        @lamps = LightBulb.create_lamps({ power: FLOUR_POWER, voltage: FLOUR_VOLTAGE }, NUMBER_OF_LAMP)
        super
      end
    end

    class Leds < Chandelier
      def initialize
        @lamps = LightBulb.create_lamps({ power: LED_POWER, voltage: LED_VOLTAGE }, NUMBER_OF_LAMP)
        super
      end
    end

    class NureEnergy < Chandelier
      attr_accessor :illumination

      def initialize
        @lamps = LightBulb.create_lamps({ power: LED_POWER, voltage: LED_VOLTAGE }, NUMBER_OF_LAMP)
        @illumination = 0.8
        super
      end

      def measure_illumination
        plus = illumination >= 0.8 ? -1 * Random.new.rand(0.1) : Random.new.rand(0.1)
        self.illumination += plus
      end

      def on?
        measure_illumination >= 0.8
      end

      def input_power(time, locale)
        lamps.each { |lam| self.all_power += lam.power * time } if on? && locale
      end
    end
  end
end
