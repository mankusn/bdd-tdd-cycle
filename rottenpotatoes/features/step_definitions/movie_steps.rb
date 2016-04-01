Given /the following movies exist:/ do |movie|
  movie.hashes.each do |mov|
    Movie.create!(mov)
  end 
end

Then /I should see "(.*)" before "(.*)"/ do |arg1, arg2|
  assert page.body =~ /#{arg1}.*#{arg2}/m, "#{arg1} was not before #{arg2}"
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating|
  rating.split(',').each do |rate|
    if uncheck
      uncheck "ratings_#{rating}"
    else
      check "ratings_#{rating}"
    end
  end
end

Then /I should not see any movies/ do
  movies = Movie.all
  movies.each do |movie|
    assert true unless page.body =~ /#{movie.title}/m
  end
end

Then /I should see all of the movies/ do
  movies = Movie.all
  
  if movies.size == 15
    movies.each do |movie|
      assert page.body =~ /#{movie.title}/m, "#{movie.title} did not appear"
    end
  else
    false
  end
end

Then /^the director of "(.*?)" should be "(.*?)"$/ do |mov_title, new_dir|
  movie = Movie.find_by_title mov_title
  movie.director.should == new_dir
end

