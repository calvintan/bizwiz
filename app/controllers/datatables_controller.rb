class DatatablesController < ApplicationController
  def index
    @datatables = Datatable.where(graph_id: params[:graph_id])
    @datatable = Datatable.new
    @graph = @datatables.first.graph
    total_value = 0
    @datatables.each { |e| total_value += e.value }
    @data_arrays = []
    @pie_array = []
    @data_series = @datatables.group_by { |data| data[:series] }
    @data_series.each do |k, v|
      arr = Array.new
      v.each do |data|
        m_arr = Array.new
        m_arr << data.column
        m_arr << data.value
        arr << m_arr
      end
      @data_arrays << arr
    end

    @series_name = []
    @data_series.each do |k, v|
      @series_name << k
    end

    @options = []
    @series_name.each_with_index do |n, i|
      @options << {name: n, data: @data_arrays[i]}
    end

    @data_series.each do |k, v|
      v.each do |data|
        m_arr =Array.new
        m_arr << k
        m_arr << (data.value * 100 / total_value).round(1)
        @pie_array << m_arr
      end
    end




      # @temp_array = []
      # @temp_array << data.series
      # @temp_array << data.value
      # @data_array << @temp_array
      # @pie_array << [data.series, (data.value * 100 / total_value).round(1)]
      # @data_array << [data.series, data.value]
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
    xlsx_read if params[:file].original_filename.match(/.xlsx/)
    docx_read if params[:file].original_filename.match(/.docx/)
    pdf_read if params[:file].original_filename.match(/.pdf/)
    redirect_to collection_path(params[:collection_id])
  end

  def pdf_read
    reader = PDF::Reader.new(@datatable.path)
    reader.pages.each do |page|
      @graph = Graph.create(collection_id: params[:collection_id])
      s = page.text.split("\n")
      s.each do |e|
        e = e.split
        e[1..-1].each do |v|
          @datatable = Datatable.create({key: e[0], value: v.to_f, graph_id: @graph.id}) if (e[0].empty? == false) && (v.to_f != 0)
        end
      end
    end
  end

  def docx_read
    doc = Docx::Document.open(@datatable.path)
    doc.tables.each do |table|
      @graph = Graph.create({collection_id: params[:collection_id]})
      table.rows.each do |row|
        data = []
        row.cells.each { |e| data << e.text }
        data[1..-1].each do |d|
          @datatable = Datatable.create({ series: data[0], value: d.to_f, graph_id: @graph.id }) if (data[0].empty? == false) && (d.to_f != 0)
        end
      end
    end
  end

  def xlsx_read
    spreadsheet = Roo::Excelx.new(@datatable.path)
    spreadsheet.sheets.each do |name|
      # Create a new graph for each Excel sheet
      @graph = Graph.create({name: name, collection_id: params[:collection_id]})
      # sheet = spreadsheet.sheet(name)
      @dataset = []
      @series = []
      @columns = []
      spreadsheet.sheet(name).each_row_streaming { |r| @dataset.push(r) }
      @dataset[0].each { |e| @columns.push(e.value) }
      @dataset[1..-1].each { |e| @series.push(e[0].value) }
      # If the last cell of the first row in the Excel is a string, begin collecting the data from the next row instead.
      
      @dataset[0..-1].each_with_index do |e, i|
        e[1..-1].each_with_index do |v, ii|
          @datatable = Datatable.create({series: @series[i], column: @columns[ii], value: v.value.to_i, graph_id: @graph.id}) if (v.value.to_i != 0) && (e[0].nil? == false)
        end
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
    params.require(:datatable).permit(:value, :column, :series)
  end
end
