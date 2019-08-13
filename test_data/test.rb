require 'roo'
require 'docx'
require 'pdf-reader'
require 'pry-byebug'

reader = PDF::Reader.new("/mnt/c/Users/Zhou Sun/Desktop/text.pdf")
reader.pages.each do |page|
  s = page.text.split("\n")
  key = []
  s.each { |e| key << e.split[0]}
  s.each do |e|
    e[1..-1].each do |v|

  end



# xlsx = Roo::Excelx.new("/mnt/c/Users/Zhou Sun/Desktop/text.xlsx")

# row = []
# key = []
# p xlsx.filename
# sheet = xlsx.sheet(0)
# p xlsx.sheets
# sheet.each_row_streaming do |r|
#   row.push(r)
# end
# p row[0].last.value.class

# row[0..-1].each { |e| key.push(e[0].value)}
# p key
# row[0..-1].each_with_index do |e, i|
#   # p e
#   e[1..-1].each do |v|
#     p '------------------------------'
#     p v.value
#     p key[i]
#     p 'saved'
#   end
# end



# docx = Docx::Document.open("/mnt/c/Users/Zhou Sun/Desktop/text.docx")
# # p 'first table '
# # first_table = docx.tables[0]
# # first_table.rows.each do |row|
# #     row.cells.each_with_index do |cell, i|
# #       puts cell.class
# #       p i
# #     end
# # end

# array = []
# p 'second table '
# second_table = docx.tables[1]
# second_table.rows.each do |row|
#   a = []
#     row.cells.each_with_index do |cell, i|
#       # puts cell
#       # p i
#       a.push(cell.text)
#     end
#   array.push(a)
# end

# # p docx.tables.size
# p array
