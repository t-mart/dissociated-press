class String
  def dissociate
    result_additions = 30

    words = split
    n_words = words.size

    raise RuntimeError if n_words <= 5
    #could possible remove this with smart decrementing of n_words_to_add

    index_map = {}

    words.each_with_index do |w,i|
      if index_map[w]
        index_map[w] << i
      else
        index_map[w] = [i]
      end
    end

    # The number of words we'll add from a contiguous part of the corpus
    # 3 with a 50% chance
    # 2 and 4 with a 20% chance
    # 1 and 5 with a 5% chance
    addition_distribution_hash = { 3 => 0.5, 2 => 0.2, 4 => 0.2, 1 => 0.05, 5 => 0.05 }

    link_word_index = -1 # an invalid initialization value

    result = result_additions.times.inject([]) do |current_result, i|

      n_words_to_add = weighted_choice addition_distribution_hash
      link_word = current_result[-1]

      if link_word == nil || index_map[link_word].size == 1
        #no words to choose from
        # or
        #there's only 1 instance of the word in the corpus
        #so choose a random index
        index = Random.rand(n_words - n_words_to_add)
      else
        index = index_map[link_word].reject { |j| j == link_word_index }.sample + 1
      end

      #our index + n_words_to_add might exceed the total number of words we have.
      #so we take the min here.
      ([n_words_to_add, n_words - index].min).times do |offset|
        current_result << words[index + offset]
        link_word_index = index + offset
      end

      current_result
    end
    result.join ' '
  end
end

# chooses from the keys of weight_hash with probability equal to the respective
# value
# the sum of the values must equal 1
#
# e.g. weighted_choice({ 3 => 0.05, 2 => 0.2, 1 => 0.75 }) will return
#       'cat' with 5% chance
#       'dog' with 20% chance
#       'fish' with 75% chance
def weighted_choice weight_hash
  rand = Random.rand
  weight_hash.inject(0) do |total, kv|
    element, probability = kv
    return element if total + probability >= rand
    total + probability
  end
end

#20.times do
#p weighted_choice({"e"=>0.7, "a"=>0.15, "b"=>0.1, "c"=>0.05})
#end
corpus = <<EOS
3 May. Bistritz.--Left Munich at 8:35 P.M., on 1st May, arriving at Vienna early next morning; should have arrived at 6:46, but train was an hour late. Buda-Pesth seems a wonderful place, from the glimpse which I got of it from the train and the little I could walk through the streets. I feared to go very far from the station, as we had arrived late and would start as near the correct time as possible.

The impression I had was that we were leaving the West and entering the East; the most western of splendid bridges over the Danube, which is here of noble width and depth, took us among the traditions of Turkish rule.

We left in pretty good time, and came after nightfall to Klausenburgh. Here I stopped for the night at the Hotel Royale. I had for dinner, or rather supper, a chicken done up some way with red pepper, which was very good but thirsty. (Mem. get recipe for Mina.) I asked the waiter, and he said it was called "paprika hendl," and that, as it was a national dish, I should be able to get it anywhere along the Carpathians.

I found my smattering of German very useful here, indeed, I don't know how I should be able to get on without it.

Having had some time at my disposal when in London, I had visited the British Museum, and made search among the books and maps in the library regarding Transylvania; it had struck me that some foreknowledge of the country could hardly fail to have some importance in dealing with a nobleman of that country.

I find that the district he named is in the extreme east of the country, just on the borders of three states, Transylvania, Moldavia, and Bukovina, in the midst of the Carpathian mountains; one of the wildest and least known portions of Europe.

I was not able to light on any map or work giving the exact locality of the Castle Dracula, as there are no maps of this country as yet to compare with our own Ordnance Survey Maps; but I found that Bistritz, the post town named by Count Dracula, is a fairly well-known place. I shall enter here some of my notes, as they may refresh my memory when I talk over my travels with Mina.

In the population of Transylvania there are four distinct nationalities: Saxons in the South, and mixed with them the Wallachs, who are the descendants of the Dacians; Magyars in the West, and Szekelys in the East and North. I am going among the latter, who claim to be descended from Attila and the Huns. This may be so, for when the Magyars conquered the country in the eleventh century they found the Huns settled in it.

I read that every known superstition in the world is gathered into the horseshoe of the Carpathians, as if it were the centre of some sort of imaginative whirlpool; if so my stay may be very interesting. (Mem., I must ask the Count all about them.)

I did not sleep well, though my bed was comfortable enough, for I had all sorts of queer dreams. There was a dog howling all night under my window, which may have had something to do with it; or it may have been the paprika, for I had to drink up all the water in my carafe, and was still thirsty. Towards morning I slept and was wakened by the continuous knocking at my door, so I guess I must have been sleeping soundly then.

I had for breakfast more paprika, and a sort of porridge of maize flour which they said was "mamaliga", and egg-plant stuffed with forcemeat, a very excellent dish, which they call "impletata". (Mem., get recipe for this also.) 
EOS

p corpus.dissociate
