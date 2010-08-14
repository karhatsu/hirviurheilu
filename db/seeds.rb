run = Sport.create!(:name => "Hirvenjuoksu", :key => "RUN")
ski = Sport.create!(:name => "Hirvenhiihto", :key => "SKI")

contest1 = run.contests.build(:name => "P-Savon hirvenjuoksukisat",
  :location => "Tervo", :start_date => '2010-08-14')
contest1.save!
contest2 = ski.contests.build(:name => "P-Savon hirvenhiihtokisat",
  :location => "Karttula", :start_date => '2010-12-13')
contest2.save!
