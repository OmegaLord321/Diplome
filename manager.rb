# frozen_string_literal: true

require_relative 'light_manager'
require 'axlsx'

module Manager
  class Runne
    WORK_HOUR = 8
    STEP_IN_MINUTES = 15
    START = 0

    class << self
      def call
        fluorescents = LightManager::Fluorescents.new
        leds = LightManager::Leds.new
        nure_energy = LightManager::NureEnergy.new

        save_sheet(nure_energy, 1, 7, 30)
        save_sheet(leds, 1, 7, 30)        
        save_sheet(fluorescents, 1, 7, 30)
      end

      private

      def user_locate(time)
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
              object.input_power(1, user_locate(current_time))
              sheet.add_row [current_time, object.all_power]
            end
          end
        end
        ax.use_shared_strings = true
        ax.serialize("#{object.class}.xlsx")
      end
    end
  end
end
