Feature: API Access Control Layer
    Scenario: Admin can add a post to a set
        Given that I want to make a new "Post"
        And that the request "Authorization" header is "Bearer testadminuser"
        And that the request "data" is:
            """
            {
                "id":1
            }
            """
        When I request "/sets/1/posts/"
        Then the response is JSON
        And the response has a "id" property
        And the type of the "id" property is "numeric"
        And the "id" property equals "1"
        Then the guzzle status code should be 200

    @resetFixture
    Scenario: User can view public and own private posts in a set
        Given that I want to get all "Posts"
        And that the request "Authorization" header is "Bearer testbasicuser"
        And that the request "query string" is "status=all"
        When I request "/sets/1/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the response has a "count" property
        And the type of the "count" property is "numeric"
        And the "count" property equals "4"

    @resetFixture
    Scenario: All users can view public posts in a set
        Given that I want to get all "Posts"
        And that the request "Authorization" header is "Bearer testbasicuser2"
        And that the request "query string" is "status=all"
        When I request "/sets/1/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the response has a "count" property
        And the type of the "count" property is "numeric"
        And the "count" property equals "2"

    @resetFixture
    Scenario: Admin user all posts in a set
        Given that I want to get all "Posts"
        And that the request "Authorization" header is "Bearer testadminuser"
        And that the request "query string" is "status=all"
        When I request "/sets/1/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the response has a "count" property
        And the type of the "count" property is "numeric"
        And the "count" property equals "6"

    Scenario: Anonymous user can access public posts
        Given that I want to get all "Posts"
        And that the request "Authorization" header is "Bearer testanon"
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the "count" property equals "10"

    Scenario: All users can view public posts
        Given that I want to get all "Posts"
        And that the request "Authorization" header is "Bearer testbasicuser2"
        And that the request "query string" is "status=all"
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the "count" property equals "10"

    Scenario: User can view public and own private posts in collection
        Given that I want to get all "Posts"
        And that the request "Authorization" header is "Bearer testbasicuser"
        And that the request "query string" is "status=all"
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the "count" property equals "12"

    Scenario: Admin can view all posts in collection
        Given that I want to get all "Posts"
        And that the request "Authorization" header is "Bearer testadminuser"
        And that the request "query string" is "status=all"
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the "count" property equals "15"

    Scenario: Admin user can view private posts
        Given that I want to find a "Post"
        And that its "id" is "111"
        And that the request "Authorization" header is "Bearer testadminuser"
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the response has an "id" property

    Scenario: User can view their own private posts
        Given that I want to find a "Post"
        And that its "id" is "111"
        And that the request "Authorization" header is "Bearer testbasicuser"
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the response has an "id" property

    Scenario: Users can not view private posts
        Given that I want to find a "Post"
        And that its "id" is "111"
        And that the request "Authorization" header is "Bearer testbasicuser2"
        When I request "/posts"
        Then the guzzle status code should be 403
        And the response is JSON
        And the response has an "errors" property

    Scenario: Users can edit their own posts
        Given that I want to update a "Post"
        And that its "id" is "110"
        And that the request "Authorization" header is "Bearer testbasicuser"
        And that the request "data" is:
        """
        {
            "form_id": 1,
            "title": "Test editing own post",
            "description": "testing post for oauth",
            "status": "published",
            "locale": "en_us"
        }
        """
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the response has an "id" property

    Scenario: Anonymous users can create posts
        Given that I want to make a new "Post"
        And that the request "Authorization" header is "Bearer testanon"
        And that the request "data" is:
        """
        {
            "form_id": 1,
            "title": "Test creating anonymous post",
            "description": "testing post for oauth",
            "status": "published",
            "locale": "en_us"
        }
        """
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response is JSON
        And the response has an "id" property

    Scenario: Anonymous users can not edit posts
        Given that I want to update a "Post"
        And that the request "Authorization" header is "Bearer testanon"
        And that its "id" is "110"
        And that the request "data" is:
        """
        {
            "form_id": 1,
            "title": "Test post",
            "description": "testing post for oauth",
            "status": "published"
        }
        """
        When I request "/posts"
        Then the guzzle status code should be 403

    Scenario: Anonymous users can not view private posts
        Given that I want to find a "Post"
        And that the request "Authorization" header is "Bearer testanon"
        And that its "id" is "111"
        When I request "/posts"
        Then the guzzle status code should be 403

    Scenario: Anonymous users can view public post
        Given that I want to find a "Post"
        And that the request "Authorization" header is "Bearer testanon"
        And that its "id" is "110"
        When I request "/posts"
        Then the guzzle status code should be 200
        And the response has an "id" property

    Scenario: Anonymous user can not access updates with private parent post
        Given that I want to get all "Updates"
        And that the request "Authorization" header is "Bearer testanon"
        When I request "/posts/111/updates"
        Then the guzzle status code should be 403

    Scenario: Anonymous user can not access update with private parent post
        Given that I want to find an "Update"
        And that the request "Authorization" header is "Bearer testanon"
        And that its "id" is "114"
        When I request "/posts/111/updates"
        Then the guzzle status code should be 403

    Scenario: User user can access update to their own private parent post
        Given that I want to find an "Update"
        And that the request "Authorization" header is "Bearer testbasicuser"
        And that its "id" is "114"
        When I request "/posts/111/updates"
        Then the guzzle status code should be 200

    Scenario: User user can not access update with private parent post
        Given that I want to find an "Update"
        And that the request "Authorization" header is "Bearer testbasicuser2"
        And that its "id" is "114"
        When I request "/posts/111/updates"
        Then the guzzle status code should be 403

    Scenario: Anonymous user can not access translations with private parent post
        Given that I want to get all "Translations"
        And that the request "Authorization" header is "Bearer testanon"
        When I request "/posts/111/translations"
        Then the guzzle status code should be 403

    Scenario: Anonymous user can not access translation with private parent post
        Given that I want to find a "Translation"
        And that the request "Authorization" header is "Bearer testanon"
        And that its "id" is "115"
        When I request "/posts/111/translations"
        Then the guzzle status code should be 403

    Scenario: Anonymous user can not access revisions with private parent post
        Given that I want to get all "Revisions"
        And that the request "Authorization" header is "Bearer testanon"
        When I request "/posts/111/revisions"
        Then the guzzle status code should be 403

    Scenario: Anonymous user can not access revision with private parent post
        Given that I want to find a "Revision"
        And that the request "Authorization" header is "Bearer testanon"
        And that its "id" is "116"
        When I request "/posts/111/revisions"
        Then the guzzle status code should be 403

    Scenario: Anonymous user can not access private update in listing
        Given that I want to get all "Updates"
        And that the request "Authorization" header is "Bearer testanon"
        When I request "/posts/110/updates"
        Then the guzzle status code should be 200
        And the "count" property equals "0"

    Scenario: Anonymous user can not access private update
        Given that I want to find an "Update"
        And that the request "Authorization" header is "Bearer testanon"
        And that its "id" is "117"
        When I request "/posts/110/updates"
        Then the guzzle status code should be 403
