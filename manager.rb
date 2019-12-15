require_relative 'light_manager'
require 'axlsx'

module Manager
  class Runner
    WORK_HOUR = 8
    STEP_IN_MINUTES = 15
    START = 0

    DAY = 1
    WEEK = 7
    MONTH  = 30
    KW = 1000.0

    class << self
      def call
        fluorescents = LightManager::Fluorescents.new
        leds = LightManager::Leds.new
        nure_energy = LightManager::NureEnergy.new

        save_sheet(nure_energy, DAY, WEEK, MONTH)
        save_sheet(leds, DAY, WEEK, MONTH)        
        save_sheet(fluorescents, DAY, WEEK, MONTH)
      end

      private

      def user_locate?(time)
        time % 45 != 0
      end

      def to_minutes(days)
        days * WORK_HOUR * 60
      end

      def save_sheet(object, *days)
        ax = Axlsx::Package.new
        days.each do |day|
          ax.workbook.add_worksheet(name: "#{day}") do |sheet|
            (START...to_minutes(day)).step(STEP_IN_MINUTES) do |current_time|
              user_in = user_locate?(current_time)
              time = map(current_time, START, to_minutes(day), 0.0, 1.0)
              current_power = object.input_power(time, user_in)
              current_power = current_power.nil? ? 0 : current_power / KW
              sheet.add_row [current_time, current_power, object.all_power / KW]
              sheet.add_row [current_time, current_power, object.all_power / KW]
            end
          end
          object.all_power = 0
        end
        ax.use_shared_strings = true
        ax.serialize("#{object.class}.xlsx")
      end

      def map(x, in_min, in_max, out_min, out_max)
        (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
      end
    end
  end
end
