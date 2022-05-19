require "thor"
require "pstore"
class ParkingManagement < Thor

  desc "create_parking_lot SLOT", "creates new parking lot"
  def create_parking_lot(slots)
    PStore.new("/tmp/parking.txt").transaction { |slot| slot[slots] = true}
    puts "Successfuly created parking with #{slots} slots"
  end

  desc "park PLATE_NUM COLOR", "allocates slot to customer"
  def park(plate_num, color)
    puts "Allocated slot number 1. Plate number: #{plate_num}, color: #{color}"
  end

  desc "leave SLOT_NUM", "empties parking slot"
  def leave(slot_num)
    puts "Slot number #{slot_num} is free"
  end

  desc "status", "lists current status of slots"
  def status
    PStore.new("/tmp/parking.txt").transaction do |parking|
      parking.roots.each_with_index {|slot, index| puts "#{index + 1}. Parking #{slot}"}
    end
    #puts "Kailangan pa tong ayusin"
  end

  desc "plate_numbers_for_cars_with_colour COLOR", "lists plate numbers of cars that matches the color provided"
  def plate_numbers_for_cars_with_colour(color)
    puts "Dito naka list yung plate numbers na kulay #{color}"
  end

  desc "slot_numbers_for_cars_with_colour COLOR", "lists slot numbers of cars that matches the color provided"
  def plate_numbers_for_cars_with_colour(color)
    puts "Dito naka list yung slot numbers na kulay #{color}"
  end

  desc "slot_number_for_registration_number PLATE_NUM", "Shows the slot num of the given plate number"
  def slot_number_for_registration_number(plate_num)
    puts "Slot number 6"
  end

end

ParkingManagement.start(ARGV)