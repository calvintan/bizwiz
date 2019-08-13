class CollectionsController < ApplicationController
  def index
  end

  def create
    @collection = Collection.new
    @collection.save
    redirect_to new_collection_datatable_path(@collection)
  end

  def show
    @collection = Collection.find(params[:id])
    @graphs = @collection.graphs
  end
end
