class DatatablesController < ApplicationController
  def index
    @datatables = Datatable.where(graph_id: params[:graph_id])
    @datatable = Datatable.new
    @graph = @datatables.first.graph
    @data_array = []
    @datatables.each do |data|
      @temp_array = []
      @temp_array << data.key
      @temp_array << data.value
      @data_array << @temp_array
    end
  end

  def new
    @datatable = Datatable.new
  end

  def create
    @datatable = Datatable.new(datable_params)
    @datatable.graph_id = params[:graph_id]
    if @datatable.update(datable_params)
      redirect_to graph_datatables_path
    else
      render :new
    end
  end

  def import
    @datatable = params[:file]
    spreadsheet = Roo::Excelx.new(@datatable.path)
    spreadsheet.sheets.each do |name|
      @graph = Graph.new({
        collection_id: params[:collection_id]
      })
      @graph.save
      sheet = spreadsheet.sheet(name)
      @row = []
      sheet.each_row_streaming { |r| @row.push(r) }

      # If the last cell of the first row in the Excel is a string
      if @row[0].last.value.class == String
        display(1)
      else
        display(0)
      end
    end
    redirect_to collection_path(params[:collection_id])
  end

  def display(integer)
    key = []
    @row[integer..-1].each { |e| key.push(e[0].value) }
    @row[integer..-1].each_with_index do |e, i|
      e[1..-1].each do |v|
        @datatable = Datatable.create({
          key: key[i], value: v.value,
          graph_id: @graph.id
        }) if (v.value.nil? == false) && (key[i].nil? == false)
      end
    end
  end

  def edit
    @datatable = Datatable.find(params[:id])
  end

  def update
    @datatable = Datatable.find(params[:id])
    @graph = @datatable.graph
    if @datatable.update(datable_params)
      redirect_to graph_datatables_path(@graph)
    else
      render :edit
    end
  end

  def destroy
    @datatable = Datatable.find(params[:id])
    @graph = @datatable.graph
    @datatable.destroy
    redirect_to graph_datatables_path(@graph)
  end

  private

  def datable_params
    params.require(:datatable).permit(:value, :key)
  end
end
