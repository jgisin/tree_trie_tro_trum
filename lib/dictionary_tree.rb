require_relative "./letter_node.rb"
LetterNode = Struct.new(:letter, :definition, :children, :parent, :depth)

class DictionaryTree

  @@TREE_WORD = 0
  @@TREE_LETTER = 0

  attr_reader :root, :depth

  def initialize(dictionary = nil)
    @dictionary = dictionary
    @root = LetterNode.new(nil, nil, [], nil, 0)
    @depth = 0
    @stack = Stack.new
  end

  def num_words
    @@TREE_WORD
  end

  def num_letters
    @@TREE_LETTER
  end

  def insert_word(word, defin)
    @@TREE_WORD += 1
    @@TREE_LETTER = word.length
    if word.length > @depth
      @depth= word.length
    end
    current_node = @root
    word.length.times do |letter|
      current_node.children.each do |child|
        unless current_node.children.include?(child.letter)
          current_node.children << LetterNode.new(word[letter], nil, nil, current_node, current_node.depth + 1 )
          current_node = current_node.children
          @@TREE_LETTER += 1
        else
          current_node = child
        end
      end

    end
    #should store definition on last letter of word
    current_node.definition = defin
  end

  #depth first search for definition of word looking for last letter
  def definition_of(word)
    stack.push(@root)
    until @stack.empty?
      current_node = @stack.pop
      if current_node.letter == word[-1]
        return current_node.definition
      else
        @stack.push(current_node.children)
      end
    end
  end

  #Depth first search for all non overlapping letters. Not enough time to implement
  def remove_word(word)
    @@TREE_WORD -= 1
  end



end

class Stack

  attr_reader :data

  def initialize(data =[])
    @data = data
    @cursor = data.length
  end

  def push(elt)
    @data[@cursor] = elt
    @cursor += 1
  end

  def pop
    if @cursor == 0
      puts "EmptyStack"
      return
    end
    @cursor -= 1
    ret_val = @data[@cursor]
    @data[@cursor] = nil
    ret_val
  end

  def peek
    @data[@cursor-1]

  end

  def empty?
    @cursor == 0 ? true: false
  end

end