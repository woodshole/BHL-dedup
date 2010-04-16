require 'progressbar' # sudo gem install progressbar

namespace :reformat do
  desc "Pulls all books from db and calls format_cells on them"
  task :books => :environment do
    puts "Pulling all books from database..."
    all_books = Book.find(:all)
    
    progress = ProgressBar.new('formatting', all_books.length)
    
    all_books.each do |b|
      progress.inc
      b.instance_eval <<-ENDEVAL
        def public_format_cells
          format_cells  # format_cells is a private method. This is a public accessor
        end
      ENDEVAL
      
      b.title = b.title + ' '  # I have to do this to get the b.save call to work. I don't know why. SQL caching perhaps?
      b.public_format_cells
      b.save!
    end
    
    progress.finish
    
  end
end