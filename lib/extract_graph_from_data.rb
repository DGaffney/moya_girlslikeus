class ExtractGraphFromData
  def self.path
    File.dirname(__FILE__)+"/../moya_dataset.csv"
  end

  def self.dataset
    keys = nil
    dataset = []
    CSV.open(self.path).each do |r|
      keys.nil? ? keys = r : dataset << Hash[keys.zip(r)]
    end
    dataset
  end

  def self.graph
    raw = self.dataset
    graph = {nodes: self.nodes(raw), edges: self.edges(raw)}
  end

  def self.nodes(dataset)
    (Tweet.fields("user.screen_name").collect(&:user).collect(&:screen_name)|Tweet.fields(:text).collect(&:text).compact.collect(&:extract_screen_names).flatten).compact.collect(&:downcase).uniq.map do |name|
      {id: name, label: name}
    end
  end

  def self.edges(dataset)
    set = []
    Tweet.fields("user.screen_name", :text).each do |r|
      next if r.text.nil?
      r.text.extract_screen_names.each do |name|
        set << {source: r.user.screen_name.downcase, target: name.downcase}
      end
    end
    set
  end

  def self.run
    Graph.new(self.graph).to_gexf
  end
end
