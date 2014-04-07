module Goods
  module Util
    class CategoriesGraph
      attr_reader :vertex_count, :edge_count

      def initialize(categories=[])
        reset
        add_categories(categories)
      end

      def adjacent_categories?(cid1, cid2)
        vertexes = [
          vertex_for_category(cid1),
          vertex_for_category(cid2)
        ]
        adjacent?(*vertexes)
      end

      def topsorted
        sorted = []
        on_processed = ->(vertex_num) { sorted.unshift(vertex_num) }
        dfs(nil, on_processed)
        sorted.map { |v| category_for_vertex(v) }
      end

      private

      # Make empty graph
      def reset
        @vertex_count = 0
        @edge_count = 0
        @adjacency_list = []
        @vertex_to_category = []
        @category_to_vertex = {}
      end

      def add_categories(categories)
        categories.each { |c| init_category(c) }
        categories.each { |c| link_category(c) }
      end

      def init_category(category)
        return if vertex_for_category(category[:id])

        add_vertex do |vertex_num|
          set_mapping vertex_num, category
        end
      end

      def link_category(category)
        if category[:parent_id]
          edge = [
            vertex_for_category(category[:parent_id]),
            vertex_for_category(category[:id])
          ]

          add_edge(*edge)
        end
      end

      def add_vertex
        @adjacency_list.push([])
        yield @vertex_count if block_given?
        @vertex_count += 1
      end

      def add_edge(v_start, v_end)
        if v_start && v_end
          @adjacency_list[v_start].push(v_end)
          @edge_count += 1
        end
      end

      def adjacent?(v1, v2)
        @adjacency_list[v1].include?(v2)
      end

      def adjacent_for(vertex)
        @adjacency_list[vertex]
      end

      def vertex_for_category(category_id)
        @category_to_vertex[category_id]
      end

      def category_for_vertex(vertex_num)
        @vertex_to_category[vertex_num]
      end

      def set_mapping(vertex_num, category)
        @vertex_to_category[vertex_num] = category
        @category_to_vertex[category[:id]] = vertex_num
      end

      def dfs(on_discovered, on_processed)
        states = vertex_count.times.map { :undiscovered }

        vertex_count.times.each do |vertex|
          if states[vertex] == :undiscovered
            dfs_internal(vertex, states, on_discovered, on_processed)
          end
        end
      end

      def dfs_internal(vertex, states, on_discovered, on_processed)
        states[vertex] = :discovered
        on_discovered.call(vertex) if on_discovered

        adjacent_for(vertex).each do |adjacent|
          if states[adjacent] == :undiscovered
            dfs_internal(adjacent, states, on_discovered, on_processed)
          end
        end

        states[vertex] = :processed
        on_processed.call(vertex) if on_processed
      end
    end
  end
end
