class Configuration
  attr_accessor :namespaces
  attr_accessor :trace_id_length

  def initialize
    @namespaces = []
    @trace_id_length = 8
  end
end
