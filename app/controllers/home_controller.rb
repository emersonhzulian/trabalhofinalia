require 'sparql/client'
require "#{Rails.root}/app/models/Modelo.rb"

class HomeController < ApplicationController


  helper_method [:films]
  def index
  end

  def films
    
    retorno = []

    teste = client.query(query).limit(100)
    puts(query)
    teste.each do |film|
          nome = film[:film]
          comentario = film[:comment]
          estrelando = film[:starring]

          if(retorno.empty?) 
                model = Modelo.new(nome, comentario)
		model.estrelando.push(estrelando)
		retorno.push(model)
	  else 
            filmeEncontrado = retorno.find{|aux| aux.nome == nome}
            if(filmeEncontrado != nil) 
                filmeEncontrado.estrelando.push(estrelando)
	    else
		model = Modelo.new(nome, comentario)
		model.estrelando.push(estrelando)
		retorno.push(model)
            end
          end
          
    end
    


retorno
  end

  private

  def client
    @client ||= SPARQL::Client.new("http://pt.dbpedia.org/sparql")
  end

  def query
    qry = <<-QUERY
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX dbr: <http://dbpedia.org/resource/>
      SELECT DISTINCT ?film ?comment ?starring WHERE {
        ?film rdf:type dbo:Film .
        ?film rdfs:comment ?comment .
        ?film dbo:starring ?starring .
        FILTER(LANGMATCHES(LANG(?comment), "pt")) .
        #{genre_query}
        #{country_query}
        #{search_query}
      }
    QUERY
  end

  def genre_query
    return "" unless params[:genre].present?

    "?film dbo:genre dbr:#{params[:genre]} ."
  end

  def country_query
    return "" unless params[:country].present?

    "?film dbo:country dbr:#{params[:country]} ."
  end

  def search_query
    return "" unless params[:search].present?

    nomeFilme = params[:search].gsub(" ", "_")

    "FILTER regex(str(?film), '#{nomeFilme}') ."
  end

end
