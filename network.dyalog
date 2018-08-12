:Namespace Network
        ∇ weights←network BackProp(input target)
          S←{⍵×1-⍵} ⍝ S'(x) where ⍵=S(x)
          ff←{⊃{l←⊃⍵⋄n←+⌿(l,1)×[1]⍺⋄(⊂Sigmoid n),⍵}/⌽(⊂⊂⍺), ⊆⍵} ⍝ FeedForward that keeps track of state
          eta←3 ⍝ learning rate
          weights←{w←⍵⋄⍵+eta×¯1↓⊃(+/÷≢) input {res←⍺ ff w
                   e←⍵-⊃res
                   etotal←+/{.5××⍨⍵}e
                   res←e{r←⍵⋄r[1]←(⊂⍺)×S r[1]⋄r}res
                   res←⌽(⌽w,⊂⍬){⍺{⍵⍺}¨⍵}res
                   1↓⊃{∆o←⊃⍵⋄l w←⍺⋄∆w←↑(l,1)×¨⊂∆o⋄((¯1↓+/(S (l,1))×[1]∆o×[2] w) ∆w), 1↓⍵}/ res}¨ target} network
        ∇
        Sigmoid←{÷1+*-⍵}
        shuffle_perm ← ?⍨≢
        ∇ network←inputs SGD targets
          network_shape←784 30 10
          network←{{2×.5-?0⍴⍨(1+⍺)⍵}/⍵}⌺2⊣ network_shape
          epochs←10
          batch_size←20
          input_length←≢inputs
          n←⌊input_length÷batch_size
          network←{
                  perm←shuffle_perm inputs
                  mini_inputs←↓n batch_size⍴inputs[perm]
                  mini_targets←↓n batch_size⍴targets[perm]
                  mini_batches←mini_inputs{⍺⍵}¨mini_targets
                  mini_batches[1]←⊂(⊂⍵),⊃mini_batches
                  temp←⊃⊃{net input target←⍵⋄(⊂net BackProp input target),⍺}/⌽mini_batches
                  ⎕←('new ephoch: ',⍕test temp),'/10000'
                  temp
          }⍣epochs⊣network
        ∇
        ∇ net←Run
          inputs←image_csv
          targets←target_csv
          net←inputs SGD targets
        ∇
        image_csv←↓⎕CSV '/home/joe/mnist/mnist_train_images.csv' '' 3
        target_csv←{⍵=-1-⍳10}¨∊⎕CSV '/home/joe/mnist/mnist_train_labels.csv' '' 3
        image_test_csv←↓⎕CSV '/home/joe/mnist/mnist_test_images.csv' '' 3
        target_test_csv←∊⎕CSV '/home/joe/mnist/mnist_test_labels.csv' '' 3
        feedforward←{⊃{Sigmoid+⌿(⍵,1)×[1]⍺}/⌽(⊂⍺), (⊆⍵)}
        classify←{{-1-⍵⍳⌈/⍵}⍺ feedforward ⍵}
        test←{+/∊target_test_csv = image_test_csv classify¨ ⊂⍵}
:EndNamespace
