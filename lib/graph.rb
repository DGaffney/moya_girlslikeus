class Graph
  def self.from_edges(conditions)
    graph = {edges: [], nodes: {}}
    self.edge_cursor(conditions).each do |e|
      graph.edges << {source: e.source, target: e.target, attributes: e.edge_attributes}
      graph.nodes[e.source] ||= {:id => e.source, :label => e.source}
      graph.nodes[e.target] ||= {:id => e.target, :label => e.target}
    end
    self.new(edges: graph.edges, nodes: graph.nodes.values)
  end

  def self.edge_cursor(conditions)
    Edge.where(conditions)
  end

  def to_gexf(file=StringIO.new("", "w+"))
    gexf = GEXF.new(file)
    gexf.header_declaration;false
    gexf.graph_declaration;false
    gexf.attribute_declarations(attribute_declarations);false
    gexf.nodes(@nodes);false
    gexf.edges(@edges);false
    gexf.footer;false
    gexf.file.rewind
    gexf.file
  end

  def initialize(graph)
    @nodes = graph.nodes
    @edges = graph.edges
  end

  def attribute_declarations
    {node: {static: []}, edge: {static: []}}
  end

  def gexf_type(class_to_s)
    {
      "Float" => "double",
      "FalseClass" => "boolean",
      "TrueClass" => "boolean",
      "Array" => "string",
      "Hash" => "string",
      "String" => "string",
      "NilClass" => "string",
    }[class_to_s]
  end
end
#(gexf = (g = Graph.from_edges(query)).to_gexf(File.open("ferguson_reduced.gexf", "w")))
