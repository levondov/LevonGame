--[[
###############################################################################
# Copyright (c) 2012, Floor Terra <floort@gmail.com>
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
###############################################################################
]]

M = {}

-- Seed the PRNG
math.randomseed(os.time())

--[[    Define the function that takes a table with weights and returns
        a number with a chance proportional to that weight.
        Example:
            weigted_choice({1, 2, 7})
        Returns:
            1: ~10% of the time
            2: ~20% of the time
            3: ~70% of the time
  ]]
function M.weighted_choice(w)
    cumulative_weights = {}
    total = 0
    for i=1, #w do
        cumulative_weights[i] = total + w[i]
        total = total + w[i]
    end
    rnd = math.random()*total
    for i=1, #w do
        if rnd < cumulative_weights[i] then
            return i
        end
    end
    return #w
end

return M