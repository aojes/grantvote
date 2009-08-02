Factory.define :blitz do |b|
  b.name "blitz grant"
  b.proposal "blitz grant proposal"
  b.media '<object width="425" height="344"><param name="movie" value="http:' +
          '//www.youtube.com/v/9QtR0D-VK-M&hl=en&fs=1&"></param><param name=' + 
          '"allowFullScreen" value="true"></param><param name="allowscriptac' +
          'cess" value="always"></param><embed src="http://www.youtube.com/v' +
          '/9QtR0D-VK-M&hl=en&fs=1&" type="application/x-shockwave-flash" al' +
          'lowscriptaccess="always" allowfullscreen="true" width="425" heigh' +
          't="344"></embed></object>'
  b.amount 10
  
  b.association :blitz_fund
end

Factory.define :invalid_blitz do |b|
end
