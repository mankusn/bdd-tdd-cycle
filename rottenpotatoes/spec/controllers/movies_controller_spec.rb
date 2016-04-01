require 'spec_helper'

describe Movie do
  
  before :each do
    @movies = Movie.new :title=>'Title', :rating=>'rating', :director=> 'director'
  end
  
  describe '#new' do
    it 'calls the default new method' do
      @movies.should_be_an_instance_of Movie 
    end
  end
end
