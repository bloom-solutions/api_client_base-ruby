require 'spec_helper'

module APIClientBase
  RSpec.describe Validate do

    context "a schema exists" do
      before do
        class ValidateTestWithSchemaRequest
          include APIClientBase::Request.module
        end

        ValidateTestWithSchemaRequestSchema = Dry::Validation.Schema do
          required(:name).filled
        end
      end

      it "validates the given attributes against the class' schema" do
        expect { described_class.(ValidateTestWithSchemaRequest, name: nil) }.
          to raise_error(ArgumentError, {name: ["must be filled"]}.to_json)
      end
    end

    context "a schema does not exist" do
      before do
        class ValidateTestWithoutSchemaRequest
          include APIClientBase::Request.module
        end
      end

      it "does nothing" do
        expect { described_class.(ValidateTestWithoutSchemaRequest, name: nil) }.
          to_not raise_error
      end
    end

  end
end
