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
        lamps.inject(0) do |result, elem|
          self.all_power += elem.power * time
          result + elem.power
        end
      end

      def input_power_now(_locale)
        lamps.inject(0){ |result, elem| result + elem.power }
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
        if on? && locale
          lamps.inject(0) do |result, elem|
            self.all_power += elem.power * time
            result += elem.power
          end
        end 
      end
    end
  end
end
