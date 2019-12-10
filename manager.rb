# frozen_string_literal: true

require_relative 'light_manager'

module Manager
  class Runner
    DAYS = 30
    WORK_HOUR = 8
    STEP_IN_MINUTES = 15
    START = 0
    WORKING_MINUTES = DAYS * WORK_HOUR * 60

    class << self
      def call
        fluorescents = LightManager::Fluorescents.new
        leds = LightManager::Leds.new
        nure_energy = LightManager::NureEnergy.new

        (START...WORKING_MINUTES).step(STEP_IN_MINUTES) do |current_time|
          nure_energy.input_power(1, user_locate(current_time))
          leds.input_power(1)
          print current_time
          print " #{nure_energy.all_power}"
          print " #{leds.all_power}\n"
        end
      end

      def user_locate(time)
        time % 45 != 0
      end
    end
  end
end
