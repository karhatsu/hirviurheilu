class FeedbackMailerPreview < ActionMailer::Preview
  def feedback_mail
    FeedbackMailer.feedback_mail('This is my feedback', 'Sender name', 'test@test.com',
                                 '+358 50 12323131', User.last)
  end

  def race_feedback_mail
    FeedbackMailer.race_feedback_mail(Race.last, 'This is my feedback', 'Sender name', 'test@test.com',
                                      '+358 50 12323131', User.last)
  end

  def offer_mail
    FeedbackMailer.offer_mail('Timo Testaaja', 'timo@testi.com', '045 3333 444',
                              '10 kilpailua, jokaisessa 50 kilpailijaa', nil)
  end
end