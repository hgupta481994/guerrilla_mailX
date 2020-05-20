class ArgumentRequiredError < StandardError
	def message(arg)
	  "Argument '#{arg}' is missing"
	end
end
