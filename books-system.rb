class Book
  attr_accessor :title, :author, :isbn, :count

  def initialize(title, author, isbn, count = 1)
    @title = title
    @author = author
    @isbn = isbn
    @count = count
  end

  def to_file_format
    "#{title}|#{author}|#{isbn}|#{count}"
  end
end

class Inventory
  FILE_NAME = "books.txt"

  def initialize
    @books = []
    load_books
  end

  def load_books
    return unless File.exist?(FILE_NAME)

    File.readlines(FILE_NAME).each do |line|
      title, author, isbn, count = line.chomp.split("|")

      @books << Book.new(
        title,
        author,
        isbn,
        count.to_i
      )
    end
  end

  def save_books
    File.open(FILE_NAME, "w") do |file|
      @books.each do |book|
        file.puts(book.to_file_format)
      end
    end
  end


  def valid_input?(*values)
    values.all? do |value|
      !value.nil? && !value.strip.empty?
    end
  end

  def add_book(title, author, isbn)
    unless valid_input?(title, author, isbn)
      puts "\nInvalid input."
      return
    end

    existing_book = @books.find do |book|
      book.isbn == isbn
    end

    if existing_book
      existing_book.count += 1
      existing_book.title = title
      existing_book.author = author

      puts "\nBook already exists."
      puts "Count increased to #{existing_book.count}"
    else
      @books << Book.new(title, author, isbn)

      puts "\nBook added successfully."
    end

    save_books
  end

  def remove_book(isbn)
    unless valid_input?(isbn)
      puts "\nInvalid ISBN."
      return
    end

    removed = @books.reject! do |book|
      book.isbn == isbn
    end

    if removed
      save_books
      puts "\nBook removed."
    else
      puts "\nBook not found."
    end
  end

  def list_books
    if @books.empty?
      puts "\nNo books found."
      return
    end

    puts "\nBooks List"

    @books.each do |book|
      puts "-" * 40
      puts "Title : #{book.title}"
      puts "Author: #{book.author}"
      puts "ISBN  : #{book.isbn}"
      puts "Count : #{book.count}"
    end

    puts "-" * 40
  end

  def sort_books_by_isbn
    @books.sort_by!(&:isbn)

    puts "\nBooks sorted successfully."
  end

  def search_by_isbn(isbn)
    result = @books.find do |book|
      book.isbn == isbn
    end

    display_result(result)
  end

  def search_by_title(title)
    results = @books.select do |book|
      book.title.downcase.include?(title.downcase)
    end

    display_results(results)
  end

  def search_by_author(author)
    results = @books.select do |book|
      book.author.downcase.include?(author.downcase)
    end

    display_results(results)
  end

  def display_result(book)
    if book.nil?
      puts "\nBook not found."
      return
    end

    puts "\nBook Found"
    puts "-" * 40
    puts "Title : #{book.title}"
    puts "Author: #{book.author}"
    puts "ISBN  : #{book.isbn}"
    puts "Count : #{book.count}"
  end

  def display_results(results)
    if results.empty?
      puts "\nNo matching books found."
      return
    end

    results.each do |book|
      puts "-" * 40
      puts "Title : #{book.title}"
      puts "Author: #{book.author}"
      puts "ISBN  : #{book.isbn}"
      puts "Count : #{book.count}"
    end
  end
end


inventory = Inventory.new

loop do
  puts
  puts "=" * 50
  puts "Book Management System"
  puts "=" * 50

  puts "1. List Books"
  puts "2. Add Book"
  puts "3. Remove Book"
  puts "4. Search By ISBN"
  puts "5. Search By Title"
  puts "6. Search By Author"
  puts "7. Sort Books By ISBN"
  puts "8. Exit"

  print "\nChoose option: "

  choice = gets.chomp

  case choice
  when "1"
    inventory.list_books

  when "2"
    print "Title: "
    title = gets.chomp

    print "Author: "
    author = gets.chomp

    print "ISBN: "
    isbn = gets.chomp

    inventory.add_book(title, author, isbn)

  when "3"
    print "Enter ISBN: "
    isbn = gets.chomp

    inventory.remove_book(isbn)

  when "4"
    print "Enter ISBN: "
    isbn = gets.chomp

    inventory.search_by_isbn(isbn)

  when "5"
    print "Enter Title: "
    title = gets.chomp

    inventory.search_by_title(title)

  when "6"
    print "Enter Author: "
    author = gets.chomp

    inventory.search_by_author(author)

  when "7"
    inventory.sort_books_by_isbn

  when "8"
    puts "\nGoodbye."
    break

  else
    puts "\nInvalid option."
  end
end