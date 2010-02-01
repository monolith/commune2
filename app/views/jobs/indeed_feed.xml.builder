# this feed is picked up by indeed.com
# http://www.indeed.com/intl/en/xmlinfo.html

xml.instruct!

xml.source do

  xml.publisher "Commune2 Job Board"
  xml.publisherurl "http://www.commune2.com"

  @jobs.each do |job|
    xml.job do
      xml.title { xml.cdata! job.title }
      xml.description { xml.cdata! "Compensation type: #{job.compensation_type}\nGeneral skills: #{job.general_skills_string}#{"\nRelevant industries: " + job.project.industries_string if job.project }\n\n#{job.description}" }
      xml.date { xml.cdata! job.created_at.strftime("%a, %d %b %Y %H:%M:%S GMT") }
      xml.referencenumber { xml.cdata! job.id.to_s }
      xml.country { xml.cdata! job.user.locations.first.country_name }
      xml.url { xml.cdata! job_public_preview_url(job) }
    end
  end
end

