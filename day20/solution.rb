inputfile = "input.txt"

nums = File.foreach(inputfile).map { |line| line.strip.to_i }

def mix(list, element, delta)
  return if delta == 0
  startIdx = list.index(element)
  newIdx = startIdx
  
  while delta.abs > list.size
    laps, remainder = delta.divmod(list.size)
    delta = laps + remainder
  end

  if delta < 0
    delta.abs.times do
      newIdx = list.size-1 if newIdx == 0
      newIdx -= 1
      newIdx = list.size-1 if newIdx == 0
    end
  else
    delta.times do
      newIdx = 0 if newIdx == list.size-1
      newIdx += 1
      newIdx = 0 if newIdx == list.size-1
    end
  end
  list.delete_at(startIdx)
  list.insert(newIdx, element)
end

def decrypt(input, mixes, key)
  nums = input.map { |n| n * key }
  shuff = (0...nums.size).to_a
  mixes.times do
    (0...shuff.size).each do |idx|
      mix(shuff, idx, nums[idx])
    end
  end

  zero_idx = shuff.index(nums.index(0))
  [1000, 2000, 3000].map do |offset|
    nums[shuff[(zero_idx + offset) % shuff.size]]
  end
end

# Part 1
vals = decrypt(nums, 1, 1)
p vals
puts vals.sum

# Part 2
decryption_key = 811589153
dec_vals = decrypt(nums, 10, decryption_key)
p dec_vals
puts dec_vals.sum