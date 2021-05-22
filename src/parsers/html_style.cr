module Mint
  class Parser
    syntax_error HtmlStyleExpectedClosingParentheses

    def html_style : Ast::HtmlStyle?
      start do |start_position|
        name = start do
          skip unless keyword "::"
          skip unless value = variable_with_dashes track: false
          value
        end

        skip unless name

        arguments = [] of Ast::Node

        if char! '('
          whitespace

          arguments = list(terminator: ')', separator: ',') { expression }

          whitespace
          char ')', HtmlStyleExpectedClosingParentheses
        end

        Ast::HtmlStyle.new(
          arguments: arguments,
          from: start_position,
          to: position,
          input: data,
          name: name)
      end
    end
  end
end
