
_page_width = pdf.bounds.width
_page_top = pdf.bounds.top
_page = 1

pdf_header(pdf, @invoice)

pdf.move_down 10

pdf_invoice_data(pdf, @invoice)

pdf.move_down 10

if @invoice.work_items.size > 0
	pdf.table(
		generate_table_data(pdf, @invoice),
		:headers => generate_table_headers(pdf, @invoice),
		:align => generate_table_alignments(pdf, @invoice),
		:align_headers => :center,
		:vertical_padding => 0,
		:column_widths => generate_table_widths(pdf, @invoice),
		:font_size => 10
	)

	pdf.table(
		[ ['Subtotal', "%0.02f" % @invoice.hours, number_to_currency(@invoice.subtotal)] ],
		:column_widths => summary_table_widths(pdf, @invoice),
		:align => summary_table_alignments(pdf, @invoice),
		:vertical_padding => 0,
		:row_colors => [ odd_color ],
		:font_size => 10
	)

	pdf.table(
		[ ['Tax', "%0.02f" % @invoice.taxeable_hours, number_to_currency(@invoice.tax)] ],
		:column_widths => summary_table_widths(pdf, @invoice),
		:align => summary_table_alignments(pdf, @invoice),
		:vertical_padding => 0,
		:row_colors => [ even_color ],
		:font_size => 10
	)

	pdf.table(
		[ ['Total', "%0.02f" % @invoice.hours, number_to_currency(@invoice.total)] ],
		:column_widths => summary_table_widths(pdf, @invoice),
		:align => summary_table_alignments(pdf, @invoice),
		:vertical_padding => 0,
		:row_colors => [ odd_color ],
		:font_size => 10
	)
end

pdf_footer(pdf, @invoice)
