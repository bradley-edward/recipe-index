Map<String,Map<String,Map<String,String>>> tableAttributesMap = {
  'recipes': {
    'id': {
      'type': 'INTEGER',
      'other_keywords': 'PRIMARY KEY AUTOINCREMENT NOT NULL',
    },
    'displayId': {
      'type': 'TEXT',
    },
    'name': {
      'type': 'TEXT',
    },
    'complexity': {
      'type': 'INTEGER',
    },
    'difficulty': {
      'type': 'INTEGER',
    },
    'prepTime': {
      'type': 'INTEGER',
    },
    'cookingTime': {
      'type': 'INTEGER',
    },
    'additionalTime': {
      'type': 'INTEGER',
      'other_keywords': 'DEFAULT 0'
    },
    'servings': {
      'type': 'TEXT',
    },
    'rating': {
      'type': 'REAL',
    },
    'notes': {
      'type': 'TEXT',
    },
    'timestampCreate': {
      'type': 'TEXT',
    },
    'timestampLastUpdate': {
      'type': 'TEXT',
    },
    'timestampLastExport': {
      'type': 'TEXT',
    },
    'timestampLastImport': {
      'type': 'TEXT',
    },
  },
  'images': {
    'id': {
      'type': 'INTEGER',
      'other_keywords': 'PRIMARY KEY AUTOINCREMENT NOT NULL',
    },
    'listIndex': {
      'type': 'INTEGER',
    },
    'imageType': {
      'type': 'INTEGER',
    },
    'imageLocation': {
      'type': 'TEXT',
    },
    'ownerId': {
      'type': 'INTEGER',
      'other_keywords': 'NOT NULL',
    },
  },
  'tags': {
    'id': {
      'type': 'INTEGER',
      'other_keywords': 'PRIMARY KEY AUTOINCREMENT NOT NULL',
    },
    'name': {
      'type': 'TEXT',
    },
  },
  'mn_recipes_tags': {
    'recipeId': {
      'type': 'INTEGER',
      'other_keywords': 'NOT NULL',
    },
    'tagId': {
      'type': 'INTEGER',
      'other_keywords': 'NOT NULL',
    },
  }
};
