(import ../src/bencode :as ben)

(comment

  (ben/read-buffer (string "d"
                           "2:" "id"
                           "1:" "1"
                           "2:" "op"
                           "5:" "clone"
                           "e"))
  # =>
  {:id "1" :op "clone"}

  (ben/read-buffer (string "d"
                           "2:id"
                           "1:1"
                           "11:new-session"
                           "36:4ca0256c-606f-47ec-9534-06eeaa3227f0"
                           "7:session"
                           "36:fabb7627-45d3-46a8-8804-7a8cd3fc6f94"
                           "6:status"
                           "l"
                           "4:done"
                           "e"
                           "e"))
  # =>
  {:id "1"
   :new-session "4ca0256c-606f-47ec-9534-06eeaa3227f0"
   :session "fabb7627-45d3-46a8-8804-7a8cd3fc6f94"
   :status ["done"]}

  )

(comment

  (def rdr
    (ben/reader (string "d"
                        "2:" "id"
                        "1:" "1"
                        "2:" "op"
                        "5:" "clone"
                        "e")))

  rdr
  # =>
  @{:buffer "d2:id1:12:op5:clonee"}

  (ben/read rdr)
  # =>
  {:id "1" :op "clone"}

  rdr
  # =>
  @{:buffer "d2:id1:12:op5:clonee" :index 19}

  (ben/read rdr)
  # =>
  nil

  rdr
  # =>
  @{:buffer "d2:id1:12:op5:clonee" :index 20}

  (def [ok? val] (protect (ben/read rdr)))

  [ok? val]
  # =>
  [false "Read past the end of the buffer"]

  )

(comment

  (def rdr (ben/reader (string "2:id" "1:1")))

  rdr
  # =>
  @{:buffer "2:id1:1"}

  (ben/read rdr)
  # =>
  "id"

  rdr
  # =>
  @{:buffer "2:id1:1" :index 3}

  (ben/read rdr)
  # =>
  "1"

  rdr
  # =>
  @{:buffer "2:id1:1" :index 6}

  (ben/read rdr)
  # =>
  nil

  rdr
  # =>
  @{:buffer "2:id1:1" :index 7}

  (def [ok? val] (protect (ben/read rdr)))

  [ok? val]
  # =>
  [false "Read past the end of the buffer"]

  )

(comment

  (ben/write {:id "1" :op "clone"})
  # =>
  (buffer "d"
          "2:id"
          "1:1"
          "2:op"
          "5:clone"
          "e")

  (ben/write {:id "1"
              :new-session "4ca0256c-606f-47ec-9534-06eeaa3227f0"
              :session "fabb7627-45d3-46a8-8804-7a8cd3fc6f94"
              :status ["done"]})
  # =>
  (buffer "d"
          "2:id" "1:1"
          "11:new-session" "36:4ca0256c-606f-47ec-9534-06eeaa3227f0"
          "7:session" "36:fabb7627-45d3-46a8-8804-7a8cd3fc6f94"
          "6:statusl4:doneee")

  )
