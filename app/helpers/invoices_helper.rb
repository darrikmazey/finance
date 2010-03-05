module InvoicesHelper
  @invoice_background_color

	def pdf_footer(pdf, invoice)
		(1 .. pdf.page_count).each do |page|
			pdf.go_to_page(page)
			pdf.bounding_box [0, 0], :width => pdf.bounds.width, :height => 10 do
				pdf.stroke_horizontal_rule
				pdf.bounding_box [0, 8], :width => (pdf.bounds.width / 3), :height => 8 do
					pdf.text((invoice.billed_at.short_date.gsub(/-/, '.') rescue 'none'), :size => 8, :align => :left)
				end
				pdf.bounding_box [(pdf.bounds.width / 3), 8], :width => (pdf.bounds.width / 3), :height => 8 do
					pdf.text invoice.user.company_name || '', :size => 8, :align => :center
				end
				pdf.bounding_box [(pdf.bounds.width / 3 * 2), 8], :width => (pdf.bounds.width / 3), :height => 8 do
					pdf.text 'Invoice #' + invoice.identifier, :size => 8, :align => :right
				end
			end
		end
	end

	def pdf_header(pdf, invoice)
		pdf.bounding_box [ 0, pdf.bounds.top ], :width => pdf.bounds.width, :height => 100 do
			pdf.stroke_bounds
			pdf.bounding_box [ 10, 80 ], :width => (pdf.bounds.width), :height => 80 do
				pdf.text invoice.user.company_name || '', :align => :center, :size => 20
				pdf.text invoice.user.company_street1 || '', :align => :center, :size => 12
				pdf.text invoice.user.city_state_zip || '', :align => :center, :size => 12
				pdf.text invoice.user.company_phone || '', :align => :center, :size => 12
			end
		end
	end

	def pdf_invoice_data(pdf, invoice)
		pdf.bounding_box [0, pdf.cursor], :width => pdf.bounds.width, :height => 70 do
			pdf.stroke_bounds
			half_width = pdf.bounds.width / 2
			pdf.bounding_box [10, 60], :width => (half_width - 15), :height => 60 do
				pdf.text invoice.client.name, :size => 10
				pdf.text 'c/o ' + invoice.client.contact_name, :size => 9
				pdf.text invoice.client.contact_street1, :size => 9
				if !invoice.client.contact_street2.blank?
					pdf.text invoice.client.contact_street2, :size => 9
				end
				pdf.text invoice.client.city_state_zip, :size => 9
			end
			pdf.bounding_box [((pdf.bounds.width)/2), 60], :width => (half_width - 15), :height => 60 do
				pdf.text 'Invoice #' + invoice.identifier, :size => 10, :align => :right
				pdf.text 'Billed: ' + (invoice.billed_at.short_date rescue 'none'), :size => 10, :align => :right
			end
		end
	end

	def generate_table_data(pdf, invoice)
		data = []
    invoice.invoice_items.each do |invoice_item|
      data << generate_invoice_item_row(invoice_item)
    end
    data
  end

  def generate_invoice_item_row(invoice_item)
    color = background_color
    comments = invoice_item.comments
    first_comment = comments.shift || nil
    row_data = [
      prawn_cell((invoice_item.start_time.short_date rescue 'none'), color),
      prawn_cell((invoice_item.start_time.short_time rescue 'none'), color),
      prawn_cell((invoice_item.end_time.short_time rescue 'none'), color),
      prawn_cell((first_comment.body rescue ''), color),
      prawn_cell(number_to_currency(invoice_item.total_rate), color),
      prawn_cell("%0.02f" % invoice_item.hours, color),
      prawn_cell(number_to_currency(invoice_item.subtotal), color)
    ]
  #  comments.each { |comment| 
  #    row_data << generate_comment_row(comment)
  #  }
    row_data
  end

  def generate_comment_row(comment)
    color = background_color
    return [
      prawn_cell('', color),
      prawn_cell('', color),
      prawn_cell('', color),
      prawn_cell(comment.body, color),
      prawn_cell('', color),
      prawn_cell('', color)
    ]
  end

  def prawn_cell(text, color)
    Prawn::Table::Cell.new( :text => text, :background_color => color)
  end
  
	def generate_table_headers(pdf, invoice)
		[ 'Date', 'In', 'Out', 'Description', 'Rate', 'Hours', 'Amount' ]
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

  def background_color
    @invoice_background_color == even_color ? odd_color : even_color
    return @invoice_background_color
  end

	def odd_color
		'dddddd'
	end

	def even_color
		'eeeeee'
	end
end
