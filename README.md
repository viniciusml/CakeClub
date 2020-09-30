# **Cake Club**
![CI](https://github.com/viniciusml/CakeClub/workflows/CI/badge.svg)

Thank you for taking the time to review my code.

To run the code, simply unzip it and open in Xcode. It was developed using Xcode 11.7. There are 3 schemes in the project:

- CakeClub: where it's possible to run the unit tests for the app.
- CakeClubIntegrationTests: where it's possible to run the integration tests for the Network module.
- CI: where it's possible to run all the tests.

## **Goal**

> An application that displays a list of Cakes in a Table View.

> The list items should display cake name, description image.

> Unit tests were written in TDD methodology for the whole application.

> MVVM was used as design pattern for the UI module.

# **Story: Customer requests to see the cake list**

# **Narrative #1**

*As an online customer*

*I want the app to automatically load the cake list*

*So I can decide which cake I would like to try*

# **Scenarios (Acceptance criteria)**

***Given** the customer has connectivity*

***When** the customer requests to see the cake list*

***Then** the app should display the list retrieved from remote*

***Given** the customer doesn't have connectivity*

***When** the customer requests to see the cake list*

***Then** the app should display an error message*

# **Load List Use Case**

# **Data (Input):**

- URL

# **Primary course (happy path):**

1. Execute "Load Cake List command with above data.
2. System downloads data from the URL.
3. System validates downloaded data.
4. System creates items from valid data.
5. System delivers items.
6. Items are displayed on screen with animations.

# **Invalid data – error course (sad path):**

1. System delivers error.
2.  Error message is displayed on screen.

# **No connectivity – error course (sad path):**

1. System delivers error.
2. Error message is displayed on screen.

# **Load Cake Image Use Case**

# **Data (Input):**

- URL

# **Primary course (happy path):**

1. Execute "Load Image" command with above data.
2. System downloads data from the URL.
3. System validates downloaded data as image.
4. System delivers image.

# **Invalid data – error course (sad path):**

1. Placeholder image is presented

# **No connectivity – error course (sad path):**

1. Placeholder image is presented
