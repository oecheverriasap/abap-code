CLASS animal DEFINITION ABSTRACT.
    PUBLIC SECTION.
      METHODS: constructor IMPORTING i_name TYPE string i_breed TYPE string,
               get_name RETURNING VALUE(r_name) TYPE string,
               get_breed RETURNING VALUE(r_breed) TYPE string,
               makeSound ABSTRACT.
    PRIVATE SECTION.
      DATA: name TYPE string,
            breed TYPE string.
  ENDCLASS.
  
  CLASS animal IMPLEMENTATION.
    METHOD constructor.
      name = i_name.
      breed = i_breed.
    ENDMETHOD.
  
    METHOD get_name.
      r_name = name.
    ENDMETHOD.
  
    METHOD get_breed.
      r_breed = breed.
    ENDMETHOD.
  ENDCLASS.
  
  
  CLASS dog DEFINITION INHERITING FROM animal.
    PUBLIC SECTION.
      METHODS: makeSound REDEFINITION.
  ENDCLASS.
  
  CLASS dog IMPLEMENTATION.
    METHOD makeSound.
      WRITE: 'Woof!'.
    ENDMETHOD.
  ENDCLASS.
  
  
  CLASS cat DEFINITION INHERITING FROM animal.
    PUBLIC SECTION.
      METHODS: makeSound REDEFINITION.
  ENDCLASS.
  
  CLASS cat IMPLEMENTATION.
    METHOD makeSound.
      WRITE: 'Meow!'.
    ENDMETHOD.
  ENDCLASS.
  
  
  START-OF-SELECTION.
    DATA: my_dog TYPE REF TO dog,
          my_cat TYPE REF TO cat.
  
    CREATE OBJECT my_dog
      EXPORTING
        i_name = 'Buddy'
        i_breed = 'Labrador'.
  
    CREATE OBJECT my_cat
      EXPORTING
        i_name = 'Whiskers'
        i_breed = 'Siamese'.
  
    WRITE: 'My dog ', my_dog->get_name( ), ' (', my_dog->get_breed( ), ') says: '.
    CALL METHOD my_dog->makeSound( ).
    WRITE: / 'My cat ', my_cat->get_name( ), ' (', my_cat->get_breed( ), ') says: '.
    CALL METHOD my_cat->makeSound( ).
  