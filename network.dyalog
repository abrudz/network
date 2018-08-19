:Namespace Network
        ∇ weights←network BackProp(input target batch_size);S;ff;eta;res;e;∆weights
          S←{⍵×1-⍵} ⍝ S'(x) where ⍵=S(x)
          ff←{⊃{(⊂Sigmoid ((⊃⍵),1)+.×⍺),⍵}/⌽(⊂⊂⍺), ⊆⍵}
          eta←3 ⍝ learning rate
          res←input ff network
          e←target-⊃res
          res←(⊂e) ((⊣×S)@1) res
          res←⌽(⌽network,⊂⍬){⍺{⍵⍺}¨⍵}res
          ∆weights←¯1↓1↓⊃{∆o←⊃⍵ ⋄l w←⍺ ⋄ ∆w←(⍉l,1)+.×∆o ⋄ ((0 ¯1↓⊢(S (l,1))×∆o+.×⍉w) ∆w),1↓⍵}/res
          weights←network+eta×∆weights÷batch_size
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
                  temp←⊃⊃{net input target←⍵⋄(⊂net BackProp (↑input) (↑target) batch_size),⍺}/⌽mini_batches
                  ⎕←('new ephoch: ',⍕test temp),'/10000'
                  temp
          }⍣epochs⊣network
        ∇
        ∇ net←Run
          inputs←trainImages
          targets←trainLabels
          net←inputs SGD targets
        ∇
        trainImages←↓60000 784⍴255÷⍨255|⎕NREAD ('/home/joe/network/train-images-idx3-ubyte' ⎕NTIE 0) 83 ¯1 16
        trainLabels←{⍵=⊂-1-⍳10}⎕NREAD ('/home/joe/network/train-labels-idx1-ubyte' ⎕NTIE 0) 83 ¯1 8
        testImages←10000 784⍴255÷⍨255|⎕NREAD ('/home/joe/network/t10k-images-idx3-ubyte' ⎕NTIE 0) 83 ¯1 16
        testLabels←⎕NREAD ('/home/joe/network/t10k-labels-idx1-ubyte' ⎕NTIE 0) 83 ¯1 8
        ⎕NUNTIE - 1 2 3 4
        feedforward←{⊃{Sigmoid (⍵,1)+.×⍺}/⌽(⊂⍺), ⊆⍵}
        classify←{{-1-⍵⍳⌈/⍵}⍤1⊢⍺ feedforward ⍵}
        test←{+/∊testLabels = (testImages) classify ⍵}
:EndNamespace
