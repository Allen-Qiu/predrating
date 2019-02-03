# predrating
A project for predicting ratings of English reviews.

The steps for building a predictive model are listed as follows.

1. running dataset/datasetGenerateor.java
update table "termpairs"  and build dictionary from table "reviews" in database.

2. dataset/selector.java select termpairs based on frequence and then output the result into a file
termpair.txt, terms.txt and dictionarys in folder 'dic'.

3. model/test.java train models from files of termpair.txt and terms.txt. it will generate two files:
global-lamda-polarity.out
global-mu-polarity.out

4. GenerateVector.java uses global-lamda-polarity.out and global-mu-polarity.out
to convert termpairs.txt to vectors that CLM need. Obtain the file of vector.txt

5. Using rating-predict.r to train a predictive model based on vector.txt.
The parameters of the predictive model are put in the file clm.properties.

6. qjt.predrating/Test.java give examples for predicting the ratings using the model.

PS: DatasetGenerator.java needs a database that store original data and middle results.
The name of the database need be set in globalVars.properties. the database should contain:
(1) the table of 'reviews' stores original reviews. It has fields: rid (id of reviews), stars (the ratings of stars), and rtext (reviews).
(2) the table of 'termpairs' stores middle results. It has fields:
rid(corresponding to id in 'reviews'),stars (corresponding to 'stars' in 'reviews'),
comment(term-pairs)


