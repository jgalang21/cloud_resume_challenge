# Cloud Resume hosted on AWS S3
![image](https://github.com/user-attachments/assets/169b8ac8-7f6d-42d1-b498-39851bc2b958)



# Key Accomplishments
* Created simple HTML/CSS Website to showcase a simple static page to host on an S3 bucket.
* Bought a domain jjgalang.com on Route 53 and learned how to set permissions and redirect requests (i.e. wwww.jjgalang.com and jjgalang.com should be the same result!).
* Created a simple JavaScript function that tracks the number of visitors on the frontend.
* Created an API Gateway so the function can post to it every time a visitor visits the page.
* The API Gateway executes a Lambda function, which increments a row on the DynamoDB table. This tracks the number of visitors!

You can visit my cloud resume website [here!](http://jjgalang.com)
