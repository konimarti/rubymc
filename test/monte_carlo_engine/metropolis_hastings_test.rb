require "test_helper"
require "rubystats"

class MetropolisHastingsTest < Minitest::Test
  def test_expected_value
  
    #create monte carlo engine for sampling  
    engine = Rubymc::MonteCarloEngine::MetropolisHastings.new(
      f: Rubystats::GammaDistribution.new(6.0,0.5),
      g: Rubystats::LognormalDistribution.new(1.1,0.5),
      start: 3.0
    )
    
    #run monte carlo simulation for P(Y > 3) with Y ~ N(0,1)
    experiment = Rubymc::MonteCarloSimulation::Simulation.new do
      burn_in 10000
      iterations 100000
      # sample { x=engine.sample; (x>0.0)?x:0.000001 }
      sample { engine.sample }
    end
    
    #perform analysis on markov chain
    m = Rubymc::MonteCarloSimulation.extract_measurements(experiment.run)            
    
    assert_in_delta 3.0, m[0].mean, 0.1   
  end
end
