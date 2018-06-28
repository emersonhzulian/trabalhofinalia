class Modelo
  
  attr_accessor :nome, :comentario, :estrelando # Creates getter and setter methods.
  
  def initialize(nome, comentario)
    @nome = nome
    @comentario = comentario
    @estrelando = []
  end

end
