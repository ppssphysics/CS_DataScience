

Coursera Data Science Capstone
========================================================
author: Pierre Saouter	
date: 11/28/2017
css: rpres_customcss.css
font-family: 'Helvetica'
autosize: true
width: 960
height: 700


<span style="font-weight:bold;font-size:50px">[#GetYourNextWordPredicted](https://thachtranerc.wordpress.com/2016/04/12/katzs-backoff-model-implementation-in-r/)</span>
is an <span style="font-weight:bold;font-size:40px">interactive</span> dashboard that <span style="font-weight:bold;font-size:60px;color:red">predicts</span> the next <span style="font-weight:bold;font-size:40px">most probable</span> <span style="font-weight:bold;font-size:50px;color:green">word</span> a user <span style="font-weight:bold;font-size:40px">intends</span> to <span style="font-weight:bold;font-size:50px">write</span>

<span class="specialsubtype">
The application runs on a public Shiny server at the link below:<br>
[https://datasciencebackwords.shinyapps.io/GetYourNextWordPredicted/](https://datasciencebackwords.shinyapps.io/GetYourNextWordPredicted/)<br>
The R code used to build the app is available here:<br>
[https://github.com/ppssphysics](https://github.com/ppssphysics)
</span>


Introduction to the Project
========================================================

Before proposing an interactive application to the user, a number of steps have been followed:

<span class="specialitems"> 1. Data preparation </span>
<br>
<span style="font-size:20px">
Exploration and cleaning of available sources of texts in order to built frequency table of most probable combinations of 1,2,3,4 and 5 words, so-called ngrams. Available corpus of texts were of three types: news, blogs and twitter posts.
</span>

<span class="specialitems">  2. Building a prediction algorithm </span>
<br>
<span style="font-size:20px">
Development of a prediction algorithm based on text searching functionalities in the ngram tables and calculation of associated probabilities. The algorithm is built to return a prediction even if an exact match of the text input by the user is not found.
</span>

<span class="specialitems"> 3. Building a shiny application </span>
<br>
<span style="font-size:20px">
Development of a responsive and engaging application for word prediction available to any user. The application focuses on being fast and responsive, therefore allowing for a compromise to lower prediction accuracy.
</span>



Data preparation
========================================================

<span style="font-size:20px">
Due to limited computing ressources, a pre-scaling factor of roughly 99% is applied to the available corpus of texts before building the ngrams (random re-sampling to minimize bias).Text mining applied: all characters to lower case, removing punctuation/numbers, urls, subsitution of few abreviations by a word (twitter content). All details can be found [here](http://rpubs.com/ppss85/324013).<br><br>
Ngrams built up to the fifth order and we results studied by text source type to search for any strong specificities that could lead to biases in the prediction (see right plots comparing results of word frequencies for unigrams when including or not stopwords).
</span>
***
![alt text](images/unigramexamples.png)


Building a prediction algorithm
========================================================

<span class="specialitems">  Based on a user's text input, the prediction works as follows:</span>
<br>
<span style="font-size:20px";color:green>
1. The text input is run through the same text cleaning process as for building the ngrams<br>
2. The words are matched against all word combinations available in the ngrams (exact and partial matches returned) <br>
3. A matching score for the next word inferred from each combination to be the next one is calculated <br>
4. The next word associated to the combination with highest match score is returned
</span>

<span style="font-size:20px">
The <b>matching score</b> is calculated by using a given combination's probability in the ngram, the frequency of a given word prediction accross all combinations and the number of words from the input matched. The probability calculation was inspired by Katz's Backoff [model](
https://thachtranerc.wordpress.com/2016/04/12/katzs-backoff-model-implementation-in-r/) but eventually become a custom calculation. A proper implentation of Katz's Backoff model or the use of Kneser-Ney technique seem natural steps going further.
</span>

<span style="font-size:20px;color:red">
At this time, the algorithm is found to under-perform with a predication accuracy estimated to be around 48% to 60%. This seems to be largely attributable to low quality ngrams (in terms of completeness/representativeness) rather than due to the matching score.
</span>

Shiny application and future prospects
========================================================

<img src="images/Dashboard.PNG" style="background-color:transparent; border:0px; box-shadow:none;"></img><br>
<span style="font-size:20px">
The [online application](https://datasciencebackwords.shinyapps.io/GetYourNextWordPredicted/) was built with a strong focus
on making the product as user friendly as possible (this includes fast reactiveness and responsiveness) while offering a possiblity for the user to see the prediction model work in real time (display of probability tables). </span> <span style="font-size:20px;text-decoration: underline"> The user only has to input text in the white input bar.</span><br><br>
<span style="font-size:20px">
With the framework of the application in place, the biggest area of improvement lies in building more complete ngrams tables as the prediction is under-performing at this time. I am sure that working in your company and benefiting from your infrastructures and expertise would allow to scale this product to a whole other perspective.
</span><br>
<span style="font-size:15px">
*The application proposes a Information icon on the top-right corner that provides the user with additional information on the functionning of the application.
</span>
