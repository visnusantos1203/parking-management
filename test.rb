require "thor"
require "pstore"
require 'csv'
require_relative 'create_slots'
require_relative 'get_slots'

class ParkingManagement < Thor

  desc "create_parking_lot SLOT", "creates new parking lot"
  def create_parking_lot(slots)
    PStore.new("/tmp/parking.txt").transaction do |slot|
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
    PStore.new("/tmp/parking.txt").transaction { |parking| parking.delete(:last_file) }
    puts "successfuly deleted slot number"
  end

  desc "park PLATE_NUM COLOR", "allocates slot to customer"
  def park(plate_num, color)
    PStore.new("/tmp/parking.txt").transaction do |parking|
      parking.roots.each_with_index do |park, index| # I had to do this because I created a first record with wrong format
        unless index == 0 # and I temporarily created this to skip the first record
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
    #puts "Allocated slot number 1. Plate number: #{plate_num}, color: #{color}"
  end

  desc "leave SLOT_NUM", "empties parking slot"
  def leave(slot_num)
    puts "Slot number #{slot_num} is free"
  end

  desc "status", "lists current status of slots"
  def status
    PStore.new("/tmp/parking.txt").transaction do |parking|
      parking.roots.each_with_index {|slot, index| puts "#{index + 1}. Parking #{slot}"}
      puts "No data available" if parking.roots.empty?
      # GetSlots.status(parking.roots)
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