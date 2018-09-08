# frozen_string_literal: true

RSpec::Matchers.define :match_email_format do
  match { |obj| obj.to_s =~ URI::MailTo::EMAIL_REGEXP }

  failure_message { |obj| "expected that #{obj} would match e-mail format" }

  description { 'match e-mail address format' }
end
