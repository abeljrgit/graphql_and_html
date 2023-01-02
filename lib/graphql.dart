class GraphQLQuery {
  static const getPosts = '''
    query getPosts{
      posts {
        edges {
          node {
            title
            content
            featuredImage {
              node {
                mediaItemUrl
              }
            }
            categories {
              edges {
                node {
                  name
                }
              }
            }
            tags {
              edges {
                node {
                  name
                }
              }
            }
          }
        }
      }
    }
''';
}
