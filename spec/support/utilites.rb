module Features
  module UtilityHelpers
    def t(key, options = {})
      I18n.t(key, options)
    end
  end
end
