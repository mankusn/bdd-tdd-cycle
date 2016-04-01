require 'spec_helper'

describe MoviesController do
  
  describe 'getting same director' do
    before :each do
      @movie=double(Movie, :title => 'Title', :director => 'director', :id => '1')
      Movie.stub(:find).with('1').and_return(@movie)
    end
    
    it 'should route to same_director' do
      { :get => same_director_path(1) }.
      should route_to(:controller => 'movies', :action => 'same_director', :id => '1')
    end
    
    it 'should find movies with the same director' do
      results = [double('Movie'), double('Movie')]
      Movie.should_receive(:find_all_by_director).with('director').and_return(results)
      get :same_director, :id => '1'
    end
    
    it 'should select the same director template for rendering and make results available' do
      Movie.stub(:find_all_by_director).with('director').and_return(@movie)
      get :same_director, :id => '1'
      response.should render_template('same_director')
      assigns(:movies).should == @movie
    end
  end 
  describe 'add director' do
    before :each do
      @movie=double(Movie, :title => 'Title', :director => 'director', :id => '1')
      Movie.stub(:find).with('1').and_return(@movie)
    end
    it 'should call update_attributes and redirect' do
      @movie.stub(:update_attributes!).and_return(true)
      put :update, {:id => '1', :movie => @movie}
      response.should redirect_to(movie_path(@movie))
    end
  end
  
  describe 'edit' do
    it 'should get movie' do
      Movie.should_receive(:find).with('1').and_return(@movie)
      post :edit, {:id=>'1'}
    end 
  end
  
  describe 'show' do
    it 'should call find' do
      Movie.should_receive(:find).with('1')
      get :show, {:id => '1' } 
     
    end
    
  end
  describe 'index' do
    it 'should sort session by title' do
      get :index, nil, {:sort => 'title'}
      @request.session['sort'].should == 'title'
     
    end
    it 'should sort session by release_date' do
      get :index, nil, {:sort => 'release_date'}
      @request.session['sort'].should == 'release_date'
     
    end
    it 'should select ratings from params[:ratings] to session[:ratings]' do
      get :index, {:ratings=>'PG, R'}, {:ratings=>nil}
      @request.session['ratings'].should =='PG, R'
    end
    
    it 'should call find_all_by_ratings' do
      Movie.should_receive(:find_all_by_rating)
      get :index
    end
    
  end
  
  describe 'failing to get same director' do
    before :each do
      @movie = double(Movie, :title => 'Title', :director => nil, :id => '1')
      Movie.stub(:find).with('1').and_return(@movie)
    end
    
    it 'should generate routing for Same Director' do
      { :get => same_director_path(1) }.
      should route_to(:controller => 'movies', :action => 'same_director', :id => '1')
    end
    it 'should select the Index template for rendering and generate a flash' do
      get :same_director, :id => '1'
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_empty
    end
  end
  
  describe 'create' do
    it 'should create a new movie' do
      MoviesController.stub(:create).and_return(double('Movie'))
      post :create, {:id => '1'}
    end
  end
  
  describe 'destroy' do
    it 'should destroy a movie' do
      movie = double(Movie, :id => '10', :title => 'blah', :director => nil)
      Movie.stub(:find).with('10').and_return(movie)
      movie.should_receive(:destroy)
      delete :destroy, {:id => '10'}
    end
  end
end
