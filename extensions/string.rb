class String
  include Twitter::Extractor

  def extract_screen_names
    extract_mentioned_screen_names(self)
  end
end
