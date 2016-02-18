# tliaa
true love is an algorithm - dating recommender system

in stat 640 (data mining and statistical learning, taught by [dr. allen](http://www.stat.rice.edu/~gallen/), a grad student under the statistical learning godfather [himself](http://statweb.stanford.edu/~tibs/)) we had a [class project](https://inclass.kaggle.com/c/rice-stat-640-444) to build a recommender system based on a users rating history of other profiles.  there was no 'fun' information like [whether users like the taste of beer](http://blog.okcupid.com/index.php/the-best-questions-for-first-dates/), simply gender and their rating history.

spoiler alert: our two man team, true love is an algorithm, did not win.

but - we did earn an 'honorable mention' for our innovative idea, a _conditional_ knn.  the data provided was sparse , ~3% coverage in a 10,000 user by 10,000 profile matrix.  knn seemed to be doomed ([curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality?oldformat=true)).  instead of running a knn for a user-profile pair, we would run a knn algorithm to find similar users _given they had rated the profile we were trying to rate_.

with one of the simplest statistical learning algorithms, we were able to provide a significantly lower root mean squared error (rmse) for males than most other groups (this didn't help in the competetion, given that majority of users were female).

the code provided is not quickly executable (generating a cosine matrix for 10,000 users is over a gig, even as .rdata) but gives you a sense of our logic in developing an algorithm.

