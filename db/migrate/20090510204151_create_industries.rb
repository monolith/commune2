class CreateIndustries < ActiveRecord::Migration
  def self.up
    create_table :industries do |t|
      t.column :name, :string, :limit => 100, :null => false
      t.timestamps
    end
    
    industries = ['Academia',
                  'Accounting',
                  'Advertising, Public Relations',
                  'Aerospace, Aviation',
                  'Architecture, Design, or Planning',
                  'Arts/Entertainment/Publishing',
                  'Automotive',
                  'Banking',
                  'Biology, Life Sciences',
                  'Broadcasting, Media productions',
                  'Business Development',
                  'Career services',
                  'Clerical, Administrative',
                  'Computers and Programming',
                  'Construction, Facilities',
                  'Consumer Goods',
                  'Customer Service',
                  'Education, Training',
                  'Energy, Utilities',
                  'Engineering',
                  'Environmental Science, Natural Resources',
                  'Government, Politics, and Public Policy',
                  'Hospitality, Travel',
                  'Human Resources',
                  'Installation, Maintenance',
                  'Insurance',
                  'Internet',
                  'Law Enforcement, Security',
                  'Legal',
                  'Library and Information Sciences',
                  'Making the World a Better Place',
                  'Management, Executive',
                  'Manufacturing, Operations',
                  'Marketing',
                  'Mathematics, Statistics',
                  'Medicine, Healthcare',
                  'Military',
                  'Non-Profit, Volunteering',
                  'Pharmaceutical, Biotech',
                  'Physical Sciences',
                  'Professional Services',
                  'Publishing, Journalism',
                  'Quality Control',
                  'Real Estate',
                  'Religion',
                  'Restaurant, Food Service',
                  'Retail',
                  'Sales',
                  'Science, Research',
                  'Skilled Labor',
                  'Social Science or Services',
                  'Sports, Recreation',
                  'Technology',
                  'Telecommunications',
                  'Transportation, Logistics',
                  'Veterinary Services',
                ]
                
    
    industries.each do |industry|
      Industry.create :name => industry
    end
          
  end

  def self.down
    drop_table :industries
  end
end
