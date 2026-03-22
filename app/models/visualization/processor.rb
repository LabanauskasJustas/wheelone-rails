class Visualization::Processor
  def self.call(visualization)
    new(visualization).call
  end

  def initialize(visualization)
    @visualization = visualization
  end

  def call
    # TODO: call Python service here
    # response = PythonApi.generate(car_image_url, rim_image_url)
    # @visualization.result_image.attach(response[:image])
    @visualization.ready!
  end

  private

  attr_reader :visualization
end
