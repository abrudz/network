def convert(imgf, outf, n):
    f = open(imgf, "rb")
    o = open(outf, "w")

    f.read(16)
    images = []

    for i in range(n):
        image = []
        for j in range(28*28):
            image.append(ord(f.read(1))/255)
        images.append(image)

    for image in images:
        o.write(",".join(str(pix) for pix in image)+"\n")
    f.close()
    o.close()

def convert_label (labelf, outf, n):
    l = open(labelf,"rb")
    o = open(outf, "w")

    l.read(8)
    labels = []
    for i in range(n):
        labels.append(ord(l.read(1)))

    o.write(','.join(str(a) for a in labels))


convert("train-images-idx3-ubyte", "mnist_train_images.csv", 60000)
convert_label("train-labels-idx1-ubyte", "mnist_train_labels.csv", 60000)
convert("t10k-images-idx3-ubyte", "mnist_test_images.csv", 10000)
convert_label("t10k-labels-idx1-ubyte","mnist_test_labels.csv",10000)
