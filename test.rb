require "thor"
require "pstore"

class ParkingManagement < Thor

  desc "create_parking_lot SLOT", "creates new parking lot"
  def create_parking_lot(slots)
    PStore.new("/tmp/parking-lot.txt").transaction do |slot|
      data = []
      slots.to_i.times do |count|
        data << { slot_num: (count + 1), plate_num: "",  color: "", available: true }
      end
      slot[data] = true
    end
    puts "Successfuly created parking with #{slots} slots"
  end

  desc "delete_parking_lot", "deletes slot"
  def delete_parking_lot
    PStore.new("/tmp/parking-lot.txt").transaction { |parking| parking.delete(:last_file) }
    puts "successfuly deleted slot number"
  end

  desc "park PLATE_NUM COLOR", "allocates slot to customer"
  def park(plate_num, color)
    PStore.new("/tmp/parking-lot.txt").transaction do |parking|
      parking.roots.each_with_index do |park, index|
        available_slot = park.find { |slot| slot[:available] == true }
        if available_slot.nil?
          puts "Sorry, parking lot is full"
        else
          available_slot[:plate_num] = plate_num
          available_slot[:color] = color
          available_slot[:available] = false

          puts "Allocated slot number #{available_slot[:slot_num]}. Plate number: #{plate_num}, color: #{color}"

        end
      end
    end
  end

  desc "leave SLOT_NUM", "empties parking slot"
  def leave(slot_num)
    PStore.new("/tmp/parking-lot.txt").transaction do |parking|
    parking.roots.each_with_index do |park, index|
        leaving_slot = park.find { |slot| slot[:slot_num] == slot_num.to_i && slot[:available] == false}
        if leaving_slot.nil?
          puts "Slot number is either non-existent or unoccupied"
        else
          leaving_slot[:plate_num] = ""
          leaving_slot[:color] = ""
          leaving_slot[:available] = true

          puts "Slot number #{slot_num} is free"

        end
    end
    end
  end

  desc "status", "lists current status of slots"
  def status
    PStore.new("/tmp/parking-lot.txt").transaction do |parking|
      parking.roots.each_with_index {|slot, index| puts "#{index + 1}. Parking #{slot}"}
      puts "No data available" if parking.roots.empty?
    end
  end

  desc "plate_numbers_for_cars_with_colour COLOR", "lists plate numbers of cars that matches the color provided"
  def plate_numbers_for_cars_with_colour(color)
    result = []
    PStore.new("/tmp/parking-lot.txt").transaction do |parking|
      parking.roots.each_with_index do |park, index|
        color_matched = park.select { |slot| slot[:color].downcase == color.downcase }
        if color_matched.nil?
          puts "No car with #{color} color found"
        else
          color_matched.each { |car| result << car[:plate_num] }
          puts result
        end
      end
    end
  end

  desc "slot_numbers_for_cars_with_colour COLOR", "lists slot numbers of cars that matches the color provided"
  def slot_numbers_for_cars_with_colour(color)
    result = []
    PStore.new("/tmp/parking-lot.txt").transaction do |parking|
      parking.roots.each_with_index do |park, index|
        color_matched = park.select { |slot| slot[:color].downcase == color.downcase }
        if color_matched.nil?
          puts "No slot with #{color} color car found"
        else
          color_matched.each { |car| result << car[:slot_num] }
          puts result
        end
      end
    end
  end

  desc "slot_number_for_registration_number PLATE_NUM", "Shows the slot num of the given plate number"
  def slot_number_for_registration_number(plate_num)
   PStore.new("/tmp/parking-lot.txt").transaction do |parking|
      parking.roots.each_with_index do |park, index|
        slot_parked = park.find { |slot| slot[:plate_num] == plate_num.upcase }
        if slot_parked.nil?
          puts "No car with plate number: #{plate_num} found"
        else
          puts "Car with plate number: #{plate_num} is in slot #{slot_parked[:slot_num]}"
        end
      end
    end
  end

end

ParkingManagement.start(ARGV)