module Dmt
	module DmtDisplayHelper

		def accent(word)
			'<div class="accent">' + word.to_s + '</div>'
		end

		def accent_first(word)
			letter = word[0, 1]
			rest = word[1, word.length]
			accent(letter) + rest
		end

		def safe(args = Array.new)
			if args.size == 0
				return
			end
			obj = nil
			counter = 0
			args.each do |a|
				if !a.nil?
					if obj
						obj = obj.send a
					else
						if counter == 0
							obj = a
						else
							return nil
						end
					end
				else
					return obj
				end
				counter += 1
			end
			return obj
		end

		def h_safe(args = Array.new)
			return h(safe(args))
		end
		
		def ne(arg)
			if arg.blank? or arg.nil?
				'&nbsp;'
			else
				arg
			end
		end

		def h_ne(arg)
			if arg.blank? or arg.nil?
				'&nbsp;'
			else
				h(arg)
			end
		end

	end
end
