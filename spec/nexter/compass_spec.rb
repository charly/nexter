require "spec_helper"

describe Nexter::Compass, focus: true do

  describe "#arrwo or #bracket" do
    context "when looking for *next*" do
      let(:compass) {Nexter::Compass.new(:next)}

      it "returns > when direction's *asc*" do
        compass.direction= "asc"
        expect(compass.bracket).to eq(">")
      end

      it "returns < when direction's *desc*" do
        compass.direction= "desc"
        expect(compass.bracket).to eq("<")
      end
    end

    context "when looking for *previous*" do
      let(:compass) {Nexter::Compass.new(:previous)}

      it "returns < when direction's *asc*" do
        compass.direction= "asc"
        expect(compass.bracket).to eq("<")
      end

      it "returns > when direction's *desc*" do
        compass.direction= "desc"
        expect(compass.bracket).to eq(">")
      end
    end
  end # desc
end