# frozen_string_literal: true

class LightBulb
  attr_accessor :current, :voltage, :power

  def initialize(params)
    @voltage = params[:voltage]
    @power = params[:power]
    @current = params[:current] unless params[:current]
  end

  class << self
    def create_lamps(params, count)
      array = []
      count.times { new(params).tap { |object| array << object } }
      array
    end
  end
end
