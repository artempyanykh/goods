require "spec_helper"

describe Goods::Util::CategoriesGraph do
  let(:klass) { Goods::Util::CategoriesGraph }

  describe "#initialize" do
    it "should create empty graph if nothing passed" do
      graph = klass.new
      expect(graph.vertex_count).to eql(0)
      expect(graph.edge_count).to eql(0)
    end

    it "should create graph with vertice for each category" do
      graph = klass.new([
        { id: 1, name: "First" },
        { id: 2, name: "Second" }
      ])
      expect(graph.vertex_count).to eql(2)
      expect(graph.edge_count).to eql(0)
    end

    it "should create edge between parent and child category" do
      normal_categories = [
        { id: 1, name: "First" },
        { id: 2, name: "Second", parent_id: 1 }
      ]
      reversed_categories = normal_categories.reverse

      [normal_categories, reversed_categories].each do |categories|
        graph = klass.new(categories)
        expect(graph.vertex_count).to eql(2)
        expect(graph.edge_count).to eql(1)
        expect(graph.adjacent_categories?(1, 2)).to eql(true)
      end
    end

    it "should not duplicate categories" do
      graph = klass.new([
        { id: 1, name: "Name" },
        { id: 1, name: "Name" }
      ])

      expect(graph.vertex_count).to eql(1)
    end
  end

  describe "#topsorted" do

    context "with single strongly connected component" do
      let(:simple_description) {
        [
          { id: 1, name: "First" },
          { id: 2, name: "Second", parent_id: 1 }
        ]
      }

      it "if already topsorted should return the same" do
        graph = klass.new(simple_description)
        topsorted = graph.topsorted
        expect(topsorted).to eql(simple_description)
      end

      it "if not topsorted should topsort" do
        graph = klass.new(simple_description.reverse)
        topsorted = graph.topsorted
        expect(topsorted).to eql(simple_description)
      end
    end

    context "with multiple strongly connected component" do
      let(:complex_description) {
        [
          {id: 1, name: 'C0L0N0', level: 0, component: 1},
          {id: 2, name: 'C0L1N0', parent_id: 1, level: 1, component: 1},
          {id: 3, name: 'C0L1N1', parent_id: 1, level: 1, component: 1},
          {id: 4, name: 'C0L1N2', parent_id: 1, level: 1, component: 1},
          {id: 5, name: 'C0L2N0', parent_id: 2, level: 2, component: 1},
          {id: 6, name: 'C0L3N0', parent_id: 5, level: 2, component: 1},

          {id: 7, name: 'C1L0N0', level: 0, component: 2},
          {id: 8, name: 'C1L1N0', parent_id: 7, level: 1, component: 2},
          {id: 9, name: 'C1L1N1', parent_id: 7, level: 1, component: 2},
        ]
      }

      it "if not topsorted should topsort" do
        graph = klass.new(complex_description.reverse)
        topsorted = graph.topsorted
        topsorted.each_with_index do |cat, idx|
          if cat[:parent_id]
            expect(
              topsorted[0, idx].find { |el| el[:id] == cat[:parent_id]}
            ).not_to be_nil
          end
        end
      end
    end

  end
end
