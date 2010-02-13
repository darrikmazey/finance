module InvoicesHelper
	def pdf_footer(pdf, invoice)
		pdf.bounding_box [0, 10], :width => pdf.bounds.width, :height => 10 do
			pdf.stroke_horizontal_rule
			pdf.bounding_box [0, 8], :width => (pdf.bounds.width / 3), :height => 8 do
				pdf.text Date.today.to_s.gsub(/-/, '.'), :size => 8, :align => :left
			end
			pdf.bounding_box [(pdf.bounds.width / 3), 8], :width => (pdf.bounds.width / 3), :height => 8 do
				pdf.text 'DarmaSoft, LLC.', :size => 8, :align => :center
			end
			pdf.bounding_box [(pdf.bounds.width / 3 * 2), 8], :width => (pdf.bounds.width / 3), :height => 8 do
				pdf.text 'Invoice #' + invoice.identifier, :size => 8, :align => :right
			end
		end
	end

	def pdf_header(pdf, invoice)
		pdf.bounding_box [ 0, pdf.bounds.top ], :width => pdf.bounds.width, :height => 100 do
			pdf.stroke_bounds
			pdf.bounding_box [ 10, 80 ], :width => (pdf.bounds.width), :height => 80 do
				pdf.text 'DarmaSoft, LLC', :align => :center, :size => 20
				pdf.text '1627 Marigold Avenue', :align => :center, :size => 12
				pdf.text 'Akron, OH 44301-2627', :align => :center, :size => 12
				pdf.text '330.983.9941', :align => :center, :size => 12
			end
		end
	end

	def pdf_invoice_data(pdf, invoice)
		pdf.bounding_box [0, pdf.cursor], :width => pdf.bounds.width, :height => 60 do
			pdf.stroke_bounds
			half_width = pdf.bounds.width / 2
			pdf.bounding_box [10, 50], :width => (half_width - 15), :height => 50 do
				pdf.text invoice.client.name, :size => 10
			end
			pdf.bounding_box [((pdf.bounds.width)/2), 50], :width => (half_width - 15), :height => 50 do
				pdf.text 'Invoice #' + invoice.identifier, :size => 10, :align => :right
				pdf.text 'Billed: ' + invoice.billed_at.short_date, :size => 10, :align => :right
			end
		end
	end

	def generate_table_data(pdf, invoice)
		data = Array.new
		i = 0
		invoice.work_items.each do |work_item|
			row_color = (i % 2 == 0) ? odd_color : even_color
			data << [
				Prawn::Table::Cell.new( :text => work_item.start_time.short_date, :background_color => row_color),
				Prawn::Table::Cell.new( :text => work_item.start_time.short_time, :background_color => row_color),
				Prawn::Table::Cell.new( :text => work_item.end_time.short_time, :background_color => row_color),
				Prawn::Table::Cell.new( :text => 'test', :background_color => row_color),
				Prawn::Table::Cell.new( :text => number_to_currency(work_item.rate.modifier * work_item.project.base_rate), :background_color => row_color),
				Prawn::Table::Cell.new( :text => "%0.02f" % work_item.hours, :background_color => row_color),
				Prawn::Table::Cell.new( :text => number_to_currency(work_item.subtotal), :background_color => row_color),
			]
			i += 1
		end
		data
	end

	def generate_table_headers(pdf, invoice)
		[ 'date', 'in', 'out', 'description', 'rate', 'hours', 'amount'  ]
	end

	def generate_table_widths(pdf, invoice)
		{
			0 => 70,	# date
			1 => 45,	# in
			2 => 45,	# out
			3 => (pdf.bounds.width - 325),		# description
			4 => 55,	# rate
			5 => 45,	# hours
			6 => 65,	# amount
		}
	end

	def summary_table_widths(pdf, invoice)
		{
			0 => (pdf.bounds.width - 110),
			1 => 45,
			2 => 65,
		}
	end

	def summary_table_alignments(pdf, invoice)
		{
			0 => :left,
			1 => :center,
			2 => :right,
		}
	end

	def generate_table_alignments(pdf, invoice)
		{
			0 => :left,
			1 => :center,
			2 => :center,
			3 => :left,
			4 => :center,
			5 => :center,
			6 => :right,
		}
	end

	def odd_color
		'dddddd'
	end

	def even_color
		'eeeeee'
	end
end
