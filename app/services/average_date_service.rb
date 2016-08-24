class AverageDateService
  def initialize(options = {})
    @album = options[:album]
    @media = options[:media]
  end

  def calculate_average_date
    @album.average_date = average_date(@media)
    @album.save!
  end

  private

  def average_date(media)
    average_date = 0.0
    unless media.blank?
      media.each do |m|
        average_date = average_date + m.taken_at.to_f if m.taken_at
      end
      average_date = average_date / media.size
      average_date = Time.at(average_date).to_date
    else
      average_date = nil
    end
    return average_date
  end
end
