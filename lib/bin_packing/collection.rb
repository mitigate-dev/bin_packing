module Collection
  def create_all(*hshs)
    hshs.map do |hsh|
      b = new(hsh[:width],hsh[:height])
      hsh.each {|k,v| b.send("#{k}=", v)}
      b
    end
  end
end
